# Automated Deployment Script for shinyapps.io
# Indonesian Weather Visualization App
# Uses default values for automated deployment

# Set CRAN mirror and SSL options
options(repos = c(CRAN = "https://cran.rstudio.com/"))
options(rsconnect.check.certificate = FALSE)

# Install required packages if not already installed
required_packages <- c(
  "rsconnect",     # For deployment
  "shiny",         # Core Shiny framework
  "shinydashboard", # Dashboard layout
  "DT",            # Interactive data tables
  "plotly",        # Interactive plots
  "dplyr",         # Data manipulation
  "ggplot2",       # Static plotting
  "readr",         # CSV file reading
  "shinyWidgets"   # Enhanced UI widgets
)

# Check and install missing packages
missing_packages <- required_packages[!required_packages %in% installed.packages()[,"Package"]]
if(length(missing_packages) > 0) {
  cat("Installing missing packages:", paste(missing_packages, collapse = ", "), "\n")
  install.packages(missing_packages)
}

# Load rsconnect package
library(rsconnect)

# Configuration
cat("=== AUTOMATED SHINYAPPS.IO DEPLOYMENT ===\n\n")

# Check if account is configured
accounts <- rsconnect::accounts()
if(nrow(accounts) == 0) {
  cat("❌ No shinyapps.io account configured!\n\n")
  cat("To configure your account, run:\n")
  cat("1. Rscript setup_shinyapps_account.R\n")
  cat("2. Follow the instructions to set up your token\n")
  cat("3. Then run this script again\n\n")
  cat("Alternatively, run your token command directly:\n")
  cat("rsconnect::setAccountInfo(name='your-username',\n")
  cat("                         token='your-token',\n")
  cat("                         secret='your-secret')\n")
  stop("Account configuration required")
} else {
  cat("✅ Account configured:", accounts$name[1], "\n\n")
}

# Pre-deployment checks
cat("Running pre-deployment checks...\n")

# Check if required files exist
required_files <- c("app.R", "Opo.csv")
missing_files <- required_files[!file.exists(required_files)]

if(length(missing_files) > 0) {
  cat("❌ Missing required files:", paste(missing_files, collapse = ", "), "\n")
  stop("Please ensure all required files are in the current directory")
} else {
  cat("✅ All required files present\n")
}

# Test app locally before deployment
cat("Testing app locally...\n")
tryCatch({
  # Quick validation - try to load the app without running it
  source("app.R", local = TRUE)
  cat("✅ App loads successfully\n")
}, error = function(e) {
  cat("❌ App failed to load:", e$message, "\n")
  stop("Please fix app errors before deployment")
})

# Default deployment configuration
app_name <- "indonesian-weather-viz"
app_title <- "Indonesian Weather Visualization by Novian Andika"

cat("\nDeployment Configuration:\n")
cat("App Name:", app_name, "\n")
cat("App Title:", app_title, "\n")
cat("Files to deploy:", paste(required_files, collapse = ", "), "\n")

# Deploy the application
cat("\n🚀 Starting automated deployment to shinyapps.io...\n")
cat("This may take several minutes...\n\n")

tryCatch({
  rsconnect::deployApp(
    appName = app_name,
    appTitle = app_title,
    appFiles = required_files,
    forceUpdate = TRUE,
    launch.browser = FALSE  # Don't open browser in automated mode
  )
  
  # Success message
  account_name <- accounts$name[1]
  app_url <- paste0("https://", account_name, ".shinyapps.io/", app_name, "/")
  
  cat("\n🎉 DEPLOYMENT SUCCESSFUL! 🎉\n\n")
  cat("Your Indonesian Weather Visualization app is now live at:\n")
  cat(app_url, "\n\n")
  cat("Deployment details:\n")
  cat("- Account:", account_name, "\n")
  cat("- App Name:", app_name, "\n")
  cat("- App Title:", app_title, "\n")
  cat("- Files deployed:", paste(required_files, collapse = ", "), "\n")
  cat("- Indonesian localization: Preserved\n\n")
  
  cat("Features available in the deployed app:\n")
  cat("- Interactive weather data visualization\n")
  cat("- Indonesian language interface\n")
  cat("- Data table with Opo.csv weather data\n")
  cat("- Responsive dashboard layout\n\n")
  
  cat("Next steps:\n")
  cat("1. Visit", app_url, "to test your live app\n")
  cat("2. Share the URL with your students/colleagues\n")
  cat("3. Monitor usage in your shinyapps.io dashboard\n")
  cat("4. Update the app as needed using this script\n\n")
  
  # Write URL to file for easy access
  writeLines(app_url, "deployed_app_url.txt")
  cat("📝 App URL saved to 'deployed_app_url.txt'\n\n")
  
}, error = function(e) {
  cat("❌ DEPLOYMENT FAILED!\n")
  cat("Error:", e$message, "\n\n")
  cat("Common solutions:\n")
  cat("1. Check your internet connection\n")
  cat("2. Verify your shinyapps.io account token\n")
  cat("3. Ensure all required packages are installed\n")
  cat("4. Check that app.R and Opo.csv are in the current directory\n")
  cat("5. Try running: Rscript setup_shinyapps_account.R\n")
  cat("6. See DEPLOYMENT_GUIDE.md for detailed troubleshooting\n")
})