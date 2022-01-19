

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

  "sos_com_aftype",
  "sos_comdur_af",
  "sos_comdur_af_cat",
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
  "sos_ddr_aad",
  "sos_ddr_ratecontrol",
  "sos_ddr_bbl",
  "sos_ddr_digoxin",
  "sos_ddr_rasiarni",
  "sos_ddr_diuretics",
  "sos_ddr_mra",
  "sos_ddr_antiplatlet",
  "sos_ddr_oralanticoagulant",
  "sos_ddr_lipidlowering",
  "sos_ddr_sglt2i_glp1a"
)

# vars fox log reg and cox reg
tabvars_not_in_mod <- c(
  "sos_comdur_af",

  "sos_com_aftype",

  "chadsvasc",
  "chadsvasc_cat",

  "sos_ddr_sglt2i_glp1a"
)

modvars <- c(tabvars[!(tabvars %in% tabvars_not_in_mod)])
