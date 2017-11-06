library(h2o)
h2o.init()
mtcar <- read.csv("F:/h20/predicitve_mantainance/auto_design.csv")
mtcar$gear <- as.factor(mtcar$gear)  
mtcar$carb <- as.factor(mtcar$carb) 
mtcar$cyl <- as.factor(mtcar$cyl)  
mtcar$vs  <- as.factor(mtcar$vs)  
mtcar$am  <- as.factor(mtcar$am)
mtcar$ID  <- 1:nrow(mtcar)  
mtcar.hex  <- as.h2o(mtcar)
# Use a bigger DNN
mtcar.dl = h2o.deeplearning(x = 1:10, training_frame = mtcar.hex, autoencoder = TRUE,
                            hidden = c(50, 50, 50), epochs = 100)
# Turn results into a normal R data frame
err <- as.data.frame(h2o.anomaly(mtcar.dl, mtcar.hex, per_feature = FALSE))	
# Plot 
plot(sort(err$Reconstruction.MSE), main='Reconstruction Error')						