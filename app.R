# Visualisasi Data Cuaca - Aplikasi Shiny Interaktif
# Berdasarkan kebutuhan PRD untuk eksplorasi data cuaca edukatif

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
      stop("File data tidak mengandung 22 kolom yang diharapkan")
    }
    
    # Convert categorical variables to factors
    categorical_vars <- c("WindGustDir", "WindDir9am", "WindDir3pm", "RainToday", "RainTomorrow")
    data[categorical_vars] <- lapply(data[categorical_vars], as.factor)
    
    # Add row numbers for identification
    data$ID <- 1:nrow(data)
    
    return(data)
  }, error = function(e) {
    stop(paste("Kesalahan saat memuat data:", e$message))
  })
}

# Define variable categories and metadata
get_variable_info <- function() {
  list(
    continuous = list(
      "Suhu" = c("MinTemp" = "Suhu Minimum (°C)",
                 "MaxTemp" = "Suhu Maksimum (°C)",
                 "Temp9am" = "Suhu Pukul 09.00 (°C)",
                 "Temp3pm" = "Suhu Pukul 15.00 (°C)"),
      
      "Presipitasi" = c("Rainfall" = "Curah Hujan (mm)",
                        "Evaporation" = "Evaporasi (mm)",
                        "RISK_MM" = "Risiko Curah Hujan (mm)"),
      
      "Angin" = c("WindGustSpeed" = "Kecepatan Hembusan Angin (km/jam)",
                  "WindSpeed9am" = "Kecepatan Angin Pukul 09.00 (km/jam)",
                  "WindSpeed3pm" = "Kecepatan Angin Pukul 15.00 (km/jam)"),
      
      "Atmosfer" = c("Sunshine" = "Sinar Matahari (jam)",
                     "Humidity9am" = "Kelembapan Pukul 09.00 (%)",
                     "Humidity3pm" = "Kelembapan Pukul 15.00 (%)",
                     "Pressure9am" = "Tekanan Udara Pukul 09.00 (hPa)",
                     "Pressure3pm" = "Tekanan Udara Pukul 15.00 (hPa)",
                     "Cloud9am" = "Tutupan Awan Pukul 09.00 (oktas)",
                     "Cloud3pm" = "Tutupan Awan Pukul 15.00 (oktas)")
    ),
    
    categorical = c("WindGustDir" = "Arah Hembusan Angin",
                   "WindDir9am" = "Arah Angin Pukul 09.00",
                   "WindDir3pm" = "Arah Angin Pukul 15.00",
                   "RainToday" = "Hujan Hari Ini",
                   "RainTomorrow" = "Hujan Besok")
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
    "Variabel Kontinu" = continuous_choices,
    "Variabel Kategorikal" = categorical_choices
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
      message = "📊 Rekomendasi: Diagram Sebar - Sempurna untuk mengeksplorasi hubungan antara dua variabel kontinu. Cari korelasi, tren, dan data outlier."
    ))
  } else if ((!x_is_continuous && y_is_continuous) || (x_is_continuous && !y_is_continuous)) {
    return(list(
      recommended = "bar",
      message = "📊 Rekomendasi: Diagram Batang - Ideal untuk membandingkan nilai antar kategori. Gunakan untuk melihat bagaimana nilai numerik bervariasi per kelompok."
    ))
  } else {
    return(list(
      recommended = "bar",
      message = "📊 Rekomendasi: Diagram Batang - Bagus untuk analisis frekuensi data kategorikal."
    ))
  }
}

# Load data
weather_data <- load_weather_data()

# Define UI
ui <- dashboardPage(
  dashboardHeader(title = "Visualisasi Data Cuaca Interaktif"),
  
  dashboardSidebar(
    sidebarMenu(
      menuItem("Visualisasi", tabName = "viz", icon = icon("chart-line")),
      menuItem("Tabel Data", tabName = "data", icon = icon("table")),
      menuItem("Bantuan", tabName = "help", icon = icon("question-circle"))
    ),
    
    # Variable Selection
    div(style = "padding: 20px;",
      h4("Pemilihan Variabel"),
      
      selectInput("x_variable",
                 "Variabel Sumbu-X:",
                 choices = get_variable_choices(),
                 selected = "MaxTemp"),
      
      selectInput("y_variable",
                 "Variabel Sumbu-Y:",
                 choices = get_variable_choices(),
                 selected = "MinTemp"),
      
      # Chart Type Selection
      h4("Jenis Grafik"),
      radioButtons("chart_type",
                  "Pilih Visualisasi:",
                  choices = list(
                    "Diagram Sebar" = "scatter",
                    "Diagram Garis" = "line",
                    "Diagram Batang" = "bar"
                  ),
                  selected = "scatter"),
      
      # Additional Options
      h4("Opsi Tambahan"),
      checkboxInput("show_trend", "Tampilkan Garis Tren", FALSE),
      checkboxInput("group_data", "Kelompokkan berdasarkan Hujan Hari Ini", FALSE),
      
      # Download Options
      br(),
      downloadButton("download_plot", "Unduh Grafik", class = "btn-primary"),
      br(), br(),
      downloadButton("download_data", "Unduh Data", class = "btn-secondary")
    )
  ),
  
  dashboardBody(
    tabItems(
      # Visualization Tab
      tabItem(tabName = "viz",
        fluidRow(
          box(width = 12, status = "primary",
            h3("Visualisasi Data Cuaca Interaktif"),
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
          
          box(width = 3, status = "info", title = "Informasi Variabel",
            h4("Variabel Terpilih:"),
            verbatimTextOutput("variable_info"),
            
            h4("Statistik Ringkasan:"),
            tableOutput("summary_stats"),
            
            h4("Catatan Edukatif:"),
            div(style = "font-size: 12px; color: #666;",
                textOutput("educational_notes")
            )
          )
        )
      ),
      
      # Data Table Tab
      tabItem(tabName = "data",
        fluidRow(
          box(width = 12, status = "primary", title = "Dataset Cuaca",
            p("Tabel ini berisi 366 pengamatan cuaca harian dengan 22 variabel.
              Gunakan fitur pencarian, sortir, dan filter untuk mengeksplorasi data."),
            DT::dataTableOutput("data_table")
          )
        )
      ),
      
      # Help Tab
      tabItem(tabName = "help",
        fluidRow(
          box(width = 12, status = "primary", title = "Bantuan & Petunjuk",
            h3("Memulai"),
            p("Aplikasi ini membantu Anda mengeksplorasi data cuaca melalui visualisasi interaktif."),
            
            h4("Cara Penggunaan:"),
            tags$ol(
              tags$li("Pilih variabel dari dropdown di sidebar"),
              tags$li("Pilih jenis grafik yang sesuai dengan data Anda"),
              tags$li("Berinteraksi dengan grafik dengan cara mengarahkan kursor, zoom, dan geser"),
              tags$li("Gunakan tab Tabel Data untuk memeriksa data mentah"),
              tags$li("Unduh grafik dan data untuk tugas Anda")
            ),
            
            h4("Jenis Grafik:"),
            tags$ul(
              tags$li(strong("Diagram Sebar:"), " Terbaik untuk mengeksplorasi hubungan antara dua variabel kontinu"),
              tags$li(strong("Diagram Garis:"), " Ideal untuk menunjukkan tren dan pola dalam urutan data"),
              tags$li(strong("Diagram Batang:"), " Sempurna untuk membandingkan kategori atau menunjukkan distribusi")
            ),
            
            h4("Informasi Dataset:"),
            p("Dataset ini berisi 366 pengamatan cuaca harian dari Porto, Portugal dengan kategori variabel berikut:"),
            
            h5("Variabel Suhu:"),
            p("MinTemp, MaxTemp, Temp9am, Temp3pm (semua dalam °C)"),
            
            h5("Variabel Presipitasi:"),
            p("Rainfall, Evaporation, RISK_MM (semua dalam mm)"),
            
            h5("Variabel Angin:"),
            p("WindGustSpeed, WindSpeed9am, WindSpeed3pm (km/jam), WindGustDir, WindDir9am, WindDir3pm"),
            
            h5("Variabel Atmosfer:"),
            p("Sunshine (jam), Humidity9am/3pm (%), Pressure9am/3pm (hPa), Cloud9am/3pm (oktas)"),
            
            h5("Indikator Hujan:"),
            p("RainToday, RainTomorrow (Ya/Tidak)")
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
    
    paste0("Sumbu-X: ", input$x_variable, " (", x_desc, ")",
           "\nSumbu-Y: ", input$y_variable, " (", y_desc, ")")
  })
  
  # Summary statistics
  output$summary_stats <- renderTable({
    data <- filtered_data()
    
    if (input$x_variable %in% names(data) && input$y_variable %in% names(data)) {
      x_data <- data[[input$x_variable]]
      y_data <- data[[input$y_variable]]
      
      if (is.numeric(x_data) && is.numeric(y_data)) {
        data.frame(
          Variabel = c(input$x_variable, input$y_variable),
          Rata2 = round(c(mean(x_data, na.rm = TRUE), mean(y_data, na.rm = TRUE)), 2),
          Median = round(c(median(x_data, na.rm = TRUE), median(y_data, na.rm = TRUE)), 2),
          StandarDeviasi = round(c(sd(x_data, na.rm = TRUE), sd(y_data, na.rm = TRUE)), 2)
        )
      }
    }
  })
  
  # Educational notes
  output$educational_notes <- renderText({
    chart_type <- input$chart_type
    
    notes <- switch(chart_type,
      "scatter" = "Cari pola: korelasi positif/negatif, kelompok data, atau outlier. Korelasi kuat menunjukkan hubungan antar variabel.",
      "line" = "Periksa tren: apakah nilai meningkat, menurun, atau siklis? Cari pola musiman atau puncak/lembah yang tidak biasa.",
      "bar" = "Bandingkan tinggi: kategori mana yang memiliki nilai tertinggi/terendah? Cari pola antar kelompok yang berbeda."
    )
    
    notes
  })
  
  # Main plot
  output$main_plot <- renderPlotly({
    data <- filtered_data()
    
    if (nrow(data) == 0) {
      return(plotly_empty() %>%
             layout(title = "Tidak ada data tersedia untuk variabel yang dipilih"))
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
      
      p <- p + labs(x = "Indeks Pengamatan")
      
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
          p <- p + labs(y = paste("Rata-rata", input$x_variable))
        } else {
          # Both continuous - create histogram
          p <- ggplot(data, aes_string(x = input$x_variable))
          p <- p + geom_histogram(fill = "#3498db", alpha = 0.8, bins = 20)
          p <- p + labs(y = "Frekuensi")
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
          p <- p + labs(y = paste("Rata-rata", input$y_variable))
        } else {
          # Both categorical - frequency count
          count_data <- data %>%
            count(!!sym(input$x_variable), name = "count")
          
          p <- ggplot(count_data, aes_string(x = input$x_variable, y = "count"))
          p <- p + geom_col(fill = "#3498db", alpha = 0.8)
          p <- p + labs(y = "Jumlah")
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
        labs(title = paste("Data Cuaca:", input$y_variable, "vs", input$x_variable))
      
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