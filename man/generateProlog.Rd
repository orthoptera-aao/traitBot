\name{generateProlog}
\alias{generateProlog}
%- Also NEED an '\alias' for EACH other topic documented here.
\title{
Generates a ProLog knowledge base for cascading traits.
}
\description{
This function generates a ProLog knoweldge base combining the BioAcoustica taxonomic hierarchy and cascading traits. This allows uploadFromProlog() to compute inherited traits.
}
\usage{
generateProlog(c)
}
%- maybe also 'usage' for other objects documented here.
\arguments{
  \item{c}{
  A CURL handle for an authenticated BioAcoustica session.
  }
}
\details{
The generated file is: ~/orth.pl
}
%\value{
%%  ~Describe the value returned
%%  If it is a LIST, use
%%  \item{comp1 }{Description of 'comp1'}
%%  \item{comp2 }{Description of 'comp2'}
%% ...
%}
%\references{
%% ~put references to the literature/web site here ~
%}
\author{
Ed Baker
}
%\note{
%%  ~~further notes~~
%}

%% ~Make other sections like Warning with \section{Warning }{....} ~

%\seealso{
%% ~~objects to See Also as \code{\link{help}}, ~~~
%}

% Add one or more standard keywords, see file 'KEYWORDS' in the
% R documentation directory.
%\keyword{ ~kwd1 }% use one of  RShowDoc("KEYWORDS")
%\keyword{ ~kwd2 }% __ONLY ONE__ keyword per line
