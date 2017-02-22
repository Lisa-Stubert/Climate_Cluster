###############################################################################
###### Reshaping der Daten#####################################################
# Dieses Skript dient der Datenaufbereitung. Es wird von den Skripten, die die
# Clusterverfahren durchführen automatisch aufgerufen #########################
###############################################################################

# setwd()

data = read.csv("sommer15.csv", header = TRUE, sep = ";")   # Einlesen der Klimadaten
koor = read.csv("koordinaten.csv", header = TRUE, sep = ";")  # Einlesen der Stationsstandorte
data = subset(data, select = -c(datum_ende,windstaerke,sonnenschein,
                                max_max_luft,min_min_luft,max_windspitze,
                                max_niederschlag))  # Überflüssige Variablen löschen
data[data == -999] = NA # Fehlende Werte auf NA setzen
reshaped_data <- reshape(data,direction='wide',idvar='id'
                         , timevar='datum_anfang') # Daten von Long- ins Wide-Format umwandeln
reshaped_data <- na.omit(reshaped_data) # NA's löschen
reshaped_data <- merge(koor,reshaped_data, by="id") # Daten Raumbezug hinzufügen
reshaped_data = subset(reshaped_data , select = -c(ort, hoehe, id))  # Überflüssige Variablen löschen
