# function readFile
# Returns one data set by reading and merging all component files.
# The file_path indicates the path where the data files can be found from R working directory.
# The file_name indicates the file name "test or train" adding the extension ".txt".
# Subset data to extract only the measurements on the mean and standard deviation for each measurement.
# The required columns in the subset is determined by selecting only those columns that have either "mean()" or "std()" in their names.
# First copy all files and folders from  the "\UCI HAR Dataset\" to the R working directory, preserving the structure.

readFile <- function(file_path, file_name) {
  fpath <- file.path(file_path, paste0("y_", file_name, ".txt"))
  y_file <- read.table(fpath, header=F, col.names=c("ActivityID"))
  
  fpath <- file.path(file_path, paste0("subject_", file_name, ".txt"))
  subject_data <- read.table(fpath, header=F, col.names=c("SubjectID"))
  
  # read the column names
  data_cols <- read.table("features.txt", header=F, as.is=T, col.names=c("MeasureID", "MeasureName"))
  
  # read the X data file
  fpath <- file.path(file_path, paste0("X_", file_name, ".txt"))
  data <- read.table(fpath, header=F, col.names=data_cols$MeasureName)
  
  # names of subset columns required
  subset_data_cols <- grep(".*mean\\(\\)|.*std\\(\\)", data_cols$MeasureName)
  
  # subset the data (done early to save memory)
  data <- data[,subset_data_cols]
  
  # append the activity id and subject id columns
  data$ActivityID <- y_file$ActivityID
  data$SubjectID <- subject_data$SubjectID
  
  # return the data
  data
}


# read test data set, in a folder named "test"
readTestData <- function() {
  readFile("test", "test")
}


# read test data set, in a folder named "train"
readTrainData <- function() {
  readFile("train", "train")
}


# Merge both train and test data sets
mergeData <- function() {
  data <- rbind(readTestData(), readTrainData())
  cnames <- colnames(data)
  cnames <- gsub("\\.+mean\\.+", cnames, replacement="Mean")
  cnames <- gsub("\\.+std\\.+",  cnames, replacement="Std")
  colnames(data) <- cnames
  data
}


# Add the activity names as another column
applyActivityLabel <- function(data) {
  activity_labels <- read.table("activity_labels.txt", header=F, as.is=T, col.names=c("ActivityID", "ActivityName"))
  activity_labels$ActivityName <- as.factor(activity_labels$ActivityName)
  data_labeled <- merge(data, activity_labels)
  data_labeled
}


# Combine training and test data sets and add the activity label as another column
getMergedLabeledData <- function() {
  applyActivityLabel(mergeData())
}


# Create a tidy data set that has the average of each variable for each activity and each subject.
getTidyData <- function(merged_labeled_data) {
  library(reshape2)
  
  # melt the dataset
  id_vars = c("ActivityID", "ActivityName", "SubjectID")
  measure_vars = setdiff(colnames(merged_labeled_data), id_vars)
  melted_data <- melt(merged_labeled_data, id=id_vars, measure.vars=measure_vars)
  
  # recast 
  dcast(melted_data, ActivityName + SubjectID ~ variable, mean)    
}


# Create the tidy data set
createTidyDataFile <- function(fname) {
  tidy_data <- getTidyData(getMergedLabeledData())
  write.table(tidy_data, fname)
}


createTidyDataFile("tidy.txt")
print("Tidy dataset was created and saved in the file tidy.txt...")
