run_analysis <- function()
{
	
	library("reshape2")
	
	
#================================================
# Download data 
#================================================	
	
	fileURL <- "https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip"
    zip_file <- ".Dataset.zip"
		
	#Check if Dataset.zip is there
	if(!file.exists(zip_file))
	{
		download.file(fileURL, destfile=zip_file, method="curl")
		
		#unzip the file
		unzip(zip_file, overwrite=TRUE)
	}
		
	
#================================================
# Read the data
#================================================		
	
	# Base Path = ./UCI HAR Dataset/
	
	#features.txt
	features <- read.table("./UCI HAR Dataset/features.txt", header=FALSE)
	activity_labels <- read.table("./UCI HAR Dataset/activity_labels.txt", header=FALSE)
	
	#files in test directory
	y_test <- read.table( "./UCI HAR Dataset/test/y_test.txt",header=FALSE)
	x_test <- read.table("./UCI HAR Dataset/test/x_test.txt", header=FALSE)
	subject_test <- read.table("./UCI HAR Dataset/test/subject_test.txt", header=FALSE)
	
	#files in train direcotry
	y_train <- read.table("./UCI HAR Dataset/train/y_train.txt", header=FALSE)
	x_train <- read.table("./UCI HAR Dataset/train/X_train.txt", header=FALSE)
	subject_train <- read.table("./UCI HAR Dataset/train/subject_train.txt", header=FALSE)
	

	

#================================================
# Merges the training and the test sets to create one data set.
#================================================		
	test_data <- cbind(cbind(x_test,subject_test),y_test)
	train_data <- cbind(cbind(x_train,subject_train),y_train)
	
	#Combine test and train
	all_data <- rbind(test_data, train_data)


	
#================================================
# Extracts only the measurements on the mean and standard deviation for each measurement. 
#================================================
	#In order to use grep, we need to label the columns
	colnames(all_data) <- c(as.character(features[,2]),"Subject_ID", "Activity_ID" )

	#Grep the mean & std for the assignment but get the Activity_ID to do the join the next assignment	
	mean_sd <- all_data[, grep("mean|std|Activity_ID|Subject_ID", colnames(all_data))]

#================================================
# Uses descriptive activity names to name the activities in the data set
#================================================
	#Need to label activity_labels so I could do it a join
	names(activity_labels) = c("Activity_ID", "Activity_Name")
    
    #Join mean_sd by Activity_ID
    mean_sd_activity_labels <- merge(activity_labels, mean_sd, by = "Activity_ID")


#================================================
# Uses descriptive activity names to name the activities in the data set
#================================================
      # Base on http://archive.ics.uci.edu/ml/datasets/Human+Activity+Recognition+Using+Smartphones#
      # Gyro -> Gyroscope
      # Acc -> Accelerometer
      
      
      names(mean_sd_activity_labels) <- gsub('Acc', 'Accelerometer', names(mean_sd_activity_labels))
      names(mean_sd_activity_labels) <- gsub('Gyro', 'Gyroscope', names(mean_sd_activity_labels))


#================================================
# From the data set in step 4, creates a second, independent tidy data set with the average of each variable for each activity and each subject.
#================================================
	#Need plyr for aggregate function
	library("plyr")
	
	#Group by Subject_ID, Activity_ID and Activity_Name for the mean of all columns
	tinydata <- aggregate( . ~Subject_ID + Activity_ID+ Activity_Name, mean_sd_activity_labels, mean)

	# easy to write the output to file and use vi
	write.table(tinydata, "tinydata.txt")
	
}