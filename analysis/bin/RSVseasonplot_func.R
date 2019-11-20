
RSVseasonPlot = function(mydata, outdir = NULL, plot.type = "png"){

  # Creates RSV Season plot.  It expects a data frame with the following format.
    #     calendar.week: value 1-52 for calendar week in year
    #     weekending:  date of weekend end
    #     country: Unites States (US) or Puerto Rico (PR)
    #     year: value where first number is the current year and the second number is the current year + 1
    #     total.RSV.tests: total number of RSV tests performed
    #     positive.RSV.tests:  total number of positive tests
    #     percent positive:  postive tests/total tests
    #
    # Args:
    #     mydata: the data frame with column names [calendar.week, weekending, country, year, total.RSV.tests, positive.TSV.tests, percent positive]
    #     out.dir: a filepath for saving the plot to file
    #         Default: NULL (do not save to file)
    #     plot.type: file extension for the saved plot
    #         DEFAULT: png
    #
    # Returns:
    #     p is a ggplot object containing the RSVseason plot
  rsvdat <- mydata %>%
    filter(!(country == "PR" & year == "1112")) %>%
    group_by(calendar.week,country) %>%
    summarize(mean_perc.pos = mean(`percent positive`, na.rm = T)) %>%
    mutate(month = ifelse(calendar.week %in% c(1:5), 1,
                    ifelse(calendar.week %in% c(6:9), 2,
                    ifelse(calendar.week %in% c(10:13), 3,
                    ifelse(calendar.week %in% c(14:18), 4,
                    ifelse(calendar.week %in% c(19:22), 5,
                    ifelse(calendar.week %in% c(22:26), 6,
                    ifelse(calendar.week %in% c(27:31), 7,
                    ifelse(calendar.week %in% c(32:35), 8,
                    ifelse(calendar.week %in% c(36:39), 9,
                    ifelse(calendar.week %in% c(40:44), 10,
                    ifelse(calendar.week %in% c(45:48), 11,
                    ifelse(calendar.week %in% c(49:53), 12, NA))))))))))))) %>%
    arrange(match(month, c(6:12,1:5)), calendar.week)

  rsvdat$calendar.week <- factor(rsvdat$calendar.week,levels=unique(rsvdat$calendar.week))

   p <- ggplot(rsvdat, aes(color = country, group = country, x = calendar.week, y = mean_perc.pos)) +
        geom_point() +
        scale_y_continuous(labels=c("0","10","20","30","40","50","60"),
                             breaks = c(0,.1,.2,.3,.4,.5,.6)) +
        scale_color_manual(breaks = c("PR", "US"),
                             values=c("red", "blue")) +
        geom_line(linetype = "solid",
                    size =0.5) +
        geom_hline(aes(yintercept = .10),
                     col = 'gray50',
                     lty = 2) +
        theme_classic() +
        labs(x = "",
               y = "Average Percent Positive") +
        theme(legend.position="none",
                axis.text=element_text(size=20),
                text = element_text(size=20, face='bold'),
                legend.key.size = unit(1, 'cm'),
                plot.margin=unit(c(0.25,0.5,0,0),"cm"),
                legend.margin=margin(0,0,0,0)) +
        guides(color = guide_legend(title = "", override.aes = list(linetype = 0))) +
        annotate("text",
                   x = 47,
                   y = 0.13,
                   label = 'paste(bold("Mainland\n     USA"))',
                   color = "blue",
                   parse = TRUE,
                   size = 6.5) +
        annotate("text",
                   x = 26,
                   y = .40,
                   label = 'paste(bold("Puerto Rico"))',
                   color = "red",
                   parse = TRUE,
                   size = 6.5) +
        scale_x_discrete(breaks = c(27, 52, 18),
                           labels = c("August", "December", "July")) +
        theme(axis.ticks.x = element_blank() )

   # save to file?
    if (!is.null(outdir) & is.character(outdir)) {
      save.as=paste0(outdir,"/RSVseasonPlot.",plot.type)
      cat("=>  saving RSV season figure to:", save.as, "\n")
      ggsave(save.as, plot = p, width = 10, height = 7, units = "in")
    }
}
