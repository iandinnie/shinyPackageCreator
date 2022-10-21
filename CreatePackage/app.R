library(devtools)
library(shiny)
library(stringr)

# Define UI
ui <- fluidPage(

    
    titlePanel("Create a package"),

    numericInput("num", label = h3("Add this number"), value = 1),
    
    textInput("packageName", label = h3("Enter a name for your package"), value = "APackage"),
    
    textInput("companyName", label = h3("Enter the name of your company"), value = "Posit"),
    
    textInput("author", label = h3("Enter your name"), value = "Ian Dinnie"),
    
    textInput("email", label = h3("Enter your email address"), value = "test@email.com"),
    
    actionButton("action", label = "Create Package")
)

# Define server logic 
# do we have to take advantage of session argument?
server <- function(input, output) {

  observeEvent(input$action, {
    numberToAdd <- input$num
    companyName <- input$companyName
    email <- input$email
    author <- input$author
    
    print(getwd())
    # setwd("To be edited")
    
    # define a function that adds user input to any number
    # this currently doesn't work; should add 1 to x
    myFunction <- function(x){
      print(x + numberToAdd)
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
    
    dump("myFunction", "To be edited/R/myFunction.R")
    
    use_description(
      fields = list(
        Package = "PackageWithFunction",
        Title = paste0("A package with custom theming for ", companyName),
        # this authors section doesn't currently work, unsure how important that is
        `Authors@R` = paste0('person("', unlist(stringr::str_split(author, " "))[1],'", ',unlist(stringr::str_split(author, " "))[2],'", , "',email,'", role = "aut")'),
        Description = paste0("A package with custom theming for ", companyName),
        License = "`use_mit_license()`",
        Encoding = "UTF-8",
        Roxygen = "list(markdown = TRUE)",
        RoxygenNote = "7.2.1"
        
      )
    )
    
    Sys.sleep(2)
    print(list.files())
    # move this DESCRIPTION file into 'To be edited' directory
    # this currently doesn't work, getting 'cannot rename file... 'No such file or directory exists'
    # I believe it is creating the description at the top level of the project, but it still doesn't find it when I point it there
    print(file.exists("/mnt/home/ian.dinnie/R/shinyPackageCreator/DESCRIPTION"))
    # file.copy(from = "shinyPackageCreator/DESCRIPTION",
    #           to = "shinyPackageCreator/CreatePackage/To be edited/DESCRIPTION")
    
    # how to generalize? this is pulling from Ian's directory
    # use git?
    # use temp directory?
    
    file.rename(paste0("/mnt/home/ian.dinnie/R/shinyPackageCreator/DESCRIPTION"),
                paste0(getwd(),"/To be edited/DESCRIPTION"))
    
  })
  

}

# Run the application 
shinyApp(ui = ui, server = server)
