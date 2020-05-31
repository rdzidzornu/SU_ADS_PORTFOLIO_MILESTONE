#
# IST719 - Data Visualization
# Purpose:: Homework4
# Author :: Richard Dzidzornu 
#


library(readr)
library(ggplot2)
library(knitr)
library(tidyverse)
library(caret)
library(leaps)
library(car)
library(mice)
library(scales)
library(RColorBrewer)
library(plotly)
library(nortest)
library(lmtest)
#library(rsconnect)

filename <- file.choose()
filename



cali_Data <- read.csv("C:\\Users\\rdzid\\Documents\\SU Courses Folder\\IST 719 Data Visualization\\Datasets\\california_housing.csv", 
                      header = TRUE,
                      sep = ",",
                      stringsAsFactors = FALSE)

View(cali_Data)
#fix(cali_Data)

dim(cali_Data)
#[1] 20640    10

str(cali_Data)


colnames(cali_Data)
#[1] "longitude"          "latitude"           "housing_median_age" "total_rooms"        "total_bedrooms"    
#[6] "population"         "households"         "median_income"      "median_house_value" "ocean_proximity"

#par(mfrow = c(2, 2))
#plot 01
boxplot(cali_Data$total_bedrooms, 
        horizontal = TRUE,
        ylim = c(100, 7000),
        col = c("magenta"),
        xlab = "Total Bedrooms",
        main = "Distribution of total bedrooms by locality in California ",
        notch = TRUE, 
        varwidth = TRUE,
        cex.main = 0.90, font.main= 3, col.main= "#15738E", col.xlab = "#15738E")
mtext(text = "(total bedrooms by locality)", side = 3, line = 0, outer = FALSE, at = NA,
      cex = 0.75, col = "#15AC36", font = 3)
mtext(text = "Source: https://www.kaggle.com", side = 1, line = 4, outer = FALSE, at = NA, adj = 1,
      cex =0.50, col = "#EC6370", font = 1)

#plot 02
#par(mfrow = c(2, 2)) 
#  Distribution by density
data_density <- density(cali_Data$median_income)
plot(data_density, 
     main =  "Density Distribution of median income by locality California",
     xlab = "Median_Income of California",
     cex.main = 0.90, font.main= 3, col.main= "#15738E", col.xlab = "#15738E")
polygon(data_density, col="#EC6370", border="black")
mtext(text = "(Median Income by locality)", side = 3, line = 0, outer = FALSE, at = NA,
      cex = 0.75, col = "#15AC36", font = 3)
mtext(text = "Source: https://www.kaggle.com", side = 1, line = 4, outer = FALSE, at = NA, adj = 1,
      cex =0.50, col = "#EC6370", font = 1)

#plot 03
#, cali_Data$households)
hist(cali_Data$housing_median_age,
     borders = NA,
     col = "#5298AC",
     main = "California Median Housing age by locality",
     #sub = "(Population by household)",
     xlab = "Median Housing age",
     ylab = "Frequency",
     cex.main = 0.90,   font.main= 3, col.main= "#15738E")
mtext(text = "(Median Housing age by locality)" , side = 3, line = 0, outer = FALSE, at = NA,
      adj = NA, padj = NA, cex = 0.75, col = "#15AC36", font = 3)
mtext(text = "Source: https://www.kaggle.com", side = 1, line = 4, outer = FALSE, at = NA, adj = 1,
      cex =0.50, col = "#EC6370", font = 1)


####################
#
# Multi-Dimension Plot 
#
######################
dev.off
par()
plot(cali_Data$population, cali_Data$households,
     type = "p",
     #pch = 19,
     borders = NA,
     col = c("skyblue3"),
     main = "California Population distribution by Households",
     #sub = "(Population by household)",
     xlab = "Population",
     ylab = "Households",
     cex.main = 1.00,   font.main= 3, col.main= "#15AC36")
mtext(text = "(Population by household)" , side = 3, line = 0, outer = FALSE, at = NA,
      adj = NA, padj = NA, cex = 0.90, col = "dark green", font = 3)
mtext(text = "Source: https://www.kaggle.com", side = 1, line = 4, outer = FALSE, at = NA, adj = 1,
      cex =0.75, col = "#EC6370", font = 1)

#################################################################################################
filename <- file.choose()
filename



housing_data <- read.csv("C:\\Users\\rdzid\\Documents\\SU Courses Folder\\IST 719 Data Visualization\\WorkInProgress Report\\housing.csv", 
                      header = TRUE,
                      sep = ",",
                      stringsAsFactors = FALSE)


sum(is.na(housing_data))

housing_data$total_bedrooms[is.na(housing_data$total_bedrooms)]=0

max(housing_data$median_house_value)
  

# Multi dimension plots
#plot01
plot_map = ggplot(housing_data, 
                  aes(x = latitude, y = longitude, color = median_house_value, 
                      hma = housing_median_age, tr = total_rooms, tb = total_bedrooms,
                      hh = households, mi = median_income)) +
  geom_point(aes(size = population), alpha = 0.75) +
  ylab("Longitude") +
  xlab("Latitude") +
  ggtitle("Data Map - Longtitude vs Latitude and Associated Variables") +
  theme(plot.title = element_text(hjust = 0.5)) +
  scale_color_distiller(palette = "Paired", labels = comma) +
  labs(color = "Median House Value (in $USD)", size = "Population")
plot_map


plot_map = ggplot(housing_data, 
                  aes(x = latitude, y = longitude, color = median_house_value)) +
  geom_point(aes(size = population), alpha = 0.75) +
  ylab("Longitude") +
  xlab("Latitude") +
  ggtitle("Data Map - Longtitude vs Latitude and Associated Variables") +
  theme(plot.title = element_text(hjust = 0.5)) +
  scale_color_distiller(palette = "Paired", labels = comma) +
  labs(color = "Median House Value (in $USD)", size = "Population")
plot_map


plot_map = ggplot(housing_data, 
                  aes(x = latitude, y = longitude, color = median_house_value)) +
  geom_point(aes(size = population), alpha = 0.75) +
  ylab("Longitude") +
  xlab("Latitude") +
  ggtitle("Data Map - Longtitude vs Latitude and Associated Variables") +
  theme(plot.title = element_text(hjust = 0.5)) +
  scale_color_distiller(palette = "Paired", labels = comma) +
  labs(color = "Median House Value (in $USD)", size = "Population")
plot_map
#############################################################################

#plot(housing_data$population, housing_data$median_income)

#plot(housing_data$median_house_value, housing_data$median_income,
#     type = "p", pch = 19)
######################################################################################
#Plot 2
col_df = if (housing_data$ocean_proximity == "<1H OCEAN") { 
  1
} else if (housing_data$ocean_proximity == "NEAR BAY") {
  2
} else if  (housing_data$ocean_proximity == "INLAND") {
  3
} else if  (housing_data$ocean_proximity == "NEAR OCEAN") {
  4
} else {
  5
}

Ocean.Proximity.Color <- ifelse(housing_data$ocean_proximity == "<1H OCEAN", "Orange2",
                          ifelse(housing_data$ocean_proximity == "INLAND", "darkred2",
                                 ifelse(housing_data$ocean_proximity == "ISLAND", "Yellow",
                                        ifelse(housing_data$ocean_proximity == "NEAR BAY", "Green2", "skyblue2"))))

Ocean.Proximity <- ifelse(housing_data$ocean_proximity == "<1H OCEAN", 1,
                          ifelse(housing_data$ocean_proximity == "INLAND", 2,
                                 ifelse(housing_data$ocean_proximity == "ISLAND", 3,
                                        ifelse(housing_data$ocean_proximity == "NEAR BAY", 4, 5))))

x <- ggplot(housing_data) + 
  aes(x = median_house_value, y = median_income, col = Ocean.Proximity) + 
  geom_point(size = 3, alpha = .5) +
  theme(axis.text.x = element_text(angle = 90))
x + scale_colour_distiller(palette = "YIGnBu", aesthetics = "colour")


x <- ggplot(housing_data) + 
  aes(x = median_house_value, y = median_income, col = Ocean.Proximity) + 
  geom_point(size = 2, alpha = .5) +
  theme(axis.text.x = element_text(angle = 90))
x + scale_colour_distiller(palette = "Set3", aesthetics = "colour")


x <- ggplot(housing_data) + 
  aes(x = median_house_value, y = median_income, col = Ocean.Proximity) + 
  geom_point(size = 3, alpha = .5) +
  theme(axis.text.x = element_text(angle = 90))
x + scale_colour_distiller(palette = "Dark2", aesthetics = "colour")

x <- ggplot(housing_data) + 
  aes(x = median_house_value, y = median_income, col = Ocean.Proximity) + 
  geom_point(size = 3, alpha = .5) +
  theme(axis.text.x = element_text(angle = 90))
x + scale_colour_distiller(palette = "Pastel2", aesthetics = "colour")





# Single dimention plots

###plot01
hist(housing_data$median_house_value, 
     breaks = 25, main = "median_house_value", 
     border="white", col="orange2",
     xlim = c(0, 500000), 
     ylim = c(0, 2000))
abline(v = mean(housing_data$median_house_value), col = "red")
axis(4, labels=FALSE, col = "lightgrey", lty=2, tck=1)

###plot02
hist(housing_data$housing_median_age,
     breaks = 20, 
     main = "median House Age",
     border="white", col="blue4",
     ylim = c(0, 2000))
abline(v = mean(housing_data$housing_median_age), col = "green")
axis(4, labels=FALSE, col = "lightgrey", lty=2, tck=1)

##plot03
##Oceanproximity
barchart(housing_data$ocean_proximity,
         beside = TRUE,
         horizontal = FALSE,
         borders = NA,
         col = c("orange", "red", "yellow", "green", "skyblue2"),
         main = "Ocean proximity")



###################################################
library(raster)
library(ggplot2)

states    <- c('California')
us <- getData("GADM",country="USA",level=1)
us.states <- us[us$NAME_1 %in% states,]
us.bbox <- bbox(us.states)
xlim <- c(min(us.bbox[1,1]),max(us.bbox[1,2]))
ylim <- c(min(us.bbox[2,1]),max(us.bbox[2,2]))


# PLOTTING LOCATION POINTS ON THE MAP
plot(us.states, xlim=xlim, ylim=ylim)
points(housing_data$longitude[housing_data$ocean_proximity=="<1H OCEAN"], 
       housing_data$latitude[housing_data$ocean_proximity=="<1H OCEAN"], col = "orange2", cex = .5)

points(housing_data$longitude[housing_data$ocean_proximity=="NEAR BAY"], 
       housing_data$latitude[housing_data$ocean_proximity=="NEAR BAY"], col = "green3", cex = .5)

points(housing_data$longitude[housing_data$ocean_proximity=="INLAND"], 
       housing_data$latitude[housing_data$ocean_proximity=="INLAND"], col = "darkred", cex = .5)

points(housing_data$longitude[housing_data$ocean_proximity=="ISLAND"], 
       housing_data$latitude[housing_data$ocean_proximity=="ISLAND"], col = "yellow", cex = .5)

points(housing_data$longitude[housing_data$ocean_proximity=="NEAR OCEAN"], 
       housing_data$latitude[housing_data$ocean_proximity=="NEAR OCEAN"], col = "skyblue3", cex = .5)

#################################################################
states    <- c('California')
us <- getData("GADM",country="USA",level=1)
us.states <- us[us$NAME_1 %in% states,]
us.bbox <- bbox(us.states)
xlim <- c(min(us.bbox[1,1]),max(us.bbox[1,2]))
ylim <- c(min(us.bbox[2,1]),max(us.bbox[2,2]))


# PLOTTING LOCATION POINTS ON THE MAP
plot(us.states, xlim=xlim, ylim=ylim)
points(housing_data$longitude[housing_data$ocean_proximity=="<1H OCEAN"], 
       housing_data$latitude[housing_data$ocean_proximity=="<1H OCEAN"], pch= 16, col = "orange3", cex = 1)

points(housing_data$longitude[housing_data$ocean_proximity=="NEAR BAY"], 
       housing_data$latitude[housing_data$ocean_proximity=="NEAR BAY"], pch= 16, col = "green4", cex = 1)

points(housing_data$longitude[housing_data$ocean_proximity=="INLAND"], 
       housing_data$latitude[housing_data$ocean_proximity=="INLAND"], pch= 16, col = "darkred", cex = 1)

points(housing_data$longitude[housing_data$ocean_proximity=="ISLAND"], 
       housing_data$latitude[housing_data$ocean_proximity=="ISLAND"], pch= 16, col = "yellow", cex = 1)

points(housing_data$longitude[housing_data$ocean_proximity=="NEAR OCEAN"], 
       housing_data$latitude[housing_data$ocean_proximity=="NEAR OCEAN"], pch= 16, col = "skyblue3", cex = 1)



##plot04
data_density <- density(housing_data$median_income)
plot(data_density, 
     main =  "Density Distribution of median income by locality California",
     xlab = "Median_Income of California")
polygon(data_density, col="darkred", border="black")
axis(4, labels=FALSE, col = "lightgrey", lty=2, tck=1)
abline(v = median(housing_data$median_income), col = "yellow")


hist(housing_data$median_income,
         breaks = 25,
     border="white", col="darkred")
abline(v = mean(housing_data$median_income), col = "green")


#ggplot(housing_data, 
#       aes(x = factor(ocean_proximity))) +
#  geom_bar(stat = "count", color = "black", fill = c("red", "blue", "green", "orange", "yellow"))

plot(housing_data$ocean_proximity,
       size = 4,

         col = c("red", "yellow", "blue", "green", "orange"),
         main = "Ocean proximity")


summary(housing_data)


##############################
housing_data$median_income<-housing_data$median_income*10000

income_level <- c(0,10000,20000,30000,40000,50000,60000,70000,80000,90000,
                  100000,110000,120000,130000,140000,150000,Inf)


headers_income <- c("0-10k", "10k-20k", "20k-30k","30k-40k", "40k-50k",
                    "50k-60k","60k-70k","70k-80k","80k-90k","90k-100k" 
                    ,"100k-110k","110k-120k","120k-130k","130k-140k",
                    "140k-150k"," >150k")

housing_data <- transform(housing_data, income_cut = cut(median_income, income_level, labels = headers_income))

View(housing_data)
################################################
max(housing_data$median_house_value)
#500001
min(housing_data$median_house_value)
#14999
value_level = c(0, 50000, 100000, 150000, 200000, 250000, 300000, 350000, 400000, 450000, 500000, 550000)

headers_value = c("0-50k", "50k-100k", "100k-150k", "150k-200k", "200k-250k", "250k-300k", 
                 "300k-350k", "350k-400k", "400k-450k", "450k-500k", "500k-550k")

housing_data <- transform(housing_data, value_cut = cut(median_house_value, value_level, labels = headers_value))



##########################################
stack_plot <- ggplot(data = housing_data) + 
  geom_bar(map = aes(x = housing_data$value_cut, 
                     fill = ocean_proximity)) +
theme(axis.text.x = element_text(angle = 90))
stack_plot

stack_plot + labs(x="price range",y="count of households",title="Median price of households") + 
  labs(colour = "ocean proximity")

stack_plot


length(housing_data$income_cut)
summary(housing_data)

#############################################################

rCols <- heat.colors(12,0.25)
brCols <- rCols[housing_data$value_cut]
plot(us.states, xlim=xlim, ylim=ylim,main="median price by ocean proximity")
points(housing_data$longitude,housing_data$latitude,col=brCols,pch = 18, cex = 0.4)
legend(2.8,-1,legend = housing_data$value_cut, fill = Ocean.Proximity)




