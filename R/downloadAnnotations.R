downloadAnnotations <- function(c) {
  setwd("./data")
  bioacoustica::bioacoustica.getAllAnnotationFiles(c)
  setwd("..")
}