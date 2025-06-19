
##### Libraries #####

# Project Flow 
library(targets)
library(tarchetypes)

# Data Collection and Preparation
library(tidyquant)
library(tidyverse)
library(timetk)
library(wbstats)
library(TTR)

# Modeling
library(modeltime)
library(modeltime.gluonts)
library(modeltime.ensemble)
library(tidymodels)

# Viz 
library(DT)

#### Source Functions 
tar_source("functions/data_collection_functions.R")
tar_source("functions/data_eda_function_tk.R")
tar_source("functions/model_functions.R")
tar_source("functions/recipe_functions.R")
tar_source("functions/ensemble_models_functions.R")

#### Workflow #####

list(
  
  # Get Data 
  tar_target(
    name = data_raw,
    command =
      get_data(
        fx_symbols = c("EURUSD=X", "GBPUSD=X", "JPYUSD=X", "CADAUD=X"),
        from = "2000-01-01",
        country = c("GB","US","JP","CAD","AU")
        )
    ),
  
  #### EDA ####
  tar_target(
    name = diagnostics,
    command = 
      eda_tk(data = data_raw)
  ),
  
  # EDA Report
  tar_render(
    eda_report,
    path = "documents/eda_tk.Rmd",
    params = list(data = diagnostics)
  ),
  
  #### Future data for forecast ####
  tar_target(
    name = future_data,
    command = 
      data_raw %>%
      group_by(symbol) %>%
      future_frame(
        .date_var = date.x,
        .length_out = 30
        )
    ),
  
  #### Train / Test split #### 
  tar_target(
    name = splits,
    command = 
      time_series_split(
        data = data_raw,
        date_var = date.x,
        assess = 30,
        cumulative = TRUE
        )
    ),
  
  #### Modeling ####
  
  ###### Model 1 XGB ####
  tar_target(
    name = xgb_model,
    command = xgb_boost_functions(splits)
    ),
  
  ###### Model 2 ELASTIC NET ####
  tar_target(
    name = elastic_net_model,
    command = elastic_net_function(splits)
    ),
  
  ###### Model 3 MARS ####
  tar_target(
    name = mars_model,
    command = mars_function(splits)
    ),
  
  ###### Model 4 DeepAR ####
  tar_target(
    name = deep_ar_model,
    command = deep_ar_function(splits)
    ),
  
  ###### Model 5 Gaussian Process (GP) Forecaster ####
  tar_target(
    name = gp_model,
    command = gp_forecaster_function(splits)
    ),
  
  #### Ensemble Models ####
  
  ###### Mean Ensemble ####
  tar_target(
    name = ensemble_mean,
    command = mean_ensemble(
      xgb_model,
      elastic_net_model,
      mars_model,
      deep_ar_model,
      gp_model
      )
    ),
  
  ###### Weighted Ensemble ####
  tar_target(
    name = ensemble_weighted,
    command = weighted_ensemble(
      xgb_model,
      elastic_net_model,
      mars_model,
      deep_ar_model,
      gp_model,
      weights = c(1,1,0.5,1.5,1)
      )
    )
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
)