#!/usr/bin/env Rscript
# https://jokergoo.github.io/circlize_book/book/circular-layout.html
# https://www.rdocumentation.org/packages/circlize/versions/0.4.15/topics/circos.text
# library
library(circlize)
library(hash)

cols_all  = rand_color(20)
args = commandArgs(trailingOnly=TRUE)
arg1 = args[1]
arg2 = args[2]
# arg1='/Users/mo11/work/Chord_Plots/t2.txt'
df2 <- read.csv(arg1, header=TRUE,sep='\t',row.names = 1,)
dims = dim(df2)[1]+dim(df2)[2]-2

factors = 1:dims

# Produce input vector for the rows and columns and color accordingly
color_string = c()
text_string = c()
indexes =hash()

count=0
for (val in row.names(df2))
{
    if(val!='color'){
        print(val)
        count = count+1
        existing_col_or_int = df2[val,'color']
        if (substr(existing_col_or_int,1,1)=='#'){
            color_string <- c(color_string,existing_col_or_int)
        }else{
            color_string <- c(color_string,cols_all[ df2[val,'color']]) 
        }
        
        text_string <- c(text_string,val) 
        indexes[val] <- count
    }
}

unique_vals = unique(as.vector(as.matrix(df2[-1,-1])))
unique_vals<-unique_vals[!is.na(unique_vals)]
link_colors =hash()
for(val1 in unique_vals){
    print(val1)
    if (!val1==""){
        if (substr(existing_col_or_int,1,1)=='#'){
            link_colors[val1]=val1
        }else{
            link_colors[val1]=rand_color(1,luminosity="light", transparency = 0.4)
        }
    }
}

for (val in colnames(df2))
{
    if(val!='color'){
        count = count+1
        existing_col_or_int =df2['color',val]
        if (substr(existing_col_or_int,1,1)=='#'){
            color_string <- c(color_string, existing_col_or_int)
        }else{
            color_string <- c(color_string, cols_all[df2['color',val]]) 
        }
        # color_string <- c(color_string, cols_all[df2['color',val]]) 
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
                if (!is.na( df2[c(val1),c(val2)])){
                    d = h[[val1]]
                    if(is.null(d)){
                        h[val1] <- c(val2)
                    }else{
                        gfg <-h[[val1]]
                        gfg <- append(gfg, val2)
                        h[val1]<-gfg
                    }
                }
            }
        }
    }
}
res <- 144
# svglite(arg1, width = 1080/res, height = 820/res,scaling = 0.2,)

# svg("/Users/mo11/work/Chord_Plots/my_plot3.svg",width = 1080/res, height = 820/res)
# layout(matrix(1:1, 1, 1),respect = TRUE)
# circos.par(cell.padding = c(0, 0, 0, 0),circle.margin=c(0.9,0.9,0.9,0.9)) 
# circos.initialize(factors, xlim = c(0, .5)) 
# count=0
# circos.trackPlotRegion(ylim = c(0, 1), track.height = 0.1, bg.col = color_string, bg.border = NA, panel.fun = function(x, y) {
#     l = CELL_META$sector.numeric.index
#     circos.text(CELL_META$xcenter[1]- mm_x(6), CELL_META$cell.ylim[2] + mm_y(2),
#         text_string[l], facing = "reverse.clockwise", niceFacing = TRUE,
#         adj = c(1, 0.5), cex = 0.4,col = color_string[l])
    
#     for(v1 in h[[text_string[l]]]){
#         color = link_colors[[as.character(df2[text_string[l],v1])]]
#         circos.link(l, 0.25, indexes[[v1]], 0.25, col = color,lwd = 2,)
#     }
    
# } )

# dev.off()

pdf(arg2,width = 1080/res, height = 820/res)
layout(matrix(1:1, 1, 1),respect = TRUE)
# par(mar = c(1), bg=rgb(1,1,1,1) )
circos.par(cell.padding = c(0, 0, 0, 0),circle.margin=c(0.9,0.9,0.9,0.9)) 
circos.initialize(factors, xlim = c(0, .5)) 
count=0
circos.trackPlotRegion(ylim = c(0, 1), track.height = 0.1, bg.col = color_string, bg.border = NA, panel.fun = function(x, y) {
    l = CELL_META$sector.numeric.index
    circos.text(CELL_META$xcenter[1]- mm_x(1), CELL_META$cell.ylim[2] + mm_y(2),
    text_string[l], facing = "reverse.clockwise", niceFacing = TRUE,
    adj = c(1, 0.5), cex = 0.4)
    count3=0.05
    for(v1 in h[[text_string[l]]]){
        count3=count3+0.1
        print(v1)
        t =as.character(df2[text_string[l],v1])

        print(t)
        if (length(t)>0){
            if (t!=''){
                print('yes')
                color = link_colors[[as.character(df2[text_string[l],v1])]]
                circos.link(l, count3, indexes[[v1]], 0.25, col = color,lwd = 1,)
            }

        }

    }
    
} )
dev.off()