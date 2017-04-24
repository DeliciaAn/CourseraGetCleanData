# run_analysis.R
# R script
# Download dataset from:https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip

setwd("/Users/dishaan/Documents/Coursera/DataScience/Course3/FinalProject/UCI HAR Dataset")
getwd()
# Look all the data we have in order to find a way to merge train and test dataset

####### Question1 Merges the training and the test sets to create one data set.
test_sub <- read.table("test/subject_test.txt")
str(test_sub)
test_x <- read.table("test/X_test.txt")
str(test_x)
test_y <- read.table("test/y_test.txt")
str(test_y)

train_sub <- read.table("train/subject_train.txt")
str(train_sub)
train_x <- read.table("train/X_train.txt")
str(train_x)
train_y <- read.table("train/y_train.txt")
str(train_y)

# According to README.txt, we have following data division
# Activity Files:
test_act <- test_y
train_act <- train_y

# Subject Files:
test_sub
train_sub

# Features Files:
test_fea <- test_x
train_fea <- train_x

# Combine test and train
activity <- rbind(test_act, train_act)
subject <- rbind(test_sub, train_sub)
feature <- rbind(test_fea, train_fea)

# Get the name for these three data
names(activity) <- "Activity"
names(subject) <- "Subject"
# Names of features we can get from features.txt
features_raw <- read.table("features.txt")
names(feature) <- features_raw$V2

# Combine the three together
question1 <- cbind(cbind(activity, subject), feature)
head(question1)


############ Question 2
# Extract mean and std, giving the index of the features that have mean and std
index <- grep(".*mean.*|.*std.*", features_raw$V2)
index

# Extract these data
q2feature <- feature[,index]
names(q2feature) <- features_raw[index, 2]

# Combine all the columns together
question2 <- cbind(cbind(activity, subject), q2feature)
head(question2)



########## Question 3
## Uses descriptive activity names to name the activities in the data set
head(question1)
activity_labels <- read.table("activity_labels.txt")
activity_labels <- activity_labels$V2
for (i in (1:length(activity_labels))){
    question1$Activity[question1$Activity==i] <- as.character(activity_labels[i])
}
head(question1)



########## Question 4
## Appropriately labels the data set with descriptive variable names.
# According to features_info.txt, I find several variables are needed to change
# t -> time
# Acc -> Accelerometer
# Gyro -> Gyroscope
# f -> frequency
# Mag -> Magnitude
# BodyBody -> Body
temp <- gsub("^t","time", question1)
temp <- gsub("Acc","Accelerometer", temp)
temp <- gsub("Gyro","Gyroscope", temp)
temp <- gsub("f","frequency", temp)
temp <- gsub("Mag","Magnitude", temp)
temp <- gsub("BodyBody","Body", temp)
question4_name <- temp
names(question1)[3:length(names(question1))] <- question4_name
data_4 <- question1


###########Question 5
#From the data set in step 4, creates a second, 
#independent tidy data set with the average of each variable
#for each activity and each subject.
library(plyr)
data_5 <- aggregate(.~Subject + Activity, data_4, mean)
tidy_data <- data_5
write.table(tidy_data, "tidy.txt", row.names = FALSE, quote = FALSE)



