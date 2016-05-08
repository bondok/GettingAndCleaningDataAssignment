## Clean up R memory
rm(list=ls())

## Loading dplyr
library(dplyr)

## Set working directory
setwd("C:/DataScience/GettingAndCleaningData/Assignments/assignment/")

## Set file paths
activityLabelURL <- "UCI HAR Dataset/activity_labels.txt"
featuresURL <- "UCI HAR Dataset/features.txt"
testSubjectURL <- "UCI HAR Dataset/test/subject_test.txt"
testActivityURL <- "UCI HAR Dataset/test/y_test.txt"
testDataURL <- "UCI HAR Dataset/test/X_test.txt"
trainSubjectURL <- "UCI HAR Dataset/train/subject_train.txt"
trainActivityURL <- "UCI HAR Dataset/train/y_train.txt"
trainDataURL <- "UCI HAR Dataset/train/X_train.txt"

## 1. Merges the training and the test sets to create one data set.
# read data to memory
testData <- read.table(testDataURL,header = FALSE)
testActivity <- read.table(testActivityURL, header = FALSE)
testSubject <- read.table(testSubjectURL, header = FALSE)
trainData <- read.table(trainDataURL,header = FALSE)
trainActivity <- read.table(trainActivityURL, header = FALSE)
trainSubject <- read.table(trainSubjectURL, header = FALSE)
features <- read.table(featuresURL, header = FALSE)
activityLabel <- read.table(activityLabelURL, header = FALSE, col.names=c("Activity", "ActivityName"))
# bind data
bindData <- rbind(testData, trainData)
bindActivity <- rbind(testActivity, trainActivity)
bindSubject <- rbind(testSubject, trainSubject)


## 2. Extracts only the measurements on the mean and standard deviation for each measurement.
# extract the indexes of all the mean and standard deviation data
meanAndStdIndex <- grep(pattern="std|mean", x=features[[2]])
# extract from bind data only data for std and mean
meanAndStdData <- bindData[,meanAndStdIndex]


## 4. Appropriately labels the data set with descriptive variable names.
meanAndStdDataWithActivityandSubject <- cbind(bindActivity, bindSubject, meanAndStdData)
names(meanAndStdDataWithActivityandSubject) <- c("Activity", "Subject", as.vector(features[meanAndStdIndex,2]))
## 3. Uses descriptive activity names to name the activities in the data set
meanAndStdDataWithActivityandSubject <- merge(activityLabel, meanAndStdDataWithActivityandSubject,by ="Activity")


## 5. From the data set in step 4, creates a second, independent tidy data set with the average of each variable for each activity and each subject.
aggdata <- meanAndStdDataWithActivityandSubject %>%group_by(ActivityName,Subject)%>%summarize_each(funs(mean))

## write aggdata to filesystem
write.table(aggdata, "Aggdata.csv", sep=",",row.names = FALSE)
