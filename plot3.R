#### Plot 3 ###################################################################
# Source the prelude to check available working direcotry, RAM and
# file existence, then provide a function to load data for this plot:
source("prelude.R")

# Which plot are we doing?
plotIndex <- 3

# For the sourced file, fetch the data for this plot:
message(paste("\nLoading data for plot", plotIndex, "..."))
data <- plotData(plotVars[[plotIndex]])

# Construct the plot using the base plotting system
message("\nConstructing the plot...")
chart <- 
  with(data, 
       plot(Timestamp, Sub_metering_1, 
            type = "n",
            xlab = "", ylab = "Energy sub metering")
  )
with(data, lines(Timestamp, Sub_metering_1, type = "l", col = "black"))
with(data, lines(Timestamp, Sub_metering_2, type = "l", col = "red"))
with(data, lines(Timestamp, Sub_metering_3, type = "l", col = "blue"))
legend("topright", lty = c(1,1,1), col=c("black", "blue", "red"),
       legend=c("Sub_metering_1", "Sub_metering_2", "Sub_metering_3"))


# Ask the user to confirm or cancel subsequent processing.
invisible(
  readline(
    prompt = "Press the [Enter] key to create a PNG file, or [Esc] to quit."))

# If the user pressend the enter key, then create an output PNG
dev.copy(png, file = paste0("plot", plotIndex, ".png"),
         width = 480, height = 480, units = "px",
         pointsize = 11, bg = "white")
dev.off()
# Ouput a message with file details.
message(
  sprintf(
    "File generated with name %s (%.2f Kb) in your working directory.",
    paste0("plot", plotIndex, ".png"),
    round(file.info(paste0("plot", plotIndex, ".png"))$size / 2^10, 2))
)
