library(shiny)
library(gdata)
library("rwunderground")

# chest <- icons(
#   iconUrl = "chest.png" , 
#   iconWidth = 18, iconHeight = 18
# )
ref <- a("Weather Underground", href="https://www.wunderground.com/", target="_blank")
location <- (set_location(territory = "Australia", city = "Melbourne"))

# Define server logic required 
shinyServer(function(input, output) {
  
  # ntext <- eventReactive(input$go, {
  #   
  #   leaflet(data = mydata) %>% addTiles()  %>%
  #     addCircles(lng= mydata$Longitude, lat = mydata$Latitude) %>%
  #     addCircleMarkers(~Longitude, ~Latitude,radius = .0002,popup = paste("Room Type", mydata$Longitude, "<br>",
  #                                                                         "Price:", mydata$Latitude, "<br>"))
  #   
  # })
  
  output$area <- renderText({
    
    if(input$Suburb == "All"){
    paste(h4("Weather in Melbourne"))  #"<font color=\"#FF0000\"><b>", input$n, "</b></font>"
    }
    else
      paste(h4("Weather in " , input$Suburb))
    
  })
  
  output$details <- renderText({
    if (input$Suburb == "All"){
    
    location <- (set_location(territory = "Australia", city = "Melbourne"))
    }
    else
    {
      location <- (set_location(territory = "Australia", city = input$Suburb))
    }
    
    # tryCatch({
    #   abc <- as.vector(conditions(location, use_metric = TRUE, key = "7c66212b86d504bb", raw = FALSE,
    #                               message = TRUE))
    # }, error = function(){
    #   location <- (set_location(territory = "Australia", city = "Melbourne"))
    #   return(NA)
    # }, finally = {
    #   #location <- (set_location(territory = "Australia", city = "Melbourne"))
    #   abc <- as.vector(conditions(location, use_metric = TRUE, key = "7c66212b86d504bb", raw = FALSE,
    #                               message = TRUE))
    # }
    # )
    
    b<- try(abc <- as.vector(conditions(location, use_metric = TRUE, key = "7c66212b86d504bb", raw = FALSE,message = TRUE)))
    if(class(b) == "try-error")
    {
      location <- (set_location(territory = "Australia", city = "Melbourne"))
      abc <- as.vector(conditions(location, use_metric = TRUE, key = "7c66212b86d504bb", raw = FALSE,message = TRUE))
    }
       
    #abc <- as.vector(conditions(location, use_metric = TRUE, key = "7c66212b86d504bb", raw = FALSE,
      #                          message = TRUE))
    
    paste("Condition:" , abc$weather , "<br>",
           "Temp: ", abc$temp, "°C","<br>",
            "Wind: ", abc$wind_dir , " ", abc$wind_spd, " ", "km/hr" )
    
    
    
  })
  
  output$url <- renderUI({
    
    tagList( ref)
    
  })
  
  
  output$secondselection <- renderUI({
    
    if (input$Suburb == "All")
    {
      selectInput("Sports", "Select one Sport:", 
                  choices = c("All Sports" = "All", as.character(mydata$SportsPlayed) ))
    }
    else
    {
    selectInput("Sports", "Select one Sport:", 
                choices = c("All Sports" = "All" , as.character(mydata[mydata$SuburbTown==input$Suburb, "SportsPlayed"])))
    }
      })
  
  
  
  output$map <- renderLeaflet({
    
    if ( input$Suburb == "All" & input$Sports == "All"){
     map <- leaflet(data = mydata, width = "100%",height = "100%") %>% addTiles(
       urlTemplate = "//{s}.tiles.mapbox.com/v3/jcheng.map-5ebohr46/{z}/{x}/{y}.png",
       attribution = 'Maps by <a href="http://www.mapbox.com/">Mapbox</a>'
     ) %>% #addMarkers(lng= mydata$Longitude, lat = mydata$Latitude ) %>%
       addCircles(lng= mydata$Longitude, lat = mydata$Latitude) %>%
       #addPopups(~Longitude, ~Latitude,popup = paste(mydata$FacilityName, "<br>", mydata$Street, " " ,mydata$SuburbTown,"<br>", mydata$SportsPlayed))%>%
       addCircleMarkers(~Longitude, ~Latitude,radius = 2,popup = paste(mydata$FacilityName, "<br>", mydata$Street, " " ,
                                                                           mydata$SuburbTown,"<br>", mydata$SportsPlayed)) %>%
        setView(lng = 144.9631, lat = -37.8136, zoom = 12) %>% addControlGPS(options = gpsOptions(position = "topleft", activate = TRUE,
                                                                                                   autoCenter = TRUE, maxZoom = 16,
                                                                                                   setView = TRUE))
     activateGPS(map)
    }
    else if (input$Suburb == "All"){
      
      ydata<- mydata[mydata$SportsPlayed == input$Sports, ]
      
      leaflet(data = ydata) %>% addTiles(
        urlTemplate = "//{s}.tiles.mapbox.com/v3/jcheng.map-5ebohr46/{z}/{x}/{y}.png",
        attribution = 'Maps by <a href="http://www.mapbox.com/">Mapbox</a>'
      ) %>%
        addCircles(lng= ydata$Longitude, lat = ydata$Latitude) %>%
        addCircleMarkers(~Longitude, ~Latitude,radius = .0002,popup = paste(ydata$FacilityName, "<br>", ydata$Street, " " ,
                                                                            ydata$SuburbTown,"<br>", ydata$SportsPlayed))
    }
    
    else if (input$Sports == "All"){
      
      ydata<- mydata[mydata$SuburbTown == input$Suburb, ]
      
      leaflet(data = ydata) %>% addTiles(
        urlTemplate = "//{s}.tiles.mapbox.com/v3/jcheng.map-5ebohr46/{z}/{x}/{y}.png",
        attribution = 'Maps by <a href="http://www.mapbox.com/">Mapbox</a>'
      )  %>% #addMarkers(lng= ydata$Longitude, lat = ydata$Latitude ) %>%
        addCircles(lng= ydata$Longitude, lat = ydata$Latitude) %>%
        addCircleMarkers(~Longitude, ~Latitude,radius = .0002,popup = paste(ydata$FacilityName, "<br>", ydata$Street, " " ,
                                                                            ydata$SuburbTown,"<br>", ydata$SportsPlayed))
    }
    
    else{
      
      ydata<- mydata[mydata$SuburbTown == input$Suburb, ]
      ydata<- ydata[ydata$SportsPlayed == input$Sports, ]
      leaflet(data = ydata) %>% addTiles(
        urlTemplate = "//{s}.tiles.mapbox.com/v3/jcheng.map-5ebohr46/{z}/{x}/{y}.png",
        attribution = 'Maps by <a href="http://www.mapbox.com/">Mapbox</a>'
      )  %>% #addMarkers(lng= ydata$Longitude, lat = ydata$Latitude ) %>%
        addCircles(lng= ydata$Longitude, lat = ydata$Latitude) %>%
        addCircleMarkers(~Longitude, ~Latitude,radius = .0002,popup = paste(ydata$FacilityName, "<br>", ydata$Street, " " ,
                                                                            ydata$SuburbTown,"<br>", ydata$SportsPlayed))
      }
    
    
  })
})