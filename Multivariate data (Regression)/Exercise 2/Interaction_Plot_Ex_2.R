wk = loadWorkbook("D:\\R dir\\first ex\\Data Exercise.xlsx")
df = readWorksheet(wk, sheet = "Exercise 2")

attach(df)
pairs(df)
View(df)