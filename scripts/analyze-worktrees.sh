#!/bin/bash

################################################################################
# Git Worktree Analyzer
# Analyzes all git worktrees and displays their merge status, GitHub PR status,
# and provides cleanup recommendations.
# This script is read-only and performs no destructive actions.
################################################################################

GREEN='\033[0;32m'
YELLOW='\033[1;33m'
RED='\033[0;31m'
BLUE='\033[0;34m'
CYAN='\033[0;36m'
BOLD='\033[1m'
DIM='\033[2m'
RESET='\033[0m'

SHOW_SAFE=true
SHOW_ATTENTION=true
SHOW_KEEP=true
USE_COLOR=true
VERBOSE=false
NO_INTERACTIVE=false

BASE_BRANCH_OVERRIDE=""
REPO_REMOTE_OVERRIDE=""

declare -a WORKTREES
declare -A WT_BRANCH
declare -A WT_PR_STATUS
declare -A WT_PR_NUMBER
declare -A WT_PR_TITLE
declare -A WT_COMMIT_DATE
declare -A WT_COMMIT_MSG
declare -A WT_BEHIND
declare -A WT_AHEAD
declare -A WT_CATEGORY

TOTAL_COUNT=0
SAFE_COUNT=0
ATTENTION_COUNT=0
KEEP_COUNT=0

REPO_DIR=""
BASE_BRANCH=""
REPO_REMOTE=""

################################################################################
# Utility Functions
################################################################################

print_color() {
    local color=$1
    shift
    if [[ "$USE_COLOR" == "true" ]]; then
        echo -e "${color}$@${RESET}"
    else
        echo "$@"
    fi
}

show_help() {
    cat <<EOF
Usage: $0 [options]

Analyzes all git worktrees and displays a detailed report.

Options:
  --all                  Show all categories (default)
  --safe-to-delete       Show only worktrees that can be safely deleted
  --need-attention       Show only worktrees that need attention
  --keep                 Show only worktrees to keep
  --base-branch <name>   Override auto-detected base branch
  --repo <owner/name>    Override auto-detected GitHub repository
  --no-color            Disable colored output
  --no-interactive      Skip interactive cleanup prompt
  --verbose             Enable verbose output for debugging
  --help                Display this help message

Categories:
  🟢 SAFE TO DELETE      : PR merged on GitHub
  🟡 NEEDS ATTENTION     : PR closed without merge or no PR found
  🔴 KEEP                : PR open (work in progress)

Note: This script can optionally remove SAFE worktrees after interactive confirmation.

EOF
    exit 0
}

parse_args() {
    while [[ $# -gt 0 ]]; do
        case $1 in
        --safe-to-delete)
            SHOW_SAFE=true
            SHOW_ATTENTION=false
            SHOW_KEEP=false
            shift
            ;;
        --need-attention)
            SHOW_SAFE=false
            SHOW_ATTENTION=true
            SHOW_KEEP=false
            shift
            ;;
        --keep)
            SHOW_SAFE=false
            SHOW_ATTENTION=false
            SHOW_KEEP=true
            shift
            ;;
        --all)
            SHOW_SAFE=true
            SHOW_ATTENTION=true
            SHOW_KEEP=true
            shift
            ;;
        --base-branch)
            if [[ -z "$2" ]]; then
                echo "❌ Error: --base-branch requires a branch name"
                exit 1
            fi
            BASE_BRANCH_OVERRIDE="$2"
            shift 2
            ;;
        --repo)
            if [[ -z "$2" ]]; then
                echo "❌ Error: --repo requires owner/repo format"
                exit 1
            fi
            REPO_REMOTE_OVERRIDE="$2"
            shift 2
            ;;
        --no-color)
            USE_COLOR=false
            shift
            ;;
        --no-interactive)
            NO_INTERACTIVE=true
            shift
            ;;
        --verbose)
            VERBOSE=true
            shift
            ;;
        --help | -h)
            show_help
            ;;
        *)
            echo "Unknown option: $1"
            echo "Use --help to see available options"
            exit 1
            ;;
        esac
    done
}

################################################################################
# Configuration Detection
################################################################################

detect_configuration() {
    REPO_DIR=$(git rev-parse --show-toplevel 2>/dev/null)
    if [[ -z "$REPO_DIR" ]]; then
        echo "❌ Error: This script must be run from within a git repository"
        echo "   Run 'git init' or navigate to a git repository"
        exit 1
    fi

    local remote_url=$(git -C "$REPO_DIR" remote get-url origin 2>/dev/null)
    if [[ -z "$remote_url" ]]; then
        echo "❌ Error: No git remote 'origin' found"
        echo "   Add a remote with: git remote add origin <url>"
        exit 1
    fi

    if [[ -n "$REPO_REMOTE_OVERRIDE" ]]; then
        REPO_REMOTE="$REPO_REMOTE_OVERRIDE"
    else
        REPO_REMOTE=$(echo "$remote_url" | sed -E 's#.*github\.com[:/]([^/]+/[^/]+)(\.git)?$#\1#' | sed 's/\.git$//')
    fi

    if [[ -z "$REPO_REMOTE" ]] || [[ ! "$REPO_REMOTE" =~ / ]]; then
        echo "❌ Error: Remote 'origin' is not a GitHub repository"
        echo "   Detected remote: $remote_url"
        echo "   This script only supports GitHub repositories"
        echo ""
        echo "   If this is a GitHub repo, use --repo owner/name to specify manually"
        exit 1
    fi

    if [[ -n "$BASE_BRANCH_OVERRIDE" ]]; then
        BASE_BRANCH="$BASE_BRANCH_OVERRIDE"
    else
        for branch in development main master; do
            if git -C "$REPO_DIR" show-ref --verify --quiet refs/heads/$branch; then
                BASE_BRANCH="$branch"
                break
            fi
        done

        if [[ -z "$BASE_BRANCH" ]]; then
            BASE_BRANCH=$(git -C "$REPO_DIR" symbolic-ref refs/remotes/origin/HEAD 2>/dev/null |
                sed 's@^refs/remotes/origin/@@')
        fi

        if [[ -z "$BASE_BRANCH" ]]; then
            echo "❌ Error: Unable to auto-detect main branch"
            echo "   Available branches:"
            git -C "$REPO_DIR" branch -a | head -10
            echo ""
            echo "   Use --base-branch <name> to specify manually"
            exit 1
        fi
    fi
}

check_prerequisites() {
    if ! command -v git &>/dev/null; then
        echo "❌ Error: git is not installed"
        exit 1
    fi

    if ! command -v gh &>/dev/null; then
        echo "❌ Error: github-cli (gh) is not installed"
        echo "   Install from: https://cli.github.com/"
        exit 1
    fi
}

################################################################################
# Data Collection Functions
################################################################################

get_pr_status() {
    local branch=$1
    local result

    result=$(timeout 10 gh pr list --repo "$REPO_REMOTE" --head "$branch" --state all --json number,state,title --limit 1 2>/dev/null)

    if [[ $? -ne 0 ]] || [[ -z "$result" ]] || [[ "$result" == "[]" ]]; then
        echo "NO_PR|||"
        return
    fi

    local number=$(echo "$result" | grep -o '"number":[0-9]*' | head -1 | cut -d':' -f2)
    local state=$(echo "$result" | grep -o '"state":"[^"]*"' | head -1 | cut -d'"' -f4)
    local title=$(echo "$result" | grep -o '"title":"[^"]*"' | head -1 | cut -d'"' -f4)

    echo "${state}|${number}|${title}"
}

get_commit_info() {
    local wt_path=$1
    git -C "$wt_path" log -1 --format="%cd|%s" --date=short 2>/dev/null || echo "N/A|N/A"
}

get_commit_count() {
    local wt_path=$1
    local counts

    counts=$(git -C "$wt_path" rev-list --left-right --count "$BASE_BRANCH"...HEAD 2>/dev/null)

    if [[ $? -eq 0 ]]; then
        echo "$counts"
    else
        echo "0 0"
    fi
}

categorize_worktree() {
    local pr_status=$1

    case "$pr_status" in
    MERGED)
        echo "SAFE"
        ;;
    OPEN)
        echo "KEEP"
        ;;
    CLOSED | NO_PR)
        echo "ATTENTION"
        ;;
    *)
        echo "ATTENTION"
        ;;
    esac
}

################################################################################
# Main Analysis
################################################################################

analyze_worktrees() {
    print_color "$BLUE" "╔══════════════════════════════════════════════════════════════════════════════╗"
    print_color "$BLUE" "║ 🔍 DETECTED CONFIGURATION                                                    ║"
    print_color "$BLUE" "╚══════════════════════════════════════════════════════════════════════════════╝"
    echo ""
    print_color "$CYAN" "  📁 Repository        : $REPO_DIR"
    print_color "$CYAN" "  🌐 GitHub Remote     : $REPO_REMOTE"
    print_color "$CYAN" "  🌿 Reference Branch  : $BASE_BRANCH"
    echo ""

    local worktree_list=$(git -C "$REPO_DIR" worktree list --porcelain)
    local main_worktree=$(git -C "$REPO_DIR" worktree list | head -1 | awk '{print $1}')

    local current_path=""
    local is_detached=false

    while IFS= read -r line; do
        if [[ "$line" =~ ^worktree\ (.+)$ ]]; then
            current_path="${BASH_REMATCH[1]}"
            is_detached=false
        elif [[ "$line" =~ ^branch\ refs/heads/(.+)$ ]]; then
            if [[ "$current_path" != "$main_worktree" ]]; then
                WORKTREES+=("$current_path")
            fi
        elif [[ "$line" =~ ^detached$ ]]; then
            is_detached=true
            if [[ "$current_path" != "$main_worktree" ]]; then
                WORKTREES+=("$current_path")
            fi
        fi
    done <<<"$worktree_list"

    TOTAL_COUNT=${#WORKTREES[@]}
    if [[ "$TOTAL_COUNT" -eq 0 ]]; then
        echo "❌ No worktrees found to analyze"
        echo ""
        echo "   Detected worktrees:"
        git -C "$REPO_DIR" worktree list
        echo ""
        echo "   Note: Main worktree is excluded from analysis"
        exit 1
    fi

    print_color "$CYAN" "  📊 Worktrees Found   : $TOTAL_COUNT"
    echo ""
    print_color "$DIM" "⏳ Analysis in progress... (this may take several minutes)"
    echo ""

    local current=0
    for wt_path in "${WORKTREES[@]}"; do
        current=$((current + 1))
        local wt_name=$(basename "$wt_path")

        local progress=$((current * 100 / TOTAL_COUNT))
        local bar_length=30
        local filled=$((progress * bar_length / 100))
        local empty=$((bar_length - filled))

        local short_name="${wt_name:0:40}"

        printf "\r  Progress: ["
        [[ $filled -gt 0 ]] && printf '█%.0s' $(seq 1 $filled)
        [[ $empty -gt 0 ]] && printf '░%.0s' $(seq 1 $empty)
        printf "] %3d%% (%d/%d) - %-40s" "$progress" "$current" "$TOTAL_COUNT" "$short_name"

        if [[ "$VERBOSE" == "true" ]]; then
            echo ""
            echo "Analyzing $wt_name..."
        fi

        local branch=$(git -C "$wt_path" branch --show-current 2>/dev/null)
        if [[ -z "$branch" ]]; then
            branch="(detached HEAD)"
        fi
        WT_BRANCH[$wt_name]="$branch"

        local pr_info=$(get_pr_status "$branch")
        IFS='|' read -r pr_status pr_number pr_title <<<"$pr_info"
        WT_PR_STATUS[$wt_name]="$pr_status"
        WT_PR_NUMBER[$wt_name]="$pr_number"
        WT_PR_TITLE[$wt_name]="$pr_title"

        local commit_info=$(get_commit_info "$wt_path")
        IFS='|' read -r commit_date commit_msg <<<"$commit_info"
        WT_COMMIT_DATE[$wt_name]="$commit_date"
        WT_COMMIT_MSG[$wt_name]="$commit_msg"

        local counts=$(get_commit_count "$wt_path")
        read -r behind ahead <<<"$counts"
        WT_BEHIND[$wt_name]="$behind"
        WT_AHEAD[$wt_name]="$ahead"

        local category=$(categorize_worktree "$pr_status")
        WT_CATEGORY[$wt_name]="$category"

        case "$category" in
        SAFE) SAFE_COUNT=$((SAFE_COUNT + 1)) ;;
        ATTENTION) ATTENTION_COUNT=$((ATTENTION_COUNT + 1)) ;;
        KEEP) KEEP_COUNT=$((KEEP_COUNT + 1)) ;;
        esac
    done

    printf "\r%80s\r" " "

    print_color "$GREEN" "✅ Analysis complete!"
    echo ""
}

################################################################################
# Display Functions
################################################################################

display_header() {
    local current_date=$(date "+%Y-%m-%d %H:%M:%S")

    echo ""
    print_color "$BOLD$BLUE" "╔══════════════════════════════════════════════════════════════════════════════╗"
    print_color "$BOLD$BLUE" "║                        WORKTREE ANALYSIS REPORT                              ║"
    print_color "$BOLD$BLUE" "╚══════════════════════════════════════════════════════════════════════════════╝"
    echo ""
    print_color "$CYAN" "  Repository           : $REPO_REMOTE"
    print_color "$CYAN" "  Reference Branch     : $BASE_BRANCH"
    print_color "$CYAN" "  Analysis Date        : $current_date"
    print_color "$CYAN" "  Total Worktrees      : $TOTAL_COUNT"
    echo ""
}

display_worktree() {
    local wt_name=$1
    local branch="${WT_BRANCH[$wt_name]}"
    local pr_status="${WT_PR_STATUS[$wt_name]}"
    local pr_number="${WT_PR_NUMBER[$wt_name]}"
    local pr_title="${WT_PR_TITLE[$wt_name]}"
    local commit_date="${WT_COMMIT_DATE[$wt_name]}"
    local commit_msg="${WT_COMMIT_MSG[$wt_name]}"
    local behind="${WT_BEHIND[$wt_name]}"
    local ahead="${WT_AHEAD[$wt_name]}"

    echo "┌──────────────────────────────────────────────────────────────────────────────"
    print_color "$BOLD" "│ $wt_name"
    echo "├──────────────────────────────────────────────────────────────────────────────"

    printf "│ ${BOLD}Branch${RESET}        : %s\n" "$branch"

    if [[ "$pr_status" == "NO_PR" ]]; then
        print_color "$DIM" "│ Pull Request   : No PR found"
    else
        local pr_display="#$pr_number - $pr_status"
        if [[ -n "$pr_title" ]]; then
            pr_display="$pr_display - $pr_title"
        fi

        case "$pr_status" in
        MERGED)
            print_color "$GREEN" "│ Pull Request   : $pr_display"
            ;;
        OPEN)
            print_color "$YELLOW" "│ Pull Request   : $pr_display ⚠️"
            ;;
        CLOSED)
            print_color "$DIM" "│ Pull Request   : $pr_display"
            ;;
        esac
    fi

    local commit_status=""
    if [[ "$behind" -eq 0 ]] && [[ "$ahead" -eq 0 ]]; then
        commit_status="(up to date)"
    elif [[ "$behind" -gt 0 ]] && [[ "$ahead" -gt 0 ]]; then
        commit_status="(diverged)"
    elif [[ "$behind" -gt 0 ]]; then
        commit_status="(behind)"
    else
        commit_status="(ahead)"
    fi

    printf "│ Commits        : ← %s | → %s %s\n" "$behind" "$ahead" "$commit_status"
    printf "│ Last commit    : %s\n" "$commit_date"

    local short_msg="$commit_msg"
    if [[ ${#commit_msg} -gt 70 ]]; then
        short_msg="${commit_msg:0:67}..."
    fi
    printf "└─ Message        : %s\n" "$short_msg"

    echo ""
}

display_safe_to_delete() {
    if [[ "$SHOW_SAFE" != "true" ]] || [[ "$SAFE_COUNT" -eq 0 ]]; then
        return
    fi

    print_color "$BOLD$GREEN" "╔══════════════════════════════════════════════════════════════════════════════╗"
    print_color "$BOLD$GREEN" "║ 🟢 SAFE TO DELETE - $SAFE_COUNT worktree(s)                                  ║"
    print_color "$BOLD$GREEN" "╚══════════════════════════════════════════════════════════════════════════════╝"
    echo ""
    print_color "$DIM" "These worktrees have their PRs merged on GitHub."
    print_color "$DIM" "They can be safely removed."
    echo ""

    for wt_name in "${WORKTREES[@]}"; do
        local wt_basename=$(basename "$wt_name")
        if [[ "${WT_CATEGORY[$wt_basename]}" == "SAFE" ]]; then
            display_worktree "$wt_basename"
        fi
    done
}

display_need_attention() {
    if [[ "$SHOW_ATTENTION" != "true" ]] || [[ "$ATTENTION_COUNT" -eq 0 ]]; then
        return
    fi

    print_color "$BOLD$YELLOW" "╔══════════════════════════════════════════════════════════════════════════════╗"
    print_color "$BOLD$YELLOW" "║ 🟡 NEEDS ATTENTION - $ATTENTION_COUNT worktree(s)                            ║"
    print_color "$BOLD$YELLOW" "╚══════════════════════════════════════════════════════════════════════════════╝"
    echo ""
    print_color "$DIM" "These worktrees have PRs that were closed without merging, or have no PR at all."
    print_color "$DIM" "Review them to understand why before deciding to remove."
    echo ""

    for wt_name in "${WORKTREES[@]}"; do
        local wt_basename=$(basename "$wt_name")
        if [[ "${WT_CATEGORY[$wt_basename]}" == "ATTENTION" ]]; then
            display_worktree "$wt_basename"
        fi
    done
}

display_keep() {
    if [[ "$SHOW_KEEP" != "true" ]] || [[ "$KEEP_COUNT" -eq 0 ]]; then
        return
    fi

    print_color "$BOLD$RED" "╔══════════════════════════════════════════════════════════════════════════════╗"
    print_color "$BOLD$RED" "║ 🔴 KEEP - $KEEP_COUNT worktree(s)                                            ║"
    print_color "$BOLD$RED" "╚══════════════════════════════════════════════════════════════════════════════╝"
    echo ""
    print_color "$DIM" "These worktrees have open PRs on GitHub."
    print_color "$DIM" "They represent active work and should be kept."
    echo ""

    for wt_name in "${WORKTREES[@]}"; do
        local wt_basename=$(basename "$wt_name")
        if [[ "${WT_CATEGORY[$wt_basename]}" == "KEEP" ]]; then
            display_worktree "$wt_basename"
        fi
    done
}

display_summary() {
    local safe_percent=0
    local attention_percent=0
    local keep_percent=0

    if [[ "$TOTAL_COUNT" -gt 0 ]]; then
        safe_percent=$((SAFE_COUNT * 100 / TOTAL_COUNT))
        attention_percent=$((ATTENTION_COUNT * 100 / TOTAL_COUNT))
        keep_percent=$((KEEP_COUNT * 100 / TOTAL_COUNT))
    fi

    echo ""
    print_color "$BOLD$BLUE" "╔══════════════════════════════════════════════════════════════════════════════╗"
    print_color "$BOLD$BLUE" "║                                   SUMMARY                                    ║"
    print_color "$BOLD$BLUE" "╚══════════════════════════════════════════════════════════════════════════════╝"
    echo ""
    print_color "$BOLD" "📊 Worktree Distribution:"
    echo ""
    printf "   • Total analyzed           : %s\n" "$TOTAL_COUNT"
    print_color "$GREEN" "   • 🟢 Safe to delete        : $SAFE_COUNT ($safe_percent%)"
    print_color "$YELLOW" "   • 🟡 Needs attention       : $ATTENTION_COUNT ($attention_percent%)"
    print_color "$RED" "   • 🔴 Keep                  : $KEEP_COUNT ($keep_percent%)"
    echo ""

    if [[ "$SAFE_COUNT" -gt 0 ]]; then
        print_color "$BOLD$GREEN" "💾 Worktrees that can be safely removed:"
        echo ""

        local safe_list=()
        for wt_name in "${WORKTREES[@]}"; do
            local wt_basename=$(basename "$wt_name")
            if [[ "${WT_CATEGORY[$wt_basename]}" == "SAFE" ]]; then
                safe_list+=("$wt_basename")
            fi
        done

        local line=""
        for wt in "${safe_list[@]}"; do
            if [[ ${#line} -gt 60 ]]; then
                echo "   $line"
                line="$wt"
            else
                if [[ -z "$line" ]]; then
                    line="$wt"
                else
                    line="$line $wt"
                fi
            fi
        done
        if [[ -n "$line" ]]; then
            echo "   $line"
        fi
        echo ""
    fi

    print_color "$BOLD$CYAN" "⚠️  Recommendations:"
    echo ""

    if [[ "$ATTENTION_COUNT" -gt 0 ]]; then
        print_color "$YELLOW" "   • Review $ATTENTION_COUNT worktree(s) 🟡 to close/merge their PRs"
    fi

    if [[ "$SAFE_COUNT" -gt 0 ]]; then
        print_color "$GREEN" "   • $SAFE_COUNT worktree(s) 🟢 can be removed with:"
        echo "     git worktree remove <path>"
        echo ""
        print_color "$DIM" "     Example:"
        print_color "$DIM" "     cd $REPO_DIR && git worktree remove ../worktree-name"
    fi

    if [[ "$KEEP_COUNT" -gt 0 ]]; then
        print_color "$RED" "   • $KEEP_COUNT worktree(s) 🔴 contain unmerged work, keep them"
    fi

    echo ""
    print_color "$BOLD$BLUE" "══════════════════════════════════════════════════════════════════════════════"
    echo ""
}

remove_safe_worktrees() {
    if [[ "$SAFE_COUNT" -eq 0 ]] || [[ "$NO_INTERACTIVE" == "true" ]]; then
        return
    fi

    echo ""
    print_color "$BOLD$YELLOW" "╔══════════════════════════════════════════════════════════════════════════════╗"
    print_color "$BOLD$YELLOW" "║                           ⚠️  CLEANUP OPERATION                               ║"
    print_color "$BOLD$YELLOW" "╚══════════════════════════════════════════════════════════════════════════════╝"
    echo ""
    print_color "$DIM" "You can now remove all SAFE worktrees automatically."
    print_color "$DIM" "Only clean worktrees will be removed (git will refuse dirty ones)."
    echo ""

    read -p "Do you want to remove all $SAFE_COUNT SAFE worktree(s)? [y/N]: " -n 1 -r
    echo ""

    if [[ ! $REPLY =~ ^[Yy]$ ]]; then
        print_color "$CYAN" "Cleanup cancelled. No worktrees were removed."
        return
    fi

    echo ""
    print_color "$BOLD$GREEN" "Starting cleanup operation..."
    echo ""

    local removed_count=0
    local failed_count=0
    local failed_list=()
    local failed_reasons=()

    local safe_worktrees=()
    for wt_name in "${WORKTREES[@]}"; do
        local wt_basename=$(basename "$wt_name")
        if [[ "${WT_CATEGORY[$wt_basename]}" == "SAFE" ]]; then
            safe_worktrees+=("$wt_name")
        fi
    done

    local total=${#safe_worktrees[@]}
    local current=0

    for wt_path in "${safe_worktrees[@]}"; do
        current=$((current + 1))
        local wt_basename=$(basename "$wt_path")

        local progress=$((current * 100 / total))
        local bar_length=30
        local filled=$((progress * bar_length / 100))
        local empty=$((bar_length - filled))

        printf "\r  Progress: ["
        [[ $filled -gt 0 ]] && printf '█%.0s' $(seq 1 $filled)
        [[ $empty -gt 0 ]] && printf '░%.0s' $(seq 1 $empty)
        printf "] %3d%% (%d/%d)" "$progress" "$current" "$total"

        printf "\n  Removing: %-50s" "$wt_basename"

        local error_msg
        error_msg=$(git -C "$REPO_DIR" worktree remove "$wt_path" 2>&1)
        local exit_code=$?

        if [[ $exit_code -eq 0 ]]; then
            print_color "$GREEN" "✓ Success"
            removed_count=$((removed_count + 1))
        else
            print_color "$RED" "✗ Failed"
            failed_count=$((failed_count + 1))
            failed_list+=("$wt_basename")

            local clean_error=$(echo "$error_msg" | head -1 | sed 's/^fatal: //' | sed 's/^error: //')
            failed_reasons+=("$clean_error")
        fi
    done

    echo ""
    echo ""
    print_color "$BOLD$BLUE" "╔══════════════════════════════════════════════════════════════════════════════╗"
    print_color "$BOLD$BLUE" "║                              CLEANUP SUMMARY                                 ║"
    print_color "$BOLD$BLUE" "╚══════════════════════════════════════════════════════════════════════════════╝"
    echo ""

    if [[ "$removed_count" -gt 0 ]]; then
        print_color "$GREEN" "  ✓ Successfully removed : $removed_count worktree(s)"
    fi

    if [[ "$failed_count" -gt 0 ]]; then
        print_color "$RED" "  ✗ Failed to remove     : $failed_count worktree(s)"
    fi

    echo ""

    if [[ "$failed_count" -gt 0 ]]; then
        print_color "$BOLD$YELLOW" "Failed worktrees (require manual attention):"
        echo ""

        for i in "${!failed_list[@]}"; do
            local wt="${failed_list[$i]}"
            local reason="${failed_reasons[$i]}"

            printf "  ${BOLD}•${RESET} %s\n" "$wt"
            print_color "$DIM" "    └─ Reason: $reason"
        done

        echo ""
        print_color "$BOLD$CYAN" "💡 How to resolve:"
        echo ""
        print_color "$DIM" "  1. Check for uncommitted changes:"
        print_color "$CYAN" "     cd <worktree-path> && git status"
        echo ""
        print_color "$DIM" "  2. Commit or stash your changes, then remove:"
        print_color "$CYAN" "     cd $REPO_DIR && git worktree remove <worktree-name>"
        echo ""
        print_color "$DIM" "  3. Or force removal (⚠️  WILL LOSE ALL CHANGES):"
        print_color "$RED" "     cd $REPO_DIR && git worktree remove --force <worktree-name>"
        echo ""
    fi

    if [[ "$removed_count" -gt 0 ]]; then
        print_color "$BOLD$GREEN" "✅ Cleanup completed successfully!"

        if [[ "$failed_count" -eq 0 ]]; then
            print_color "$GREEN" "   All $removed_count SAFE worktree(s) have been removed."
        fi
    fi

    echo ""
    print_color "$BOLD$BLUE" "══════════════════════════════════════════════════════════════════════════════"
    echo ""
}

################################################################################
# Entry Point
################################################################################

main() {
    parse_args "$@"
    detect_configuration
    check_prerequisites
    analyze_worktrees
    display_header
    display_safe_to_delete
    display_need_attention
    display_keep
    display_summary
    remove_safe_worktrees
}

main "$@"
