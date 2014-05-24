Getting dataset tidy independent, with the mean of each variable for each activity and each subject
========================================================

* Download the data set and extract it.
* Copy the structure, files and folders, from the <UCI HAR Dataset>  folder to the R working directory.
* Copy the script run_analysis.R to the R working directory.
* Execute in R the command: source("run_analysis.R")
* The tidy dataset should get created in the current directory as  tidy.txt.

How the script run_analysis.R works
-----------------------------------

* The function *readFile* reads the data, at a time, from the files test.txt and train.txt.  
Subset data to extract only the measurements on the mean and standard deviation for each measurement.  
The required columns in the subset is determined by selecting only those columns that have either "mean()" or "std()" in their names.  
Returns the dataframe <data> from the files test.txt and train.txt, depending on the arguments.

* The function *readTestData* invokes the *readFile* function for get the results of the test dataframe.

* The function *readTrainData* invokes the *readFile* function for get the results of the train dataframe.

* With these two functions, the data is merged in the function *mergeData*  

* The function *applyActivityLabel* add the activity names as another column, on the resulting merged dataframes (test and train).  
This is done in the function *getMergedLabeledData*.  

* The function *getTidyData* create a tidy data set that has the average of each variable for each activity and each subject.  
This function needs the **reshape2** library.  
This is done in the function *createTidyDataFile*  

* The function *createTidyDataFile* also writes the tidy data to a txt file, with a name passed by the parameter.  
In this case, creates a tidy.txt file.

