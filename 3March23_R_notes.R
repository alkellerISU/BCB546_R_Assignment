library(tidyverse)
# this is the syntx for pipeing in R: %>%

dvst <- read_csv("https://raw.githubusercontent.com/vsbuffalo/bds-files/master/chapter-08-r/Dataset_S1.txt") %>% 
  mutate(diversity = Pi / (10*1000), cent = (start >= 25800000 & end <= 29700000)) %>% 
  rename(percent.GC = `%GC`, total.SNPs = `total SNPs`, total.Bases = `total Bases`, reference.Bases = `reference Bases`)

dvst <- mutate(dvst, position = (end + start) / 2)
ggplot(data = dvst) + geom_point(mapping=aes(x=position, y=diversity))

# This is a graphing command template
# ggplot(data = <DATA>) + <GEOM_FUNCTION>(mapping = aes(<MAPPINGS>))

ggplot(data = dvst) + geom_point(mapping = aes(x=position, y=diversity, color=cent))

ggplot(data = dvst) + geom_point(mapping = aes(x = position, y = diversity, color = diversity))

ggplot(data = dvst) + geom_point(mapping = aes(x = position, y = diversity, color = depth))

ggplot(data = dvst) + geom_point(mapping = aes(x = position, y = diversity, stroke=1))

ggplot(data = dvst) + geom_point(mapping = aes(x = position, y = diversity, stroke=10))
# stroke changes the size of the points
ggplot(data = dvst) + geom_point(mapping = aes(x = position, y = diversity, color = percent.GC < 50))

ggplot(data = dvst) + geom_point(mapping = aes(x=position, y=diversity), alpha=0.01)
# alpha changes transparency of points, inside it canges them based on the mapping and outside will make all points the same transparency

ggplot(data = dvst) + geom_density(mapping = aes(x=diversity), fill="blue", color="red")
# y-axsis is automatically populated

ggplot(data = dvst) + geom_density(mapping = aes(x=diversity, fill=cent), alpha=0.4)
