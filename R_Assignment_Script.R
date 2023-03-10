library(tidyverse)

snp_positions <- read.delim("https://raw.githubusercontent.com/EEOB-BioData/BCB546_Spring2023/main/assignments/UNIX_Assignment/snp_position.txt", header = T, sep = "\t")
Fang_et_al_genotypes <- read.delim("https://raw.githubusercontent.com/EEOB-BioData/BCB546_Spring2023/main/assignments/UNIX_Assignment/fang_et_al_genotypes.txt", header = T, sep = "\t")

str(snp_positions)
str(Fang_et_al_genotypes)

maize_genotypes <- filter(Fang_et_al_genotypes, Group %in% c('ZMMIL', 'ZMMLR', 'ZMMMR'))
teosinte_genotypes <- filter(Fang_et_al_genotypes, Group %in% c('ZMPBA', 'ZMPIL', 'ZMPJA'))

maize_genotypes <- column_to_rownames(maize_genotypes, var = "Sample_ID")
transposed_maize <- t(maize_genotypes) %>% as.data.frame() %>% rownames_to_column(var = "SNP_ID")

Maize_data <- merge(snp_positions, transposed_maize, by = "SNP_ID")
Maize_data <- select(Maize_data, SNP_ID, Chromosome, Position, everything())

teosinte_genotypes <- column_to_rownames(teosinte_genotypes, var = "Sample_ID")
transposed_teosinte <- t(teosinte_genotypes) %>% as.data.frame() %>% rownames_to_column(., var = "SNP_ID")


Teosinte_Data <- merge(snp_positions, transposed_teosinte, by = "SNP_ID")
Teosinte_Data <- select(Teosinte_Data, SNP_ID, Chromosome, Position, everything())

