
ProjectTemplate::reload.project()

memory.limit(size = 10000000000000)

# Import LM from SoS -----------------------------------------------------

sospath <- "C:/Users/Lina/STATISTIK/Projects/20200225_shfdb3/dm/raw-data/SOS/lev3_15875_2019 Lina Benson/"

load(paste0(sospath, "RData/lm.RData"))

# Select ATC codes --------------------------------------------------------

lmsel <- lm %>%
  mutate(atcneed = stringr::str_detect(ATC, "^(C0|B01A|C10|A10B)")) %>%
  filter(
    ANTAL >= 0,
    # AR >= 2013,
    # AR <= 2018,
    atcneed
  )

# Store as RData in /data folder ------------------------------------------

save(file = "./data/lmsel.RData", list = c("lmsel"))

# Patient registry from SHFDB3 v 3.2.2, prepared in 08-prep_sosdata.R -----

load(file = "C:/Users/Lina/STATISTIK/Projects/20200225_shfdb3/dm/data/patreg.RData")

# Store as RData in /data folder ------------------------------------------

save(file = "./data/patreg.RData", list = c("patreg"))

# Death data ----------------------------------------------------------------

load(file = "C:/Users/Lina/STATISTIK/Projects/20200225_shfdb3/dm/data/rawData_sosdors.RData")

# Store as RData in /data folder ------------------------------------------

save(file = "./data/rawData_sosdors.RData", list = c("rawData_sosdors"))

# SCB data ----------------------------------------------------------------

load(file = "C:/Users/Lina/STATISTIK/Projects/20200225_shfdb3/dm/data/rawData_scb.RData")

# Store as RData in /data folder ------------------------------------------

save(file = "./data/rawData_scb.RData", list = c("rawData_scb"))

# UCR data ----------------------------------------------------------------

load(file = "C:/Users/Lina/STATISTIK/Projects/20200225_shfdb3/dm/data/rawData_rs.RData")

# Store as RData in /data folder ------------------------------------------

save(file = "./data/rawData_rs.RData", list = c("rawData_rs"))
