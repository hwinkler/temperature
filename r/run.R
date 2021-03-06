## see http://cran.r-project.org/web/packages/gRain/vignettes/gRain-intro.pdf

library ('gRain')
joint <- LoadJoint ("/Users/hughw/temperature/rdata/site_detail.txt", "/Users/hughw/temperature/rdata/data.txt")
latitude <- cptable( ~lat,  values = margin.table(joint, 2),  levels = names(margin.table(joint, 2) ))
longitude <- cptable( ~lon,  values = margin.table(joint, 3),  levels = names(margin.table(joint, 3) ))
decade <- cptable( ~d,  values = margin.table(joint, 4),  levels = names(margin.table(joint, 4) ))
month <- cptable( ~m,  values = margin.table(joint, 5),  levels = names(margin.table(joint, 5) ))
elevation <- cptable( ~e,  values = margin.table(joint, 6),  levels = names(margin.table(joint, 6)))

temperature.lldme.vals <- MakeTGivenRest(joint )
temperature.lldme <- cptable(~t|lat:lon:d:m:e, values=temperature.lldme.vals + 1.0E-150, levels=names(joint[,1,1,1,1,1]))
                     
plist <- compileCPT(list(latitude, longitude, decade, month, elevation, temperature.lldme))
net1 <- grain(plist)

## Compare these two joint prob tables; they should be equal
#pjoint <- prop.table(joint)
#pjoint2 <- querygrain(net1,nodes=c("t","lat","lon","d","m","e"), type="joint")

## Global surface temp by decade
gmst.d <- querygrain (net1, c( "t", "d"), type="conditional")

image(seq(1:120) * 1 - 75, seq(1: ((2020 -1900)/10)) * 10 + 1900 - 10, gmst.d, col=heat.colors(64), xlab='Temperature' , ylab = 'Year')

