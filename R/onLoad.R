# This package is designed for automatic operation environments
# The package runs code when it is loaded to facilitate automatic operation
# Seting remote to FALSE allows local operation
.onLoad <- function(libname, pkgname){
  remote <- TRUE
  if (remote==TRUE){
    c <- bioacoustica::bioacoustica.authenticate(Sys.getenv("BAUSR"), Sys.getenv("BAPWD"))
  } else {
    source("~/authenticate.R")
  }
  
  #Generate prolog file for reasoning
  generateProlog(c)
}