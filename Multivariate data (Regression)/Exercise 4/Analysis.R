wk = loadWorkbook("D:\\R dir\\first ex\\Data Exercise.xlsx")
df = readWorksheet(wk, sheet = "Sheet 1")

head(df)
attach(df)
pairs(df)


wk2 = loadWorkbook("D:\\R dir\\first ex\\Data Exercise.xlsx")
df2 = readWorksheet(wk, sheet = "Exercise 4")

pca <- prcomp(df)

dim(pca$x)

reg <- lm(df2$outcome ~ pca$x[,1] + pca$x[,2] + pca$x[,3] + pca$x[,4] + pca$x[,5])


