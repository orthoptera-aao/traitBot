downloadAnnotations <- function(c) {
  a <- bioacoustica.getAnnotations()
  bioacoustica.getAnnotationFile(a)
}