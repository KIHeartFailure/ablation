
flowrs <- c("No of posts in SwedeHF", nrow(rsdata))

# remove duplicated indexdates
rsdata <- rsdata %>%
  group_by(LopNr, shf_indexdtm) %>%
  arrange(shf_source) %>% 
  slice(1) %>% 
  ungroup()

flowrs <- rbind(flowrs, c("Remove posts with duplicated index dates", nrow(rsdata)))

rsdata <- left_join(rsdata,
  pnr_bytt_ater,
  by = "LopNr"
)

rsdata <- rsdata %>%
  filter(is.na(AterPnr) & is.na(ByttPnr)) # reused/changed personr

flowrs <- rbind(flowrs, c("Remove posts with reused or changed PINs", nrow(rsdata)))

rsdata <- rsdata %>%
  filter(shf_age >= 18 & !is.na(shf_age))

flowrs <- rbind(flowrs, c("Remove posts < 18 years", nrow(rsdata)))

rsdata <- rsdata %>%
  filter((shf_indexdtm < shf_deathdtm | is.na(shf_deathdtm))) # enddate prior to indexdate

flowrs <- rbind(flowrs, c("Remove posts with end of follow-up <= index date (died in hospital)", nrow(rsdata)))

rsdata <- rsdata %>%
  filter(shf_indexdtm <= ymd("2019-12-31")) %>%
  select(-ByttPnr, -AterPnr)

flowrs <- rbind(flowrs, c("Remove posts with with index date > 2019-12-31", nrow(rsdata)))
