

##### Recipe Functions ####

###### 1 Recipe for ML Models ####

ml_recipe <- function(split){
  
  recipe(close ~ .,data = training(split)) %>%
    
    # Add Date features 
    step_timeseries_signature(date.x) %>%
    
    # Remove date 
    step_rm(date.x) %>%
    
    # Remove near zero var features 
    step_nzv(all_numeric_predictors()) %>%
    
    # Remove NAs
    step_naomit(all_predictors()) %>%
    
    # Convert id symbol into factor
    step_mutate(symbol = as.factor(symbol)) %>%
    
    # Dummy encoding
    step_dummy(all_nominal_predictors(),one_hot = TRUE)
  
}

  
  









