downloadAnnotations <- function(c) {
  setwd("./data")
  bioacoustica.getAllAnnotationFiles(c)
  setwd("..")
}