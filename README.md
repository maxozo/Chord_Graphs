# Chord_Graphs
This is a quick wrapper for generating chord plots of interest. 

This wrapper will generate an svg file which can be imported in Illustrator or any other SVG editor packages to adjust the plots and beautify them even more.

Credits to the GO Chord developers.

Besides the packages listed in the requirements.txt you should also instrall GOplot package in R:
install.packages('GOplot')



After instalation:

# For the expression type of plots as in - 

prepeare 2 files - 
1) Quantifiable file (like in example file ./sample_data/sample_data1.tsv)  - first col must be Identifier, second column can be any quantifiable value of your interest, does not have to be labeled logFC: 
Identifier	logFC
Spp2	20.24209064
Ccn5	-1.7727406615
Stat1	18.936646694

This file will be used to produce first half of the graph.
2) Belongings file (like in example file ./sample_data/sample_data_2_belongings.tsv) - first col must be Identifier, second col must contain ids present in the sample_data #1.

Identifier	Belongings
Platelet degranulation	CAVIN2;RMDN3;LRPPRC;SPTB;CD36;CLIP1;ACTN3;ACTG1;COL1A1;MBP;RPL37A;A1BG;LRP1;UCHL1;SPP2
G2 Phase	PAWR;IKBKG;GSN;APP;STAT1

Once you have both of these files you can run:
python /path/to/your/colned/folder/Produce_Chrod.py -o test_output_Nath.svg -f1 /path/to/your/sample_data_1.tsv -f2 /path/to/your/sample_data_2_belongings.tsv


# For matrix pathway plots type of plots as in - 

Produce a pathway matrix file where first column is first identifiers and firt row is second identifiers that you want to link.
The second column has to be color - this is a bolean number that will make coresponding rows/columns in a different color ion a circle plot(currently arbitary).
The second row has to be color again for the same reason.

The matrix represents different links. Different values will be colored differently, and empty cells will not establish link between two coresponding cells.

Then you can run a code pointing to a file and an output pdf name:
`Rscript /path/to/Chord_Matrix.R /path/to/your/input/matrix/matrix_sample.tsv /path/to/output/file/matrix_test_out.pdf`