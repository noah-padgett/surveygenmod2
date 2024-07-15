library(survey)
options(survey.lonely.psu = "certainty")
library(tidyverse)

imp.data <- read.csv("sample_data.csv")


svy.data <- svydesign(
  data = imp.data,
  ids = ~PSU,
  STRATA = ~STRATA,
  weights = ~WGT
)

fit.linear <- svyglm(
  OUTCOME_EXPENSES ~ AGE + FEMALE + OTHER + EDUCATION_16PLUS + EDUCATION_UNDER8 + HEALTH12_EXCELLENT + HEALTH12_VERYGOOD + HEALTH12_FAIR + HEALTH12_POOR, 
  design = svy.data
)
summary(fit.linear)
wald.linear <- regTermTest(
  fit.linear,
  test.terms = c("HEALTH12_EXCELLENT", "HEALTH12_VERYGOOD", "HEALTH12_FAIR", "HEALTH12_POOR"),
  method = "Wald"
)
wald.linear


fit.poisson <- svyglm(
  OUTCOME_INCOME ~ AGE + FEMALE + OTHER + EDUCATION_16PLUS + EDUCATION_UNDER8 + HEALTH12_EXCELLENT + HEALTH12_VERYGOOD + HEALTH12_FAIR + HEALTH12_POOR, 
  design = svy.data,
  family = "quasipoisson"
)
summary(fit.poisson)
wald.poisson <- regTermTest(
  fit.poisson,
  test.terms = c("HEALTH12_EXCELLENT", "HEALTH12_VERYGOOD", "HEALTH12_FAIR", "HEALTH12_POOR"),
  method = "Wald"
)
wald.poisson


