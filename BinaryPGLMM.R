#binaryPGLMM model from Palmer Foster 2022
setwd("C:/Users/jdpal/Documents/R/ToxinStats")
library(ape)

#Set file name to correspond to F_DD0_v1.csv for main model.  F_Strict_v1.csv for the strict model.
dater <- read.csv("F_Strict.csv", row.names = 1, header = TRUE)
#Load phylogeny based on 16S
phylo <- read.nexus("Phylo168_v1.nexus")
#Run model
model_simple_f <- binaryPGLMM(formula = DDR~as.factor(Spectr), phy = phylo, data = dater)
#Output results
model_simple_f
