filenm <- "getdata_dataset.zip"

## Downloading dataset and unzipping it if not already done in working directory
if(!file.exists(filenm)){
  fileURL <- "https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip"
  download.file(fileURL, filenm)
}
if(!file.exists("UCI HAR Dataset")){
  unzip(filenm)
}

## Read in files 
Test_act_data <- read.table(file.path("UCI HAR Dataset", "test","y_test.txt"), header = FALSE)
Train_act_data <- read.table(file.path("UCI HAR Dataset", "train","y_train.txt"), header = FALSE)
Test_subject_data <- read.table(file.path("UCI HAR Dataset", "test","subject_test.txt"), header = FALSE)
Train_subject_data <- read.table(file.path("UCI HAR Dataset", "train","subject_train.txt"), header = FALSE)
Test_features_data <- read.table(file.path("UCI HAR Dataset", "test","X_test.txt"), header = FALSE)
Train_features_data <- read.table(file.path("UCI HAR Dataset", "train","X_train.txt"), header = FALSE)

## Combining the training and test sets by data type 
Subject_data <- rbind(Train_subject_data, Test_subject_data)
Act_data <- rbind(Train_act_data, Test_act_data)
Features_data <- rbind(Train_features_data, Test_features_data)

## Naming the variables
names(Subject_data) <- c("subject")
names(Act_data) <- c("activity")
FeaturesNames <- read.table(file.path("UCI HAR Dataset","features.txt"),head=FALSE)
names(Features_data) <- FeaturesNames$V2

## Merge columns for data frame
All_data <- cbind(Subject_data, Act_data)
Data <- cbind(Features_data, All_data)

## Subset Name of Features by measurements
Sub_FeaturesNames <- FeaturesNames$V2[grep("mean\\(\\)|std\\(\\)",FeaturesNames$V2)]
SelectedNames <- c(as.character(Sub_FeaturesNames),"subject","activity")
Data<-subset(Data, select=SelectedNames)

ActivityLabs <- read.table(file.path("UCI HAR Dataset", "activity_labels.txt"), header=FALSE)

Data$activity <- factor(Data$activity, levels = activityLabels[,1], labels = activityLabels[,2])
Data$subject <- as.factor(Data$subject)

library(reshape2)

Data.melted <- melt(Data, id = c("subject", "activity"))
Data.mean <- dcast(Data.melted, subject + activity ~ variable, mean)

write.table(Data.mean, "tidydata.txt", row.names = FALSE, quote = FALSE)
