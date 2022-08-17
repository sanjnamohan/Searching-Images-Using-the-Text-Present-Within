# Invoking required libraries

library(shiny)
library(shinydashboard, warn.conflicts = FALSE)
library(shinythemes)
library(shinyWidgets)
library(stringr)

cs <- list()

source('Text_Ext.R')

# Setting working directory
setwd("/Users/rohith/Desktop/PROJECTS AND WORK FILES/trial/Images")

# Define UI for data upload app ----
ui <- navbarPage(
  position = "fixed-top", # To keep navigation bar static
  theme = shinytheme("slate"), # Applying slate theme
  
  fluid = TRUE,
  responsive = NULL,
  
  # Dashboard Title
  "Image Search Dashboard",
  
  # Default Selected Tab ----
  tabPanel("THEIA", icon = icon("fire",  lib = "glyphicon"),
           
           # Page Break
           br(),br(),br(),br(),
           
           # Sidebar layout with input and output definitions ----
           sidebarLayout(
             
             # Sidebar panel for inputs 
             sidebarPanel(
               
               # Search input for searching image
               searchInput(
                 inputId = "search",
                 label = "Enter your text",
                 value = "",
                 placeholder = "Theia Search",
                 btnSearch = icon("search"),
                 btnReset = icon("remove"),
                 width = "450px"
               ),
               fileInput(
                 inputId = "myFile",
                 label = "Upload Image",
                 accept = c('image/png', 'image/jpeg','image/jpg')
               )
               
               # Radio buttons to classify the type of image
               
               # Invoking an action button for search option
               #actionButton("action", label = "Search", class = "btn-secondary")
               
             ),
             
             # Main panel for displaying outputs ----
             mainPanel(
               
       
              uiOutput("myImage1") 
              #verbatimTextOutput("console")
             )
        )
  ),
           
  # Navigation menu tab
  tabPanel("Help",icon = icon("question-circle"),
           
           tags$iframe(style="height:1600px; width:100%;scrolling=yes", src="theia.pdf")),
  
  # Navigation menu tab
  navbarMenu("Users", icon = icon("users"), 
             tabPanel("Profile", icon = icon("user")),
             tabPanel("Privacy", icon = icon("shield"),tags$iframe(style="height:1600px; width:100%;scrolling=yes", src="privacy.pdf")), 
             tabPanel("About", icon = icon("cogs"),tags$iframe(style="height:1600px; width:100%;scrolling=yes", src="about.pdf") ))
  
  # Navigation menu tab
  
           
           # Page Break
           
             
           )
         
       


# Define server logic to read selected file ----
server <- function(input, output) {
   
  observeEvent(input$myFile,{
    setwd("/Users/rohith/Desktop/PROJECTS AND WORK FILES/trial/Images")
    inFile <- input$myFile
    if (is.null(inFile))
      return()
    if(file.exists(inFile$name)){
      #if file already exists,to stop duplicate upload
     return()
    }
    else{
      file.copy(inFile$datapath, file.path("/Users/rohith/Desktop/PROJECTS AND WORK FILES/trial/Images", inFile$name) )
      t<-inFile$datapath
      u <- inFile$name
      fun(t,u)
      
      setwd("/Users/rohith/Desktop/PROJECTS AND WORK FILES/trial/Images")
      output$myImage1 <- renderUI({
      
        b64 <- list()
        for (i in list.files()) {
          name <- paste('image:', i, sep = '')
          tmp <- base64enc::dataURI(file = i, mime = "image/png")
          b64[[name]] <- tmp
        }
        
        # List to display all images in the UI
        a64 <- list()
        for (j in (1:length(b64))) {
          name_1 <- paste('img:', j, sep = '')
          tmp_1 <- img(src = b64[j],
                       width = 250,
                       height = 250)
          a64[[name_1]] <- tmp_1
        }
        a64
        # Output list of images
       })
    } 
})
  observeEvent(input$search,{
    setwd("/Users/rohith/Desktop/PROJECTS AND WORK FILES/trial")
    list_data <- readRDS("list_data.rds")
    img_trai<-  readRDS("list_of_files.rds")
    setwd("/Users/rohith/Desktop/PROJECTS AND WORK FILES/trial/Images")
     output$myImage1 <- renderUI({
      if(input$search==''){
      #h1("LET'S THEIA ")
        b64 <- list()
        for (i in list.files()) {
          name <- paste('image:', i, sep = '')
          tmp <- base64enc::dataURI(file = i, mime = "image/png")
          b64[[name]] <- tmp
        }
        
        # List to display all images in the UI
        a64 <- list()
        for (j in (1:length(b64))) {
          name_1 <- paste('img:', j, sep = '')
          tmp_1 <- img(src = b64[j],
                       width = 250,
                       height = 250)
          a64[[name_1]] <- tmp_1
        }
        
        # Output list of images
        a64
    
      }
  
  
    else{ 
    c <- input$search
    if(str_detect(c,",")) {
      c1 <- strsplit(c,",")
      f <- unlist(c1)
      
      g <- c(f[1],f[2])
      h <- c(f[2],f[1])
      g1 <- paste(g,collapse = ".*")
      g2 <- paste(h,collapse= ".*")
      d <- c(g1,g2)
      id <- grep(paste(d,collapse="|"), list_data,ignore.case = TRUE)
    }
    else
    { id <- grep(toString(c), list_data,ignore.case = TRUE)}
    # id <- grep(toString(c), list_data,ignore.case = TRUE)
    list_of_paths<-list()
    
    for(i in 1:length(id)){
      list_of_paths[i]<-c(img_trai[id[i]])
    }
    # k <- list()
    # for(j in list_of_paths){
    #   k[[j]] <- img(src = j,width = 250,
    #                   height = 250)
    # }
    b64 <- list()
    for (i in list_of_paths) {
      name <- paste('image:', i, sep = '')
      tmp <- base64enc::dataURI(file = i, mime = "image/png")
      b64[[name]] <- tmp
    }
    
    # List to display all images in the UI
    a64 <- list()
    for (j in (1:length(b64))) {
      name_1 <- paste('img:', j, sep = '')
      tmp_1 <- img(src = b64[j],
                   width = 250,
                   height = 250)
      a64[[name_1]] <- tmp_1
    }
    
    # Output list of images
    a64
    
    }      
         })
  })

 
  

}







# Run the app ----
shinyApp(ui, server)

