uploadFrequencySpectrumAAO <- function(c) {
  a <- bioacoustica::bioacoustica.getAnnotations(c)
  t <- bioacoustica::bioacoustica.listTraits(c)
  a <- a[a$type == "Call", ]
  for (i in 1:nrow(a)) {
    file <- as.character(a[[i, "file"]])
    parts <- strsplit(file, "/")
    filename <-
      paste0("data/", URLdecode(parts[[1]][7]), ".", as.character(a[[i, "id"]]), ".wav")
    if (file.exists(filename)) {
      wave <- tuneR::readWave(paste0(filename))
      wave <- seewave::bwfilter(wave, from = 1000, output = "Wave")
      spectrum <- orthophonia::frequencySpectrumAAO(wave, plot = TRUE)
      message(paste(i, ": ", spectrum, sep = " "))
      
      pf <-
        t[t$Annotation.ID == as.character(a[[i, "id"]]) &
            !is.na(t$Annotation.ID) & t$Trait == "Peak Frequency (kHz)", ]
      if (nrow(pf) == 0) {
        bioacoustica::bioacoustica.postTrait(
          as.character(a[[i, "taxon"]]),
          c,
          call_type = as.character(a[[i, "type"]]),
          trait = "Peak Frequency (kHz)",
          value = spectrum[[3]],
          temp = "",
          sex = "",
          annotation_id = as.character(a[[i, "id"]]),
          inference_notes = "Calculated from annotation using algorithm 'frequencySpectrumAAO'",
          cascade = 0
        )
      }
      pf <-
        t[t$Annotation.ID == as.character(a[[i, "id"]]) &
            !is.na(t$Annotation.ID) &
            t$Trait == "Frequency Spectrum (50%) (kHz)", ]
      if (nrow(pf) == 0) {
        bioacoustica::bioacoustica.postTrait(
          as.character(a[[i, "taxon"]]),
          c,
          call_type = as.character(a[[i, "type"]]),
          trait = "Frequency Spectrum (50%) (kHz)",
          value = paste0(spectrum[[2]], "-", spectrum[[4]]),
          temp = "",
          sex = "",
          annotation_id = as.character(a[[i, "id"]]),
          inference_notes = "Calculated from annotation using algorithm 'frequencySpectrumAAO'",
          cascade = 0
        )
      }
      pf <-
        t[t$Annotation.ID == as.character(a[[i, "id"]]) &
            !is.na(t$Annotation.ID) &
            t$Trait == "Frequency Spectrum (25%) (kHz)", ]
      if (nrow(pf) == 0) {
        bioacoustica::bioacoustica.postTrait(
          as.character(a[[i, "taxon"]]),
          c,
          call_type = as.character(a[[i, "type"]]),
          trait = "Frequency Spectrum (25%) (kHz)",
          value = paste0(spectrum[[1]], "-", spectrum[[5]]),
          temp = "",
          sex = "",
          annotation_id = as.character(a[[i, "id"]]),
          inference_notes = "Calculated from annotation using algorithm 'frequencySpectrumAAO'",
          cascade = 0
        )
      }
    }
  }
}