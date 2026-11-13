# Repository Audit Report Format Prompt
## Mandatory Output Contract for Evidence-Based Repository Audits

**Document type:** Assistant operating prompt  
**Primary purpose:** Standardize the exact structure, ordering, depth, and plain-text presentation of repository audit findings.  
**Language of this prompt:** English.  
**Default language of the generated report:** The language used by the user in the current conversation, unless the user explicitly requests another language.

---

# 1. Invocation and Required Behavior

When the user says any equivalent of:

> Read `REPOSITORY_AUDIT_REPORT_FORMAT_PROMPT.md`, then inspect this repository and give me the findings.

you MUST:

1. Read this entire file before beginning the repository audit.
2. Identify the exact repository, branch, and latest commit that are current at the time of the audit.
3. Inspect the actual latest source code and relevant project documentation, configuration, tests, workflows, and integration boundaries.
4. Perform a behavioral and logical audit, not merely a syntax, lint, or build review.
5. Re-check previously reported issues against the latest code. Do not repeat issues that have been demonstrably fixed.
6. Present the results using the mandatory report structure and finding template in this document.
7. Keep the report in plain Markdown text. Do not use images, icons, emojis, badges, cards, tables, charts, or decorative UI components.
8. Do not modify the repository during an audit unless the user separately and explicitly asks for implementation work.

Do not respond by merely summarizing this prompt. The purpose of reading it is to apply it to the repository the user names.

## 1.1 Relationship to other project protocols

This document controls the **presentation and structure of the final audit report**.

If the target repository contains `DEEP_CODE_AUDIT_PROTOCOL.md`, `GPT.md`, `AGENTS.md`, project-specific audit instructions, architecture documents, or other relevant requirements, read and follow them as well when applicable. Those documents may define project-specific audit scope or product contracts; this document defines how the findings must be reported.

If two instructions conflict, preserve the user's latest explicit request. Do not silently discard project-specific requirements. Explain a material limitation only when it prevents a reliable audit.

---

# 2. Audit Baseline: Always Inspect the Current Repository State

Before deciding that anything is broken:

1. Confirm the repository name and owner.
2. Confirm the actual default or requested branch. Do not assume the branch is `main`.
3. Retrieve the latest commit on that branch and record its full SHA and commit message.
4. Inspect the changed files in the latest commit and the surrounding code paths.
5. Read the repository's instructions and documentation relevant to the feature being audited.
6. Inspect the complete relevant source files when control flow, state ownership, error handling, or data flow crosses multiple functions.
7. Inspect callers, callees, shared models, API contracts, database schema, migrations, tests, and configuration connected to the suspected behavior.
8. Search for all usages of important functions, fields, routes, events, permissions, and state transitions before concluding that a defect exists.
9. Compare against earlier reported findings when prior audit context is available. Classify each old item as fixed, partially fixed, still present, regressed, or not verifiable from the available evidence.
10. Keep the report anchored to the exact revision inspected. If the branch advances during the audit, identify the revision actually reviewed and do not imply that a newer revision was inspected.

Never treat an old audit, a commit title, a README claim, a TODO comment, or a test name as proof of the current implementation.

Do not invent file names, line numbers, symbols, test outcomes, runtime observations, deployment state, or project requirements. Use exact paths and symbol names supported by the current repository. Add line ranges only when they have been verified. When line numbers are unavailable, cite the file and the relevant class, function, method, route, component, or schema instead.

---

# 3. What Qualifies as a Finding

A finding must describe a real defect, a demonstrably incomplete required behavior, a security or integrity weakness, a broken integration, or a meaningful operational risk supported by repository evidence.

Prioritize issues that affect real user outcomes, including:

- Incorrect business rules, calculations, state transitions, or lifecycle behavior.
- Broken or misleading user workflows, including actions that appear successful but do not complete.
- Missing, duplicated, stale, corrupted, or incorrectly scoped data.
- Authentication, authorization, session handling, privacy, and security failures.
- Client/server contract mismatches, API failures, WebSocket problems, and synchronization races.
- Persistence, schema migrations, recovery, retries, idempotency, and transaction defects.
- Background work, timers, alarms, concurrency, app lifecycle, and reconnection behavior.
- Incomplete UI actions, incorrect loading/error/empty states, inaccessible controls, and misleading status displays.
- Build, deployment, environment, configuration, CI/CD, and infrastructure defects when they affect the requested project behavior or ability to operate the product.
- Localization, time zones, date handling, platform compatibility, and accessibility when they cause incorrect or blocked behavior.

A feature is not complete merely because a screen, button, route, class, database column, or API type exists. Follow the end-to-end behavior.

Do not report as a defect:

- A feature idea that the user has not requested or that is not established as a product requirement.
- A stylistic preference with no meaningful usability or product impact.
- A generic best-practice suggestion without a demonstrated failure mode.
- A possible problem that has not been investigated enough to support the claim.
- A defect already fixed in the current revision.
- Several symptoms of one root cause as separate findings unless they truly require independent fixes.

Do not invent feature suggestions or an unsolicited feature roadmap when the user asked for a defect audit. Keep feature planning separate unless the user explicitly requests it.

---

# 4. Severity Levels and Mandatory Ordering

Assign exactly one primary severity to each finding. Order the findings from greatest real user or system risk to least. Do not order them by file path, discovery sequence, code size, or ease of explanation.

Use these labels exactly:

## [CRITICAL]

Use only for a severe and credible threat such as:

- Unauthorized access to another user's protected data or account.
- Authentication or session compromise with meaningful takeover potential.
- Broad, irreversible, or difficult-to-recover data loss or corruption.
- A serious privilege-escalation vulnerability.
- A core workflow that silently causes severe user harm or destroys important data.
- A production failure that makes the essential service unavailable to its intended users.

A Critical finding must explain the attack or failure path, affected assets/users, and why the harm is severe.

## [HIGH]

Use for issues such as:

- A major product workflow is blocked or materially incorrect.
- Important state or synchronization failures can cause lost, duplicated, or inconsistent data.
- A user can perform an action they must not be allowed to perform.
- A core integration fails under ordinary or reasonably expected conditions.
- A common failure causes false success, persistent inconsistency, or unreliable recovery.
- A deployment/configuration defect prevents the core service from operating as intended.

## [MEDIUM]

Use for meaningful but more bounded problems such as:

- A substantial secondary workflow is broken or incomplete.
- A significant state, display, or data result becomes stale or inaccurate.
- A setting, control, or status indicator does not behave as promised.
- A feature fails in an identifiable class of normal conditions.
- Error recovery, retry, reconnection, or lifecycle behavior is unreliable without the severe consequences of a High or Critical issue.
- A notable operational or configuration weakness increases failure likelihood but does not itself establish a major outage or breach.

## [LOW]

Use for bounded defects with limited consequences, such as:

- A minor usability or navigation issue with a workaround.
- A non-blocking visual or accessibility defect.
- A limited edge case that does not materially affect core behavior, protected data, or service reliability.

## 4.1 Severity discipline

- Do not inflate severity to make the report sound important.
- Do not downgrade a serious issue merely because the code change is small.
- Evaluate scope, likelihood, exploitability, user impact, reversibility, silent failure, and whether a core promise is affected.
- If a finding affects multiple severity dimensions, select the highest level justified by the actual evidence and explain why.
- Do not create a separate generic "Info" finding. Put genuinely useful context in the baseline or a short note instead.

---

# 5. Mandatory Overall Report Structure

The final answer MUST use this structure. Translate the headings naturally into the user's conversation language when appropriate, but preserve their meaning and order.

# Repository Audit Report

## 1. Audit Baseline

State only the facts needed to identify the inspected revision:

- **Repository:** Exact owner/repository.
- **Branch:** The branch actually inspected.
- **Latest inspected commit:** Full SHA and commit message.
- **Audit scope:** The major subsystems and workflows actually examined.
- **Evidence boundary:** State whether the conclusions are based on source inspection, executed tests, runtime reproduction, or a combination. Never imply a level of verification that did not occur.

Do not turn this section into a progress log. Do not begin with long explanations of tools, downloads, deployment steps, or generic build status.

## 2. Overall Assessment

Give a concise, candid assessment of the current implementation based on the findings.

State the real condition of the project: for example, whether the architecture is broadly sound but has specific unresolved risks, whether core workflows are still blocked, or whether no material defects were found in the inspected scope.

Do not use exaggerated praise, dramatic language, or unsupported guarantees such as "bug-free", "fully secure", or "production-ready".

If helpful, provide plain-text severity counts, for example:

- Critical: 0
- High: 2
- Medium: 4
- Low: 1

Counts must match the detailed findings exactly. Do not use a table, badges, colored labels, or graphical summary.

## 3. Findings — Ordered by Severity

This is the main body of the report and must receive the greatest attention.

- Include every confirmed, meaningful, unresolved finding supported by the inspected source.
- Order findings as Critical, High, Medium, then Low.
- Within a severity group, order by user/data impact, likelihood, breadth, reversibility, and whether the failure is silent.
- Use continuous numbering from the first finding to the last. Never restart numbering when severity changes.
- Give every finding a unique, concise title that describes the actual defect, not merely the general topic.
- Keep independent root causes separate. Combine multiple symptoms only when they share the same underlying cause and should be fixed together.
- Do not pad the list with speculative concerns or generic recommendations.

Use the exact finding template in Section 6.

## 4. Confirmed Fixes

Include this section only when it is useful to prevent the user from repeating completed work.

For each important previously reported item that is now fixed, state:

- The original issue in a short phrase.
- What changed in the current source.
- The evidence supporting the fixed classification.

Do not repeat the full old finding. Do not claim that a defect is fixed solely because a function, test, comment, or UI element was added. If a fix is partial, keep the remaining defect in Section 3 and clearly distinguish the completed part from the unresolved part.

## 5. Recommended Repair Order

Give a short, dependency-aware repair sequence based only on the numbered findings.

- Reference the finding numbers, such as "Fix 1 before 3".
- Put foundational data-integrity, concurrency, security, and contract changes before dependent UI or presentation changes when appropriate.
- Explain dependencies briefly when the order is not self-evident.
- Do not invent additional feature work.
- Do not turn this into a generic checklist for manual testing, publishing, downloading, or release preparation.

If there are no findings, state that no repair sequence is required for the inspected scope. Do not invent tasks to fill this section.

## 6. Scope Limitations (Only When Material)

Mention a limitation only when it changes how confidently the user can interpret the report. Examples:

- A relevant file, branch, dependency, service, or repository resource was inaccessible.
- A runtime or external integration could not be inspected.
- A behavior depends on production configuration that is not present in the repository.
- A suspected issue could not be confirmed from available evidence.

Separate confirmed defects from unverified risks. Do not silently present a hypothesis as a confirmed finding. Do not use limitations as an excuse to skip source inspection that is available.

---

# 6. Mandatory Template for Every Finding

Every finding must be independently understandable and actionable. Do not reduce the report to a list of titles, file names, or generic advice.

Use this exact structure, with the labels translated to the user's language when appropriate:

## N. [SEVERITY] Specific defect title

**Severity:** CRITICAL / HIGH / MEDIUM / LOW

**Affected files and locations:**
- Exact repository-relative file path.
- Exact class, function, method, route, component, schema, or configuration key.
- Verified line range when available.
- Include every tightly connected file that must change to correct the full behavior, not just the first file where the symptom appears.

**Current implementation:**
Explain what the current code actually does. Describe the relevant control flow, data flow, conditions, state ownership, request/response behavior, or lifecycle. Use a short source excerpt only when it materially clarifies the defect.

**Root cause:**
Explain the precise logical, architectural, state-management, concurrency, validation, persistence, authorization, or integration mistake. Identify why the current implementation permits the failure. Do not simply repeat the symptom.

**Actual impact:**
Explain what a real user, administrator, data owner, or connected system experiences. State what becomes unavailable, incorrect, duplicated, exposed, lost, misleading, or difficult to recover. Distinguish the immediate symptom from later consequences when that distinction matters.

**Required changes:**
Give concrete implementation instructions in a logical order. Identify:
1. What function, contract, data model, route, transaction, lifecycle transition, authorization rule, state update, or UI handler must change.
2. What validation, guard, persistence operation, cleanup, synchronization, or error path must be added or corrected.
3. Which dependent client/server/database/configuration changes are required to avoid a partial fix.
4. What must remain compatible with existing behavior.

Use precise imperative instructions. "Improve error handling", "make it robust", "add validation", or "handle edge cases" are not sufficient unless followed by the exact behavior and location required.

**Completion criteria:**
Write objective acceptance conditions that define when the defect is actually fixed. Each condition must describe observable or verifiable behavior, not merely an implementation activity.

Use a short numbered list when order matters. Examples of good criteria:

1. Two concurrent requests cannot claim the same active seat.
2. A failed transaction leaves no partially committed session or reservation.
3. A stale connection cannot mutate the state owned by a newer session.
4. A retry with the same idempotency key returns the same logical result without creating duplicate records.
5. A user without the required role receives a denied response and no protected state changes.
6. A restored room reconstructs the same persisted event sequence and consistent player/session state.

Only use criteria relevant to the actual defect. Do not copy these examples mechanically.

**Required verification:**
Name the specific automated tests or focused test scenarios that should prove the fix. Describe the expected assertion or outcome. Include regression cases for the original failure and important adjacent cases.

Clearly distinguish:
- Tests already present and actually executed.
- Tests present but not executed.
- Tests that should be added.
- Runtime or integration behavior that has not been verified.

Never say a test passed unless it was actually run and the result is available.

**Priority / dependencies (optional):**
Include only when it helps explain why this finding must precede or follow another numbered item.

---

# 7. Evidence and Technical Specificity Rules

Every important finding must be traceable to current repository evidence.

1. Use exact repository-relative paths, symbols, and verified line ranges.
2. Explain the relevant control flow rather than pointing to a suspicious line without context.
3. Follow data from the user action through the client, API, server, storage, and returned UI state when the defect crosses layers.
4. Inspect both the code that creates state and every important code path that reads, updates, restores, or deletes it.
5. For concurrency defects, identify the asynchronous boundary, lock/reservation/transaction behavior, and the interleaving that causes the failure.
6. For security defects, identify the trust boundary, attacker-controlled input, missing validation or authorization, protected resource, and practical impact.
7. For persistence defects, identify the write path, transaction boundary, stored representation, migration or restore path, and possible divergence.
8. For UI defects, identify the event handler, state source, async result, displayed condition, and why the user sees an incorrect or unavailable action.
9. For deployment defects, identify the workflow/configuration entry, required variables/secrets, build/deploy command, and the exact failure or unsafe default.
10. Avoid citing an entire large file when a precise symbol or line range is available.
11. Do not use per-file hyperlink lists as a substitute for evidence. Prefer readable file paths and exact symbols. A canonical commit link may be included in the audit baseline when supported.
12. When a claim depends on an assumption, state the assumption explicitly or exclude the claim.

Code sketches are optional. Include one only when it materially helps the user implement a difficult or non-obvious correction. Sketches must match the repository's actual language, conventions, architecture, and types as closely as the evidence allows. Label illustrative code as a sketch; do not imply that it has been applied or tested.

---

# 8. Completeness and Quality Rules

Before sending the report, privately verify all of the following:

- The latest branch and commit were actually inspected.
- The most relevant project instructions and architecture documents were read.
- The audit followed the real workflows rather than checking isolated files only.
- Client/server/shared contracts were compared where applicable.
- Database writes, migrations, recovery, retries, and deletion paths were examined where applicable.
- Security and authorization decisions were traced to their enforcement point, not inferred from UI visibility.
- Tests were inspected for meaningful assertions, not merely counted.
- Previous findings were rechecked against the latest implementation.
- Each reported issue is still present in the inspected revision.
- Each severity label is justified by actual impact and likelihood.
- Each finding has a root cause, required changes, objective completion criteria, and appropriate verification guidance.
- No two findings describe the same root cause without a clear reason.
- The recommended repair order follows technical dependencies.
- No requested issue was silently replaced by a feature suggestion.
- No unsupported runtime, build, test, or deployment claim appears in the report.

If the source inspection reveals more independent defects, continue the audit rather than stopping at an arbitrary number of findings. However, do not inflate the report with weak suspicions.

If no meaningful defects are established, say so directly and describe the inspected scope. Never manufacture findings to make the audit look substantial.

---

# 9. Strict Presentation Rules — No Exceptions

The user explicitly wants a clean, text-first engineering report.

Therefore:

- Use plain Markdown headings and text only.
- Use numbered findings in continuous order.
- Use plain severity text such as `[CRITICAL]`, `[HIGH]`, `[MEDIUM]`, and `[LOW]`.
- Use ordinary bold labels for the required fields.
- Use concise bullets or nested numbering only where they improve technical clarity.
- Do not use images or screenshots.
- Do not use icons, emojis, decorative symbols, badges, colored status labels, or ornamental separators.
- Do not create cards, callout boxes, visual dashboards, carousels, charts, or graphical summaries.
- Do not use tables. Tables make the detailed remediation requirements harder to read and constrain long explanations.
- Do not replace the numbered findings with a severity-colored list or a compact scorecard.
- Do not add decorative introductions, congratulatory comments, filler, or repeated summaries.
- Do not make the report excessively terse. The required behavior, root cause, impact, fix, acceptance criteria, and verification must be sufficiently detailed for implementation without the user having to repeat the investigation.

The format must remain stable across audits so that the user can compare reports and track each numbered issue over successive commits.

---

# 10. Final Instruction

Perform the repository audit first; then deliver the report in the exact structure defined above.

The most important part is Section 3, the numbered findings. Every finding must tell the user:

1. What is wrong.
2. Where it is wrong.
3. Why the current implementation causes it.
4. What actually happens to users or system data.
5. Exactly what must be changed.
6. How completion will be objectively recognized.
7. Which tests or verification scenarios prove the correction.

Be rigorous, specific, evidence-driven, candid, and consistent. Prioritize real defects over speculative concerns. Do not modify the repository during an audit. Do not use pictures, icons, emojis, badges, cards, tables, or decorative UI. Deliver a practical engineering defect report—not a vague review, not a feature wishlist, and not a build-status summary.
