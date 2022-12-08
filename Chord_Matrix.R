#!/usr/bin/env Rscript
# https://jokergoo.github.io/circlize_book/book/circular-layout.html
# https://www.rdocumentation.org/packages/circlize/versions/0.4.15/topics/circos.text
# library
library(circlize)
library(glue)
layout(matrix(1:0.7, 0.7, 0.7))

cols_all  = rand_color(20)
args = commandArgs(trailingOnly=TRUE)
arg0 = args[1]
df2 <- read.csv('/Users/mo11/work/Chord_Plots/sample_data/matrix_sample.tsv', header=TRUE,sep='\t',row.names = 1,)
df2 <- read.csv(arg0, header=TRUE, row.names="X")
dims = dim(df2)[1]+dim(df2)[2]-2
par(mar = c(0.5), bg=rgb(1,1,1,0.1) )
factors = 1:dims
library(hash)
# Produce input vector for the rows and columns and color accordingly
color_string = c()
text_string = c()
indexes =hash()

count=0
for (val in row.names(df2))
{
    if(val!='color'){
        count = count+1
        color_string <- c(color_string,cols_all[ df2[val,'color']]) 
        text_string <- c(text_string,val) 
        indexes[val] <- count
    }
}

unique_vals = unique(as.vector(as.matrix(df2[-1,-1])))
unique_vals<-unique_vals[!is.na(unique_vals)]
link_colors =hash()
for(val1 in unique_vals){
    print(val1)
    link_colors[val1]=rand_color(1,luminosity="light")
}

for (val in colnames(df2))
{
    if(val!='color'){
        count = count+1
        color_string <- c(color_string, cols_all[df2['color',val]]) 
        text_string <- c(text_string,val) 
        indexes[val] <- count
    }
}


h <- hash()
for (val1 in row.names(df2))
{
    if(val1!='color'){
        for (val2 in colnames(df2))
        {
            if(val2!='color'){
                print(glue(' {val1} -- {val2}.'))
                print(df2[c(val1),c(val2)])
                if (!is.na( df2[c(val1),c(val2)])){
                    d = h[[val1]]
                    if(is.null(d)){
                        h[val1] <- c(val2)
                    }else{
                    print('no')
                    gfg <-h[[val1]]
                    gfg <- append(gfg, val2)
                    h[val1]<-gfg
                    }
                }
            }
        }
    }
}

circos.par(cell.padding = c(0, 0, 0, 0)) 
circos.initialize(factors, xlim = c(0, .5)) 
count=0
circos.trackPlotRegion(ylim = c(0, 1), track.height = 0.1, bg.col = color_string, bg.border = NA, panel.fun = function(x, y) {
    l = CELL_META$sector.numeric.index
    circos.text(CELL_META$xcenter[1]- mm_x(6), CELL_META$cell.ylim[2] + mm_y(2),
        text_string[l], facing = "reverse.clockwise", niceFacing = TRUE,
        adj = c(1, 0.5), cex = 0.4,col = color_string[l])
    
    for(v1 in h[[text_string[l]]]){
        color = link_colors[[as.character(df2[text_string[l],v1])]]
        circos.link(l, 0.25, indexes[[v1]], 0.25, col = color,lwd = 2,)
    }
    
} )


# add links
for(i in 1:2) {
    se = sample(factors, 2)
    circos.link(se[1], c(1,1), se[2], runif(2), col = rand_color(1, transparency = 0.4)) 
    
}
