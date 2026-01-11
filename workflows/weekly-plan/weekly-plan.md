weekly-plan.md:
---
allowed-tools: Read, Write, Bash(date), mcp_google_calendar_*
description: Principles-first weekly reflection & planning with floors, project scope-locks, proof, and anchored flexibility
argument-hint: [reflection|plan|review]
---

# Weekly Planning (v2): Principles → Floors → Projects → Anchors → Flex

This command implements a process-first system:
- **Principles** drive choices: Balance (weekly), Momentum (early), Wonder (bounded), Excellence (process)
- **Floors** are weekly standards (A–F). We plan to hit them.
- **Projects** are WIP-limited (2). We scope-lock weekly (not 6-week rigid plans).
- **Schedule** is *anchors only* (deep work blocks + key commitments), preserving white space.
- **Proof** is required weekly: crumb/slice/ship artifacts, with excellence check.

## Configuration Files
Reads:
- `weekly-reflection-questions.md` (updated to match this system)
- `weekly-roles.md` (used as "weekly nourishment check", not full scheduling)

## Key Concepts (used throughout)

### The 4 Principles (read at start of planning)
1) **Balance (weekly, not daily)**
2) **Momentum (early actions compound)**
3) **Wonder (bounded; cannot steal from the other 3)**
4) **Pursuit of excellence (serious striving, not perfectionism)**

### Floors (A–F) (weekly standards)
A) Physical Health (sleep/diet/exercise)
B) Reflection + planning
C) Deep work: **≥ 6 blocks/week, each 2h+**
D) Curiosity: **≤ 4 hours/week (hard cap)**
E) White space: **≥ 3 unscheduled half-days/week**
F) Gigi: **≥ 1 intentional date/week**

### Projects
- WIP=2 "Now" projects.
- Weekly scope-lock per project:
  - Weekly Focus (1 sentence)
  - In-scope (max 3 bullets)
  - Out-of-scope (max 3 bullets)
  - Weekly Ship (1 sentence artifact)

### Proof ladder
- Crumb (10–30 min), Slice (1–3h), Ship (weekly)
- Each deep work block ends with a proof artifact + excellence check.

---

# Layered Workflow
Run **Layer 0** always. If you run low on time, stop after Layer 0.

## LAYER 0 — Core (must-do)
**Output:** week file with (1) last week scoreboard, (2) floors plan, (3) 2 project scope-locks, (4) anchor schedule.

### PHASE 0: Initialization
1) Get current date: `date +%Y-%m-%d`
2) Compute planned week start/end (Mon–Sun) and ISO week number `date +%V`
3) Set week file: `week-YYYY-Wnn.md`
4) Locate storage path: `"$(a4 root)/collections/weekly-plans/YYYY/week-YYYY-Wnn.md"`
5) Locate last week file (YYYY-Wnn-1) if exists
6) Show: "📅 Starting weekly planning for [week_start → week_end]"

### PHASE 1: Last Week Closeout (Scoreboard-first reflection)
**Goal:** convert last week into a few decisions, not a long essay.

1) Read last week’s file (if exists) + daily notes from the week
2) Extract and display:
   - Floors (A–F): met? trends? which broke first?
   - Deep work blocks completed count (2h+)
   - Proof shipped count per project (ships + any proof points you track)
   - Pride/Wonder trend (if logged)
3) Ask the user to answer (short):
   - What *worked* (1–3 bullets)?
   - What *didn’t* (1–3 bullets)?
   - What will I *remove* next week (1–2 bullets)?
   - Any avoidance/discomfort moments to face next week (optional 1 bullet)?

Write this into the week file under "Last Week Closeout".

### PHASE 2: Floors Plan (A–F) — lock the container
**Goal:** floors get planned before projects and scheduling.

Ask the user to confirm/choose:
1) **Sleep plan (process targets):**
   - In bed 11, asleep by 12, wake+sunlight by 9:30
   - Weekly threshold (default): ≥ 5 days/week hit all 3

2) **Diet plan:**
   - Creatine daily; protein priority; sugar only evening and max once/day
   - Weekly thresholds (defaults): creatine ≥ 6/7, protein ≥ 5/7, sugar rule ≥ 5/7

3) **Exercise plan:**
   - Small morning movement (default: 5–15 min) ≥ 5/7
   - One big session: Nikki or class ≥ 1/week
   - Ask user to pick a target day/time window for the big session

4) **Reflection plan:**
   - Daily morning intention ≥ 5/7
   - Daily evening review ≥ 5/7
   - Weekly review must happen by end of Wed if slipped

5) **Deep work plan:**
   - ≥ 6 blocks/week, each 2h+
   - Ask user: preferred time windows for deep work blocks this week (optional)

6) **Curiosity cap plan:**
   - ≤ 4h/week (hard cap)
   - Ask user: do you want to aim for ~4h or intentionally lower this week?

7) **White space plan:**
   - ≥ 3 unscheduled half-days
   - Ask the user to choose *which* 3 half-days to protect (e.g., Tue PM, Thu AM, Sun PM).
   - If user doesn’t choose, select the 3 least constrained half-days based on calendar.

8) **Gigi date plan:**
   - ≥ 1 intentional date
   - Ask user to pick a day/time window.

Write floors into the week file as a "Floors Plan" section with checkboxes and chosen anchor windows.

### PHASE 3: Projects (WIP=2) + Weekly Scope-Lock (week-level boundaries)
**Goal:** keep outcomes light; lock weekly focus so the week is coherent.

1) Confirm the two active projects ("Now").
2) For each project, ask the user to fill:

**Project Scope-Lock template**
- Weekly Focus (1 sentence)
- In-scope (max 3 bullets)
- Out-of-scope (max 3 bullets)
- Weekly Ship (1 sentence artifact)
- Deep work blocks allocated this week (number + preferred days)

3) Add the **Weekly Scope Integrity rule**:
- Aim for ≥ 80% of deep blocks to match the weekly focus.
- If not, note why during next weekly review.

Write this into the week file under "Projects & Scope-Locks".

### PHASE 4: Anchor Scheduling (anchored flexibility; preserve free space)
**Goal:** schedule only anchors; do NOT schedule the whole week.

1) Pull fixed commitments from Google Calendar (if available).
2) Place anchors:
   - 6 deep work blocks (2h+)
   - Weekly review block (if you want it calendared)
   - Gigi date block
   - Big exercise session block
   - Optional: 1 curiosity session (bounded) if desired
3) Ensure the three protected white-space half-days remain unscheduled.
4) Present a compact "Anchor Schedule" (not full-day blocks).
5) If Calendar MCP available:
   - Clear and recreate events only on the "Idealized Week" calendar (or your chosen one)
   - Create events for anchors only (deep blocks, date, big workout, weekly review)
   - Do not create events inside protected white-space half-days

Write schedule into the week file.

### PHASE 5: Save + Weekly Summary
1) Save week file to disk.
2) Generate $SUMMARY (short) and append to daily note with `a4 append`.

$SUMMARY should include:
- link to week file
- floors (deep work target, curiosity cap, white space count, date planned)
- the two projects + weekly focus + weekly ship (one line each)
- anchor highlights (5 bullets max)

Confirm: "✅ Week planned and saved to [filename]"

---

## LAYER 1 — Strong (recommended if time)
**Output:** stack blocks chosen + weekly balance check + content hook.

### PHASE 6: Stack Map (choose 3–5 stack blocks for the week)
Ask user to choose 3–5 from a stack map menu (kept in the week file), e.g.:
- walk+sunlight+call (health+people)
- cowork+ship packaging (people+building)
- yogurt/protein+morning intention (diet+reflection)
- dinner prep+evening review+capture refinement (diet+planning)
- wonder outing (bounded curiosity)
- post-ship content drafting while warm (builder+content)

Write "Selected Stack Blocks" into the week file.
Optionally schedule 1–2 stack blocks if they are scarce resources; otherwise keep as a menu.

### PHASE 7: Weekly Nourishment Check (roles as balance lens, not scheduling)
Read roles from `weekly-roles.md`, then ask:
- Which roles are naturally covered by floors + project anchors?
- Which 1–2 roles might be neglected this week?
- Add at most 1–2 “nice-to-have” items to the week file under "Optional Menu" (not scheduled).

### PHASE 8: Content hook (build/learn in public)
Ask:
- Which project ship will become public content this week?
- When is the best day to draft it (optional to schedule)?
Write under "Public Learning".

---

## LAYER 2 — Deep (optional)
**Output:** micro-experiments + friction removal plan.

### PHASE 9: System iteration (one friction per week)
Ask:
- What was the biggest friction in the system last week?
- Choose exactly one friction to reduce this week.
- Define a tiny ship for that (template, script, terminal banner, etc.).
Write under "System Iteration".

### PHASE 10: Discomfort rep (optional)
Ask:
- What is one avoided conversation/action you’ll face this week?
Write under "Discomfort Rep".

---

# Modes

## Review Mode (`$ARGUMENTS` = "review")
1) Read current week file.
2) Display:
   - Floors plan + current progress if tracked
   - Projects scope-locks (focus/in/out/ship)
   - Anchor schedule
   - Stack blocks selected (if any)

## Reflection Only (`$ARGUMENTS` = "reflection")
Run only Phase 1 and append to current week file.

## Plan Only (`$ARGUMENTS` = "plan" or default)
Run full process: Layer 0 + optional Layer 1/2 if time.

---

# Week File Template (written in Phase 5)

```markdown
---
kind: weekly.plan
week_start: YYYY-MM-DD
week_end: YYYY-MM-DD
tags: [weekly, Wnn]
principles: [balance_weekly, momentum, wonder_bounded, excellence_process]
wip_limit: 2
---

# Week YYYY-Wnn

## Principles
- Balance (weekly)
- Momentum (early)
- Wonder (bounded)
- Excellence (process)

## Last Week Closeout (Scoreboard)
- Floors: A __ / B __ / C __ / D __ / E __ / F __
- Deep blocks (2h+): __ / 6
- Ships: Project 1 __ / Project 2 __
- Pride/Wonder trend: __ / __
- Worked:
- Didn’t:
- Remove:
- Avoidance/discomfort notes (optional):

## Floors Plan (A–F)
### A) Physical
- Sleep targets: bed 11 / asleep 12 / sunlight by 9:30 (threshold ≥5/7)
- Diet: creatine daily (≥6/7), protein priority (≥5/7), sugar evening-only once/day (≥5/7)
- Exercise: morning movement ≥5/7; big session ≥1/week (when: ____)

### B) Reflection & Planning
- Morning intention ≥5/7
- Evening review ≥5/7
- Weekly review: Sat/Sun/Mon preferred; must by Wed if slipped

### C) Deep Work
- Plan: 6 blocks/week, 2h+ each

### D) Curiosity
- Cap: ≤ 4h/week (aim: ____)

### E) White Space
- Protect 3 unscheduled half-days:
  - __
  - __
  - __

### F) Gigi Date
- Date: ____ (day/time window)

## Projects & Weekly Scope-Locks (WIP=2)
### Project 1: ______
- Weekly Focus:
- In-scope (≤3):
- Out-of-scope (≤3):
- Weekly Ship:
- Planned deep blocks (# + preferred days):

### Project 2: ______
- Weekly Focus:
- In-scope (≤3):
- Out-of-scope (≤3):
- Weekly Ship:
- Planned deep blocks (# + preferred days):

## Anchor Schedule (anchors only)
- Deep blocks:
  - ...
- Big exercise:
- Gigi date:
- Weekly review:

## Selected Stack Blocks (optional)
- ...

## Optional Menu (optional)
- ...

## Public Learning (optional)
- Ship-to-content plan:
- Draft window:

## System Iteration (optional)
- Friction:
- Tiny ship:
