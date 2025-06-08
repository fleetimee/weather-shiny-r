# R Package Installation Script for Weather Data Visualization App
# Run this script before launching the Shiny application

cat("Installing required R packages for Weather Data Visualization App...\n\n")

# Set CRAN mirror
options(repos = c(CRAN = "https://cran.rstudio.com/"))
cat("CRAN mirror set to: https://cran.rstudio.com/\n\n")

# List of required packages
required_packages <- c(
  "shiny",          # Web application framework
  "shinydashboard", # Dashboard layout components
  "DT",             # Interactive data tables
  "plotly",         # Interactive visualizations
  "dplyr",          # Data manipulation
  "ggplot2",        # Static plot generation
  "readr",          # CSV file reading
  "shinyWidgets"    # Enhanced UI widgets
)

# Optional enhancement packages
optional_packages <- c(
  "shinycssloaders", # Loading animations
  "shinyjs",         # JavaScript integration
  "colourpicker",    # Color selection tools
  "htmlwidgets"      # Custom widget creation
)

# Function to install packages if not already installed
install_if_missing <- function(packages, package_type = "required") {
  cat(paste("Checking", package_type, "packages...\n"))
  
  for (pkg in packages) {
    if (!require(pkg, character.only = TRUE, quietly = TRUE)) {
      cat(paste("Installing", pkg, "...\n"))
      install.packages(pkg, dependencies = TRUE)
      
      # Verify installation
      if (require(pkg, character.only = TRUE, quietly = TRUE)) {
        cat(paste("✓", pkg, "installed successfully\n"))
      } else {
        cat(paste("✗ Failed to install", pkg, "\n"))
      }
    } else {
      cat(paste("✓", pkg, "already installed\n"))
    }
  }
  cat("\n")
}

# Install required packages
install_if_missing(required_packages, "required")

# Ask user about optional packages
cat("Would you like to install optional enhancement packages? (y/n): ")
install_optional <- readline()

if (tolower(install_optional) %in% c("y", "yes")) {
  install_if_missing(optional_packages, "optional")
}

# Verify installation by loading all required packages
cat("Verifying package installation...\n")
all_loaded <- TRUE

for (pkg in required_packages) {
  if (!require(pkg, character.only = TRUE, quietly = TRUE)) {
    cat(paste("✗ Error: Could not load", pkg, "\n"))
    all_loaded <- FALSE
  }
}

if (all_loaded) {
  cat("\n✅ All required packages are installed and working correctly!\n")
  cat("You can now run the Weather Data Visualization app.\n\n")
  cat("To launch the app, run: shiny::runApp('app.R')\n")
} else {
  cat("\n❌ Some packages failed to install. Please check the error messages above.\n")
  cat("You may need to install packages manually or check your R installation.\n")
}

# Display system information
cat("\nSystem Information:\n")
cat(paste("R Version:", R.version.string, "\n"))
cat(paste("Platform:", R.version$platform, "\n"))
cat(paste("Working Directory:", getwd(), "\n"))

# Check for data file
if (file.exists("Opo.csv")) {
  cat("✓ Opo.csv data file found\n")
} else {
  cat("⚠️  Opo.csv data file not found in current directory\n")
  cat("Please ensure the Opo.csv file is in the same directory as app.R\n")
}