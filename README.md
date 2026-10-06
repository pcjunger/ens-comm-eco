# Community Ecology TP – Tara Oceans

This repository contains the material for a **90-minute practical session in Community Ecology** using plankton metabarcoding data from the *Tara Oceans* expedition.

## Before the practical

Please install:

- [R](https://cran.r-project.org/)
- [RStudio](https://posit.co/download/rstudio-desktop/)

The practical uses three R packages:

```r
install.packages(c("tidyverse", "vegan", "ape"))
```

You only need to install them once.

## Starting the practical

1. Download the complete repository using **Code → Download ZIP**.
2. Unzip the folder.
3. Open `Community_Ecology_TP.Rproj` in RStudio.
4. Open `Community_Ecology_TP.Rmd`.
5. Run the code chunks in order.

The main practical uses preprocessed tables included in `outputs/tables/`, so **you do not need to download the original Tara Oceans datasets before class**.

## Repository structure

```text
community-ecology-tp/
├── Community_Ecology_TP.Rmd
├── Community_Ecology_TP.Rproj
├── README.md
├── outputs/
│   └── tables/
│       ├── OTUtab_protists_ra_filtered.csv
│       ├── context-env-div_otu-ra_tab.csv
│       └── tab_raref_curves.csv
└── extra_codes/
    ├── 01_download_tara_data.R
    ├── 02_prepare_protist_community.R
    ├── 03_compute_rarefaction_curves.R
    └── 04_compute_alpha_diversity.R
```

## Original data and extra code

The complete source datasets are hosted on Zenodo:

- Tara Oceans 18S V4 OTU and taxonomy tables: <https://zenodo.org/records/7235995>
- Tara Oceans contextual and environmental data: <https://zenodo.org/records/7229815>

The scripts in `extra_codes/` show how the tables used in the practical can be reconstructed from the original data. They are provided for reproducibility and for students who want to explore the workflow further; they are **not required during the 90-minute session**.

The last section of the practical, **Choose your favourite plankton**, is also an extension. If time allows, students can work in groups to select a plankton group and repeat the diversity analyses. Otherwise, the section can be completed independently after the class.
