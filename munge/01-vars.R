

# Variables for tabs/mods -------------------------------------------------

tabvars <- c(
  # demo
  "shf_age",
  "shf_sex",
  "indexyear",

  "shf_ef_cat",

  # socec
  "scb_education",
  "scb_education_mis",
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

  # treatments
  "ddr_aad",
  "ddr_ratecontrol",
  "ddr_bbl",
  "ddr_digoxin"
)

# vars fox log reg and cox reg
tabvars_not_in_mod <- c(
  "sos_com_afparoxysmal",
  "sos_com_afpersistent",
  # "sos_comdur_af",

  "scb_education",

  "chadsvasc",
  "chadsvasc_cat"
)

modvars <- c(tabvars[!(tabvars %in% tabvars_not_in_mod)])
