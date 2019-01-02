#### Plot 1 ###################################################################
# Source the prelude to check available working direcotry, RAM and
# file existence, then provide a function to load data for this plot:
source("prelude.R")

# Which plot are we doing?
plotIndex <- 1

# For the sourced file, fetch the data for this plot:
message(paste("\nLoading data for plot", plotIndex, "..."))
data <- plotData(plotVars[[plotIndex]])

# Construct the plot using the base plotting system
message("\nConstructing the plot...")
chart <- 
  with(data, 
       hist(Global_active_power, 
            col = "red", main = "Global Active Power",
            xlab = "Global Active Power (kilowatts)"))

# Push out a message with the breaks and maximum frequecy...
message(paste("Chart plotted:",
              sprintf(
                "\n\tThere are %d breaks of width %.1f between %.1f and %.1f.", 
                length(chart$breaks), chart$breaks[2] - chart$breaks[1], 
                chart$breaks[1], max(chart$breaks)),
              sprintf(
                "\n\tThe maximum frequency of %d occurs for the bar datum at %.1f",
                max(chart$counts),
                chart$mids[which(max(chart$breaks) %in% chart$breaks)] 
              )))

# Ask the user to confirm or cancel subsequent processing.
invisible(
  readline(
    prompt = "Press the [Enter] key to create a PNG file, or [Esc] to quit."))

# If the user pressend the enter key, then create an output PNG
dev.copy(png, file = paste0("plot", plotIndex, ".png"),
    width = 480, height = 480, units = "px",
    pointsize = 12, bg = "white")
dev.off()
# Ouput a message with file details.
message(
  sprintf(
    "File generated with name %s (%.2f Kb) in your working directory.",
    paste0("plot", plotIndex, ".png"),
    round(file.info("plot1.png")$size / 2^10, 2))
  )
