# Gencode

# Extract gene names and gene ID from Gencode GTF files -------------
library(dplyr)
library(stringr)

# Download gencode gtf from the terminal
# wget ftp://ftp.ebi.ac.uk/pub/databases/gencode/Gencode_human/release_35/gencode.v35.annotation.gtf.gz
# Unzip it
# gunzip gencode.v35.annotation.gtf.gz

gencode_gtf <- readr::read_tsv("data/gencode.v35.annotation.gtf", 
                               col_names = FALSE, 
                               skip = 5)
gencode_gtf_tidy <-
  gencode_gtf %>% mutate(gene_id = str_extract(.$X9, "ENSG\\d{1,}"),
                         gene_name = str_extract(.$X9, "(?<=gene_name \")[:graph:]{1,}") %>% str_remove("\";")) %>% 
  select(gene_id, gene_name) %>% distinct()

gencode_gtf_tidy %>% readr::write_csv("data/gencode_v35_gene_id_name.csv")
