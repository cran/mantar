## ----include = FALSE----------------------------------------------------------
knitr::opts_chunk$set(
  collapse = TRUE,
  comment = "#>"
)

## ----craninstall, eval = FALSE------------------------------------------------
# install.packages("mantar")

## ----remoteinstall, eval = FALSE----------------------------------------------
# # install.packages("remotes")
# remotes::install_github("kai-nehler/mantar@develop")

## ----loadmantar---------------------------------------------------------------
library(mantar)

## ----example------------------------------------------------------------------
# Load some example data sets for the ReadMe
data(mantar_dummy_full_cont)
data(mantar_dummy_full_cat)
data(mantar_dummy_mis_cont)

# Preview the first few rows of these data sets
head(mantar_dummy_full_cont)
head(mantar_dummy_full_cat)
head(mantar_dummy_mis_cont)

## ----example_network----------------------------------------------------------
# Estimate network from full data set using BIC, the and rule as well as treating the data as continuous
result_full_cont <- neighborhood_net(data = mantar_dummy_full_cont, 
                                     ic_type = "bic", 
                                     pcor_merge_rule = "and",
                                     ordered = FALSE)

# View estimated partial correlations
result_full_cont

## ----example_network_ord------------------------------------------------------
# Estimate network from full data set using BIC, the and rule as well as treating the
# data as ordered categorical
result_full_cat <- neighborhood_net(data = mantar_dummy_full_cat,
                                    ic_type = "bic",  
                                    pcor_merge_rule = "and",
                                    ordered = TRUE)

# View estimated partial correlations
result_full_cat

## ----example_network_mis, results = "hide"------------------------------------
# Estimate network for data set with missing values
result_mis_cont <- neighborhood_net(data = mantar_dummy_mis_cont,
                                    n_calc = "individual", 
                                    missing_handling = "stacked-mi",
                                    nimp = 20,
                                    imp_method = "pmm",
                                    pcor_merge_rule = "and")

## ----example_network_mis_view-------------------------------------------------
# View estimated partial correlations
result_mis_cont

## ----example_reg_network------------------------------------------------------
# Estimate network from full data set using BIC and the glasso penalty
result_full_cont <- regularization_net(data = mantar_dummy_full_cont,
                                       penalty = "glasso",
                                       vary = "lambda",
                                       n_lambda = 100,
                                       lambda_min_ratio = 0.1,
                                       ic_type = "bic", 
                                       pcor_merge_rule = "and",
                                       ordered = FALSE)

# View estimated partial correlations
result_full_cont


## ----example_reg_network_mis--------------------------------------------------
# Estimate network for data set with missing values
result_mis_cont <- regularization_net(data = mantar_dummy_mis_cont,
                                      likelihood = "obs_based",
                                      penalty = "glasso",
                                      vary = "lambda",
                                      n_lambda = 100,
                                      lambda_min_ratio = 0.1,
                                      ic_type = "ebic",
                                      extended_gamma = 0.5,
                                      n_calc = "average",
                                      missing_handling = "two-step-em",
                                      pcor_merge_rule = "and",
                                      ordered = FALSE)

# View estimated partial correlations
result_mis_cont

## ----example_data_prep, message=FALSE, warning=FALSE--------------------------
url <- "https://osf.io/download/6s9p4/"

zipfile <- file.path(tempdir(), "vervaet.zip")
exdir <- file.path(tempdir(), "vervaet")

dir.create(exdir, recursive = TRUE, showWarnings = FALSE)

download.file(url, destfile = zipfile, mode = "wb")
unzip(zipfile, exdir = exdir)

load(file.path(exdir, "Supplementary materials", "Dataset.RData"))


## ----example_data_miss--------------------------------------------------------
colMeans(is.na(Data))

## ----ordered_cat--------------------------------------------------------------
summary(Data)

## ----example_final_network----------------------------------------------------
final_result <- neighborhood_net(data = Data,
                                 n_calc = "individual",
                                 missing_handling = "two-step-em",
                                 pcor_merge_rule = "and",
                                 ordered = FALSE)

## ----example_final_network_view-----------------------------------------------
final_result$pcor

## ----example_final_network_summary--------------------------------------------
summary(final_result)

## ----example_final_network_plot, message=FALSE, warning=FALSE-----------------
Groups <- c(rep("EDI-II", 11), rep("BDI", 1), rep("STAI", 1), rep("RS-NL", 1), 
  rep("TCI", 7), rep("YSQ", 5), rep("FMPS", 6))

# Create names for legend
Names <- c("Drive for Thinness", "Bulimia","Body Dissatisfaction", "Ineffectiveness", "Perfectionism", 
  "Interpersonal Distrust ", "Interoceptive Awareness ", "Maturity Fears", "Asceticism", 
  "Impulse Regulation","Social Insecurity", "Depression", "Anxiety", "Resilience", "Novelty Seeking", 
  "Harm Avoidance", "Reward Dependence", "Persistence", "Self-Directedness", "Cooperativeness", 
  "Self- Transcendence", "Disconnection and Rejection", "Impaired Autonomy & Performance",
  "Impaired Limits", "Other-directness", "Overvigilance & Inhibition", "Concern over Mistakes", 
  "Personal Standards", "Parental Expectations", "Parental Criticism", "Doubting of Actions", "Order and Organisation")


Lab_Colors <- c(rep('white', 11),
  rep('white', 1),
  rep('black', 1),
  rep('white', 1),
  rep('black', 7),
  rep('black', 5),
  rep('white', 6))

plot(final_result,
    layout = 'spring',
  nodeNames = Names,
  groups = Groups,
  label.color = Lab_Colors,
  vsize = 5, 
  legend.cex = 0.15, 
  label.cex = 1.25,
  negCol = "#7A0403FF",
  posCol = "#00204DFF")

