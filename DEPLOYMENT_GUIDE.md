# 🚀 Deployment Guide - Indonesian Weather Visualization App

This guide provides step-by-step instructions for deploying your Indonesian Shiny weather visualization application online. Since GitHub Pages only supports static sites, we'll cover the best hosting options for Shiny applications.

## 📋 Table of Contents

- [Quick Start - shinyapps.io (Recommended)](#quick-start---shinyappsio-recommended)
- [Alternative Hosting Options](#alternative-hosting-options)
- [Deployment Preparation](#deployment-preparation)
- [Troubleshooting](#troubleshooting)
- [Cost Considerations](#cost-considerations)

## 🎯 Quick Start - shinyapps.io (Recommended)

**shinyapps.io** is RStudio's official hosting platform and the easiest way to deploy Shiny apps online.

### Step 1: Create shinyapps.io Account

1. Visit [shinyapps.io](https://www.shinyapps.io/)
2. Click "Sign Up" and create a free account
3. Choose the free plan (25 active hours/month, 5 applications)

### Step 2: Install Required Packages

```r
# Install deployment packages
install.packages(c("rsconnect", "shiny", "shinydashboard", "DT",
                   "plotly", "dplyr", "ggplot2", "readr", "shinyWidgets"))
```

### Step 3: Configure rsconnect

1. **Get your token:**

   - Log into your shinyapps.io account
   - Go to Account → Tokens
   - Click "Show" and copy the token command

2. **Configure in R:**
   ```r
   # Run the token command you copied (example format):
   rsconnect::setAccountInfo(name='your-username',
                            token='your-token',
                            secret='your-secret')
   ```

### Step 4: Deploy Your App

```r
# Navigate to your app directory
setwd("path/to/your/weather-app")

# Deploy the app
rsconnect::deployApp(
  appName = "indonesian-weather-viz",
  appTitle = "Indonesian Weather Visualization",
  appFiles = c("app.R", "Opo.csv"),
  forceUpdate = TRUE
)
```

### Step 5: Access Your Live App

After deployment, your app will be available at:
`https://your-username.shinyapps.io/indonesian-weather-viz/`

## 🌐 Alternative Hosting Options

### Option 1: Heroku (Free Tier Available)

**Pros:** Free tier, good performance, custom domains
**Cons:** Requires Docker setup, more technical

#### Steps:

1. Create Heroku account
2. Install Heroku CLI
3. Create Dockerfile and heroku.yml
4. Deploy via Git

**Cost:** Free tier available (550 hours/month)

### Option 2: DigitalOcean/AWS (Most Control)

**Pros:** Full control, scalable, professional hosting
**Cons:** Requires server management knowledge

#### Steps:

1. Create cloud server instance
2. Install R and Shiny Server
3. Upload app files
4. Configure web server

**Cost:** $5-20/month depending on requirements

### Option 3: ShinyProxy (Enterprise)

**Pros:** Enterprise features, Docker containers, authentication
**Cons:** Complex setup, requires Java expertise

**Cost:** Open source (self-hosted) or commercial licenses available

## 📦 Deployment Preparation

### File Structure Check

Ensure your project has this structure:

```
weather-visualization/
├── app.R                    # Main Shiny application
├── Opo.csv                  # Weather dataset
├── install_packages.R       # Package installation
├── launch_app.R            # Local launcher
├── .gitignore              # Git ignore file
├── README.md               # Project documentation
├── DEPLOYMENT_GUIDE.md     # This guide
└── rsconnect/              # Deployment metadata (auto-created)
```

### Pre-deployment Checklist

- [ ] All required packages listed in `install_packages.R`
- [ ] `Opo.csv` file is in the same directory as `app.R`
- [ ] App runs successfully locally
- [ ] No hardcoded file paths (use relative paths)
- [ ] Memory usage optimized for hosting limits

### Package Dependencies

Your app requires these packages:

```r
required_packages <- c(
  "shiny",         # Core Shiny framework
  "shinydashboard", # Dashboard layout
  "DT",            # Interactive data tables
  "plotly",        # Interactive plots
  "dplyr",         # Data manipulation
  "ggplot2",       # Static plotting
  "readr",         # CSV file reading
  "shinyWidgets"   # Enhanced UI widgets
)
```

## 🔧 Troubleshooting

### Common Deployment Issues

#### "Package not found" Error

```r
# Solution: Ensure all packages are installed
source("install_packages.R")

# Or install individually:
install.packages("package-name")
```

#### "File not found" Error

- Ensure `Opo.csv` is in the same directory as `app.R`
- Use relative paths only (no absolute paths like `/Users/...`)
- Check file permissions

#### Memory/Timeout Issues

- Free hosting plans have memory and time limits
- Optimize data loading and processing
- Consider upgrading to paid plans for better performance

#### App Crashes on Load

```r
# Test locally first:
shiny::runApp("app.R")

# Check R console for error messages
# Common fixes:
# 1. Update package versions
# 2. Check data file format
# 3. Verify all dependencies
```

### Getting Help

1. **shinyapps.io Support:**

   - Check application logs in your dashboard
   - Review [shinyapps.io user guide](https://docs.rstudio.com/shinyapps.io/)

2. **Community Resources:**

   - [RStudio Community](https://community.rstudio.com/)
   - [Stack Overflow](https://stackoverflow.com/questions/tagged/shiny)

3. **Documentation:**
   - [Shiny deployment guide](https://shiny.rstudio.com/deploy/)
   - [rsconnect package documentation](https://github.com/rstudio/rsconnect)

## 💰 Cost Considerations

### shinyapps.io Pricing (2024)

| Plan     | Price     | Active Hours     | Applications | RAM  |
| -------- | --------- | ---------------- | ------------ | ---- |
| Free     | $0        | 25 hours/month   | 5 apps       | 1 GB |
| Starter  | $9/month  | 100 hours/month  | 25 apps      | 1 GB |
| Basic    | $39/month | 500 hours/month  | 100 apps     | 2 GB |
| Standard | $99/month | 2000 hours/month | 500 apps     | 4 GB |

### Usage Estimation

For **educational use:**

- **Free plan** is usually sufficient for classroom demonstrations
- **Starter plan** recommended for semester-long courses
- Monitor usage in your shinyapps.io dashboard

### Cost Optimization Tips

1. **Use sleep mode:** Apps automatically sleep when inactive
2. **Monitor usage:** Check dashboard regularly
3. **Optimize code:** Reduce memory usage and load times
4. **Consider alternatives:** Use local hosting for development

## 🔒 Security Best Practices

### Data Protection

- The `Opo.csv` dataset contains public weather data (no privacy concerns)
- No sensitive information in the application
- Use HTTPS (automatically provided by shinyapps.io)

### Application Security

- No user authentication required for this educational app
- Input validation already implemented in the app
- Regular package updates recommended

## 📈 Performance Optimization

### For Production Deployment

1. **Data Loading:**

   ```r
   # Cache data loading for better performance
   weather_data <- reactive({
     # Add caching logic if needed
   })
   ```

2. **Memory Management:**

   - Monitor memory usage in deployment logs
   - Optimize data structures if needed
   - Consider data sampling for large datasets

3. **User Experience:**
   - Add loading indicators for slow operations
   - Implement error handling for network issues
   - Provide offline fallbacks where possible

---

## 🎉 Next Steps

After successful deployment:

1. **Test your live app** thoroughly
2. **Share the URL** with students/colleagues
3. **Monitor usage** and performance
4. **Update** the app as needed
5. **Scale up** hosting plan if required

Your Indonesian Weather Visualization app is now ready for online use! 🌤️📊

---

**Need Help?** Check the troubleshooting section above or refer to the main README.md for application usage instructions.
