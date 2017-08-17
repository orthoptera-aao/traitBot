# Seting remote to FALSE allows local operation
.onLoad <- function(libname, pkgname){
  remote <- TRUE
  if (remote==TRUE){
    c <- bioacoustica::bioacoustica.authenticate(Sys.getenv("BAUSR"), Sys.getenv("BAPWD"))
    generateProlog(c)
  } else {
    source("~/authenticate.R", local=TRUE)
    generateProlog(c)
    uploadFromProlog(c)
  }
}