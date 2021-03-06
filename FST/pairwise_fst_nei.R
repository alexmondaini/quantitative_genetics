# load packages
require(here)
require(gtools)
require(hierfstat)

# and data
load(here('FST','fst_hierfstat.rda'))
fst_hierfstat[1:7,1:7]

# Calculate Pairwise FST values among populations
pairwise_nei_fst <- pairwise.neifst(fst_hierfstat[,-1:-4],diploid = T)

# Transform dataframe
pairwise_nei_fst <- as.data.frame(pairwise_nei_fst)

# Sort accordingly to what we need
pairwise_fst <- pairwise_nei_fst[mixedsort(rownames(pairwise_nei_fst)),mixedsort(colnames(pairwise_nei_fst))]

# save
write.csv(pairwise_fst,here('FST','pairwise_fst.csv'))
