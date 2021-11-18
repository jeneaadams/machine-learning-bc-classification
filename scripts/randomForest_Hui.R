#Daniel Hui
#CIS520
#Final Project
#December 10, 2020


#################
# train all RFs #
#################
library(randomForest)
for (set in c(1,2,3,4,5)){
  train <- read.table(paste("Documents/Year2/Semester1/CIS520/final_project/cv_data/train_", set, ".csv", sep=""), sep=",", head=T)
  val <- read.table(paste("Documents/Year2/Semester1/CIS520/final_project/cv_data/val_", set, ".csv", sep=""), sep=",", head=T)
  
  x_train <- as.data.frame(train[-c(1:3)])
  y_train <- as.vector(train[c(3)])
  
  x_val <- as.data.frame(val[-c(1:3)])
  y_val <- as.vector(val[c(3)])
  
  for (m in c(10, 50, 132, 500, 1000, 2500)){
    rf <- randomForest(x=x_train, y=y_train[,1], xtest = x_val, ytest = y_val[,1], keep.forest = TRUE, mtry=m)
    save(rf, file=paste("Documents/Year2/Semester1/CIS520/final_project/rfs/rf_set", set, "_", m, ".Rdata", sep=""))
    print(paste("done test", set, " m", m, sep=""))
  }
}
    


#############################################
# get best performing RF per validation set #
#############################################
library(caret)

for (set in c(1,2,3,4,5)){
  val <- read.table(paste("Documents/Year2/Semester1/CIS520/final_project/cv_data/val_", set, ".csv", sep=""), head=T, sep=",")
  x_val <- as.data.frame(val[-c(1:3)])
  y_val <- as.vector(val[c(3)])
  
  print(paste("Set:", set))
  for (m in c(10, 50, 132, 500, 1000, 2500)){
    print(m)
    load(paste("Documents/Year2/Semester1/CIS520/final_project/rfs/rf_set", set, "_", m, ".Rdata", sep=""), rfLoad <- new.env())
    preds <- predict(rfLoad$rf, x_val)
    print(sum(preds == y_val[,1]) / length(preds))
  }
}

m10 <- c(0.7625899, 0.7625899, 0.7697842, 0.7553957, 0.7553957)
m50 <- c(0.7913669, 0.7697842, 0.7985612, 0.7553957, 0.7769784)
m132 <- c(0.8129496, 0.7769784, 0.8201439, 0.8057554, 0.7913669)
m500 <- c(0.8561151, 0.7913669, 0.8561151, 0.8129496, 0.8057554)
m1000 <- c(0.8489209, 0.7913669, 0.8633094, 0.8201439, 0.8273381)
m2500 <- c(0.8633094, 0.7985612, 0.8633094, 0.8345324, 0.8345324)

sd(m2500)
mean(m2500)

#confusionMatrix(preds, y_test1[,1])


means <- c(mean(m10), mean(m50), mean(m132), mean(m500), mean(m1000), mean(m2500))
sds <- c(sd(m10), sd(m50), sd(m132), sd(m500), sd(m1000), sd(m2500))
mtrys <- c(10, 50, 132, 500, 1000, 2500)

accs <- as.data.frame(cbind(mtrys, means, sds))

ggplot(accs, aes(x=as.factor(mtrys), y=means, group=1)) + 
  geom_line()+
  geom_pointrange(aes(ymin=means-sds, ymax=means+sds)) +
  theme_classic() +
  scale_y_continuous(name="Validation set mean +/- SD", limits=c(.75, .875)) + xlab("Number of variables per tree")
  

######################################
# output stats for chosen RF per set #
######################################
train <- read.table(paste("Documents/Year2/Semester1/CIS520/final_project/cv_data/val_", set, ".csv", sep=""), head=T, sep=",")

for (set in c(1,2,3,4,5)){
  print(paste("Set:", set))
  
  load(paste("Documents/Year2/Semester1/CIS520/final_project/rfs/rf_set", set, "_2500.Rdata", sep=""), rfLoad <- new.env())
  
  train <- read.table(paste("Documents/Year2/Semester1/CIS520/final_project/cv_data/train_", set, ".csv", sep=""), head=T, sep=",")
  test <- read.table(paste("Documents/Year2/Semester1/CIS520/final_project/cv_data/test_", set, ".csv", sep=""), head=T, sep=",")
  
  x_train <- as.data.frame(train[-c(1:3)])
  y_train <- as.vector(train[c(3)])
  
  x_test <- as.data.frame(test[-c(1:3)])
  y_test <- as.vector(test[c(3)])
  
  preds <- predict(rfLoad$rf, x_train)
  print(sum(preds == y_train[,1]) / length(preds))
  
  preds <- predict(rfLoad$rf, x_test)
  print(sum(preds == y_test[,1]) / length(preds))
}

#[1] "Set: 1"
#[1] 1
#[1] 0.8273381
#[1] "Set: 2"
#[1] 1
#[1] 0.8561151
#[1] "Set: 3"
#[1] 1
#[1] 0.8129496
#[1] "Set: 4"
#[1] 1
#[1] 0.8273381
#[1] "Set: 5"
#[1] 1
#[1] 0.8417266

tests <- c(0.8273381, 0.8561151, 0.8129496, 0.8273381, 0.8417266)
mean(tests)
sd(tests)
trains #all 1



###############################################
# testing accuracy per subclass for mtry 2500 #
###############################################
library(dplyr)

for (set in c(1,2,3,4,5)){
  print(paste("Set:", set))
  test <- read.table(paste("Documents/Year2/Semester1/CIS520/final_project/cv_data/test_", set, ".csv", sep=""), head=T, sep=",")
  for (cancer in c("her2Enriched", "luminalA", "luminalB", "tripleNegative")){
    print(cancer)
    y_test <- as.vector(test[c(3)])
    bool <- y_test == cancer
  
    x_test <- as.data.frame(test[-c(1:3)])
    rows_x <- x_test[bool,]
    rows_y <- y_test[bool,]
  
    preds <- predict(rfLoad$rf, rows_x)
    print(sum(preds == rows_y) / length(preds))
    print(sum(preds == rows_y))
    print(length(preds))
  }
}


##[1] "Set: 1"
#[1] "her2Enriched"
#[1] 1
#[1] 6
#[1] 6
#[1] "luminalA"
#[1] 0.9545455
#[1] 84
#[1] 88
#[1] "luminalB"
#[1] 0.7727273
#[1] 17
#[1] 22
#[1] "tripleNegative"
#[1] 1
#[1] 23
#[1] 23
#[1] "Set: 2"
#[1] "her2Enriched"
#[1] 0.5
#[1] 3
#[1] 6
#[1] "luminalA"
#[1] 0.9885057
#[1] 86
#[1] 87
#[1] "luminalB"
#[1] 0.9090909
#[1] 20
#[1] 22
#[1] "tripleNegative"
#[1] 1
#[1] 24
#[1] 24
#[1] "Set: 3"
#[1] "her2Enriched"
#[1] 0.6666667
#[1] 4
#[1] 6
#[1] "luminalA"
#[1] 0.9772727
#[1] 86
#[1] 88
#[1] "luminalB"
#[1] 0.7727273
#[1] 17
#[1] 22
#[1] "tripleNegative"
#[1] 1
#[1] 23
#[1] 23
#[1] "Set: 4"
#[1] "her2Enriched"
#[1] 0.8333333
#[1] 5
#[1] 6
#[1] "luminalA"
#[1] 0.9772727
#[1] 86
#[1] 88
#[1] "luminalB"
#[1] 0.6363636
#[1] 14
#[1] 22
#[1] "tripleNegative"
#[1] 0.9565217
#[1] 22
#[1] 23
#[1] "Set: 5"
#[1] "her2Enriched"
#[1] 0.5
#[1] 3
#[1] 6
#[1] "luminalA"
#[1] 0.9431818
#[1] 83
#[1] 88
#[1] "luminalB"
#[1] 0.4545455
#[1] 10
#[1] 22
#[1] "tripleNegative"
#[1] 0.9130435
#[1] 21
#[1] 23