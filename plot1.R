## Retrieve file
download.file("https://d396qusza40orc.cloudfront.net/exdata%2Fdata%2Fhousehold_power_consumption.zip", "power_consumption.zip")

## Unzip the file
unzip("power_consumption.zip")

## Necessary libraries
library(sqldf)
library(data.table)

## Read in all data
powerAll <- fread("household_power_consumption.txt", sep = ";", na.strings = "?")

## Subset by two dates in February
powerFebruary <- subset(powerAll, Date == "1/2/2007" | Date == "2/2/2007")

## Clean date and time in data
powerFebruary[,Date:=as.Date(Date, format = "%d/%m/%Y")]
powerFebruary[,DateTime:=paste(Date, Time, sep = " ")]
powerFebruary[,DateTime:=as.POSIXct(DateTime)]
powerFebruary[,Date:=NULL]
powerFebruary[,Time:=NULL]

## Build histogram
png(filename = "plot1.png", width = 480, height = 480)
with(powerFebruary, hist(Global_active_power, col = "red", xlab = "Global Active Power (kilowatts)", main = "Global Active Power"))
dev.off()