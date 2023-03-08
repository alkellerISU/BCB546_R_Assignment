# R Assignment: replicate UNIX assignment in R
# data inspection and creating same files as in UNIX assignment
# part 3: Visualization of data
# part 4: review two assignments from your peers (using github)
# common mistakes, don't use links to files on your computer, don't use objects that you don't state to create

library(tidyverse)
dvst
str(dvst)
dvst <- read_csv("https://raw.githubusercontent.com/vsbuffalo/bds-files/master/chapter-08-r/Dataset_S1.txt")
summary(select(dvst,`total SNPs`))
# Here we also used `select` function. We'll talk about it soon.
filter(dvst,`total SNPs` >= 85)
# only gives the rows that have total SNPs greater than or equal to 85 (3 rows total)
filter(dvst, Pi > 16, `%GC` > 80)
# can filter more than one variable at once and get the rows for the objects that matches those variables
# dyplr by default does not modify your data
new_df <- filter(dvst, Pi > 16, `%GC` > 80)
# only makes new ojbect but does not print output
(new_df <- filter(dvst, Pi > 16, `%GC` > 80))
# makes new object and prints the output
filter(dvst, `total SNPs` %in% c(0,1,2))
# gives output of all values in total SNPs that equal 0,1,or 2
mutate(dvst, cent = start >= 25800000 & end <= 29700000)
# creates new column but will not add it to the origin dataset
# if we want to include it in the original dataset we must tell R that we want that
dvst <- mutate(dvst, cent = start >= 25800000 & end <= 29700000)
# it was now added to the dataset
dvst <- mutate(dvst, 
               diversity = Pi / (10*1000), 
               cent = start >= 25800000 & end <= 29700000)
# we only want to keep the new variables, but will not save this
transmute(dvst,
          diversity = Pi / (10*1000), 
          cent = start >= 25800000 & end <= 29700000)

summary(select(dvst,`%GC`))
filter(dvst, `%GC` > 85.4)
filter(dvst, `%GC` < 1)
filter(dvst, `%GC`== min(`%GC`))
filter(dvst, `%GC`== max(`%GC`))
filter(dvst, `total SNPs`== 0)
filter(dvst, `total Bases` < 1000)
summary(select(dvst, `Divergence`))
filter(dvst, `Divergence` > 1)
filter(dvst, `Divergence`== max(`Divergence`))
filter(dvst, between(`%GC`, mean(`%GC`)-5, mean(`%GC`)+5))
nrow(filter(dvst, cent))
#arrange is basically the sort function, looks at first column first and uses the second column to break ties
arrange(dvst, cent, `%GC`)
#select lets you select only a few colums at once instead of all of them
dvst <- rename(dvst, total.SNPs = `total SNPs`,
               total.Bases = `total Bases`,
               unique.SNPs = `unique SNPs`,
               reference.Bases = `reference Bases`,
               percent.GC = `%GC`) #renaming all the columns that require ` `!
colnames(dvst)
summarise(dvst, GC = mean(percent.GC, na.rm = TRUE), averageSNPs=mean(total.SNPs, 
                                                                      na.rm = TRUE), allSNPs=sum(total.SNPs))
by_cent <- group_by(dvst, cent)
summarise(by_cent, GC = mean(percent.GC, na.rm = TRUE), averageSNPs=mean(total.SNPs, na.rm = TRUE), allSNPs=sum(total.SNPs))
