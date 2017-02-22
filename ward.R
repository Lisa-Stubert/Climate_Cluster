###############################################################################
## Hierarchisches Clustern mit Ward ###########################################
###############################################################################

library(cluster)
library(tripack)
library(deldir)
library(GISTools)
library(rgdal)
library(vegan)

source("reshaping.R")  # R-Code sourcen, der die Daten auf das Clustern vorbereitet
str(reshaped_data) # Überprüfen ob richtig eingelesen wurde

####### Clusterberechnung ################################################

#start.time <- Sys.time() # Laufzeitmessung beginnt hier

d <- dist(as.matrix(reshaped_data[,3:14]))   # Distance matrix erstellen
hc <- hclust(d, method="ward.D2")      # Ward-Clusterung

groups <- cutree(hc, k=15) # Ergebnis auf 15 Cluster zuschneiden

#end.time <- Sys.time() # Laufzeitmessung endet hier
#time.taken <- end.time - start.time
#time.taken


####### erste Visualisierung ##############################################

groups2 <- levels(factor(groups)) # Vektor mit Cluster-Leveln anlegen

cmd = subset(reshaped_data, select=c(laenge,breite)) # Koordinaten selektieren
ordiplot(cmd, type = "n") # Koordinatensystem anlegen
cols <- c("steelblue", "darkred", "darkgreen",  # Clustern Farben zuweisen
          "pink", "red", "black",
          "yellow", "green","blue",
          "orange","grey","black",
          "lightblue", "darkgrey", "lightgrey"
)
for(i in seq_along(groups2)){  # Punkte plotten
  points(cmd[factor(groups) == groups2[i], ], col = cols[i], pch = 16)
}

test<-deldir(cmd$laenge,cmd$breite)  # Voronoi-Diagramme plotten
par(new=T)
plot(test, wlines="tess", wpoints="none", number=FALSE, add=TRUE, lty=1)


####### Shapefile erstellen und exportieren #################################

groupscoords = cbind(groups, reshaped_data) # Clusterzugehörigkeiten mit dem Datensatz verbinden
xy <- groupscoords[,c(3,2)]  # Spalten mit Koordinaten auswählen
spdf <- SpatialPointsDataFrame(coords = xy, data = groupscoords,
                               proj4string = CRS(
                                 "+proj=longlat +datum=WGS84 +ellps=WGS84 +towgs84=0,0,0"))
writeOGR(obj=spdf, dsn="shapefiles", layer="ward", driver="ESRI Shapefile") # Shapefile schreiben
