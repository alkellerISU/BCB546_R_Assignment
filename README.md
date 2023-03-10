# BCB546-R-Assignment Codes

## Assigment Set Up

To start I set up my R environment by doing the following:

    library(tidyverse)

    snp_positions <- read.delim("https://raw.githubusercontent.com/EEOB-BioData/BCB546_Spring2023/main/assignments/UNIX_Assignment/snp_position.txt", header = T, sep = "\t")

    Fang_et_al_genotypes <- read.delim("https://raw.githubusercontent.com/EEOB-BioData/BCB546_Spring2023/main/assignments/UNIX_Assignment/fang_et_al_genotypes.txt", header = T, sep = "\t")

## Data Inspection

### snp_positions.txt

I start by looking at the structure of my table

    str(snp_positions)

What I have learned:

-   its a data frame with 983 observations and 15 variables

-   it contains integers and characters

### Fang_et_al_genotypes

I start by looking at the structure of my table

    str(Fang_et_al_genotypes)

What I have learned:

-   its a data frame with 2782 observations and 986 variables

-   it contains characters
