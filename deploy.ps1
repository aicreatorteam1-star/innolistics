<#
.SYNOPSIS
  Push code → GitHub repo + Deploy → Vercel  (เวอร์ชันใช้ repo ที่ user สร้างไว้แล้ว)

.DESCRIPTION
  Repo: https://github.com/aicreatorteam1-star/innolistics.git
  ไม่ต้องลง gh CLI — ใช้แค่ git ปกติ
  ครั้งแรก git จะ pop หน้า GitHub login (Git Credential Manager) ผ่าน browser
  เสร็จแล้วใช้ npx vercel deploy
#>
$ErrorActionPreference = "Stop"

$REMOTE = "https://github.com/aicreatorteam1-star/innolistics.git"
$BRANCH = "main"

function Step($msg) { Write-Host "`n==> $msg" -ForegroundColor Cyan }
function Ok($msg)   { Write-Host "    OK  $msg" -ForegroundColor Green }
function Warn($msg) { Write-Host "    !!  $msg" -ForegroundColor Yellow }
function Die($msg)  { Write-Host "`nERROR: $msg" -ForegroundColor Red; exit 1 }

function HasCmd($name) { return [bool](Get-Command $name -ErrorAction SilentlyContinue) }

# 0 ---------------- checks ----------------
Step "Step 0/4 - check tools"
if (-not (HasCmd "git"))  { Die "ไม่พบ git — ติดตั้งที่ https://git-scm.com/download/win" }
Ok "git $((git --version) -replace 'git version ','')"
if (-not (HasCmd "node")) { Die "ไม่พบ node — ติดตั้ง Node 18+ ที่ https://nodejs.org/" }
Ok "node $(node -v)"
if (HasCmd "vercel")      { $VercelCmd = "vercel" }
else { $VercelCmd = "npx --yes vercel@latest"; Warn "จะใช้ npx vercel (download ~30s)" }

# 1 ---------------- git init + remote ----------------
Step "Step 1/4 - git init + set remote"
if (-not (Test-Path ".git")) {
  git init -b $BRANCH | Out-Null
  Ok "git init -b $BRANCH"
} else {
  Ok "git repo อยู่แล้ว"
}

# ตั้ง user.name / user.email ถ้ายังไม่ตั้ง (commit จะ fail)
if (-not (git config user.name 2>$null))  { git config user.name  "aicreatorteam1-star" }
if (-not (git config user.email 2>$null)) { git config user.email "aicreatorteam1-star@users.noreply.github.com" }

# ตั้ง remote
$existing = (git remote get-url origin 2>$null)
if ($existing) {
  if ($existing -ne $REMOTE) {
    git remote set-url origin $REMOTE
    Ok "อัปเดต remote → $REMOTE"
  } else {
    Ok "remote already $REMOTE"
  }
} else {
  git remote add origin $REMOTE
  Ok "เพิ่ม remote → $REMOTE"
}

# 2 ---------------- commit ----------------
Step "Step 2/4 - commit"
git add -A | Out-Null
$status = git status --porcelain
if ($status) {
  git commit -m "feat: initial Space Matching Platform prototype" | Out-Null
  Ok "commit created"
} else {
  Ok "ไม่มีการเปลี่ยนแปลง — ข้าม commit"
}

# 3 ---------------- push ----------------
Step "Step 3/4 - push to GitHub"
Write-Host "    >>> ครั้งแรก browser จะเด้งให้ login GitHub (Git Credential Manager)"
Write-Host "    >>> หรือถ้า prompt ใน terminal ให้ paste Personal Access Token แทน password"
Write-Host ""
try {
  git push -u origin $BRANCH
  Ok "pushed → https://github.com/aicreatorteam1-star/innolistics"
} catch {
  Warn "push ล้มเหลว — ลองอีกที"
  Write-Host "    ถ้ายัง fail ให้สร้าง PAT ที่ https://github.com/settings/tokens (scope: repo)"
  Write-Host "    แล้วใช้ PAT แทน password ตอน prompt"
  exit 1
}

# 4 ---------------- Vercel deploy ----------------
Step "Step 4/4 - Vercel deploy"
Write-Host "    >>> ครั้งแรก browser จะเด้งให้ login Vercel"
Write-Host "    >>> ตอบ Y/default ทุกข้อ (กด Enter รัว ๆ)"
Write-Host "    >>> Framework Preset = Vite (auto-detect)"
Write-Host ""
Invoke-Expression "$VercelCmd --prod --yes"

# 5 ---------------- done ----------------
Step "DONE!"
Write-Host ""
Write-Host "  GitHub : https://github.com/aicreatorteam1-star/innolistics" -ForegroundColor Green
Write-Host "  Vercel : ดู Production URL ด้านบน (https://*.vercel.app)" -ForegroundColor Green
Write-Host ""
Write-Host "  ทุก 'git push' ต่อจากนี้ Vercel จะ auto-deploy ภายใน ~30 วินาที"
Write-Host "  ส่ง Production URL กลับมาให้ Claude ผ่าน chat เพื่อให้ตรวจ build logs"
