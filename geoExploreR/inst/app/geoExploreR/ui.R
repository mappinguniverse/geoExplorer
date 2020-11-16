ui <- dashboardPage(skin = "blue",
  dashboardHeader(title = "geoExplorer", disable = FALSE),
  dashboardSidebar(
    sidebarMenu(
      tags$head(tags$style(".butt{background-color:white;} .butt{color: #555555;} .butt{font-style: italic;} .butt{width: 100%}")),

      fileInput("file", "Choose shape file", accept = c(".geojson",'.shp','.dbf','.sbn','.sbx','.shx', '.prj', ".cpg",'.topojson'), buttonLabel = "Browse", multiple = TRUE),
      textInput('url', "Insert URL", value = "", placeholder = "URL to shape file"),
      selectInput('variables', label = 'Variables', choices = " ", multiple = TRUE),
      selectInput('variable', label = 'Color variable', choices = " ", multiple = FALSE),
      selectInput('palette', label = 'Palette', choices = rownames(brewer.pal.info), selected = rownames(brewer.pal.info)[1],multiple = FALSE),
      selectInput('legend', label = 'Legend type', choices = c("cont","order", "log10",'cat','fixed','sd', "equal","pretty","quantile", "hclust", "bclust","fisher","jenks","dpih","headtails", "log10_pretty"), selected = 'pretty',multiple = FALSE),
      selectInput('tiles', label = 'Tiles', choices = unlist(leaflet::providers), selected = 'OpenStreetMap',multiple = FALSE),
      selectInput('pop', label = 'Popup Variables', choices = " ", multiple = TRUE),

      selectInput('download_type', label = 'Download type', choices = c('map.html', "map.png", "map.pdf", "map.jpeg", "data.geojson","data.RData","data.csv", "map&data.RData"), multiple = FALSE),
      downloadButton('download', label = "Download", class = "butt")

    )
  ),
  dashboardBody(
    tags$head(
      tags$style(HTML("

          .main-sidebar {
            background-color: #D3D3D3 !important;
          }
          .content-wrapper {
            background-color: white !important;
          }
          .skin-blue .main-header .navbar{
            background-color:#FFD300;
          }
          .skin-blue .main-header .logo:hover{
            background-color:#FFD300;
          }
                 .skin-blue .main-header .logo{
            background-color:#FFD300;
            color: black;
            font-size: 50px:
                 }

                 .skin-blue .main-header .navbar .sidebar-toggle:hover{
                 background-color:#D3D3D3
                 }


        "))
    ),
    fluidRow(
      box(title = "Map", leafletOutput('map'),width = 12, collapsible = TRUE)),
    fluidRow(
      box(title = "Data table", dataTableOutput('table'), width = 12, collapsible = TRUE),
    )

)
)
