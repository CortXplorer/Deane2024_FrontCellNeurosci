### This pipeline is for supplemental figures and graphs if desired. Contained here are synaptic depression ratios testing if there is a difference between groups from the response of the first to the last click or modulation in a train as well as Vector strength analysis.

### Ratio of first to last response ###
# ------------------------------------------------------------------------------------------
## input:   Deane_etal_2022/Data/PeakDataCSV/AVRECPeak*ST.csv
## output:  Deane_etal_2022/Figures/Avrec1Peak, & /CohensDPlots
#           -&- Deane_etal_2022/Data/PeakDataCSV/AvrecPeakStats

### Peak Amp/RMS Ratio of Last/First response
        # -> J. Heck, in her paper, used EPSP5/EPSP1 to show the difference between groups of the ratio from the last to first stimulus response

# This loop runs through stim type (click and AM), and frequency (5 and 10 Hz). It analyzes groups KIT, KIC, and KIV and can handle changes in group size if animals are added. Analysis is run for single-trial (ST) data

# # to add packages (e.g. Plots): # #
# type ']' in command window to enter pkg> 
# then in pkg> type 'add Plots' 
# then backspace to return to julia> and use 'using Plots'
# #
using Plots, OhMyREPL
using CSV, DataFrames
using StatsPlots
using HypothesisTests, EffectSizes

# # make sure Julia is in the directory you would like to use: # #
# type '@__DIR__' to print out the directory julia is currently pointing to
home    = @__DIR__
func    = joinpath(home,"Scripts\\Julia")
figs    = joinpath(home,"Figures")
data    = joinpath(home,"Data\\PeakDataCSV")
include(joinpath(func,"AvrecPeakPlots.jl")) # contains all plotting functions 
include(joinpath(func,"AvrecPeakStats.jl")) # contains all stats functions

savetype = ".pdf" # choose how all figures are saved, default ".pdf"
stimtype = ["CL" "AM"] # CL = click train and AM = amplitude modulation
freqtype = ["5Hz" "10Hz"] # "2Hz" "5Hz" "10Hz" "20Hz" "40Hz"# frequency of train or modulation

for iTyp = 1:length(stimtype)
    # Load in data from matlab table csv file which contains 2 and 5 hz peak amp and latency. 
    if stimtype[iTyp] == "CL"
        PeakDatST = CSV.File(joinpath(data,"AVRECPeakCLST.csv")) |> DataFrame # single trial
        println("Click Trains")
    elseif stimtype[iTyp] == "AM"
        PeakDatST = CSV.File(joinpath(data,"AVRECPeakAMST.csv")) |> DataFrame # single trial
        println("Amplitude Modulation")
    end

    for iFrq = 1:length(freqtype)

        println("Single Trial Stats At frequency: " * freqtype[iFrq])

        # seperate just stimulus presentation from full table
        StimHz = PeakDatST[PeakDatST[:,:ClickFreq] .== parse(Int,freqtype[iFrq][begin:end-2]),:]

        # seperate the 1st and last click
        Stat  = StimHz[StimHz[:,:OrderofClick] .== 1,:]
        Last  = StimHz[StimHz[:,:OrderofClick] .== parse(Int,freqtype[iFrq][begin:end-2]),:]

        # divide the last by first
        RatioAMP  = Last[:,:PeakAmp] ./ Stat[!,:PeakAmp] .* 100
        RatioRMS  = Last[:,:RMS] ./ Stat[!,:RMS] .* 100
        # add this column to the table to keep tags
        Stat.RatioAMP, Stat.RatioRMS = RatioAMP, RatioRMS

        # cheeky plots first;
        AvrecPeakRatio(figs,Stat,freqtype[iFrq],savetype,stimtype[iTyp],"ST")

        # And stats for overlay
        PeakRatio_Between(data,Stat,freqtype[iFrq],stimtype[iTyp],"ST")
        PeakRatio_Within(data,Stat,freqtype[iFrq],stimtype[iTyp],"ST")

    end
end

### Vector Strength ###
# ------------------------------------------------------------------------------------------
## input:   Deane_etal_2022/Data/PeakDataCSV/AVRECPeak*ST.csv
## output:  Deane_etal_2022//Data/PeakDataCSV/VSoutput
# from https://journals.physiology.org/doi/pdf/10.1152/jn.01109.2007 :
# The vector strength and mean phase were obtained by expressing spike times relative to the phase of the modulator, representing each spike as a unit vector with orientation given by that phase, and computing the sum of the unit vectors. The vector strength was given by the length of the resultant vector divided by the number of vectors. It could range from 0 (no phase locking) to 1 (all spikes at identical phase); spike probability exactly following the sine modulator waveform would yield a vector strength of 0.5. The mean phase was given by the orientation of the resultant vector. The mean phase lag tended to increase linearly with increasing modulator frequency.

using DSP, FFTW
using CSV, DataFrames
using StatsPlots

home    = @__DIR__
func    = joinpath(home,"Scripts\\Julia")
data    = joinpath(home,"Data\\PeakDataCSV")
figs    = joinpath(home,"Figures")
# figs    = joinpath(home,"figs")

include(joinpath(func,"VSfunc.jl"))

# parameters:
sr   = 1000 # sampling rate
type = ["AM" "CL"]
clickfreq = [5 10]   # stimulus frequency full list: [2 5 10 20 40]

for curtype = type
    for curCF = clickfreq
        VSstats(data, sr, curtype, curCF)
    end
end

layer = ["All" "I_II" "IV" "V" "VI"]  

# note: "corrected" means vector strength only taken for figure when significance was found
for curtype = type
    for curCF = clickfreq
        for curlay = layer
            VSfigure(data, figs, curtype, curCF, curlay)
        end
    end
end

