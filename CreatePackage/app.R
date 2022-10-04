library(devtools)
library(shiny)

# Define UI
ui <- fluidPage(

    
    titlePanel("Create a package"),

    numericInput("num", label = h3("Add this number"), value = 1),
    
    actionButton("action", label = "Create Package")
)

# Define server logic 
# do we have to take advantage of session argument?
server <- function(input, output) {

  observeEvent(input$action, {
    numberToAdd <- input$num
    
    # define a function that adds user input to any number
    myFunction <- function(x, numberToAdd){
      x + numberToAdd
    }
    
    # this is the hard part
    # this function launches a new r session
    # which sort of breaks the app;
    # not sure how to handle this, should the session variable be used?
    # Ian is not currently sure what that does. 
    # Also, need to figure out how to save/load above myFunction to .R file verbatim; 
    # the dump() function will save it verbatim, but I can't read it in with load(), get the following error:
      # Error in load("myFunction.R") : 
        # bad restore file magic number (file may be corrupted) -- no data loaded
      # In addition: Warning message:
      # file ‘myFunction.R’ has magic number 'myFun'
        #  Use of save versions prior to 2 is deprecated 
    # just running save(myFunction) does not save it verbatim, but maybe I'm using it wrong?
    create_package(
      path = tempdir(),
      open = F
    )
    save(myFunction, file = "myFunction.R")
    
  })
  

}

# Run the application 
shinyApp(ui = ui, server = server)
