# putting commands in [] will allow R to pull out the values that match your argument
# if you want to subset a list but not extract an element you will use [] and it will give you a list
# if you want to extract a single element use [[]] and it will give you an element
# use $ to extract an element by its name and do not need to use ""

lst <- list(1:3, "a", c(TRUE, FALSE, TRUE), c(2.3, 5.9))
names(lst) <- c("A","B","C","D")
# command 1:
lst[1][2]
# command 2:
lst[[1]][2]

install.packages("tidyverse")
install.packages("tidyr")

dvst <- read_csv("https://raw.githubusercontent.com/vsbuffalo/bds-files/master/chapter-08-r/Dataset_S1.txt")
