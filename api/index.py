from fastapi import FastAPI, HTTPException
from fastapi.middleware.cors import CORSMiddleware
from pydantic import BaseModel
from typing import List, Optional
from datetime import date
import os
from supabase import create_client, Client

app = FastAPI(title="VMO Clarity API")

# CORS for frontend
app.add_middleware(
    CORSMiddleware,
    allow_origins=["*"],
    allow_methods=["*"],
    allow_headers=["*"],
)

# Supabase client
supabase_url = os.getenv("SUPABASE_URL")
supabase_key = os.getenv("SUPABASE_KEY")
supabase: Client = create_client(supabase_url, supabase_key)

# Models
class ProjectCreate(BaseModel):
    project_code: str
    project_name: str
    delivery_manager: str
    status: str = "Green"
    budget: float = 0
    expected_benefit: float = 0

class ProjectUpdate(BaseModel):
    project_name: Optional[str] = None
    delivery_manager: Optional[str] = None
    status: Optional[str] = None
    actual_cost: Optional[float] = None
    forecast_cost: Optional[float] = None
    rag_reason: Optional[str] = None

class RIDACCreate(BaseModel):
    ridac_code: str
    type: str
    title: str
    description: str
    project_id: Optional[str] = None
    owner: str
    impact: str = "Medium"
    action_required: str
    target_date: Optional[str] = None

class BenefitUpdate(BaseModel):
    realised_value: float
    status: str

@app.get("/")
def root():
    return {"message": "VMO Clarity API", "version": "1.0.0"}

@app.get("/projects")
def get_projects():
    result = supabase.table("projects").select("*").execute()
    return {"projects": result.data}

@app.post("/projects")
def create_project(project: ProjectCreate):
    result = supabase.table("projects").insert(project.dict()).execute()
    return {"message": "Project created", "data": result.data[0]}

@app.put("/projects/{project_id}")
def update_project(project_id: str, update: ProjectUpdate):
    data = {k: v for k, v in update.dict().items() if v is not None}
    result = supabase.table("projects").update(data).eq("project_id", project_id).execute()
    return {"message": "Project updated", "data": result.data[0]}

@app.delete("/projects/{project_id}")
def delete_project(project_id: str):
    supabase.table("projects").delete().eq("project_id", project_id).execute()
    return {"message": "Project deleted"}

@app.get("/ridac")
def get_ridac():
    result = supabase.table("ridac").select("*").execute()
    return {"ridac": result.data}

@app.post("/ridac")
def create_ridac(item: RIDACCreate):
    result = supabase.table("ridac").insert(item.dict()).execute()
    return {"message": "RIDAC item created", "data": result.data[0]}

@app.put("/ridac/{ridac_id}")
def update_ridac(ridac_id: str, item: RIDACCreate):
    result = supabase.table("ridac").update(item.dict()).eq("ridac_id", ridac_id).execute()
    return {"message": "RIDAC updated", "data": result.data[0]}

@app.delete("/ridac/{ridac_id}")
def delete_ridac(ridac_id: str):
    supabase.table("ridac").delete().eq("ridac_id", ridac_id).execute()
    return {"message": "RIDAC item deleted"}

@app.get("/benefits")
def get_benefits():
    result = supabase.table("benefits").select("*").execute()
    return {"benefits": result.data}

@app.patch("/benefits/{benefit_id}")
def update_benefit(benefit_id: str, update: BenefitUpdate):
    result = supabase.table("benefits").update(update.dict()).eq("benefit_id", benefit_id).execute()
    return {"message": "Benefit updated", "data": result.data[0]}

@app.get("/demands")
def get_demands():
    result = supabase.table("demands").select("*").execute()
    return {"demands": result.data}

@app.post("/demands")
def create_demand(demand: dict):
    result = supabase.table("demands").insert(demand).execute()
    return {"message": "Demand created", "data": result.data[0]}

@app.get("/dashboard/stats")
def get_stats():
    projects = supabase.table("projects").select("*").execute().data
    total = len(projects)
    green = sum(1 for p in projects if p.get("status") == "Green")
    amber = sum(1 for p in projects if p.get("status") == "Amber")
    red = sum(1 for p in projects if p.get("status") == "Red")
    total_budget = sum(p.get("budget", 0) for p in projects)
    total_actual = sum(p.get("actual_cost", 0) for p in projects)

    return {
        "total_projects": total,
        "green": green,
        "amber": amber,
        "red": red,
        "total_budget": total_budget,
        "total_actual": total_actual,
        "variance": total_budget - total_actual
    }
