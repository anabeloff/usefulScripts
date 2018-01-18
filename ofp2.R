#!/opt/R/bin/Rscript
#$ -q all.q
#$ -pe smp 6
#$ -cwd
#$ -S /opt/R/bin/Rscript

###########
### OFP ###
###########
# Oligo Fishing Pipeline. Scripts to fish out oligos from NGS samples.
# As oligos designed are species specific ~95% of fished sequences will be species specific as well.
library("data.tree", lib.loc = "/home/AAFC-AAC/belova/R/x86_64-pc-linux-gnu-library/3.2/")
library(ape)
library(dplyr)
library(Biostrings)

### TOXINS
# Fishing with oligos
ofp2 <- function(tab, newick, matched_out, NGSdata) {

  tab_reads <- read.delim(tab, header = F, colClasses=c("character", "character"))
  colnames(tab_reads) <- c("Seq_Name", "Seq")

  # ## Tab oligos
  # selnodes <- tab_reads[nchar(tab_reads$Seq) == c(26,27),]
  # ptnm <- unique(names(ptrn))
  # selnodes1 <- function() {
  #   for(o in ptnm) {
  #   a <- selnodes[grep(o, selnodes$Seq_Name),]
  #     if(o == ptnm[1]) {
  #       seqtab <- a
  #     } else {
  #       seqtab <- rbind(seqtab, a)
  #     }
  #   }
  #   seqtab
  # }
  # sqtb <- selnodes1()
  # write.table(sqtb, file = paste(matched_out, "_used_oligos.tab", sep = ""), append = F, row.names = F, sep = "\t", quote = F)
  #
  # Actually designed oligos data
  tab_reads_nodes <- tab_reads[grep("Node", tab_reads$Seq_Name),]
  nodes <- data.frame(do.call('rbind', strsplit(tab_reads_nodes$Seq_Name, '-', fixed=T)))
  oligo_node <- DNAStringSet(tab_reads_nodes$Seq)
  names(oligo_node) <- nodes$X1

  tab_reads_taxon <- tab_reads[grep("taxonid", tab_reads$Seq_Name),]
  taxons <- data.frame(do.call('rbind', strsplit(tab_reads_taxon$Seq_Name, '|', fixed=T)))
  taxons$X2 <- sub("^[0-9_]*", "", taxons$X2)

  taxons_treeMatchin <- data.frame(do.call('rbind', strsplit(tab_reads_taxon$Seq_Name, '-', fixed=T)))
  taxons_treeMatchin$X1 <- gsub("_", " ", taxons_treeMatchin$X1)

  oligos_tax <- DNAStringSet(tab_reads_taxon$Seq)
  names(oligos_tax) <- taxons$X2

  oligo_set <- append(oligo_node, oligos_tax, after = length(oligo_node))



  # Tree, theoretical data
  tree <- as.Node(read.tree(file = newick))
  tree <- ToDataFrameNetwork(tree, "path", direction = "descend")
  tree <- tree[grep("taxonid", tree$from),]

  treeTaxons <- data.frame(do.call('rbind', strsplit(tree$from, '|', fixed=T)))[c(2)]
  tree <- cbind(tree, treeTaxons)
  tree$X2 <- gsub(" ", "_", tree$X2)
  tree$X2 <- sub("^[0-9_]*", "", tree$X2)
  tree <- tree %>%
    dplyr::group_by(X2) %>%
    dplyr::summarise(path = paste(unique(path), collapse = ", "), NoITS = length(X2))

  tree$path <- strsplit(as.character(tree$path), ', ', fixed=T)
  #tree$path <- lapply(tree$path, function(x) head(x, -1))


  #tree$path <- lapply(tree$path, function(x) unique(x[match(unique(tab_reads_nodes$to),x)]))
  tree$path <- lapply(tree$path, function(x) gsub("Node", "", x))
  tree$path <- lapply(tree$path, function(x) unique(sort(as.numeric(x))))
  tree$path <- lapply(tree$path, function(x) x[!is.na(x)])

  ## Function to select closest nodes to the leaves and match them with list of designed oligos.
  ## Nodes that are lest in a list are ones with oligos designed.
  bestNode <- function(x) {
    if(length(x)>4) {
      x[x>3]-> y
      # Taking last adjacent nodes
      y = x[c((length(x)-2):length(x))]
      # Transform numbers to character adding "Node".
      y = as.character(paste("Node", y, sep = "", collapse = ", "))
      y = unlist(strsplit(y, ', ', fixed=T))
      # Match selected nodes with oligos designed. Leave only matching.
      m = match(sn,y)
      y = unique(y[m])

          # condition to relace NAs and lines with only NA in them.
          if(length(is.na(y)) == 1 & unique(is.na(y)) == TRUE) {
            y = as.character(NA)
          } else {
            y = y[!is.na(y)]

          }

    } else {
      y = as.character(NA)
    }
  }


  # Second lowest node
  sn = as.vector(unique(names(oligo_set)))
  tree$UniNodeSecond <- sapply(tree$path, bestNode)

  tree$path <- sapply(tree$path, function(x) paste("Node", x, sep = "", collapse = ", "))


  sm <- tree
  message("Summary table created!\n")

  colnames(sm)[c(1,2)] <- c("Species", "Parent Nodes")
  sm <- sm[c("Species", "Parent Nodes", "UniNodeSecond", "NoITS")]


  # Matching seqs loop
  oligo_mn <- unique(as.character(c(unlist(sm$UniNodeSecond), sm$Species)))
  ptrn <- oligo_set[!is.na(match(names(oligo_set),oligo_mn))]
  # Oligo size to be used for matching
  #ptrn <- ptrn[width(ptrn) == c(26)]
  #ptrn <- ptrn[grep("_poae", names(ptrn))]
  #ptrn[grep("CAGCTTGGTGTTGGGAGCTGTTTGTCA", ptrn)]
  #ptrn <- ptrn[c(50:150)]
  used_oligos_nm <- paste(matched_out, "_used_oligos.fasta", sep = "")

  ptrn_names <- names(ptrn)
  seqs_l <- sapply(sm$UniNodeSecond, length)
  seqs <- data.frame(Species = rep(sm$Species, seqs_l), Nodes = unlist(sm$UniNodeSecond))
  seqs <- seqs[!is.na(seqs$Nodes),]
  seqs <- seqs %>%
    dplyr::group_by(Nodes) %>%
    dplyr::summarise(node_names = paste(unique(Nodes), paste(Species, collapse = ";", sep = ";"), sep = ";"))

  selnames <- function(x) {
    y <- seqs[seqs$Nodes == x, "node_names"]
    if(nrow(y) == 0) {
      x
    } else {
      y
    }
  }
  ptrn_names <- sapply(ptrn_names, selnames)
  ptrn_names <- unlist(ptrn_names)
  names(ptrn_names) <- NULL
  names(ptrn) <- ptrn_names

  writeXStringSet(ptrn, filepath = used_oligos_nm)
  message("Used Oligos saved!\n", appendLF = F)


  ## Matching Script
  message("Matching oligos...", appendLF = F)

  system(paste("~/bin/oligofishing-master/oligofishing -h ", used_oligos_nm, " -p ", NGSdata, " > out.fasta", sep = ""))

  mt_oligos <- readDNAStringSet("out.fasta")
  spp <- strsplit(names(mt_oligos), '|', fixed=T)
  #spp <- strsplit(as.character(spp), '_', fixed=T)
  #spp <- data.frame(species = sapply(spp, "[", 2), oligos = sapply(spp, "[", 3)) %>% dplyr::group_by(species,oligos) %>%
  spp <- data.frame(species = sapply(spp, "[", 1), oligos = sapply(spp, "[", 2))
  spp <- spp %>%
    dplyr::group_by(species,oligos) %>%
    dplyr::summarise(No = length(species))


  message("done", appendLF = T)
  message("Writing fasta...", appendLF = F)
  matched_nm <- paste(matched_out, "_matched_oligos.fasta", sep = "")
  spp_nm <- paste(matched_out, "_species_oligos.tab", sep = "")


  writeXStringSet(mt_oligos, filepath = matched_nm)

  sm$UniNodeSecond <- as.character(sm$UniNodeSecond)

  write.table(sm, file = paste(matched_out, "_summary.tab", sep = ""), append = F, row.names = F, sep = "\t", quote = F)
  write.table(spp, file = spp_nm, append = F, row.names = F, sep = "\t", quote = F)

  file.remove("out.fasta")

  message("done", appendLF = T)
  sm


}
########################################################
arg = commandArgs(TRUE)

dtfr <- ofp(matched_out = arg[1], NGSdata = arg[2], tab = arg[3], newick = arg[4])

quit(save = "no")
