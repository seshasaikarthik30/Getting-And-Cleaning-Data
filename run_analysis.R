library(dplyr)

#read train data
X_train <- read.table("~/getdata_projectfiles_UCI HAR Dataset (2)/UCI HAR Dataset/train/X_train.txt")
y_train <- read.table("~/getdata_projectfiles_UCI HAR Dataset (2)/UCI HAR Dataset/train/y_train.txt")
subject_train <- read.table("~/getdata_projectfiles_UCI HAR Dataset (2)/UCI HAR Dataset/train/subject_train.txt")

#read test data
X_test <- read.table("~/getdata_projectfiles_UCI HAR Dataset (2)/UCI HAR Dataset/test/X_test.txt")
y_test <- read.table("~/getdata_projectfiles_UCI HAR Dataset (2)/UCI HAR Dataset/test/y_test.txt")
subject_test <- read.table("~/getdata_projectfiles_UCI HAR Dataset (2)/UCI HAR Dataset/test/subject_test.txt")

#read data description
variable_names <- read.table("~/getdata_projectfiles_UCI HAR Dataset (2)/UCI HAR Dataset/features.txt")

#read activity labels
activity_labels <- read.table("~/getdata_projectfiles_UCI HAR Dataset (2)/UCI HAR Dataset/activity_labels.txt")

# Merges the training and the test sets to create one data set.
X_total <- rbind(X_train, X_test)
Y_total <- rbind(y_train, y_test)
sub_total <- rbind(subject_train, subject_test)

# Extracts only the measurements on the mean and standard deviation for each measurement.
selected_var <- variable_names[grep("mean\\(\\)|std\\(\\)",variable_names[,2]),]
X_total <- X_total[,selected_var[,1]]

#  Uses descriptive activity names to name the activities in the data set
colnames(Y_total) <- "activity"
Y_total$activitylabel <- factor(Y_total$activity, labels = as.character(activity_labels[,2]))
activitylabel <- Y_total[,-1]

# Appropriately labels the data set with descriptive variable names.
colnames(X_total) <- variable_names[selected_var[,1],2]

# From the data set in step 4, creates a second, independent tidy data set with the average
# of each variable for each activity and each subject.
colnames(sub_total) <- "subject"
total <- cbind(X_total, activitylabel, sub_total)
total_mean <- total %>% group_by(activitylabel, subject) %>% summarize_each(funs(mean))
write.table(total_mean, file = "~/getdata_projectfiles_UCI HAR Dataset (2)/UCI HAR Dataset/tidydata.txt", row.names = FALSE, col.names = TRUE)


