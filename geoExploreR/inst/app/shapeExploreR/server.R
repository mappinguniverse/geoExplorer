shinyServer(function(input, output, session) {
  options(shiny.maxRequestSize = 50 * 1024^2)

  data <- reactive({
    req(input$file)
    shp <- input$file
    if (nrow(shp) == 1) {
      shp_dir <- input$file$datapath
    } else {
      dir_prv <- getwd()
      uploadDirectory <- dirname(shp$datapath[1])
      setwd(uploadDirectory)
      for (i in 1:nrow(shp)) {
        file.rename(shp$datapath[i], shp$name[i])
      }
      shp_names <- shp$name[grep(x = shp$name, pattern = "*.shp")]
      shp_dir <- paste(uploadDirectory, shp_names, sep = "/")
      setwd(dir_prv)
    }

    df <- read_sf(shp_dir)
    dt$df <- df
  })

  dt <- reactiveValues()

  output$table <- renderDataTable({
    req(input$file)
    tb <- data()
    return(tb[, -ncol(tb), drop = TRUE])
  })

  output$map <- renderLeaflet({
    tmap_mode("view")
    map <- data()

    if (input$variable == " " | input$variable == "NONE") {
      ciao <- tm_shape(map) + tm_polygons(col = "grey80", popup.vars = input$pop) + tm_tiles(input$tiles)
    } else {
      ciao <- tm_shape(map) + tm_polygons(col = input$variable, style = input$legend, palette = input$palette, popup.vars = input$pop)
    }
    return(tmap_leaflet(ciao))
  })


  observe({
    tb <- data()
    tb <- tb[, -ncol(tb), drop = TRUE]

    updateSelectInput(session,
      inputId = "variables", label = "Variables",
      choices = names(tb), selected = names(tb)
    )
    updateSelectInput(session,
      inputId = "variable", label = "Color variable",
      choices = c(names(tb), "NONE"), selected = " "
    )
    updateSelectInput(session,
      inputId = "pop", label = "Popup Variables",
      choices = names(tb), selected = names(tb)
    )

    output$table <- renderDataTable({
      return(tb[, input$variables, drop = FALSE])
    })
  })

  output$download <- downloadHandler(
    filename = function() {
      if (input$download_type == "data.csv") {
        paste("data", "csv", sep = ".")
      } else if (input$download_type == "data.RData") {
        paste("data", "RData", sep = ".")
      } else if (input$download_type == "data.geojson") {
        paste("data", "geojson", sep = ".")
      } else if (input$download_type == "map&data.RData") {
        paste("dataMap", "Rdata", sep = ".")
      } else if (input$download_type == "map.pdf") {
        paste("map", "pdf", sep = ".")
      } else if (input$download_type == "map.jpeg") {
        paste("map", "jpeg", sep = ".")
      } else if (input$download_type == "map.png") {
        paste("map", "png", sep = ".")
      } else if (input$download_type == "map.html") {
        paste("map", "html", sep = ".")
      } else if (input$download_type == "map_static.pdf") {
        paste("map", "pdf", sep = ".")
      } else if (input$download_type == "map_static.jpeg") {
        paste("map", "jpeg", sep = ".")
      } else if (input$download_type == "map_static.png") {
        paste("map", "png", sep = ".")
      }
    },
    content = function(file) {
      dt <- data()
      df <- dt[, -ncol(dt), drop = TRUE]

      if (input$download_type == "data.csv") {
        write.csv(df, file, row.names = FALSE)
      } else if (input$download_type == "data.RData") {
        save(df, file = file)
      } else if (input$download_type == "data.geojson") {
        geojson_write(
          input = dt,
          geometry = "polygon", file = file,
          crs = "+init=epsg:4326"
        )
      } else if (input$download_type == "map&data.RData") {
        save(df, dt, file = file)
      } else {
        if (substr(input$download_type, 4, 4) == "_") {
          tmap_mode("plot")
        } else {
          tmap_mode("view")
        }
        map <- data()

        if (input$variable == " " | input$variable == "NONE") {
          ciao <- tm_shape(map) + tm_polygons(col = "grey80", popup.vars = input$pop) + tm_tiles(input$tiles)
        } else {
          ciao <- tm_shape(map) + tm_polygons(col = input$variable, style = input$legend, palette = input$palette, popup.vars = input$pop)
        }

        if (input$download_type == "map.pdf" | input$download_type == "map.jpeg" | input$download_type == "map.png" | input$download_type == "map.html") {
          mapshot(tmap_leaflet(ciao), file = file)
        } else if (input$download_type == "map_static.pdf" | input$download_type == "map_static.jpeg" | input$download_type == "map_static.png") {
          tmap_save(ciao, filename = file)
        }
      }
    }
  )
})
