# terminal command: `Rscript main_script.R`

# check if packages are installed and install if not

packages <- c(
  "tidyverse", "knitr", "kableExtra", "nlme",
  "emmeans", "standardize", "gridExtra", "effectsize",
  "nlstools", "htmltools", "rmarkdown")

for(pckg in packages) {
  if(!pckg %in% rownames(installed.packages())) {
    install.packages(pckg)
  }
}


# render RMarkdown files

rmarkdown::render(
  input = "LMM_AM.Rmd",  
  output_file = "LMM_AM.html")

rmarkdown::render(
  input = "LMM_CL.Rmd",  
  output_file = "LMM_CL.html")
