# BCB546-R-Assignment Codes

## Assignment Set Up

To start I set up my R environment by doing the following:

```{r}
library(tidyverse)
library(ggplot2)

snp_positions <- read.delim("https://raw.githubusercontent.com/EEOB-BioData/BCB546_Spring2023/main/assignments/UNIX_Assignment/snp_position.txt", header = T, sep = "\t")

Fang_et_al_genotypes <- read.delim("https://raw.githubusercontent.com/EEOB-BioData/BCB546_Spring2023/main/assignments/UNIX_Assignment/fang_et_al_genotypes.txt", header = T, sep = "\t")
```

## Data Inspection

### snp_positions.txt

I start by looking at the structure of my tables.

```{r}
str(snp_positions)
```

What I have learned:

-   Its a data frame with 983 observations and 15 variables.

-   It contains integers and characters.

### Fang_et_al_genotypes

I start by looking at the structure of my tables.

```{r}
str(Fang_et_al_genotypes)
```

What I have learned:

-   Its a data frame with 2782 observations and 986 variables.

-   It contains characters.

## Data Processing

The first step is sorting out the Maize and Teosinte genotypes.

```{r}
maize_genotypes <- filter(Fang_et_al_genotypes, Group %in% c('ZMMIL', 'ZMMLR', 'ZMMMR'))
    
teosinte_genotypes <- filter(Fang_et_al_genotypes, Group %in% c('ZMPBA', 'ZMPIL', 'ZMPJA'))
```

Next is to transpose the data, make sure it remains a data frame and make sure the "SNP_ID" is the first column so that it can be used to merge and sort with the "snp_positions.txt" data.

#### Transposition of maize data

```{r}
maize_genotypes <- column_to_rownames(maize_genotypes, var = "Sample_ID")

transposed_maize <- t(maize_genotypes) %>% as.data.frame() %>% rownames_to_column(var = "SNP_ID")
```

#### Merging maize data with snp_positions.txt data and ordering

```{r}
Maize_data <- merge(snp_positions, transposed_maize, by = "SNP_ID")

Maize_data <- select(Maize_data, SNP_ID, Chromosome, Position, everything())
```

#### Transposition of teosinte data

```{r}
teosinte_genotypes <- column_to_rownames(teosinte_genotypes, var = "Sample_ID")

transposed_teosinte <- t(teosinte_genotypes) %>% as.data.frame() %>% rownames_to_column(., var = "SNP_ID")
```

#### Merging teosinte data with snp_positions.txt data and ordering

```{r}
Teosinte_Data <- merge(snp_positions, transposed_teosinte, by = "SNP_ID")

Teosinte_Data <- select(Teosinte_Data, SNP_ID, Chromosome, Position, everything())
```

### Full Maize Data Processing

```{r}
dir.create('./Maize') #where my data is going to go

chr_maize <- filter(Maize_data, Chromosome != "unknown" & Chromosome != "multiple") #filters out the data with unknown or multiple chromosome data

Missing_Q_Maize <- as_tibble(lapply(chr_maize, gsub, pattern ="-", replacement ="?", fixed = TRUE)) #replaces -/- for missing data with ?/?

Missing_D_Maize <- as_tibble(lapply(chr_maize, gsub, pattern ="?", replacement ="-", fixed = TRUE)) #replaces ?/? for missing data with -/-

#Part A: 1 file for each chromosome with SNPs ordered based on increasing position values and missing data represented as ?
for (i in 1:length(unique(Missing_Q_Maize$Chromosome))){
  chr_maize_ascending <-  Missing_Q_Maize %>% filter(Chromosome == i) %>% arrange(Position)
  write_delim(chr_maize_ascending, file = paste("./Maize/Maize_Part_A",i, sep="_"))  
}

#Part B: 1 file for each chromosome with SNPs ordered based on decreasing position values and with missing data represented as -
for (i in 1:length(unique(Missing_D_Maize$Chromosome))){
  chr_maize_descending <-  Missing_D_Maize %>% filter(Chromosome == i) %>% arrange(desc(Position))
  write_delim(chr_maize_descending, file = paste("./Maize/Maize_Part_B",i, sep="_"))  
}

#Part C: Make and write files for multiple and unknown maize data
unknown_maize <- filter(Maize_data, Chromosome == "unknown")

multiple_maize <- filter(Maize_data, Chromosome == "multiple")

write_delim(multiple_maize, file = "./Maize/Multiple_Maize")

write_delim(unknown_maize, file = "./Maize/Unknown_Maize")
```

### Full Teosinte Data Processing

```{r}
dir.create('./Teosinte') #where my data is going to go

chr_teosinte <- filter(Teosinte_Data, Chromosome != "unknown" & Chromosome != "multiple") #filters out the data with unknown or multiple chromosome data

Missing_Q_Teosinte <- as_tibble(lapply(chr_teosinte, gsub, pattern ="-", replacement ="?", fixed = TRUE)) #replaces -/- for missing data with ?/?

Missing_D_Teosinte <- as_tibble(lapply(chr_teosinte, gsub, pattern ="?", replacement ="-", fixed = TRUE)) #replaces ?/? for missing data with -/-

#Part A: 1 file for each chromosome with SNPs ordered based on increasing position values and missing data represented as ?
for (i in 1:length(unique(Missing_Q_Teosinte$Chromosome))){
  chr_teosinte_ascending <-  Missing_Q_Teosinte %>% filter(Chromosome == i) %>% arrange(Position)
  write_delim(chr_teosinte_ascending, file = paste("./Teosinte/Teosinte_Part_A",i, sep="_"))  
}

#Part B: 1 file for each chromosome with SNPs ordered based on decreasing position values and with missing data represented as -
for (i in 1:length(unique(Missing_D_Teosinte$Chromosome))){
  chr_teosinte_descending <-  Missing_D_Teosinte %>% filter(Chromosome == i) %>% arrange(desc(Position))
  write_delim(chr_teosinte_descending, file = paste("./Teosinte/Teosinte_Part_B",i, sep="_"))  
}

#Part C: Make and write files for multiple and unknown maize data
unknown_teosinte <- filter(Teosinte_Data, Chromosome == "unknown")

multiple_teosinte <- filter(Teosinte_Data, Chromosome == "multiple")

write_delim(multiple_teosinte, file = "./Teosinte/Multiple_Teosinte")

write_delim(unknown_teosinte, file = "./Teosinte/Unknown_Teosinte")
```

## Data Visualization

To start, I am going to make files that are easier to preform these visualizations on.

```{r}
Formated_SNP <- snp_positions %>% select(SNP_ID, Chromosome, Position)

Genotypes_Transposed <- Fang_et_al_genotypes %>% select(-JG_OTU, -Group) %>% column_to_rownames(., var = "Sample_ID") %>% t() %>% as.data.frame() %>% rownames_to_column(., var = "SNP_ID")

Merged_Genotypes <- merge(Formated_SNP, Genotypes_Transposed) %>% filter(., !Chromosome %in% c("unknown", "multiple"))
```

#### SNP per chromosome visualization.

```{r}
TotalSNPs <- 
  ggplot(Merged_Genotypes, aes(x=as.double(Chromosome), #x=as.double(Chromosome) considers Chr as a number
  fill = as.factor(as.double(Chromosome)))) +  # for getting chrom in the right order in the legend   
  geom_bar() +
  scale_x_continuous(breaks = 1:10) + # bcs x=as.double(Chromosome), breaks by default don't match chrom number
  theme_bw() + ggtitle("Total Number of SNPs across each chromosome") +
  labs(x = "Chromosome", y = "Total number of SNPs", fill = "Chromosome") #fill = "Chromosome" only replace legend's tittle 

DiversitySNPs <- 
  ggplot(Merged_Genotypes, aes(x= as.numeric(Position))) + 
  geom_density(aes(fill = as.factor(as.double(Chromosome)))) + #same as the previous plot 
  facet_wrap(~ as.factor(as.double(Chromosome)), nrow = 2, ncol = 5) + 
  ggtitle("Diversity of SNPs across each chromosome") +
  theme(axis.text.x=element_text(angle = 90)) + #change orientation of x axis
  labs(x = "Position", y = "Density", fill = "Chromosome")

print(TotalSNPs)
print(DiversitySNPs)
```

#### Missing data and amount of heterozygosity.

```{r}
# started by prepping data for the visualizations
tidy_genotypes <- Fang_et_al_genotypes %>% select(-JG_OTU) %>% pivot_longer( -Sample_ID: -Group, names_to = "SNP_ID", values_to = "Sequence")

tidy_genotypes <- tidy_genotypes %>% mutate(new_sequence = ifelse(Sequence %in% c("A/A", "T/T", "C/C", "G/G"), "Homozygous", ifelse(Sequence == "?/?", "Missing", "Heterozygous")))

#For all the samples
Samples_Plot <-  ggplot(tidy_genotypes, aes(x = Sample_ID, fill = new_sequence)) +
  ggtitle("Heterozygosity Plot") +
  geom_bar(position = "fill") + theme_bw() + labs(x = "Sample ID", y = "Proportion")

#Stacked Bar-graph for all groups
Groups_Plot <- ggplot(tidy_genotypes, aes(x = Group , fill = new_sequence)) + geom_bar(position = "fill") + 
  ggtitle("Heterozygosity in various Groups of Species ") +
  theme_bw() + theme(axis.text.x = element_text(angle = 90))+ labs(y = "Proportion")

print(Samples_Plot)
print(Groups_Plot)
```

#### Own feature

I wanted to look at the proportions of different sequences in the samples.

```{r}
Own_Feature <- ggplot(filter(tidy_genotypes, Sequence != "?/?") , aes(x = Sample_ID, fill = Sequence)) + 
  geom_bar(position = "fill") + theme_bw() + labs(x = "Sample ID", y = "Proportion")

print(Own_Feature)
```
