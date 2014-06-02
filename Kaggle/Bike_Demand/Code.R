train_df = train[2:12][1:7650,]
test_df = train[2:12][7651:10886,]



fit <- lm(count ~ season*temp*atemp + humidity + windspeed + holiday*workingday, data=train_df)

pred = predict(fit, test)

print(round(pred))

write.csv(x =round(pred), file = "Kagggg3.csv",row.names = FALSE)