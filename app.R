# Weather Data Visualization - Interactive Shiny Application
# Based on PRD requirements for educational weather data exploration

# Load required libraries
library(shiny)
library(shinydashboard)
library(DT)
library(plotly)
library(dplyr)
library(ggplot2)
library(readr)
library(shinyWidgets)

# Load and prepare data
load_weather_data <- function() {
  tryCatch({
    data <- read_csv("Opo.csv", show_col_types = FALSE)
    
    # Validate data structure
    if (ncol(data) != 22) {
      stop("Data file does not contain expected 22 columns")
    }
    
    # Convert categorical variables to factors
    categorical_vars <- c("WindGustDir", "WindDir9am", "WindDir3pm", "RainToday", "RainTomorrow")
    data[categorical_vars] <- lapply(data[categorical_vars], as.factor)
    
    # Add row numbers for identification
    data$ID <- 1:nrow(data)
    
    return(data)
  }, error = function(e) {
    stop(paste("Error loading data:", e$message))
  })
}

# Define variable categories and metadata
get_variable_info <- function() {
  list(
    continuous = list(
      "Temperature" = c("MinTemp" = "Minimum Temperature (°C)",
                       "MaxTemp" = "Maximum Temperature (°C)",
                       "Temp9am" = "Temperature 9AM (°C)",
                       "Temp3pm" = "Temperature 3PM (°C)"),
      
      "Precipitation" = c("Rainfall" = "Rainfall (mm)",
                         "Evaporation" = "Evaporation (mm)",
                         "RISK_MM" = "Risk Rainfall (mm)"),
      
      "Wind" = c("WindGustSpeed" = "Wind Gust Speed (km/h)",
                "WindSpeed9am" = "Wind Speed 9AM (km/h)",
                "WindSpeed3pm" = "Wind Speed 3PM (km/h)"),
      
      "Atmospheric" = c("Sunshine" = "Sunshine (hours)",
                       "Humidity9am" = "Humidity 9AM (%)",
                       "Humidity3pm" = "Humidity 3PM (%)",
                       "Pressure9am" = "Pressure 9AM (hPa)",
                       "Pressure3pm" = "Pressure 3PM (hPa)",
                       "Cloud9am" = "Cloud Cover 9AM (oktas)",
                       "Cloud3pm" = "Cloud Cover 3PM (oktas)")
    ),
    
    categorical = c("WindGustDir" = "Wind Gust Direction",
                   "WindDir9am" = "Wind Direction 9AM",
                   "WindDir3pm" = "Wind Direction 3PM",
                   "RainToday" = "Rain Today",
                   "RainTomorrow" = "Rain Tomorrow")
  )
}

# Get all variable choices for dropdowns
get_variable_choices <- function() {
  var_info <- get_variable_info()
  
  # Create choices with actual column names as values and descriptions as labels
  continuous_choices <- c()
  for (category in names(var_info$continuous)) {
    category_vars <- var_info$continuous[[category]]
    for (var_name in names(category_vars)) {
      continuous_choices[category_vars[var_name]] <- var_name
    }
  }
  
  categorical_choices <- c()
  for (var_name in names(var_info$categorical)) {
    categorical_choices[var_info$categorical[var_name]] <- var_name
  }
  
  list(
    "Continuous Variables" = continuous_choices,
    "Categorical Variables" = categorical_choices
  )
}

# Educational content
get_chart_recommendations <- function(x_var, y_var, data) {
  var_info <- get_variable_info()
  all_continuous <- unlist(var_info$continuous, use.names = TRUE)
  all_categorical <- var_info$categorical
  
  x_is_continuous <- x_var %in% names(all_continuous)
  y_is_continuous <- y_var %in% names(all_continuous)
  
  if (x_is_continuous && y_is_continuous) {
    return(list(
      recommended = "scatter",
      message = "📊 Recommended: Scatter Plot - Perfect for exploring relationships between two continuous variables. Look for correlations, trends, and outliers."
    ))
  } else if ((!x_is_continuous && y_is_continuous) || (x_is_continuous && !y_is_continuous)) {
    return(list(
      recommended = "bar",
      message = "📊 Recommended: Bar Chart - Ideal for comparing values across categories. Use this to see how numerical values vary by group."
    ))
  } else {
    return(list(
      recommended = "bar",
      message = "📊 Recommended: Bar Chart - Great for frequency analysis of categorical data."
    ))
  }
}

# Load data
weather_data <- load_weather_data()

# Define UI
ui <- dashboardPage(
  dashboardHeader(title = "Interactive Weather Data Visualization"),
  
  dashboardSidebar(
    sidebarMenu(
      menuItem("Visualization", tabName = "viz", icon = icon("chart-line")),
      menuItem("Data Table", tabName = "data", icon = icon("table")),
      menuItem("Help", tabName = "help", icon = icon("question-circle"))
    ),
    
    # Variable Selection
    div(style = "padding: 20px;",
      h4("Variable Selection"),
      
      selectInput("x_variable", 
                 "X-Axis Variable:",
                 choices = get_variable_choices(),
                 selected = "MaxTemp"),
      
      selectInput("y_variable", 
                 "Y-Axis Variable:",
                 choices = get_variable_choices(),
                 selected = "MinTemp"),
      
      # Chart Type Selection
      h4("Chart Type"),
      radioButtons("chart_type", 
                  "Select Visualization:",
                  choices = list(
                    "Scatter Plot" = "scatter",
                    "Line Plot" = "line", 
                    "Bar Chart" = "bar"
                  ),
                  selected = "scatter"),
      
      # Additional Options
      h4("Options"),
      checkboxInput("show_trend", "Show Trend Line", FALSE),
      checkboxInput("group_data", "Group by Rain Today", FALSE),
      
      # Download Options
      br(),
      downloadButton("download_plot", "Download Plot", class = "btn-primary"),
      br(), br(),
      downloadButton("download_data", "Download Data", class = "btn-secondary")
    )
  ),
  
  dashboardBody(
    tabItems(
      # Visualization Tab
      tabItem(tabName = "viz",
        fluidRow(
          box(width = 12, status = "primary",
            h3("Interactive Weather Data Visualization"),
            div(id = "recommendation", 
                style = "background-color: #e3f2fd; padding: 10px; margin-bottom: 15px; border-radius: 5px;",
                textOutput("chart_recommendation")
            )
          )
        ),
        
        fluidRow(
          box(width = 9, status = "primary",
            plotlyOutput("main_plot", height = "500px")
          ),
          
          box(width = 3, status = "info", title = "Variable Information",
            h4("Selected Variables:"),
            verbatimTextOutput("variable_info"),
            
            h4("Summary Statistics:"),
            tableOutput("summary_stats"),
            
            h4("Educational Notes:"),
            div(style = "font-size: 12px; color: #666;",
                textOutput("educational_notes")
            )
          )
        )
      ),
      
      # Data Table Tab
      tabItem(tabName = "data",
        fluidRow(
          box(width = 12, status = "primary", title = "Weather Dataset",
            p("This table contains 366 daily weather observations with 22 variables. 
              Use the search, sort, and filter features to explore the data."),
            DT::dataTableOutput("data_table")
          )
        )
      ),
      
      # Help Tab
      tabItem(tabName = "help",
        fluidRow(
          box(width = 12, status = "primary", title = "Help & Instructions",
            h3("Getting Started"),
            p("This application helps you explore weather data through interactive visualizations."),
            
            h4("How to Use:"),
            tags$ol(
              tags$li("Select variables from the sidebar dropdowns"),
              tags$li("Choose a chart type that matches your data"),
              tags$li("Interact with plots by hovering, zooming, and panning"),
              tags$li("Use the Data Table tab to examine raw data"),
              tags$li("Download plots and data for your assignments")
            ),
            
            h4("Chart Types:"),
            tags$ul(
              tags$li(strong("Scatter Plot:"), " Best for exploring relationships between two continuous variables"),
              tags$li(strong("Line Plot:"), " Ideal for showing trends and patterns over sequences"),
              tags$li(strong("Bar Chart:"), " Perfect for comparing categories or showing distributions")
            ),
            
            h4("Dataset Information:"),
            p("The dataset contains 366 daily weather observations from Porto, Portugal with the following variable categories:"),
            
            h5("Temperature Variables:"),
            p("MinTemp, MaxTemp, Temp9am, Temp3pm (all in °C)"),
            
            h5("Precipitation Variables:"),
            p("Rainfall, Evaporation, RISK_MM (all in mm)"),
            
            h5("Wind Variables:"),
            p("WindGustSpeed, WindSpeed9am, WindSpeed3pm (km/h), WindGustDir, WindDir9am, WindDir3pm"),
            
            h5("Atmospheric Variables:"),
            p("Sunshine (hours), Humidity9am/3pm (%), Pressure9am/3pm (hPa), Cloud9am/3pm (oktas)"),
            
            h5("Rain Indicators:"),
            p("RainToday, RainTomorrow (Yes/No)")
          )
        )
      )
    )
  )
)

# Define Server
server <- function(input, output, session) {
  
  # Reactive data filtering
  filtered_data <- reactive({
    data <- weather_data
    
    # Remove rows with NA values for selected variables
    if (input$x_variable %in% names(data) && input$y_variable %in% names(data)) {
      data <- data[!is.na(data[[input$x_variable]]) & !is.na(data[[input$y_variable]]), ]
    }
    
    return(data)
  })
  
  # Chart recommendation
  output$chart_recommendation <- renderText({
    recommendation <- get_chart_recommendations(input$x_variable, input$y_variable, weather_data)
    recommendation$message
  })
  
  # Variable information
  output$variable_info <- renderText({
    var_info <- get_variable_info()
    all_continuous <- unlist(var_info$continuous, use.names = TRUE)
    all_categorical <- var_info$categorical
    
    # Get descriptions for selected variables
    x_desc <- if(input$x_variable %in% names(all_continuous)) {
      all_continuous[input$x_variable]
    } else if(input$x_variable %in% names(all_categorical)) {
      all_categorical[input$x_variable]
    } else {
      input$x_variable
    }
    
    y_desc <- if(input$y_variable %in% names(all_continuous)) {
      all_continuous[input$y_variable]
    } else if(input$y_variable %in% names(all_categorical)) {
      all_categorical[input$y_variable]
    } else {
      input$y_variable
    }
    
    paste0("X-Axis: ", input$x_variable, " (", x_desc, ")",
           "\nY-Axis: ", input$y_variable, " (", y_desc, ")")
  })
  
  # Summary statistics
  output$summary_stats <- renderTable({
    data <- filtered_data()
    
    if (input$x_variable %in% names(data) && input$y_variable %in% names(data)) {
      x_data <- data[[input$x_variable]]
      y_data <- data[[input$y_variable]]
      
      if (is.numeric(x_data) && is.numeric(y_data)) {
        data.frame(
          Variable = c(input$x_variable, input$y_variable),
          Mean = round(c(mean(x_data, na.rm = TRUE), mean(y_data, na.rm = TRUE)), 2),
          Median = round(c(median(x_data, na.rm = TRUE), median(y_data, na.rm = TRUE)), 2),
          SD = round(c(sd(x_data, na.rm = TRUE), sd(y_data, na.rm = TRUE)), 2)
        )
      }
    }
  })
  
  # Educational notes
  output$educational_notes <- renderText({
    chart_type <- input$chart_type
    
    notes <- switch(chart_type,
      "scatter" = "Look for patterns: positive/negative correlations, clusters, or outliers. Strong correlations suggest relationships between variables.",
      "line" = "Examine trends: are values increasing, decreasing, or cyclical? Look for seasonal patterns or unusual peaks/valleys.",
      "bar" = "Compare heights: which categories have the highest/lowest values? Look for patterns across different groups."
    )
    
    notes
  })
  
  # Main plot
  output$main_plot <- renderPlotly({
    data <- filtered_data()
    
    if (nrow(data) == 0) {
      return(plotly_empty() %>% 
             layout(title = "No data available for selected variables"))
    }
    
    # Create base plot
    if (input$chart_type == "scatter") {
      p <- ggplot(data, aes_string(x = input$x_variable, y = input$y_variable))
      
      if (input$group_data && "RainToday" %in% names(data)) {
        p <- p + geom_point(aes(color = RainToday), alpha = 0.7, size = 2)
        p <- p + scale_color_manual(values = c("No" = "#3498db", "Yes" = "#e74c3c"))
      } else {
        p <- p + geom_point(alpha = 0.7, size = 2, color = "#3498db")
      }
      
      if (input$show_trend) {
        p <- p + geom_smooth(method = "lm", se = TRUE, color = "#e74c3c")
      }
      
    } else if (input$chart_type == "line") {
      # Create line plot with data indices
      data$Index <- 1:nrow(data)
      p <- ggplot(data, aes_string(x = "Index", y = input$y_variable))
      
      if (input$group_data && "RainToday" %in% names(data)) {
        p <- p + geom_line(aes(color = RainToday), size = 1)
        p <- p + scale_color_manual(values = c("No" = "#3498db", "Yes" = "#e74c3c"))
      } else {
        p <- p + geom_line(color = "#3498db", size = 1)
      }
      
      p <- p + labs(x = "Observation Index")
      
    } else if (input$chart_type == "bar") {
      # Determine if we need aggregation
      var_info <- get_variable_info()
      all_continuous <- unlist(var_info$continuous, use.names = FALSE)
      
      if (input$x_variable %in% names(all_continuous)) {
        # X is continuous, Y should be categorical for bar chart
        if (input$y_variable %in% var_info$categorical) {
          # Aggregate continuous by categorical
          agg_data <- data %>%
            group_by(!!sym(input$y_variable)) %>%
            summarise(mean_val = mean(!!sym(input$x_variable), na.rm = TRUE), .groups = 'drop')
          
          p <- ggplot(agg_data, aes_string(x = input$y_variable, y = "mean_val"))
          p <- p + geom_col(fill = "#3498db", alpha = 0.8)
          p <- p + labs(y = paste("Mean", input$x_variable))
        } else {
          # Both continuous - create histogram
          p <- ggplot(data, aes_string(x = input$x_variable))
          p <- p + geom_histogram(fill = "#3498db", alpha = 0.8, bins = 20)
          p <- p + labs(y = "Frequency")
        }
      } else {
        # X is categorical
        if (input$y_variable %in% names(all_continuous)) {
          # Categorical X, continuous Y
          agg_data <- data %>%
            group_by(!!sym(input$x_variable)) %>%
            summarise(mean_val = mean(!!sym(input$y_variable), na.rm = TRUE), .groups = 'drop')
          
          p <- ggplot(agg_data, aes_string(x = input$x_variable, y = "mean_val"))
          p <- p + geom_col(fill = "#3498db", alpha = 0.8)
          p <- p + labs(y = paste("Mean", input$y_variable))
        } else {
          # Both categorical - frequency count
          count_data <- data %>%
            count(!!sym(input$x_variable), name = "count")
          
          p <- ggplot(count_data, aes_string(x = input$x_variable, y = "count"))
          p <- p + geom_col(fill = "#3498db", alpha = 0.8)
          p <- p + labs(y = "Count")
        }
      }
      
      p <- p + theme(axis.text.x = element_text(angle = 45, hjust = 1))
    }
    
    # Apply theme
    p <- p + theme_minimal() +
      theme(
        plot.title = element_text(size = 14, face = "bold"),
        axis.title = element_text(size = 12),
        axis.text = element_text(size = 10),
        legend.title = element_text(size = 11),
        legend.text = element_text(size = 10)
      )
    
    # Convert to plotly
    ggplotly(p, tooltip = "all") %>%
      layout(hovermode = "closest") %>%
      config(displayModeBar = TRUE, displaylogo = FALSE,
             modeBarButtonsToRemove = c("pan2d", "select2d", "lasso2d", "autoScale2d"))
  })
  
  # Data table
  output$data_table <- DT::renderDataTable({
    DT::datatable(
      weather_data,
      options = list(
        pageLength = 15,
        scrollX = TRUE,
        autoWidth = TRUE,
        searchHighlight = TRUE,
        dom = 'Bfrtip',
        buttons = c('copy', 'csv', 'excel')
      ),
      filter = 'top',
      rownames = FALSE
    )
  })
  
  # Download plot
  output$download_plot <- downloadHandler(
    filename = function() {
      paste0("weather_plot_", Sys.Date(), ".png")
    },
    content = function(file) {
      # Create the plot
      data <- filtered_data()
      
      if (input$chart_type == "scatter") {
        p <- ggplot(data, aes_string(x = input$x_variable, y = input$y_variable)) +
          geom_point(alpha = 0.7, size = 2, color = "#3498db")
        
        if (input$show_trend) {
          p <- p + geom_smooth(method = "lm", se = TRUE, color = "#e74c3c")
        }
      }
      
      p <- p + theme_minimal() +
        labs(title = paste("Weather Data:", input$y_variable, "vs", input$x_variable))
      
      ggsave(file, plot = p, device = "png", width = 10, height = 6, dpi = 300)
    }
  )
  
  # Download data
  output$download_data <- downloadHandler(
    filename = function() {
      paste0("weather_data_", Sys.Date(), ".csv")
    },
    content = function(file) {
      write.csv(filtered_data(), file, row.names = FALSE)
    }
  )
}

# Run the application
shinyApp(ui = ui, server = server)