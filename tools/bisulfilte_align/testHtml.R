#!/usr/bin/env Rscript

## begin warning handler)

suppressPackageStartupMessages(require(optparse))

option_list = list(
make_option(c("-a", "--avar"), action="store", default=NA, type='character',help="just a variable named assembly"),
make_option(c("-b", "--bvar"), action="store", default=NA, type='character',help="just a variable named destranded"),
make_option(c("-c", "--cvar"), action="store", default=NA, type='character',help="just a variable named outpath"),
make_option(c("-d", "--dvar"), action="store", default=NA, type='character',help="just a variable named gile name"),
make_option(c("-i", "--ivar"), action="store", default=NA, type='character',help="just a variable named file name"),
make_option(c("-p", "--ipvar"), action="store", default=NA, type='character',help="just a variable named f name")
)
opt = parse_args(OptionParser(option_list=option_list))
 




ata<-data.frame(Stat11=rnorm(100,mean=3,sd=2),
Stat21=rnorm(100,mean=4,sd=1),
Stat31=rnorm(100,mean=6,sd=0.5),
Stat41=rnorm(100,mean=10,sd=0.5),
Stat12=rnorm(100,mean=4,sd=2),
Stat22=rnorm(100,mean=4.5,sd=2),
Stat32=rnorm(100,mean=7,sd=0.5),
Stat42=rnorm(100,mean=8,sd=3),
Stat13=rnorm(100,mean=6,sd=0.5),
Stat23=rnorm(100,mean=5,sd=3),
Stat33=rnorm(100,mean=8,sd=0.2),
Stat43=rnorm(100,mean=4,sd=4))

dir.create(opt$c, showWarnings = FALSE)
img = paste0(opt$c,'/','rplot.jpeg')


jpeg(img)
boxplot(ata)
dev.off()

content =paste('<html> this is the test file' , '<img src= "rplot.jpeg" alt="box plot" style="width:304px;height:228px;">', '/html')

write(content, file = opt$d,
      append = FALSE, sep = " ")



 

