#!/usr/bin/env bash
# Push to https://github.com/aicreatorteam1-star/innolistics + Vercel deploy
set -euo pipefail
REMOTE="https://github.com/aicreatorteam1-star/innolistics.git"
BRANCH="main"

c_step()  { printf "\n\033[36m==> %s\033[0m\n" "$1"; }
c_ok()    { printf "    \033[32mOK\033[0m  %s\n" "$1"; }
c_warn()  { printf "    \033[33m!!\033[0m  %s\n" "$1"; }
c_die()   { printf "\n\033[31mERROR: %s\033[0m\n" "$1"; exit 1; }

c_step "Step 0/4 - check tools"
command -v git  >/dev/null || c_die "ไม่พบ git"
c_ok  "git $(git --version | awk '{print $3}')"
command -v node >/dev/null || c_die "ไม่พบ node"
c_ok  "node $(node -v)"
if command -v vercel >/dev/null; then VERCEL_CMD="vercel"
else VERCEL_CMD="npx --yes vercel@latest"; c_warn "จะใช้ npx vercel"; fi

c_step "Step 1/4 - git init + remote"
[ -d .git ] || { git init -b "$BRANCH"; c_ok "git init"; }
git config user.name  "${USER:-aicreatorteam1-star}" >/dev/null
git config user.email "$(git config user.email || echo "${USER:-aicreatorteam1-star}@users.noreply.github.com")" >/dev/null
if git remote get-url origin >/dev/null 2>&1; then
  cur=$(git remote get-url origin)
  if [ "$cur" != "$REMOTE" ]; then git remote set-url origin "$REMOTE"; fi
else
  git remote add origin "$REMOTE"
fi
c_ok "remote = $REMOTE"

c_step "Step 2/4 - commit"
git add -A
if [ -n "$(git status --porcelain)" ]; then
  git commit -m "feat: initial Space Matching Platform prototype" >/dev/null
  c_ok "commit created"
else
  c_ok "no changes — skip commit"
fi

c_step "Step 3/4 - push"
echo "    >>> browser จะเด้งให้ login GitHub ครั้งแรก (Git Credential Manager)"
echo "    >>> หรือ paste Personal Access Token (scope: repo) แทน password"
git push -u origin "$BRANCH"
c_ok "pushed → https://github.com/aicreatorteam1-star/innolistics"

c_step "Step 4/4 - Vercel deploy"
$VERCEL_CMD --prod --yes

c_step "DONE!"
echo "  GitHub : https://github.com/aicreatorteam1-star/innolistics"
echo "  Vercel : ดู Production URL ด้านบน"
