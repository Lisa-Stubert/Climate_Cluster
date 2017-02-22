###############################################################################
## Clustern mit dem EM-Algorithmus ###########################################
###############################################################################

library("vegan")
library(tripack)
library(deldir)
library(mclust)
library(GISTools)
library(rgdal)


source("reshaping.R")  # R-Code sourcen, der die Daten auf das Clustern vorbereitet
str(reshaped_data) # Überprüfen ob richtig eingelesen wurde

####### Clusterberechnung ################################################

#start.time <- Sys.time() # Laufzeitmessung beginnt hier

# Variante 1 : Ohne Koordinaten geclustert
mc <- Mclust(reshaped_data[,3:14], 15)  # Berechnung der Cluster

#end.time <- Sys.time() # Laufzeitmessung endet hier
#time.taken <- end.time - start.time
#time.taken

groups <- mc$classification # Cluster als Vektor abspeichern
groups2 <- levels(factor(mc$classification)) # Cluster-Level als Vektor abspeichern

####### erste Visualisierung ##############################################

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
writeOGR(obj=spdf, dsn="shapefiles", layer="emcluster", driver="ESRI Shapefile") # Shapefile schreiben




# Variante 2: Mit Koordinaten geclustert --> besseres Ergebnis

mc <- Mclust(reshaped_data, 15)
groups <- mc$classification
groups2 <- levels(factor(mc$classification))
cmd = subset(reshaped_data, select=c(laenge,breite))

ordiplot(cmd, type = "n")
cols <- c("steelblue", "darkred", "darkgreen",
          "pink", "red", "black",
          "yellow", "green","blue",
          "orange","grey","black",
          "lightblue"
)
for(i in seq_along(groups)){
  points(cmd[factor(groups) == groups2[i], ], col = cols[i], pch = 16)
}


