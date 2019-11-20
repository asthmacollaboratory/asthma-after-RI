# asthma-after-RI
Repository for the paper "*Differential asthma risk following respiratory infection in children from three minority populations.*" (LINK IN PROGRESS)

## Analysis
This repository contains all the analysis scripts needed to reproduce all results and figures in the paper "*Differential asthma risk following respiratory infection in children from three minority populations.*" Specifically you will find the following:

```
asthma-after-RI
|-- README.md
|-- LICENSE
|-- analysis
| |-- run_analysis.sh           # user friendly button to push for running all analysis steps
| |-- env.sh                    # a script for populating the environment variables
| 
| |--bin
| | |-- OddsRatioplot_func.R    # function to source to create the Odds Ratio Plot
| | |-- Prevalenceplot_func.R   # function to source to create the Prevalence Plot
| | |-- RSVseason_func.R        # function to source to create the RSV Season Plot **see Notes below
|
| |-- src
| | |-- run_AssocTests.R        # performs the association tests
| | |-- run_FigCreations.R      # sources all figure functions to generate figures
| | |-- run_PairwiseP.R         # performs the pairwise P-value analysis
| | |-- set_R_environment.R     # installs and loads all packages needed for the analysis 
```

## Notes
Please contact the authors of the following paper for access to the data used to make the RSV season figure:

[McGuiness CB, Boron ML, Saunders B, Edelman L, Kumar VR, Rabon-Stith KM. Respiratory syncytial virus surveillance in the United States, 2007-2012: results from a national surveillance system. Pediatr Infect Dis J. 2014;33(6):589-94. Epub 2014/01/22. doi: 10.1097/INF.0000000000000257. PubMed PMID: 24445835; PMCID: PMC4025589](https://www.ncbi.nlm.nih.gov/pubmed/24445835)
