
# Comorbidities -----------------------------------------------------------

pop <- create_sosvar(
  type = "com",
  name = "af",
  sosdata = patreg,
  cohortdata = pop,
  patid = LopNr,
  indexdate = indexdtm,
  sosdate = INDATUM,
  diavar = DIA_all,
  comduration = TRUE,
  diakod = " I48",
  valsclass = "fac",
  stoptime = -9 * 365.25,
  warnings = TRUE
)

pop <- create_sosvar(
  type = "com",
  name = "afparoxysmal",
  sosdata = patreg,
  cohortdata = pop,
  patid = LopNr,
  indexdate = indexdtm,
  sosdate = INDATUM,
  diavar = DIA_all,
  diakod = " I480",
  valsclass = "fac",
  stoptime = -5 * 365.25,
  warnings = TRUE
)

pop <- create_sosvar(
  type = "com",
  name = "afpersistent",
  sosdata = patreg,
  cohortdata = pop,
  patid = LopNr,
  indexdate = indexdtm,
  sosdate = INDATUM,
  diavar = DIA_all,
  diakod = " I481",
  valsclass = "fac",
  stoptime = -5 * 365.25,
  warnings = TRUE
)

pop <- create_sosvar(
  type = "com",
  name = "hypertension",
  sosdata = patreg,
  cohortdata = pop,
  patid = LopNr,
  indexdate = indexdtm,
  sosdate = INDATUM,
  diavar = DIA_all,
  diakod = " I1[0-5]",
  valsclass = "fac",
  stoptime = -5 * 365.25,
  warnings = TRUE
)

pop <- create_sosvar(
  type = "com",
  name = "diabetes",
  sosdata = patreg,
  cohortdata = pop,
  patid = LopNr,
  indexdate = indexdtm,
  sosdate = INDATUM,
  diavar = DIA_all,
  diakod = " E1[0-4]",
  valsclass = "fac",
  stoptime = -5 * 365.25,
  warnings = TRUE
)

pop <- create_sosvar(
  type = "com",
  name = "liver",
  sosdata = patreg,
  cohortdata = pop,
  patid = LopNr,
  indexdate = indexdtm,
  sosdate = INDATUM,
  diavar = DIA_all,
  diakod = " B18| I85| I864| I982| K70| K710| K711| K71[3-7]| K7[2-4]| K760| K76[2-9]",
  valsclass = "fac",
  stoptime = -5 * 365.25,
  warnings = TRUE
)

pop <- create_sosvar(
  type = "com",
  name = "copd",
  sosdata = patreg,
  cohortdata = pop,
  patid = LopNr,
  indexdate = indexdtm,
  sosdate = INDATUM,
  diavar = DIA_all,
  diakod = " J4[0-4]",
  valsclass = "fac",
  stoptime = -5 * 365.25,
  warnings = TRUE
)

pop <- create_sosvar(
  type = "com",
  name = "stroketia",
  sosdata = patreg,
  cohortdata = pop,
  patid = LopNr,
  indexdate = indexdtm,
  sosdate = INDATUM,
  diavar = DIA_all,
  diakod = " I6[0-4]| I69[0-4]| G45",
  valsclass = "fac",
  stoptime = -5 * 365.25,
  warnings = TRUE
)

pop <- create_sosvar(
  type = "com",
  name = "ihd",
  sosdata = patreg,
  cohortdata = pop,
  patid = LopNr,
  indexdate = indexdtm,
  sosdate = INDATUM,
  diavar = DIA_all,
  diakod = " I2[0-5]",
  valsclass = "fac",
  stoptime = -5 * 365.25,
  warnings = TRUE
)

pop <- create_sosvar(
  type = "com",
  name = "dcm",
  sosdata = patreg,
  cohortdata = pop,
  patid = LopNr,
  indexdate = indexdtm,
  sosdate = INDATUM,
  diavar = DIA_all,
  diakod = " I420",
  valsclass = "fac",
  stoptime = -5 * 365.25,
  warnings = TRUE
)

pop <- create_sosvar(
  type = "com",
  name = "peripheralartery",
  sosdata = patreg,
  cohortdata = pop,
  patid = LopNr,
  indexdate = indexdtm,
  sosdate = INDATUM,
  diavar = DIA_all,
  diakod = " I7[0-3]",
  valsclass = "fac",
  stoptime = -5 * 365.25,
  warnings = TRUE
)

pop <- create_sosvar(
  type = "com",
  name = "mi",
  sosdata = patreg,
  cohortdata = pop,
  patid = LopNr,
  indexdate = indexdtm,
  sosdate = INDATUM,
  diavar = DIA_all,
  diakod = " I21| I22| I252",
  valsclass = "fac",
  stoptime = -5 * 365.25,
  warnings = TRUE
)

pop <- create_sosvar(
  type = "com",
  name = "cancer3y",
  sosdata = patreg,
  cohortdata = pop,
  patid = LopNr,
  indexdate = indexdtm,
  sosdate = INDATUM,
  diavar = DIA_all,
  diakod = " C",
  valsclass = "fac",
  stoptime = -3 * 365.25,
  warnings = TRUE
)

pop <- create_sosvar(
  type = "com",
  name = "bleed",
  sosdata = patreg,
  cohortdata = pop,
  patid = LopNr,
  indexdate = indexdtm,
  sosdate = INDATUM,
  diavar = DIA_all,
  opvar = OP_all,
  diakod = " S064| S065| S066| I850| I983| K226| K250| K252| K254| K256| K260| K262| K264| K266| K270| K272| K274| K276| K280| K284| K286| K290| K625| K661| K920| K921| K922| H431| N02| R04| R58| T810| D629",
  opkod = " DR029",
  valsclass = "fac",
  stoptime = -5 * 365.25,
  warnings = TRUE
)

# Outcomes hospitalizations ----------------------------------------------

pop <- create_sosvar(
  sosdata = patreg %>% filter(sos_source == "sv"),
  cohortdata = pop,
  patid = LopNr,
  indexdate = indexdtm,
  sosdate = INDATUM,
  diavar = HDIA,
  type = "out",
  name = "hosphf",
  diakod = " I110| I130| I132| I255| I420| I423| I425| I426| I427| I428| I429| I43| I50| J81| K761| R57",
  censdate = censdtm,
  valsclass = "fac",
  warnings = FALSE
)

pop <- create_sosvar(
  sosdata = patreg %>% filter(sos_source == "sv"),
  cohortdata = pop,
  patid = LopNr,
  indexdate = indexdtm,
  sosdate = INDATUM,
  diavar = HDIA,
  type = "out",
  name = "hospany",
  diakod = " ",
  censdate = censdtm,
  valsclass = "fac",
  warnings = FALSE
)

pop <- create_sosvar(
  sosdata = patreg %>% filter(sos_source == "sv"),
  cohortdata = pop,
  patid = LopNr,
  indexdate = indexdtm,
  sosdate = INDATUM,
  diavar = HDIA,
  type = "out",
  name = "hospcv",
  diakod = " I| J81| K761| G45| R57",
  censdate = censdtm,
  valsclass = "fac",
  warnings = FALSE
)

pop <- create_sosvar(
  sosdata = patreg %>% filter(sos_source == "sv"),
  cohortdata = pop,
  patid = LopNr,
  indexdate = indexdtm,
  sosdate = INDATUM,
  diavar = HDIA,
  type = "out",
  name = "hospstroketia",
  diakod = " I6[0-4]| G45",
  censdate = censdtm,
  valsclass = "fac",
  warnings = FALSE
)

# Cause of death ----------------------------------------------------------

pop <- pop %>%
  mutate(
    sos_out_death = factor(ifelse(censdtm == sos_deathdtm & !is.na(sos_deathdtm), 1, 0), levels = 0:1, labels = c("No", "Yes")),
    sos_outtime_death = as.numeric(censdtm - indexdtm)
  )

pop <- create_deathvar(
  cohortdata = pop,
  indexdate = indexdtm,
  censdate = censdtm,
  deathdate = sos_deathdtm,
  name = "cv",
  orsakvar = sos_deathcause,
  orsakkod = "I|J81|K761|R57|G45",
  valsclass = "fac",
  warnings = FALSE,
  meta_pos = "ULORSAK"
)
