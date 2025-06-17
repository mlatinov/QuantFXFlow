
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
library(modeltime.ensemble)
library(tidymodels)

# Viz 
library(DT)

#### Source Functions 
tar_source("functions/data_collection_functions.R")
tar_source("functions/data_eda_function_tk.R")

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
  
  # EDA
  tar_target(
    name = diagnostics,
    command = 
      eda_tk(data = data_raw)
  ),
  
  # EDA Report
  tar_render(
    eda_report,
    path = "documents/eda_tk.Rmd",
    params = list(
      data = diagnostics
    )
  )
)