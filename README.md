# geoExplorer: Exploring geospatial files



Shiny apps for exploring, modifying and exporting data, geospatial coordinates and maps.

-------------------
[Run shapeExploreR](https://mybinder.org/v2/gh/dataallaround/geoExplorer/main?urlpath=shiny/shapeExploreR/)
-------------------

### Installation R

A R package is available to use the app on your local machine:

```R
library(remotes)
remotes::install_github("dataallaround/geoExplorer@main",subdir = "geoExploreR")
```



To run the shapeExploreR app, on R console

```R
geoExplorer::shapeExploreR()
```





### Run server Binder

[mybinder.org](https://mybinder.org) provide server to run geoExplorer apps.

- shapeExploreR [![Binder](https://mybinder.org/badge_logo.svg)](https://mybinder.org/v2/gh/dataallaround/geoExplorer/main?urlpath=shiny/shapeExploreR/)



### Docker

Docker are available on https://hub.docker.com/repository/docker/dataallaround/geoexplorer.

```bash
docker push dataallaround/geoexplorer
```

