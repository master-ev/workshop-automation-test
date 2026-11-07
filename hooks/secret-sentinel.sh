#!/usr/bin/env bash
# Challenge 1: The Secret Sentinel
# Blocks a commit if any staged change adds a line containing the forbidden word below.
# Install: cp hooks/secret-sentinel.sh .git/hooks/pre-commit && chmod +x .git/hooks/pre-commit

FORBIDDEN='PASS''WORD='   # split so this file doesn't trigger itself

# Only look at lines being ADDED in the staged changes (not the whole file history).
matches=$(git diff --cached -U0 --no-color --diff-filter=ACMR \
    | grep -E '^(\+\+\+ |\+)' \
    | awk -v pat="$FORBIDDEN" '
        /^\+\+\+ / { file = substr($0, 7); next }
        index($0, pat) { print "  " file ": " substr($0, 2) }')

if [ -n "$matches" ]; then
    RED=$'\033[1;41;97m'; YEL=$'\033[1;33m'; RST=$'\033[0m'
    echo
    echo "${RED}                                                            ${RST}"
    echo "${RED}   🚨  COMMIT BLOCKED: POSSIBLE SECRET DETECTED  🚨          ${RST}"
    echo "${RED}                                                            ${RST}"
    echo
    echo "${YEL}Found '$FORBIDDEN' in your staged changes:${RST}"
    echo "$matches"
    echo
    echo "Remove the secret (use environment variables or a secrets manager),"
    echo "then 'git add' the file again and retry the commit."
    echo
    exit 1
fi

exit 0
