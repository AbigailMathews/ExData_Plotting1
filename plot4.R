
# This script a plot containing four subplots using data derived from a small subset of
# the household power consumption dataset. Because the source data is contained in a 
# zipped archive, this program assumes that the file has been downloaded ahead of time 
# and is available in the current working directory

# I tried using data.table's fread, but the coercion of columns containing NA strings
# to character is problematic. I also tried using the sqldf package, but it couldn't 
# handle the heading properly. Alas, I will default to the very slow read.table

loadpower <- read.table("household_power_consumption.txt", na.strings='?', sep=";", 
                        header=TRUE, colClasses=c("character","character",rep("numeric",7)))

# Fix up header
colnames(loadpower) <-names(read.table('household_power_consumption.txt', 
                                       header=TRUE,sep=";",nrows=1))
# Subset the data to just look at the two dates of interest
power1 <- loadpower[(loadpower$Date=="1/2/2007" | loadpower$Date=="2/2/2007"),]

# Fix the date issues by concatenating the date and time columns, and then appending
# the new datetime column to the head of the table
powerdat <- paste(power1$Date, power1$Time, sep=' ')
datetime  <- strptime(powerdat,format ="%d/%m/%Y %H:%M:%S")
power <- cbind(datetime,power1)

# Create plot 4, containing 4 subplots, in a png file, plot4.png
png(file = "plot4.png")
par(mfrow = c(2,2))
plot(power$datetime, power$Global_active_power, type="l", 
     ylab= "Global Active Power", xlab="")
plot(power$datetime, power$Voltage, type="l", xlab="datetime", ylab="Voltage")
plot(power$datetime, power$Sub_metering_1, type="n", ylab="Energy Sub Metering", xlab="")
lines(power$datetime, power$Sub_metering_1)
lines(power$datetime, power$Sub_metering_2, col="red")
lines(power$datetime, power$Sub_metering_3, col="blue")
legend("topright", col=c("black", "red", "blue"), lty="solid",
       legend=c("Sub_metering_1", "Sub_metering_2", "Sub_metering_3"))
plot(power$datetime, power$Global_reactive_power, type="l", 
     xlab="datetime", ylab="Global_reactive_power")
dev.off()
