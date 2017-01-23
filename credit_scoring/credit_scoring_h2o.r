	library(h2o)
	h2o.init()
	
# read comma separated file into h2o cluster http://freakonometrics.free.fr/german_credit.csv

	data<-h2o.importFile("F:/git/credit_scoring/german_credit.csv")

#### Exploratory Data Analysis ######


	h2o.head(data)      ## Returns the first rows of an H2OFrame object. Useful to inspect the data
	
### Describe the data ###
### Provides information about column types, mins/maxs/missing/zero counts/stds/number of levels of the variables
	h2o.describe(data)  

### Convert Numeric to Categorical ###

	to_factors <- c(1,2,4,5,7,8,9,10,11,12,13,15,16,17,18,19,20)
	for(i in to_factors) data[,i] <- h2o.asfactor(data[,i])

	h2o.describe(data)    # Describe again to validate the column information
 
### Summarize the dara ## 
### Displayes the minimum, 1st quartile, median, mean, 3rd quartile and maximum for each numeric column, and the levels and 
### category counts of the levels in each categorical column.

	h2o.summary(data)    
 
### Display the structure of an H2OFrame object ##
	h2o.str(data)  
	
### Performs a group by and apply similar to ddply. ##

	h2o.group_by(data, by="Creditability",nrow("Creditability"))  
	
### Compute a histogram over a numeric column. You can also use the positional notion
### to refer the column such as h2o.hist(data[,6])   	
 
	h2o.hist(data[,"Credit Amount"])  
###Compute the logarithm on the Credit Amount of an H2OFrame object.    
								   
	h2o.log(data[,"Credit Amount"])   #Here we just validate if the values are properly transformed to their logs
	
### Apply log to every value of Credit Amount
### and create a new variables credit_amount_trnsf 

    data$credit_amount_trnsf <- apply(data[,"Credit Amount"],1,h2o.log) 
	 data$credit_amount_trnsf <- h2o.log(data[,"Credit Amount"])
	h2o.hist(data$credit_amount_trnsf)

### Define  Creditability ( Good/Bad credit) as the Target for modeling. 
	target <- "Creditability"   
	
### Everything other than the target are the predictors
	features <- setdiff(h2o.colnames(data), c("Creditability")) 

    print(target)
    print(features)

### Partition the data into training(60%) and test set(40%). 
### setting a seed will guarantee reproducibility

    credit_samples <- h2o.splitFrame(data, c(0.6), seed=1) 
    credit_train <- credit_samples[[1]]                    
    credit_test  <- credit_samples[[2]]

### Now that we have prepared our data, let us train some models.
### We will start by training a h2o.glm model

	glm_model1 <- h2o.glm(x = features, 
						  y = target, 
						  training_frame = credit_train,
						  model_id = "glm_model1",
                         family = "binomial")
					
###Evaluate the model summary	
				
	print(summary(glm_model1))

###Evaluate model performance on test data

	perf_obj <- h2o.performance(glm_model1, newdata = credit_test) 
	h2o.accuracy(perf_obj, 0.95)
	
	pred_creditability <- h2o.predict(glm_model1,credit_test)