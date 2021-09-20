

# Variables for tabs/mods -------------------------------------------------

tabvars <- c(
  # demo
  "shf_age",
  "shf_sex",
  "indexyear",

  "shf_ef_cat",

  # socec
  "scb_education",
  "scb_child",
  "scb_famtype",
  "scb_dispincome_cat2",

  "sos_com_afparoxysmal",
  "sos_com_afpersistent",
  "sos_comdur_af",
  "sos_com_hypertension",
  "sos_com_diabetes",
  "sos_com_liver",
  "sos_com_copd",
  "chadsvasc",
  "chadsvasc_cat",
  "sos_com_stroketia",
  "sos_com_ihd",
  "sos_com_dcm",
  "sos_com_peripheralartery",
  "sos_com_cancer3y",
  "sos_com_bleed",
  "sos_com_renal",

  # treatments
  "ddr_aad",
  "ddr_ratecontrol",
  "ddr_bbl",
  "ddr_digoxin",
  "ddr_rasiarni",
  "ddr_diuretics",
  "ddr_mra",
  "ddr_antiplatlet",
  "ddr_anticoagulant",
  "ddr_lipidlowering",
  "ddr_sglt2i_glp1a"
)

# vars fox log reg and cox reg
tabvars_not_in_mod <- c(
  "sos_com_afparoxysmal",
  "sos_com_afpersistent",

  "chadsvasc",
  "chadsvasc_cat"
)

nsvars <- c("shf_age", "indexyear", "sos_comdur_af")
modvars <- c(tabvars[!(tabvars %in% tabvars_not_in_mod)])
modvarsns <- if_else(modvars %in% nsvars, paste0("ns(", modvars, ", df = 4)"), modvars)
