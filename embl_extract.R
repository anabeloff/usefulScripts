
##########################
### Parse EMBL format ####\
##########################

# The function takes two options:
# embl_file - path to a multi sequence text file in EMBL format.
# parts - field in EMBL format sequence. Usually two capital letter code.

# How to run example:

# parts <- c("ID", "RX")
# names(parts) <- c("miId", "PUBMED")
# data <- embl_extract(data_list = "embl.dat", part = parts)

embl_extract <- function(embl_file, part) {

# Split multi sequence file into list of sequences in EMBL format.
filedat <- scan(file = embl_file, what = "character", sep = "\n")
dat <- split(filedat, f = cumsum(filedat == "//"))

  for(i in 1:length(part)) {
    extractEMBL <- function(x) {
      if(length(x) == 0) {
        y = as.character(NA)
      } else {
        g = grep(part[i], x)
        y = x[g]
        y = gsub("^[A-Z][A-Z]   ", "", y)
      }
      y
    }
    dt <- data.frame(I(lapply(embl_file, extractEMBL)))
    colnames(dt)[1] <- names(part)[i]
    
    if(i == 1) {
    fn_dt <- dt  
    } else {
      fn_dt <- cbind(fn_dt, dt)
    }
  }
  fn_dt
}

