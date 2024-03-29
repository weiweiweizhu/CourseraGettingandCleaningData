options(stringsAsFactors = FALSE)

# Load the feature list
features <- read.table("features.txt")
colnames(features) <- c("colnum", "measurement")

# Extract features of interest
interesting_cols <- features[grepl("-(mean|std)\\(\\)", features$measurement),]

# Load volunteers
subject_test  <- read.table("test/subject_test.txt")
subject_train <- read.table("train/subject_train.txt")
subject_full  <- rbind(subject_train, subject_test)

# Load X values
x_test  <- read.table("test/X_test.txt")
x_train <- read.table("train/X_train.txt")
# Merge them into one single dataframe
x_full  <- rbind(x_train, x_test)

# Only keep values from columns of interest
x_filtered <- x_full[interesting_cols[,1]]

# Load activity labels
y_test  <- read.table("test/y_test.txt",   colClasses = c("character"))
y_train <- read.table("train/y_train.txt", colClasses = c("character"))
# Merge them into one single dataframe
y_full  <- rbind(y_train, y_test)

# Replace labels with more descriptive names
activity_labels <- read.table("activity_labels.txt")
for (i in 1:length(activity_labels[,1])) {
        y_full[y_full==activity_labels[i,1]] <- activity_labels[i,2]
}

# Merge everything together
dataframe <- cbind(subject_full, y_full, x_filtered)
colnames(dataframe) <- c("volunteer", "activity", interesting_cols[,2])
write.table(dataframe, "tidy.txt", row.names=FALSE)

tidy_means <- aggregate(dataframe[, 3:ncol(dataframe)], list(dataframe$volunteer, dataframe$activity), mean)
names(tidy_means)[1] <- "volunteer" # rename groups
names(tidy_means)[2] <- "activity"  # rename groups
write.table(tidy_means, "tidy_means.txt", row.names=FALSE)

