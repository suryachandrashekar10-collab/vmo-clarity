-- VMO CLARITY - Supabase Schema
-- Run this in Supabase SQL Editor → New Query → Run

-- Enable UUID extension
CREATE EXTENSION IF NOT EXISTS "uuid-ossp";

-- 1. PROJECTS
CREATE TABLE IF NOT EXISTS projects (
    project_id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    project_code TEXT UNIQUE NOT NULL,
    project_name TEXT NOT NULL,
    delivery_manager TEXT NOT NULL,
    methodology TEXT DEFAULT 'Waterfall',
    phase TEXT DEFAULT 'Initiating',
    status TEXT DEFAULT 'Green',
    rag_reason TEXT,
    budget DECIMAL(15,2) DEFAULT 0,
    actual_cost DECIMAL(15,2) DEFAULT 0,
    forecast_cost DECIMAL(15,2) DEFAULT 0,
    expected_benefit DECIMAL(15,2) DEFAULT 0,
    actual_benefit DECIMAL(15,2) DEFAULT 0,
    strategic_alignment DECIMAL(3,1) DEFAULT 5,
    risk_score DECIMAL(3,1) DEFAULT 3,
    complexity DECIMAL(3,1) DEFAULT 3,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- 2. RIDAC (Risks, Issues, Decisions, Actions, Changes)
CREATE TABLE IF NOT EXISTS ridac (
    ridac_id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    ridac_code TEXT UNIQUE NOT NULL,
    type TEXT NOT NULL CHECK (type IN ('Risk', 'Issue', 'Decision', 'Action', 'Change')),
    title TEXT NOT NULL,
    description TEXT NOT NULL,
    project_id UUID REFERENCES projects(project_id),
    owner TEXT NOT NULL,
    impact TEXT DEFAULT 'Medium',
    action_required TEXT,
    status TEXT DEFAULT 'Active',
    target_date DATE,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- 3. DEMANDS
CREATE TABLE IF NOT EXISTS demands (
    demand_id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    demand_code TEXT UNIQUE NOT NULL,
    title TEXT NOT NULL,
    business_area TEXT NOT NULL,
    expected_benefit DECIMAL(15,2) DEFAULT 0,
    strategic_alignment DECIMAL(3,1) DEFAULT 5,
    regulatory_score DECIMAL(3,1) DEFAULT 5,
    feasibility_score DECIMAL(3,1) DEFAULT 5,
    commercial_score DECIMAL(3,1) DEFAULT 5,
    vmo_score DECIMAL(4,2) DEFAULT 5,
    stage TEXT DEFAULT 'Draft',
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- 4. BENEFITS
CREATE TABLE IF NOT EXISTS benefits (
    benefit_id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    project_id UUID REFERENCES projects(project_id),
    benefit_name TEXT NOT NULL,
    benefit_type TEXT NOT NULL,
    expected_value DECIMAL(15,2) DEFAULT 0,
    realised_value DECIMAL(15,2) DEFAULT 0,
    measurement_unit TEXT,
    status TEXT DEFAULT 'On Track',
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- 5. PROCESS IMPROVEMENTS
CREATE TABLE IF NOT EXISTS process_improvements (
    improvement_id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    process_name TEXT NOT NULL,
    before_metric TEXT,
    after_metric TEXT,
    improvement_percentage DECIMAL(5,2),
    owner TEXT,
    status TEXT DEFAULT 'Identified',
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- SEED DATA
INSERT INTO projects (project_code, project_name, delivery_manager, methodology, phase, status, budget, actual_cost, forecast_cost, expected_benefit, actual_benefit, rag_reason, strategic_alignment, risk_score, complexity) VALUES
('PRJ-AMP8-UU', 'United Utilities Smart Meter Rollout', 'Glen Lines', 'Waterfall', 'Executing', 'Amber', 15000000, 8200000, 16200000, 12500000, 4800000, 'Rigger resource constraint - 3 vacancies unfilled for 6 weeks', 9.5, 4.2, 3.8),
('PRJ-M&B-AWS', 'AWS Cloud Playout Transition', 'Lesley Wilson', 'Hybrid', 'Executing', 'Green', 18000000, 6200000, 17500000, 8500000, 2100000, 'Sprints tracking to plan. 45 channels migrated, 105 remaining', 9.0, 2.5, 4.5),
('PRJ-AMP8-AN', 'Anglian Water Phase 2 Metering', 'Justin Godson', 'Waterfall', 'Initiating', 'Green', 14000000, 800000, 14200000, 11200000, 0, 'Playbook configured. Supply chain resilience plan approved', 9.0, 2.8, 3.5),
('PRJ-CNI-SEC', 'CNI Security Vetting Acceleration', 'Peter Swift', 'Agile', 'Planning', 'Red', 3200000, 450000, 3800000, 3200000, 0, '340 clearance backlog. Government API blocked. Union delay 6 weeks', 8.5, 4.8, 4.2),
('PRJ-SITE-EM', 'Emley Moor Transmitter Resilience', 'Sarah Chen', 'Waterfall', 'Executing', 'Amber', 4500000, 1200000, 4800000, 4500000, 800000, 'Heritage permission delayed 8 weeks. Rigging contractor booked Q3', 8.0, 3.5, 3.2),
('PRJ-UTIL-4G', 'Smart Meter 4G/5G Fallback Network', 'David Park', 'Hybrid', 'Planning', 'Green', 2800000, 150000, 2800000, 1800000, 0, 'Technical spec approved. MNO negotiations 80% complete', 7.5, 2.2, 3.0);

INSERT INTO ridac (ridac_code, type, title, description, owner, impact, action_required, status, target_date) VALUES
('R001', 'Risk', 'SC Security Clearance backlog', '5 rigger recruitments delayed due to clearance backlog. Offshore team cannot commence work.', 'Glen Lines', 'High', 'Escalate to government liaison. Engage alternative UK contractor.', 'Active', '2026-07-15'),
('R006', 'Risk', 'Government API rate limiting', '340 pending clearance applications blocked by government API rate limits.', 'Peter Swift', 'Critical', 'Escalate to Cabinet Office. Implement batch processing.', 'Escalated', '2026-07-01'),
('RID003', 'Decision', 'Pivot software engineering resources', 'Board decision: reallocate 2 engineers from AMP8 to AWS Cloud Playout to maintain sprint velocity.', 'Ruth Kirby', 'High', 'Present business case to Steering Committee. Assess AMP8 impact.', 'Pending', '2026-07-05'),
('RID004', 'Action', 'Request 4G/5G mobile fallback', 'Procure and deploy temporary 4G/5G mobile cellular fallback connectivity units for 50 critical Northwest sites.', 'Glen Lines', 'Medium', 'Issue PO for 50 units. Coordinate with MNOs. Schedule installation.', 'Active', '2026-07-30'),
('RID005', 'Change', 'Adjust AMP8 United Utilities baseline', 'Formal change request to adjust baseline deployment dates by 6 weeks due to rigger resource and weather constraints.', 'Glen Lines', 'High', 'Submit to Steering Committee. Update plan and forecast. Communicate to UU.', 'Active', '2026-07-10');

INSERT INTO benefits (project_id, benefit_name, benefit_type, expected_value, realised_value, measurement_unit, status) VALUES
((SELECT project_id FROM projects WHERE project_code = 'PRJ-AMP8-UU'), 'Water Leakage Reduction', 'Operational Efficiency', 30000000, 8500000, 'Litres/Day', 'On Track'),
((SELECT project_id FROM projects WHERE project_code = 'PRJ-AMP8-UU'), 'Manual Reading Cost Elimination', 'Cost Saving', 2500000, 800000, 'GBP/Year', 'On Track'),
((SELECT project_id FROM projects WHERE project_code = 'PRJ-M&B-AWS'), 'Infrastructure Cost Reduction', 'Cost Saving', 3200000, 850000, 'GBP/Year', 'On Track');

INSERT INTO demands (demand_code, title, business_area, expected_benefit, strategic_alignment, regulatory_score, feasibility_score, commercial_score, vmo_score, stage) VALUES
('D001', 'United Utilities Northwest Smart Meter Rollout', 'Smart Utilities', 12500000, 9.5, 9.0, 7.5, 9.0, 8.85, 'Approved'),
('D002', 'AWS Cloud Playout Transition - MediaConnect', 'Media & Broadcast', 8500000, 9.0, 6.0, 8.5, 8.5, 8.05, 'Approved'),
('D004', 'CNI National Security Vetting Acceleration', 'Enablement', 3200000, 8.5, 10.0, 6.0, 7.5, 7.95, 'Screening');

INSERT INTO process_improvements (process_name, before_metric, after_metric, improvement_percentage, owner, status) VALUES
('Contract Approval Process', '15 days', '6 days', 60.0, 'Process Improvement Lead', 'Validated'),
('Field Service Dispatch', '4 hours', '2 hours', 50.0, 'Field Operations Manager', 'Validated'),
('Security Clearance Onboarding', '20 weeks', '8 weeks', 60.0, 'Peter Swift', 'Implementing');
