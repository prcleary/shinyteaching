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
    tags$li(actionLink("toc_text", "Text Input and Output")),
    tags$li(actionLink("toc_numbers", "Numbers")),
    tags$li(actionLink("toc_dropdowns", "Dropdowns"))#,
    # tags$li(actionLink("toc_embedded_app", "Embedded App")),
    # tags$li(actionLink("toc_file_upload", "File Upload & Editable Table"))
  )
)

nothing_ui <- fluidPage(
  h2("Nothing app"),
  h3("Frontend (nothing)"),
  h3("Code"),
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

text_ui <- fluidPage(
  h2("Text Input and Output"),
  h3("Frontend"),
  textInput("textinput", "Enter some text:"),
  verbatimTextOutput("textoutput"),
  h3("Code"),
  HTML(
    markdown::markdownToHTML(
      text = "
  ```r
  library(shiny)
  ui <- fluidPage(textInput('textinput', 'Enter some text:'),
                  verbatimTextOutput('textoutput')
  )
  server <- function(input, output) {
    output$textoutput <- renderText({
      paste('You entered:', input$textinput)
    })
  }
  shinyApp(ui = ui, server = server)
  ````
  ",
      fragment.only = TRUE
    )
  )
)

numbers_ui <- fluidPage(
  h2("Numbers"),
  h3("Frontend"),
  sidebarLayout(
    sidebarPanel(
      numericInput("num_input", "Enter a number:", value = 10, min = 0, max = 100)
    ),
    mainPanel(
      textOutput("num_output")
    )
  ),
  h3("Code"),
  HTML(
    markdown::markdownToHTML(
      text = "
  ```r
  library(shiny)
  ui <- fluidPage(titlePanel('Numbers'),
                  sidebarLayout(sidebarPanel(
                    numericInput(
                      'num_input',
                      'Enter a number:',
                      value = 10,
                      min = 0,
                      max = 100
                    )
                  ),
                  mainPanel(textOutput('num_output'))))
  server <- function(input, output) {
    output$num_output <- renderText({
      paste('You selected the number:', input$num_input)
    })
  }
  shinyApp(ui = ui, server = server)
  ````
  ",
      fragment.only = TRUE
    )
  )
)

dropdowns_ui <- fluidPage(
  titlePanel("Dropdowns"),
  h3("Frontend"),
  sidebarLayout(
    sidebarPanel(
      selectInput("select_input", "Choose an option:", choices = c("Option 1", "Option 2", "Option 3"))
    ),
    mainPanel(
      textOutput("select_output")
    )
  ),
  h3("Code"),
  HTML(
    markdown::markdownToHTML(
      text = "
  ```r
  library(shiny)
  ui <- sidebarLayout(sidebarPanel(selectInput(
    'select_input',
    'Choose an option:',
    choices = c('Option 1', 'Option 2', 'Option 3')
  )),
                      mainPanel(textOutput('select_output')))
  server <- function(input, output) {
    output$select_output <- renderText({
      paste('You chose:', input$select_input)
    })
  }
  shinyApp(ui = ui, server = server)
  ````
  ",
      fragment.only = TRUE
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
    tabPanel("Text Input and Output", text_ui),
    tabPanel("Numbers", numbers_ui),
    tabPanel("Dropdowns", dropdowns_ui)  #,
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

  observeEvent(input$toc_nothing, {
    updateTabsetPanel(session, "main_tabs", selected = "Nothing app")
  })

  observeEvent(input$toc_text, {
    updateTabsetPanel(session, "main_tabs", selected = "Text Input and Output")
  })

  observeEvent(input$toc_numbers, {
    updateTabsetPanel(session, "main_tabs", selected = "Numbers")
  })

  observeEvent(input$toc_dropdowns, {
    updateTabsetPanel(session, "main_tabs", selected = "Dropdowns")
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
    tabs <- c("Home", "TOC", "Nothing app", "Text Input and Output", "Numbers", "Dropdowns")  #, "Embedded App", "File Upload")
    current_index <- which(tabs == current_tab)
    if (current_index > 1) {
      updateTabsetPanel(session, "main_tabs", selected = tabs[current_index - 1])
    }
  })

  observeEvent(input$forward_btn, {
    current_tab <- input$main_tabs
    tabs <- c("Home", "TOC", "Nothing app", "Text Input and Output", "Numbers", "Dropdowns") #, "Embedded App", "File Upload")
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
