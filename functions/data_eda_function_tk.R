
##### EDA Function #####


eda_tk <- function(data){
  
  # Group the data
  data_grouped <- data %>%
    group_by(symbol)
  
  # View the general structure
  str_plot <- data_grouped %>%
    tk_summary_diagnostics(.date_var = date.x) %>%
    datatable()
  
  # Plot Time Series 
  plot_tk <- data_grouped %>%
    plot_time_series(
      .date_var = date.x,
      .value = close
    )
  
  # ACF 
  acf_plot <- data_grouped %>%
    plot_acf_diagnostics(.date_var = date.x,.value = close,.lags = 50)
  
  #Ljung-Box Tests
  ljung_box <- data_grouped %>%
    group_modify(~ {
      box_result <- Box.test(.x$close, type = "Ljung-Box")
      tibble(
        statistic = box_result$statistic,
        p_value = box_result$p.value
      )
    }) %>%
    datatable()
  
  # Anomalies	Spike detection #
  spike_plot <- data_grouped %>%
    plot_anomaly_diagnostics(.date_var = date.x,.value = close)
  
  
  # Retrun 
  return(list(
    str_plot = str_plot,
    plot_tk  = plot_tk,
    acf_plot = acf_plot,
    ljung_box = ljung_box,
    spike_plot = spike_plot
  ))
}


