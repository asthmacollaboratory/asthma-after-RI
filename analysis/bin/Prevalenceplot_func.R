
PrevalencePlot = function(mydata, outdir = NULL, predictors, plot.type = "png"){

  # Creates Prevalence plot.  It expects a data frame with the following format, meta data allowed.
    #     pop:         odds ratio
    #     predictor1:  first item in predictor list
    #     ...
    #     predictorN:  last item in predictor list
    #
    # Args:
    #     mydata: the data frame with column names [pop, predictor1, ..., predictorN]
    #     out.dir: a filepath for saving the plot to file
    #         Default: NULL (do not save to file)
    #     predictor.list: comma separated list of predictors, no spaces
    #     plot.type: file extension for the saved plot
    #         DEFAULT: png
    #
    # Returns:
    #     p is a ggplot object containing the Prevalence plot

  mypredictors <- unlist(str_split(predictors, ","))

  prev.table <- data.frame()
  for (i in mypredictors){
    tab <- CrossTable(x=mydata$Pop_Code, y=as.factor(mydata[[i]]), format='SAS', prop.r = T, prop.c=F, prop.t=F, prop.chisq=F, digits=4)
    prev.table <- rbind(prev.table,cbind(prev = round(tab$prop.row[,2],digits = 3), predictor = i))
  }
  prev.table$group <- gsub(pattern = "\\d$", replacement = "", x = rownames(prev.table))

   p <- ggplot(prev.table, aes(x=predictor, y=as.numeric(as.character(prev)), fill=group)) +
        geom_bar(stat='identity', position = position_dodge(width=0.91)) +
        scale_y_continuous(labels=scales::percent) +
        geom_text(aes(label=scales::percent(as.numeric(as.character(prev)))), 
                  position=position_dodge(width=0.9), vjust=-0.5, size = 3) +
        guides(fill = guide_legend(title = "",override.aes = list(linetype = 0))) +
        theme(axis.text = element_text(size=15),
              axis.title.y = element_text(size = rel(1.5), face="bold"),
              legend.text = element_text(size = 15),
              legend.position="bottom", 
              plot.title = element_text(hjust = 0.5)) +
        labs(x = '', y='Proportion of Early-Childhood Respiratory Illness')

   # save to file?
    if (!is.null(outdir) & is.character(outdir)) {
      save.as=paste0(outdir,"/PrevalencePlot.",plot.type)
      cat("=>  saving Prevalence figure to:", save.as, "\n")
      ggsave(save.as, plot = p, width = 10, height = 7, units = "in")
    }
}
