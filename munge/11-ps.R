

# Propensity scores -------------------------------------------------------

psfunction <- function(psdata = popps, psname, modvarsps = modvars, allratio = FALSE) {
  ps <- glm(formula(paste0(
    "ablation == 'Yes' ~ ", paste(modvarsps, collapse = " + ")
  )),
  data = psdata,
  family = binomial
  )

  psdata <- bind_cols(
    psdata,
    !!sym(psname) := ps$fitted.values
  ) %>%
    select(
      LopNr,
      indexdtm,
      !!sym(psname)
    )

  pop <<- left_join(
    pop,
    psdata,
    by = c("LopNr", "indexdtm")
  )

  # Matching ----------------------------------------------------------------

  tmpdata <- pop %>%
    filter(!is.na(!!sym(psname))) %>%
    mutate(
      par = NA
    )

  cal <- 0.01 / sd(tmpdata %>% pull(!!sym(psname)))

  set.seed(2334325)
  match2 <- Match(
    Tr = tmpdata$ablationnum,
    X = tmpdata %>% pull(!!sym(psname)),
    estimand = "ATT",
    caliper = cal,
    replace = F,
    ties = F,
    M = 2
  )

  if (allratio) {
    set.seed(2334325)
    match1 <- Match(
      Tr = tmpdata$ablationnum,
      X = tmpdata %>% pull(!!sym(psname)),
      estimand = "ATT",
      caliper = cal,
      replace = F,
      ties = F,
      M = 1
    )
    set.seed(2334325)
    match3 <- Match(
      Tr = tmpdata$ablationnum,
      X = tmpdata %>% pull(!!sym(psname)),
      estimand = "ATT",
      caliper = cal,
      replace = F,
      ties = F,
      M = 3
    )
    set.seed(2334325)
    match4 <- Match(
      Tr = tmpdata$ablationnum,
      X = tmpdata %>% pull(!!sym(psname)),
      estimand = "ATT",
      caliper = cal,
      replace = F,
      ties = F,
      M = 4
    )
    set.seed(2334325)
    match5 <- Match(
      Tr = tmpdata$ablationnum,
      X = tmpdata %>% pull(!!sym(psname)),
      estimand = "ATT",
      caliper = cal,
      replace = F,
      ties = F,
      M = 5
    )
    matchingn <<- paste0(
      "org data: N = ", sum(pop$ablationnum), ", ",
      "org no-missing data: N = ", sum(tmpdata$ablationnum), ", ",
      "1:1: N = ", match1$wnobs, ", ",
      "1:2: N = ", match2$wnobs, ", ",
      "1:3: N = ", match3$wnobs, ", ",
      "1:4: N = ", match4$wnobs, ", ",
      "1:5: N = ", match5$wnobs
    )
  }

  tmpdata$par[c(unique(match2$index.treated), match2$index.control)] <-
    c(1:match2$wnobs, rep(1:match2$wnobs, each = 2))

  matchpop <- tmpdata[c(unique(match2$index.treated), match2$index.control), ]

  return(matchpop)
}


# Main analysis -----------------------------------------------------------

popps <- pop %>% drop_na(any_of(modvars))

matchpop <- psfunction(psdata = popps, psname = "ps", allratio = T)


# Excluding Unclassified/Unknown AF ---------------------------------------

popps <- pop %>%
  filter(sos_com_aftype != "Unclassified/Unknown") %>%
  drop_na(any_of(modvars))

matchpop_excl_unsaf <- psfunction(psdata = popps, psname = "ps_excl_unsaf", allratio = F)


# Only AAD -----------------------------------------------------------------

popps <- pop %>%
  filter(sos_ddr_aad == "Yes") %>%
  drop_na(any_of(c(modvars[modvars != "sos_ddr_aad"])))

matchpop_aad <- psfunction(psdata = popps, modvarsps = c(modvars[modvars != "sos_ddr_aad"]), psname = "ps_aad", allratio = F)


# Only rate control ---------------------------------------------------------

popps <- pop %>%
  filter(sos_ddr_ratecontrolbbldigoxin == "Yes") %>%
  drop_na(any_of(c(modvars[!modvars %in% c("sos_ddr_aad")])))

matchpop_rc <- psfunction(
  psdata = popps,
  modvarsps = modvars[!modvars %in% c("sos_ddr_aad")],
  psname = "ps_rc", allratio = F
)


# Including heart rate ----------------------------------------------------

popps <- pop %>% drop_na(any_of(c(modvars, "shf_heartrate")))

matchpop_heartrate <- psfunction(psdata = popps, modvarsps = c(modvars, "shf_heartrate"), psname = "ps_heartrate", allratio = F)


# Excluding sotalol and disopyramid ----------------------------------------

popps <- pop %>%
  filter(sos_ddr_sotalol == "No" & sos_ddr_disopyramid == "No") %>%
  drop_na(any_of(modvars))

matchpop_excl_sotdis <- psfunction(psdata = popps, psname = "ps_excl_sotdis", allratio = F)
