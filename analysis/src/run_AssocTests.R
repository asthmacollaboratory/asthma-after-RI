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
        c("-b", "--population"),
        type    = "character",
        default = NULL,
        help    = "Variable name of outcome found in your phenotype file.",
        metavar = "character"
    ),
    make_option(
        c("-c", "--outcome-name"),
        type    = "character",
        default = NULL,
        help    = "Variable name of outcome found in your phenotype file.",
        metavar = "character"
    ),
    make_option(
        c("-d", "--predictor-names"),
        type    = "character",
        default = NULL,
        help    = "Comma-separated list of predictors found in you phenotype file.",
        metavar = "character"
    ),
    make_option(
        c("-e", "--covariate-list"),
        type    = "character",
        default = NULL,
        help    = "Comma-separated list of covariates found in you phenotype file.",
        metavar = "character"
    ),
    make_option(
        c("-f", "--glm-family"),
        type    = "character",
        default = "logistic",
        help    = "Name of glm family. Default:default.",
        metavar = "character"
    ),
    make_option(
        c("-g", "--output-directory"),
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

pop.code        = opt$population
pheno.file      = opt$phenotype_file
outcome         = opt$outcome_name
predictor.list  = opt$predictor_names
covariate.list  = opt$covariate_list
glm.family      = opt$glm_family
out.dir         = opt$output_directory

# use for tagging saved results
# this prints in YYYY-MM-DD format
the.date = Sys.Date()

# ==============================================================================
# Load data
# ==============================================================================

cat("Loading data for population ", pop.code, "\n")

# load unified phenotype data table from file
phenotype.df = fread(pheno.file, header = TRUE)

# subset phenotype.df to current pop
phenotype.df = phenotype.df %>%
    dplyr::filter(Pop_Code == pop.code)

cat("Loading data complete\n")

#==============================================================================
# Run association anslysis
#==============================================================================

myoutcome <- outcome
mypredictors <- unlist(str_split(predictor.list, ","))
mycovars <- str_c(unlist(str_split(covariate.list, ",")), collapse = " + ")


cat("\nRunning analysis for population ", pop.code, "\n")

# run the analysis for each predictor and place into a data frame
df <- data.frame()
for (i in mypredictors){
  form <- formula(paste0(myoutcome,"~",i," + ",mycovars))
  fam <- glm.family
  mod <- glm(form, data = phenotype.df, family = fam)
  OR <- exp(mod$coefficients[2])
  CI <- exp(confint(mod, parm = i))
  SE <- summary(mod)$coef[2, 2]
  Beta <- mod$coefficients[2]
  p.value <- summary(mod)$coef[2, 4]
  N <- nobs(mod)
  df <- rbind(df, cbind(OR, LL = CI[1], UL = CI[2], p.value, N, SE, Beta))
}
df$predictor <- row.names(df)
df$pop <- pop.code

cat("Analysis for population", pop.code, "complete.\n")

#==============================================================================
# Print results to file
#==============================================================================
outfile <- paste0(out.dir, "/", pop.code, ".AssocResults.txt")
cat("printing results to:", outfile, "\n")
write.table(df, file = outfile, sep = "\t", quote = F, row.names = F)
