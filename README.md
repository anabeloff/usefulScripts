<h2> Useful Scripts</h2>
</br>
Collection of scripts and pipelenes I find useful in daily work with biological data analysis.
These include R and Bash scripts and pipelines. As well as R Notebook files with code and manuals. 
</br>

<h2>Tax2taxid.R</h2>
This script comes useful if you want to train RDP classifer with your own dataset. Training requers a taxid file along with sequence file.  
</br>
For training the sequence FASTA file hast to have sequence names formated as: sequence ID, space, sequence taxonomy (where each taxonomic group separated by ';'). 
</br>
The taxonomy id file example you can find on RDP classifier page.

<h3>Usage</h3>
To create taxid file using tax2taxid.R you need to provide two arguments:
1. Input file.  
2. Output file name.    

Input file supposed to be taxonomy file, what is basically the same as sequence names for FASTA file. Only here sequence ID and taxonomy should be separated by tab.  
Example:  
<blockquote>
GU981582	Root;Fungi;Ascomycota;Eurotiomycetes;Eurotiales;Aspergillaceae;Penicillium;Penicillium_abidjanum;CBS246.67;  
JN714929	Root;Fungi;Ascomycota;Eurotiomycetes;Eurotiales;Aspergillaceae;Penicillium;Penicillium_adametzii;CBS209.28;  
KC773822	Root;Fungi;Ascomycota;Eurotiomycetes;Eurotiales;Aspergillaceae;Penicillium;Penicillium_adametzii;DTO190A8;  
</blockquote>
 
