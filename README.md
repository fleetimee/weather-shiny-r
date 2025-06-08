# Interactive Weather Data Visualization

An educational R Shiny application for exploring weather data patterns through interactive visualizations. This application helps students learn data visualization principles using real meteorological data from Porto, Portugal.

## 📊 Overview

This application provides an intuitive interface for exploring weather patterns through multiple chart types and interactive features. Students can learn fundamental data visualization principles while exploring relationships between meteorological variables.

### Key Features

- **Interactive Visualizations**: Scatter plots, line plots, and bar charts with hover tooltips, zoom, and pan
- **Educational Guidance**: Chart type recommendations and learning notes
- **Data Exploration**: Comprehensive data table with search, sort, and filter capabilities
- **Variable Selection**: Easy-to-use dropdowns for exploring different variable combinations
- **Download Options**: Export plots and data for assignments
- **Educational Content**: Built-in help system and variable explanations

## 🗂️ Dataset

The application uses the `Opo.csv` dataset containing 366 daily weather observations with 22 meteorological variables:

### Temperature Variables (°C)

- `MinTemp`: Daily minimum temperature
- `MaxTemp`: Daily maximum temperature
- `Temp9am`: Temperature at 9 AM
- `Temp3pm`: Temperature at 3 PM

### Precipitation Variables (mm)

- `Rainfall`: Daily rainfall amount
- `Evaporation`: Daily evaporation
- `RISK_MM`: Risk of rainfall amount

### Wind Variables

- `WindGustSpeed`: Maximum wind gust speed (km/h)
- `WindSpeed9am`: Wind speed at 9 AM (km/h)
- `WindSpeed3pm`: Wind speed at 3 PM (km/h)
- `WindGustDir`: Direction of maximum wind gust
- `WindDir9am`: Wind direction at 9 AM
- `WindDir3pm`: Wind direction at 3 PM

### Atmospheric Variables

- `Sunshine`: Daily sunshine hours
- `Humidity9am`: Relative humidity at 9 AM (%)
- `Humidity3pm`: Relative humidity at 3 PM (%)
- `Pressure9am`: Atmospheric pressure at 9 AM (hPa)
- `Pressure3pm`: Atmospheric pressure at 3 PM (hPa)
- `Cloud9am`: Cloud coverage at 9 AM (oktas)
- `Cloud3pm`: Cloud coverage at 3 PM (oktas)

### Rain Indicators

- `RainToday`: Whether it rained today (Yes/No)
- `RainTomorrow`: Whether it will rain tomorrow (Yes/No)

## 🚀 Getting Started

### Prerequisites

- **R Version**: 4.0.0 or higher
- **RStudio**: Latest stable version (recommended)
- **Operating System**: Windows 10+, macOS 10.14+, or Ubuntu 18.04+

### Installation

1. **Clone or download** this repository to your local machine

2. **Navigate** to the project directory containing `app.R` and `Opo.csv`

3. **Install required packages** by running the installation script:

   ```r
   source("install_packages.R")
   ```

   Or install packages manually:

   ```r
   install.packages(c(
     "shiny", "shinydashboard", "DT", "plotly",
     "dplyr", "ggplot2", "readr", "shinyWidgets"
   ))
   ```

4. **Verify files** are in place:
   - `app.R` (main application file)
   - `Opo.csv` (weather dataset)
   - `install_packages.R` (package installer)

### Running the Application

#### Method 1: Using RStudio (Recommended)

1. Open RStudio
2. Open the `app.R` file
3. Click the "Run App" button in RStudio
4. The application will open in your default browser or RStudio viewer

#### Method 2: Using R Console

```r
# Set working directory to the app folder
setwd("path/to/your/app/directory")

# Run the app
shiny::runApp("app.R")
```

#### Method 3: Using R Command Line

```r
# From the app directory
R -e "shiny::runApp('app.R')"
```

## 📖 How to Use

### 1. Variable Selection

- Use the **X-Axis Variable** dropdown to select your independent variable
- Use the **Y-Axis Variable** dropdown to select your dependent variable
- Variables are grouped by category (Temperature, Wind, Precipitation, etc.)

### 2. Chart Type Selection

Choose from three visualization types:

- **Scatter Plot**: Best for exploring relationships between two continuous variables
- **Line Plot**: Ideal for showing trends and patterns over sequences
- **Bar Chart**: Perfect for comparing categories or showing distributions

### 3. Interactive Features

- **Hover**: Move your mouse over data points to see exact values
- **Zoom**: Use mouse wheel or zoom controls to examine data regions in detail
- **Pan**: Click and drag to move around zoomed plots
- **Download**: Export plots as PNG files or download data as CSV

### 4. Educational Guidance

- Watch for **chart recommendations** that appear based on your variable selections
- Read the **educational notes** in the sidebar for visualization tips
- Use the **Help tab** for comprehensive instructions and dataset information

### 5. Data Exploration

- Switch to the **Data Table tab** to examine raw data
- Use search, sort, and filter features to find specific observations
- Export filtered data for further analysis

## 🎓 Educational Objectives

This application helps students learn:

### Data Visualization Principles

- When to use different chart types
- How to identify appropriate visualizations for different data types
- Understanding the relationship between variables and visualization choices

### Statistical Concepts

- Correlation and relationship identification
- Trend analysis and pattern recognition
- Distribution analysis and frequency interpretation
- Outlier detection and data quality assessment

### Interactive Data Exploration

- Using hover tooltips to examine individual data points
- Zooming and panning for detailed analysis
- Filtering and searching data tables
- Comparing different variable combinations

## 📋 Sample Exercises

### Exercise 1: Temperature Relationships

1. Select `MaxTemp` for X-axis and `MinTemp` for Y-axis
2. Choose Scatter Plot visualization
3. Enable trend line option
4. **Questions**: What type of relationship exists? How strong is the correlation?

### Exercise 2: Seasonal Patterns

1. Select observation index for X-axis and `Temp9am` for Y-axis
2. Choose Line Plot visualization
3. **Questions**: Can you identify seasonal patterns? When are temperatures highest/lowest?

### Exercise 3: Categorical Analysis

1. Select `RainToday` for X-axis and `Humidity9am` for Y-axis
2. Choose Bar Chart visualization
3. **Questions**: How does humidity differ between rainy and non-rainy days?

### Exercise 4: Wind Analysis

1. Select `WindDir9am` for X-axis (leave Y-axis as is)
2. Choose Bar Chart visualization
3. **Questions**: Which wind directions are most common? Are there seasonal patterns?

## 🛠️ Troubleshooting

### Common Issues

**App won't start:**

- Ensure all required packages are installed: `source("install_packages.R")`
- Check that `Opo.csv` is in the same directory as `app.R`
- Verify your R version is 4.0.0 or higher

**Plots not displaying:**

- Try refreshing the browser
- Check browser console for JavaScript errors
- Ensure plotly package is properly installed

**Data table not loading:**

- Verify the DT package is installed
- Check that the CSV file is not corrupted

**Performance issues:**

- Close other R sessions or RStudio projects
- Restart R session: `Ctrl+Shift+F10` (Windows) or `Cmd+Shift+F10` (Mac)

### Getting Help

1. Check the **Help tab** within the application
2. Review this README file
3. Verify package installation with `install_packages.R`
4. Check R and package versions for compatibility

## 📊 Technical Specifications

### Performance Requirements

- **Load Time**: < 3 seconds on typical student laptops
- **Chart Generation**: < 1 second after variable selection
- **Memory Usage**: < 200MB RAM for typical operation
- **Data Processing**: Handles 366-row dataset without performance degradation

### Browser Compatibility

- Chrome 80+
- Firefox 75+
- Safari 13+
- Edge 80+

### System Requirements

- **RAM**: Minimum 4GB, recommended 8GB
- **Storage**: 50MB for application and dependencies
- **Screen Resolution**: Minimum 1024x768, optimized for 1366x768 and higher

## 📝 File Structure

```
weather-visualization/
├── app.R                    # Main Shiny application
├── Opo.csv                  # Weather dataset
├── install_packages.R       # Package installation script
└── README.md               # This documentation file
```

## 🤝 Educational Use

This application is designed for:

- **Data Science Courses**: Introduction to data visualization
- **Statistics Classes**: Understanding relationships between variables
- **Meteorology Education**: Exploring weather patterns and relationships
- **R Programming**: Learning Shiny application development

### For Educators

- Use provided sample exercises as starting points
- Encourage students to explore different variable combinations
- Assign specific visualization tasks based on learning objectives
- Use the application to demonstrate good visualization practices

### For Students

- Start with the Help tab to understand the interface
- Follow chart recommendations when learning
- Experiment with different variable combinations
- Pay attention to educational notes and guidance messages
- Use the data table to verify patterns you observe in visualizations

## 📄 License

This educational application is provided for learning purposes. The weather dataset is publicly available meteorological data.

## 🔄 Version History

- **v1.0**: Initial release with core visualization features
- Educational guidance system
- Interactive charts with plotly
- Comprehensive data table
- Download functionality
- Help system and documentation

## 🌐 Online Deployment

This Shiny application can be deployed online for easy access by students and colleagues. See our deployment documentation:

### Quick Deployment (Recommended)

**Deploy to shinyapps.io in minutes:**

```r
# Run the automated deployment script
source("deploy_to_shinyapps.R")
```

### Deployment Resources

- **[DEPLOYMENT_GUIDE.md](DEPLOYMENT_GUIDE.md)** - Complete step-by-step deployment instructions
- **[HOSTING_OPTIONS.md](HOSTING_OPTIONS.md)** - Comparison of hosting platforms
- **[deploy_to_shinyapps.R](deploy_to_shinyapps.R)** - Automated deployment script

### Hosting Options Summary

| Platform         | Difficulty  | Cost      | Best For             |
| ---------------- | ----------- | --------- | -------------------- |
| **shinyapps.io** | ⭐ Easy     | Free/Paid | Education, Beginners |
| **Heroku**       | ⭐⭐ Medium | Free/Paid | Developers           |
| **DigitalOcean** | ⭐⭐⭐ Hard | $5+/month | Production           |

### Why Deploy Online?

- **Easy sharing** with students and colleagues
- **No local setup** required for users
- **Always accessible** from any device
- **Professional presentation** for portfolios

For detailed instructions, see [DEPLOYMENT_GUIDE.md](DEPLOYMENT_GUIDE.md).

---

**Happy Data Exploring! 📊🌤️**

_Ready to deploy? Start with [shinyapps.io deployment guide](DEPLOYMENT_GUIDE.md#quick-start---shinyappsio-recommended) for the easiest online hosting solution!_
