


#### Data Collection ####

##### Get data function 

get_data <- function(fx_symbols,from,country){
  
  # Get historical daily data 
  fx_data <- tq_get(
    fx_symbols,
    get = "stock.prices",
    from = from,
    to = Sys.Date()
  ) %>%
    mutate(
      year = year(date),
      close = round(close, 5),
      high  = round(high, 5),
      low   = round(low, 5)
    ) %>% 
    # Fill the missing values with the last one observed
    fill(where(is.numeric), .direction = "down")
  
  # Macro Indicators
  indicator_codes <- c(
    "FR.INR.LEND",       # Interest rate
    "FP.CPI.TOTL",       # Inflation
    "NY.GDP.MKTP.CD",    # GDP
    "NY.GDP.MKTP.KD.ZG", # GDP growth
    "BN.CAB.XOKA.GD.ZS", # Current account
    "GC.DOD.TOTL.GD.ZS", # Government debt
    "SL.UEM.TOTL.ZS",    # Unemployment
    "BX.KLT.DINV.CD.WD"  # FDI
  )
  
  # Get marco data
  macro_data <- 
    
    # Get the data
    wb_data(
    country = country,
    indicator = indicator_codes,
    start_date = year(from),
    end_date = as.numeric(format(Sys.Date(), "%Y"))
  ) %>%
    
    # Remove ISOs 
    select(-iso2c,-iso3c) %>%
    
    # Extract the year
    mutate(
      year = date
    ) %>%
    
    # Pivot wider with countries
    pivot_wider(
      names_from = country,
      values_from = c(indicator_codes)
    ) %>%
    
    # Fill the missing values with the last one observed
    fill(where(is.numeric), .direction = "down")
  
  # Combine FX and marco
  fx_marco <- fx_data %>%
    left_join(y = macro_data,by = "year")
  
  # Add TA 
  fx_marco_ta <- fx_marco %>%
    group_by(symbol) %>%
    arrange(date.x, .by_group = TRUE) %>%
    mutate(
      
      # Moving Averages 
      sma_20 = SMA(close, n = 20),
      sma_50 = SMA(close, n = 50),
      sma_100 = SMA(close, n = 100),
      
      # Trend Indicators
      tdi = TDI(price = close, n = 30, multiple = 2),
      cci = CCI(HLC = select(cur_data(), high, low, close), n = 30),
      adx = ADX(HLC = select(cur_data(), high, low, close), n = 30)[, "ADX"],
      vhf = VHF(price = close, n = 30),
      
      # Volatility
      atr = ATR(HLC = select(cur_data(), high, low, close), n = 14)[, "atr"],
      bbands_up = BBands(HLC = select(cur_data(), high, low, close), n = 20)[, "up"],
      bbands_dn = BBands(HLC = select(cur_data(), high, low, close), n = 20)[, "dn"],
      bbands_mavg = BBands(HLC = select(cur_data(), high, low, close), n = 20)[, "mavg"],
      donchian_high = DonchianChannel(HL = select(cur_data(), high, low), n = 10)[, "high"],
      donchian_low = DonchianChannel(HL = select(cur_data(), high, low), n = 10)[, "low"],
      run_sd_10 = runSD(close, n = 10),
      
      # Momentum
      momentum_10 = TTR::momentum(close,10),
      roc_10 = ROC(close, n = 10),
      rsi_14 = RSI(close, n = 14),
      macd = MACD(close, nFast = 12, nSlow = 26, nSig = 9)[, "macd"],
      macd_signal = MACD(close, nFast = 12, nSlow = 26, nSig = 9)[, "signal"],
      stoch_k = stoch(HLC = select(cur_data(), high, low, close))[, "fastK"],
      stoch_d = stoch(HLC = select(cur_data(), high, low, close))[, "fastD"]
      
    ) %>%
    ungroup() %>%
    select(-date.y,-volume)
  
}







