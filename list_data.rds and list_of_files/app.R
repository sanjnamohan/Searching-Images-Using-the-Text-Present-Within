#
# This is a Shiny web application. You can run the application by clicking
# the 'Run App' button above.
#
# Find out more about building applications with Shiny here:
#
#    http://shiny.rstudio.com/
#


library(shiny)
#library(googledrive)
source('Text_Ext.R')

ui <- fluidPage(
  sidebarLayout(
    sidebarPanel(
      fluidRow( 
         fileInput("myFile", "Choose a file", accept = c('image/png', 'image/jpeg'))
      )
    ),
    mainPanel(
      div(id = "image-container", style = "display:flexbox"),
      verbatimTextOutput("console"),
      verbatimTextOutput("console1")
      
    )
  )
)


server <- function(input, output) {
  
  observeEvent(input$myFile, {
    setwd("/Users/rohith/Desktop/PROJECTS AND WORK FILES/trial/Images")
    inFile <- input$myFile
    if (is.null(inFile))
      return()
    if(file.exists(inFile$name)){
      setwd("/Users/rohith/Desktop/PROJECTS AND WORK FILES/trial") #if file already exists,to stop duplicate upload
      p<-readRDS("list_data.rds")
      output$console <- renderPrint({
        print(p)
      })
      p1<-readRDS("list_of_files.rds")
      output$console1 <- renderPrint({
        print(p1)
      })
    }
    else{file.copy(inFile$datapath, file.path("/Users/rohith/Desktop/PROJECTS AND WORK FILES/trial/Images", inFile$name) )
    t<-inFile$datapath
    u<-inFile$name
    p<-fun(t,u)
    
    output$console <- renderPrint({
      print(p)
    })
    p1<-readRDS("list_of_files.rds")
    output$console1 <- renderPrint({
      print(p1)
    })
    }
    #file.copy(inFile$datapath, file.path("/Users/rohith/Desktop/PROJECTS AND WORK FILES/REDO/images", inFile$name) )
    # drive_upload(media = input$myFile$datapath,
    #              path = '/Theia/',
    #                name = input$myFile$name)
    # b64 <- base64enc::dataURI(file = "https://googledrive.com/Folders/THEIA OWNERS/Theia/1img.png", mime = "image/png")
    # insertUI(
    #   selector = "#image-container",
    #   where = "afterBegin",
    #   ui = img(src = "https://googledrive.com/Folders/THEIA OWNERS/Theia/1img.png", width = 250, height = 250)
    # )
  })
  
} 
shinyApp(ui = ui, server = server)