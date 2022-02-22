Command to run the main R script:

```bash
$ Rscript Pipeline02_LMM.R
```

Note, that data for the LMM analysis should be stored in `"Data/PeakDataCSV/AVRECPeakAMST.csv"` and `"Data/PeakDataCSV/AVRECPeakCLST.csv"`. If path to data has changed, please change it in RMarkdown files `LMM_AM.Rmd` and `LMM_CL.Rmd` (line 42).

Script will also check whether all the needed packages are installed and install them if it's not the case. Packages used: tidyverse, knitr, kableExtra, nlme, emmeans, standardize, gridExtra, effectsize, nlstools, htmltools, rmarkdown.
