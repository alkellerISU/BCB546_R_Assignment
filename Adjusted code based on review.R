fang_new <- Fang_et_al_genotypes %>% pivot_longer(!c(Sample_ID, Group), names_to="SNP_ID", values_to= "allele")
Subsetted <- filter(fang_new, Group %in% c("ZMMIL","ZMMLR","ZMMMR","ZMPBA","ZMPIL","ZMPJA"))

snp_vis_2 <- merge(Subsetted, Formated_SNP, by.y="SNP_ID")


## add new column: 
Subsetted_SNPs <- snp_vis_2 %>% 
  mutate(
    type = if_else(
      condition = Group %in% c("ZMMIL","ZMMLR","ZMMMR"), 
      true      = "Maize", 
      false     = "Teosinte"
    ), 
  )



TotalSNPs <- 
  ggplot(Subsetted_SNPs, aes(x=as.double(Chromosome), #x=as.double(Chromosome) considers Chr as a number
                               fill = as.factor(as.double(Chromosome)))) +  # for getting chrom in the right order in the legend   
  geom_bar() +
  scale_x_continuous(breaks = 1:10) + # bcs x=as.double(Chromosome), breaks by default don't match chrom number
  theme_bw() + ggtitle("Total Number of SNPs across each chromosome") +
  labs(x = "Chromosome", y = "Total number of SNPs", fill = "Chromosome") #fill = "Chromosome" only replace legend's tittle


DiversitySNPs <- 
  ggplot(Subsetted_SNPs, aes(x= as.numeric(Position))) + 
  geom_density(aes(fill = as.factor(as.double(Chromosome)))) + #same as the previous plot 
  facet_wrap(~ as.factor(as.double(Chromosome)), nrow = 2, ncol = 6) + 
  ggtitle("Diversity of SNPs across each chromosome") +
  theme(axis.text.x=element_text(angle = 90)) + #change orientation of x axis
  labs(x = "Position", y = "Density", fill = "Chromosome")
print(DiversitySNPs)
