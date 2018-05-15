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

## Of the four types of sources indicated by the type (point, nonpoint, onroad, nonroad) variable,
## which of these four sources have seen decreases in emissions from 1999–2008 for Baltimore City?
## Which have seen increases in emissions from 1999–2008?
## Use the ggplot2 plotting system to make a plot answer this question.

## select NEI data in Baltimore
baltimoreNEI <- NEI[NEI$fips == "24510", ]

## calculate total emissions for each year and type
aggregatedTotalByYearAndType <- aggregate(Emissions ~ type+year, baltimoreNEI, sum)

## plot total emissions
png("plot3.png")
g <- ggplot(aggregatedTotalByYearAndType, aes(year, Emissions, color = type)) +
  geom_line() + 
  labs(x = "Year", y = expression("Total PM"[2.5]*" Emissions")) + 
  labs(title = expression("Total PM"[2.5]*" Emissions in Baltimore, MD"))
print(g)
dev.off()

## As shown by the plot, PM2.5 emissions from non-road, nonpoint and on-road sources
## have decreased from 1999 to 2008 in Baltimore City. Emissions from point sources
## have increased.






