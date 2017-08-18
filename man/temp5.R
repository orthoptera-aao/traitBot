traits <- bioacoustica::bioacoustica.listTraits(c)

unique_taxa <- unique(traits$Taxonomic.name)

#ABC traits: The sum of values A and B equals C
abc <- list(
  c("Echeme Duration", "Echeme Spacing", "Echeme Period"),
  c("Syllable Duration (in Echeme)", "Syllable Spacing", "Syllable Period")
)

for (i in 1:length(abc)) {
  a_taxa <- traits[traits$Trait==abc[[i]][[1]],"Taxonomic.name"]
  b_taxa <- traits[traits$Trait==abc[[i]][[2]],"Taxonomic.name"]
  overlap_taxa <- intersect(a_taxa, b_taxa)
  for (j in 1:length(overlap_taxa)) {
    a_values <- subset(traits, Taxonomic.name==overlap_taxa[[j]] & Trait==abc[[i]][[1]], select=c(Trait, Value))
  }
}