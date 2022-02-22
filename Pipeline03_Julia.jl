### This pipeline takes extracted features from avrec and layer trace data in the form of csv (output from matlab) and produces graphs and plots for all t tests and cohen's d tests as well as a few extra plots to explore the data

## input:   Deane_etal_2022/Data/PeakDataCSV/AVRECPeak*ST.csv
## output:  Deane_etal_2022/Figures/Avrec1Peak, .../AvrecPeakPlots_againstLayer, .../AvrecPeakPlots_againstMeasurement, .../AvrecPeakRatio, .../AvrecScatter, .../CohensDPlots -&- home/Data/AvrecPeakStats

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

# This loop runs through stim type (click and AM), and frequency (5 and 10 Hz). It analyzes groups KIT, KIC, and KIV and can handle changes in group size if animals are added. Analysis is run for single-trial (ST) data
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
        ### Stats ###
        #-----------------------------------------------------------------------
        # seperate just stimulus presentation from full table
        StimHz = PeakDatST[PeakDatST[:,:ClickFreq] .== parse(Int,freqtype[iFrq][begin:end-2]),:]

        ## Peak Amp/Lat/RMS response difference
        peaks = ["1st"] # refers to how many detection windows to look through (5 Hz has 5, 10 Hz has 10, etc.). Just the first was used for most of the publication
        # full list: "2nd" "3rd" "4th" "5th" "6th" "7th" "8th" "9th" "10th" 
        for ipeak = 1:length(peaks)

            if ipeak <= StimHz.ClickFreq[1] # cut this to amount of detection windows
                # pull out current response window (i.e. 1st peak)
                Stat = StimHz[StimHz[:,:OrderofClick] .== ipeak,:]
                Avrec1Peak(figs,Stat,peaks[ipeak],freqtype[iFrq],savetype,stimtype[iTyp],"ST")
                Peak1_Between(data,Stat,peaks[ipeak],freqtype[iFrq],stimtype[iTyp],"ST")
                Peak1_Within(data,Stat,peaks[ipeak],freqtype[iFrq],stimtype[iTyp],"ST")
            end

        end

        # ### Peak Amp/RMS Ratio of Last/First response
        # # -> J. Heck, in her paper, used EPSP5/EPSP1 to show the difference between groups of the ratio from the last to first stimulus response

        # # seperate the 1st and last click
        # Stat  = StimHz[StimHz[:,:OrderofClick] .== 1,:]
        # Last  = StimHz[StimHz[:,:OrderofClick] .== parse(Int,freqtype[iFrq][begin:end-2]),:]

        # # divide the last by first
        # RatioAMP  = Last[:,:PeakAmp] ./ Stat[!,:PeakAmp] .* 100
        # RatioRMS  = Last[:,:RMS] ./ Stat[!,:RMS] .* 100
        # # add this column to the table to keep tags
        # Stat.RatioAMP, Stat.RatioRMS = RatioAMP, RatioRMS

        # # cheeky plots first;
        # AvrecPeakRatio(figs,Stat,freqtype[iFrq],savetype,stimtype[iTyp],TAorST[iStat])

        # # And stats for overlay
        # PeakRatio_Between(data,Stat,freqtype[iFrq],stimtype[iTyp],TAorST[iStat])
        # PeakRatio_Within(data,Stat,freqtype[iFrq],stimtype[iTyp],TAorST[iStat])

        # # Scatter Plots for visualization and possibly use for Brown Forsythe stats overlay
        # AvrecScatter(figs,StimHz,freqtype[iFrq],savetype,stimtype[iTyp],TAorST[iStat])


    end
end

include(joinpath(func,"CohensProg.jl")) # contains cohen's d plotting function (stats output already has cohen's d results per row)

CohensProg(figs, data, freqtype, stimtype, savetype)

# Run RAnova.R before or after this