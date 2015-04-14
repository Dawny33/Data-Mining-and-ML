#Loading the the H2o library
library(h2o)

#Starting the H2o instance
LocalH2O = h2o.init(nthreads = -1)

#Importing the Iris dataset into H2O
irisPath = system.file("extdata", "iris_wheader.csv", package = "h2o")
iris.hex = h2o.importFile(LocalH2O, path = irisPath, key = "iris.hex")


#Add function to taking mean of the sepal_len column
fun = function(df) {
  sum(df[,1], na.rm = T)/ nrow(df)
}
h2o.addFunction(LocalH2O, fun)

