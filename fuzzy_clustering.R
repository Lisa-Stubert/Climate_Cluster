###############################################################################
## Fuzzy Clustering ###########################################################
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

fanny <- fanny(d, 15)  # Clusterberechnung

#end.time <- Sys.time()
#time.taken <- end.time - start.time
#time.taken

groups <- fanny$clustering  # Vektor mit Clustern anlegen
groups2 <- levels(factor(fanny$clustering)) # Vektor mit Cluster-Leveln anlegen


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

####### Membership-Wahrsscheinlichkeiten ausgeben lassen und visualisieren #

member = round(fanny$membership,2)  # Membership-Koeffizienten ausgeben lassen
member2 = as.numeric(levels(factor(round(fanny$membership,2)))) # Levels als Vektor abspeichern

for(i in seq_along(groups)){  # Anzeigen der Wahrscheinlichkeiten mit denen ein Punkt einem Cluster zuzuordnen ist  
  points(cmd[factor(groups) == groups2[i], ],
         cex = (member[i, groups[i]]*30),pch = 1)}

reshaped_data$member = NA  # leere Spalte anlegen die gleich gefüllt wird
for (i in seq_along(groups)){ # Schleife um den Membership-Koeffizienter des jeweiligen Clusters dem Beobachtungspunkt zuzuordnen
  reshaped_data$member[i] = member[i, groups[i]]}


test<-deldir(cmd$laenge,cmd$breite)  # Voronoi-Diagramme plotten
par(new=T)
plot(test, wlines="tess", wpoints="none", number=FALSE, add=TRUE, lty=1)


####### Shapefile erstellen und exportieren #################################

groupscoords = cbind(groups, reshaped_data) # Clusterzugehörigkeiten mit dem Datensatz verbinden
xy <- groupscoords[,c(3,2)]  # Spalten mit Koordinaten auswählen
spdf <- SpatialPointsDataFrame(coords = xy, data = groupscoords,
                               proj4string = CRS(
                                 "+proj=longlat +datum=WGS84 +ellps=WGS84 +towgs84=0,0,0"))
writeOGR(obj=spdf, dsn="shapefiles", layer="fuzzy", driver="ESRI Shapefile") # Shapefile schreiben


