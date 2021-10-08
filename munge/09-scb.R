pop <- pop %>%
  mutate(
    scbyear = indexyear - 1
  )

pop <- left_join(
  pop,
  antalbarn %>%
    select(LopNr, year) %>%
    mutate(scb_child = "Yes"),
  by = c("LopNr" = "LopNr", "scbyear" = "year")
) %>%
  mutate(scb_child = replace_na(scb_child, "No"))


lisa <- lisa %>%
  mutate(
    scb_famtype = case_when(
      FamTypF %in% c(11, 12, 13, 21, 22, 23, 31, 32, 41, 42) ~ "Cohabitating",
      FamTypF %in% c(50, 60) ~ "Living alone"
    ),
    scb_education = case_when(
      Sun2000niva_old %in% c(1, 2) ~ "Compulsory school",
      Sun2000niva_old %in% c(3, 4) ~ "Secondary school",
      Sun2000niva_old %in% c(5, 6, 7) ~ "University"
    ),
    scb_dispincome = coalesce(DispInk04, DispInk)
  ) %>%
  select(LopNr, year, starts_with("scb_"))

# no values for education available for 2018 (baseline values for patients with indexyear 2019)
# so assumed same education 2018 as 2017

lisaeducation2017 <- lisa %>%
  filter(year == 2017) %>%
  mutate(
    edyear = 2018,
    scb_educationimp = scb_education
  ) %>%
  select(LopNr, scb_educationimp, edyear)

lisa <- left_join(lisa,
  lisaeducation2017,
  by = c("LopNr" = "LopNr", "year" = "edyear")
) %>%
  mutate(scb_education = coalesce(scb_education, scb_educationimp)) %>%
  select(-scb_educationimp)


pop <- left_join(
  pop,
  lisa,
  by = c("LopNr" = "LopNr", "scbyear" = "year")
) %>%
  select(-scbyear)

## income cat
inc <- pop %>%
  group_by(indexyear) %>%
  summarise(incmed = quantile(scb_dispincome,
    probs = 0.5,
    na.rm = TRUE
  ), .groups = "drop_last")

pop <- left_join(
  pop,
  inc,
  by = "indexyear"
) %>%
  mutate(
    scb_dispincome_cat2 = case_when(
      scb_dispincome < incmed ~ 1,
      scb_dispincome >= incmed ~ 2
    ),
    scb_dispincome_cat2 = factor(scb_dispincome_cat2,
      levels = 1:2,
      labels = c("Below medium", "Above medium")
    )
  ) %>%
  select(-incmed)
