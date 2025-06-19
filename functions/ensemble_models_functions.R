


##### Ensemble Models ####

#### 1 Average Ensemble ####
mean_ensemble <- function(...){
  
  # Make a Modeltime Table 
  mean_ensemble <- modeltime_table(...) %>%
    
    # Mean Ensemble
    ensemble_average(type = "mean")

}

#### 2 WEIGHTED Ensemble ####
weighted_ensemble <- function(weights,...){
  
  # Make a modeltime Table
  weighted_ensemble <- modeltime_table(...) %>%
    
    # Weighted Ensemble
    ensemble_weighted(
      loadings = weights,
      scale_loadings = TRUE
      )
}