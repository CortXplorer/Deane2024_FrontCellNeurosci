These are the scripts specific to the **Frontiers in Cellular Neuroscience** publication:

## Title: Inhibiting presynaptic calcium channel motility in the auditory cortex suppresses synchronized input processing
### Authors: ***Katrina E. Deane, Ruslan Klymentiev, Jennifer Heck, Frank W. Ohl, Martin Heine, Max F. K. Happel***
[https://www.frontiersin.org/articles/10.3389/fncel.2024.1369047](https://www.frontiersin.org/articles/10.3389/fncel.2024.1369047)

***Please cite us if you use these scripts***

___

#### Necessary to run:
Raw data for this project can be found at: [https://figshare.com/s/5000eeb8946f1b8fd33e](https://figshare.com/articles/dataset/Raw_Data_for_Deane_et_al_2024_Front_Cell_Neurosci/12080910)
Animal raw data (e.g "KIC01_0001.mat") should be placed in ../Deane_etal_2024/Raw;

#### Order to run and summary of steps:

If animal raw data files are placed correctly in \Deane_etal_2022\Raw, running the *Pipeline01_MatLab.m* script will produce 
* single CSD figures
* group average CSD figures
* Data structure per animal with all measurement data (lfp, csd, avrec, relres, absres)
* single AVREC and layer traces
* single trial peak detection csv per animal (to be compiled into AVRECPeakCLST.csv and AVRECPeakAMST.csv)
* group average AVREC and layer traces 

If AVRECPeakCLST.csv and AVRECPeakAMST.csv is in \Deane_etal_2022\Data\PeakDataCSV\, running *Pipeline02_LMM.R* will produce 
* LMM html files in \Deane_etal_2022\Data\LMMstats
* NOTE: these master files need to be manually compiled by copying data from per-subject single trial peak data output of Deane_etal_2022\Scripts\MatLab\ChangeInAvrecSTperAnimal, run from the Pipeline01_MatLab script (can be run independantly if data already exists from previous runs)

Then running *Pipeline03_Julia.jl* will produce
* cohen's d and student's t test graphs and data output

___

***Please raise an issue in this repository if something is not running. Thank you!***
