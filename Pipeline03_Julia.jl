### This pipeline takes extracted features from avrec and layer trace data in the form of csv (output from matlab) and produces graphs and plots for all t tests and cohen's d tests 

## input:   Deane_etal_2022/Data/PeakDataCSV/AVRECPeak*ST.csv
## output:  Deane_etal_2022/Figures/Avrec1Peak, & /CohensDPlots 
#           -&- Deane_etal_2022/Data/PeakDataCSV/AvrecPeakStats

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

        # seperate just stimulus presentation from full table
        StimHz = PeakDatST[PeakDatST[:,:ClickFreq] .== parse(Int,freqtype[iFrq][begin:end-2]),:]

        ## Peak Amp/Lat/RMS response difference
        peaks = ["1st"] # refers to how many detection windows to look through (5 Hz has 5, 10 Hz has 10, etc.). Just the first was used for most of the publication
        # full list: "1st" "2nd" "3rd" "4th" "5th" "6th" "7th" "8th" "9th" "10th" 
        for ipeak = 1:length(peaks)

            if ipeak <= StimHz.ClickFreq[1] # cut this to amount of detection windows
                # pull out current response window (i.e. 1st peak)
                Stat = StimHz[StimHz[:,:OrderofClick] .== ipeak,:]
                # create box plot figures for peak amp, peak latency, and root mean square 
                Avrec1Peak(figs,Stat,peaks[ipeak],freqtype[iFrq],savetype,stimtype[iTyp],"ST")
                # create csv table of stats comparing between group at each pre and post laser measurement
                Peak1_Between(data,Stat,peaks[ipeak],freqtype[iFrq],stimtype[iTyp],"ST")
                # create csv table of stats comparing within group from pre to post laser measurements
                Peak1_Within(data,Stat,peaks[ipeak],freqtype[iFrq],stimtype[iTyp],"ST")
            end
        end # which peak
    end # stim frequency
end # stim type CL or AM

include(joinpath(func,"CohensProg.jl")) # contains cohen's d plotting function (stats output already has cohen's d results per row, make sure it has been generated with the previous code at least once)
peaks = ["1st"] # same as above
# create Cohen's d figures based on tables created above
CohensProg(figs, data, freqtype, stimtype, peaks, savetype)