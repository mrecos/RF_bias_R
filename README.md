# Random Forest Variable Importance bias with categorical variables

### Exploring the impact of the number of categorical levels on the Gini importance in Random Forests

This is an R based extension of a recent post by RJ Nowling (@discretestates) entitled "Feature Correlation and Feature Importance Bias with Random Forests".
The blog [post](http://rnowling.github.io/machine/learning/2015/08/10/random-forest-bias.html) and [Python code (GitHub)](https://gist.github.com/rnowling/a47f5f61bcf9df61d73e)
were provided.  Generally, the premise of Nowling's post is to recreate the findings of [Strobl, et al.](http://www.biomedcentral.com/1471-2105/8/25)
and [Altmann, et al.](http://bioinformatics.oxfordjournals.org/content/26/10/1340.short) indicating that the number of levels in a categorical variable has a direct effect ont the Gini importance of that variable; as measured by the variable importance in the Random Forest algorithm.
A finding of Nowling's post is that the positive correlation between importance and number of levels is only present when levels are encoded as integers indicating each level in a variable.  For example if a categorical variable has 5 levels, then it is encoded as either 0,1,2,3, or 4.
 
This is opposed to what Nowling calls [One-hot encoding](https://en.wikipedia.org/wiki/One-hot) where each level is split into its own binary variable such that a variable with 5 levels would result in 5 new variables with either 0 or 1 indicating the presence of that level. This is similar to an indicator variable typical to model building, but even there is no reference level.

#### My intention was simply to recreate this in R and see if the bias of categorical variable level count on Gini importance persisted.  Being that I am not interested in the issue of encoding, I skipped the On-hot encoding and only worked with integer encoding

To do so, I reviewed Nowling's Python code and recreated it in R trying to keep variable names and the general approach the same; obvious differences result from translation.
Also, I included two additional switches, 1) "asFactor" to switch between true integer representation of the categorical variable level and the conversion of the variable into a factor; and 2) varImp_type that switches between the two types of variable importance in the Random Forest implementation; 1 = decrease in accuracy, 2 = node purity (Gini importance).
These two switches have additional effects on the results demonstrated by Nowling.  In general, the code creates a matrix of p simulated variables where each pth variable has p + 1 categories; as run here, the first variable has 2 categories in the first variable and 32 categories in the final variable.
The category for each of the n observations (n = 1000) is selected randomly. Finally, a response variable is created as a randomly sampled 1 or 0 independent of the X variables and both X and y are put into a dataframe with the X converted to factors if the option is used. The creation of this matrix is done within the 'generate_stacked()` function.

This function is then called to retrieve a simulated matrix (as data.frame) and fit with `randomForest()` to the outcome labels using ntrees = 100 and importance = TRUE.  The `importance()` function extracts the Gini importance if varImp_type is set to 2 or the mean decrease in accuracy per node if varImp_type is set to 1. The documentation for these two measures of variable importance is included below the figures.
This routine is run N_SIMS times (N_SIMS = 100) with the results collected in a `variable_importances` object ti be plotted with GGplot2.

#### Essentially, the results are that by having categories defined as integers and using the Gini importance as measure, Nowling's findings are repeated.  Interestingly, when asFactor = TRUE and the categories are encoded are factor levels, the effect is still positive, but changes at a different rate with the increase in factor level count.  Finally, when the measure of variable importance is the mean decrease in node accuracy (varImp_type = 1), there is no effect or bias on importance. 

In the first example, the switches are set to asFactor = FALSE and varImp_type = 2.  This is the closest match to Nowling's results.  Note the generally logarithmic rate of increased importance with the increase in categories. 
![alt tag](https://github.com/mrecos/RF_bias_r/blob/master/graphics/RF_bias_factor_false.png)
 
In the second example, the options are asFactor = TRUE and varImp_type = 2, such that the categories are coerced to the factor data type and categories are represented as levels.  Note the different rate of increase given the number of factor levels versus categories as integers.
![alt tag](https://github.com/mrecos/RF_bias_r/blob/master/graphics/RF_bias_factor_true.png)

Finally, the measure of importance is set to mean decrease in node accuracy (varImp_type = 1) and the bias is no longer observed.  This is the same whether categories are integers or factors.
![alt tag](https://github.com/mrecos/RF_bias_r/blob/master/graphics/RF_accuracy.png)

#### Details on the two types of Random Forest variable importance measures
[documentation](http://www.inside-r.org/packages/cran/randomForest/docs/importance)

type:
either 1 or 2, specifying the type of importance measure (1=mean decrease in accuracy, 2=mean decrease in node impurity).

Here are the definitions of the variable importance measures. The first measure is computed from permuting OOB data: For each tree, the prediction error on the out-of-bag portion of the data is recorded (error rate for classification, MSE for regression). Then the same is done after permuting each predictor variable. The difference between the two are then averaged over all trees, and normalized by the standard deviation of the differences. If the standard deviation of the differences is equal to 0 for a variable, the division is not done (but the average is almost always equal to 0 in that case).

The second measure is the total decrease in node impurities from splitting on the variable, averaged over all trees. For classification, the node impurity is measured by the Gini index. For regression, it is measured by residual sum of squares.


Disclaimer: This was done as a relatively quickly learning example so sloppy coding and other errors may be present. Please let me know if you find anything detrimental.
If you find it enjoyable, please let me know! @md_harris


