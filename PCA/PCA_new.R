require(here)
require(factoextra)

# load numeric hapmap data
load(file = here('hapmap','df.rda'))
df[1:5,1:6]

# load the trial data
trial_df <- read.csv(here('trial_data_cleaning','trial_df.csv'))
head(trial_df)

# all GID feature names in df are unique but not all are unique in trial_df 
# since the same GID has been used across different years and trials.
# Thus we need to exclude the GID that are present in different years to use 
# only which have unique classification for PCA labelling purposes

# confirming all df GID are unique
length(unique(names(df))) == length(names(df))

# Let's start by creating the groups we want to define.
trial_df$group <- trial_df$trial
trial_df$group <- gsub("ES[1-7]$","ES1-7",trial_df$group)
trial_df$group <- gsub("ES[8-9]$|ES1[0-3]$","ES8-13",trial_df$group)
trial_df$group <- gsub("ES1[4-9]$|ES2[0-5]$","ES14-25",trial_df$group)
trial_df$group <- gsub("ES2[6-9]$|ES3[0-8]$","ES26-38",trial_df$group)
trial_df$group <- gsub("SA[1-9]$|SA1[0-2]$","SA1-12",trial_df$group)
trial_df$group <- gsub("SA1[3-9]$|SA2[0-5]$","SA13-25",trial_df$group)
# checking if works
trial_df$group
head(trial_df)

# remove all GID which are replicated.
trial_df <- trial_df[!duplicated(trial_df$GID)&!duplicated(trial_df$GID,fromLast = T),]
# paste GID in front of number for comparison with df GID columns
trial_df$GID <- paste0('GID',trial_df$GID)
#subset by the GID values which are in df
trial_df <- trial_df[trial_df$GID%in%names(df),]

# great now we can value match the vector of GID columns from df(hapmap) to the vector of trial_df$GID
# this will provide us a way to select only the GIDs in df(hapmap) which are not replicated accross years/trials
first_col <- df[,1:4]
names(df)%in%trial_df$GID
df <- df[,names(df)%in%trial_df$GID]
df[1:6,1:7]
row.names(df) <- NULL

# now we may sort the trial_df with the columns of df for later labelling
trial_df <- trial_df[match(names(df),trial_df$GID,),]
row.names(trial_df) <- NULL
head(trial_df)
# check if it worked
all(trial_df$GID==names(df))

# We can start the PCA now, we don't need to scale since allele dosage is in the same unit

pca <- prcomp(t(df))
save(pca,file = here('PCA','pca.rda'))

# we can note that the first 3 PCA do not account for a big variance in the whole data, this is normal with so many features (1879). 
fviz_eig(pca)

groups <- as.factor(trial_df$group)

# First and second PCA
fviz_pca_ind(pca,
             geom = 'point',
             col.ind = groups,
             addEllipses = F,
             legend.title = 'Trials',
             repel = T
             )+
  ggtitle('2D PCA')

# First and third PCA
fviz_pca_ind(pca,
             axes = c(1,3),
             geom = 'point',
             col.ind = groups,
             addEllipses = F,
             legend.title = 'Trials',
             repel = T
)+
  ggtitle('2D PCA')

# Second and third PCA
fviz_pca_ind(pca,
             axes = c(2,3),
             geom = 'point',
             col.ind = groups,
             addEllipses = F,
             legend.title = 'Trials',
             repel = T
)+
  ggtitle('2D PCA')


# Saving
df <- cbind(first_col,df)
#save(df,file = here('PCA','df.rda'))
save(trial_df,file = here('PCA','trial_df.rda'))
save(pca,file = here('PCA','pca.rda'))