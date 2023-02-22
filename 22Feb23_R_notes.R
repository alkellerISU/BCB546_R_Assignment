c("hi", "there")
#created a vector but it is not saved

my_string <- c("hi", "there")
#now I have named it and it has saved in my global environment as a charactor vector

rm(my_sring)
#this removes things from my enviroment (wish i knew that when I was taking stats)

dbl_var <- c(1, 2.5, 4.5)
# With the L suffix, you get an integer rather than a double (see below)
int_var <- c(1L, 6L, 10L)
# Use TRUE and FALSE (or T and F) to create logical vectors
log_var <- c(TRUE, FALSE, T, F)
chr_var <- c("these are", "some strings")
#these are character variables

x <- c(1,2,3)
#this is a numerical vector
y <- list(1,2,3)
#this is a list (each item becomes its own vector)
z <- list(1:3, "a", c(TRUE, FALSE, TRUE), c(2.3, 5.9))
#this is a list that includes difference vectors within them
is.vector(list(1,2,3))
is.numeric(c(1L,2L,3L))
typeof(as.numeric(c(1L,2L,3L)))

NA
#is part of a vector, it is a "not available" piece of informaiton and is considered logical value
#NA becomes whatever type of data we combine it with

sex_char <- c("m", "m", "m", "f")
sex_factor <- factor(sex_char, levels = c("m", "f"))

table(sex_char)
#can be used to get counts of things within a data set by following this (above)

dir.create("class_notes")
