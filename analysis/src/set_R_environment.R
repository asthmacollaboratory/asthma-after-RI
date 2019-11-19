
#!/usr/bin/env Rscript --vanilla
# ==============================================================================
# Copyright Asthma Collaboratory (2018)
# Coded by Kevin L. Keys and Jennifer R. Liberto
#
# This script loads all of the libraries required for analyses in this project.
# If a package is not installed, then the script will attempt to install it.
# The content of this file is similar in spirit to an .Rprofile.
# Load it at the beginning of analysis scripts.
# ==============================================================================

# ==============================================================================
# function definitions
# ==============================================================================
LoadPackage = function(package.name, library.path){
	# LoadPackage
	#
	# This function loads a package into the current workspace.
	# If the package is not installed, then LoadPackage will attempt to install it.
	# The installed package is then silently loaded

  if (!(package.name %in% row.names(installed.packages()))){
     install.packages(package.name, lib = library.path)
     library(package.name, lib.loc = library.path, character.only = TRUE, quietly = T, warn.conflicts = FALSE)
  } else {
     library(package.name, character.only = TRUE, quietly = T, warn.conflicts = FALSE)
  }
	return()
}

AutoloadPackages = function(vector.of.package.names, library.path){
	# AutoloadPackages
	#
	# This function calls LoadPackage on a vector of package names.
	#
	# Args:
	#	list.of.package.names: a vector of package names, e.g. c("ggplot2", "MASS")
	#
	# Output: NULL

	invisible(sapply(vector.of.package.names, LoadPackage, library.path))
	return()
}

# ==============================================================================
# environment variables
# ==============================================================================
cran.mirror     = "https://cran.cnr.berkeley.edu/"  # use UC Berkeley CRAN mirror
editor          = "vim"  # default text editor
library.path    = "./asthma-after-RI/R_Libraries"
bitmap.type     = "cairo"  # needed for producing raster plots

# this vector should contain all packages required for analysis
auto.loads = c("optparse", "stringr", "data.table", "dplyr", "descr",
               "ggplot2", "ggpubr", "ggrepel", "scales")

# ==============================================================================
# executable code
# ==============================================================================

# set CRAN mirror
local({
    r = getOption("repos")
    r["CRAN"] = cran.mirror
    options(repos = r)
})

# set group R library path
.libPaths(c(library.path, .libPaths()))



# R allows strings as factors by default
# make the default to *not* convert strings to factors
options(stringsAsFactors = FALSE)

# default text editor
options(editor = editor)

# enable raster graphics
options(bitmapType = bitmap.type)

# autoload packages
AutoloadPackages(auto.loads, library.path)

# omit NAs rather than having the computation fail.
options(na.action = na.omit)
