library(devtools)
library(shiny)
library(stringr)
library(roxygen2)

# alternatively; use Shiny to make R/ folder with functions made from inputs, provide instructions for including them into a package


ui <- fluidPage(

    
    titlePanel("Create a package"),

    numericInput("num", label = h3("Add this number"), value = 1),
    
    textInput("packageName", label = h3("Enter a name for your package"), value = "APackage"),
    
    textInput("companyName", label = h3("Enter the name of your company"), value = "Posit"),
    
    textInput("author", label = h3("Enter your name"), value = "Ian Dinnie"),
    
    textInput("email", label = h3("Enter your email address"), value = "test@email.com"),
    
    actionButton("action", label = "Create Package")
)

server <- function(input, output) {

  observeEvent(input$action, {
    
    # currently unsure how to use temp directory to create package
    # path <- file.path(tempdir(), "mypkg")
    # setwd(path)
    # since a R file is really just plain text, we will write the functions as plain text
    fileConn <- file("myFunctionTest.R")
    writeLines(paste0("#' A test function
                      #'
                      #' @param x A numeric input to add to
                      #' 
                      #' @return The sum of x and the user input
                      #' @export
                      #'
                      #' @examples
                      #' x <- 1
                      #' myFunction(x,", input$num,")
                      myFunction <- function(x) + ", input$num), fileConn)
    close(fileConn)
    file.rename(paste0("/mnt/home/ian.dinnie/R/shinyPackageCreator/CreatePackage/myFunctionTest.R"),
                paste0(getwd(),"/To be edited/R/myFunctionTest.R"))
    print(list.files())
    use_description(
      fields = list(
        Package = "PackageWithFunction",
        Title = paste0("A package with custom theming for ", input$companyName),
        # this authors section doesn't currently work, unsure how important that is
        `Authors@R` = paste0('person("', unlist(stringr::str_split(input$author, " "))[1],'", ',unlist(stringr::str_split(input$author, " "))[2],'", , "',input$email,'", role = "aut")'),
        Description = paste0("A package with custom theming for ", input$companyName),
        License = "`use_mit_license()`",
        Encoding = "UTF-8",
        Roxygen = "list(markdown = TRUE)",
        RoxygenNote = "7.2.1"
        
      )
    )
    
    Sys.sleep(2)

    
    # how to generalize? this is pulling from Ian's directory
    # use git?
    # use temp directory?
    
    file.rename(paste0("/mnt/home/ian.dinnie/R/shinyPackageCreator/DESCRIPTION"),
                paste0(getwd(),"/To be edited/DESCRIPTION"))
    
    Sys.sleep(2)
    
    # License is being created at top level of directory
    use_mit_license()
    file.rename(paste0("/mnt/home/ian.dinnie/R/shinyPackageCreator/LICENSE.md"),
                paste0(getwd(),"/To be edited/LICENSE.md"))
    document("/mnt/home/ian.dinnie/R/shinyPackageCreator/CreatePackage/To be edited")
    roxygenize("/mnt/home/ian.dinnie/R/shinyPackageCreator/CreatePackage/To be edited")
    # document()
    # roxygenize()
    
  })
  
  

}

# Run the application 
shinyApp(ui = ui, server = server)
