# Births and person-years for the 2025 birth cohort, from the UN annual
# estimates the published model says it used (Mahmud et al., main paper,
# page 5: births from UN projections by calendar year, and person-years
# from UN interpolated single age/year population estimates).
#
# Added in version 1.1. It replaces three columns of mahmud_cohort_2025.csv:
#   births_2025    live births in calendar 2025
#   PY_0to5        person-years lived from birth to age 5 by the 2025 cohort
#   PY_per_birth   PY_0to5 divided by births_2025
# The life expectancy columns (e0, e0_discounted) are not changed. They
# come from 00b_ingest_wpp2019.R.
#
# Source files, in the data-raw folder. Both are from UN World Population
# Prospects 2019, Rev. 1, folder 5_Interpolated of WPP2019-Excel-files.zip
# in the UN WPP archive (population.un.org/wpp). We use the MEDIUM VARIANT
# sheet of each.
#   WPP2019_INT_F01_ANNUAL_DEMOGRAPHIC_INDICATORS.xlsx       births
#   WPP2019_INT_F03_1_POPULATION_BY_AGE_ANNUAL_BOTH_SEXES.xlsx  population by single age
#
# This script needs the readxl package to open the Excel files. Install it
# once with install.packages("readxl"). The rest of the code is base R.
#
# Run the whole file. It prints Kenya as a check and rewrites
# mahmud_cohort_2025.csv.

library(readxl)

f01 <- "data-raw/WPP2019_INT_F01_ANNUAL_DEMOGRAPHIC_INDICATORS.xlsx"
f03 <- "data-raw/WPP2019_INT_F03_1_POPULATION_BY_AGE_ANNUAL_BOTH_SEXES.xlsx"

# The first 16 rows of each sheet are titles. Row 17 holds the column names.
# Some cells for regions hold "..." for missing values, so Excel columns can
# come in as text. as.numeric() turns the numbers back into numbers.
births <- as.data.frame(read_excel(f01, sheet = "MEDIUM VARIANT", skip = 16))
pop    <- as.data.frame(read_excel(f03, sheet = "MEDIUM VARIANT", skip = 16))

cohort <- read.csv("mahmud_cohort_2025.csv")   # the countries, and life expectancy
codes  <- read.csv("un_codes.csv")             # iso3 and UN country code
un     <- codes$un_code[match(cohort$iso3, codes$iso3)]


# Births in calendar 2025. The UN reports them in thousands.
b <- births[births$`Reference date (1 January - 31 December)` == 2025, ]
births_2025 <- 1000 * as.numeric(b$`Births (thousands)`[match(un, b$`Country code`)])


# Person-years from birth to age 5.
#
# The UN gives the number of people at each single age on 1 July of each
# year, in thousands. A child born during 2025 is aged 0 for part of 2025
# and part of 2026, aged 1 for part of 2026 and part of 2027, and so on.
# So for each age from 0 to 4 we take the average of the 1 July population
# at that age in the two years the cohort spans, and add up the five ages.
# This averaging is our choice. The published model does not describe the
# calculation.
pop_at <- function(age, year) {
  p <- pop[pop$`Reference date (as of 1 July)` == year, ]
  1000 * as.numeric(p[[as.character(age)]][match(un, p$`Country code`)])
}
PY_0to5 <- 0
for (age in 0:4) {
  PY_0to5 <- PY_0to5 + (pop_at(age, 2025 + age) + pop_at(age, 2026 + age)) / 2
}


# Stop if any country is missing from the UN files.
if (anyNA(births_2025) || anyNA(PY_0to5)) {
  print(cohort$iso3[is.na(births_2025) | is.na(PY_0to5)])
  stop("A country is missing from the UN files")
}

cohort$births_2025  <- births_2025
cohort$PY_0to5      <- PY_0to5
cohort$PY_per_birth <- PY_0to5 / births_2025

k <- cohort$iso3 == "KEN"
cat("Kenya: births", round(cohort$births_2025[k]),
    " person-years 0-5", round(cohort$PY_0to5[k]),
    " per birth", round(cohort$PY_per_birth[k], 4), "\n")

write.csv(cohort, "mahmud_cohort_2025.csv", row.names = FALSE)
cat("Wrote mahmud_cohort_2025.csv for", nrow(cohort), "countries\n")
