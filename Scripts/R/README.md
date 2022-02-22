Command to run the main R script:

```bash
$ Rscript main_script.R
```

Note, that data for the LMM analysis should be stored in `"Data/AVRECPeakAMST.csv"` and `"Data/AVRECPeakCLST.csv"`. If path to data has changed, please change it in RMarkdown files `LMM_AM.Rmd` and `LMM_CL.Rmd` (line 42).

Script will also check whether all the needed packages are installed and install them if it's not the case. Packages used: tidyverse, knitr, kableExtra, nlme, emmeans, standardize, gridExtra, effectsize, nlstools, htmltools, rmarkdown.
