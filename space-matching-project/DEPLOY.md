# Deploy คู่มือ — GitHub + Vercel แบบรันคำสั่งเดียวจบ

> ผมไม่สามารถ push code หรือ deploy แทนคุณได้โดยไม่มี personal access token
> ซึ่งไม่ควรแชร์ผ่าน chat — ดังนั้นวิธีที่ปลอดภัยที่สุดคือคุณรัน script
> ที่ผมเตรียมไว้ในเครื่องตัวเอง โดย script จะให้ `gh` กับ `vercel` CLI
> เปิด browser ขึ้นมา login ของคุณเอง (ไม่ผ่าน script เลย)

---

## ก่อนรัน (one-time setup)

ติดตั้ง 3 อย่างนี้บนเครื่อง Windows (ถ้ายังไม่มี):

```powershell
# 1) Git — ส่วนใหญ่มีอยู่แล้ว เช็คด้วย
git --version

# 2) GitHub CLI (gh)
winget install --id GitHub.cli -e

# 3) Node 18+
winget install OpenJS.NodeJS.LTS
```

(Vercel CLI ไม่ต้องลง — script จะใช้ `npx vercel` ให้)

ปิด PowerShell แล้วเปิดใหม่หลังลงเสร็จ เพื่อให้ PATH refresh

---

## รัน 1 คำสั่งจบ (Windows)

```powershell
cd "C:\path\to\space-matching"     # ⬅ ใส่ path โฟลเดอร์โปรเจกต์
.\deploy.ps1
```

ครั้งแรก Windows อาจติด ExecutionPolicy — รันคำสั่งนี้แค่ครั้งเดียวก่อน:

```powershell
Set-ExecutionPolicy -Scope CurrentUser -ExecutionPolicy RemoteSigned
```

แล้วลอง `.\deploy.ps1` ใหม่

### ทางเลือก: ปรับชื่อ repo / public

```powershell
.\deploy.ps1 -RepoName "space-matching-prod" -Private $false
.\deploy.ps1 -Owner "innolistic"               # push เข้า org แทน personal
```

---

## รัน 1 คำสั่งจบ (Mac / Linux / WSL)

```bash
cd ~/path/to/space-matching
bash deploy.sh
# หรือ
PRIVATE=false bash deploy.sh space-matching-prod
```

---

## script จะทำอะไรบ้าง

```
Step 0/5 — เช็คว่า git / gh / node / vercel พร้อมไหม
Step 1/5 — git init -b main (ข้ามถ้าทำแล้ว)
Step 2/5 — git add + commit
Step 3/5 — gh repo create  →  git push -u origin main
            ↳ ครั้งแรก gh จะเปิด browser ให้ login (รออนุมัติ ~30 วินาที)
Step 4/5 — vercel --prod --yes
            ↳ ครั้งแรก vercel จะเปิด browser ให้ login + ถาม project ใหม่
              ตอบ default ทั้งหมด (กด Enter รัว ๆ) ใช้เวลา ~1 นาที
Step 5/5 — print GitHub + Vercel URL
```

ครั้งต่อ ๆ ไป (push update ใหม่):

```powershell
git add .
git commit -m "fix: ..."
git push                  # ⬅ Vercel auto-deploy ภายใน ~30 วินาที
```

---

## ถ้าอยากให้ผมช่วยทำสด (Walk-through)

ถ้าไม่อยากรัน CLI เอง บอกผมได้ครับ ผมจะใช้ **Claude in Chrome**
walk-through ทีละหน้า — คุณดูที่ browser ของตัวเอง ผมคลิกให้ทีละ step
(ต้องติดตั้ง Claude in Chrome extension ก่อน)

---

## Troubleshooting

| อาการ | สาเหตุ / วิธีแก้ |
|---|---|
| `gh: command not found` | ยังไม่ได้ลง GitHub CLI หรือยังไม่ restart PowerShell หลังลง |
| `Authentication failed` ตอน push | login ผ่าน `gh auth login --web` ใหม่ |
| `Vercel CLI` ค้างที่ "Set up and deploy?" | กด Enter (default = yes) |
| `Build failed on Vercel` | ทดสอบ `npm run build` ในเครื่องก่อน (เคยทดสอบแล้ว — ผ่าน) |
| repo มีอยู่แล้ว | script จะแจ้งเตือนแล้ว push ทับ (ไม่ลบของเดิม) |
