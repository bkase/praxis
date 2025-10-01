---
allowed-tools: Read, Write, Bash(date), mcp_google_calendar_*
description: Plan your week with anchored flexibility and role-based activities
argument-hint: [reflection|plan|review]
---

# Weekly Planning with Anchored Flexibility

Guide the user through a comprehensive weekly planning session using role-based activity allocation and time blocking with Google Calendar integration.

## Overview

This command implements an anchored flexibility system where:

- Each day has 5 two-hour blocks (1 morning, 2 afternoon, 2 evening)
- Activities are planned by embodying different life roles
- Focus sessions are 60-90 minutes within 2-hour blocks
- The week is balanced holistically, not necessarily each day
- Previous week's reflection informs current planning

## Configuration Files

This command reads from two configuration files in the working directory:

- `weekly-reflection-questions.md`: Customizable reflection questions
- `weekly-roles.md`: List of roles for activity planning

## Workflow Phases

### PHASE 0: INITIALIZATION

1. Get current date: `date +%Y-%m-%d` ; if this is Sunday, then this is the start of the next week.
2. Calculate week start (Monday) and end (Sunday) dates
3. Get ISO week number: `date +%V` (for the week being planned)
4. Set week file name: `week-YYYY-Wnn.md` (e.g., `week-2025-W38.md`)
5. Check if current week file exists, `"$(a4 root)/weekly-plans/2025/week-YYYY-Wnn.md"`
6. If exists and contains reflection, skip to PHASE 2
7. Show user current phase: "📅 Starting weekly planning for [dates]"

### PHASE 1: WEEKLY REFLECTION

**Always run this phase for new week planning**

1. Read related files from the prior week `$(a4 root)/weekly-plans/2025/week-YYYY-Wnn` and all the daily notes from that week `a4 today` to get the path, and look for anything from those other days. Look for slugs with the `find-note.sh` tool in `$(a4 root)` too. Read all files linked to this week!
2. Show user: "📝 Phase 1: Weekly Reflection"
3. Read questions from `weekly-reflection-questions.md` and sprinkle in extra context from the week too.
4. If file doesn't exist, send error to the user and quit
5. Remind the user about all the activities that they said they would do last week (show them to the user)
6. Present all questions at once to the user
7. Collect responses and ask deeper follow questions, and tell the user:
   "Press 'y' to end the reflection"
8. Repeat 6 until the user sends 'y'
9. Format reflection section for the week file

### PHASE 2: WEEK STRUCTURE SETUP

1. Show user: "⚙️ Phase 2: Setting Up Week Structure"
2. Ask user to define time blocks for the week:

   ```
   Please specify the time ranges for your daily blocks:
   - Morning block (default: 09:00-11:00):
   - Afternoon block 1 (default: 14:00-16:00):
   - Afternoon block 2 (default: 16:00-18:00):
   - Evening block 1 (default: 19:00-21:00):
   - Evening block 2 (default: 21:00-23:00):
   ```

3. Ask about constraints:

   ```
   Do you have any fixed commitments this week?
   Please list them with day and time block (e.g., "Tuesday afternoon 1: Team meeting")
   ```

4. Store time blocks in memory for front matter metadata. Keep constraints in memory for later use in the body content only (do not include them in the file's front matter).

### PHASE 3: ROLE-BASED ACTIVITY PLANNING

1. Show user: "🎭 Phase 3: Planning Activities by Role"
2. First, ask orientation questions:

   ```
   Before we plan your activities, let's set your focus for the week:

   What are your top 3 outcomes for the upcoming week?
   (These should be specific, meaningful results you want to achieve)
   ```

3. Store the top 3 outcomes in memory for later inclusion in the week file
4. Read roles from `weekly-roles.md`
5. If file doesn't exist, send error to the user and quit
6. Present all roles at once:

   ```
   For each role below, list activities you want to schedule this week.
   Include any constraints (e.g., "mornings only", "3 sessions", "Tuesday specific")

   [List all roles]
   ```

7. Parse user response for:
   - Activities per role
   - Number of slots needed
   - Timing constraints
   - Priority levels

### PHASE 4: SCHEDULE OPTIMIZATION

1. Show user: "🗓️ Phase 4: Creating Your Schedule"
2. Start from the current time -- if the user is running this workflow Monday at midnight, only start on Tuesday when allocating time slots!
3. Algorithm for slot assignment:
   - First, place all constrained activities
   - Distribute remaining activities to balance roles across the week
   - Ensure orthogonality (mix different roles each day)
   - Leave gaps evenly distributed if not all slots filled
4. Present proposed schedule:

   ```
   Here's your proposed weekly schedule:

   MONDAY
   Morning (09:00-11:00): [Activity] (Role)
   Afternoon 1 (14:00-16:00): [Activity] (Role)
   Afternoon 2 (16:00-18:00): [Activity] (Role)
   Evening 1 (19:00-21:00): [Activity] (Role)
   Evening 2 (21:00-23:00): [Activity] (Role)

   [Continue for all days...]
   ```

5. Ask: "Does this schedule work for you? (yes/adjustments needed)"
6. If adjustments needed:
   - Collect specific changes
   - Regenerate schedule with modifications
   - Present again for approval

### PHASE 5: FINALIZE AND SAVE

1. Show user: "💾 Phase 5: Saving Your Plan"
2. Create week file with structure:

   ```markdown
   ---
   kind: weekly.plan
   week_start: YYYY-MM-DD
   week_end: YYYY-MM-DD
   time_blocks:
     morning: "HH:MM-HH:MM"
     afternoon_1: "HH:MM-HH:MM"
     afternoon_2: "HH:MM-HH:MM"
     evening_1: "HH:MM-HH:MM"
     evening_2: "HH:MM-HH:MM"
   tags: [weekly, Wnn]
   ---

   # Week {{YYYY-Wnn}}

   ## Last Week's Reflection

   [Reflection content from Phase 1]

   ## Top 3 Outcomes for This Week

   1. [Outcome 1]
   2. [Outcome 2]
   3. [Outcome 3]

   ## Schedule

   ### Monday

   [Formatted schedule]

   ## Activities by Role

   ### [Role Name]

   - [Activity] ([number] slots)
   ```

3. Write file to disk at `"$(a4 root)/collections/weekly-plans/2025/week-YYYY-Wnn.md"`, ensuring:
   - Every heading is followed by a blank line before content begins
   - Role labels appear in parentheses (e.g., "Call with Gigi (Partner)")
4. Generate some summary markdown, `$SUMMARY`, containing the outcomes (1,2,3) and a summary of the schedule (5 bullets max), eg.

```markdown
[[week-YYYY-Wnn|W38]]

### Top 3 Outcomes

1.  [Outcome 1]
2.  [Outcome 2]
3.  [Outcome 3]

### Activities

- Coding on my app
- Meeting with friends: David, Gigi, Fred
- Attending meetings on the weekdays
- Attend a few exercise classes on [[2025-09-16|Tuesday]] and [[2025-09-18|Thursday]]
- Go on a hike on [[2025-09-20]]
```

4. Append to daily note `a4 append --heading "Weekly Plan" --anchor "weekly" --today --text "$SUMMARY"`
5. Confirm: "✅ Week planned and saved to [filename]"
6. If Google Calendar MCP is available:
   - Remove all existing calendar events this week in the Idealized Week calendar if there are any
   - Create calendar events for each scheduled activity using the Idealized Week calendar
   - Use my current timezone unless otherwise specified
   - Use 2-hour blocks with activity name
   - Add role as event description
   - Color-code by role if possible
7. Confirm: "✅ Week saved into calendar"

## Additional Commands

### Review Mode (`$ARGUMENTS` = "review")

1. Read current week's file
2. Display the top 3 outcomes that were set for the week
3. Display schedule in readable format
4. Show progress indicators if available

### Reflection Only (`$ARGUMENTS` = "reflection")

1. Run only Phase 1
2. Append to current week's file

## Error Handling

- If configuration files missing: Use defaults and notify user
- If week file corrupted: Backup and create new
- If Calendar MCP fails: Continue with local file only
- Always preserve user data in case of errors

## Usage Examples

```bash
/weekly-plan          # Full planning session
/weekly-plan review   # Review current week
/weekly-plan reflection # Add reflection only
```

## Notes

- Focus sessions are 60-90 minutes within 2-hour blocks
- Extra time allows for transitions and breaks
- Week starts Monday, ends Sunday
- Week files use ISO week format: `week-YYYY-Wnn.md` (e.g., `week-2025-W38.md`)
- Balance across week, not necessarily each day
- Calendar is projection of markdown file (source of truth)
- Do not store weekly constraints in the front matter; capture them within the body content if needed
