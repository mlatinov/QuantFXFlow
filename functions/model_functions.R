


#### ML Models ####

###### 1 XGB Function ####

xgb_boost_functions <- function(split){
  
  # Recipe 
  recipe_results <- ml_recipe(split)
  
  # Model Spec
  xgb_model <- boost_tree(learn_rate = 0.1) %>%
    set_mode("regression") %>%
    set_engine("xgboost")
  
  # Workflow 
  xgb_workflow <- workflow() %>%
    add_model(xgb_model) %>%
    add_recipe(recipe_results) %>%
    fit(training(split))
  
}

##### 2 ELASTIC NET Function ####

elastic_net_function <- function(split){
  
  # Recipe 
  recipe_results <- ml_recipe(split)
  
  # Model Spec
  elastic_net_model <- linear_reg(penalty = 1.5) %>%
    set_mode("regression") %>%
    set_engine("glmnet")
  
  # Workflow 
  elastic_net_workflow <- workflow() %>%
    add_model(elastic_net_model) %>%
    add_recipe(recipe_results) %>%
    fit(training(split))
}

##### 3 MARS Function ####

mars_function <- function(split){
  
  # Recipe 
  recipe_results <- ml_recipe(split)
  
  # Model Spec
  mars_model <- mars() %>%
    set_mode("regression") %>%
    set_engine("earth")
  
  # Workflow 
  mars_workflow <- workflow() %>%
    add_model(mars_model) %>%
    add_recipe(recipe_results) %>%
    fit(training(split))

}

#### GluonTS models ####

##### 4 DeepAR Function ####

deep_ar_function <- function(split){
  
  # Model Spec
  deep_ar_model <- deep_ar(
    id                 = "symbol",    
    freq               = "D",
    mode               = "regression",
    prediction_length  = 30,
    epochs             = 20,
    scale              = TRUE
    ) %>%
    fit(close ~ .,data = training(split))
  
}

##### 5 Gaussian Process (GP) Forecaster ####
gp_forecaster_function <- function(split){
  
  # GP Model
  gp_forecaster_model <- gp_forecaster(
    id                 = "symbol",    
    freq               = "D",
    mode               = "regression",
    prediction_length  = 30,
    epochs             = 20,
    scale              = TRUE  
  ) %>%
    fit(close ~ .,data = training(split))
  
}



