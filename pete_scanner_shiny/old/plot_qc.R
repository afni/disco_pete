library(tidyverse)
library(ggplot2)

setwd('/Users/molfesepj/Library/CloudStorage/OneDrive-NationalInstitutesofHealth/FMRIF/fmrif_qc_plot')

#load data
A3 = read.csv('fbirn_3ta_00.txt')
B3 = read.csv('fbirn_3tb_00.txt')
D3 = read.csv('fbirn_3td_00.txt')
A7 = read.csv('fbirn_7ta_00.txt')
B7 = read.csv('fbirn_7tb_00.txt')
B7$scanner='fmrif7tb'
A7$scanner='fmrif7ta'

mydata = A3
mydata = rbind(mydata, B3)
mydata = rbind(mydata, D3)
mydata = rbind(mydata, A7)
mydata = rbind(mydata, B7)

mydata$scanner = as.factor(mydata$scanner)
mydata$Date = as.Date(mydata$Date, format="%Y-%m-%d")
mydata$month = format(as.Date(mydata$Date, format="%Y-%m-%d"), "%m")
mydata$year = format(as.Date(mydata$Date, format="%Y-%m-%d"), "%Y")

ggplot(mydata[mydata$scanner=='fmrif7ta',], aes(x=Date, y=mean_tsnr, colour=year)) + geom_point() + theme(axis.text.x=element_text(angle=90, hjust=1))

ggplot(mydata, aes(x=Date, y=mean_tsnr, colour=month)) + geom_point() + facet_wrap(~scanner, scales='free_x', nrow = 5) + theme(axis.text.x=element_text(angle=90, hjust=1))
ggsave('myplot2.png')


ggplot(mydata, aes(x=Date, y=mean_tsnr, colour=year)) + geom_point() + facet_wrap(~scanner, scales='free_x', nrow = 5) + theme(axis.text.x=element_text(angle=90, hjust=1))
