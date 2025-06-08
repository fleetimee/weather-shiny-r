# Deployment Script for shinyapps.io
# Indonesian Weather Visualization App

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

# Configuration instructions
cat("=== SHINYAPPS.IO DEPLOYMENT SCRIPT ===\n\n")
cat("Before running this script, please:\n")
cat("1. Create an account at https://www.shinyapps.io/\n")
cat("2. Go to Account -> Tokens and copy your token\n")
cat("3. Run the token command shown there (it looks like this):\n")
cat("   rsconnect::setAccountInfo(name='your-username',\n")
cat("                            token='your-token',\n")
cat("                            secret='your-secret')\n\n")

# Check if account is configured
accounts <- rsconnect::accounts()
if(nrow(accounts) == 0) {
  cat("❌ No shinyapps.io account configured!\n")
  cat("Please run your token command first, then run this script again.\n")
  cat("Example token command:\n")
  cat("rsconnect::setAccountInfo(name='your-username',\n")
  cat("                         token='ABC123...',\n")
  cat("                         secret='XYZ789...')\n")
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

# Get deployment configuration
cat("\nDeployment Configuration:\n")
app_name <- readline(prompt = "Enter app name (or press Enter for 'indonesian-weather-viz'): ")
if(app_name == "") {
  app_name <- "indonesian-weather-viz"
}

app_title <- readline(prompt = "Enter app title (or press Enter for default): ")
if(app_title == "") {
  app_title <- "Indonesian Weather Visualization"
}

cat("\nDeployment Summary:\n")
cat("App Name:", app_name, "\n")
cat("App Title:", app_title, "\n")
cat("Files to deploy:", paste(required_files, collapse = ", "), "\n")

# Confirm deployment
proceed <- readline(prompt = "\nProceed with deployment? (y/N): ")
if(tolower(proceed) != "y") {
  cat("Deployment cancelled.\n")
  quit()
}

# Deploy the application
cat("\n🚀 Starting deployment to shinyapps.io...\n")
cat("This may take several minutes...\n\n")

tryCatch({
  rsconnect::deployApp(
    appName = app_name,
    appTitle = app_title,
    appFiles = required_files,
    forceUpdate = TRUE,
    launch.browser = TRUE  # Open browser after deployment
  )
  
  # Success message
  account_name <- accounts$name[1]
  app_url <- paste0("https://", account_name, ".shinyapps.io/", app_name, "/")
  
  cat("\n🎉 DEPLOYMENT SUCCESSFUL! 🎉\n\n")
  cat("Your app is now live at:\n")
  cat(app_url, "\n\n")
  cat("Deployment details:\n")
  cat("- Account:", account_name, "\n")
  cat("- App Name:", app_name, "\n")
  cat("- App Title:", app_title, "\n")
  cat("- Files deployed:", paste(required_files, collapse = ", "), "\n\n")
  
  cat("Next steps:\n")
  cat("1. Test your live app thoroughly\n")
  cat("2. Share the URL with your students/colleagues\n")
  cat("3. Monitor usage in your shinyapps.io dashboard\n")
  cat("4. Update the app as needed using this script\n\n")
  
  cat("Troubleshooting:\n")
  cat("- If the app doesn't work, check the logs in your shinyapps.io dashboard\n")
  cat("- For help, see DEPLOYMENT_GUIDE.md\n")
  
}, error = function(e) {
  cat("❌ DEPLOYMENT FAILED!\n")
  cat("Error:", e$message, "\n\n")
  cat("Common solutions:\n")
  cat("1. Check your internet connection\n")
  cat("2. Verify your shinyapps.io account token\n")
  cat("3. Ensure all required packages are installed\n")
  cat("4. Check that app.R and Opo.csv are in the current directory\n")
  cat("5. See DEPLOYMENT_GUIDE.md for detailed troubleshooting\n")
})