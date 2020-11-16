shinyServer(function(input, output, session)  {
    options(shiny.maxRequestSize=50*1024^2)

    data <- reactive({
        req(input$file)
        shpDF <- input$file
        if(nrow(shpDF) == 1)
        {
            shpPath <- input$file$datapath

        }else
        {
            prevWD <- getwd()
            uploadDirectory <- dirname(shpDF$datapath[1])
            setwd(uploadDirectory)
            for (i in 1:nrow(shpDF)){
                file.rename(shpDF$datapath[i], shpDF$name[i])
            }
            shpName <- shpDF$name[grep(x=shpDF$name, pattern="*.shp")]
            shpPath <- paste(uploadDirectory, shpName, sep="/")
            setwd(prevWD)
        }

        df <- read_sf(shpPath)
        dt$df <- df
    })

    dt <- reactiveValues()

    output$table <- renderDataTable({
        req(input$file)
        tb = data()
        return(tb[,-ncol(tb), drop = TRUE])
        })

    output$map <- renderLeaflet({

            tmap_mode("view")
            map = data()

            if(input$variable == " " | input$variable == "NONE")
            {
                ciao <- tm_shape(map) + tm_polygons(col = 'grey80', popup.vars = input$pop) + tm_tiles(input$tiles)

            }else{
                ciao <- tm_shape(map) + tm_polygons(col = input$variable, style = input$legend, palette = input$palette, popup.vars = input$pop)

            }
            return(tmap_leaflet(ciao))

    })


    observe({
        tb = data()
        tb <- tb[,-ncol(tb), drop = TRUE]

        updateSelectInput(session, inputId="variables", label="Variables",
                          choices=names(tb), selected = names(tb))
        updateSelectInput(session, inputId="variable", label="Color variable",
                          choices=c(names(tb),"NONE"), selected = " ")
        updateSelectInput(session, inputId="pop", label="Popup Variables",
                           choices= names(tb), selected = names(tb))

        output$table <- renderDataTable({
            return(tb[,input$variables, drop = FALSE])
        })

    })

    output$download <- downloadHandler(
        filename = function() {

            if(input$download_type == "data.csv")
            {
                paste("data", "csv", sep = ".")

            }else if(input$download_type == "data.RData")
            {
               paste("data", "RData", sep = ".")
            }else if(input$download_type == "data.geojson")
            {
                paste("data", "geojson", sep = ".")

            }else if(input$download_type == "map&data.RData")
            {
                paste("dataMap", "Rdata", sep = ".")
            }else if (input$download_type == "map.pdf")
            {
                paste("map", "pdf", sep = ".")

            }else if(input$download_type == "map.jpeg")
            {
                paste("map", "jpeg", sep = ".")
            }else if(input$download_type == "map.png")
            {
                paste("map", "png", sep = ".")
            }else if(input$download_type == "map.html")
            {
                paste("map", "html", sep = ".")
            }

        },
        content = function(file)
        {
            dt <- data()
            df <- dt[,-ncol(dt), drop = TRUE]
            if(input$download_type == "data.csv")
            {
                write.csv(df, file, row.names = FALSE)

            }else if(input$download_type == "data.RData")
            {
                save(df, file = file)
            }else if(input$download_type == "data.geojson")
            {
                geojson_write(input = dt,
                              geometry = "polygon", file = file,
                              crs = "+init=epsg:4326")

            }else if(input$download_type == "map&data.RData")
            {
                save(df, dt, file = file)
            }else{

                tmap_mode("view")
                map = data()
                #nm <- names(map)[-ncol(map)]

                if(input$variable == " " | input$variable == "NONE")
                {
                    #ciao = mapview(map)
                    ciao <- tm_shape(map) + tm_polygons(col = 'grey80', popup.vars = input$pop) + tm_tiles(input$tiles)

                }else{
                    #ciao = mapview(map, zcol = input$variable)
                    ciao <- tm_shape(map) + tm_polygons(col = input$variable, style = input$legend, palette = input$palette, popup.vars = input$pop)

                }

                if(input$download_type == "map.pdf")
                {
                mapshot(tmap_leaflet(ciao), file = file)
                }else if(input$download_type == "map.jpeg")
                {
                    mapshot(tmap_leaflet(ciao), file = file)

                }else if(input$download_type == "map.png")
                {
                    mapshot(tmap_leaflet(ciao), file = file)

                }else if(input$download_type == "map.html")
                {
                    mapshot(tmap_leaflet(ciao), url = file)

                }
            }
        }



    )

})

