shapeExploreR <- function() {

  appDir <- system.file("app","geoExploreR", package = "geoExploreR")
  if (appDir == "")
    {
    stop("Could not find directory. Try re-installing `geoExploreR`.", call. = FALSE)
    }

  runApp(appDir, display.mode = "normal")
}
