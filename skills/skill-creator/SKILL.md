---
name: skill-creator
description: Create new skills, modify and improve existing skills, and measure skill performance. Use when users want to create a skill from scratch, edit, or optimize an existing skill, run evals to test a skill, benchmark skill performance with variance analysis, or optimize a skill's description for better triggering accuracy.
license: MIT
compatibility: opencode
metadata:
  source: https://github.com/anthropics/skills/tree/main/skills/skill-creator
  ported-from: claude-code
---

# Skill Creator

A skill for creating new skills and iteratively improving them.

At a high level, the process of creating a skill goes like this:

- Decide what you want the skill to do and roughly how it should do it
- Write a draft of the skill
- Create a few test prompts and run the agent-with-access-to-the-skill on them
- Help the user evaluate the results both qualitatively and quantitatively
  - While the runs happen in the background, draft some quantitative evals if there aren't any. Explain them to the user.
  - Use qualitative review to show the user the results, and also show them the quantitative metrics
- Rewrite the skill based on feedback from the user's evaluation of the results (and also if there are any glaring flaws that become apparent from the quantitative benchmarks)
- Repeat until you're satisfied
- Expand the test set and try again at larger scale

Your job when using this skill is to figure out where the user is in this process and then jump in and help them progress through these stages. So for instance, maybe they say "I want to make a skill for X". You can help narrow down what they mean, write a draft, write the test cases, figure out how they want to evaluate, run all the prompts, and repeat.

On the other hand, maybe they already have a draft of the skill. In this case you can go straight to the eval/iterate part of the loop.

Of course, always be flexible — if the user says "I don't need to run a bunch of evaluations, just vibe with me", do that instead.

After the skill is done (order is flexible), you can also help optimize the skill description for better triggering accuracy.

## Communicating with the user

Pay attention to context cues to understand how to phrase your communication. The skill creator may be used by people across a wide range of familiarity with coding jargon:

- "evaluation" and "benchmark" are borderline but OK
- For "JSON" and "assertion" — look for cues that the user knows those terms before using them without explanation

It's OK to briefly explain terms if you're in doubt.

---

## Creating a skill

### Capture Intent

Start by understanding the user's intent. The current conversation might already contain a workflow the user wants to capture (e.g., they say "turn this into a skill"). If so, extract answers from the conversation history first — the tools used, the sequence of steps, corrections the user made, input/output formats observed. The user may need to fill the gaps and should confirm before proceeding.

1. What should this skill enable the agent to do?
2. When should this skill trigger? (what user phrases/contexts)
3. What's the expected output format?
4. Should we set up test cases to verify the skill works? Skills with objectively verifiable outputs (file transforms, data extraction, code generation, fixed workflow steps) benefit from test cases. Skills with subjective outputs (writing style, art) often don't need them. Suggest the appropriate default based on the skill type, but let the user decide.

### Interview and Research

Proactively ask questions about edge cases, input/output formats, example files, success criteria, and dependencies. Wait to write test prompts until you've got this part ironed out.

### Write the SKILL.md

OpenCode skills live at:
- Global: `~/.config/opencode/skills/<name>/SKILL.md`
- Project: `.opencode/skills/<name>/SKILL.md`

Each `SKILL.md` requires YAML frontmatter:

```yaml
---
name: skill-name          # required, must match directory name
description: ...          # required, 1-1024 chars — this is the primary trigger mechanism
license: MIT              # optional
compatibility: opencode   # optional
metadata:                 # optional, string-to-string map
  key: value
---
```

**Name rules:** 1–64 chars, lowercase alphanumeric with single-hyphen separators, must match directory name.

Fill in these components based on your user interview:

- **name**: Skill identifier (matches directory name)
- **description**: When to trigger AND what it does. This is the primary triggering mechanism — include both what the skill does AND specific contexts/phrases that should trigger it. Make descriptions slightly "pushy": instead of "How to do X", write "How to do X. Use this skill whenever the user mentions Y or Z, even if they don't explicitly ask."
- **compatibility**: Set to `opencode`
- **the rest of the skill body**: Instructions, examples, reference pointers

### Skill Writing Guide

#### Anatomy of a Skill

```
skill-name/
├── SKILL.md (required, filename must be ALL CAPS)
│   ├── YAML frontmatter (name, description required)
│   └── Markdown instructions
└── Bundled Resources (optional)
    ├── scripts/    - Executable code for deterministic/repetitive tasks
    ├── references/ - Docs loaded into context as needed
    └── assets/     - Files used in output (templates, icons, fonts)
```

#### Progressive Disclosure

Skills use a three-level loading system:
1. **Metadata** (name + description) — Always in context (~100 words)
2. **SKILL.md body** — In context whenever skill triggers (<500 lines ideal)
3. **Bundled resources** — As needed (scripts can execute without loading)

**Key patterns:**
- Keep SKILL.md under 500 lines; if approaching the limit, add hierarchy with clear pointers to follow-up files
- Reference files clearly from SKILL.md with guidance on when to read them
- For large reference files (>300 lines), include a table of contents

**Domain organization**: When a skill supports multiple domains/frameworks, organize by variant:
```
cloud-deploy/
├── SKILL.md (workflow + selection logic)
└── references/
    ├── aws.md
    ├── gcp.md
    └── azure.md
```

#### Writing Patterns

Prefer the imperative form in instructions.

**Defining output formats:**
```markdown
## Report structure
ALWAYS use this exact template:
# [Title]
## Executive summary
## Key findings
## Recommendations
```

**Examples pattern:**
```markdown
## Commit message format
**Example 1:**
Input: Added user authentication with JWT tokens
Output: feat(auth): implement JWT-based authentication
```

### Writing Style

Explain *why* things are important rather than issuing heavy-handed MUSTs. Use theory of mind and make the skill general — not narrow to specific examples. Write a draft, then look at it with fresh eyes and improve it. If you find yourself writing ALWAYS or NEVER in all caps, try reframing and explaining the reasoning instead — that's more effective.

### Test Cases

After writing the skill draft, come up with 2-3 realistic test prompts — the kind of thing a real user would actually say. Share them with the user: "Here are a few test cases I'd like to try. Do these look right, or do you want to add more?" Then run them.

Save test cases to `evals/evals.json`:

```json
{
  "skill_name": "example-skill",
  "evals": [
    {
      "id": 1,
      "prompt": "User's task prompt",
      "expected_output": "Description of expected result",
      "files": []
    }
  ]
}
```

---

## Running and Evaluating Test Cases

This section is one continuous sequence — don't stop partway through.

Put results in `<skill-name>-workspace/` as a sibling to the skill directory. Within the workspace, organize by iteration (`iteration-1/`, `iteration-2/`, etc.) and within that, each test case gets a directory (`eval-0/`, `eval-1/`, etc.). Don't create all of this upfront — create directories as you go.

### Step 1: Spawn all runs in the same turn

For each test case, spawn two subagents in the same turn — one with the skill, one without (baseline). Don't spawn with-skill runs first and come back for baselines later. Launch everything at once.

**With-skill run prompt:**
```
Execute this task using the skill at <path-to-skill>:
- Task: <eval prompt>
- Input files: <eval files if any, or "none">
- Save outputs to: <workspace>/iteration-<N>/eval-<ID>/with_skill/outputs/
- Outputs to save: <what the user cares about>
```

**Baseline run** (same prompt, no skill):
- **New skill**: no skill at all — same prompt, save to `without_skill/outputs/`
- **Improving existing skill**: old version as baseline — snapshot first (`cp -r <skill-path> <workspace>/skill-snapshot/`), point baseline at snapshot

Write an `eval_metadata.json` for each test case (assertions can be empty for now). Give each eval a descriptive name:
```json
{
  "eval_id": 0,
  "eval_name": "descriptive-name-here",
  "prompt": "The user's task prompt",
  "assertions": []
}
```

### Step 2: While runs are in progress, draft assertions

Use this time to draft quantitative assertions and explain them to the user. Good assertions are objectively verifiable and have descriptive names.

Update `eval_metadata.json` files and `evals/evals.json` with assertions once drafted.

### Step 3: Capture timing data

When each subagent task completes, save timing data to `timing.json` in the run directory:
```json
{
  "total_tokens": 84852,
  "duration_ms": 23332,
  "total_duration_seconds": 23.3
}
```

### Step 4: Grade and aggregate

1. **Grade each run** — evaluate each assertion against the outputs. Save to `grading.json` in each run directory using these exact fields: `text`, `passed`, `evidence` (not `name`/`met`/`details`).

2. **Aggregate into benchmark** — produce a `benchmark.md` with pass_rate, time, and tokens for each configuration, with mean ± stddev and the delta.

3. **Do an analyst pass** — surface patterns the aggregate stats might hide: assertions that always pass regardless of skill (non-discriminating), high-variance evals (possibly flaky), time/token tradeoffs.

4. **Present results to the user** — show both qualitative outputs and quantitative data. Tell the user: "Here are the results. The with-skill outputs are in X, and I've put together a benchmark summary in Y. When you've reviewed, let me know your feedback."

### Step 5: Read the feedback

After the user reviews, collect their feedback and note which test cases had issues. Empty feedback means they thought it was fine.

---

## Improving the Skill

### How to think about improvements

1. **Generalize from feedback.** You're trying to create skills that work across many different prompts, not just the test examples. Rather than fiddly overfitty changes or oppressively constrictive MUSTs, try different metaphors or patterns. It's cheap to experiment.

2. **Keep the skill lean.** Remove things that aren't pulling their weight. Read the transcripts, not just the final outputs — if the skill is making the agent waste time on unproductive steps, trim those parts.

3. **Explain the why.** Try hard to explain the *why* behind everything you're asking the agent to do. Today's LLMs are smart — when given a good harness they can go beyond rote instructions. Reframe rigid ALWAYS/NEVER rules into explanations of the reasoning.

4. **Look for repeated work.** If all test cases resulted in the agent independently writing similar helper scripts, that's a signal the skill should bundle that script. Write it once in `scripts/` and tell the skill to use it.

### The iteration loop

After improving the skill:
1. Apply improvements to the skill
2. Rerun all test cases into a new `iteration-<N+1>/` directory, including baseline runs
3. Show the user the new results alongside previous results
4. Wait for the user to review and provide feedback
5. Read feedback, improve again, repeat

Keep going until:
- The user says they're happy
- All feedback is empty (everything looks good)
- You're not making meaningful progress

---

## Description Optimization

The description field is the primary mechanism that determines whether the agent invokes a skill. After creating or improving a skill, offer to optimize the description for better triggering accuracy.

### Step 1: Generate trigger eval queries

Create 20 eval queries — a mix of should-trigger and should-not-trigger. Save as JSON:

```json
[
  {"query": "the user prompt", "should_trigger": true},
  {"query": "another prompt", "should_trigger": false}
]
```

Queries must be realistic and specific. Include file paths, personal context, column names, company names, URLs, a little backstory. Some in lowercase, with abbreviations or typos. Mix different lengths, focus on edge cases.

**Should-trigger (8-10):** Different phrasings of the same intent — some formal, some casual. Include cases where the user doesn't explicitly name the skill but clearly needs it. Include uncommon use cases and cases where this skill competes with another but should win.

**Should-not-trigger (8-10):** Near-misses — queries that share keywords but actually need something different. Adjacent domains, ambiguous phrasing where a naive keyword match would trigger but shouldn't. Avoid obviously irrelevant negatives — make them genuinely tricky.

### Step 2: Review with user

Present the eval set to the user and let them review, edit, and approve before running the optimization.

### Step 3: Run the optimization loop

Iteratively:
1. Test the current description against the eval set (run each query, check whether the agent triggers the skill)
2. Identify failures — queries that should have triggered but didn't, or shouldn't have triggered but did
3. Propose an improved description based on what failed
4. Re-evaluate on both train and test splits (to avoid overfitting)
5. Repeat up to 5 iterations, selecting the best description by test score

### Step 4: Apply the result

Update the skill's SKILL.md frontmatter with the optimized description. Show the user before/after and report the scores.

---

## How skill triggering works in OpenCode

Skills appear in the agent's `skill` tool description with their name and description. The agent loads a skill by calling:
```js
skill({ name: "skill-name" })
```

The agent only consults skills for tasks it can't easily handle on its own — simple one-step queries may not trigger a skill even if the description matches. Complex, multi-step, or specialized queries reliably trigger skills when the description matches.

This means eval queries should be substantive enough that the agent would actually benefit from consulting a skill.

---

## Core loop (summary)

1. Figure out what the skill is about
2. Draft or edit the skill
3. Run the agent-with-access-to-the-skill on test prompts
4. With the user, evaluate the outputs (qualitative review + quantitative benchmarks)
5. Improve and repeat until satisfied
6. Optimize the description for triggering accuracy
