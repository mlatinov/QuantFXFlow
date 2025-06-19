

##### Recipe Functions ####

###### 1 Recipe for ML Models ####

ml_recipe <- function(splits){
  
    recipe <- recipe(close ~ .,data = training(splits)) %>%
      
      # Add Date features 
      step_timeseries_signature(date.x) %>%
      
      # Remove date 
      step_rm(date.x) %>%
      
      # Remove near zero var features 
      step_nzv(all_numeric_predictors()) %>%
      
      # Remove sub-day features
      step_rm(
        contains("hour"),
        contains("minute"),
        contains("second"),
        contains("am.pm"),
        contains("date"),
        contains("iso"),
        contains("xts")
      ) %>%
      # Convert id symbol into factor
      step_mutate(symbol = as.factor(symbol)) %>%
      
      # Dummy encoding
      step_dummy(all_nominal_predictors(),one_hot = TRUE)
        
}

  
  









