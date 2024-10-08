library(shiny)
library(DT)
library(markdown)
library(readxl)

custom_css <- "
  .nav-buttons {
    display: flex;
    justify-content: center;
    margin-top: 10px;
    margin-bottom: 10px;
  }
  .scrollable-page {
    max-height: 100vh;
    overflow: auto;
  }
  .modal-fullscreen {
    width: 100%;
    height: 100%;
    margin: 0;
    padding: 0;
  }
  .modal-dialog-fullscreen {
    min-width: 100%;
    min-height: 100%;
  }
  .large-font {
    font-size: 24px;
  }
  .medium-font {
    font-size: 18px;
  }
  .scroll-table {
    overflow-x: auto;
  }
  .shiny-tab-panel {
    display: flex;
    flex-direction: column;
  }
  #main_tabs .tab-content {
    order: 1;
  }
  #main_tabs .nav-tabs {
    order: 2;
    justify-content: center;
    position: relative; /* Positioning context for the bottom */
    bottom: 0; /* Position tabs at the bottom */
    width: 100%; /* Ensure full width */
  }
"

# Home
front_page_ui <- fluidPage(
  titlePanel("Introduction to Shiny apps"),
  # h2("App Title", class = "large-font"),
  p("Paul Cleary", class = "medium-font"),
  p("October 9, 2024", class = "medium-font"),
  HTML(markdown::markdownToHTML(text = "
  ### Demonstration Shiny apps

  This site just includes some simple Shiny apps for demonstration purposes.

  To run this app on your own computer, run the following code in RStudio:
  ```r
  install.packages(c('shiny', 'htmltools', 'markdown', 'DT', 'data.table', 'bit64', 'readxl'))
  shiny::runGitHub('prcleary/shinyteaching')
  ````
  ", fragment.only = TRUE))



)

toc_ui <- fluidPage(
  titlePanel("TOC"),
  p("Click on any section below to navigate directly."),
  tags$ul(
    tags$li(actionLink("toc_nothing", "Nothing app")),
    tags$li(actionLink("toc_page1", "Page 1: Text Input")),
    tags$li(actionLink("toc_page2", "Page 2: Numeric Input")),
    tags$li(actionLink("toc_page3", "Page 3: Select Input"))#,
    # tags$li(actionLink("toc_embedded_app", "Embedded App")),
    # tags$li(actionLink("toc_file_upload", "File Upload & Editable Table"))
  )
)

nothing_ui <- fluidPage(
  h2("Nothing app"),
    HTML(markdown::markdownToHTML(text = "
  ```r
  library(shiny)
  ui <- fluidPage(
    # your frontend code will go here
  )
  server <- function(input, output) {
    # your backend code will go here
  }
  shinyApp(ui = ui, server = server)
  ````
  ", fragment.only = TRUE))
)

page1_ui <- fluidPage(
  h2("Page 1: Text Input"),
  HTML(markdown::markdownToHTML(text = "
  ### Markdown Section for Page 1
  This is some **Markdown** content on Page 1 with a line break.

  * Bullet point 1
  * Bullet point 2
  ", fragment.only = TRUE)),
  textInput("textinput", "Enter some text:"),
  verbatimTextOutput("textoutput")
)

page2_ui <- fluidPage(
  titlePanel("Page 2: Numeric Input"),
  sidebarLayout(
    sidebarPanel(
      numericInput("num_input", "Enter a number:", value = 10, min = 0, max = 100)
    ),
    mainPanel(
      textOutput("num_output")
    )
  )
)

page3_ui <- fluidPage(
  titlePanel("Page 3: Select Input"),
  sidebarLayout(
    sidebarPanel(
      selectInput("select_input", "Choose an option:", choices = c("Option 1", "Option 2", "Option 3"))
    ),
    mainPanel(
      textOutput("select_output")
    )
  )
)

# embedded_app_ui <- fluidPage(
#   titlePanel("Embedded Shiny App"),
#   sidebarLayout(
#     sidebarPanel(
#       selectInput("url_select", "Choose an app to embed:", choices = c("App 1" = "https://shiny.rstudio.com/", "App 2" = "https://www.shinyapps.io/")),
#       actionButton("view_app", "View App")
#     ),
#     mainPanel(
#       uiOutput("embedded_app_frame")
#     )
#   )
# )

# file_upload_ui <- fluidPage(
#   titlePanel("File Upload & Editable Table"),
#   sidebarLayout(
#     sidebarPanel(
#       fileInput("file", "Upload a CSV or Excel file"),
#       # actionButton("edit_fullscreen", "Edit Table Fullscreen"),
#       downloadButton("download_data", "Download Data")
#     ),
#     mainPanel(
#       DTOutput("data_table"),
#       div(
#         DTOutput("fullscreen_table"),
#         class = "modal fade modal-fullscreen", id = "fullscreen_modal"
#       )
#     )
#   )
# )

ui <- fluidPage(
  tags$head(tags$style(HTML(custom_css))),

  tabsetPanel(
    id = "main_tabs",
    type = "tabs",

    tabPanel("Home", front_page_ui),
    tabPanel("TOC", toc_ui),
    tabPanel("Nothing app", nothing_ui),
    tabPanel("Page 1", page1_ui),
    tabPanel("Page 2", page2_ui),
    tabPanel("Page 3", page3_ui)  #,
    # tabPanel("Embedded App", embedded_app_ui),
    # tabPanel("File Upload", file_upload_ui)
  ),

  div(
    class = "nav-buttons",
    actionButton("home_btn", "Home"),
    actionButton("back_btn", "Back"),
    actionButton("forward_btn", "Forward")
  )
)

server <- function(input, output, session) {

  observeEvent(input$toc_page1, {
    updateTabsetPanel(session, "main_tabs", selected = "Page 1")
  })

  observeEvent(input$toc_page2, {
    updateTabsetPanel(session, "main_tabs", selected = "Page 2")
  })

  observeEvent(input$toc_page3, {
    updateTabsetPanel(session, "main_tabs", selected = "Page 3")
  })

  # observeEvent(input$toc_embedded_app, {
  #   updateTabsetPanel(session, "main_tabs", selected = "Embedded App")
  # })

  # observeEvent(input$toc_file_upload, {
  #   updateTabsetPanel(session, "main_tabs", selected = "File Upload")
  # })

  observeEvent(input$home_btn, {
    updateTabsetPanel(session, "main_tabs", selected = "Home")
  })

  observeEvent(input$back_btn, {
    current_tab <- input$main_tabs
    tabs <- c("Home", "TOC", "Nothing app", "Page 1", "Page 2", "Page 3")  #, "Embedded App", "File Upload")
    current_index <- which(tabs == current_tab)
    if (current_index > 1) {
      updateTabsetPanel(session, "main_tabs", selected = tabs[current_index - 1])
    }
  })

  observeEvent(input$forward_btn, {
    current_tab <- input$main_tabs
    tabs <- c("Home", "TOC", "Nothing app", "Page 1", "Page 2", "Page 3") #, "Embedded App", "File Upload")
    current_index <- which(tabs == current_tab)
    if (current_index < length(tabs)) {
      updateTabsetPanel(session, "main_tabs", selected = tabs[current_index + 1])
    }
  })

  output$textoutput <- renderText({
    paste("You entered:", input$textinput)
  })

  output$num_output <- renderText({
    paste("You selected the number:", input$num_input)
  })

  output$select_output <- renderText({
    paste("You chose:", input$select_input)
  })

  # observeEvent(input$view_app, {
  #   output$embedded_app_frame <- renderUI({
  #     tags$iframe(src = input$url_select, width = "100%", height = "600px")
  #   })
  # })

  # observeEvent(input$file, {
  #   req(input$file)
  #   file_ext <- tools::file_ext(input$file$name)
  #   if (file_ext == "csv") {
  #     data <- read.csv(input$file$datapath)
  #   } else {
  #     data <- readxl::read_excel(input$file$datapath)
  #   }
  #   output$data_table <- renderDT({
  #     datatable(data, editable = TRUE)
  #   })
  #
  #   # Fullscreen table modal logic
  #   # output$fullscreen_table <- renderDT({
  #   #   datatable(data, editable = TRUE)
  #   # })
  #
  #   observeEvent(input$edit_fullscreen, {
  #     showModal(modalDialog(
  #       DTOutput("fullscreen_table"),
  #       footer = NULL,
  #       size = "l",
  #       easyClose = TRUE
  #     ))
  #   })
  # })
}

shinyApp(ui, server)
