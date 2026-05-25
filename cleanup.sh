#!/bin/bash
set -euo pipefail
#####################################################################
# Author    : Erik Dubois
# Website   : https://kiroproject.be
#####################################################################
#
#   DO NOT JUST RUN THIS. EXAMINE AND JUDGE. RUN AT YOUR OWN RISK.
#
#   Purpose:
#   - Wipe this repo's git history and replace it with a single
#     commit containing the current working tree.
#   - Force-push the new history to origin/main.
#   - GC the local .git to reclaim disk space.
#
#   Why: these repos accumulate large binary churn (package files,
#   ISOs, build artefacts). History is not needed; only the latest
#   state matters.
#
#####################################################################

SCRIPT_DIR="$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" && pwd)"

#####################################################################
# Colors
#####################################################################
if command -v tput >/dev/null 2>&1 && [[ -t 1 ]]; then
    RED="$(tput setaf 1)"
    GREEN="$(tput setaf 2)"
    YELLOW="$(tput setaf 3)"
    BLUE="$(tput setaf 4)"
    CYAN="$(tput setaf 6)"
    RESET="$(tput sgr0)"
else
    RED="" GREEN="" YELLOW="" BLUE="" CYAN="" RESET=""
fi

#####################################################################
# Logging
#####################################################################
log_section() {
    echo
    echo "${GREEN}############################################################################${RESET}"
    echo "$1"
    echo "${GREEN}############################################################################${RESET}"
    echo
}

log_info() {
    echo
    echo "${BLUE}############################################################################${RESET}"
    echo "$1"
    echo "${BLUE}############################################################################${RESET}"
    echo
}

log_warn() {
    echo
    echo "${YELLOW}############################################################################${RESET}"
    echo "$1"
    echo "${YELLOW}############################################################################${RESET}"
    echo
}

log_error() {
    echo
    echo "${RED}############################################################################${RESET}"
    echo "$1"
    echo "${RED}############################################################################${RESET}"
    echo
}

log_success() {
    echo
    echo "${GREEN}############################################################################${RESET}"
    echo "$1"
    echo "${GREEN}############################################################################${RESET}"
    echo
}

#####################################################################
# Error handling
#####################################################################
on_error() {
    local lineno="$1"
    local cmd="$2"
    echo
    echo "${RED}ERROR on line ${lineno}: ${cmd}${RESET}"
    echo
    sleep 10
}

trap 'on_error "$LINENO" "$BASH_COMMAND"' ERR

#####################################################################
# Functions
#####################################################################
require_git_repo() {
    cd "${SCRIPT_DIR}"
    if ! git rev-parse --is-inside-work-tree >/dev/null 2>&1; then
        log_error "${SCRIPT_DIR} is not inside a git working tree"
        exit 1
    fi
}

show_state() {
    local remote_url
    local branch
    local git_size
    remote_url="$(git remote get-url origin 2>/dev/null || echo '(no origin)')"
    branch="$(git branch --show-current 2>/dev/null || echo '(detached)')"
    git_size="$(du -sh .git 2>/dev/null | awk '{print $1}')"

    log_info "Repository: ${SCRIPT_DIR}
Origin    : ${remote_url}
Branch    : ${branch}
.git size : ${git_size}"
}

confirm_destruction() {
    log_warn "This will PERMANENTLY DESTROY the history of this repo:
  - Local main will be replaced with a single orphan commit
  - origin/main will be FORCE-PUSHED (remote history erased)
  - .git will be GC'd

There is no undo. Make sure no one else is pushing to this repo."

    echo "${YELLOW}Type the word 'WIPE' (uppercase) to proceed, anything else to abort:${RESET}"
    local reply
    read -r reply
    if [[ "${reply}" != "WIPE" ]]; then
        log_info "Aborted by user."
        exit 0
    fi
}

rewrite_history() {
    log_section "Rewriting history as a single orphan commit"

    git checkout --orphan __cleanup_fresh
    git add -A
    git commit -m "Reset history — single snapshot of current state"
    git branch -M main
}

force_push() {
    log_section "Force-pushing main to origin"
    git push -f origin main
}

gc_local() {
    log_section "Reclaiming local disk space"
    git reflog expire --expire=now --all
    git gc --prune=now --aggressive

    local git_size
    git_size="$(du -sh .git 2>/dev/null | awk '{print $1}')"
    log_info ".git size now: ${git_size}"
}

#####################################################################
# Main
#####################################################################
main() {
    log_section "Cleanup script — wipe git history"

    require_git_repo
    show_state
    confirm_destruction
    rewrite_history
    force_push
    gc_local

    log_success "$(basename "$0") done"
}

main "$@"
