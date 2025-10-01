# Uber-Report: Evidence Synthesis on AI Tutor Prompting for Advanced STEM Learners

*(Synthesizing three independent reports: \[A] ChatGPT, \[B] Claude, \[C] Gemini)*

## Scope & Method (PRISMA-ish, GRADE-inspired)

* **Corpus.** Three independent deep-research reports on AI tutoring prompts for advanced STEM learning: \[A] (intent + outline), \[B] (evidence-forward framework with quantitative effects and templates), \[C] (andragogy-driven “Emergent Tutor” with modular modes and metacognitive/PBL engine).  &#x20;
* **Procedure.**

  1. Normalize into atomic **evidence units** (claims / data / methods / assumptions / limitations).
  2. **Cluster** units; mark **Consensus** (≥2 sources), **Single-source**, or **Conflict**.
  3. **Adjudicate** conflicts using only internal textual cues (specificity, internal consistency, explicit limits, cross-support).
  4. **Certainty rating** per cluster using GRADE-like labels (High/Moderate/Low/Very low) + 1-line rationale.
  5. **Surface gaps & missingness** across sources.
  6. **Compose** a unified uber-report and a consolidated, implementation-ready prompt skeleton.

---

## Step 1 — Normalized Evidence Units (selected)

| ID  | Type       | Unit (short paraphrase or quote)                                                                                            | Provenance |
| --- | ---------- | --------------------------------------------------------------------------------------------------------------------------- | ---------- |
| U1  | Claim      | Expertise architecture differs from novices; implies less scaffolding for advanced learners; expertise-reversal effect.     | \[B]       |
| U2  | Data       | Active learning ↑ exam performance (\~0.47 SD) and ↓ failure rates by \~55%.                                                | \[B]       |
| U3  | Data       | PBL meta-effects \~0.626 (creative) and \~0.719 (computational).                                                            | \[B]       |
| U4  | Claim      | Desirable difficulties (spacing, interleaving, retrieval) improve long-term retention/transfer.                             | \[B]       |
| U5  | Method     | 5-step Socratic tutoring dialogue; progressive questioning to metacognition.                                                | \[B]       |
| U6  | Method     | ZPD-based loop **Probe → Diagnose → Intervene → Fade** combining Socratic + scaffolding.                                    | \[C]       |
| U7  | Method     | Andragogy: autonomy, leverage experience, relevance, problem-centeredness, intrinsic motivation.                            | \[C]       |
| U8  | Method     | Domain-specific adaptations (Math/Stats, Physics/Eng, CS, Life Sciences).                                                   | \[B]       |
| U9  | Method     | Session structure (5/40/5) with activation, main phase, consolidation.                                                      | \[B]       |
| U10 | Method     | Process-focused feedback, two-tier assessments, diagnostic hinge-point questions.                                           | \[B]       |
| U11 | Method     | First-principles + decomposition + analogies (with explicit breakdowns) + Feynman technique as a cycle.                     | \[C]       |
| U12 | Method     | Project-Based Learning as grand framework; driving question → sustained inquiry → critique/revision.                        | \[C]       |
| U13 | Method     | Think-aloud modeling to surface expert cognition.                                                                           | \[B,C]     |
| U14 | Method     | Jupyter “cognitive sandbox” pattern: analogy → scaffolded code → Socratic prediction → interactive experiment → reflection. | \[C]       |
| U15 | Assumption | Tutor should **not** be an “answer engine,” but a facilitator (Socratic guide, cognitive coach, project catalyst).          | \[C]       |
| U16 | Claim      | Continuous adaptation via learning indicators (latency, error types, confidence calibration).                               | \[B]       |
| U17 | Claim      | “Approaching Bloom’s 2-sigma” is a potential outcome of personalized, evidence-based tutoring.                              | \[B]       |

*(Note: \[A] states intent to synthesize foundations and provide reusable prompts but contains limited substantive claims/data beyond scope framing. \[A] )*

---

## Steps 2–4 — Clusters, Consensus/Conflict Labels, and GRADE-like Certainty

### C1 — **Andragogy first: autonomy, experience, relevance, problem-centeredness**

**Synthesis.** Adult learners demand autonomy; prompts must elicit prior experience, tie tasks to goals, keep problem-/project-centered, and support intrinsic motivation \[C]; \[B] echoes autonomy/engagement and career relevance. \[C,B]   &#x20;
**Label:** Consensus
**Certainty:** **High.** Strong converging prescriptions; \[C] detailed principles; \[B] reinforcing patterns.

### C2 — **Socratic + Scaffolding, coordinated by ZPD**

**Synthesis.** Use Socratic probes to locate ZPD; tailor scaffold (think-aloud, templates, vocabulary) and then fade support; operational loop “Probe → Diagnose → Intervene → Fade.” \[C]; \[B] independently prescribes structured Socratic dialogue + calibrated scaffolding trajectory. \[C,B]  &#x20;
**Label:** Consensus
**Certainty:** **High.** Multi-source agreement with explicit mechanisms.

### C3 — **Active learning & PBL deliver large learning gains**

**Synthesis.** Quantitative effects for active learning and PBL reported in \[B]; \[C] adopts PBL as macro-framework (driving questions, sustained inquiry, critique). \[B,C] &#x20;
**Label:** Consensus (data + design)
**Certainty:** **Moderate–High.** \[B] supplies effect sizes; \[C] provides design scaffolds.

### C4 — **Desirable difficulties (spacing, interleaving, retrieval) for durable learning**

**Synthesis.** \[B] prescribes spaced, interleaved, retrieval-heavy practice and success-rate targeting. \[B]&#x20;
**Label:** Single-source
**Certainty:** **Moderate.** Detailed, internally consistent, but corroboration absent in \[A],\[C].

### C5 — **Metacognition: plan-monitor-evaluate; exam wrappers; muddiest point**

**Synthesis.** \[C] centers metacognition with explicit Plan-Monitor-Evaluate loop and concrete tools; \[B] independently specifies metacognitive development protocol. \[C,B] &#x20;
**Label:** Consensus
**Certainty:** **High.** Agreement + actionable instruments.

### C6 — **Think-aloud modeling of expert cognition**

**Synthesis.** Both \[B] and \[C] direct think-alouds to expose expert strategies. \[B,C] &#x20;
**Label:** Consensus
**Certainty:** **High.**

### C7 — **First-principles → decomposition → analogies (with limits) → Feynman cycle**

**Synthesis.** \[C] details a four-technique workflow and warns to mark analogy breakdowns; finish with Feynman explanation to reveal gaps. \[C] &#x20;
**Label:** Single-source
**Certainty:** **Moderate.** Rich, specific method; no conflicting accounts.

### C8 — **Session architecture & adaptive responses**

**Synthesis.** 5/40/5 structure, hinge-point diagnostics, and adaptive playbooks for struggle/success; domain-specific adaptations (Math/Stats, Physics/Eng, CS, Life Sci). \[B] &#x20;
**Label:** Single-source
**Certainty:** **Moderate.** Specific and internally consistent; corroboration absent.

### C9 — **Tutor identity: not an answer engine; modular modes/router**

**Synthesis.** \[C] asserts facilitator persona and provides modes: Socratic Explorer, Scaffolding Architect, Project Catalyst, Metacognitive Coach. \[C]&#x20;
**Label:** Single-source
**Certainty:** **Moderate.** Strong internal rationale; no contradictions.

### C10 — **Jupyter as “cognitive sandbox” for interactive learning**

**Synthesis.** \[C] outlines an explicit notebook flow (analogy → scaffolded code → Socratic prediction → interactive experiment → reflection). \[C]&#x20;
**Label:** Single-source
**Certainty:** **Moderate.** Practical and specific; not addressed elsewhere.

### C11 — **Continuous adaptation via learner signals**

**Synthesis.** Monitor response latency, error type, confidence calibration; adjust challenge/scaffold accordingly. \[B]&#x20;
**Label:** Single-source
**Certainty:** **Moderate.**

### C12 — **Potential to approach Bloom’s 2-sigma**

**Synthesis.** \[B] suggests the combined approach may approach 2-sigma personalization gains. \[B]&#x20;
**Label:** Single-source
**Certainty:** **Low.** Ambitious generalization; not echoed by \[A],\[C]; context/constraints unspecified.

---

## Step 3 — Conflicts & Adjudication

1. **“Not an answer engine” vs. worked examples/scaffolds**

* **Positions.** \[C] cautions against direct answering; role is facilitator \[C]. \[B] endorses worked examples, hints, and guided practice \[B]. &#x20;
* **Adjudication.** **No true conflict**: \[B]’s scaffolds are temporary and faded (gradual release), which aligns with \[C]’s facilitation when framed as *optional supports* within ZPD and with learner autonomy. Stronger reading: combine \[C]’s stance with \[B]’s fade-out protocol. **Certainty: High** (textual compatibility).

2. **Socratic challenge vs. andragogical respect**

* **Positions.** \[C] explicitly warns that untempered Socratic pressure can violate adult-learning respect/self-direction; it must be framed collaboratively \[C]. \[B] doesn’t note this risk explicitly.&#x20;
* **Adjudication.** Accept \[C]’s caveat as **stronger** due to explicit limitation handling and integration with autonomy; no contrary claim in \[B]. **Certainty: Moderate–High.**

*(No additional explicit contradictions surfaced; \[A] too sparse to conflict.)*

---

## Step 5 — Gaps & Missingness

* **\[A]**: Provides scope/intent for evidence-based, project-centric prompts but lacks concrete findings, methods, or quantitative effects; thus contributes minimal adjudicable evidence beyond design goals. **(Gap: limited substance.)**&#x20;
* **\[B]**: Strong on **quantitative effects**, **desirable difficulties**, **session design**, **domain adaptations**, **feedback/assessment**, and **continuous adaptation**, but lighter on **andragogical framing** and **mode routing**.  &#x20;
* **\[C]**: Strong on **andragogy**, **ZPD loop**, **metacognition**, **PBL**, **modular modes**, and **interactive workflows**; lacks empirical effect sizes and some practical classroom diagnostics present in \[B].  &#x20;

---

## Integrated Takeaways (for advanced technical readers)

1. **Adopt an andragogical contract** (autonomy, relevance, experience) as the *governor* on all tactics \[C], then orchestrate **Socratic ↔ scaffolding** within ZPD using the **Probe → Diagnose → Intervene → Fade** loop \[C], augmented with \[B]’s calibrated release and success-rate targeting. \[C,B] &#x20;
2. **Run on active, project-based fuel**: anchor sessions in authentic research-like tasks; expect measurable gains vs. lecture baselines (\[B] data) while following \[C]’s PBL pipeline (driving question → sustained inquiry → critique/revision). \[B,C] &#x20;
3. **Engineer durability** with spacing/interleaving/retrieval and cumulative practice; weave metacognitive **Plan-Monitor-Evaluate** and error analysis into the cadence. \[B,C] &#x20;
4. **Use the four-technique cognition cycle** for novel problems: *first-principles → decomposition → analogy (with known breakdowns) → Feynman explanation.* \[C] &#x20;
5. **Operationalize with templates**: session 5/40/5; adaptive playbooks for struggle/success; domain-specific patterns; diagnostic hinge-points and two-tier assessments. \[B] &#x20;

---

## Consolidated Prompt Skeleton (the “best-of” uber-prompt)

> **Identity & Compact Charter.** *You are an andragogy-aligned tutor for an advanced STEM learner. You are a facilitator, not an answer engine; you balance Socratic inquiry with just-in-time scaffolding to keep me in my ZPD.* \[C]&#x20;

**Core Loop (run every exchange).**
**Probe → Diagnose → Intervene → Fade**

* *Probe* with Socratic questions (clarity, assumptions, evidence, alternatives, implications) to locate my ZPD. \[C]&#x20;
* *Diagnose* whether I face a misconception vs. skill/knowledge gap. \[C]&#x20;
* *Intervene* only as needed: think-alouds, partial templates, pre-taught vocabulary, or bridging analogies (and say where the analogy breaks). \[B,C]  &#x20;
* *Fade* support; keep success \~60–70% to maintain optimal challenge. \[B]&#x20;

**Andragogical Guardrails (apply continuously).**

* Ask for prior experience and current goals; tie every task to my stated outcomes; offer options, not commands; reinforce effort/process. \[C]  &#x20;

**Session Scaffold (5/40/5).**

* *Opening (5):* retrieve prior knowledge, preview connections, set specific capabilities. \[B]&#x20;
* *Main (40):* authentic research problem; progressive Socratic dialogue; think-aloud model; analogous task with reduced scaffolding; integrate/transfer. \[B]&#x20;
* *Consolidation (5):* reflection + self-assessment + feed-forward plan. \[B]&#x20;

**Learning-for-durability.**

* Schedule spaced revisits; interleave related concepts; use retrieval as primary mechanism; maintain cumulative practice. \[B]&#x20;

**Cognitive Workflow for Hard Topics.**

* First-principles → decomposition → careful analogies (with explicit breakdowns) → Feynman explain-back. \[C] &#x20;

**Assessment & Feedback.**

* Hinge-point diagnostics; two-tier answers (confidence/reasoning); process-focused feedback; error-pattern analysis. \[B]&#x20;

**Modes (router, optional).**

* *Socratic Explorer* (questions only), *Scaffolding Architect* (temporary supports), *Project Catalyst* (PBL planning), *Metacognitive Coach* (Plan-Monitor-Evaluate). \[C]&#x20;

**Interactive Environment (optional, computational domains).**

* Notebook sequence: analogy/concept → scaffolded code → Socratic prediction → interactive experiment → metacognitive reflection. \[C]&#x20;

---

## Actionable Checklist (implementation quick-start)

* Start every new topic by **eliciting prior knowledge + goals** and **choosing a mode** (Explorer/Architect/Catalyst/Coach). \[C]&#x20;
* For each exchange, run **P→D→I→F**; log the **diagnosis** type and **intervention** you used. \[C]&#x20;
* Maintain a **spaced/interleaved** review calendar and track **success rate**; raise difficulty if success >70%, add scaffolds if <60%. \[B]&#x20;
* Embed **Plan-Monitor-Evaluate** prompts at transitions and after assessments (use exam wrappers/muddiest-point). \[C,B] &#x20;
* For hard concepts, drive the **4-technique cycle** ending with a **Feynman** explain-back. \[C]&#x20;

---

## Appendix — Per-Cluster Certainty Table (abridged)

| Cluster                   | Consensus Type   | Certainty         | One-line Rationale                                                |
| ------------------------- | ---------------- | ----------------- | ----------------------------------------------------------------- |
| C1 Andragogy              | Consensus \[C,B] | **High**          | \[C] detailed principles; \[B] reinforces relevance/engagement.   |
| C2 Socratic↔Scaffold ZPD  | Consensus \[C,B] | **High**          | Shared loop + tactics; independent articulation.                  |
| C3 Active/PBL Gains       | Consensus \[B,C] | **Moderate–High** | \[B] quantitative; \[C] structural adoption.                      |
| C4 Desirable Difficulties | Single \[B]      | **Moderate**      | Detailed protocol; no contrary claims.                            |
| C5 Metacognition PME      | Consensus \[C,B] | **High**          | Both specify PME & tools.                                         |
| C7 4-Technique Cycle      | Single \[C]      | **Moderate**      | Rich method; unchallenged.                                        |
| C8 Session & Domains      | Single \[B]      | **Moderate**      | Specific, operational; not echoed elsewhere.                      |
| C12 2-sigma Potential     | Single \[B]      | **Low**           | Ambitious; no corroboration.                                      |

---

## Provenance Map (who contributed what)

* **\[B] Claude**: quantitative effects; desirable difficulties; session/assessment templates; domain adaptations; continuous adaptation; rich Socratic script.  &#x20;
* **\[C] Gemini**: andragogy; ZPD loop; modular modes/router; PBL macro-framework; metacognition (PME); first-principles/decomposition/analogy/Feynman; notebook pedagogy.   &#x20;
* **\[A] ChatGPT**: scope commitment to evidence-based, project-centric tutoring; limited concrete findings.&#x20;

---

### Extrapolation / Outside knowledge

*(None added beyond the three inputs.)*

---

If you want, I can drop this **uber-prompt** into a single, copy-pastable “system prompt” block or tailor it to your preferred agent framework (router + modes + evaluation hooks) using the same citations (\[B],\[C]) embedded as comments.
