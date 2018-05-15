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

## How have emissions from motor vehicle sources changed from 1999–2008 in Baltimore City?

## merge data sets 
if(!exists("NEISCC")){
  NEISCC <- merge(NEI, SCC, by = "SCC")
}

## get data in Baltimore
baltimoreNEISCC <- NEISCC[NEISCC$fips == "24510", ]

## get motor vehicle-related records by Short Name = "veh"
vehicle <- grepl("veh", baltimoreNEISCC$Short.Name, ignore.case = TRUE)
vehicleNEISCC <- baltimoreNEISCC[vehicle, ]

aggregatedTotalByYear <- aggregate(Emissions ~ year, vehicleNEISCC, sum)

## plot total emissions
png("plot5.png")
g <- ggplot(aggregatedTotalByYear, aes(factor(year), Emissions)) +
  geom_bar(stat = "Identity") + 
  labs(x = "Year", y = expression("Total PM"[2.5]*" Emissions")) + 
  labs(title = expression("Total PM"[2.5]*" Emissions from Motor Vehicle Sources in Baltimore"))
print(g)
dev.off()

## As shown by the plot, PM2.5 emissions from motor vehicle sources in Baltimore City
## have decreased by 74.5% from 1999 to 2008.






