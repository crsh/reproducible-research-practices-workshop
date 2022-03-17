library("targets")
library("tarchetypes")

options(tidyverse.quiet = TRUE)

tar_option_set(packages = c("rprojroot", "tools", "rmarkdown", "fs"))

slides_dir <- "src/slides"
exercise_dir <- "src/exercises"


exercise_rmd <- list.files(
  path = exercise_dir
  , pattern = "\\.rmd$|\\.Rmd$"
  , full.names = TRUE
)
exercise_rmd <- exercise_rmd[!grepl("template|setup", exercise_rmd)]

slide_rmd <- list.files(
  path = slides_dir
  , pattern = "\\.rmd$|\\.Rmd$"
  , full.names = TRUE
)
slide_rmd <- slide_rmd[!grepl("template|setup", slide_rmd)]


list(
  # Workshop metadata
  tar_target(
    workshop_meta
    , list(
      author = c("Johannes Breuer", "Frederik Aust")
      , date = "27.-28.04.2022"
      , location = "KU Leuven"
    )
  ),

  # Source files
  ## Slides
  tar_target(
    slide_rmd_files
    , c(!!slide_rmd)
    , format = "file"
  ),
  tar_target(
    slide_rmds
    , slide_rmd_files
  ),
  tar_target(
    slide_styles
    , c("src/slides/src/xaringan-themer.css", "src/slides/src/slides.css")
    , format = "file"
  ),
  tar_target(
    slide_output_file
    , c(
      file.path(!!slides_dir, "_output.yaml")
      , file.path(!!slides_dir, "_setup.Rmd")
    )
    , format = "file"
  ),

  ## Exercises
  tar_target(
    exercise_rmd_files
    , c(!!exercise_rmd)
    , format = "file"
  ),
  tar_target(
    exercise_rmds
    , exercise_rmd_files
  ),
  tar_target(
    exercise_output_file
    , c(
      file.path(!!exercise_dir, "_output.yaml")
      , file.path(!!exercise_dir, "_setup.Rmd")
    )
    , format = "file"
  ),

  # Render R Markdown files
  ## Outline
  tar_target(
    render_outline
    , {
      params <- workshop_meta

      fs::path_rel(
        # Need to return/track all input/output files.
        c(
          rmarkdown::render(
            input = "src/outline.Rmd"
            , output_dir = "."
            , intermediates_dir = file.path(rprojroot::find_rstudio_root_file(), "src")
            , knit_root_dir = file.path(rprojroot::find_rstudio_root_file(), "src")
            , clean = TRUE
            , params = workshop_meta
            , output_options = list(self_contained = TRUE)
          )
          , "src/outline.Rmd"
        )
      )
    }
    , format = "file"
  ),

  ## Slides
  tar_target(
    render_slides
    , {
      params <- workshop_meta
      list(slide_styles)
      list(slide_output_file)

      fs::path_rel(
        # Need to return/track all input/output files.
        c(
          rmarkdown::render(
            input = slide_rmds
            , output_dir = "slides"
            , intermediates_dir = file.path(rprojroot::find_rstudio_root_file(), !!slides_dir)
            , knit_root_dir = file.path(rprojroot::find_rstudio_root_file(), !!slides_dir)
            , clean = TRUE
            , params = workshop_meta
            , output_yaml = slide_output_file
            , output_options = list(self_contained = TRUE)
          )
          , slide_rmds
        )
      )
    }
    , pattern =  map(slide_rmds)
    , format = "file"
  ),

  ## Exercises
  tar_target(
    render_exercises
    , {
      params <- workshop_meta
      list(exercise_output_file)

      fs::path_rel(
        # Need to return/track all input/output files.
        c(
          rmarkdown::render(
            input = exercise_rmds
            , output_format = "all"
            , output_dir = "exercises"
            , intermediates_dir = file.path(rprojroot::find_rstudio_root_file(), !!exercise_dir)
            , knit_root_dir = file.path(rprojroot::find_rstudio_root_file(), !!exercise_dir)
            , clean = TRUE
            , params = workshop_meta
            , output_yaml = exercise_output_file
          )
          , exercise_rmds
        )
      )
    }
    , pattern =  map(exercise_rmds)
    , format = "file"
  ),

  # Spell checking
  tar_target(
    spellcheck_exceptions
      # Add new exceptions here
    , c("pandoc", "Frederik", "Aust", "Johannes", "Breuer")
  ),
  tar_target(
    spellcheck_rmds
    , spelling::spell_check_files(
      c(slide_rmds, exercise_rmd)
      , ignore = spellcheck_exceptions
    )
  ),
  tar_force(
    spellcheck_report_results
    , print(spellcheck_rmds)
    , nrow(spellcheck_rmds) > 0
  )
)
