uploadFromProlog <- function(c){
  
  taxa <- bioacoustica::bioacoustica.listTaxa()
  
  n <- c(names(taxa), "orig_taxon", "orig_parent_taxon")
  orig_taxon <- taxa$taxon
  orig_parent_taxon <- taxa$parent_taxon
  taxa <-dplyr::mutate_all(taxa, dplyr::funs(tolower))
  taxa <- cbind(taxa, orig_taxon, orig_parent_taxon)
  names(taxa) <- n
  
  taxa$taxon <- gsub(' ', '_', taxa$taxon)
  taxa$taxon <- gsub('-', '_', taxa$taxon)
  taxa$taxon <- gsub('\\(', '_', taxa$taxon)
  taxa$taxon <- gsub('\\)', '_', taxa$taxon)
  taxa$taxon <- gsub('"', '', taxa$taxon)
  taxa$taxon <- gsub('\u201C', '', taxa$taxon)
  taxa$taxon <- gsub('\u201D', '', taxa$taxon)
  taxa$taxon <- gsub('\\.', '', taxa$taxon)
  taxa$taxon <- gsub("'", '', taxa$taxon)
  taxa$taxon <- gsub("\u00D7", 'x', taxa$taxon)
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
  taxa$parent_taxon <- gsub("\u00D7", 'x', taxa$parent_taxon)
  taxa$parent_taxon <- gsub('\\?', 'question_', taxa$parent_taxon)
  
  all_traits <- bioacoustica::bioacoustica.listTraits(c)
  cascade_traits <- all_traits[!is.na(all_traits$Cascade),]
  cascade_traits <- cascade_traits[cascade_traits$Cascade==1,]
  
  for (j in 1:nrow(cascade_traits)) {
    cascade_trait <- paste0("t", cascade_traits[j,"traitID"])
    for (i in 1:nrow(taxa)) {
      #If trait already set for this taxon then skip
      if (nrow(subset(subset(all_traits, Taxonomic.name==as.character(taxa[i,"orig_taxon"])), Trait==as.character(cascade_traits[j,"Trait"]))) > 0) {
        next;
      }
      #If this is the taxon that defines the cascading trait then skip
      if (as.integer(taxa[i,"id"]) == as.integer(cascade_traits[j,"taxonID"])) {
        next;
      }
      pl_taxon <- taxa[i,"taxon"]
      
      #Pipe output through cat to supress warning when no match found and swipl returns with code 2
      r <- system2("swipl", paste0("-s ~/orth.pl -- --taxon=",pl_taxon," --trait=",cascade_trait, " | cat"), stdout=TRUE)
      if (r[length(r)]!="no_match_found") {
        notes <- paste0("Inferred by inference_bot from value assigned to ",as.character(cascade_traits[j,"Taxonomic.name"]))
        #message(paste0(as.character(cascade_traits[j, "Value"]), " inferred by inference_bot from value assigned to ",as.character(cascade_traits[j,"Taxonomic.name"])))
        bioacoustica::bioacoustica.postTrait( as.character(taxa[i,"orig_taxon"]), 
                                c, 
                                call_type=as.character(cascade_traits[j,"Call.Type"]), 
                                trait=as.character(cascade_traits[j, "Trait"]), 
                                value=as.character(cascade_traits[j, "Value"]), 
                                temp=as.character(cascade_traits[j, "Temperature"]), 
                                sex=as.character(cascade_traits[j,"Sex"]), 
                                inference_notes=notes, 
                                cascade=0)
      }
    }
  }
}