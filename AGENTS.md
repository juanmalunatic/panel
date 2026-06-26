# AGENTS.md

Small commit.
This repository contains course materials for Panel Data Econometrics.

When answering content questions:
- Prefer `.txt` transcript files for lecture content and summaries.
- Prefer `.tsv` transcript files when the user asks where a topic is discussed or needs timestamps.
- Do not use Whisper `.json` files unless explicitly requested; they contain noisy metadata.
- Use `.vtt` / `.srt` only for subtitle-related tasks.
- If a folder has its own README.md or AGENTS.md, read it before analyzing files in that folder.

For lecture questions, synthesize across slides, problem sets, solutions, and transcripts when available.

## Study workflow and practical-class lookup

The user's intended study workflow is practical-video-first:
1. For each practical video/class, first read only the necessary theoretical prerequisites.
   - Main source: 2026 slides under `Theory/`.
   - Supplement: 2024 theory transcripts, when available, for intuition and verbal explanation.
   - Keep this prereq pass short and operational: what the topic is, why it is used, and what to watch for in the practice. Do not turn it into a deep theory dive unless the user asks.
2. Then follow the corresponding 2023 practical video transcript/do-file and implement what is done there.
3. Use `ProblemSet/` and solutions as the exercise spine.
4. Use `PracticalNotes/` as the 2026 alignment/evidence for what the practical classes actually covered.

Use the following working map as the fast lookup. It is based on the 2023 practical-video map plus the 2026 PracticalNotes alignment. Treat it as a study spine, not as proof that every exercise/inciso was fully covered.

| Practical video/class | Theory prereq, short operational version | Problem set coverage | PracticalNotes alignment / 2026 evidence |
|---|---|---|---|
| P01 | OLS/matrix algebra review: design matrix, OLS formula, residuals/SRC, variance of beta-hat, standard errors, t-statistics, Cholesky/GLS mechanics. | PS0: ex1, ex2, ex3 partial/fast. | Clase 1 matches PS0 algebra/MCO. Clase 2 begins by closing PS0 ex3. |
| P02 | Heteroskedasticity and serial correlation in linear models: robust SEs, FGLS/GLS, White-style variance modeling, clustered VCE, Prais-Winsten / AR(1) correction. | PS1: ex1, ex2, ex3 in the 2023 map. | Clase 2 covers PS1 ex1. Clase 3 clearly covers PS1 ex2. No strong 2026-note evidence yet for PS1 ex3. |
| P03 | Linear panel models: unobserved heterogeneity, composite error, POLS vs RE/FE, strict exogeneity, within transformation, first differences, interpretation of time-invariant regressors. | PS2: ex1, ex2. | Clase 3 starts PS2 with FE/RE/within/FD. Clase 4 covers PS2 material, especially ex2. |
| P04 | Linear panel continuation: FE/RE/FD implementation details, time dummies in first differences, Hausman logic, clustered variance-covariance in panel data, possible two-way effects. | PS2: ex3, ex4 in the 2023 map. | Clase 4 is official 2026-used material even if labeled 2025. It states PS2 ex2 and ex3, and visibly covers PS2 ex2/Hausman/FD/exogeneity. No clear 2026-note evidence for PS2 ex4. |
| P05 | Dynamic panels intro: lagged dependent variable, why OLS overestimates persistence, FE/Nickell bias, FD endogeneity, Anderson-Hsiao, Arellano-Bond intuition. | PS3: ex1, calculations and intuition; incomplete. | Clase 5 matches PS3 ex1 very strongly. |
| P06 | Dynamic panels continuation: Arellano-Bond instruments, instrument relevance/exogeneity, too many instruments, collapse, Blundell-Bond / system GMM, LSDV/LSDVC and inference. | PS3: closes ex1, then ex2, ex3, ex4. | Clase 6 matches the 2023 P06 map very strongly. |
| P07 | Unbalanced panels and selection: rotating panels, attrition, incidental truncation, censored vs truncated variables, FE under selection, Wooldridge (1995), Mundlak and Chamberlain selection tests. | PS4: ex1 + ex2(a-b). | Clase 7 covers PS4 ex1 and PS4 ex2(a-b), and sets up bootstrap/variance for the next class. |
| P08 | Sample-selection correction inference: inverse Mills ratio as generated regressor, why the usual VCOV breaks, bootstrap vs analytic asymptotic VCOV. Also, in 2023 this class seems to start binary dependent-variable models. | PS4: ex2 variance/bootstrap. 2023 map also says PS5 ex1(a-c). | Clase 8 visibly covers PS4 ex2 variance/bootstrap. No 2026-note evidence for PS5 in Clase 8. |
| P09 | Binary dependent-variable panel models: LPM, pooled Probit/Logit, marginal effects, delta method, unobserved heterogeneity in nonlinear models, RE/FE limitations and interpretation. | PS5: ex1(d-g) + ex2 in the 2023 map. | Clase 9 covers PS5 ex1 from the beginning (a-c as well as later parts) and starts PS5 ex2. |

Important open coverage flags for review after the first study pass:
- PS1 ex3: no strong evidence in the 2026 PracticalNotes transcribed so far.
- PS2 ex4: no strong evidence in the 2026 PracticalNotes transcribed so far.
- PS5 ex2 beyond the initial parts: only partial evidence in Clase 9.
- P08 differs slightly across sources: 2023 map says PS5 ex1(a-c) starts there, but 2026 PracticalNotes show only PS4 ex2 inference/variance work.

When the user asks for a study plan, prefer progressing through this map in order rather than rebuilding the whole system. The default unit of exposed action is: short theory prereq pass -> watch/implement one practical video -> update solved exercises/log -> move on.