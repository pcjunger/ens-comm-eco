# 04_compute_alpha_diversity.R
#
# Reproduce the alpha-diversity table used in the practical.
# Metrics are calculated from the complete protist community count table,
# before the 0.1% abundance filtering used to speed up beta-diversity analyses.
#
# Run from the root of the repository.

library(tidyverse)
library(vegan)

source("extra_codes/02_prepare_protist_community.R")

context <- readr::read_tsv(
  "datasets/context_general.tsv",
  show_col_types = FALSE
)

env <- readr::read_tsv(
  "datasets/context_stat.tsv",
  show_col_types = FALSE
)

# vegan expects samples in rows
comm_counts <- t(protist_counts)

alpha_div <- data.frame(
  sample_id_pangaea = rownames(comm_counts),
  OTU_richness = specnumber(comm_counts),
  Shannon = diversity(comm_counts, index = "shannon"),
  Inv_Simpson = diversity(comm_counts, index = "invsimpson")
)

alpha_div$Pielou <- with(
  alpha_div,
  ifelse(
    OTU_richness > 1,
    Shannon / log(OTU_richness),
    NA_real_
  )
)

context_env <- merge(
  context,
  env,
  by = "sample_id_pangaea"
) %>%
  select(
    sample_id_pangaea,
    ocean_region,
    depth,
    depthplot,
    sizeplot,
    abs_lat,
    temperature,
    chla,
    phosphate,
    nitrate_nitrite,
    silicate
  )

env_div <- merge(
  context_env,
  alpha_div,
  by = "sample_id_pangaea"
)

write.table(
  env_div,
  "outputs/tables/context-env-div_otu-ra_tab.csv",
  sep = ";",
  row.names = FALSE,
  quote = FALSE
)
