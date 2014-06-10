library(xlsx)
library(ggplot2)


df <- read.xlsx("D:\\R dir\\WB_Poverty\\Custom Data.xlsx", sheetName = "Sheet1")

#plot(df$Year, df$Poverty.Gap)

df = df

p <- ggplot(df, aes(Year, GNI))+geom_point(colour='steelblue')
p <- p + geom_point(aes(size = Poverty.HCR.National.*10))
print(p)