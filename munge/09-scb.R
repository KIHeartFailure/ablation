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
    scb_region = case_when(
      Lan == "01" ~ "Stockholm",
      Lan == "03" ~ "Uppsala",
      Lan == "04" ~ "Sodermanland",
      Lan == "05" ~ "Ostergotland",
      Lan == "06" ~ "Jonkoping",
      Lan == "07" ~ "Kronoberg",
      Lan == "08" ~ "Kalmar",
      Lan == "09" ~ "Gotland",
      Lan == "10" ~ "Blekinge",
      Lan == "12" ~ "Skane",
      Lan == "13" ~ "Halland",
      Lan == "14" ~ "Vastra Gotaland",
      Lan == "17" ~ "Varmland",
      Lan == "18" ~ "Orebro",
      Lan == "19" ~ "Vastmanland",
      Lan == "20" ~ "Dalarna",
      Lan == "21" ~ "Gavleborg",
      Lan == "22" ~ "Vasternorrland",
      Lan == "23" ~ "Jamtland",
      Lan == "24" ~ "Vasterbotten",
      Lan == "25" ~ "Norrbotten"),
    scb_famtype = case_when(
      FamTypF %in% c(11, 12, 13, 21, 22, 23, 31, 32, 41, 42) ~ "Cohabitating",
      FamTypF %in% c(50, 60) ~ "Living alone"
    ),
    Sun2000niva_old = coalesce(Sun2000niva_old, Sun2000niva_Old), 
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
