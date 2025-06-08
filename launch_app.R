#!/usr/bin/env Rscript

# Quick Launch Script for Weather Data Visualization App
# This script provides an easy way to launch the Shiny application

cat("🌤️  Weather Data Visualization App Launcher\n")
cat("==========================================\n\n")

# Check if required files exist
if (!file.exists("app.R")) {
  cat("❌ Error: app.R not found in current directory\n")
  cat("Please ensure you're running this script from the correct directory.\n")
  quit(status = 1)
}

if (!file.exists("Opo.csv")) {
  cat("⚠️  Warning: Opo.csv not found in current directory\n")
  cat("The app may not work properly without the dataset.\n")
}

# Set CRAN mirror
options(repos = c(CRAN = "https://cran.rstudio.com/"))

# Check if required packages are installed
required_packages <- c("shiny", "shinydashboard", "DT", "plotly", "dplyr", "ggplot2", "readr", "shinyWidgets")
missing_packages <- c()

cat("Checking required packages...\n")
for (pkg in required_packages) {
  if (!require(pkg, character.only = TRUE, quietly = TRUE)) {
    missing_packages <- c(missing_packages, pkg)
  }
}

if (length(missing_packages) > 0) {
  cat("❌ Missing packages detected:", paste(missing_packages, collapse = ", "), "\n")
  cat("Please run 'source(\"install_packages.R\")' first to install required packages.\n")
  quit(status = 1)
}

cat("✅ All required packages are available\n\n")

# Display launch information
cat("📊 Launching Weather Data Visualization App...\n")
cat("📍 The app will open in your default web browser\n")
cat("🔗 Local URL: http://localhost:3838\n")
cat("⚠️  To stop the app, press Ctrl+C (or Cmd+C on Mac)\n\n")

# Additional instructions
cat("💡 Quick Start Tips:\n")
cat("   • Start with the Help tab to learn about the interface\n")
cat("   • Try selecting MaxTemp (X) and MinTemp (Y) with Scatter Plot\n")
cat("   • Explore different variable combinations and chart types\n")
cat("   • Use the Data Table tab to examine raw data\n\n")

cat("🚀 Starting application...\n")

# Launch the app
tryCatch({
  shiny::runApp("app.R", 
                port = 3838, 
                host = "127.0.0.1",
                launch.browser = TRUE)
}, error = function(e) {
  cat("❌ Error launching app:", e$message, "\n")
  cat("Please check the error message above and ensure all files are in place.\n")
})