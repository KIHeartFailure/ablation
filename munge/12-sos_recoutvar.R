
# Outcomes hospitalizations ----------------------------------------------

svpatreg <- patreg %>% 
  filter(sos_source == "sv")

svpatregpop <- left_join(pop %>% 
                        select(LopNr, indexdtm, ablation, sos_outtime_death, sos_out_death, censdtm), 
                      svpatreg, 
                      by = "LopNr") %>%
  mutate(sos_outtime = difftime(INDATUM, indexdtm, units = "days")) %>%
  filter(sos_outtime > 0 & INDATUM < censdtm)

svpatregmatch <- left_join(matchpop %>% 
                        select(LopNr, indexdtm, ablation, sos_outtime_death, sos_out_death, censdtm), 
                      svpatreg, 
                      by = "LopNr") %>%
  mutate(sos_outtime = difftime(INDATUM, indexdtm, units = "days")) %>%
  filter(sos_outtime > 0 & INDATUM < censdtm)

create_recevents <- function(data, svpatregdata, diakod){
  tmpsos <- svpatregdata %>% 
    mutate(sos_out = stringr::str_detect(HDIA, diakod)) %>%
    filter(sos_out) %>%
    select(LopNr, indexdtm, ablation, sos_outtime_death, sos_out_death, censdtm, sos_outtime, sos_out)
    
  dataout <- bind_rows(data %>% 
                         select(LopNr, indexdtm, ablation, sos_outtime_death, sos_out_death, censdtm), 
                       tmpsos) %>%
    mutate(sos_out = if_else(is.na(sos_out), 0, 1), 
           sos_outtime = if_else(is.na(sos_outtime), difftime(censdtm, indexdtm, units = "days"), sos_outtime))
  
  dataout <- dataout %>%
    group_by(LopNr, indexdtm, sos_outtime) %>%
    arrange(desc(sos_out)) %>%
    slice(1) %>%
    ungroup()
  
  dataout <- dataout %>%
    mutate(LopNrablation = paste0(LopNr, ablation)) %>%
    select(-LopNr)
}

pop_rec_hosphf <- create_recevents(
  data = pop, 
  svpatregdata = svpatregpop, 
  diakod = " I110| I130| I132| I255| I420| I423| I425| I426| I427| I428| I429| I43| I50| J81| K761| R57"
)

matchpop_rec_hosphf <- create_recevents(
  data = matchpop, 
  svpatregdata = svpatregmatch, 
  diakod = " I110| I130| I132| I255| I420| I423| I425| I426| I427| I428| I429| I43| I50| J81| K761| R57"
)