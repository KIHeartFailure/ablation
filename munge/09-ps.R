

# Propensity scores -------------------------------------------------------

# All patients ------------------------------------------------------------

ps <- glm(formula(paste0(
  "ablation == 'Yes' ~ ", paste(modvars, collapse = " + ")
)),
data = pop,
family = binomial
)

popps <- bind_cols(
  pop %>% drop_na(any_of(modvars)),
  ps = ps$fitted.values
)

pop <- left_join(pop,
  popps %>%
    select(
      LopNr,
      indexdtm,
      ps
    ),
  by = c("LopNr", "indexdtm")
)

# Matching ----------------------------------------------------------------

tmpdata <- pop %>%
  filter(!is.na(ps)) %>%
  mutate(
    par = NA
  )

cal <- 0.01 / sd(tmpdata %>% pull(ps))

set.seed(2334325)
match1 <- Match(
  Tr = tmpdata$ablationnum,
  X = tmpdata %>% pull(ps),
  estimand = "ATT",
  caliper = cal,
  replace = F,
  ties = F,
  M = 1
)
set.seed(2334325)
match2 <- Match(
  Tr = tmpdata$ablationnum,
  X = tmpdata %>% pull(ps),
  estimand = "ATT",
  caliper = cal,
  replace = F,
  ties = F,
  M = 2
)
set.seed(2334325)
match3 <- Match(
  Tr = tmpdata$ablationnum,
  X = tmpdata %>% pull(ps),
  estimand = "ATT",
  caliper = cal,
  replace = F,
  ties = F,
  M = 3
)
set.seed(2334325)
match4 <- Match(
  Tr = tmpdata$ablationnum,
  X = tmpdata %>% pull(ps),
  estimand = "ATT",
  caliper = cal,
  replace = F,
  ties = F,
  M = 4
)
set.seed(2334325)
match5 <- Match(
  Tr = tmpdata$ablationnum,
  X = tmpdata %>% pull(ps),
  estimand = "ATT",
  caliper = cal,
  replace = F,
  ties = F,
  M = 5
)
matchingn <- paste0(
  "org data, N = ", sum(tmpdata$ablationnum), ", ",
  "1:1: N = ", match1$wnobs, ", ",
  "1:2: N = ", match2$wnobs, ", ",
  "1:3: N = ", match3$wnobs, ", ",
  "1:4: N = ", match4$wnobs, ", ",
  "1:5: N = ", match5$wnobs
)

tmpdata$par[c(unique(match2$index.treated), match2$index.control)] <-
  c(1:match2$wnobs, rep(1:match2$wnobs, each = 2))

matchpop <- tmpdata[c(unique(match2$index.treated), match2$index.control), ]
