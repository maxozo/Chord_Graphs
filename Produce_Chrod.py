#!/usr/bin/env python

__author__ = 'Matiss Ozols'
__date__ = '2021-08-11'
__version__ = '0.0.1'

''''This file takes the pathway analysis and generates a chorrds graphs for the set of genes'''
import pandas as pd
import os
outfolder='/Users/mo11/work/Bennet_project/test/'
w1='22'
w2='72'
outname = f'{outfolder}Pathways_Chord_{w1}_{w2}.csv'
outname2 = f'{outfolder}Pathways_Chord_{w1}_{w2}.svg'

# Data_Genes = pd.read_excel(f'/Users/mo11/Library/CloudStorage/GoogleDrive-mo11@sanger.ac.uk/My Drive/Cambridge_Proteomics/work/Matiss Pathway Analysis - all GN with Interactions/Reactome Analysis all GN Interactions.xlsx',sheet_name=f'{w1}_v_{w2}_fold_changes')
# Data_Genes = Data_Genes[Data_Genes['P.Value'].astype(float)<=0.05]
# Data_Genes['GN']=Data_Genes['Identifier']
# DF1 = Data_Genes[['Identifier','logFC']].head(50)
Data_Genes = pd.read_csv('/Users/mo11/work/Chord_Plots/sample_data/sample_data_1.tsv',sep='\t')
# DF1.to_csv('/Users/mo11/work/Chord_Plots/sample_data/sample_data_1.tsv',sep='\t')
Data_Pathways=pd.read_excel('/Users/mo11/Library/CloudStorage/GoogleDrive-mo11@sanger.ac.uk/My Drive/Cambridge_Proteomics/work/Matiss Pathway Analysis - all GN with Interactions/Reactome Analysis all GN Interactions.xlsx',sheet_name='Pathways')
Data_Pathways=pd.read_csv('/Users/mo11/work/Chord_Plots/sample_data/sample_data_2_bellongings.tsv')
Data_Pathways = Data_Pathways[Data_Pathways[f'FDR.{w1} v {w2}']<=0.05]
DF2 = Data_Pathways[['Name','Genes']]
DF2.to_csv('/Users/mo11/work/Chord_Plots/sample_data/sample_data_2_bellongings.tsv',sep='\t')
Data_Pathways = pd.read_csv('/Users/mo11/work/Chord_Plots/sample_data/sample_data_2_belongings.tsv')
Data_Pathways['Genes']=Data_Pathways['Genes'].str.upper()
Data_Pathways = Data_Pathways.dropna(subset=['Genes'])
Data_Pathways['Genes'] = ';'+Data_Pathways['Genes']+';'
colnames_all = list(Data_Pathways.Name)
colnames_all.append('logFC')
Data = pd.DataFrame(columns=colnames_all)

for i, row in Data_Genes.iterrows():
    logFC = row['logFC']
    GN = row['GN'].upper()
    Pathways = Data_Pathways[Data_Pathways['Genes'].str.contains(f';{GN};')]
    if len(Pathways)>0:
        paths = list(Pathways.Name)
        paths=list(set(paths).intersection(colnames_all))
        
        if(len(paths)>0):
            Data.loc[GN]=0
            Data.loc[GN,paths]=1
            Data.loc[GN,'logFC']= logFC

Data = Data.loc[:,Data.sum(axis=0) !=0]
Data.to_csv(outname)
# then feed this in the R module to generate the chord graph
os.system(f'Rscript Go_module.R {outname} {outname2}')
print('Finished generating chord graph')