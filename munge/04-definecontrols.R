
# rsdata selected in 03-soslmvar
flowcontrol <- c("Number of posts (cases) in SHFDB3", nrow(rsdata))

rsdata <- rsdata %>%
  filter(shf_indexdtm > ymd("2005-12-01"))
flowcontrol <- rbind(flowcontrol, c("Index date > 1 Dec 2005 (start of DDR + 5 months)", nrow(rsdata)))

rsdata <- rsdata %>%
  filter(!is.na(shf_ef))
flowcontrol <- rbind(flowcontrol, c("Non-missing EF", nrow(rsdata)))

rsdata <- rsdata %>%
  filter(sos_com_af == "Yes")
flowcontrol <- rbind(flowcontrol, c("NPR post with I48 (any position) within 5 years from index date", nrow(rsdata)))

rsdata <- left_join(rsdata,
  ablationpop %>%
    select(LopNr, sos_ablationdtm),
  by = c("LopNr")
) %>%
  filter(is.na(sos_ablationdtm) | shf_indexdtm < sos_ablationdtm)
flowcontrol <- rbind(flowcontrol, c("No previous ablation (defined as a case)", nrow(rsdata)))

rsdata <- rsdata %>%
  mutate(med = if_else(ddr_aad == "Yes" | ddr_ratecontrol == "Yes" | ddr_bbl == "Yes" | ddr_digoxin == "Yes", "Yes", "No")) %>%
  filter(med == "Yes") %>%
  select(-med)
flowcontrol <- rbind(flowcontrol, c("At least one prescription of either AAD, rate control, beta-blocker, digoxin within 5 months prior and 14 days after index", nrow(rsdata)))

rsdata <- rsdata %>%
  group_by(LopNr) %>%
  arrange(shf_indexdtm) %>%
  slice(1) %>%
  ungroup()
flowcontrol <- rbind(flowcontrol, c("First post / patient", nrow(rsdata)))
