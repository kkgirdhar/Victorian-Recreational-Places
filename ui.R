# library(markdown)
# library(leaflet)
# library(leaflet.extras)
# 
# fluidPage(style="padding-top: 10px;",
#           h1("Locations"),
#           absolutePanel(
#             top = 60, left = "auto", right = 20, bottom = "auto",
#             width = 330, height = "auto",draggable = TRUE,
#             wellPanel(
#               selectInput("Suburb", "Select one Suburb:",choices = c("Select one Suburb" = "All", as.character(mydata$SuburbTown))),
#               uiOutput("secondselection")
#               ),
#             style = "opacity: 1; z-index: 1000;"
#               ),
#           
#           leafletOutput("leafl", height = "800px")
#               )

library(leaflet)
library(markdown)
library(leaflet.extras)
library("rwunderground")

# mainPanel(
#   tags$head(
#     tags$style(type='text/css', 
#                ".nav-tabs {font-size: 10px} ")),    
#   tabsetPanel(tabPanel("Plot"))
# )

navbarPage("",id="nav",
           
           # tags$head(
           #   tags$style(type = 'text/css', ".tabPanel {font-size: 100px} " )
           # ), <h1 style="colour: green; font-size:16px">Big Heading</h1>
           #tags$div(
           #HTML(paste("This text is ", tags$span(style="color:red", "red"), sep = ""))
           
           tabPanel(
                    div(class="outer",
                        
                        tags$head(
                          includeCSS("styles.css")
                          #tags$style(type = 'text/css', ".nav-tabs {font-size: 40px} " )
                        ),
                        
                        
                        leafletOutput("map", width="100%", height="85%"),
                        
                        
                        #k beech
                        absolutePanel(id = "controls", class = "panel panel-default", fixed = TRUE,
                                      draggable = TRUE, top = 80, left = "auto", right = 20, bottom = "auto",
                                      width = 330, height = "auto",
                                      h5("Search for recreational Areas"),
                                      selectInput("Suburb", "Select one Suburb:",choices = c("Select one Suburb" = "All", as.character(mydata$SuburbTown))),
                                      uiOutput("secondselection")
                                      
                                      
                        ),
                        
                        absolutePanel(id = "weather", class = "panel panel-default", fixed = TRUE,
                                      draggable = TRUE, top = 600, left = 20, right = "auto", bottom = "auto",
                                      width = "auto" , height  ="auto",
                                      
                                      htmlOutput("area"),
                                      htmlOutput("details"),
                                      uiOutput("url")
                                      
                                      )
                        
                        #leafletOutput("map", width="100%", height="100%"),
                        
                        ###in dono
                        #leafletOutput("map", width="100%", height="100%")
                    )
                    
           )
)
