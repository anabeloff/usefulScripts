
arg = commandArgs(TRUE)




tax2taxid <- function(filePath = arg[1], outFile = arg[2]) {
  
  tax_file <- read.delim(filePath, 
                         header = F, 
                         na.strings = c("","NA"),
                         col.names = c("SeqID", "taxonomy"),
                         colClasses=c("character", "character"))
  
  rank_names <- c("norank", "domain", "phylum", "class", "order", "family", "genus", "species", "strain")
  
  ranks <- c(1:length(rank_names))
  names(ranks) <- rank_names
  
  dt <- data.frame(No = 1, taxa = "Root", inheritNo = 0, rankNum = 0, Rank = "norank", stringsAsFactors = F)
  
  
  for(o in 1:length(tax_file$taxonomy)) {
    tax <- tax_file$taxonomy[o]
    tax <- unique(unlist(strsplit(tax, split = "[;]"), use.names = F))
    
    for(i in 1:length(tax)) {
      
      if(o == 1) { 
        nonm = i + 1
        rnm = ranks[i]
      } else {
        nonm = nonm + 1
        
        if(tax[i] %in% dt$taxa) {
          
          rnm = as.integer(dt[dt$taxa %in% tax[i],c(1)])
          
          if(i < length(tax)) {i = i + 1}
          
        } else {
          rnm = nonm
        }
      }
      
      
      rn <- data.frame(No = nonm, taxa = tax[i], inheritNo = rnm, rankNum = ranks[i], Rank = names(ranks[i]), stringsAsFactors = F)
      
      dt <- rbind(dt, rn) 
      dt <- dt[!duplicated(dt$taxa),]
    }
  }
  row.names(dt) <- dt$No
  
  write.table(dt, file = outFile, append = F, sep = "*", quote = F, row.names = F, col.names = F)
  
  return(dt)
}




