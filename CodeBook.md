Getting and Cleaning Data - Project 1 CodeBook
========================================================

This document contains all the steps on the data acquisition, transformation and export for the Project 1.

**Dataset characteristics**
-------------------------
The dataset comes from the *Human Activity Recognition Using Smartphones Data Set*  
* Project website  
http://archive.ics.uci.edu/ml/datasets/Human+Activity+Recognition+Using+Smartphones
* Data source  
https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip 

* Data source file  
*getdata_projectfiles_UCI HAR Dataset.zip*

**Data transformation script**  
The script *run_analysis.R* encloses all the transformation steps  

**Data transformations**  
1. Unzip the data source file  
2. Load the variable names into *features*  
3. Load the activity labels into *activities* with column name "Activity" for later merging  
4. Define the dataset labels as combination of *Type*, *Subject*, *Activity* and the rest of variables in *features*. Store the labels into *labels*  
5. Load the test and train data activity into *train_activity* and *test_activity*  
6. Load the test and train data set into *train_data* and *test_data*  
7. Load the subject for the test and train datasets into *test_subjects* and *train_subjects*  
8. Combine separately for test and train the subjects, activity and data into *test_dataset* and *train_dataset*  
  * Include as first a *Type* column with hardcoded values (¨Test¨ or ¨Train¨) in order to be able to identify the origin of the observations  
  * Assign the column names from *labels*  
9. Append the *test_dataset* and the *train_dataset* into *full_data*  
10. Merge the *full_data* with the *activities* in order to grab the description values  
  * Reorganise the order of the columns by placing *Type*, *Subject*, *Activity_Name* and all the measures   
  * Convert *Activity_Name* and *Subject* as factors   
11. Subset the *full_data* to obtain only the measurements related to mean and std  
  * Identify the column names related to std and mean and save them accordingly to *std_cols* and *mean_cols*  
  * Subset the *full_data* by taking only the *Type*, *Subject* and *Activity_Name* dimensions and the std and mean measurements into *tidy_dataset*  
13. Export the *tidy_dataset* content into *tidy_dataset.csv*  
14. Calculate the mean of all the variables for each subject and activity type into *tidy_dataset_mean*  
15. Export the *tidy_dataset_mean* content into *tidy_dataset_mean.csv*  

**Data output**  
The script exports  
 * a clean and tidy subset fo data to a file named *tidy_dataset.csv* in *CSV* format  
 * a summarised cleaned subset with the mean values for all the std and mean variables by *Activity* and *Subject* to a file named *tidy_dataset_mean.csv* in *CSV* format  