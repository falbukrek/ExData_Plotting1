library(lubridate)

source_url <- "https://d396qusza40orc.cloudfront.net/exdata%2Fdata%2Fhousehold_power_consumption.zip"
zipfile_name <- "household_power_consumption.zip"
textfile_name <- "household_power_consumption.txt"

# download the zip file, if we don't have it already
if (!file.exists(zipfile_name)) {
    download.file("https://d396qusza40orc.cloudfront.net/exdata%2Fdata%2Fhousehold_power_consumption.zip", zipfile_name)
}

# extract the text file, if we don't have it already
if (!file.exists(textfile_name)) {
    unzip(zipfile_name)
}

# read the data into a data frame
consumption <- read.csv2(textfile_name, stringsAsFactors = FALSE)

# clean up the column types
consumption$DateTime <- dmy_hms(paste(consumption$Date, consumption$Time))
consumption$Date <- dmy(consumption$Date)
consumption$Time <- hms(consumption$Time)
consumption$Global_active_power <- as.numeric(consumption$Global_active_power)
consumption$Global_reactive_power <- as.numeric(consumption$Global_reactive_power)
consumption$Voltage <- as.numeric(consumption$Voltage)
consumption$Global_intensity <- as.numeric(consumption$Global_intensity)
consumption$Sub_metering_1 <- as.numeric(consumption$Sub_metering_1)
consumption$Sub_metering_2 <- as.numeric(consumption$Sub_metering_2)
consumption$Sub_metering_3 <- as.numeric(consumption$Sub_metering_3)

# subset the data to the 2007-02-01 and 2007-02-02
plotdata <- subset(consumption, Date == dmy("1/2/2007") | Date == dmy("2/2/2007"))

# start the png file
png("plot4.png")

# set up a 2x2 grid with reduced top margin and smaller font
par(mfrow = c(2, 2),
    mar = c(4, 4, 3, 2),
    cex = 0.75)

# Top-left chart
plot(plotdata$DateTime, plotdata$Global_active_power,
     type = "l",
     ylab = "Global Active Power",
     xlab = "")

# Top-right chart
plot(plotdata$DateTime, plotdata$Voltage,
     type = "l",
     ylab = "Voltage",
     xlab = "datetime")

# bottom-left chart
plot(plotdata$DateTime, plotdata$Sub_metering_1, type = "n", ylab = "Energy sub metering", xlab = "")
lines(plotdata$DateTime, plotdata$Sub_metering_1, col = "black")
lines(plotdata$DateTime, plotdata$Sub_metering_2, col = "red")
lines(plotdata$DateTime, plotdata$Sub_metering_3, col = "blue")
legend("topright",
       legend = c("Sub_metering_1", "Sub_metering_2", "Sub_metering_3"),
       col = c("black", "red", "blue"),
       lty = 1,
       bty = "n")

# bottom-right chart
plot(plotdata$DateTime, plotdata$Global_reactive_power,
     type = "l",
     ylab = "Global_reactive_power",
     xlab = "datetime")

# close the png file
dev.off()




