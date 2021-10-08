rsdata <- bind_rows(
  newrs %>% mutate(source = 3),
  oldrs %>% mutate(source = 1) %>% select(-TYPE, -FATIGUE, -MOBILITY, -DIABETES, -BNP, -ARNI)
)

rsdata <- rsdata %>%
  mutate(
    shf_source = case_when(
      source == 3 & migrated == 1 ~ 2,
      TRUE ~ source
    ),
    shf_source = factor(shf_source, labels = c("Old SHF", "New SHF migrated from old SHF", "New SHF")),

    tmp_indexstartdtm = coalesce(DTMIN, d_DATE_FOR_ADMISSION),
    tmp_indexstopdtm = coalesce(DTMUT, DATE_DISCHARGE),
    shf_indexdtm = coalesce(tmp_indexstopdtm, tmp_indexstartdtm),
    shf_indexyear = year(shf_indexdtm),
    shf_sex = case_when(
      SEX == "FEMALE" | GENDER == 2 ~ "Female",
      SEX == "MALE" | GENDER == 1 ~ "Male"
    ),
    shf_age = coalesce(d_age_at_VISIT_DATE, d_alder),
    shf_ef = case_when(
      d_lvefprocent == 1 | LVEF_SEMIQUANTITATIVE == "NORMAL" | LVEF_PERCENT >= 50 ~ 1,
      d_lvefprocent == 2 | LVEF_SEMIQUANTITATIVE == "MILD" | LVEF_PERCENT >= 40 ~ 2,
      d_lvefprocent == 3 | LVEF_SEMIQUANTITATIVE == "MODERATE" | LVEF_PERCENT >= 30 ~ 3,
      d_lvefprocent == 4 | LVEF_SEMIQUANTITATIVE == "SEVERE" | LVEF_PERCENT < 30 ~ 4
    ),
    shf_ef = factor(shf_ef, labels = c(">=50", "40-49", "30-39", "<30")),

    # outcomes
    shf_deathdtm = coalesce(d_befdoddtm, befdoddtm),
    shf_deathdtm = if_else(shf_deathdtm > ymd("2018-12-31"), as.Date(NA), shf_deathdtm)
  ) %>%
  select(LopNr, starts_with("shf_"))

clean_outliers <- function(var, min, max) {
  var <- replace(var, var < min | var > max, NA)
}

rsdata <- rsdata %>%
  mutate(
    shf_age = clean_outliers(shf_age, 0, 120)
  )
