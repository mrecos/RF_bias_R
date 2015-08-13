require(randomForest)
require(ggplot2)
require(reshape2)

generate_stacked <- function(n_samples, max_categories, asFactor){
  n_features <- max_categories - 1 
  features <-  data.frame(mat.or.vec(n_samples, n_features))
  labels <- rep(0, n_samples)
  for(r in 1:n_samples){
    labels[r] <- sample(c(0,1),1)
    for(c in 1:n_features){
      n_categories <- c + 1 
      features[r, c] <- sample(c(0:(n_categories - 1)), 1)
    }
  }
  if(isTRUE(asFactor)){
    features[] <- lapply(features, factor)
  }
  return(data.frame(features, y = as.factor(labels)))
}

N_SAMPLES <- 1000
N_TREES <- 100
MAX_CATEGORIES <- 32
N_SIMS <- 100
asFactor <- FALSE
varImp_type <- 2
ylab_title <- ifelse(varImp_type == 2, "Gini Importance", "Decreased Accuracy")

variable_importances = mat.or.vec(N_SIMS, (MAX_CATEGORIES - 1))
for(i in 1:N_SIMS){
  message(paste(c("Round", i, "\n"), collapse =' '))
  Xy <- generate_stacked(N_SAMPLES, MAX_CATEGORIES, asFactor)
  rf.fit <- randomForest(x = Xy[1:(MAX_CATEGORIES - 1)], 
                         y = Xy$y, ntrees = N_TREES,
                         importance=TRUE)
  feature_importances <- t(importance(rf.fit, type = varImp_type))
  variable_importances[i,] <- as.numeric(feature_importances)
}

varImp_melt <- melt(variable_importances)
ggplot(varImp_melt, aes(y = value, x = Var2, group = Var2 )) +
  geom_boxplot(outlier.colour = "blue", outlier.shape = 3, colour = "blue") +
  stat_summary(geom = "crossbar", width=0.75, fatten=2, 
               color="red", 
               fun.data = function(x){ return(c(y=median(x), ymin=median(x), ymax=median(x)))}) +
  ggtitle(paste(c("Variable Importance by number of levels. as.factor = ", asFactor), collapse='')) +
  xlab("Variable") + 
  ylab(ylab_title) +
  scale_x_discrete(breaks = seq(1,(MAX_CATEGORIES - 1),1), 
                   labels = seq(1,(MAX_CATEGORIES - 1),1)) +
  theme_bw()