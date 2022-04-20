# terminal command: `Pipeline02_LMM.R`

# create a directory Data/LMMstats for the output. ignores, if already exists 
output_path <- paste(getwd(),"/Data/LMMstats",sep="")
dir.create(output_path, showWarnings = FALSE)

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
  input = "Scripts/R/LMM_AM.Rmd",  
  output_file = file.path(output_path, "LMM_AM.html"))

rmarkdown::render(
  input = "Scripts/R/LMM_CL.Rmd",  
  output_file = file.path(output_path, "LMM_CL.html"))


