# Klima_Cluster

Die hier bereitgestellten R-Skripte dienen der Clusteranalyse von Klimadaten und dem Vergleich verschiedener Clusterverfahren.
Ausgelegt sind sie für die Verwendung mit frei verfügbaren Daten des Deutschen Wetterdienstes, die für jede Stunde des Jahres Werte von Klimastationen in ganz Deutschland enthalten. 
Jedes Clusterverfahren wird mittels eines eigenen Skripts durchgeführt. Das Einladen der Daten und die Datenvorverarbeitung geschieht im "reshaping.R"-Skript. Dieses wird automatisch von den anderen Skripten aufgerufen.
Es wird ebenfalls ein Beispieldatensatz für den Sommer 2015 bereitgestellt, sowie eine SQL-Datei mit welcher der Beispieldatensatz aus den Rohdaten des Deutschen Wetterdienstes extrahiert wurde.
