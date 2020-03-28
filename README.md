# Climate_Cluster

The R-scripts provided here are ment for cluster analysis of climate data to identify climate zones and the comparison of different cluster methods.
They are designed for use with open data from the German Weather Service, which contain values from climate stations throughout Germany for every hour of the year. Each cluster procedure is carried out by a separate script. The loading of the data and the data preprocessing is done in the "reshaping.R" script and then called by the specific scripts for clustering.
An example data set for the summer of 2015 is also provided, as well as an SQL file with which the example data set was extracted from the raw data of the German Weather Service.
