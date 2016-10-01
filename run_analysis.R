print('Type clean_har_data(directory) where directory is the unzipped UCI HAR Dataset folder to start the function.')

# Function found on stackoverflow - credits to Silentbang
# http://stackoverflow.com/questions/9341635/check-for-installed-packages-before-running-install-packages
is.installed <- function(mypkg){
  is.element(mypkg, installed.packages()[,1])
}

clean_har_data <- function(directory = "UCI HAR Dataset"){
  # 0a- Check if all the required files exists
  if(!file.exists(directory) |
     !file.exists(paste(directory, "features.txt", sep = "/")) |
     !file.exists(paste(directory, "activity_labels.txt", sep = "/")) |
     !file.exists(paste(directory, "test", "subject_test.txt", sep = "/")) |
     !file.exists(paste(directory, "test", "y_test.txt", sep = "/")) |
     !file.exists(paste(directory, "test", "X_test.txt", sep = "/")) |
     !file.exists(paste(directory, "train", "subject_train.txt", sep = "/")) |
     !file.exists(paste(directory, "train", "y_train.txt", sep = "/")) |
     !file.exists(paste(directory, "train", "X_train.txt", sep = "/"))
  ){
    print('One or more files are missing.')
    return('Please download the UCI HAR Dataset from https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip and unzip it.')
  }
  # 0b- Importing packages that will be needed later on
  if(!is.installed("dplyr")){
    print("Installing dplyr package")
    install.packages("dplyr")
  }
  library(dplyr)
  
  if(!is.installed("nlme")){
    print("Installing nlme package")
    install.packages("nlme")
  }
  library(nlme)
  
  if(!is.installed("tidyr")){
    print("Installing tidyr package")
    install.packages("tidyr")
  }
  library(tidyr)
  
  # 1- Get the features. The features are the columns of the X_*.txt files (* = test or train)
  features <- read.table(paste(directory, "features.txt", sep = "/"))
  
  # 2- Find the features we want to average
  feature_columns <- grep("(mean)|(std)", features[,2])
  
  # 3- Get the activity names
  activity_labels <- read.table(paste(directory, "activity_labels.txt", sep = "/"))
  activity_labels <- as.character(activity_labels[,2])
  
  # 4- Get all test data
  
  # 4a- Subject id's. Every subject id matches 1 row in X_test.txt
  subjects_test <- read.table(paste(directory, "test", "subject_test.txt", sep = "/"))
  
  # 4b- y_test.txt represents the activities. Every activity matches 1 row in X_test.txt
  y_test <- read.table(paste(directory, "test", "y_test.txt", sep = "/"))
  names(y_test) <- "activity"
  
  # 4c- Import test data and merge it with the subjects and activities. Keep only the needed features.
  x_test <- read.table(paste(directory, "test", "X_test.txt", sep = "/"))
  names(x_test) <- features[,2]
  x_test <- x_test[, feature_columns]
  x_test["activity"] <- y_test
  x_test["subject"] <- subjects_test
  
  # 4d- Give names to activities instead of just having the activity id's
  x_test["activity_name"] <- activity_labels[x_test$activity]
  
  # 5- Get all train data (same steps as the test data)
  subjects_train <- read.table(paste(directory, "train", "subject_train.txt", sep = "/"))
  
  y_train <- read.table(paste(directory, "train", "y_train.txt", sep = "/"))
  names(y_train) <- "activity"
  
  x_train <- read.table(paste(directory, "train", "X_train.txt", sep = "/"))
  names(x_train) <- features[,2]
  x_train <- x_train[,feature_columns]
  x_train["activity"] <- y_train
  x_train["subject"] <- subjects_train
  x_train["activity_name"] <- activity_labels[x_train$activity]
  
  # 6- Merge test and train data into 1 dataframe
  x <- rbind(x_train, x_test)
  
  # 7- Remove the activity column (not required since there's a column with the activity names)
  x <- x[, !names(x) == "activity"]
  
  # 8- Average the features by subject and activity
  final_data <- aggregate(x[, !names(x) %in% c("activity_name", "subject")], list(x$subject, x$activity_name), mean)
  
  # 9- Rename the columns (basicalle just adding "average" before the column name)
  names(final_data) <- paste("average_of_:", names(final_data), sep = "_")
  
  # 10- Renaming the subject and activity columns since they were changed in the aggregate function
  colnames(final_data)[1] <- "subject"
  colnames(final_data)[2] <- "activity"
  
  # 11a- Sorting the data by subject and activity
  sorted_data <- arrange(final_data, subject, activity)
  
  # 11b- Renaming the column names to be tidy
  names(sorted_data) <- tolower(gsub("[^[:alnum:] ]","",names(sorted_data)))
  
  # 12- Writing the data in a .txt file
  write.table(sorted_data, "UCI HAR Dataset - tidy data.txt", row.names = F, quote = F)
  
  print("Job completed.")
  
  # 13- Displaying the data to the user
  View(read.table("UCI HAR Dataset - tidy data.txt"))
}