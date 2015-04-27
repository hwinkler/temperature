load.temperatures <- function (site.details.path, data.path) {
    dataColNames = c(
        "station_id",
        "series_number",
        "date",
        "temperature",
        "uncertainty",
        "observations",
        "time_of_observation"
    );

    dataColClasses <- c(
        "numeric",
        "numeric",
        "numeric",
        "numeric",
        "numeric",
        "numeric",
        "numeric");

    siteColNames = c(
        "station_id",
        "station_name",
        "latitude",
        "longitude",
        "elevation",
        "lat_uncertainty",
        "long_uncertainty",
        "elev_uncertainty",
        "country",
        "state_province_code",
        "county",
        "time_zone",
        "wmo_id",
        "coop_id",
        "wban_id",
        "icao_id",
        "num_relocations",
        "num_suggested_relocations",
        "num_sources",
        "hash"
    );

    siteColClasses <- c(
        "numeric",
        "character",
        "numeric",
        "numeric",
        "numeric",
        "numeric",
        "numeric",
        "numeric",
        "character", 
        "character", 
        "character",
        "numeric",
        "numeric", 
        "numeric",
        "numeric",
        "character",
        "numeric",
        "numeric",
        "numeric",
        "character");

    #without fill=TRUE, we get errors on some rows. TODO investigate
    site.detail<- read.table(
        site.detail.path,
        sep = "\t",
        comment.char = "%",
        fill=TRUE,
        na.strings = c("-99","-9999"),
        colClasses = siteColClasses,
        col.names = siteColNames,
        quote = "")

    data <- read.table(
        data.path,
        sep = "\t",
        comment.char = "%",
        fill = TRUE,
        na.strings = c("-99","-9999"),
        colClasses = dataColClasses,
        col.names = dataColNames,
        quote = "")

    merged <- merge(site.detail, data)

    
    temperature <- cut(
        as.matrix(merged["temperature"]),
        breaks = seq(from=-70, to=50, by=10) ,
        ordered_result=TRUE)
    
    latitude <- cut(
        as.matrix(merged["latitude"]),
        breaks=c(-90,-60,-30,0,30,60,90),
        ordered_result=TRUE)

    dates <- as.matrix(merged["date"])
    fracdates = dates %% 1

    month <- factor(
        fracdates,
        ordered=TRUE,
        labels=c("Jan","Feb","Mar","Apr","May","Jun","Jul","Aug","Sep","Oct","Nov","Dec") )

    yearbreaks =  c(
        sort( as.integer(10*unique(floor(years/10)))),
        2020)
    
    decade <- cut(
        years,
        breaks= c(yearbreaks, 2020),
        labels= yearbreaks,
        ordered_result=TRUE)


    elevations.factor <- cut(
        as.matrix(merged["elevation"]),
        breaks=c(0, 1000, 2000, 3000, 4000, 5000, 6000),
        ordered_result=TRUE)

    return  table(
        temperature, latitude, decade, month, elevation)
}
