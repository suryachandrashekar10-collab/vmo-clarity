# VMO Clarity — Value Management Office Control Tower

Built for Arqiva Senior Planning & Value Management Specialist role.

## Quick Start (Claude Code)

1. **Supabase Setup**
   - Open `supabase_schema.sql`
   - Copy contents to Supabase SQL Editor → New Query → Run
   - Database is ready with realistic Arqiva data

2. **Environment Variables**
   - Copy `.env.example` to `.env`
   - Fill in your Supabase URL and Anon Key

3. **Deploy to Vercel**
   ```bash
   npm i -g vercel
   vercel login
   vercel --prod
   ```

4. **Done** — Live URL provided by Vercel

## Architecture

- **Frontend:** Static HTML/JS (Vercel)
- **Backend:** FastAPI Python (Vercel serverless)
- **Database:** Supabase PostgreSQL

## Features

- Executive Dashboard with real-time KPIs
- Project CRUD (Create, Read, Update, Delete)
- Demand Intake with VMO Score calculator
- RIDAC Hub (Risks, Issues, Decisions, Actions, Changes)
- Value Realisation Tracker
- Full API integration with Supabase

## API Endpoints

- `GET /api/projects` — List all projects
- `POST /api/projects` — Create project
- `PUT /api/projects/{id}` — Update project
- `DELETE /api/projects/{id}` — Delete project
- `GET /api/ridac` — List RIDAC items
- `POST /api/ridac` — Create RIDAC item
- `GET /api/benefits` — List benefits
- `PATCH /api/benefits/{id}` — Update benefit
- `GET /api/demands` — List demands
- `POST /api/demands` — Create demand
- `GET /api/dashboard/stats` — Dashboard statistics
