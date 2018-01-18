##############################
##                          ##
## Read BLAST data function ##
##                          ##
##############################
readBLAST <- function(blastFile, bt = NA, annot = NA) {
  
  #bt - BLAST treshold. Used to filter blast results.
  #blastdb - BLAST databse

  blast.read.data <- read.delim(blastFile, 
                                header = F, 
                                comment.char = "#", 
                                na.strings = c("","NA"),
                                col.names = c("queryID", "gene_id", "identity", "length", "mismatch", "gaps", "start", "end", "gene_id_start", "gene_id_end", "evalue", "Score"),
                                colClasses=c("character", "character", "numeric", "integer",  "integer", "integer", "integer", "integer", "integer", "integer", "numeric", "numeric"))
  #filter blast results 
  if(!is.na(bt)) {
    blast.read.data <- blast.read.data[blast.read.data$Score >= bt,]
  }
  
  blast.data <- blast.read.data %>%
    dplyr::group_by(queryID) %>%
    dplyr::filter(Score == max(Score) & evalue == min(evalue)) %>%
    dplyr::summarise_all(funs(first))
  
  if(!is.na(annot)) {
    names(annot)[1] <- "queryID"
    blast.data <- left_join(blast.data, annot, by = "queryID")
  }
  return(blast.data)
}
