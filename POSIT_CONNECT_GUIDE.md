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

The `manifest.json` file tells Posit Connect Cloud:

```json
{
  "version": 1,                    // Manifest format version
  "metadata": {
    "appmode": "shiny",           // Application type
    "entrypoint": "app.R"         // Main application file
  },
  "packages": {                   // Required R packages with versions
    "R": [...]
  },
  "files": {                      // Files to include in deployment
    "app.R": {"checksum": "auto"},
    "Opo.csv": {"checksum": "auto"}
  }
}
```

## 🔄 Updating Your App

To update an existing deployment:

```r
# Make your changes to app.R or other files
# Then redeploy with forceUpdate = TRUE
rsconnect::deployApp(
  appName = "indonesian-weather-viz",
  server = "posit-cloud",
  forceUpdate = TRUE
)
```

## 📊 Monitoring Your App

### Check App Status

```r
# List your deployed applications
rsconnect::applications(server = "posit-cloud")

# Get app usage statistics (if available)
rsconnect::showLogs(
  appName = "indonesian-weather-viz",
  server = "posit-cloud"
)
```

### Performance Monitoring

- Monitor app performance in Posit Connect Cloud dashboard
- Check for memory usage warnings
- Review error logs if app crashes

## 💰 Posit Connect Cloud Pricing

### Free Tier

- Limited computational hours
- Basic hosting features
- Good for educational projects

### Paid Plans

- More computational resources
- Better performance guarantees
- Advanced features and support

## 🔒 Security and Privacy

### Data Security

- Weather data is public (no privacy concerns)
- Use HTTPS (automatically provided)
- Regular security updates by Posit

### Access Control

- Apps can be made public or private
- Share specific URLs with students
- Control access through Posit Connect Cloud settings

## 🎓 Educational Use Benefits

### For Students

- **Easy access** via web browser
- **No local R installation** required
- **Consistent experience** across devices
- **Always up-to-date** version

### For Educators

- **Centralized hosting** for all students
- **Usage monitoring** capabilities
- **Easy sharing** with class links
- **Professional presentation**

## 📞 Getting Help

### Posit Support Resources

- [Posit Connect Cloud Documentation](https://docs.posit.co/connect-cloud/)
- [RStudio Community](https://community.rstudio.com/)
- [Posit Support](https://support.posit.co/)

### Common Commands Reference

```r
# List servers
rsconnect::servers()

# List applications
rsconnect::applications()

# Remove an application
rsconnect::terminateApp(
  appName = "indonesian-weather-viz",
  server = "posit-cloud"
)

# Show deployment logs
rsconnect::showLogs(
  appName = "indonesian-weather-viz",
  server = "posit-cloud"
)
```

## ✅ Deployment Checklist

Before deploying, verify:

- [ ] All files present (`app.R`, `Opo.csv`, `manifest.json`)
- [ ] App runs locally without errors
- [ ] Posit Connect Cloud account configured
- [ ] Required packages installed locally
- [ ] Internet connection stable

## 🎉 Success!

Once deployed successfully:

1. **Test your live app** thoroughly
2. **Share the URL** with students/colleagues
3. **Monitor usage** in your dashboard
4. **Update as needed** using the deployment commands

Your Indonesian Weather Visualization app is now live on Posit Connect Cloud! 🌤️📊

---

**Need help?** Check the troubleshooting section above or refer to [DEPLOYMENT_TROUBLESHOOTING.md](DEPLOYMENT_TROUBLESHOOTING.md) for additional solutions.
