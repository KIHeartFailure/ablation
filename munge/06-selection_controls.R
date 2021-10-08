
# rsdata selected in 03-soslmvar
flowcontrol <- c("Number of posts in SwedeHF (from previous flowchart)", nrow(rsdata))

controlpop <- rsdata %>%
  filter(shf_indexdtm > ymd("2005-12-01"))
flowcontrol <- rbind(flowcontrol, c("Index date > 1 Dec 2005 (start of DDR + 5 months)", nrow(controlpop)))

controlpop <- controlpop %>%
  filter(!is.na(shf_ef))
flowcontrol <- rbind(flowcontrol, c("Non-missing EF", nrow(controlpop)))

controlpop <- create_sosvar(
  type = "com",
  name = "af",
  sosdata = patreg,
  cohortdata = controlpop,
  patid = LopNr,
  indexdate = shf_indexdtm,
  sosdate = INDATUM,
  diavar = DIA_all,
  diakod = " I48",
  valsclass = "fac",
  stoptime = -5 * 365.25,
  warnings = TRUE
)
controlpop <- controlpop %>%
  filter(sos_com_af == "Yes")
flowcontrol <- rbind(flowcontrol, c("NPR post with I48 (any position) within 5 years from index date", nrow(controlpop)))

controlpop <- left_join(controlpop,
  ablationpop %>%
    select(LopNr, sos_ablationdtm),
  by = c("LopNr")
) %>%
  filter(is.na(sos_ablationdtm) | shf_indexdtm < sos_ablationdtm)
flowcontrol <- rbind(flowcontrol, c("No previous ablation (defined as a case)", nrow(controlpop)))

controlpop <- controlpop %>%
  mutate(med = if_else(sos_ddr_aad == "Yes" | sos_ddr_ratecontrol == "Yes" | sos_ddr_bbl == "Yes" | sos_ddr_digoxin == "Yes", "Yes", "No")) %>%
  filter(med == "Yes") %>%
  select(-med)
flowcontrol <- rbind(flowcontrol, c("At least one prescription of either AAD, rate control, beta-blocker, digoxin within 5 months prior and 14 days after index", nrow(controlpop)))

controlpop <- controlpop %>%
  group_by(LopNr) %>%
  arrange(shf_indexdtm) %>%
  slice(1) %>%
  ungroup()
flowcontrol <- rbind(flowcontrol, c("First post / patient", nrow(controlpop)))
