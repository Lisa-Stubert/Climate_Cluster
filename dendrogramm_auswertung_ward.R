###############################################################################
## Dendrogramm-Auswertung beim Ward-Cluserverfahren ##########################
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

d <- dist(as.matrix(reshaped_data[,3:14]))   # Distance matrix erstellen
hc <- hclust(d, method="ward.D2")      # Ward-Clusterung


####### Distanzen und Dendrogramm anzeigen und auswerten ################

updunkel =rgb(0,38,115,255, maxColorValue=255) # dunkles Uni Potsdam blau
updunkel = updunkel[1]
sort(hc$height) # Distanzen aufsteigend sortieren
plot(hc,main="Dendrogramm",col = "darkblue", ylab = "Distanz", labels = FALSE)
plot(hc$height, main="Verschmelzungsdistanzen",col = "darkblue", ylab = "Distanz")
abline(206,0, lty = 2)
abline(v = 422,h =206, lty = 2)

groups <- cutree(hc, k=8) # Ergebnis auf 8 Cluster zuschneiden


####### erste Visualisierung ##############################################

groups2 <- levels(factor(groups)) # Vektor mit Cluster-Leveln anlegen

cmd = subset(reshaped_data, select=c(laenge,breite)) # Koordinaten selektieren
ordiplot(cmd, type = "n") # Koordinatensystem anlegen
cols <- c("steelblue", "darkred", "darkgreen",  # Clustern Farben zuweisen
          "pink", "red", "black",
          "yellow", "green"
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
writeOGR(obj=spdf, dsn="shapefiles", layer="ward_8_cluster", driver="ESRI Shapefile") # Shapefile schreiben
