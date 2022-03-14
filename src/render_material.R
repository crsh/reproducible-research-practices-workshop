
# Global parameters to be passed to YAML header ---------------------------

params <- list(
  author = c("Johannes Breuer", "Frederik Aust")
  , date = "27.-28.4.2022"
  , location = "KU Leuven"
)


# all slides in subfolder src/slides/ -------------------------------------


all_slides <- list.files(
  path = "src/slides"
  , pattern = ".rmd$|.Rmd$"
  , full.names = TRUE
)

all_slides <- all_slides[!grepl("template", all_slides)]

for (i in all_slides) {
  rmarkdown::render(
    input = i
    , output_format = NULL
    , output_dir = "slides"
    , intermediates_dir = "src/slides"
    , knit_root_dir = file.path(rprojroot::find_rstudio_root_file(), "src/slides")
    , clean = TRUE
    , params = params
  )
}

# all exercises in subfolder src/exercises/ -------------------------------

all_assignments <- list.files(
  path = "src/exercises"
  , pattern = ".rmd$|.Rmd$"
  , full.names = TRUE
  , recursive = TRUE
)
all_assignments <- all_assignments[!grepl("template", all_assignments)]

for(s in c(FALSE, TRUE)) {
  params$solution <- s

  for (i in all_assignments) {
    rmarkdown::render(
      input = i
      , output_file = if(s) paste0(tools::file_path_sans_ext(i), "-solution") else tools::file_path_sans_ext(i)
      , output_format = NULL
      , output_dir = "exercises"
      , intermediates_dir = "src/exercises"
      , knit_root_dir = file.path(rprojroot::find_rstudio_root_file(), "src/exercises")
      , clean = TRUE
      , params = params
    )

    # if(s) {
    #   knitr::purl(
    #     input = i
    #     , output = file.path("assignments/output", paste0(tools::file_path_sans_ext(basename(i)), ".R"))
    #   )
    # }
  }
}
