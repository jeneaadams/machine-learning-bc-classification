###process gene_exp

#bash:
#cut -d "," -f 17645 geneEpressionDataProcessed.csv > IDs.txt
#cut -d "," -f 3-17644 geneEpressionDataProcessed.csv | paste -d "," IDs.txt - | sed -e "s/^M//g" > geneEpressionDataProcessed_formatted.txt

data <- read.table("Documents/Year2/Semester1/CIS520/final_project/geneEpressionDataProcessed_formatted.txt", head=T, sep=",", row.names = "sample_id")

#rm correlated genes
#https://stackoverflow.com/questions/18275639/remove-highly-correlated-variables
tmp <- cor(data)
tmp[upper.tri(tmp)] <- 0
diag(tmp) <- 0
tmpsq <- tmp**2
data.new <- data[,!apply(tmpsq,2,function(x) any(x > 0.95))]

#rm those with low variance
vars <- c()
for (i in 1:dim(data.new)[2]){
  vars[i] <- var(data.new[,i])
}

hist(vars, breaks = 200)
abline(v = .10, col="red", lwd=2, lty=2)

dropcols <- which(vars<=0.1, arr.ind=T, useNames = T)
rmvar <- data.new[,-c(dropcols)]  

#scale
scaled <- scale(rmvar)
write.table(scaled, "Documents/Year2/Semester1/CIS520/final_project/geneExpressionProcessedRmcorRmlowvarScaled.txt", sep="\t", row.names=T, col.names = NA)
