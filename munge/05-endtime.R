
# put data together
pop <- bind_rows(
  ablationpop %>%
    mutate(
      ablation = 1,
      indexdtm = sos_ablationdtm
    ),
  rsdata %>%
    mutate(
      ablation = 0,
      indexdtm = shf_indexdtm
    )
) %>%
  select(-sos_com_af) %>%
  mutate(
    ablation = factor(ablation, levels = 0:1, labels = c("No", "Yes")),
    indexyear = as.numeric(year(indexdtm))
  )

# table(duplicated(ablationpop$LopNr))
# table(duplicated(rsdata$LopNr))
# table(duplicated(pop$LopNr)) # 213 pats both cases and controls


# koll <- left_join(pop %>% group_by(LopNr) %>% slice(2) %>% ungroup() %>% select(LopNr),
#                  pop,
#                  by = "LopNr")


# migration

migration <- inner_join(pop %>%
  select(LopNr, indexdtm),
migration %>%
  filter(Posttyp == "Utv"),
by = c("LopNr" = "lopnr")
) %>%
  mutate(tmp_migrationdtm = ymd(MigrationDatum)) %>%
  filter(
    tmp_migrationdtm > indexdtm,
    tmp_migrationdtm <= ymd("2019-12-31")
  ) %>%
  group_by(LopNr, indexdtm) %>%
  slice(1) %>%
  ungroup() %>%
  select(LopNr, indexdtm, tmp_migrationdtm)

pop <- left_join(pop,
  migration,
  by = c("LopNr", "indexdtm")
)

# death

dors <- bind_rows(
  dors,
  dors2
)


pop <- left_join(pop,
  dors %>% select(LopNr, ULORSAK, DODSDAT),
  by = "LopNr"
) %>%
  mutate(sos_deathdtm = ymd(case_when(
    substr(DODSDAT, 5, 8) == "0000" ~ paste0(substr(DODSDAT, 1, 4), "0701"),
    substr(DODSDAT, 7, 8) == "00" ~ paste0(substr(DODSDAT, 1, 6), "15"),
    TRUE ~ DODSDAT
  ))) %>%
  rename(sos_deathcause = ULORSAK) %>%
  select(-DODSDAT)


pop <- pop %>%
  mutate(
    censdtm = coalesce(
      pmin(sos_deathdtm, tmp_migrationdtm, na.rm = TRUE),
      ymd("2019-12-31")
    ),
    censdtm = if_else(ablation == "No", pmin(censdtm, sos_ablationdtm - 1, na.rm = TRUE), censdtm)
  )
