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
        c("-a", "--output-directory"),
        type    = "character",
        default = NULL,
        help    = "Directory where output will be saved.",
        metavar = "character"
    ),
    make_option(
        c("-b", "--predictor-names"),
        type    = "character",
        default = NULL,
        help    = "Comma-separated list of predictors found in you phenotype file.",
        metavar = "character"
    )
)

opt_parser = OptionParser(option_list = option_list)
opt = parse_args(opt_parser, convert_hyphens_to_underscores = TRUE)

cat("Parsed options:\n")
print(opt)

out.dir         = opt$output_directory
predictor.list  = opt$predictor_names

# use for tagging saved results
# this prints in YYYY-MM-DD format
the.date = Sys.Date()

# ==============================================================================
# Load data
# ==============================================================================

cat("Loading association results for all populations\n")

# load all association results
listoffiles = list.files(out.dir, pattern = "AssocResults.txt$")
myfiles <- paste0(out.dir,"/", listoffiles)
mydatalist = lapply(myfiles, fread)

cat("Loading association results complete\n")


#==============================================================================
# Run p-value anslysis
#==============================================================================

# merge all files together
assoc.results <- do.call(rbind.data.frame, mydatalist)
mydata.as.list <- split(assoc.results, f=assoc.results$pop)

mycombos <- combn(unique(assoc.results$pop),2,simplify = F)
mypredictors <- unlist(str_split(predictor.list, ","))

cat("\nRunning pairwise p-value analysis.\n")

pairwise.pvals <- list()
for (i in mypredictors){
  df <- data.frame()
  for (j in 1:length(mycombos)){
    name1 <- mycombos[[j]][1]
    name2 <- mycombos[[j]][2]

    BETA1 <- mydata.as.list[[name1]][predictor == i,"Beta"]
    BETA2 <- mydata.as.list[[name2]][predictor == i,"Beta"]

    SE1 <- mydata.as.list[[name1]][predictor == i,"SE"]
    SE2 <- mydata.as.list[[name2]][predictor == i,"SE"]

    delta <- abs(BETA1-BETA2)
    deltase <- sqrt(SE1^2+SE2^2)


    Z <- as.numeric(delta/deltase)
    P <- 2*(1-pnorm(Z))
    df <- rbind(df, cbind(predictor=i,A=name1,B=name2,P.val=round(P, digits = 3)))
  }
  pairwise.pvals[[i]] <- df
}

cat("Finished running pairwise p-value analysis.\n")

#==============================================================================
# Print results to file
#==============================================================================
df <- do.call(rbind.data.frame, pairwise.pvals)

outfile <- paste0(out.dir, "/PairwisePResults.txt")
cat("printing results to:", outfile, "\n")
write.table(df, file = outfile, sep = "\t", quote = F, row.names = F)

