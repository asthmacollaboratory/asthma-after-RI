#!/usr/bin/env bash

# Store any sensitive file paths, binaries, etc as variables here
# you will source this in the run_analysis.sh

# please only edit me between the lines
# ----------------------------------------------------------------------------------------

projectdir=~
# default: ~
# help: "The path to your project directory. Do not add quotes."

phenotype_file=NULL
# default: NULL
# help: "The filename of your cleaned phenotype file. Make sure this file is 
#	in your project directory and has your phenotype and covariates."

rsvseason_file=NULL
# default: NULL
# help: "The filename containing the data for the RSV season figure. See README for
#  	information on how to obtain this data."

populations=NULL
# default: NULL
# help: "Array of populations found in the variable Pop_Code in your cleaned phenotype file."

outcome=NULL
# default: NULL
# help: "Your outcome variable. Make sure I match exactly to the variable name in your 
#	phenotype file."

predictors=NULL
# default: NULL
# help: "Your predictor or comma separated list of predictors; no spaces please. Make 
#	sure I match exactly to the variable name(s) in your phenotype file."

covars=NULL
# default: NULL
# help: "Array of comma separated lists of your covariates; no spaces within the lists
#	please. Make sure each covariate name matches exactly to those in your phenotype file."

glmfamily="binomial"
# default: "binomial"
# help: "Please let me know the glm family you are using. I accept 
# 	"binomial", "gaussian", "Gamma", "inverse.gaussian", "poisson", "quasi", 
#	"quasibinomial", "quasipoisson"."

plot_type="png"
# default: "png"
# help: "Please let me know in what format you want your plots to be saved in. I accept 
#	"eps", "ps", "tex" (pictex), "pdf", "jpeg", "tiff", "png", "bmp", "svg", and 
#   	"wmf" (windows only)."		
										
rscript_path=/usr/local/bin/Rscript
# default: /usr/local/bin/Rscript
# help: "Please let me know the path to your Rscript. You can find me by asking `which Rscript`
#   	in the terminal."		

### STOP DO NOT EDIT FURTHER ###
# ----------------------------------------------------------------------------------------



# binaries
RSCRIPT= ${rscript_path}

# directories
MYHOME=${projectdir}
analysisdir=${MYHOME}/asthma-after-RI/analysis
bindir=${analysisdir}/bin
Rlib=${analysisdir}/R_Libraries
srcdir=${analysisdir}/src
resultsdir=${MYHOME}/results
figdir=${resultsdir}/figures


if [ -d ${resultsdir} ]; then
    echo -e "placing results in:\n\t${resultsdir}\n"
else
	mkdir ${resultsdir} ${figdir}
fi


# files
phenocovarfile=${MYHOME}/${phenotype_file}
rsvseasonfile=${MYHOME}/${rsvseason_file}
