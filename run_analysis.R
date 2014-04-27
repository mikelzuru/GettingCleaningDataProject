readFiles <- function(rootDirectory="",type){
  
  if (type == "train"){
    dataDirectory <- paste(rootDirectory,"/train",sep="")
  }else if (type == "test"){
    dataDirectory <- paste(rootDirectory,"/test",sep="")
  }else{
    message("Experiment type must be 'train' or 'test'!!")
    return (-1)
  }
  
  library(plyr)
  
  featuresPath <- paste(rootDirectory,"/features.txt",sep="")
  activityLabelsPath <- paste(rootDirectory,"/activity_labels.txt",sep="")
  activitiesPath <- paste(dataDirectory,"/y_",type,".txt",sep="")
  dataPath <- paste(dataDirectory,"/X_",type,".txt",sep="")
  subjectPath <- paste(dataDirectory,"/subject_",type,".txt",sep="")
  bodyAccX_Path <- paste(dataDirectory,"/Inertial Signals/body_acc_x_",type,".txt",sep="")
  bodyAccY_Path <- paste(dataDirectory,"/Inertial Signals/body_acc_y_",type,".txt",sep="")
  bodyAccZ_Path <- paste(dataDirectory,"/Inertial Signals/body_acc_z_",type,".txt",sep="")
  bodyGyroX_Path <- paste(dataDirectory,"/Inertial Signals/body_gyro_x_",type,".txt",sep="")
  bodyGyroY_Path <- paste(dataDirectory,"/Inertial Signals/body_gyro_y_",type,".txt",sep="")
  bodyGyroZ_Path <- paste(dataDirectory,"/Inertial Signals/body_gyro_z_",type,".txt",sep="")
  totalAccX_Path <- paste(dataDirectory,"/Inertial Signals/total_acc_x_",type,".txt",sep="")
  totalAccY_Path <- paste(dataDirectory,"/Inertial Signals/total_acc_y_",type,".txt",sep="")
  totalAccZ_Path <- paste(dataDirectory,"/Inertial Signals/total_acc_z_",type,".txt",sep="")
  
  varNames <- read.table(featuresPath,header=FALSE)
  colnames(varNames) <- c("idVariable","VariableName")
  
  activityNames <- read.table(activityLabelsPath,header=FALSE)
  colnames(activityNames) <- c("idActivity","ActivityName")
  
  data <- read.table(dataPath,header=FALSE)
  colnames(data) <- varNames$VariableName
  cases <- nrow(data)
  
  activities <- read.table(activitiesPath,header=FALSE)
  colnames(activities) <- "idActivity"
  
  subject <- read.table(subjectPath,header=FALSE)
  colnames(subject) <- "idSubject"
  
  bodyAccX <- read.table(bodyAccX_Path,header=FALSE)
  bodyAccVars <- ncol(bodyAccX)
  colnames(bodyAccX) <- paste("bodyAccX",1:bodyAccVars,sep="")
  bodyAccX$idMeasurement <- 1:cases
  
  bodyAccY <- read.table(bodyAccY_Path,header=FALSE)
  colnames(bodyAccY) <- paste("bodyAccY",1:bodyAccVars,sep="")
  bodyAccY$idMeasurement <- 1:cases
  
  bodyAccZ <- read.table(bodyAccZ_Path,header=FALSE)
  colnames(bodyAccZ) <- paste("bodyAccZ",1:bodyAccVars,sep="")
  bodyAccZ$idMeasurement <- 1:cases
  
  bodyGyroX <- read.table(bodyGyroX_Path,header=FALSE)
  colnames(bodyGyroX) <- paste("bodyGyroX",1:bodyAccVars,sep="")
  bodyGyroX$idMeasurement <- 1:cases
  
  bodyGyroY <- read.table(bodyGyroY_Path,header=FALSE)
  colnames(bodyGyroY) <- paste("bodyGyroY",1:bodyAccVars,sep="")
  bodyGyroY$idMeasurement <- 1:cases
  
  bodyGyroZ <- read.table(bodyGyroZ_Path,header=FALSE)
  colnames(bodyGyroZ) <- paste("bodyGyroZ",1:bodyAccVars,sep="")
  bodyGyroZ$idMeasurement <- 1:cases
  
  totalAccX <- read.table(totalAccX_Path,header=FALSE)
  colnames(totalAccX) <- paste("totalAccX",1:bodyAccVars,sep="")
  totalAccX$idMeasurement <- 1:cases
  
  totalAccY <- read.table(totalAccY_Path,header=FALSE)
  colnames(totalAccY) <- paste("totalAccY",1:bodyAccVars,sep="")
  totalAccY$idMeasurement <- 1:cases
  
  totalAccZ <- read.table(totalAccZ_Path,header=FALSE)
  colnames(totalAccZ) <- paste("totalAccZ",1:bodyAccVars,sep="")
  totalAccZ$idMeasurement <- 1:cases
  
  activities <- arrange(join(activities,activityNames),idActivity)
  activities$idMeasurement <- 1:cases
  subject$idMeasurement <- 1:cases
  data$idMeasurement <- 1:cases
  dfList <- list(data,activities,subject,bodyAccX,bodyAccY,bodyAccZ,bodyGyroX,bodyGyroY,bodyGyroZ,totalAccX,totalAccY,totalAccZ)
  cleanData <- join_all(dfList)
  cleanData
}

loadData <- function(directory=""){
  
  library(plyr)
  library(data.table)
  
  trainCleanData <- readFiles(directory,"train")
  testCleanData <- readFiles(directory,"test")
  mergedCleanData <- rbind(trainCleanData,testCleanData)
  
  columnNames <- colnames(mergedCleanData)
  
  meanVariables <- grep("mean\\()",columnNames)
  stdVariables <- grep("std\\()",columnNames)
  idMeasurement <- grep("idMeasurement",columnNames)
  idActivity <- grep("idActivity",columnNames)
  idSubject <- grep("idSubject",columnNames)
  actName <- grep("ActivityName",columnNames)
  
  desiredColumns <- c(idMeasurement,idActivity,idSubject,actName,meanVariables,stdVariables)
  mergedCleanData_Lite <- mergedCleanData[,desiredColumns]
  tidyColumnNames <- colnames(mergedCleanData_Lite[,3:ncol(mergedCleanData_Lite)])
  
  liteDT <- data.table(mergedCleanData_Lite)
  
  summaryDataSet <- liteDT[,lapply(.SD,mean),by='idSubject,idActivity']
  summaryDataSet[,idMeasurement:=NULL]
  summaryDataSet[,idActivity:=NULL]
  tidyDataSet <- summaryDataSet[order(idSubject)]
  
  colnames(tidyDataSet) <- tidyColumnNames
  write.table(tidyDataSet,paste(directory,"/tidyDataSet.txt",sep=""),row.names=FALSE)
  
  tidyDataSet
  
}