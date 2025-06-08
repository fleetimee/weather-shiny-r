# 🛠️ Deployment Troubleshooting Guide

Common issues and solutions when deploying the Indonesian Weather Visualization Shiny app.

## 📋 Quick Diagnostics

Before troubleshooting, run these quick checks:

```r
# Check if app runs locally
shiny::runApp("app.R")

# Verify required files exist
file.exists(c("app.R", "Opo.csv"))

# Check package installation
required_packages <- c("shiny", "shinydashboard", "DT", "plotly",
                      "dplyr", "ggplot2", "readr", "shinyWidgets")
missing <- required_packages[!required_packages %in% installed.packages()[,"Package"]]
if(length(missing) > 0) print(paste("Missing packages:", paste(missing, collapse=", ")))
```

## 🔧 shinyapps.io Issues

### Issue: "Account not configured"

```
Error: No account is configured.
```

**Solution:**

1. Get your token from shinyapps.io dashboard (Account → Tokens)
2. Run the token command:

```r
rsconnect::setAccountInfo(name='your-username',
                         token='your-token',
                         secret='your-secret')
```

### Issue: "Package installation failed"

```
Error during package installation
```

**Solutions:**

1. **Update R packages locally first:**

```r
update.packages(ask = FALSE)
source("install_packages.R")
```

2. **Force package reinstallation:**

```r
install.packages(c("shiny", "shinydashboard", "DT", "plotly",
                  "dplyr", "ggplot2", "readr", "shinyWidgets"),
                force = TRUE)
```

3. **Check R version compatibility:**

```r
# Minimum R 4.0.0 required
R.version.string
```

### Issue: "File not found: Opo.csv"

```
Warning: Error in file: cannot open the connection
```

**Solutions:**

1. **Check file exists in same directory as app.R:**

```r
list.files(pattern = "*.csv")
```

2. **Verify working directory:**

```r
getwd()  # Should contain both app.R and Opo.csv
```

3. **Check file permissions:**

```bash
ls -la Opo.csv
```

### Issue: "App timeout during startup"

```
Application failed to start (timeout)
```

**Solutions:**

1. **Optimize app startup:**

   - Move heavy computations outside reactive contexts
   - Cache data loading
   - Reduce package dependencies

2. **Increase memory allowance:**

   - Upgrade to paid shinyapps.io plan
   - Optimize data structures

3. **Check app logs:**
   - Go to shinyapps.io dashboard
   - Click on your app → Logs
   - Look for specific error messages

### Issue: "Memory limit exceeded"

```
Shiny application unexpectedly exited
```

**Solutions:**

1. **Data optimization:**

```r
# Check data size
object.size(weather_data)

# Optimize data types
weather_data$RainToday <- as.factor(weather_data$RainToday)
weather_data$RainTomorrow <- as.factor(weather_data$RainTomorrow)
```

2. **Remove unused objects:**

```r
# Add to app.R after data loading
rm(list = setdiff(ls(), c("weather_data", "ui", "server")))
gc()
```

## 🐳 Heroku Issues

### Issue: "Docker build failed"

```
Error: failed to build docker image
```

**Solutions:**

1. **Check Dockerfile syntax:**

   - Ensure proper indentation
   - Verify package names are correct

2. **Test Docker build locally:**

```bash
docker build -t weather-app .
docker run -p 3838:3838 weather-app
```

3. **Update base image:**

```dockerfile
# Try different base image if needed
FROM rocker/shiny:4.3.0
```

### Issue: "Port binding error"

```
Error: Cannot bind to port
```

**Solution:**
Update Dockerfile CMD to use Heroku's PORT environment variable:

```dockerfile
CMD ["R", "-e", "shiny::runApp('/srv/shiny-server/app.R', host='0.0.0.0', port=as.numeric(Sys.getenv('PORT', 3838)))"]
```

### Issue: "App crashes after deployment"

```
Application error - App crashed
```

**Solutions:**

1. **Check Heroku logs:**

```bash
heroku logs --tail -a your-app-name
```

2. **Verify environment variables:**

```bash
heroku config -a your-app-name
```

3. **Test locally with Heroku CLI:**

```bash
heroku local web
```

## 💾 Data Issues

### Issue: "Data loading failed"

```
Error in read_csv: could not find function
```

**Solutions:**

1. **Ensure readr is loaded:**

```r
library(readr)
# or use base R
data <- read.csv("Opo.csv")
```

2. **Check CSV format:**

```r
# Verify CSV structure
head(read.csv("Opo.csv", nrows = 5))
```

3. **Handle encoding issues:**

```r
data <- read.csv("Opo.csv", encoding = "UTF-8")
```

### Issue: "Incorrect data types"

```
Error in plot: object 'variable' not found
```

**Solution:**
Add robust data type conversion:

```r
# Add to data loading function
weather_data$MinTemp <- as.numeric(weather_data$MinTemp)
weather_data$MaxTemp <- as.numeric(weather_data$MaxTemp)
weather_data$RainToday <- as.factor(weather_data$RainToday)
```

## 🌐 Network Issues

### Issue: "Connection timeout"

```
Error: Timeout was reached
```

**Solutions:**

1. **Check internet connection**
2. **Try different network** (mobile hotspot)
3. **Use VPN** if behind corporate firewall
4. **Retry deployment** after some time

### Issue: "SSL certificate error"

```
Error: SSL certificate problem
```

**Solutions:**

1. **Update R and packages:**

```r
update.packages(ask = FALSE)
```

2. **Disable SSL verification (temporary):**

```r
httr::set_config(httr::config(ssl_verifypeer = FALSE))
```

## 📊 Performance Issues

### Issue: "Slow app loading"

```
App takes long time to load
```

**Solutions:**

1. **Optimize data loading:**

```r
# Cache data loading
weather_data <- local({
  if (!exists("cached_weather_data")) {
    cached_weather_data <<- read_csv("Opo.csv")
  }
  cached_weather_data
})
```

2. **Reduce initial computations:**

   - Move heavy calculations to reactive contexts
   - Use `req()` for conditional execution

3. **Optimize plots:**

```r
# Use sampling for large datasets
if (nrow(data) > 1000) {
  data <- data[sample(nrow(data), 1000), ]
}
```

### Issue: "Memory warnings"

```
Warning: Memory usage high
```

**Solutions:**

1. **Monitor memory usage:**

```r
# Add to server function
observe({
  invalidateLater(60000)  # Check every minute
  mem_usage <- pryr::mem_used()
  if (mem_usage > 200 * 1024^2) {  # 200 MB
    gc()  # Force garbage collection
  }
})
```

2. **Optimize data structures:**

```r
# Use appropriate data types
weather_data <- weather_data %>%
  mutate(across(where(is.character), as.factor))
```

## 🔍 Debugging Tips

### Enable Debug Mode

```r
# Add to server function
options(shiny.error = browser)
options(shiny.trace = TRUE)
```

### Add Logging

```r
# Add throughout your app
cat("Data loaded successfully:", nrow(weather_data), "rows\n")
cat("Selected variables:", input$x_variable, input$y_variable, "\n")
```

### Test Components Separately

```r
# Test data loading
data <- load_weather_data()
print(str(data))

# Test plotting functions
test_plot <- ggplot(data, aes(x = MaxTemp, y = MinTemp)) + geom_point()
print(test_plot)
```

## 📞 Getting Help

### Official Documentation

- [Shiny Deployment Guide](https://shiny.rstudio.com/deploy/)
- [shinyapps.io User Guide](https://docs.rstudio.com/shinyapps.io/)
- [Heroku R Documentation](https://devcenter.heroku.com/articles/r-support)

### Community Support

- [RStudio Community](https://community.rstudio.com/)
- [Stack Overflow - Shiny](https://stackoverflow.com/questions/tagged/shiny)
- [GitHub Issues](https://github.com/rstudio/shiny/issues)

### Reporting Issues

When asking for help, include:

1. **Error message** (full text)
2. **R version:** `R.version.string`
3. **Package versions:** `sessionInfo()`
4. **Deployment platform** (shinyapps.io, Heroku, etc.)
5. **Steps to reproduce** the error

---

**Remember:** Most deployment issues are due to package conflicts or missing dependencies. Start with a fresh R session and reinstall packages if problems persist!
