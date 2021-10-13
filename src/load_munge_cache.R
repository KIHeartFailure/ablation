# 1. Set options in config/global.dcf
# 2. Load packages listed in config/global.dcf
# 3. Import functions and code in lib directory
# 4. Load data in data directory
# 5. Run data manipulations in munge directory

memory.limit(size = 10000000000000)

ProjectTemplate::reload.project(
  reset = TRUE,
  data_loading = TRUE,
  data_ignore = "",
  munging = TRUE
)

ProjectTemplate::cache("tabvars")
ProjectTemplate::cache("modvars")

ProjectTemplate::cache("flowrs")
ProjectTemplate::cache("flowcase")
ProjectTemplate::cache("flowcontrol")
ProjectTemplate::cache("metalm")
ProjectTemplate::cache("metaout")

ProjectTemplate::cache("matchingn")

ProjectTemplate::cache("pop")
ProjectTemplate::cache("matchpop")

ProjectTemplate::cache("pop_rec_hosphf")
ProjectTemplate::cache("matchpop_rec_hosphf")
