# Random Forest Variable Importance bias with catergorical variables

### Exploring the impact of the number of categorical levels on the Gini importance in Random Forests

This is an R based extension of a recent post by RJ Nowling (@discretestates) entitled "Feature Correlation and Feature Importance Bias with Random Forests".

http://rnowling.github.io/machine/learning/2015/08/10/random-forest-bias.html
https://gist.github.com/rnowling/a47f5f61bcf9df61d73e

![alt tag](https://github.com/mrecos/RF_bias_r/blob/master/RF_bias_factor_false.png)
![alt tag](https://github.com/mrecos/RF_bias_r/blob/master/RF_bias_factor_true.png)
![alt tag](https://github.com/mrecos/RF_bias_r/blob/master/RF_accuracy.png)


- description

http://www.inside-r.org/packages/cran/randomForest/docs/importance

type
either 1 or 2, specifying the type of importance measure (1=mean decrease in accuracy, 2=mean decrease in node impurity).

Here are the definitions of the variable importance measures. The first measure is computed from permuting OOB data: For each tree, the prediction error on the out-of-bag portion of the data is recorded (error rate for classification, MSE for regression). Then the same is done after permuting each predictor variable. The difference between the two are then averaged over all trees, and normalized by the standard deviation of the differences. If the standard deviation of the differences is equal to 0 for a variable, the division is not done (but the average is almost always equal to 0 in that case).

The second measure is the total decrease in node impurities from splitting on the variable, averaged over all trees. For classification, the node impurity is measured by the Gini index. For regression, it is measured by residual sum of squares.



this was done as a quick learning example so sloppy coding and other errors may be expected.
If you find it enjoyable, please let me know! @md_harris


