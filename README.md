# BCB546-R-Assignment Codes

## Assigment Set Up

To start I set up my R environment by doing the following:

```{r}
    library(tidyverse)

    snp_positions <- read.delim("https://raw.githubusercontent.com/EEOB-BioData/BCB546_Spring2023/main/assignments/UNIX_Assignment/snp_position.txt", header = T, sep = "\t")

    Fang_et_al_genotypes <- read.delim("https://raw.githubusercontent.com/EEOB-BioData/BCB546_Spring2023/main/assignments/UNIX_Assignment/fang_et_al_genotypes.txt", header = T, sep = "\t")
```

## Data Inspection

### snp_positions.txt

I start by looking at the structure of my table

```{r}
    str(snp_positions)
```

What I have learned:

-   its a data frame with 983 observations and 15 variables

-   it contains integers and characters

### Fang_et_al_genotypes

I start by looking at the structure of my table

```{r}
    str(Fang_et_al_genotypes)
```

What I have learned:

-   its a data frame with 2782 observations and 986 variables

-   it contains characters

## Data Processing

The first step is sorting out the Maize and Teosinte genotypes

```{r}
maize_genotypes <- filter(Fang_et_al_genotypes, Group %in% c('ZMMIL', 'ZMMLR', 'ZMMMR'))
teosinte_genotypes <- filter(Fang_et_al_genotypes, Group %in% c('ZMPBA', 'ZMPIL', 'ZMPJA'))
```
Next is to transpose the data, make sure it remains a data frame and make the "SNP_ID" is the first column so that is can be used to merge and sort with the "snp_positions.txt" data

```{r}
# transposition of  maize data

maize_genotypes <- column_to_rownames(maize_genotypes, var = "Sample_ID")
transposed_maize <- t(maize_genotypes) %>% as.data.frame() %>% rownames_to_column(var = "SNP_ID")

# merging maize data with snp_positions.txt data and ordering

Maize_data <- merge(snp_positions, transposed_maize, by = "SNP_ID")
Maize_data <- select(Maize_data, SNP_ID, Chromosome, Position, everything())

# transposition of  teosinte data

teosinte_genotypes <- column_to_rownames(teosinte_genotypes, var = "Sample_ID")
transposed_teosinte <- t(teosinte_genotypes) %>% as.data.frame() %>% rownames_to_column(., var = "SNP_ID")

# merging teosinte data with snp_positions.txt data and ordering

Teosinte_Data <- merge(snp_positions, transposed_teosinte, by = "SNP_ID")
Teosinte_Data <- select(Teosinte_Data, SNP_ID, Chromosome, Position, everything())

```