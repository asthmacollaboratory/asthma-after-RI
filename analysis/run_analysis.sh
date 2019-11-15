#$ -S /bin/sh


## This is currently very much in progress and will be completed before Thanksgiving 2019.

# user limits: -c max size of core files created
date
hostname
ulimit -c 0

# ==============================================================================
# Copyright 2019, Asthma Collaboratory
# coded by Jennifer Elhawary 
# ==============================================================================


# load environment variables from env.sh
source ./env.sh

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

# variables
pheno="${pheno}"
covars="${covars}"
assoc_type="${assoc_type}"
plot_type="${plot_type}"
outsfx="${outsfx}"

# scripts
R_set_environment="${srcdir}/set_R_environment.R"
R_run_analysis="${srcdir}/run_AssocTests.R"

# run analysis
Rscript $R_run_analysis \
	--phenotype-file $phenocovarfile\
	--phenotype-name $pheno \
	--covariates $covars \
	--association-type $assoc_type \
	--plot-extension $plot_type \
	--library-path $Rlib \
	--output-directory $resultsdir \
	--source-directory $srcdir \
	--binaries-directory $bindir \
	--output-suffix $outsfx
