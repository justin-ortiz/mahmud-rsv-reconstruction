# Reconstruction of the Mahmud et al. maternal RSV vaccine impact model

This repository holds our reconstruction of the acute RSV impact model for maternal RSV vaccination published by Mahmud et al. (BMC Medicine 2023;21:138), for the 2025 birth cohort in low- and middle-income countries. We rebuilt the model in R from the published paper and its Additional file 1. We did not use the UNIVAC software and did not contact the authors.

This is the one place the reconstruction is edited. Our papers that use it keep a copy of a numbered version and say which version they used.

## Versions

| Version | Date | What changed | Used by |
|---|---|---|---|
| 1.0 | 1 November 2026 | The reconstruction as used in the delay paper preprint (Research Square, 24 October 2026) and the asthma analysis results of 24 October 2026. | rsv-maternal-delay-gavi, rsv-asthma-maternal-lmic |

## Files

    mahmud_model.R                    the published model as R functions
    mahmud_inputs.csv                 income group, maternal coverage, and RSV rates per 100,000, by country
    mahmud_bounds.csv                 the uncertainty bounds of the RSV rates, by income group
    mahmud_cohort_2025.csv            births, person-years from birth to 5, and life expectancy, 2025 cohort
    00b_ingest_wpp2019.R              builds mahmud_cohort_2025.csv from the wpp2019 R package
    replicate_mahmud.R                compares our results with the published totals
    results_replication.csv           outcomes prevented, ours and published
    results_replication_baseline.csv  outcomes with no vaccination, ours and published

## How to check the reconstruction

1. Download this repository as a zip file from the green Code button and unzip it.
2. Open `replicate_mahmud.R` in RStudio.
3. Set the working folder with Session, Set Working Directory, To Source File Location.
4. Run the whole file. It prints our totals next to the published totals and writes the two results files.

The published totals are in Mahmud et al., Additional file 1, Table S12, UNIVAC column. Outcomes prevented are the Baseline rows minus the Vaccine rows.

## Agreement with the published totals, version 1.0

| Outcome | Prevented | No vaccination |
|---|---|---|
| Cases | −0.7% | −2.0% |
| Admissions | −0.6% | −1.9% |
| Deaths | −1.1% | −2.4% |
| DALYs | −0.1% | −0.2% |

## Source

Mahmud S, Baral R, Sanderson C, Pecenka C, Jit M, Li Y, Clark A. Cost-effectiveness of pharmaceutical strategies to prevent respiratory syncytial virus disease in young children: a decision-support model for use in low-income and middle-income countries. BMC Med 2023;21:138. doi:10.1186/s12916-023-02827-5.
