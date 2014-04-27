run_analysis <- function(directory_input, directory_output)
{	
	# Read features from the feature file 
	all_cols <- read.table(paste(directory_input,"/features.txt",sep = "", collapse = NULL), header=FALSE)

	# features having mean()
    meanData <- subset(all_cols, grepl("mean()", all_cols$V2, fixed=TRUE), drop = FALSE)
    # features having std()
    stdData <- subset(all_cols, grepl("std()", all_cols$V2, fixed=TRUE), drop = FALSE)
    # msData is combination of mean and standard deviation colums
	msData <- rbind(meanData,stdData)

	# Storing data from only mean and std columns from x
	data_x_train <- read.table(paste(directory_input,"/train/X_train.txt",sep = "", collapse = NULL), header=FALSE)[,sort(msData$V1)]
	data_x_test  <- read.table(paste(directory_input,"/test/X_test.txt",sep = "", collapse = NULL), header=FALSE)[,sort(msData$V1)]
	
	setnames(data_x_train, c(paste("V",msData$V1,sep="")),c(as.character(msData$V2)))
	setnames(data_x_test, c(paste("V",msData$V1,sep="")),c(as.character(msData$V2)))
	
	DXTrain <- data.table(data_x_train)
	DXTest  <- data.table(data_x_test)
	
	# Storing data from only mean and std columns from y
	data_y_train <- read.table(paste(directory_input,"/train/y_train.txt",sep = "", collapse = NULL), header=FALSE, col.names="Position")
	data_y_test  <- read.table(paste(directory_input,"/test/y_test.txt",sep = "", collapse = NULL), header=FALSE, col.names="Position")
	 
	DYTrain <- data.table(data_y_train)
	DYTest  <- data.table(data_y_test)
	 
	data_subject_train <- read.table(paste(directory_input,"/train/subject_train.txt",sep = "", collapse = NULL), header=FALSE, col.names="Patient")
	data_subject_test  <- read.table(paste(directory_input,"/test/subject_test.txt",sep = "", collapse = NULL), header=FALSE, col.names="Patient")
	 
	DSTrain <- data.table(data_subject_train)
	DSTest  <- data.table(data_subject_test)
	 
	# Combine all columns in test data and train data
	data_train_combine <- cbind(DSTrain, DXTrain, DYTrain)
	data_test_combine  <- cbind(DSTest, DXTest, DYTest)
	all_data_combine <- rbind(data_train_combine, data_test_combine)
	 
	# Extracting activity labels
	activity_lables <- read.table(paste(directory_input,"/activity_labels.txt",sep = "", collapse = NULL), header=FALSE)
	Activity_Label <- data.table(activity_lables)
	setnames(Activity_Label,c(1,2),c("Position", "Activity"))

	setkey(all_data_combine, Position);
	setkey(Activity_Label,Position)
	merged <- merge(all_data_combine, Activity_Label)
	meltedData <- melt(merged, id=c("Activity", "Position", "Patient"), measure.vars=c(as.character(msData$V2)))
	
	#variable for each activity
	varPerPosition <- dcast(meltedData, variable ~ Activity, mean)
	#variable for each subject
	varPerPatient <- dcast(meltedData, variable ~ Patient, mean)
	#variable for each activity and each subject
	varPerActivityPerPatient <- dcast(meltedData, variable ~ Activity + Patient, mean)
	 
	# Writing to file
	write.table(meltedData, file = paste(directory_output,"/MergedDataSet.txt",sep = "", collapse = NULL), append = FALSE, quote = TRUE, sep = ",",
            eol = "\n", na = "NA", dec = ".", row.names = FALSE,
            col.names = TRUE, qmethod = c("escape", "double"))
	write.table(varPerPosition, file = paste(directory_output,"/VariableForEachActivity.txt",sep = "", collapse = NULL), append = FALSE, quote = TRUE, sep = ",",
            eol = "\n", na = "NA", dec = ".", row.names = FALSE,
            col.names = TRUE, qmethod = c("escape", "double"))
	write.table(varPerPatient, file = paste(directory_output,"/VariableForEachSubject.txt",sep = "", collapse = NULL), append = FALSE, quote = TRUE, sep = ",",
            eol = "\n", na = "NA", dec = ".", row.names = FALSE,
            col.names = TRUE, qmethod = c("escape", "double"))
	write.table(varPerActivityPerPatient, file = paste(directory_output,"/VariableForActivityEachSubject.txt",sep = "", collapse = NULL), append = FALSE, quote = TRUE, sep = ",",
            eol = "\n", na = "NA", dec = ".", row.names = FALSE,
            col.names = TRUE, qmethod = c("escape", "double"))
}

