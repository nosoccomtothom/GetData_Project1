library(data.table)
library(plyr)

## Unzip the file
unzip("getdata_projectfiles_UCI HAR Dataset.zip")

## Loading the variables names
features<-read.table("UCI HAR Dataset/features.txt")

## Replacing the meanFreq to an alternate name to easy the forthcoming filtering
features$V2 <- gsub("meanFreq", "mF", features$V2)

## Clearing parenthesis and other punctuation symbols
features$V2 <- make.names(gsub("\\(.*\\)", "", features$V2))

## Loading the activity names
activities<-fread(input="UCI HAR Dataset/activity_labels.txt",header=FALSE)
colnames(activities)<-c("Activity", "Activity_Name")

## Create the list of labels combining a hardcoded "Subject" and "Activity" with the second column of 
## the features trated as a vector
labels<-c("Subject", "Activity", as.vector(features$V2))
rm(features) ##Clearing memory

## Loading the train/test data activity
train_activity<-fread(input="UCI HAR Dataset/train/y_train.txt",header=FALSE)
test_activity<-fread(input="UCI HAR Dataset/test/y_test.txt",header=FALSE)

## Loading the train/test data by removing leading spaces and creating a data set with 561 columns
train_data<-read.table("UCI HAR Dataset/train/X_train.txt", header=F, strip.white=T) 
test_data<-read.table("UCI HAR Dataset/test/X_test.txt", header=F, strip.white=T) 

##Loading the train/test subjects
train_subjects<-fread(input="UCI HAR Dataset/train/subject_train.txt",header=FALSE)
test_subjects<-fread(input="UCI HAR Dataset/test/subject_test.txt",header=FALSE)

##Assigning a values for the test and train data and combining the data type, subjects, activity performed and the actual data for test/train
test_dataset<- data.frame(test_subjects, test_activity, test_data) ##merging data sets to incoporate the tipology of activity
train_dataset<- data.frame(train_subjects, train_activity, train_data) ##merging data sets to incoporate the tipology of activity

##Freeing up memory
rm(train_activity)
rm(train_subjects)
rm(train_data)
rm(test_activity)
rm(test_subjects)
rm(test_data)

## Label the columns
colnames(train_dataset)<-labels
colnames(test_dataset)<-labels

## Combine the test and train datasets
full_data<-rbind(train_dataset,test_dataset)
rm(train_dataset)
rm(test_dataset)

## Subsetting the variables
std_cols<-which(names(full_data) %like% c("std")) ##Selecting all the columns that have a std
mean_cols<-which(names(full_data) %like% c("mean")) ## Selecting all the columns that have a mean including meanFreq

## Subset of the original data including std and mean calculations
tidy_dataset <-full_data[, c(1,2,std_cols,mean_cols)]

## Dump the filtered and clean data set with std variables to a file
write.table(tidy_dataset,file="tidy_dataset.csv", sep=",",row.names=FALSE)

## Calculate the average for all the variables for each combination of subject and activity type
## Alternatively colMeans instead of numcolwise(means)
tidy_dataset_mean<-ddply(tidy_dataset, .(Activity,Subject), numcolwise(mean)) 

## Join the dataset with the activity types
tidy_dataset_mean<-merge(tidy_dataset_mean,activities,by="Activity")

## Reorganising Activity Name to be the third after Type and Subject
## Alternatively, to use the values from activities[["Activity_Name"]]
tidy_dataset_mean<-tidy_dataset_mean[,c(length(tidy_dataset_mean),2:(length(tidy_dataset_mean)-1))] 

## Dump the filtered and clean data set with mean summary variables to a file
write.table(tidy_dataset_mean,file="tidy_dataset_mean.csv", sep=",",row.names=FALSE)
