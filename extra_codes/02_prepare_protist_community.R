# 02_prepare_protist_community.R
#
# Reproduce the preprocessing used to create the protist community table
# distributed with the practical.
#
# Steps:
#   1. remove sequences without a taxonomic hit;
#   2. remove Opisthokonta and Rhodophyta;
#   3. convert counts to relative abundance;
#   4. apply a 0.1% within-sample abundance threshold;
#   5. renormalize and save the filtered table.
#
# Run from the root of the repository.

library(tidyverse)

# Download source files if necessary
source("extra_codes/01_download_tara_data.R")

# Load original OTU and taxonomy tables
otus <- readr::read_tsv(
  "datasets/TARA-Oceans_18S-V4_Swarm-Mumu_table.tsv.gz",
  show_col_types = FALSE
)

taxo <- readr::read_tsv(
  "datasets/TARA-Oceans_18S-V4_Swarm-Mumu_taxo.tsv.gz",
  show_col_types = FALSE
)

# Remove sequences that could not be classified
taxo_classified <- taxo %>%
  filter(!str_detect(closest_hits_lca, "No_hit"))

# Keep the protist component used in the practical
taxo_protists <- taxo_classified %>%
  filter(
    !str_detect(closest_hits_lca, "Opisthokonta"),
    !str_detect(closest_hits_lca, "Rhodophyta")
  )

# Keep matching OTUs
otu_protists <- otus %>%
  filter(amplicon %in% taxo_protists$amplicon)

samples_list <- grep(
  "^TARA_",
  colnames(otu_protists),
  value = TRUE
)

# Community count matrix: OTUs in rows, samples in columns
protist_counts <- as.matrix(
  otu_protists[, samples_list]
)
storage.mode(protist_counts) <- "numeric"

# Convert counts to relative abundance within each sample
protist_ra <- sweep(
  protist_counts,
  MARGIN = 2,
  STATS = colSums(protist_counts),
  FUN = "/"
)

# Set OTUs below 0.1% relative abundance in a sample to zero
protist_ra_filtered <- protist_ra
protist_ra_filtered[protist_ra_filtered < 0.001] <- 0

# Renormalize samples after filtering
sample_totals <- colSums(protist_ra_filtered)
nonempty_samples <- sample_totals > 0

protist_ra_filtered[, nonempty_samples] <- sweep(
  protist_ra_filtered[, nonempty_samples, drop = FALSE],
  MARGIN = 2,
  STATS = sample_totals[nonempty_samples],
  FUN = "/"
)

# Remove OTUs absent from every sample after filtering
keep_otus <- rowSums(protist_ra_filtered) > 0

protist_ra_filtered <- protist_ra_filtered[
  keep_otus,
  ,
  drop = FALSE
]

# Retain the non-sample columns from the original OTU table
otu_metadata_columns <- setdiff(
  colnames(otu_protists),
  samples_list
)

otu_metadata <- otu_protists[
  keep_otus,
  otu_metadata_columns,
  drop = FALSE
]

otu_protists_ra_filtered <- bind_cols(
  otu_metadata,
  as.data.frame(protist_ra_filtered)
)

dir.create("outputs/tables", recursive = TRUE, showWarnings = FALSE)

write.table(
  otu_protists_ra_filtered,
  "outputs/tables/OTUtab_protists_ra_filtered.csv",
  sep = ";",
  row.names = FALSE,
  quote = FALSE
)

message(
  "Saved ",
  nrow(otu_protists_ra_filtered),
  " OTUs across ",
  length(samples_list),
  " samples."
)
