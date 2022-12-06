#!/usr/bin/env python
__author__ = 'Matiss Ozols'
__date__ = '2022-12-05'
__version__ = '0.0.1'

''''This file takes the pathway analysis and generates a chorrds graphs for the set of genes'''
import pandas as pd
import os
import argparse
pyd_loc = os.path.dirname(__file__)
def main():
    """Run CLI."""
    parser = argparse.ArgumentParser(
        description="""
                This code mengles the data in the right format to produce the chord graphs, and calls the cord graph generation
            """
    )
    parser.add_argument(
        '-o', '--out_file',
        dest='out_file',
        required=True,
        help='outfile name and path'
    )

    parser.add_argument(
        '-f1', '--file1',
        default='',
        dest='file1',
        required=False,
        help='file1.'
    )

    parser.add_argument(
        '-f2', '--file2',
        default='',
        dest='file2',
        required=False,
        help='file2.'
    )
    options = parser.parse_args()
    outfolder=options.out_file
    outfolder = "/".join(outfolder.split('.')[:-1])
    outname = f'{outfolder}.csv'
    outname2 = f'{outfolder}.svg'
    
    Data_Genes = pd.read_csv(options.file1,sep='\t')
    Data_Pathways = pd.read_csv(options.file2,sep='\t')

    Colname = Data_Pathways.iloc[:,1].name
    Colname2 = Data_Genes.iloc[:,1].name
    Data_Pathways.iloc[:,1]=Data_Pathways.iloc[:,1].str.upper()
    Data_Pathways = Data_Pathways.dropna(subset=[Colname])
    Data_Pathways[Colname] = ';'+Data_Pathways[Colname]+';'
    colnames_all = list(Data_Pathways['Identifier'])
    colnames_all.append(Colname2)
    Data = pd.DataFrame(columns=colnames_all)

    for i, row in Data_Genes.iterrows():
        logFC = row[Colname2]
        GN = row['Identifier'].upper()
        Pathways = Data_Pathways[Data_Pathways[Colname].str.contains(f';{GN};')]
        if len(Pathways)>0:
            paths = list(Pathways['Identifier'])
            paths=list(set(paths).intersection(colnames_all))
            if(len(paths)>0):
                Data.loc[GN]=0
                Data.loc[GN,paths]=1
                Data.loc[GN,Colname2]= logFC
    Data = Data.loc[:,Data.sum(axis=0) !=0]
    Data.to_csv(outname)
    os.system(f'Rscript {pyd_loc}/Go_module.R {outname} {outname2}')
    os.remove(outname)

if __name__ == '__main__':
    main()
    print('Finished generating chord graph')
    

