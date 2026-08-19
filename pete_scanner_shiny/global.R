## top ##################################
## 01/2025 Justin Rajendra
## Scanner QC for Pete
## global

suppressPackageStartupMessages(library(shiny))
suppressPackageStartupMessages(library(data.table))
suppressPackageStartupMessages(library(shinydashboard))
suppressPackageStartupMessages(library(plotly))
suppressPackageStartupMessages(library(RColorBrewer))


## clean up
rm(list=ls())

## for the possible wrong dates on the server
Sys.setenv(TZ="America/New_York")

## helper functions #############################


## import data ####################################
file.list <- list.files("data","*.txt",full.names=TRUE)
data.df <- c()
for( f in file.list ){
   temp.df <- fread(f)
   data.df <- rbind(data.df,temp.df)
}
rm(temp.df)

## fix up data ###################

data.df$scanner <- factor(data.df$scanner)
levels(data.df$scanner)[levels(data.df$scanner)=="AWP79139"] <- "fmrif7tb"

## sort by date just in case
data.df <- sort_by(data.df,data.df$Date)  

## lists for choices ##################################

start.date <- min(data.df$Date)
end.date <- max(data.df$Date)

### plot parameters ##################################
trans <- 0.25
line.wd <- 3
# point.size <- 2
markers <- c(21,23)
marker.size <- 3
jit <- 0.1

## colors #########################################
paired.col <- brewer.pal(12,"Paired")
dark.col <- brewer.pal(8,"Dark2")
set1.col <-  brewer.pal(8,"Set1")
acc.col <- brewer.pal(8,"Accent")
rain.col <- rainbow(6)[c(1,3,4,5,6)]

marker.color <- c('#1ECBE1','#EB9114','#29D68D','#006AFF','#8E5BA4')
line.color <- c('#E1341E','#146EEB','#D62972','#FF9500','#0DF244')


### stat functions ##################################
