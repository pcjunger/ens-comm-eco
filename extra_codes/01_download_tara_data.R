# 01_download_tara_data.R
#
# Download the original Tara Oceans source datasets used in the practical.
# Files are downloaded only if they are not already present.
#
# Run from the root of the repository.

dir.create("datasets", showWarnings = FALSE)

download_if_missing <- function(url, destination) {
  if (!file.exists(destination)) {
    message("Downloading ", basename(destination), " ...")
    download.file(
      url,
      destfile = destination,
      mode = "wb",
      quiet = FALSE
    )
  } else {
    message(basename(destination), " already exists.")
  }
}

download_if_missing(
  paste0(
    "https://zenodo.org/records/7235995/files/",
    "TARA-Oceans_18S-V4_Swarm-Mumu_table.tsv.gz?download=1"
  ),
  "datasets/TARA-Oceans_18S-V4_Swarm-Mumu_table.tsv.gz"
)

download_if_missing(
  paste0(
    "https://zenodo.org/records/7235995/files/",
    "TARA-Oceans_18S-V4_Swarm-Mumu_taxo.tsv.gz?download=1"
  ),
  "datasets/TARA-Oceans_18S-V4_Swarm-Mumu_taxo.tsv.gz"
)

download_if_missing(
  "https://zenodo.org/records/7229815/files/context_general.tsv?download=1",
  "datasets/context_general.tsv"
)

download_if_missing(
  "https://zenodo.org/records/7229815/files/context_stat.tsv?download=1",
  "datasets/context_stat.tsv"
)
