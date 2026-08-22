#!/bin/bash
# Point PRs and pushes at junruren/junruren.github.io, never the academicpages template.
#
# This repo keeps an `upstream` remote pointing at the academicpages template it
# was forked from. With two remotes and nothing pinned, `gh` resolves the repo to
# academicpages/academicpages.github.io, so a bare `gh pr create` opens a pull
# request against the TEMPLATE PROJECT instead of this site.
#
# These settings live in .git/config, so they do not survive a fresh clone.
# Re-run this script after cloning. It is safe to run repeatedly.

set -euo pipefail

REPO="junruren/junruren.github.io"
cd "$(dirname "${BASH_SOURCE[0]}")/.."

echo "==> Pinning gh's default repo to $REPO"
gh repo set-default "$REPO"

if git remote get-url upstream >/dev/null 2>&1; then
  echo "==> Making 'upstream' fetch-only (git fetch upstream still works)"
  git remote set-url --push upstream NO_PUSH_use_origin
fi

echo "==> Defaulting pushes to origin"
git config --local remote.pushDefault origin

echo
echo "==> Verifying"
resolved=$(gh repo view --json nameWithOwner --jq .nameWithOwner)
if [ "$resolved" = "$REPO" ]; then
  echo "    gh resolves to $resolved  ✓"
else
  echo "    gh resolves to $resolved  ✗  expected $REPO" >&2
  exit 1
fi
echo "    upstream push url: $(git remote get-url --push upstream 2>/dev/null || echo 'n/a')"
echo
echo "Done. When in doubt, be explicit:"
echo "  gh pr create --repo $REPO --base master"
