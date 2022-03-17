---
title: ""
subtitle: "Workshop outline"
author  : "Johannes Breuer, Frederik Aust"

date    : "27.-28.04.2022"
location: "KU Leuven"

abstract: |
  For several years, psychological science has been facing a crisis of confidence fueled by concerns about low rates of successful replications of empirical findings.
  Different solutions have been proposed to address this issue.
  A key factor in these efforts is increasing transparency and computational reproducibility of psychological research.
  While transparent and computationally reproducible research is not necessarily more replicable, it facilitates replication attempts and helps to foster trust in empirical findings.
  The evolving open science ecosystem provides a variety of tools and services that can be used to implement reproducible research practices.
  Navigating the growing space of tools and practices, however, can be a daunting task.

  Hence, the purpose of this 2 days workshop is to introduce researchers to the essential components of tailored reproducible research workflows as well as the tools for implementing them.
  Combining lectures with practical hands-on sessions, the workshop will focus on data analysis, reporting of results, and sharing data and materials.
  Regarding the tool stack, the workshop will cover version control with Git and writing reports with RMarkdown as key components of a reproducible research workflow, but will also introduce other tools, such as the Open Science Framework (OSF), Docker, and Binder.

output:
  html_document:
    keep_md       : true
    theme         : "spacelab"
    df_print      : "kable"
    toc           : true
    toc_float     : true
---



---

## Learning objectives

Upon course completion, participants should

1. be familiar with key concepts of reproducible research
2. be able to choose the appropriate tools to implement a tailored workflow
3. have gained basic proficiency of Git, LaTeX, R Markdown, and `papaja`
4. be able to manage projects and collaborate using Git and GitHub

## Prerequisites

Participants should have some basic knowledge of R have used R Studio before.

---

# Preparations

To make the most of our time, we recommend that you prepare for the workshop by installing the following software ahead of time.

*Please note that these preparations will require some time to complete. Please do not delay them to the last moment before the workshop.*

### R and RStudio

Please ensure that you are using a recent version of R ($\geq$ 4.0.0) and RStudio.

### LaTeX

To enable `papaja`'s full set of features you need a [TeX](http://de.wikipedia.org/wiki/TeX) distribution.
We recommend that you use [TinyTex](https://yihui.name/tinytex/), a LaTeX distribution designed for use with R Markdown.
TinyTex can be installed from within R as follows.


```r
# If necessary, install tinytex R package
if(!requireNamespace("tinytex", quietly = TRUE)) install.packages("tinytex")

# Install TinyTex distribution
tinytex::install_tinytex()
```

If you prefer, you may also use [MikTeX](http://miktex.org/) for Windows, [MacTeX](https://tug.org/mactex/) for Mac, or [TeX Live](http://www.tug.org/texlive/) for Linux.
Refer to the [`papaja` manual](https://crsh.github.io/papaja_man/introduction.html#getting-started) for instructions.


#### `papaja`

`papaja` is not yet available on CRAN but you can install it from this repository:


```r
# Install remotes package if necessary
if(!requireNamespace("remotes", quietly = TRUE)) install.packages("remotes")

# Install the latest development snapshot from GitHub
remotes::install_github("crsh/papaja")
```



### Git and GitHub

We will use Git for version control (change tracking) and as a tool for collaboration.
The following steps may be daunting at first, but the linked-to instructions are excellent and should get you set up in no time.
You can do it! :)

In preparation, please

1. create a [GitHub](https://github.com) account
2. install Git (see [instructions](https://happygitwithr.com/install-git.html))
    - During installation of Git, add `git bash` to the Windows context menu by selecting its option (this should be the default)
3. configure Git (see [ instructions](https://happygitwithr.com/hello-git.html))
2. create a personal access token for HTTPS (see [instructions](https://happygitwithr.com/https-pat.html))
4. confirm that you can connect to GitHub (see [instructions](https://happygitwithr.com/push-pull-github.html))
