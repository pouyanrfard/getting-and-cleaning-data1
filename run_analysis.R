library(plyr)

###   STEP 1   #####
# Merges the training and the test sets to create one data set.
##################################################


xTrain <- read.table("train/X_train.txt")
yTrain <- read.table("train/y_train.txt")
subjectTrain <- read.table("train/subject_train.txt")

xTest <- read.table("test/X_test.txt")
yTest <- read.table("test/y_test.txt")
subjectTest <- read.table("test/subject_test.txt")

# merge the training and test data set for the variable x into each other
xDataSet <- rbind(xTrain, xTest)

# merge the training and test data set for the variable x into each other
yDataSet <- rbind(yTrain, yTest)

# merge the training and test subject data set into each other
subjectDataSet <- rbind(subjectTrain, subjectTest)


###   STEP 2   #####
# Extracts only the measurements on the mean and standard deviation for each measurement. 
##################################################

features<-read.table("features.txt")["V2"]
activityLabels<-read.table("activity_labels.txt")["V2"]

# find columns  indices associated with mean and standard deviation of the data 
indices_means_stds<-grep("mean|std",features$V2) 

means_std_cols<-colnames(xTest)[indices_means_stds]
X_test_subset<-cbind(subjectTest,yTest,subset(xTest,select=means_std_cols))
X_train_subset<-cbind(subjectTrain,yTrain,subset(xTrain,select=means_std_cols))



###   STEP 3   #####
# Use descriptive activity names to name the activities in the data set
###############################################################################

activityNames <- read.table("activity_labels.txt")

yDataSet[, 1] <- activityNames[yDataSet[, 1], 2]

names(yDataSet) <- "activity"

### STEP 4 #####
# Appropriately label the data set with descriptive variable names
###############################################################################

names(subjectDataSet) <- "subject"

completeData <- cbind(xDataSet, yDataSet, subjectDataSet)


### STEP 5 #####
# Create a second, independent tidy data set with the average of each variable
# for each activity and each subject
###############################################################################

# 66 <- 68 columns but last two (activity & subject)
averageData <- ddply(completeData, .(subject, activity), function(x) colMeans(x[, 1:66]))

write.table(averageData, "tidyData.txt", row.name=FALSE)
