# Install R version 3.6.3, latest

FROM rocker/shiny:3.6.3
#MANTAINER "Alessio Serafini" srf.alessio@gmail.com

# Install Ubuntu packages

RUN apt-get update && apt-get install -y \
	sudo \
	pandoc \
	pandoc-citeproc \
	gdebi-core \
	libcurl4-gnutls-dev \
	libcairo2-dev \
	libxt-dev \
	xtail \
	wget\
	libv8-dev \
	libssl-dev \
	libgdal-dev \
	libgeos-dev \
	libproj-dev \
	libxml2-dev \
	libxml2 \
	libv8-dev \
	libnode-dev \
	libudunits2-dev \
	git \
	libfontconfig1-dev \
	libudunits2-dev \
	libcairo2-dev \
	gdal-bin \
	proj-bin \
	libgdal-dev \
	libproj-dev \
	nginx \
	libudunits2-dev \
	libcairo2-dev \
	libnetcdf-dev \
	lbzip2 \
	libfftw3-dev \
	libgsl0-dev \
	libgl1-mesa-dev \
	libglu1-mesa-dev \
	libhdf4-alt-dev \
	libhdf5-dev \
	libjq-dev \
	libpq-dev \
	libprotobuf-dev \
	libnetcdf-dev \
	libsqlite3-dev \
	libssl-dev \
	libudunits2-dev \
	netcdf-bin \
	postgis \
	protobuf-compiler \
	sqlite3 \
	tk-dev \
	unixodbc-dev \
	libfftw3-dev \
	libgsl0-dev \
	libgl1-mesa-dev \
	libglu1-mesa-dev \
	libhdf4-alt-dev \
	libhdf5-dev \
	libnetcdf-dev \
	libsqlite3-dev \
	netcdf-bin \
	postgresql
	
	
# Install R packages

RUN install2.r --error \
	digest \
	htmltools \
	httpuv \
	httr \
	rmarkdown \
	shiny \
	leaflet\
	leafpop \
	shinydashboard \
	sortable\
	shinyjs \
	DT \
	shinythemes\
	tmap\
	readxl\
	devtools\
	remotes \
	tmaptools\
	leafem\
	RColorBrewer \
	maptools \
	mapview \
	raster \
    rgdal \
	rgeos \
	proj4 \
    sf \
	geojsonio
	
		
#EXPOSE 3838



# Copy configuration files into the Docker image
COPY shiny-server.conf  /etc/shiny-server/shiny-server.conf
COPY /shapeExploreR /srv/shiny-server/


# Make the ShinyApp available at port 3838
EXPOSE 3838

# Copy further configuration files into the Docker image
COPY shiny-server.sh /usr/bin/shiny-server.sh

RUN ["chmod", "+x", "/usr/bin/shiny-server.sh"]