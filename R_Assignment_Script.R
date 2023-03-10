library(tidyverse)

snp_positions <- read.delim("https://raw.githubusercontent.com/EEOB-BioData/BCB546_Spring2023/main/assignments/UNIX_Assignment/snp_position.txt", header = T, sep = "\t")
Fang_et_al_genotypes <- read.delim("https://raw.githubusercontent.com/EEOB-BioData/BCB546_Spring2023/main/assignments/UNIX_Assignment/fang_et_al_genotypes.txt", header = T, sep = "\t")

str(snp_positions)
str(Fang_et_al_genotypes)

maize_genotypes <- filter(Fang_et_al_genotypes, Group %in% c('ZMMIL', 'ZMMLR', 'ZMMMR'))
teosinte_genotypes <- filter(Fang_et_al_genotypes, Group %in% c('ZMPBA', 'ZMPIL', 'ZMPJA'))

