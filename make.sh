#!/bin/bash

# Render slides and assignments
Rscript -e "targets::tar_make()"

# # Convert slides to PDF using decktape Docker container
# cd slides
#
# for slidedeck in $PWD/*.html
# do
#   docker run -t -v `pwd`:$PWD -v ~:/home/user astefanutti/decktape --chrome-arg=--allow-file-access-from-files -s 1024x768 "$slidedeck" slides.pdf
#   docker cp `docker ps -lq`:slides/slides.pdf "${slidedeck/html/pdf}"
#   docker rm `docker ps -lq`
# done
