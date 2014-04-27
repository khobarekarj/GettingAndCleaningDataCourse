# Existing Data:
### The input directory UCI_HAR_Dataset has two types of data. 1. train (70% of total data) and 2. test data (remaining 30% of total data). 
### - 'features_info.txt': Shows information about the variables used on the feature vector.
### - 'features.txt': List of all features.
### - 'activity_labels.txt': Links the class labels with their activity name.
### - 'train/X_train.txt': Training set.
### - 'train/y_train.txt': Training labels.
### - 'test/X_test.txt': Test set.
### - 'test/y_test.txt': Test labels.
### - individual files contain the Triaxial acceleration from the accelerometer (total acceleration), the estimated body acceleration and  Triaxial Angular velocity from the gyroscope.

# Tidy DataSet:
### VariableForActivityEachSubject.txt is the average of each variable for each activity and each subject. 
### the rows are variables and the colums are the AcitvitName_SubjectNumber to distinguish between the activities and the subjects
### the data inside is the average computed from the Existing Data for each acivity and each subject.

# Conversion:
### 1. Since only the mean and standard deviation values were required all the column names containing mean() and std() were extracted from the features.txt
### 2. Training data and test data for x and y were combined and stored together
### 3. Subject and activity labels were then stored in this table. Reults can be seen in MergedDataSet.txt in the output directory
### 4. the average of each variable for each activity and each subject was then obtained from the MergedDataSet by using the mean function in R. 
### 5. Intermediate results and more can be seen in the output directory.