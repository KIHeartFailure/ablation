pop <- pop %>%
  mutate(
    scbyear = indexyear - 1
  )

lisa <- lisa %>%
  mutate(
    scb_region = Lan,
    scb_maritalstatus = case_when(
      Civil %in% c("A", "EP", "OG", "S", "SP") ~ "Single/widowed/divorced",
      Civil %in% c("G", "RP") ~ "Married"
    ),
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
