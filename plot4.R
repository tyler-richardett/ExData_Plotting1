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

## Build plot
png(filename = "plot4.png", width = 480, height = 480)
par(mfrow = c(2,2))

## Plot 1
with(powerFebruary, plot(DateTime, Global_active_power, type = "l", xlab = "", ylab = "Global Active Power"))

## Plot 2
with(powerFebruary, plot(DateTime, Voltage, type = "l", xlab = "datetime"))

## Plot 3
with(powerFebruary, {
        plot(DateTime, Sub_metering_1, type = "n", xlab = "", ylab = "Energy sub metering")
        points(DateTime, Sub_metering_1, type = "l")
        points(DateTime, Sub_metering_2, type = "l", col = "red")
        points(DateTime, Sub_metering_3, type = "l", col = "blue")
})
legend("topright", lty = 1, col = c("black", "red", "blue"), bty = "n", legend = c("Sub_metering_1", "Sub_metering_2", "Sub_metering_3"))

## Plot 4
with(powerFebruary, plot(DateTime, Global_reactive_power, type = "l", xlab = "datetime"))

dev.off()