
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
                                        #source ("temperature/r/load-site-detail.R")
                                        #site.detail<- read.table("temperature/rdata/site_detail.txt", sep="\t", fill=TRUE, na.strings=c("-99","-9999"), colClasses=siteColClasses, col.names = siteColNames, quote="")


                                        #  latitudes.factor = factor(merged["latitude"], levels=c(-90,-60,-30,0,30,60,90), ordered=TRUE)
   ##        > latitude = as.matrix(merged["latitude"])
## > class(latitude)
## [1] "matrix"
## > latitudes.factor = cut(latitude, breaks=c(-60,-30,0,30,60), ordered_result=TRUE)

## > dates <- as.matrix(merged["date"])
## > fracdates = dates %% 1
## > summary(fracdates)
##       date       
##  Min.   :0.0420  
##  1st Qu.:0.2920  
##  Median :0.4580  
##  Mean   :0.4996  
##  3rd Qu.:0.7080  
##  Max.   :0.9580  
## > unique(fracdates)
##        date
##  [1,] 0.292
##  [2,] 0.375
##  [3,] 0.458
##  [4,] 0.542
##  [5,] 0.625
##  [6,] 0.792
##  [7,] 0.875
##  [8,] 0.958
##  [9,] 0.042
## [10,] 0.125
## [11,] 0.208
## [12,] 0.708
## > help("factor")
## > months.factor <- (unique(fracdates), ordered=TRUE, c("Jan","Feb","Mar","Apr","May","Jun","Jul","Aug","Sep","Oct","Nov","Dec") )
## Error: unexpected ',' in "months.factor <- (unique(fracdates),"
## > months.factor <- (unique(fracdates), ordered=TRUE, labels=c("Jan","Feb","Mar","Apr","May","Jun","Jul","Aug","Sep","Oct","Nov","Dec") )
## Error: unexpected ',' in "months.factor <- (unique(fracdates),"
## > months.factor <- factor(unique(fracdates), ordered=TRUE, labels=c("Jan","Feb","Mar","Apr","May","Jun","Jul","Aug","Sep","Oct","Nov","Dec") )
## > sort(unique(fracdates))
##  [1] 0.042 0.125 0.208 0.292 0.375 0.458 0.542 0.625 0.708 0.792 0.875 0.958
## > months.factor <- factor(sort(unique(fracdates)), ordered=TRUE, labels=c("Jan","Feb","Mar","Apr","May","Jun","Jul","Aug","Sep","Oct","Nov","Dec") )
years.factor <- cut(years, breaks= 10 * unique(floor(years/10), ordered_result=TRUE))
months.factor <- factor(fracdates, ordered=TRUE, labels=c("Jan","Feb","Mar","Apr","May","Jun","Jul","Aug","Sep","Oct","Nov","Dec") )
 > yearbreaks =  sort( as.integer(10*unique(floor(years/10))))
> years.factor <- cut(years, breaks= yearbreaks, labels= yearbreaks, ordered_result=TRUE)
Error in cut.default(years, breaks = yearbreaks, labels = yearbreaks,  : 
  lengths of 'breaks' and 'labels' differ
> years.factor <- cut(years, breaks= yearbreaks, labels= c(yearbreaks, 2020), ordered_result=TRUE)
Error in cut.default(years, breaks = yearbreaks, labels = c(yearbreaks,  : 
  lengths of 'breaks' and 'labels' differ
> years.factor <- cut(years, breaks= c(yearbreaks, 2020), labels= yearbreaks, ordered_result=TRUE)                   

