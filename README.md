# An Assessment of Machine Learning Classifiers for Breast Cancer Subtype Prediction
## Jenea Adams, Daniel Hui, Jacob Leiby, Vivek Sriram


Breast cancer is the most common cancer in women worldwide and causes over 500,000 deaths per year. Breast cancers can be categorized into immunohistochemistry subtypes based on cell surface proteins. However, IHC subtyping is prone to error. Recent studies have shown that gene expression data from tumors can be used to categorize the subtypes more effectively and consistently. Here, we perform IHC subtype classification with gene expression data from TCGA BRCA cohort using regularized logistic regression, random forests, support vector machines, gradient boosting, and neural networks. We found that L1 regularized logistic regression shows the best performance.

The full report can be read [here](https://github.com/jeneaadams/machine-learning-bc-classification/blob/main/Full%20Report%20Draft%20.pdf). 

## Methods at a glance 
We decided to evaluate five different methods (logistic regression, random forests, support vector machines, gradient boosting, and neural networks) in terms of their average accuracy performance in classifying breast cancer subtypes.


[Logistic Regression](~/Adams_LogisticRegression_CIS520.ipynb) 

[Random Forest](~/randomForest_Hui.R) 

[SVM](~/CIS520_final_SVMandGB_Sriram.ipynb)

[Gradient Boosting](~/CIS520_final_SVMandGB_Sriram.ipynb) 

[Neural Net](~/CIS520_final_neural_net.ipynb)



## Data
Data were acquired from The Cancer Genome Atlas (TCGA) program BRCA cohort [https://www.cancer.gov/tcga] on November 13, 2020 via FireBrowser [http://firebrowse.org/].


## Results at a glance

We can see from our results that **logistic regression and random forest perform the best** in terms of testing accuracies out of our classifiers. Notably, random forest has the highest test accuracy for the Luminal A and Triple Negative groups, which have the clearest distributions in the PCA and UMAP plots earlier on. However, overall logistic regression works the best in its total test accuracy, out-performing other classifiers in the HER-2 enriched group as well as the Luminal B group.

## Jenea's role 
I trained the logistic regression dataset, tested the other methods, wrote the Abstract, Related Work, Methods 6.2, Results, 7.1, and the Conclusion & Discussion. 
