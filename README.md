<h2> Useful Scripts</h2>
</br>
Collection of scripts and pipelenes I find useful in daily work with biological data analysis.
These include R and Bash scripts and pipelines. As well as R Notebook files with code and manuals. 
</br>

<h3>Tax2taxid.R</h3>
This script comes useful if you want to train RDP classifer with your own dataset. Training requers a taxid file along with sequence file.  
</br>
For training the sequence FASTA file hast to have format like:  
<blockquote>
>GU981582 Root;Fungi;Ascomycota;Eurotiomycetes;Eurotiales;Aspergillaceae;Penicillium;Penicillium_abidjanum;CBS246.67;
CATTACCGAGTGAGGGCCCTCTGGGTCCAACCTCCCACCCGTGTTTATCGTACCTTGTTGCTTCGGCGGGCCCGCCTCAC
GGCCGCCGGGGGGCACCCGCCCCCGGGCCCGCGCCCGCCGAAGACACCATTGAACGCTGTCTGAAGATTGCAGTCTGAGC
>JN714929 Root;Fungi;Ascomycota;Eurotiomycetes;Eurotiales;Aspergillaceae;Penicillium;Penicillium_adametzii;CBS209.28;
CATTACTGAGTGAGGGCCCTCTGGGTCCAACCTCCCACCCGTGTTTTATTGTACCTTGTTGCTTCGGCAGGCCCGCCTCA
CGGCCGCCGGGGGGCCTCTGCCCCCGGGCCCGCGCCTGCCGAAGACACCCTTGAACGCTGTCTGAAGTTTGCAGTCTGAG
CGAAAAGCAAAATTTATTAAAACTTTCAACAACGGATCTCTTGGTTCCGGCATCGATGAAGAACGCAGCGAAATGCGATA
</blockquote>
Here names of sequences conatain taxonomy.
</br>
The taxonomy file has to have format like:  
<blockquote>
1*Root*0*0*norank
2*Fungi*1*1*domain
3*Ascomycota*2*2*phylum
4*Eurotiomycetes*3*3*class
5*Eurotiales*4*4*order
6*Aspergillaceae*5*5*family
7*Penicillium*6*6*genus
8*Penicillium_abidjanum*7*7*species
9*CBS246.67*8*8*strain
10*Penicillium_adametzii*7*7*species
11*CBS209.28*10*8*strain
12*DTO190A8*10*8*strain
13*Penicillium_adametzioides*7*7*species
14*CBS313.59*13*8*strain
15*DTO115H8*13*8*strain
16*DTO115I8*13*8*strain
17*DTO78A7*13*8*strain
18*DTO78A9*13*8*strain
19*DTO78F2*13*8*strain
20*Penicillium_aeris*7*7*species 
</blockquote>

<h4>Usage</h4>

To create taxid file using tax2taxid.R you need to provide two arguments:
1. Input file.  
2. Output file name.<br>  
</br>
Input file supposed to be taxonomy file of format like: 
<blockquote>
GU981582	Root;Fungi;Ascomycota;Eurotiomycetes;Eurotiales;Aspergillaceae;Penicillium;Penicillium_abidjanum;CBS246.67;
JN714929	Root;Fungi;Ascomycota;Eurotiomycetes;Eurotiales;Aspergillaceae;Penicillium;Penicillium_adametzii;CBS209.28;
KC773822	Root;Fungi;Ascomycota;Eurotiomycetes;Eurotiales;Aspergillaceae;Penicillium;Penicillium_adametzii;DTO190A8; 
</blockquote>
 
