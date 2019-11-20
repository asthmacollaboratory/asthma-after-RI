#!/usr/bin/env bash

# ==============================================================================
# Copyright 2019, Asthma Collaboratory
# Coded by Jennifer R. Elhawary (jennifer.elhawary@ucsf.edu)
# Special acknowledgement to Kevin L. Keys for his brilliant coding skills that 
# provided a template for this project.

# To run this, please go into your project folder and run the following:
# 	bash ./asthma-after-RI/analysis/run_analysis.sh
# ==============================================================================

# load environment variables from env.sh
source $PWD/asthma-after-RI/analysis/env.sh

# binaries
RSCRIPT="${RSCRIPT}"

# directories
MYHOME="${MYHOME}"
analysisdir="${analysisdir}"
bindir="${bindir}"
Rlib="${Rlib}"
srcdir="${srcdir}"
resultsdir="${resultsdir}"
figdir="${figdir}"

# files
phenocovarfile="${phenocovarfile}"
rsvseasonfile="${rsvseasonfile}" # see readme

# variables
populations="${populations}"
outcome="${outcome}"
predictor="${predictor}"
covars="${covars}"
glmfamily="${glmfamily}"
plot_type="${plot_type}"

# scripts
R_run_assoc_analysis="${srcdir}/run_AssocTests.R"
R_run_pairwisep_analysis="${srcdir}/run_PairwiseP.R"
R_run_fig_creation="${srcdir}/run_FigCreations.R"

# will loop over populations
# requires checking lengths of these arrays
# throw error if they aren't the same length
# otherwise, proceed with analysis
npops="${#populations[@]}"
ncovars="${#covars[@]}"
if [[ ${npops} -ne ${ncovars} ]]; then
    echo -e "Number of populations = ${npops}\nNumber of covariate lists = ${ncovars}\nThese numbers must match." 1>&2
    exit 1
fi


# loop over phenotypes and covariates
for i in $(seq 0 $((${npops} - 1)) ); do 

    pop="${populations[$i]}"
	covariates="${covars[$i]}"

# run association analysis
$RSCRIPT $R_run_assoc_analysis \
	--phenotype-file $phenocovarfile \
	--population $pop \
	--outcome-name $outcome \
	--predictor-names $predictors \
	--covariate-list $covariates \
	--glm-family $glmfamily \
	--output-directory $resultsdir 	
done

# run pairwise p-value tests
$RSCRIPT $R_run_pairwisep_analysis \
	--output-directory $resultsdir \
	--predictor-names $predictors 

# run figure creation
$RSCRIPT $R_run_fig_creation \
	--phenotype-file $phenocovarfile \
	--rsv-season-file $rsvseasonfile \
	--predictor-names $predictors \
	--plot-type $plot_type \
	--bin-directory $bindir \
	--output-directory $resultsdir
