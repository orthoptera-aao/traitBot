# This package is designed for automatic operation environments
# The package runs code when it is loaded to facilitate automatic operation
.onLoad <- function(libname, pkgname){
  c <- bioacoustica::bioacoustica.authenticate(Sys.getenv("BAUSR"), Sys.getenv("BAPWD"))
  message("Code executed.")
}