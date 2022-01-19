

# Additional variables from mainly SHF ------------------------------------
pop <- pop %>%
  mutate(
    ablationnum = if_else(ablation == "Yes", 1, 0),

    shf_ef_cat = factor(case_when(
      shf_ef == ">=50" ~ 3,
      shf_ef == "40-49" ~ 2,
      shf_ef %in% c("30-39", "<30") ~ 1
    ),
    labels = c("HFrEF", "HFmrEF", "HFpEF"),
    levels = 1:3
    ),

    sos_comdur_af_cat = factor(case_when(
      sos_comdur_af < 365 / 2 ~ 1,
      sos_comdur_af < 365 ~ 2,
      sos_comdur_af <= 365 * 3 ~ 3,
      sos_comdur_af > 365 * 3 ~ 4
    ),
    levels = 1:4, labels = c("<0.5 years", "0.5-1 years", "1-3 years", ">3 years")
    ),

    sos_com_aftype = case_when(
      sos_com_afpersistent == "Yes" ~ "Persistent AF",
      sos_com_afparoxysmal == "Yes" ~ "Paroxysmal AF",
      TRUE ~ "Unclassified/Unknown"
    ),

    # chadsvasc
    chadsvasc = 1 + # hf
      if_else(sos_com_hypertension == "Yes", 1, 0) +
      if_else(shf_age >= 75, 1, 0) +
      if_else(shf_age >= 65, 1, 0) +
      if_else(sos_com_diabetes == "Yes", 1, 0) +
      if_else(sos_com_stroketia == "Yes", 1, 0) +
      if_else(sos_com_peripheralartery == "Yes" | sos_com_mi == "Yes", 1, 0) +
      if_else(shf_sex == "Female", 1, 0),

    chadsvasc_cat = factor(if_else(chadsvasc < 2, 1, 2), levels = 1:2, labels = c("<2", ">=2")),

    # combined outcomes
    sos_out_deathhosphf = case_when(
      sos_out_death == "Yes" |
        sos_out_hosphf == "Yes" ~ "Yes",
      TRUE ~ "No"
    ),

    sos_out_nodeathhosphf = if_else(sos_out_death == "Yes", sos_out_nohosphf + 1, sos_out_nohosphf),

    # comp risk
    sos_out_hosphf_cr = create_crevent(sos_out_hosphf, sos_out_death),
    sos_out_hospstroketia_cr = create_crevent(sos_out_hospstroketia, sos_out_death),
    sos_out_hospcv_cr = create_crevent(sos_out_hospcv, sos_out_death),
    sos_out_hospany_cr = create_crevent(sos_out_hospany, sos_out_death),
    sos_out_deathcv_cr = create_crevent(sos_out_deathcv, sos_out_death)
  )

pop <- pop %>%
  mutate(across(where(is_character), as_factor))
