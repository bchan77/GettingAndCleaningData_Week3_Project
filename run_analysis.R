run_analysis <- function()
{
	
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
		
	
	
	
	
}