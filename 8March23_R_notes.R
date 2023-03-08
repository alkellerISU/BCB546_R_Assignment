ll <- list(a=rnorm(6, mean=1), b=rnorm(6, mean=4), c=rnorm(6, mean=6))
#made random list above

#below is a for loop that is calculating the mean for each vector in our ll list
for (i in 1:length(ll)) {
  print(mean(ll[[i]]))
}

#below is a easier way to achieve the same thing as the for loop
lapply(ll, mean)

#apply functions will still work with dataframes

library(tidyverse)
#Read datasets
mtfs <- read_tsv("https://raw.githubusercontent.com/vsbuffalo/bds-files/master/chapter-08-r/motif_recombrates.txt")
rpts <- read_tsv("https://raw.githubusercontent.com/vsbuffalo/bds-files/master/chapter-08-r/motif_repeats.txt")

head(mtfs)
head(rpts)

#Combine columns
rpts2 <- rpts %>% 
  unite(pos, chr, motif_start, sep="-") %>% ## new function!
  select(name, pos) %>% 
  inner_join(mtfs, by="pos")

p <- ggplot(data = rpts2, mapping = aes(x=dist, y=recom)) + geom_point(size=1)
p <- p + geom_smooth(method="loess", se=FALSE, span=1/10)
print(p)
