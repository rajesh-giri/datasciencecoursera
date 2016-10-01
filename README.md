# Getting and cleaning data
## Assignment Files:
 * course_assignment.R
 * UCI HAR Dataset - tidy data.txt
 
## What this function does :
 * Keeps all the features with either mean or std in the name
 * Computes the mean of the features by subject and activity
 * Returns a file with tidy data

##How to use :

* Download the UCI HAR Dataset (https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip)
* Unzip the Dataset
* Open R
* Source the course_assignment.R file
* Use the clean_har_data(directory) function with directory set as your unzipped dataset folder
* The data will be saved in your current working directory as "UCI HAR Dataset - tidy data.txt"
* You can find more info about the UCI HAR Dataset here : http://archive.ics.uci.edu/ml/datasets/Human+Activity+Recognition+Using+Smartphones
