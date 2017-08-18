generateProlog <- function(c){
  setwd("~")
  taxa <- bioacoustica::bioacoustica.listTaxa();
  traits <- bioacoustica::bioacoustica.listTraits(c);
  #Only cascading traits
  traits <- traits[!is.na(traits$Cascade),]
  traits <- traits[traits$Cascade==1,]
  
  #Replace spaces with undescores for Prolog varibale names, and remove some characters
  taxa$taxon <- gsub(' ', '_', taxa$taxon)
  taxa$taxon <- gsub('-', '_', taxa$taxon)
  taxa$taxon <- gsub('\\(', '_', taxa$taxon)
  taxa$taxon <- gsub('\\)', '_', taxa$taxon)
  taxa$taxon <- gsub('"', '', taxa$taxon)
  taxa$taxon <- gsub('\u201C', '', taxa$taxon)
  taxa$taxon <- gsub('\u201D', '', taxa$taxon)
  taxa$taxon <- gsub('\\.', '', taxa$taxon)
  taxa$taxon <- gsub("'", '', taxa$taxon)
  taxa$taxon <- gsub('\\?', 'question_', taxa$taxon)
  taxa$parent_taxon <- gsub(' ', '_', taxa$parent_taxon)
  taxa$parent_taxon <- gsub('-', '_', taxa$parent_taxon)
  taxa$parent_taxon <- gsub('\\(', '_', taxa$parent_taxon)
  taxa$parent_taxon <- gsub('\\)', '_', taxa$parent_taxon)
  taxa$parent_taxon <- gsub('"', '', taxa$parent_taxon)
  taxa$parent_taxon <- gsub('\u201C', '', taxa$parent_taxon)
  taxa$parent_taxon <- gsub('\u201D', '', taxa$parent_taxon)
  taxa$parent_taxon <- gsub('\\.', '', taxa$parent_taxon)
  taxa$parent_taxon <- gsub("'", '', taxa$parent_taxon)
  taxa$parent_taxon <- gsub('\\?', 'question_', taxa$parent_taxon)
  taxa <- dplyr::mutate_all(taxa, dplyr::funs(tolower))
  traits$Taxonomic.name <- gsub(' ', '_', traits$Taxonomic.name)
  traits$Taxonomic.name <- gsub('-', '_', traits$Taxonomic.name)
  traits$Taxonomic.name <- gsub('\\(', '_', traits$Taxonomic.name)
  traits$Taxonomic.name <- gsub('\\)', '', traits$Taxonomic.name)
  traits$Taxonomic.name <- gsub('"', '', traits$Taxonomic.name)
  traits$Taxonomic.name <- gsub('\u201C', '', traits$Taxonomic.name)
  traits$Taxonomic.name <- gsub('\u201D', '', traits$Taxonomic.name)
  traits$Taxonomic.name <- gsub('\\.', '', traits$Taxonomic.name)
  traits$Taxonomic.name <- gsub("'", '', traits$Taxonomic.name)
  traits$Taxonomic.name <- gsub('\\?', 'question_', traits$Taxonomic.name)
  traits$Trait <- gsub(' ', '_', traits$Trait)
  traits$Value <- gsub(' ', '_', traits$Value)
  traits$Value <- gsub('-', '_', traits$Value)
  traits <- dplyr::mutate_all(traits, dplyr::funs(tolower))
  
  
  
  writePrologTaxon <- function(file, term, parent) {
    if (parent == '') {
      parent <- "animal"
    }
    
    prolog <- paste0(term,"(a_kind_of, ",parent,").")
    write(prolog, file, append =TRUE)
    
    taxontraits <- traits[traits$Taxonomic.name==term,]
    trait_count <- nrow(taxontraits)
    if (trait_count > 0 ) {
      for(i in 1:trait_count) {
        pl_trait <- paste0("t",as.character(taxontraits[i,"traitID"]))
        prolog <- paste0(term,"(",pl_trait,", ",as.character(taxontraits[i,"Value"]),").")
        write(prolog, file, append =TRUE)
      }
    }
  }
  
  mapply(writePrologTaxon,"orth.pl", taxa$taxon, taxa$parent_taxon)
  
  app <- "value(Frame, Slot, Value) :-
	Query=..[Frame, Slot, Value],
call(Query), !.

value(Frame, Slot, Value) :-
parent(Frame, ParentFrame),
writeln(ParentFrame),
value(ParentFrame, Slot, Value).

parent(Frame, ParentFrame) :-
( Query=..[Frame, a_kind_of, ParentFrame];
Query=..[Frame, an_instance_of, ParentFrame]),
call(Query).

:- initialization go.

go :- 
current_prolog_flag(argv,Argv),

opt_parse([[opt(taxon), 
type(atom),
shortflags([n]), 
longflags([taxon])]
,[opt(trait),
type(atom),
shortflags([t]),
longflags([trait])]
],
Argv,
Opts,
_),
dict_options(DicOp, Opts),


(value(DicOp.taxon, DicOp.trait, X), 
writeln(X),
halt
).

animal(_,_) :-
  writeln(no_match_found),
  halt(2)."
  
  write(app,"orth.pl", append=TRUE)
}
