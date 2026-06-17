# VMO Clarity — Claude Code Deployment Guide

## What This Is
A full-stack Value Management Office Control Tower built for Arqiva's Senior Planning & Value Management Specialist role. 

## Architecture
- **Frontend:** Static HTML/JS (deployed to Vercel)
- **Backend:** Python FastAPI (Vercel serverless functions)
- **Database:** Supabase PostgreSQL

## Your Tasks
1. Run `supabase_schema.sql` in the user's Supabase SQL Editor
2. Deploy backend using `vercel.json` config
3. Deploy frontend to Vercel
4. Update `.env` with user's Supabase credentials

## Files
- `api/index.py` — FastAPI backend with full CRUD
- `public/index.html` — Interactive frontend
- `supabase_schema.sql` — Database schema + seed data
- `vercel.json` — Vercel deployment configuration
- `.env.example` — Environment variables template
- `README.md` — Project documentation

## Deployment Steps
1. `npm i -g vercel` (if not installed)
2. `vercel login` (user logs in)
3. `vercel --prod` (deploys everything)
4. Update Supabase Row Level Security policies
