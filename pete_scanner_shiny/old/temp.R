
suppressPackageStartupMessages(library(shiny))
suppressPackageStartupMessages(library(data.table))
suppressPackageStartupMessages(library(shinydashboard))
suppressPackageStartupMessages(library(plotly))
suppressPackageStartupMessages(library(lubridate))
suppressPackageStartupMessages(library(RColorBrewer))
suppressPackageStartupMessages(library(dygraphs))
suppressPackageStartupMessages(library(xts))


## clean up
rm(list=ls())

## for the wrong dates on the server
Sys.setenv(TZ="America/New_York")


BaseFolder <- "/Users/discoraj/Documents/nih/pete_scanner_shiny/data"
setwd(BaseFolder)



file.list <- list.files(".","*.txt")
data.df <- c()
for( f in file.list ){
   temp.df <- fread(f)
   
   data.df <- rbind(data.df,temp.df)
   
}
rm(temp.df)




# data.df$scanner <- factor(data.df$scanner)
# data.df$Date <- ymd(data.df$Date)
# levels(data.df$scanner)[levels(data.df$scanner)=="AWP79139"] <- "fmrif7tb"
# 
# time.df <- xts(data.df$mean_snr,data.df$Date)
# dygraph(time.df)
