require(here)

es <- read.csv(file = here('trial_data_cleaning','ES_all_1.csv'))
head(es)
names(es)

sa <- read.csv(file = here('trial_data_cleaning','SA_all_1.csv'),sep = ';')
head(sa)
names(sa)


# I just need few columns from this data

es <- es[c('trial','CID','SID','GID','TID')]

sa <- sa[c('trial','CID','SID','GID','TID')]
sa

trial_df <- rbind(es,sa)
trial_df

# Look for duplicated entries
trial_df[duplicated(trial_df)|duplicated(trial_df,fromLast = T),]

# Let's remove them

trial_df <- trial_df[!(duplicated(trial_df)),]

write.csv(trial_df,file = here('trial_data_cleaning','trial_df.csv'),row.names = F)