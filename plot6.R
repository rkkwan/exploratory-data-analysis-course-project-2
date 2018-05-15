library(ggplot2)

## download data
if(!file.exists("./data")) {
  dir.create("./data")
}
if(!file.exists("./data/Electric Power Consumption.zip")) {
  zipURL <- "https://d396qusza40orc.cloudfront.net/exdata%2Fdata%2FNEI_data.zip"
  zipPath <- "./data/FNEI_data.zip"
  download.file(zipURL, zipPath, method = "curl")
  unzip(zipPath, exdir = "./data")
}

## read data
if(!exists("NEI")) {
  NEI <- readRDS("./data/summarySCC_PM25.rds")
}
if(!exists("SCC")) {
  SCC <- readRDS("./data/Source_Classification_Code.rds")
}

## Compare emissions from motor vehicle sources in Baltimore City with 
## emissions from motor vehicle sources in Los Angeles County, California (fips == "06037"). 
## Which city has seen greater changes over time in motor vehicle emissions?

## merge data sets 
if(!exists("NEISCC")){
  NEISCC <- merge(NEI, SCC, by = "SCC")
}

## get data in Baltimore City and Los Angeles County
subsetNEISCC <- NEISCC[NEISCC$fips == "24510" | NEISCC$fips == "06037", ]

## get motor vehicle-related records by Short Name containing "veh"
vehicle <- grepl("veh", subsetNEISCC$Short.Name, ignore.case = TRUE)
vehicleNEISCC <- subsetNEISCC[vehicle, ]

aggregatedTotalByYearAndFips <- aggregate(Emissions ~ fips+year, vehicleNEISCC, sum)
aggregatedTotalByYearAndFips$county[aggregatedTotalByYearAndFips$fips == "24510"] <- "Baltimore"
aggregatedTotalByYearAndFips$county[aggregatedTotalByYearAndFips$fips == "06037"] <- "Los Angeles"

## plot total emissions
png("plot6.png", width=550)
g <- ggplot(aggregatedTotalByYearAndFips, aes(factor(year), Emissions)) +
  facet_grid(. ~ county) + 
  geom_bar(stat = "Identity") + 
  labs(x = "Year", y = expression("Total PM"[2.5]*" Emissions")) + 
  labs(title = expression("Total PM"[2.5]*" Emissions from Motor Vehicle Sources in Baltimore vs Los Angeles"))
print(g)
dev.off()

## As shown by the plot, PM2.5 emissions from motor vehicle sources in 
## Baltimore have decreased by 258.5 tons (74.5%) while PM2.5 emissions from motor vehicle sources in
## Los Angeles have increased by 163.44 tons (4.1%) from 1999 to 2008.






