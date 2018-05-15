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

## Have total emissions from PM2.5 decreased in the Baltimore City, Maryland 
## (fips == "24510") from 1999 to 2008? 
## Use the base plotting system to make a plot answering this question.

## select NEI data in Baltimore
baltimoreNEI <- NEI[NEI$fips == "24510", ]

## calculate total emissions for each year
aggregatedTotalByYear <- aggregate(Emissions ~ year, baltimoreNEI, sum)

## plot total emissions
png("plot2.png")
barplot(height = aggregatedTotalByYear$Emissions, 
        names.arg = aggregatedTotalByYear$year,
        xlab = "Year",
        ylab = expression("Total PM"[2.5]*" Emission"),
        main = expression("Total PM"[2.5]*" Emissions by Year in Baltimore, MD"))
dev.off()

## As shown by the bar plot, total PM2.5 emissions in Baltimore, MD have decreased
## from 1999 to 2008.






