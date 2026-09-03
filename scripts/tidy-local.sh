#!/bin/bash
# Bring the local clone back in line with origin and delete branches that have landed.
#
# Day-to-day work here is short-lived topic branches (blog/<topic>/N, chore/<topic>/N)
# that land on master via PR and are then dead weight. This script fast-forwards master,
# prunes remote-tracking refs for deleted remote branches, and removes local branches
# whose work is already on master.
#
# It is deliberately conservative:
#   - Nothing is deleted without --apply. The default run only prints a plan.
#   - It refuses to touch a dirty tree, and checks untracked files too (this repo sets
#     status.showUntrackedFiles=no, so a plain `git status` lies about new posts).
#   - master is only ever fast-forwarded, never merged or rebased, so it cannot conflict
#     and cannot lose commits.
#   - A branch is deleted only if its work is provably on master, covering all three
#     merge buttons: an ancestor of master (merge commit), every commit patch-applied
#     under new SHAs (rebase), or the combined patch already applied (squash). Anything
#     else is reported and left alone.
#   - `upstream` is never fetched. Template syncs are a deliberate, reviewed act — see
#     the upstream sync policy in CLAUDE.md.
#
# Usage:
#   ./scripts/tidy-local.sh            # show what would change
#   ./scripts/tidy-local.sh --apply    # actually delete the merged branches

set -euo pipefail

cd "$(dirname "${BASH_SOURCE[0]}")/.."

TARGET="master"
REMOTE="origin"
APPLY=false

for arg in "$@"; do
  case "$arg" in
    --apply) APPLY=true ;;
    -h|--help) sed -n '2,24p' "${BASH_SOURCE[0]}" | sed 's/^# \{0,1\}//'; exit 0 ;;
    *) echo "unknown argument: $arg" >&2; exit 2 ;;
  esac
done

# --- Safety: never operate on a dirty tree -----------------------------------
# -unormal overrides this repo's status.showUntrackedFiles=no.
dirty=$(git status --porcelain -unormal)
if [ -n "$dirty" ]; then
  echo "Working tree is not clean. Commit or stash first:" >&2
  echo "$dirty" | sed 's/^/    /' >&2
  exit 1
fi

original_branch=$(git rev-parse --abbrev-ref HEAD)

echo "==> Fetching $REMOTE (pruning deleted remote branches)"
git fetch --prune --quiet "$REMOTE"

echo "==> Pruning stale worktree registrations"
git worktree prune

# --- Fast-forward master -----------------------------------------------------
echo "==> Updating $TARGET"
if [ "$original_branch" = "$TARGET" ]; then
  git merge --ff-only "$REMOTE/$TARGET" --quiet 2>/dev/null \
    && echo "    $TARGET -> $(git rev-parse --short "$TARGET")" \
    || { echo "    cannot fast-forward $TARGET; it has diverged from $REMOTE/$TARGET" >&2; exit 1; }
else
  # Updates the ref without checking it out. Fails loudly if not fast-forwardable.
  git fetch "$REMOTE" "$TARGET:$TARGET" --quiet 2>/dev/null \
    && echo "    $TARGET -> $(git rev-parse --short "$TARGET")" \
    || { echo "    cannot fast-forward $TARGET; it has diverged from $REMOTE/$TARGET" >&2; exit 1; }
fi

# --- Classify local branches -------------------------------------------------
# A branch counts as landed in any of three ways, because the three merge buttons leave
# three different traces:
#   1. merge commit  -> the branch is an ancestor of master
#   2. rebase-merge  -> commits are replayed with new SHAs, so every commit is
#                       patch-applied on master even though none share a SHA
#   3. squash-merge  -> the commits are combined into one, so no individual commit
#                       matches; instead the branch's whole tree, as a single patch,
#                       is already applied
landed=()
unlanded=()

while IFS= read -r branch; do
  [ "$branch" = "$TARGET" ] && continue
  [ "$branch" = "$original_branch" ] && continue

  if git merge-base --is-ancestor "$branch" "$TARGET"; then
    landed+=("$branch")
    continue
  fi

  # Rebase-merge: every commit is patch-applied on master under a different SHA.
  cherry=$(git cherry "$TARGET" "$branch")
  if [ -n "$cherry" ] && ! grep -q '^+' <<<"$cherry"; then
    landed+=("$branch (rebase-merged)")
    continue
  fi

  # Squash-merge: no individual commit matches, but the combined patch does.
  base=$(git merge-base "$TARGET" "$branch")
  synthetic=$(git commit-tree "$(git rev-parse "$branch^{tree}")" -p "$base" -m _)
  if [ "$(git cherry "$TARGET" "$synthetic" | head -c1)" = "-" ]; then
    landed+=("$branch (squash-merged)")
  else
    ahead=$(git rev-list --count "$TARGET".."$branch")
    unlanded+=("$branch ($ahead commit(s) not on $TARGET)")
  fi
done < <(git for-each-ref --format='%(refname:short)' refs/heads/)

# --- Report and act ----------------------------------------------------------
echo
if [ ${#landed[@]} -eq 0 ]; then
  echo "==> No merged branches to clean up."
else
  if $APPLY; then
    echo "==> Deleting ${#landed[@]} merged branch(es)"
  else
    echo "==> Would delete ${#landed[@]} merged branch(es)  [--apply to do it]"
  fi
  for entry in "${landed[@]}"; do
    name=${entry%% (*}
    if $APPLY; then
      # -D not -d: squash-merged branches are not ancestors, so -d refuses them.
      # Safe here because the loop above already proved the content is on master.
      sha=$(git rev-parse --short "$name")
      git branch -D "$name" >/dev/null
      echo "    deleted $entry  (was $sha; recover with: git branch $name $sha)"
    else
      echo "    $entry"
    fi
  done
fi

if [ ${#unlanded[@]} -gt 0 ]; then
  echo
  echo "==> Keeping ${#unlanded[@]} branch(es) with unlanded work"
  for entry in "${unlanded[@]}"; do echo "    $entry"; done
fi

# --- Repo guards -------------------------------------------------------------
# These live in .git/config and do not survive a fresh clone, so a tidy-up is a
# good moment to notice they are missing.
echo
echo "==> Checking PR guards"
if command -v gh >/dev/null 2>&1; then
  resolved=$(gh repo view --json nameWithOwner --jq .nameWithOwner 2>/dev/null || echo "unknown")
  if [ "$resolved" = "junruren/junruren.github.io" ]; then
    echo "    gh resolves to $resolved  ✓"
  else
    echo "    gh resolves to $resolved  ✗  run ./scripts/setup-git-guards.sh" >&2
  fi
else
  echo "    gh not installed; skipping"
fi

echo
echo "==> Done. On branch $(git rev-parse --abbrev-ref HEAD); $TARGET at $(git rev-parse --short "$TARGET")."
if ! $APPLY && [ ${#landed[@]} -gt 0 ]; then
  echo "    Re-run with --apply to delete the merged branches listed above."
fi
