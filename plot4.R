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

## Across the United States, how have emissions from 
## coal combustion-related sources changed from 1999–2008?

## merge data sets 
if(!exists("NEISCC")){
  NEISCC <- merge(NEI, SCC, by = "SCC")
}

## get coal-related records by Short Name containing "coal"
coal <- grepl("coal", NEISCC$Short.Name, ignore.case = TRUE)
coalNEISCC <- NEISCC[coal, ]

aggregatedTotalByYear <- aggregate(Emissions ~ year, coalNEISCC, sum)

## plot total emissions
png("plot4.png")
g <- ggplot(aggregatedTotalByYear, aes(factor(year), Emissions)) +
  geom_bar(stat = "Identity") + 
  labs(x = "Year", y = expression("Total PM"[2.5]*" Emissions")) + 
  labs(title = expression("Total PM"[2.5]*" Emissions from Coal-related Sources"))
print(g)
dev.off()

## As shown by the plot, PM2.5 emissions from coal combustion-related sources
## have decreased by 40.6% from 1999 to 2008.






