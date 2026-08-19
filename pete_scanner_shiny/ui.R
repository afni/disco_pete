## top ##################################
## 01/2025 Justin Rajendra
## Scanner QC for Pete
## UI

header <- dashboardHeader(title=paste("Scanner QC"),titleWidth=290)

## sidebar top #####################
sidebar <- dashboardSidebar(
  width=290,
  sidebarMenu(
    id="tabs",
    
    ## subject and date item #############################################
    menuItem(
      "Scanners",icon=icon('check'),selected=TRUE,startExpanded=TRUE,
      br(),
      h4(paste('Last Updated:',end.date)),
      
      selectInput('scannerSel','Select Scanner',levels(data.df$scanner),
                  selected=levels(data.df$scanner),multiple=TRUE),
      
      dateRangeInput('dateRange','Date Range',
                     min=min(data.df$Date,na.rm=TRUE),
                     max=max(data.df$Date,na.rm=TRUE),
                     start=min(data.df$Date,na.rm=TRUE),
                     end=max(data.df$Date,na.rm=TRUE)),
      
      actionButton('lastWeek','Last Week'),
      actionButton('lastMonth','Last 30 Days'),
      actionButton('allDates','All Dates'),
      
      selectInput('dataType','Data Type',c('tSNR'='mean_tsnr','SNR'='mean_snr'),
                  selected=c('tSNR'),multiple=FALSE),
      
      # selectInput('overlay','Overlay By',c('Data Type','Scanner','None'),
      #             selected='None'),
      # 
      # checkboxInput('col_month','Color by Month',FALSE),
      
      checkboxInput('matchY','Separate Ranges',FALSE),
      
      sliderInput('smooth','LOESS Smoothing',0,0.2,0),

      


      br()
    )   ## end subject and date
  
  )   ## end sidebar menu                  
)   ## end sidebar

## body top #######################################################################
body <-  dashboardBody(
   
   plotlyOutput('plot_out',height='800px')

  
)   ## end dashboard body

## run it
dashboardPage(header, sidebar, body)

