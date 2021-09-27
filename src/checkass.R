
ProjectTemplate::reload.project()

checkassfunc <- function(time, event) {
  modc <- coxph(formula(paste0("Surv(", time, ",", event, "=='Yes') ~ ablation + ", paste(modvarsns, collapse = " + "))),
    data = pop
  )

  modm <- coxme(formula(paste0("Surv(", time, ",", event, "=='Yes') ~ ablation + (1 | par)")),
    data = matchpop
  )

  # Checking for non-prop hazards -------------------------------------------

  testpat <- cox.zph(modc)
  print(sig <- testpat$table[testpat$table[, 3] < 0.05, ])

  testpat <- cox.zph(modm)
  print(sig <- testpat$table[testpat$table[, 3] < 0.05, ])
}


checkassfunc(
  time = "sos_outtime_hosphf",
  event = "sos_out_deathhosphf"
)

checkassfunc(
  time = "sos_outtime_death",
  event = "sos_out_death"
)

checkassfunc(
  time = "sos_outtime_hosphf",
  event = "sos_out_hosphf"
)

checkassfunc(
  time = "sos_outtime_hospstroketia",
  event = "sos_out_hospstroketia"
)

checkassfunc(
  time = "sos_outtime_death",
  event = "sos_out_deathcv"
)

checkassfunc(
  time = "sos_outtime_hospcv",
  event = "sos_out_hospcv"
)

checkassfunc(
  time = "sos_outtime_hospany",
  event = "sos_out_hospany"
)

ProjectTemplate::reload.project()

checkassfunc2 <- function(time, event) {
  modc <- coxph(formula(paste0("Surv(", time, ",", event, "=='Yes') ~ ablation + ", paste(modvarsns, collapse = " + "))),
    data = pop
  )

  # Checking for multicollinerity -------------------------------------------

  myvif <- rms::vif(modc)
  print(myvif[myvif > 2])
}

checkassfunc2(
  time = "sos_outtime_hosphf",
  event = "sos_out_deathhosphf"
)

checkassfunc2(
  time = "sos_outtime_death",
  event = "sos_out_death"
)

checkassfunc2(
  time = "sos_outtime_hosphf",
  event = "sos_out_hosphf"
)

checkassfunc2(
  time = "sos_outtime_hospstroketia",
  event = "sos_out_hospstroketia"
)

checkassfunc2(
  time = "sos_outtime_death",
  event = "sos_out_deathcv"
)

checkassfunc2(
  time = "sos_outtime_hospcv",
  event = "sos_out_hospcv"
)

checkassfunc2(
  time = "sos_outtime_hospany",
  event = "sos_out_hospany"
)

checkassfunc3 <- function(time, event) {

  # Checking for linearity -------------------------------------------

  survminer::ggcoxfunctional(formula(paste0("Surv(", time, ",", event, "=='Yes') ~ shf_age +
                                   indexyear + sos_comdur_af")), data = pop)
}

checkassfunc3(
  time = "sos_outtime_hosphf",
  event = "sos_out_deathhosphf"
)

checkassfunc3(
  time = "sos_outtime_death",
  event = "sos_out_death"
)

checkassfunc3(
  time = "sos_outtime_hosphf",
  event = "sos_out_hosphf"
)

checkassfunc3(
  time = "sos_outtime_hospstroketia",
  event = "sos_out_hospstroketia"
)

checkassfunc3(
  time = "sos_outtime_death",
  event = "sos_out_deathcv"
)

checkassfunc3(
  time = "sos_outtime_hospcv",
  event = "sos_out_hospcv"
)

checkassfunc3(
  time = "sos_outtime_hospany",
  event = "sos_out_hospany"
)
