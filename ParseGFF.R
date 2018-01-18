# Parse GFF
parseGFF <- function(gff, field) {
  
  gffdata <- read.delim(gff, 
                        header=F, 
                        comment.char="#", 
                        na.strings = c("","NA"), 
                        colClasses=c("character", "character", "character", "integer",  "integer", "character", "character", "character", "character"))
  colnames(gffdata) <- c("sequence", "source", "feature", "start", "end", "score", "strand", "phase", "attr")
  gffdata <- gffdata[gffdata$feature == "CDS",] 
  attr <- strsplit(gffdata$attr, split = ';', fixed=T)
  
  #gffdata <- within(gffdata, attr <- data.frame(do.call('rbind', strsplit(as.character(attr), ';|=', fixed=F))))
  #a <- data.frame(do.call('rbind', strsplit(as.character(attr), '=', fixed=F)))
  # extract specific attributes
  # Scpecified in firld option
  for (i in field) {
    
    cl <- sapply(attr, function(atts) {
      a = strsplit(atts, split = "=", fixed = F)
      m = match(i, sapply(a, "[", 1))
      if (!is.na(m)) {
        rv = a[[m]][2]
      }
      else {
        rv = as.character(NA)
      }
        return(rv)
    })
  gffdata[i] <- cl
  }
  
  return(gffdata)
}
