#!/bin/sh

if [ $# -eq 0 ]
  then
    echo "Please provide a valid path for the project."
    exit 1
fi

mkdir $1
cd $1
mkdir data
mkdir src
mkdir output
touch .gitignore
touch README 
