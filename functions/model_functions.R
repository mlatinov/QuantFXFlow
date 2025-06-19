


#### ML Models ####

###### 1 XGB Function ####

xgb_boost_functions <- function(splits){
  
  # Recipe 
  recipe_results <- ml_recipe(splits)
  
  # Model Spec
  xgb_model <- boost_tree(learn_rate = 0.1) %>%
    set_mode("regression") %>%
    set_engine("xgboost")
  
  # Workflow 
  xgb_workflow <- workflow() %>%
    add_model(xgb_model) %>%
    add_recipe(recipe_results) %>%
    fit(training(splits))
  
}

##### 2 ELASTIC NET Function ####

elastic_net_function <- function(splits){
  
  # Recipe 
  recipe_results <- ml_recipe(splits)
  
  # Model Spec
  elastic_net_model <- linear_reg(penalty = 1.5) %>%
    set_mode("regression") %>%
    set_engine("glmnet")
  
  # Workflow 
  elastic_net_workflow <- workflow() %>%
    add_model(elastic_net_model) %>%
    add_recipe(recipe_results) %>%
    fit(training(splits))
}

##### 3 MARS Function ####

mars_function <- function(splits){
  
  # Recipe 
  recipe_results <- ml_recipe(splits)
  
  # Model Spec
  mars_model <- mars() %>%
    set_mode("regression") %>%
    set_engine("earth")
  
  # Workflow 
  mars_workflow <- workflow() %>%
    add_model(mars_model) %>%
    add_recipe(recipe_results) %>%
    fit(training(splits))

}

#### GluonTS models ####

##### 4 DeepAR Function ####

deep_ar_function <- function(splits){
  
  # Model Spec
  deep_ar_model <- deep_ar(
    id                 = "symbol",    
    freq               = "D",
    mode               = "regression",
    prediction_length  = 30,
    lookback_length    = 30, 
    epochs             = 20,
    scale              = TRUE
    ) %>%
    set_engine("gluonts_deepar") %>%
    fit(close ~ .,data = training(splits))
  
}

##### 5 Gaussian Process (GP) Forecaster ####
gp_forecaster_function <- function(splits){
  
  # GP Model
  gp_forecaster_model <- gp_forecaster(
    id                 = "symbol",    
    freq               = "D",
    mode               = "regression",
    prediction_length  = 30,
    lookback_length    = 30, 
    epochs             = 20,
    scale              = TRUE  
  ) %>%
    set_engine("gluonts_gp_forecaster") %>%
    fit(close ~ .,data = training(splits))
  
}



