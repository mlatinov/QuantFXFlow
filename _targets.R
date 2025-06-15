
##### Libraries #####

# Project Flow 
library(targets)
library(tarchetypes)

# Data Collection and Preparation
library(tidyquant)
library(tidyverse)
library(wbstats)
library(TTR)

# Modeling
library(modeltime)
library(modeltime.ensemble)
library(tidymodels)

#### Source Functions 
tar_source("functions/data_collection_functions.R")

country = c("GB","US")
fx_symbols <- c("EURUSD=X", "GBPUSD=X", "JPY=X", "CAD=X")

#### Workflow #####

list(
  
  # Get Data 
  tar_target(
    name = data_raw,
    command =
      get_data(
        fx_symbols = c("EURUSD=X", "GBPUSD=X", "JPY=X", "CAD=X"),
        from = 2000,
        country = c("GB","US")
        )
    )
  
  
)