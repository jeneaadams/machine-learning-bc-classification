###########################################
## Code to perform and plot PCA and UMAP ##
###########################################
library(tidyverse)
library(ggfortify)
library(umap)

setwd("~/Desktop/CIS520/final_project/")

ge <- read_tsv("geneExpressionProcessedRmcorRmlowvarScaled.txt")
ge <- ge %>% 
  rename(bcr_patient_barcode = X1)
clin <- read_csv("clinicalDataProcessed.csv")

# PCA
ge_pca <- prcomp(ge %>% select(-bcr_patient_barcode))
autoplot(ge_pca, data = clin, colour = "category", title = "PCA")

# UMAP
ge_umap <- umap(ge %>%  select(-bcr_patient_barcode))
ge_umap_p <- data.frame(x = ge_umap$layout[,1],
                        y = ge_umap$layout[,2],
                        cat = clin$category)

ggplot(ge_umap_p, aes(x, y, colour = cat)) +
  geom_point() + 
  labs(x = "", y = "")



# merge <- clin %>% 
#   select(bcr_patient_barcode, category) %>% 
#   inner_join(ge, by = 'bcr_patient_barcode')
# 
# write.csv(merge, "merge.csv", row.names = FALSE)
