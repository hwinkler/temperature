                       
LoadJoint <- function (site.path, data.path) {
# without fill=TRUE, we get errors on some rows. TODO investigate
                                      
    dataColNames <- c(
        "station_id",
        "series_number",
        "date",
        "temperature",
        "uncertainty",
        "observations",
        "time_of_observation" )

    dataColClasses <- c(
        "numeric",
        "numeric",
        "numeric",
        "numeric",
        "numeric",
        "numeric",
        "numeric")

    siteColNames <- c(
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
        "hash" )

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
        "character")


    site.detail<- read.table(
        site.path,
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
        breaks = seq(from=-70, to=50, by=2.5) ,
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

    
    years <- floor(dates)

    yearbreaks <- sort( as.integer(10*unique(floor(years/10))))

    decade <- cut(
        years,
        breaks= c(yearbreaks, 2020),
        labels= yearbreaks,
        ordered_result=TRUE)


    elevation <- cut(
        as.matrix(merged["elevation"]),
        breaks=c(-1000, 0, 1000, 2000, 3000, 4000, 5000, 6000),
        ordered_result=TRUE)

    # Joint
    table(temperature, latitude, decade, month, elevation)


    # good reference: http://www.datavis.ca/courses/VCD/vcd-tutorial.pdf
    
}

MakeTGivenRest <- function (joint) {
    ne <- length(joint[1,1,1,1,])
    nm <- length(joint[1,1,1,,1])
    nd <- length(joint[1,1,,1,1])
    nl <-length(joint[1,,1,1,1])
    nt <- length(joint[,1,1,1,1])
    t.ldme.vals = numeric(length = ne*nm*nd*nl * nt)
    for (e in 1:length(joint[1,1,1,1,])){ 
        for (m in 1:length(joint[1,1,1,,1])){
            for (d in 1:length(joint[1,1,,1,1])){
                for (l in 1:length(joint[1,,1,1,1])){
                    ## f <- joint[,l,d,m,e] + 1.0E-30
                    ## p <- f / (sum(f) + 1.0E-30)
                    ## t.ldme.vals <- c (t.ldme.vals, f / (sum(f) + 1.0E-30))
                    ## j = l + d * nl + m * nd * nl + e * nm * nd * nl;
                    idx <-  ( (d-1) + ( (m-1)   + (e-1) * nm ) * nd ) * nl  ;
                    f <- joint[,l,d,m,e] + 1.0E-150
                    p <- f / (sum(f) + 1.0E-150)
                    t.ldme.vals[(idx * nt +1 ):(idx * nt + nt )] <- f / (sum(f) + 1.0E-150)                    
                }
            }
        }
    }
    t.ldme.vals
}
