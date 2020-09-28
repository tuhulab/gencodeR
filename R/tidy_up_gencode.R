# Read Gencode

# Annotate gene names with gene ids from Gencode GTF files -------------
library(dplyr)
library(stringr)
gencode_gtf <- readr::read_tsv("~/Downloads/gencode.v35.annotation.gtf", 
                               col_names = FALSE, 
                               skip = 5)
gencode_gtf_tidy <-
  gencode_gtf %>% mutate(gene_id = str_extract(.$X9, "ENSG\\d{1,}"),
                         gene_name = str_extract(.$X9, "(?<=gene_name \").{1,}(?=\"; gene_source)")) %>%
  select(gene_id, gene_name) %>% distinct()

# test
gencode_gtf[1:100,] %>% mutate(gene_id = str_extract(.$X9, "ENSG\\d{1,}"),
                               gene_name = str_extract(.$X9, "(?<=gene_name \")[:graph:]{1,}")) %>%
  select(gene_id, gene_name) %>% distinct()

count_geneid <- readr::read_tsv("data/counts-gene-id.txt", skip=1) %>% 
  mutate(Chr = Chr %>% str_extract("chr\\w{1,}(?=;)|chr\\w{1,}$")) %>% 
  mutate(Strand = Strand %>% str_extract("\\+|\\-")) %>% 
  mutate(Start = Start %>% str_extract("\\d{1,}(?=;)|\\d{1,}$") %>% as.numeric(), 
         End = End %>% str_extract("\\d{1,}(?=;)|\\d{1,}$") %>% as.numeric())
new_colname <- c(colnames(counttable_gencode_genename)[1:6], colnames(counttable_gencode_genename)[-1:-6] %>% str_extract("NG-[:graph:]{1,}$"))
colnames(counttable_gencode_genename) <- new_colname

JOIN_count_ID_NAME <- 
  count[, 1:6] %>% rename(Gene_name = Geneid) %>% 
  left_join(count_geneid %>% select(1:6), by=c("Chr", "Start", "End", "Strand", "Length"))

table <- JOIN_count_ID_NAME$Gene_name %>% table
names(which(table != 1))
