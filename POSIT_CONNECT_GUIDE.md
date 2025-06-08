# 🚀 Posit Connect Cloud Deployment Guide

This guide specifically covers deploying the Indonesian Weather Visualization app to **Posit Connect Cloud** (formerly RStudio Connect Cloud).

## 📋 Prerequisites

1. **Posit Connect Cloud account** - Sign up at [posit.cloud](https://posit.cloud)
2. **All required files** in your project directory
3. **Working internet connection**

## 📁 Required Files Checklist

Ensure these files are present in your project:

- ✅ [`app.R`](app.R) - Main Shiny application
- ✅ [`Opo.csv`](Opo.csv) - Weather dataset
- ✅ [`manifest.json`](manifest.json) - Deployment configuration (newly created)
- ✅ [`install_packages.R`](install_packages.R) - Package installer

## 🔧 Step-by-Step Deployment

### Step 1: Prepare Your Environment

```r
# Install rsconnect package if not already installed
if (!require("rsconnect")) {
  install.packages("rsconnect")
}

# Load the package
library(rsconnect)
```

### Step 2: Configure Posit Connect Cloud

1. **Get your server information:**

   - Log into your Posit Connect Cloud account
   - Go to your account settings or publishing section
   - Note your server URL (usually something like `https://your-account.posit.cloud/`)

2. **Add your Posit Connect Cloud server:**

```r
# Replace with your actual server details
rsconnect::addServer(
  url = "https://your-account.posit.cloud/",
  name = "posit-cloud"
)
```

3. **Configure authentication:**

```r
# This will open a browser window for authentication
rsconnect::connectUser(server = "posit-cloud")
```

### Step 3: Deploy the Application

```r
# Set working directory to your app folder
setwd("path/to/your/weather-app")

# Deploy to Posit Connect Cloud
rsconnect::deployApp(
  appName = "indonesian-weather-viz",
  appTitle = "Indonesian Weather Visualization",
  server = "posit-cloud",
  forceUpdate = TRUE
)
```

### Step 4: Verify Deployment

After successful deployment:

1. Check the deployment URL provided in the console
2. Test all app functionality online
3. Verify data loads correctly
4. Test interactive features

## 🛠️ Troubleshooting Posit Connect Cloud Issues

### Issue: "Unable to locate manifest.json"

**Solution:** The `manifest.json` file has been created for you. Ensure it's in the same directory as `app.R`.

```r
# Verify manifest.json exists
file.exists("manifest.json")
```

### Issue: "Package installation failed"

**Solution:** Update package versions in manifest.json or force reinstall:

```r
# Check current package versions
sessionInfo()

# Install packages manually first
source("install_packages.R")
```

### Issue: "Authentication failed"

**Solutions:**

1. **Clear existing connections:**

```r
# Remove old server configurations
rsconnect::removeServer("posit-cloud")

# Re-add server with correct URL
rsconnect::addServer(
  url = "https://your-correct-url.posit.cloud/",
  name = "posit-cloud"
)
```

2. **Re-authenticate:**

```r
rsconnect::connectUser(server = "posit-cloud")
```

### Issue: "File not found during deployment"

**Solution:** Ensure all required files are in the working directory:

```r
# Check all required files exist
required_files <- c("app.R", "Opo.csv", "manifest.json")
file_status <- file.exists(required_files)
names(file_status) <- required_files
print(file_status)
```

### Issue: "Memory or timeout errors"

**Solutions:**

1. **Optimize the app for cloud deployment:**

   - Reduce data size if possible
   - Optimize reactive expressions
   - Use caching for expensive operations

2. **Check Posit Connect Cloud limits:**
   - Free accounts have resource limitations
   - Consider upgrading plan if needed

## 📝 Manifest.json Explanation
