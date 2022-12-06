#!/usr/bin/env Rscript

args = commandArgs(trailingOnly=TRUE)
arg0 = args[1]
arg1 = args[2]

print("############")
print(args)
print('arg0:')
print(arg0)
print('arg1:')
print(arg1)
print("############")

library(GOplot)
library(dplyr)
library(tidyverse)
library(svglite)

df2 <- read.csv(arg0, header=TRUE, row.names="X")
res <- 144
svglite(arg1, width = 1080/res, height = 820/res,scaling = 0.2,)
GOChord(df2,  gene.order = 'logFC', gene.space = 0.25, gene.size = 2)
dev.off()