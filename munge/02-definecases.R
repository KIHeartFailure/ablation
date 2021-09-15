

# Definition of cases -----------------------------------------------------

ablationbase <- patreg %>%
  mutate(
    op = stringr::str_detect(OP_all, " FPB22| FPB32| DF003"),
    opex = stringr::str_detect(OP_all, " FPE00| FPE20"),
    dia = stringr::str_detect(HDIA, " I48"),
    diaex1 = stringr::str_detect(DIA_all, " I456| I47"),
    diaex2 = stringr::str_detect(DIA_all, " I493| I494| I489C| I489D| I489E| I489F")
  )

ablationpop <- ablationbase %>% # first ablation
  filter(op) %>%
  group_by(LopNr) %>%
  arrange(INDATUM) %>%
  slice(1) %>%
  ungroup() %>%
  rename(sos_ablationdtm = INDATUM)

flowcase <- c("First post with FPB22, FPB32 or DF003 in NPR ('ablation post')", nrow(ablationpop))

ablationpop <- ablationpop %>%
  filter(sos_ablationdtm > ymd("2005-12-01"))
flowcase <- rbind(flowcase, c("Ablation post > 1 Dec 2005 (start of DDR + 5 months)", nrow(ablationpop)))

ablationpop <- ablationpop %>%
  filter(sos_ablationdtm <= ymd("2018-12-31"))
flowcase <- rbind(flowcase, c("Ablation post <= 31 Dec 2018 (similar to restriction for controls)", nrow(ablationpop)))

ablationpop <- ablationpop %>%
  filter(dia)
flowcase <- rbind(flowcase, c("Ablation post has HDIA I48", nrow(ablationpop)))

ablationpop <- ablationpop %>%
  filter(!diaex1 & !diaex2)
flowcase <- rbind(flowcase, c("Ablation post does NOT have I456, I47, I493, I494, I489C-F in BDIA01-BDIAXX", nrow(ablationpop)))

ablationpop <- left_join(ablationpop %>%
  select(LopNr, sos_ablationdtm),
ablationbase %>%
  filter(opex) %>%
  select(LopNr, INDATUM),
by = "LopNr"
) %>%
  mutate(diff = as.numeric(INDATUM - sos_ablationdtm)) %>%
  filter(is.na(diff) | diff <= -30.5 * 3 | diff > 0) %>%
  select(-INDATUM, -diff)

ablationpop <- ablationpop %>%
  group_by(LopNr) %>%
  arrange(sos_ablationdtm) %>%
  slice(1) %>%
  ungroup()

flowcase <- rbind(flowcase, c("Ablation post does NOT have procedure FPE00, FPE20 within 3 months prior", nrow(ablationpop)))

ablationpop <- inner_join(ablationpop,
  rsdata324 %>%
    filter(
      casecontrol == "Case",
      !is.na(shf_ef)
    ) %>%
    select(LopNr, shf_indexdtm, shf_sex, shf_age, shf_ef, scb_child),
  by = "LopNr"
) %>%
  mutate(diff = as.numeric(sos_ablationdtm - shf_indexdtm)) %>%
  filter(diff <= 365, diff >= 0) %>%
  group_by(LopNr) %>%
  arrange(diff) %>%
  slice(1) %>%
  ungroup() %>%
  select(-diff)

flowcase <- rbind(flowcase, c("Ablation post has a registration in SwedeHF with non-missing EF with index date within 1 year prior", nrow(ablationpop)))
