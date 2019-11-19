#!/usr/bin/env Rscript --vanilla

# ==============================================================================
# Copyright 2019, Asthma Collaboratory
# Coded by Jennifer R. Elhawary (jennifer.elhawary@ucsf.edu)
# Special acknowledgement to Kevin L. Keys for his brilliant coding skills that 
# provided a template for this project.
# ==============================================================================


source("./asthma-after-RI/analysis/src/set_R_environment.R")


#==============================================================================
# parse options
#==============================================================================

option_list = list(
    make_option(
        c("-a", "--phenotype-file"),
        type    = "character",
        default = NULL,
        help    = "Path to cleaned phenotype file.",
        metavar = "character"
    ),
    make_option(
        c("-b", "--rsv-season-file"),
        type    = "character",
        default = NULL,
        help    = "Path to rsv season data from _____.",
        metavar = "character"
    ),
    make_option(
        c("-c", "--predictor-names"),
        type    = "character",
        default = NULL,
        help    = "Comma-separated list of predictors found in you phenotype file.",
        metavar = "character"
    ),
    make_option(
        c("-d", "--plot-type"),
        type    = "character",
        default = NULL,
        help    = "File extention of the plots.",
        metavar = "character"
    ),
    make_option(
        c("-e", "--bin-directory"),
        type    = "character",
        default = NULL,
        help    = "Directory where plotting functions are stored.",
        metavar = "character"
    ),
    make_option(
        c("-f", "--output-directory"),
        type    = "character",
        default = NULL,
        help    = "Directory where output will be saved.",
        metavar = "character"
    )
)

opt_parser = OptionParser(option_list = option_list)
opt = parse_args(opt_parser, convert_hyphens_to_underscores = TRUE)

cat("Parsed options:\n")
print(opt)

pheno.file      = opt$phenotype_file
season.file     = opt$rsv_season_file
predictor.list  = opt$predictor_names
plottype        = opt$plot_type
bin.dir         = opt$bin_directory
out.dir         = opt$output_directory


# use for tagging saved results
# this prints in YYYY-MM-DD format
the.date = Sys.Date()

# ==============================================================================
# Load data
# ==============================================================================
setwd("~/Desktop/RSVpaperproject/")
cat("Loading data for figure creation\n")

# load RSV season data
# this dataset is not housed on the github webpage and may be accessed by contacting the authors of:___________
rsvdata.df = fread(season.file, header = T)
cat("=>  rsv season data loaded\n")

# load phenotype file
phenotype.df = fread(pheno.file, header = TRUE)
cat("=>  phenotype data loaded\n")

# load and merge all association results
listofresults = list.files(out.dir, pattern = "AssocResults.txt$")
myfiles <- paste0(out.dir,"/", listofresults)
mydatalist = lapply(myfiles, fread)
assoc.results <- do.call(rbind.data.frame, mydatalist)
cat("=>  association results loaded\n")

cat("Finished loading data for figure creation\n")
# ==============================================================================
# Source figure creation functions
# ==============================================================================
RSVseason.path <- paste0(bin.dir,"/RSVseasonplot_func.R")
Prevalence.path <- paste0(bin.dir,"/Prevalenceplot_func.R")
OddsRatio.path <- paste0(bin.dir,"/OddsRatioplot_func.R")

cat("\nPlotting\n")

# figure 1: RSV season Plot
source(RSVseason.path)
RSVseasonPlot(rsvdata.df, outdir = paste0(out.dir,"/figures"), plot.type = plottype)

# figure 2: Prevalence Plot
source(Prevalence.path)
PrevalencePlot(phenotype.df, outdir = paste0(out.dir,"/figures"), predictors = predictor.list, plot.type = plottype)

# figure 3: Odds Ratio Plot
source(OddsRatio.path)
OddsRatioPlot(assoc.results, outdir = paste0(out.dir,"/figures"), plot.type = plottype)

cat("Plotting complete\n")
