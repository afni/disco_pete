## top ##################################
## 01/2025 Justin Rajendra
## Scanner QC for Pete
## Server 

## server top #####################################
shinyServer(function(input,output,session) {
   options(warn = -1)
   session$onSessionEnded(function() { cat('\nAll done!\n') ; stopApp() })
   
   ## date shortcuts #################
   
   observeEvent(input$lastWeek,{
      updateDateRangeInput(session,'dateRange',start=(end.date-6),end=end.date) 
   })
   observeEvent(input$lastMonth,{
      updateDateRangeInput(session,'dateRange',start=(end.date-30),end=end.date) 
   })
   observeEvent(input$allDates,{
      updateDateRangeInput(session,'dateRange',start=start.date,end=end.date)
   })
   
   ## output the main graph #################
   output$plot_out <- renderPlotly({
      
      ## plot parameters
      if( input$dataType == 'mean_tsnr' ){
         main.title <- 'Mean tSNR'
      } else if( input$dataType == 'mean_snr' ){
         main.title <- 'Mean SNR'
      }
      
      ## show notification about smoothing
      show.note <- FALSE
      
      ## auto range or match all subplots
      if( !input$matchY ){
         allPlot.df <- subset(data.df,data.df$scanner %in% input$scannerSel)
         y.range <- range(allPlot.df[[input$dataType]])
         y.range <- c(0,y.range[2]*1.05)
      } else {
         y.range <- NULL
      }
      
      ## empty list to add subplots
      plot.list <- list()
      
      ## loop through the selected scanners
      for( s in 1:length(input$scannerSel) ){
         
         ## subset by scanner then date
         plot.df <- subset(data.df,data.df$scanner == input$scannerSel[s])
         plot.df <- subset(plot.df,plot.df$Date >= input$dateRange[1] &
                              plot.df$Date <= input$dateRange[2])
         
         ## adjust marker size
         if( max(plot.df$Date) - min(plot.df$Date) > 30 ){
            point.size <- 6
         } else {
            point.size <- 13
         }
         ## add empty plot to list
         plot.list[[s]] <- plot_ly(type="scatter",mode="markers",evaluate=TRUE)
         
         ## main data
         plot.list[[s]] <- add_trace(plot.list[[s]],
                                     x=plot.df$Date,y=plot.df[[input$dataType]],
                                     name=input$scannerSel[s],
                                     marker=list(color=marker.color[s],
                                                 size=point.size),
                                     evaluate=TRUE)
         
         ## add smoothing line if requested
         if( input$smooth > 0 ){
            
            ## calculate smoothing
            smo <- try(loess(plot.df[[input$dataType]] ~ as.numeric(plot.df$Date),
                             span=input$smooth),silent=TRUE)
            res <- try(smo$residuals,silent=TRUE)
            
            if( class(res) != "try-error" ){
               ## add to current subplot
               plot.list[[s]] <- add_lines(
                  plot.list[[s]],x=plot.df$Date,y=predict(smo),
                  showlegend=FALSE,
                  line=list(color=line.color[s],width=~line.wd))
            } else {
               show.note <- TRUE
            }
         }
         
         ## fix up the layout (y range etc.)
         plot.list[[s]] <- layout(plot.list[[s]],yaxis=list(range=y.range))
         
      }
      
      ## show notification for span error
      if( show.note ){
         showNotification("Smoothing span too small for number of data points.",
                          type="message")
      }
      
      ## combine list of plots and output them in 1 column
      plot.ly <- subplot(plot.list,nrows=length(input$scannerSel),shareX=TRUE)
      plot.ly <- layout(plot.ly,title=main.title)
      plot.ly
   })
   
   
})   ## end server ###########################



