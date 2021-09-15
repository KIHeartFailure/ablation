
# Treatments from DDR --------------------------------------------

## rs
rsdata <- rsdata324 %>%
  filter(casecontrol == "Case") %>%
  select(LopNr, shf_indexdtm, shf_sex, shf_age, shf_ef, sos_com_af, scb_child)

lmtmprs <- left_join(
  rsdata %>%
    select(LopNr, shf_indexdtm),
  lmsel,
  by = "LopNr"
) %>%
  mutate(diff = as.numeric(EDATUM - shf_indexdtm)) %>%
  filter(diff >= -30.5 * 5, diff <= 14) %>%
  select(LopNr, shf_indexdtm, EDATUM, ATC)

## ablation
lmtmpab <- left_join(
  ablationpop %>%
    select(LopNr, sos_ablationdtm),
  lmsel,
  by = "LopNr"
) %>%
  mutate(diff = as.numeric(EDATUM - sos_ablationdtm)) %>%
  filter(diff >= -30.5 * 5, diff <= 14) %>%
  select(LopNr, sos_ablationdtm, EDATUM, ATC)

lmtreats <- function(atc, treatname) {
  treatname <- paste0("ddr_", treatname)

  ## rs
  lmtmp2 <- lmtmprs %>%
    mutate(
      atcneed = stringr::str_detect(ATC, atc)
    ) %>%
    filter(atcneed)

  lmtmp2 <- lmtmp2 %>%
    group_by(LopNr, shf_indexdtm) %>%
    slice(1) %>%
    ungroup() %>%
    mutate(!!treatname := 1) %>%
    select(LopNr, shf_indexdtm, !!sym(treatname))

  rsdata <<- left_join(
    rsdata,
    lmtmp2,
    by = c("LopNr", "shf_indexdtm")
  ) %>%
    mutate(
      !!treatname := replace_na(!!sym(treatname), 0),
      !!treatname := if_else(shf_indexdtm < ymd("2005-12-01"), NA_real_, !!sym(treatname)), # redundant, excluded obs
      !!treatname := factor(!!sym(treatname), levels = c(0, 1), labels = c("No", "Yes"))
    )

  ## ablation
  lmtmpab2 <- lmtmpab %>%
    mutate(
      atcneed = stringr::str_detect(ATC, atc)
    ) %>%
    filter(atcneed)

  lmtmpab2 <- lmtmpab2 %>%
    group_by(LopNr, sos_ablationdtm) %>%
    slice(1) %>%
    ungroup() %>%
    mutate(!!treatname := 1) %>%
    select(LopNr, sos_ablationdtm, !!sym(treatname))

  ablationpop <<- left_join(
    ablationpop,
    lmtmpab2,
    by = c("LopNr", "sos_ablationdtm")
  ) %>%
    mutate(
      !!treatname := replace_na(!!sym(treatname), 0),
      !!treatname := if_else(sos_ablationdtm < ymd("2005-12-01"), NA_real_, !!sym(treatname)), # redundant, excluded obs
      !!treatname := factor(!!sym(treatname), levels = c(0, 1), labels = c("No", "Yes"))
    )

  # metadata
  metatmp <- c(treatname, stringr::str_replace_all(atc, "\\|", ","))
  if (exists("metalm")) {
    metalm <<- rbind(metalm, metatmp) # global variable, writes to global env
  } else {
    metalm <<- metatmp # global variable, writes to global env
  }
}


lmtreats(atc = "^(C01BD07|C01BC04|C07AA|C01BD01|C01BA03|C01BC03)", treatname = "aad")
lmtreats(atc = "^(C08DA01|C08DB01)", treatname = "ratecontrol")
lmtreats(atc = "^(C07A)", treatname = "bbl")
lmtreats(atc = "^(C01AA05)", treatname = "digoxin")

colnames(metalm) <- c("Variable", "ATC")
metalm <- metalm %>%
  as_tibble() %>%
  mutate(
    ATC = gsub("^", "", ATC, fixed = TRUE),
    ATC = gsub("(", "", ATC, fixed = TRUE),
    ATC = gsub(")", "", ATC, fixed = TRUE),
    ATC = gsub("?!", " excl.", ATC, fixed = TRUE),
    Registry = "Dispensed Drug Registry",
    Period = "-5mo-14days",
  )
