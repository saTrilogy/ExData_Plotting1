#### Libraries ################################################################
library(lubridate)
library(fasttime)
library(data.table)
library(dplyr)

#### Name of target data file #################################################
targetFile <- "household_power_consumption.txt"

#### Verify file is in working directory ######################################
message(paste("Your working directory is\n\t", getwd()))
if(!file.exists(targetFile)){
  stop(paste("\tThe target file", targetFile, "\n\tis not present",
             "in your working directory. \n\tAborting process."))
} else {
  message(paste("\tFound the  target file", targetFile, "\n\n"))
}
              
#### Do we have enough RAM to process the file? ###############################
# Get the approximate memory requirement for loading the file
sz <- round( ( file.info(targetFile)$size ) * 2 * 8 / 2^30, 3 ) 
# Only on Windows using the WMI API
if(tolower(Sys.info()["sysname"]) == "windows") {
  ram <- round(
    as.numeric(
      sub("[^0-9]*", "", 
          # Issue the WMI call to get free availabale RAM
          system("wmic OS get FreePhysicalMemory /Value", 
                 intern = TRUE)[3]))
    / 10^6, 3)
  message(paste("Your Windows system free memory appears to be",
                "approximately", ram, "GB."))
  # )K - dow we have eough RAM to process the file?
  if(ram > sz){
    message(paste("\tWorking with this file will require up to ", sz,
                  "Gb \n\twhich is available in your free memory."))
    
  } else {
    # Probably not - so abort the process.
    stop(paste("\tWorking with this file will require up to ", sz,
               "Gb \n\twhich is not available in your free memory.",
               "\n\tAborting process."))
  } 
} else {
  # For non-Windows systems
  message(paste("Working with this file will require up to ", sz,
                "Gb of RAM - \n\t make sure you have that available",
                "before continuing."))
  # Ask the user to confirm or cancel subsequent processing.
  invisible(
    readline(
      prompt = "Press the [Enter] key to continue or [Esc] to quit."))
}

#### Column specification for data per plot ###################################
# The variable plotVars is a list of four elements,
# the first being the column selection list for the
# first plot, the second for the second plot and so
# forth. To access the list element for the column
# character vecor for a plot use plotVars[[n]]
# where n is the plot number 1 through 4
plotVars <- list(
  c("Global_active_power"),
  c("Timestamp", "Global_active_power"),
  c("Timestamp", "Sub_metering_1", 
    "Sub_metering_2", "Sub_metering_3"),
  c("Timestamp", "Global_active_power", "Voltage", 
    "Sub_metering_1", "Sub_metering_2", 
    "Sub_metering_3", "Global_reactive_power")
)

### Data loading function ####################################################
# For the argument fread the target file and filter out the rows from February
# 2007 that we don't need, then mutate character date/time into a strongly 
# typed datetime and subset the columns based upon the argument.
# Argument: The character vector to subset the columns required
#           for a plot. Use the plotVars variable is in for
#           example plotVars[[1]]
plotData <- function(vars = character()){
  data.table(fread(targetFile,
                   header = TRUE, strip.white = TRUE, 
                   blank.lines.skip = TRUE, check.names = FALSE, 
                   key = NULL, stringsAsFactors = FALSE, 
                   sep = ";", showProgress = TRUE,
                   na.strings = c("?"), verbose = FALSE) ) %>%
  # Reduce rowcount to around 3000
  filter(Date %in% c("1/2/2007", "2/2/2007")) %>%
  # Strongly type the date/time character data
  mutate(Timestamp = fastPOSIXct(paste(dmy(Date), Time))) %>%
  # Only output the required columns.
  select(one_of(vars))
}
