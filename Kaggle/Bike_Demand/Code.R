train <- read.csv("D:/R dir/Kaggle/Bike_Demand/train.csv")
test <- read.csv("D:/R dir/Kaggle/Bike_Demand/test.csv")

train_df = train[2:12][1:7650,]
test_df = train[2:12][7651:10886,]



set.seed(1111)
genmod<-gbm(count~season*temp*atemp + humidity + windspeed + holiday*workingday
            ,data=train_df ## registered,casual,count columns
            ,var.monotone=NULL
            ,distribution="gaussian"
            ,n.trees=1200
            ,shrinkage=0.1
            ,interaction.depth=3
            ,bag.fraction = 0.5
            ,train.fraction = 1
            ,n.minobsinnode = 10
            ,cv.folds =10
            ,keep.data=TRUE
            ,verbose=TRUE)

best.iter <- gbm.perf(genmod,method="cv") ##the best iteration number

pred = predict(genmod, test,best.iter,type="response")



write.csv(x =pred, file = "Kagggg5.csv",row.names = FALSE)