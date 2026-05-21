# Space Matching Platform — Frontend Prototype

> ระบบจับคู่ห้องฝากของ: เลือกสาขา → ระบุไอเทม → คำนวณ S/M/L → ส่งข้อมูลให้เจ้าหน้าที่
>
> **ขอบเขต prototype นี้:** Frontend อย่างเดียว ไม่มีระบบชำระเงิน ไม่มี backend จริง
> (submit จำลองด้วย `console.log` + simulated 600 ms delay)

---

## 🚀 Deploy ด้วยคำสั่งเดียว

```powershell
.\deploy.ps1     # Windows
```
```bash
bash deploy.sh   # Mac / Linux / WSL
```

ดูรายละเอียดเต็มใน [`DEPLOY.md`](./DEPLOY.md)

---

## Stack

- **Vite 5** + **React 18** + **TypeScript 5.6**
- **Lucide React** สำหรับ icon
- **Prompt font** จาก Google Fonts
- CSS Variables → map กับ brand token (`deepSpace`, `electricPurple`, `neonCyan`) — มี fallback hex
- **ไม่มี** Tailwind / Ant Design (ลด build size — gzip JS ~52 kB)

---

## โครงสร้างไฟล์

```
space-matching/
├── deploy.ps1                          ← Windows one-shot deploy
├── deploy.sh                           ← Mac/Linux one-shot deploy
├── DEPLOY.md                           ← คู่มือ deploy
├── index.html                          ← Vite entry (โหลด Prompt font)
├── package.json                        ← deps + scripts
├── tsconfig.json                       ← TS strict + @/* path alias
├── vite.config.ts                      ← Vite + React + alias
├── vercel.json                         ← framework=vite + SPA rewrite
├── .gitignore / .npmrc
├── preview.html                        ← standalone preview (CDN-based, ไม่ใช้ตอน deploy)
└── src/
    ├── main.tsx                        ← ReactDOM.createRoot
    ├── App.tsx                         ← render <SpaceMatchingPage />
    ├── vite-env.d.ts
    ├── styles/global.css               ← reset + Prompt font
    └── pages/SpaceMatching/
        ├── index.ts
        ├── types.ts
        ├── space-matching.css
        ├── SpaceMatchingPage.tsx
        ├── utils/matchRoom.ts
        └── components/
            ├── LocationSelector.tsx
            ├── ItemCounter.tsx
            └── MatchingResult.tsx
```

---

## รันบนเครื่อง (dev)

```bash
npm install
npm run dev          # → http://localhost:5173
npm run type-check   # ตรวจ TypeScript
npm run build        # → dist/
npm run preview      # serve dist/
```

✅ **Verified:** `npm run build` ทดสอบแล้ว สร้าง bundle 163 kB (gzip 52 kB) ไม่มี error

---

## Matching logic (`src/pages/SpaceMatching/utils/matchRoom.ts`)

| ไอเทม          | Units / ชิ้น |  | ขนาดห้อง | Units (≤) | ราคา / เดือน |
| -------------- | -----------: |---| -------- | --------: | -----------: |
| กล่องลัง       | 1            |  | S        | 15        | 1,500        |
| กระเป๋าเดินทาง | 2            |  | M        | 30        | 2,800        |
| ตู้เสื้อผ้า    | 5            |  | L        | 60        | 4,500        |
| ตู้เย็น        | 6            |  | XL       | ∞         | 6,900        |
| โซฟา           | 8            |  |          |           |              |

ปรับ tuning ตามจริงได้ใน `ITEM_DEFS` และ `ROOMS` ของไฟล์เดียวกัน

---

## สิ่งที่ยัง **ไม่** ทำในรอบนี้

- ระบบชำระเงิน
- การยิงข้อมูลไป backend จริง (ตอนนี้แค่ `console.log`)
- หน้า admin / dashboard
- การส่งอีเมล / SMS แจ้งเจ้าหน้าที่
- การ login / authentication
