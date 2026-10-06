# 03_compute_rarefaction_curves.R
#
# Regenerate the rarefaction table used in the practical.
# This calculation is intentionally kept outside the 90-minute session.
#
# Rarefaction must be performed on genuine count data before filtering
# rare taxa. vegan::rarecurve() calculates the expected richness for
# increasing subsample sizes.
#
# Run from the root of the repository.

library(tidyverse)
library(vegan)

# This script creates `protist_counts` from the original data
source("extra_codes/02_prepare_protist_community.R")

# vegan expects samples in rows and OTUs in columns
comm_counts <- t(protist_counts)

# Generate a tidy rarefaction table rather than plotting directly
table_raref <- rarecurve(
  comm_counts,
  step = 2500,
  label = FALSE,
  tidy = TRUE
) %>%
  transmute(
    sample = as.character(Site),
    number_reads = Sample,
    OTU_richness = Species
  )

write.table(
  table_raref,
  "outputs/tables/tab_raref_curves.csv",
  sep = ";",
  row.names = FALSE,
  quote = FALSE
)

# Optional visualization
ggplot(
  table_raref,
  aes(
    x = number_reads,
    y = OTU_richness,
    group = sample
  )
) +
  geom_line(alpha = 0.35, linewidth = 0.4) +
  theme_classic() +
  labs(
    x = "Number of reads",
    y = "OTU richness"
  )
