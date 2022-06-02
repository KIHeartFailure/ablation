
# Treatments from DDR --------------------------------------------

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

lmtreats <- function(atc2, medname2) {
  rsdata <<- create_medvar(
    atc = atc2,
    medname = medname2,
    cohortdata = rsdata,
    meddata = lmtmprs,
    id = c("LopNr", "shf_indexdtm"),
    valsclass = "fac"
  )

  ablationpop <<- create_medvar(
    atc = atc2,
    medname = medname2,
    cohortdata = ablationpop,
    meddata = lmtmpab,
    id = c("LopNr", "sos_ablationdtm"),
    valsclass = "fac",
    metatime = "REMOVE"
  )
}


lmtreats(atc2 = "^(C01BD07|C01BC04|C07AA|C01BD01|C01BA03|C01BC03)", medname2 = "aad")
lmtreats(atc2 = "^(C08DA01|C08DB01)", medname2 = "ratecontrol")
lmtreats(atc2 = "^(C07A)", medname2 = "bbl")
lmtreats(atc2 = "^(C01AA05)", medname2 = "digoxin")
lmtreats("^(C09A|C09B|C09C|C09D)", medname2 = "rasiarni")
lmtreats("^(C03(?!DA)|C07B|C07C|C07D|C08GA|C09BA|C09DA|C09DX01)", medname2 = "diuretics")
lmtreats("^C03DA", medname2 = "mra")
lmtreats("^B01AC", medname2 = "antiplatlet")
lmtreats("^(B01AA|B01AF)", medname2 = "oralanticoagulant")
lmtreats("^C10", medname2 = "lipidlowering")
lmtreats("^(A10BK0[1-6]|A10BD15|A10BD16|A10BD19|A10BD20|A10BD21|A10BD23|A10BD24|A10BD25|A10BX09|A10BX11|A10BX12|A10BJ|A10BX04|A10BX07|A10BX10|A10BX13|A10BX14)",
  medname2 = "sglt2i_glp1a"
)
lmtreats("^C07AA", medname2 = "sotalol")
lmtreats("^C01BA03", medname2 = "disopyramid")

metalm <- metalm %>% filter(Period != "REMOVE")
