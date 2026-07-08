# Insurance Claims Exploratory Analysis (SQL)

An exploratory, BI-style analysis of the same insurance claims dataset used in the [R distribution-fitting project](../distribution-fitting-insurance-claims), written and run in SQL Server (SSMS). Where that project asked *"what distribution best describes claim amounts?"*, this project asks the more operational question: *"who are the policyholders, and how do income, claims, and demographics relate to one another?"*

## Overview

This project uses `GROUP BY` aggregations to profile the `insurance_dataset` table (n = 13,000) across gender, age, marital status, occupation, and education, then relates those segments to income and claim behavior.

## Dataset

- **Source:** Kaggle — Insurance Claims Dataset (same source as [Distribution Fitting on Insurance Claims Data (R)](../distribution-fitting-insurance-claims))
- **Table:** `insurance_dataset`
- **Key fields used:** `Gender`, `Age`, `Marital_Status`, `Occupation`, `Education`, `Income`, `Claim_Amount`
- **Tool:** Microsoft SQL Server Management Studio (SSMS)

## Queries

| # | Question | Grouping |
|---|---|---|
| 1 | What's the average age of policyholders by gender? | Gender |
| 2 | Who are the youngest and oldest policyholders, by gender? | Gender |
| 3 | What are total claims and total income by gender? | Gender |
| 4 | What's total income by marital status? | Marital status |
| 5 | How does income vary by occupation and marital status? | Occupation, Marital status |
| 6 | How does income vary by education level? | Education |
| 7 | What's the count, average, and range of claims and income by gender? | Gender |
| 8 | How many claims come from each occupation/marital-status segment? | Occupation, Marital status |

## Key Findings

**Age is essentially identical across gender.** Both male and female policyholders average **51 years old**, with the same range at both ends (**18 to 102**). Age isn't a differentiator between the two groups in this dataset.

**Income and claim volume are close between genders, with a slight female skew.** Female policyholders logged marginally more total claims (6,541 vs. 6,459) and a higher total income (~$1.054B vs. ~$1.049B) than males. On a per-claim basis, females also had a slightly higher average claim amount ($9,237 vs. $9,132) and a slightly higher largest claim ($99,841 vs. $99,789). The differences are small in relative terms (roughly 1%), so this reads more as balance than a meaningful gender effect.

**Marital status shows almost no income difference.** Total income for Married ($1,051,169,791) and Single ($1,051,169,825) policyholders differs by only $34 — functionally identical, and likely just a reflection of similar group sizes rather than any real distinction.

**Education shows a mild, non-linear income effect.** Average income was highest for PhD holders ($161,909), followed closely by Bachelor's ($161,729) and Master's ($161,519) — a ~$400 spread across all three. Every education level shares the same max income ceiling ($404,428) and a similar income floor (~$5,000–5,400), suggesting income here is more driven by occupation than by degree level.

**Occupation drives the widest income differences.** Across all five occupations, average income ranges from **$116,978** (Teacher, Single) up to **$169,406** (CEO, Married) — a roughly 45% spread between the lowest- and highest-earning segments:

| Occupation | Marital Status | Avg Income | Highest Income | Lowest Income |
|---|---|---|---|---|
| CEO | Married | $169,406 | $404,428 | $5,409 |
| CEO | Single | $168,444 | $404,428 | $5,301 |
| Waiter | Single | $142,026 | $404,428 | $6,128 |
| Engineer | Single | $138,401 | $404,428 | $6,015 |
| Waiter | Married | $131,506 | $404,428 | $5,593 |
| Engineer | Married | $131,171 | $404,428 | $5,159 |
| Teacher | Married | $130,167 | $404,428 | $5,249 |
| Doctor | Married | $127,285 | $404,428 | $5,314 |
| Doctor | Single | $124,139 | $404,428 | $5,091 |
| Teacher | Single | $116,978 | $404,428 | $6,556 |

Every single occupation/marital-status segment shares the exact same income ceiling ($404,428) and a similar income floor (~$5,000–6,500). That's a strong signal: the very top and bottom earners aren't concentrated in one occupation — they're spread evenly across all of them, which points to income having an occupation-independent component (or a data-generation artifact worth checking, since a shared max across every single group is an unusual coincidence in real-world data).

**Claim counts by occupation are heavily concentrated among CEOs.** CEOs logged 5,275 (Married) and 5,300 (Single) claims — roughly **17x more** than every other occupation, which all cluster tightly between 283 and 320 claims regardless of occupation or marital status (Doctors, Engineers, Teachers, and Waiters are all within the same narrow band). That tight clustering among five otherwise-different occupations, next to one massive outlier, is the kind of pattern worth verifying against the raw data before publishing as a finding — for example, checking whether CEOs are simply overrepresented as a category (`SELECT Occupation, COUNT(*) FROM insurance_dataset GROUP BY Occupation`) versus genuinely filing claims at a higher rate.

## Relation to the Other Projects

| | Project 1 (Simulated, R) | Project 2 (Kaggle claims, R) | Project 3 (this project, SQL) |
|---|---|---|---|
| Question | What distribution fits the data? | What distribution fits real claims data? | Who are the policyholders behind the claims? |
| Method | KDE / likelihood fitting / Cullen-Frey | Same, at scale (n = 13,000) | SQL aggregation by demographic segment |
| Output | Best-fit distribution (lognormal) | Best-fit distribution (BCPE) | Descriptive profile by gender, age, occupation, education |

Together, the three projects move from *"what shape does claims data take"* (distributional) to *"who is driving that shape"* (demographic/segment-level).

## Project Structure

```
insurance_claims_analysis.sql   # Full annotated query set
```

## How to Run

Open `insurance_claims_analysis.sql` in SSMS (or any SQL Server-compatible client) against a database containing the `insurance_dataset` table, and run the queries individually or as a batch.

## Limitations

- These are descriptive/aggregate queries only — no statistical significance testing (e.g., t-tests, ANOVA) is applied to the differences observed between segments.
- `AVG()` on `Income` and `Claim_Amount` is sensitive to outliers; given the heavy right skew documented in Project 2's distribution-fitting analysis, medians may be more representative than means for some of these breakdowns.
- No date/time dimension is used, so this is a cross-sectional snapshot rather than a trend analysis.
