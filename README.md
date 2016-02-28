# Getting-CleaningData_CourseProject

creating data directory if not already created

create variable to save the url

downloading data from the url to the destination directory

decompressing the data as its downloaded zipped

after checking the decompressed data the folder name is "UCI HAR Dataset"
now  prepare the data for parsing according to the readme.txt file with the data:
- 'features_info.txt': Shows information about the variables used on the feature vector.

- 'features.txt': List of all features.

- 'activity_labels.txt': Links the class labels with their activity name.

- 'train/X_train.txt': Training set.

- 'train/y_train.txt': Training labels.

- 'test/X_test.txt': Test set.

- 'test/y_test.txt': Test labels.
use the file.path and read.table method for data preparation
create variables

Now merge test and train data

naming data


now merging all data in one data frame

facorize  activity in the data frame using descriptive activity names(actDataNames)

label Course Project Data  with descriptive variable names

generate and export tidy data using plyr package
