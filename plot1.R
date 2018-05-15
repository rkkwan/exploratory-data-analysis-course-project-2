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

## Have total emissions from PM2.5 decreased in the United States from 1999 to 2008? 
## Using the base plotting system, make a plot showing the total PM2.5 emission from 
## all sources for each of the years 1999, 2002, 2005, and 2008.

## calculate total emissions for each year
aggregatedTotalByYear <- aggregate(Emissions ~ year, data = NEI, sum)

## plot total emissions
png("plot1.png")
barplot(height = aggregatedTotalByYear$Emissions, 
        names.arg = aggregatedTotalByYear$year,
        xlab = "Year",
        ylab = expression("Total PM"[2.5]*" Emission"),
        main = expression("Total PM"[2.5]*" Emissions by Year"))
dev.off()

## As shown by the decreasing trend in the bar plot, total emissions from PM2.5 have
## decreased in the United States from 1999 to 2008. 



