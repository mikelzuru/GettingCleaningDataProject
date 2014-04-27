GettingCleaningDataProject
==========================

Repo for "Getting and Cleaning Data" coursera project.

In this repo you have an R-script "run_analysis.R", which you can load into RStudio like this.
Let's imagine that you download this script at "D:/" directory. Enter the next command into RStudio:

* source('D:/run_analysis.R')

Once you have loaded the script, you have access to 2 functions:

1. readFiles(rootDirectory,type): This function is used by "loadData" function and it's not neccesary to
call it from the command prompt in order to get the tidy data. This function reads the information of general files 
(features.txt,activity_labels.txt) and test/train files (y_train.txt, X_train.txt, subject_train.txt, body_acc_x_train.txt...).
It works depending on the parameter "type" you enter when calling the function (type has to be "train" or "test").
The first parameter "rootDirectory" normally has to be the same as entered in "loadData" function.

2. loadData(directory): This is the main function, which you must call from the command prompt in order to
get the tidy data. It needs an input parameter "directory", and it must be the absolute or relative path equal
to the content in "UCI HAR Dataset" folder (original dataSet). For example, imagine that RStudio has set the
working directory in "C:/Users/LukeSkyWalker/Documents", and you have downloaded the original dataSet here in
a folder called the same as the .zip file (getdata-projectfiles-UCI HAR Dataset.zip). So you have here a folder tree like this:

* "C:/Users/LukeSkyWalker/Documents/getdata-projectfiles-UCI HAR Dataset/UCI HAR Dataset", and here you have
some files and "test" and "train" folders.

In this case, and having your working directory as mentioned above, you can call "loadData" function in two ways,
with either absolute or relative path:

* loadData("C:/Users/LukeSkyWalker/Documents/getdata-projectfiles-UCI HAR Dataset/UCI HAR Dataset")
* loadData("getdata-projectfiles-UCI HAR Dataset/UCI HAR Dataset")

This function returns a data.table object with the tidy dataSet and also creates a file called "tidyDataSet.txt"
into the directory you entered as a parameter.

Notes: This script requires to have installed both "plyr" and "data.table" R packages.