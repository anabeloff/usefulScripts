<h2> Useful Scripts</h2>
</br>
Collection of scripts and pipelenes I find useful in daily work with biological data.
These include R and Bash scripts and pipelines, as well as R Notebooks with code examples and manuals. 
</br>

---

<h2>Tax2taxid.R</h2>
This script comes useful if you want to train RDP classifaer with your own dataset. Training requers a taxid file along with sequence file.  
</br>
For training, the sequence FASTA file has to have sequence names formated as: sequence ID, space, sequence taxonomy (where each taxonomic group separated by ';'). 
</br>
The taxonomy id file example you can find on RDP classifier page.

<h3>Usage</h3>
To create taxid file using tax2taxid.R you need to provide two arguments:
1. Input file.<br>
2. Output file name.<br>

Input file supposed to be taxonomy file, what is basically the same as sequence names for FASTA file. Only here sequence ID and taxonomy should be separated by tab.<br>
Example:<br>
GU981582	Root;Fungi;Ascomycota;Eurotiomycetes;Eurotiales;Aspergillaceae;Penicillium;Penicillium_abidjanum;CBS246.67;<br>

This script is very simple and contains predefined ranks:<br>
"norank", "domain", "phylum", "class", "order", "family", "genus", "species", "strain".<br>
If your ranks are somewhat different change variable 'rank_names' in the code. 

---

<h2>batch_rename.sh</h2>
</br>
Bash script to change specified part (or entire) of a name for multiple files.  
Options:  

-p: regex character string. If you use "*" script will replace entire name.  
-n: replacement character string.  
-f: path to file(s).  

#### Usage example:  

`batch_rename.sh -p "*-R*" -n "_R" -f *.fastq.gz`


## readBLAST.R

This is a basic R script to read BLAST tab output files into R dataframe. The script to be called in R as a function.  
The Function assigns common names and content types (character or number) to each column. It useful to orginese BLAST data in unified format.

Options:  

- blastFile: Path to BLAST tab file.
- bitScore: Numeric. If specified sets a threshold value for BitScore. Only lines above the threshold will be outputted. Default NA.
- eValue: Numeric. If specified sets a threshold value for e-value. Only lines below the threshold will be outputted. Default NA.
- annotationTbl: Data frame. If specified joins annotation data frame with BLAST output. It uses the first column of the annotation data frame to join by, so it must contain the same IDs as queryID column of BLAST file.
 

#### Usage:

```
blastData <- readBLAST(blastFile,
                        bitScore = NA,
                        eValue = NA,
                        annotationTbl = NA)

# Read BLAST file without filtering.
blastData <- readBLAST(blastFile = system.file("extdata", "so_proteins_blastx.tab", package = "RNAseqFungi"))

# Read BLAST file without and filter data.
# By e-value
blastData <- readBLAST(blastFile = system.file("extdata", "so_proteins_blastx.tab", package = "RNAseqFungi"),
                        eValue = 0.0001)

# By bit score
blastData <- readBLAST(blastFile = system.file("extdata", "so_proteins_blastx.tab", package = "RNAseqFungi"),
                        bitScore = 200)
```

---

## ParseGFF.R

Parse GFF3 annotation. This is a basic R script function to read GFF file into R dataframe.  
This function allows to parse annotation in 9th column into separate columns. The functions helps to keep GFF data in R in universal format.  

Options:  

- gff: Character string. Path to GFF file.
- field: Character string vector of names for attributes in the 9th column of GFF file. If specified, additional columns with attributes names will created.
 
#### Usage:

For example,  GFF3 in 9th column contains annatations gene ID and Name, which appears something like that:  
"ID=GENE0809;Name=PTEN"  

If you specify 'field' option in the function it will extract IDs and Names, and place them in individual columns named accordingly.  

```
# Default options
GFF <- parseGFF(gff = NA,
                field = NA)
                
# Read GFF3 and extract features "ID" and "Name".
GFF <- parseGFF(gff = system.file("extdata", "Se_LEV6574.gff", package = "RNAseqFungi"),
                field = c("ID", "Name"))
```


