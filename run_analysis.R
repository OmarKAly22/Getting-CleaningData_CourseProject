#creating data directory if not already created
if(!file.exists("./data")){
  dir.create("./data")
}

#variable to save the url
fileUrl <- "https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip"

#downloading data from the url to the destination directory
download.file(fileUrl, "./data/courseProjectData.zip")

#decompressing the data as its downloaded zipped
unzip("./data/courseProjectData.zip", exdir = "./data")


#after checking the decompressed data the folder name is "UCI HAR Dataset"
#now  prepare the data for parsing according to the readme.txt file with the data:
#- 'features_info.txt': Shows information about the variables used on the feature vector.
#
#- 'features.txt': List of all features.
#
#- 'activity_labels.txt': Links the class labels with their activity name.
#
#- 'train/X_train.txt': Training set.
#
#- 'train/y_train.txt': Training labels.
#
#- 'test/X_test.txt': Test set.
#
#- 'test/y_test.txt': Test labels.
#use the file.path and read.table method for data preparation
#create variables

#Activity data
courseProjectActTestData  <- read.table(file.path("./data/UCI HAR Dataset", "test" , "Y_test.txt" ),header = FALSE)
courseProjectActTrainData <- read.table(file.path("./data/UCI HAR Dataset", "train", "Y_train.txt"),header = FALSE)

#Subject Data
courseProjectSubTestData <- read.table(file.path("./data/UCI HAR Dataset", "test" , "subject_test.txt"),header = FALSE)
courseProjectSubTrainData  <- read.table(file.path("./data/UCI HAR Dataset", "train", "subject_train.txt"),header = FALSE)

#Feature data
courseProjectFetTestData  <- read.table(file.path("./data/UCI HAR Dataset", "test" , "X_test.txt" ),header = FALSE)
courseProjectFetTrainData <- read.table(file.path("./data/UCI HAR Dataset", "train", "X_train.txt"),header = FALSE)

#Now merge data

#merge activity data
courseProjectActData <- rbind(courseProjectActTestData, courseProjectActTrainData)

#merge subject data
courseProjectSubData<- rbind(courseProjectSubTestData, courseProjectSubTrainData)

#merge feature data
courseProjectFetData<- rbind(courseProjectFetTestData, courseProjectFetTrainData)

#naming data

#naming activity data
names(courseProjectActData)<- c("activity")

#naming subject data
names(courseProjectSubData)<-c("subject")

#naming feature data
fetDataNames <- read.table(file.path("./data/UCI HAR Dataset", "features.txt"),head=FALSE)
names(courseProjectFetData)<- fetDataNames$V2

#descreptive activity names from the activity label txt file
actDataNames <- read.table(file.path("./data/UCI HAR Dataset", "activity_labels.txt"),header = FALSE)

#now merging all data in one data frame
courseProjectDataFrame <- cbind(courseProjectFetData, courseProjectActData, courseProjectSubData)

#Name of Features by measurements on the mean and standard deviation
courseProjectsubDataFetNames<-fetDataNames$V2[grep("mean\\(\\)|std\\(\\)", fetDataNames$V2)]

#Subset main data frame  by seleted names of Features
courseProjectDataFrame<-subset(courseProjectDataFrame,select=c(as.character(courseProjectsubDataFetNames), "subject", "activity" ))


#facorize  activity in the data frame using descriptive activity names(actDataNames)

courseProjectDataFrame$activity <- factor(courseProjectDataFrame$activity, labels = actDataNames$V2)

#label Course Project Data  with descriptive variable names
names(courseProjectDataFrame)<-gsub("^t", "time", names(courseProjectDataFrame))
names(courseProjectDataFrame)<-gsub("^f", "frequency", names(courseProjectDataFrame))
names(courseProjectDataFrame)<-gsub("Acc", "Accelerometer", names(courseProjectDataFrame))
names(courseProjectDataFrame)<-gsub("Gyro", "Gyroscope", names(courseProjectDataFrame))
names(courseProjectDataFrame)<-gsub("Mag", "Magnitude", names(courseProjectDataFrame))
names(courseProjectDataFrame)<-gsub("BodyBody", "Body", names(courseProjectDataFrame))


#generate and export tidy data using plyr package

library(plyr);
courseProjectTidyData<-aggregate(. ~subject + activity, courseProjectDataFrame, mean)
courseProjectTidyData<-courseProjectTidyData[order(courseProjectTidyData$subject,courseProjectTidyData$activity),]
write.table(courseProjectTidyData, file = "tidydata.txt",row.name=FALSE)
