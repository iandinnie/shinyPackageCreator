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
    
 
    # Need to figure out best way to save above myFunction to .R file verbatim and read it back in
      # the dump() function seems to write it properly, but I can't load it back in. Getting this error:
        # Error in load("myFunction2.R") : 
        #   bad restore file magic number (file may be corrupted) -- no data loaded
        # In addition: Warning message:
        # file ‘myFunction2.R’ has magic number 'myFun'
        #   Use of save versions prior to 2 is deprecated 
    # oddly, I can click on the file and view with no issue
    # I also was able to successfully create a package in a different session using dump() instead of writing the .R file by hand, so this may work
  
   # Not going to use devtools::create_package() as it launches a new session
    # And I don't feel like figuring that out right now
    # Instead, created a subdirectory 'To be edited' with the components of a package, which we can overwrite (thanks for the idea, Tom)
    # Should also erase their contents at the end for privacy
    # We can then zip that directory as a tar.gz, and hopefully have a package
    
  
    
  })
  

}

# Run the application 
shinyApp(ui = ui, server = server)
