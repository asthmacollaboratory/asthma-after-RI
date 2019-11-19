
OddsRatioPlot = function(mydata, outdir = NULL, plot.type = "png"){

  # Creates Odds Ratio plot.  It expects a data frame with the following format, meta data allowed.
    #     OR:         odds ratio
    #     LL:         lower limit of confidence interval
    #     UL:         upper limit of confidence interval
    #     predictor:  grouping variable
    #     pop:        grouping variable
    #
    # Args:
    #     mydata: the data frame with column names [OR, LL, UL, predictor, pop]
    #     out.dir: a filepath for saving the plot to file
    #         Default: NULL (do not save to file)
    #     plot.type: file extension for the saved plot
    #         DEFAULT: png
    #
    # Returns:
    #     p is a ggplot object containing the Odds Ratio plot


   p <- ggplot(mydata, aes(color = pop)) +
        geom_pointrange(aes(x = predictor, y = as.numeric(OR), ymin = as.numeric(LL), ymax = as.numeric(UL)), position = position_dodge(width=0.6)) +
        scale_y_log10() +
        geom_hline(aes(yintercept = 1), col = 'gray50', lty = 2) +
        theme(legend.position = "bottom", 
              axis.text=element_text(size=15), 
              axis.title=element_text(size=15,face="bold"), 
              legend.text=element_text(size=15)) +
        guides(color = guide_legend(title = "",override.aes = list(linetype = 0))) +
        labs(y = "log10(Odds Ratio)", x = "")

   # save to file?
    if (!is.null(outdir) & is.character(outdir)) {
      save.as=paste0(outdir,"/OddsRatioPlot.",plot.type)
      cat("=>  saving Odds Ratio figure to:", save.as, "\n")
      ggsave(save.as, plot = p, width = 10, height = 7, units = "in")
    }
}
