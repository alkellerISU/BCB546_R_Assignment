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

# maize data processing

dir.create('./Maize')
chr_maize <- filter(Maize_data, Chromosome != "unknown" & Chromosome != "multiple")
Missing_Q_Maize <- as_tibble(lapply(chr_maize, gsub, pattern ="-", replacement ="?", fixed = TRUE))
Missing_D_Maize <- as_tibble(lapply(chr_maize, gsub, pattern ="?", replacement ="-", fixed = TRUE))

#Part A: ascending order and missing replaced by "?"
for (i in 1:length(unique(Missing_Q_Maize$Chromosome))){
  chr_maize_ascending <-  Missing_Q_Maize %>% filter(Chromosome == i) %>% arrange(Position)
  write_delim(chr_maize_ascending, file = paste("./Maize/Maize_Part_A",i, sep="_"))  
}

#Part B: descending and missing replaced by "-"
for (i in 1:length(unique(Missing_D_Maize$Chromosome))){
  chr_maize_descending <-  Missing_D_Maize %>% filter(Chromosome == i) %>% arrange(desc(Position))
  write_delim(chr_maize_descending, file = paste("./Maize/Maize_Part_B",i, sep="_"))  
}

#Part C: files for multiple and unknown maize data
unknown_maize <- filter(Maize_data, Chromosome == "unknown")
multiple_maize <- filter(Maize_data, Chromosome == "multiple")

write_delim(multiple_maize, file = "./Maize/Multiple_Maize")
write_delim(unknown_maize, file = "./Maize/Unknown_Maize")

#Teosinte Data Processing

dir.create('./Teosinte')
chr_teosinte <- filter(Teosinte_Data, Chromosome != "unknown" & Chromosome != "multiple")
Missing_Q_Teosinte <- as_tibble(lapply(chr_teosinte, gsub, pattern ="-", replacement ="?", fixed = TRUE))
Missing_D_Teosinte <- as_tibble(lapply(chr_teosinte, gsub, pattern ="?", replacement ="-", fixed = TRUE))

#Part A: ascending order and missing replaced by "?"
for (i in 1:length(unique(Missing_Q_Teosinte$Chromosome))){
  chr_teosinte_ascending <-  Missing_Q_Teosinte %>% filter(Chromosome == i) %>% arrange(Position)
  write_delim(chr_teosinte_ascending, file = paste("./Teosinte/Teosinte_Part_A",i, sep="_"))  
}

#Part B: descending and missing replaced by "-"
for (i in 1:length(unique(Missing_D_Teosinte$Chromosome))){
  chr_teosinte_descending <-  Missing_D_Teosinte %>% filter(Chromosome == i) %>% arrange(desc(Position))
  write_delim(chr_teosinte_descending, file = paste("./Teosinte/Teosinte_Part_B",i, sep="_"))  
}

#Part C: files for multiple and unknown maize data
unknown_teosinte <- filter(Teosinte_Data, Chromosome == "unknown")
multiple_teosinte <- filter(Teosinte_Data, Chromosome == "multiple")

write_delim(multiple_teosinte, file = "./Teosinte/Multiple_Teosinte")
write_delim(unknown_teosinte, file = "./Teosinte/Unknown_Teosinte")

# Data Visualization
library(ggplot2)
#data clean up
Formated_SNP <- snp_positions %>% select(SNP_ID, Chromosome, Position)
Genotypes_Transposed <- Fang_et_al_genotypes %>% select(-JG_OTU, -Group) %>% column_to_rownames(., var = "Sample_ID") %>% t() %>% as.data.frame() %>% rownames_to_column(., var = "SNP_ID")
Merged_Genotypes <- merge(Formated_SNP, Genotypes_Transposed) %>% filter(., !Chromosome %in% c("unknown", "multiple"))

TotalSNPs <- 
  ggplot(Merged_Genotypes, aes(x=as.double(Chromosome), #x=as.double(Chromosome) considers Chr as a number
  fill = as.factor(as.double(Chromosome)))) +  # for getting chrom in the right order in the legend   
  geom_bar() +
  scale_x_continuous(breaks = 1:10) + # bcs x=as.double(Chromosome), breaks by default don't match chrom number
  theme_bw() + 
  ggtitle("Total Number of SNPs across each chromosome") +
  labs(x = "Chromosome", y = "Total number of SNPs", fill = "Chromosome") #fill = "Chromosome" only replace legend's tittle 

DiversitySNPs <- 
  ggplot(Merged_Genotypes, aes(x= as.numeric(Position))) + 
  geom_density(aes(fill = as.factor(as.double(Chromosome)))) +  #same as the previous plot 
  facet_wrap(~ as.factor(as.double(Chromosome)), nrow = 2, ncol = 5) + 
  ggtitle("Diversity of SNPs across each chromosome") +
  theme(axis.text.x=element_text(angle = 90)) +                 #change orientation of x axis
  labs(x = "Position", y = "Density", fill = "Chromosome")

pdf("SNP_Visualisation.pdf")
print(TotalSNPs)
print(DiversitySNPs)
dev.off()

#missing data clean up
tidy_genotypes <- Fang_et_al_genotypes %>% select(-JG_OTU) %>% pivot_longer( -Sample_ID: -Group, names_to = "SNP_ID", values_to = "Sequence")
tidy_genotypes <- tidy_genotypes %>% mutate(new_sequence = ifelse(Sequence %in% c("A/A", "T/T", "C/C", "G/G"), "Homozygous", ifelse(Sequence == "?/?", "Missing", "Heterozygous")))

#For all the samples.
Samples_Plot <-  ggplot(tidy_genotypes, aes(x = Sample_ID, fill = new_sequence)) +
  ggtitle("Heterozygosity Plot") +
  geom_bar(position = "fill") + theme_bw() + labs(x = "Sample ID", y = "Proportion")
#Stacked Bar-graph for all groups. 
Groups_Plot <- ggplot(tidy_genotypes, aes(x = Group , fill = new_sequence)) + geom_bar(position = "fill") + 
  ggtitle("Heterozygosity in various Groups of Species ") +
  theme_bw() + theme(axis.text.x = element_text(angle = 90))+ labs(y = "Proportion")

pdf("MissingDATA_Heterozygosity_Visualisation.pdf")
print(Samples_Plot)
print(Groups_Plot)
dev.off()

#Own feature
Own_Feature <- ggplot(filter(tidy_genotypes, Sequence != "?/?") , aes(x = Sample_ID, fill = Sequence)) + 
  geom_bar(position = "fill") + theme_bw() + labs(x = "Sample ID", y = "Proportion")

print(Own_Feature)
