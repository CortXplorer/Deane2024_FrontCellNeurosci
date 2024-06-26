
function AvrecPeakRatio(figs,Tab,whichstim="2Hz",savetype=".pdf",stimtype="CL",trialtype="TA")
    # Input: folder path figs, table for ratio of 2 hz and 5 hz, all groups being plotted
    # Output: figures in folder AvrecPeakRatio of the level of synaptic depression shown as a function of the last divided by the first response peak amplitude
 
    foldername = "AvrecPeakRatio"
    if !isdir(joinpath(figs,foldername))
        mkdir(joinpath(figs,foldername))
    end

    LayList = unique(Tab[:,:Layer])

    for iLay = 1:length(LayList)
        ### peak amp by measurement per Layer ###
        Tab_Sort = Tab[Tab[:,:Layer] .== LayList[iLay],:]
        Tab_Sortamp = filter(row -> ! isnan(row.RatioAMP), Tab_Sort)
        Tab_Sortrms = filter(row -> ! isnan(row.RatioRMS), Tab_Sort)

        Title = "Synaptic dep ratio of " * LayList[iLay] * " at " * whichstim * " Peak Amplitude " * stimtype
        ratioplot = @df Tab_Sortamp groupedboxplot(:Measurement, :RatioAMP, group = :Group, bar_position = :dodge, lab= ["Control" "Treated" "Virus Control"], title=Title, xlab = "Measurement", ylab = "Ratio of last to first Peak Amplitude [%]")

        if maximum(Tab_Sortamp.RatioAMP) > 500
            plot!(ylims=(0,500))
        end

        name = joinpath(figs,foldername,Title) * " " * trialtype * savetype
        savefig(ratioplot, name);

        Title = "Synaptic dep ratio of " * LayList[iLay] * " at " * whichstim * " RMS " * stimtype
        ratioplot = @df Tab_Sortrms groupedboxplot(:Measurement, :RatioRMS, group = :Group, bar_position = :dodge, lab= ["Control" "Treated" "Virus Control"], title=Title, xlab = "Measurement", ylab = "Ratio of last to first Peak RMS [%]")

        if maximum(Tab_Sortrms.RatioRMS) > 500
            plot!(ylims=(0,500))
        end

        name = joinpath(figs,foldername,Title) * " " * trialtype * savetype
        savefig(ratioplot, name);
    end
end

function Avrec1Peak(figs,Tab,whichpeak="1st",whichstim="2Hz",savetype=".pdf",stimtype="CL",trialtype="ST")
    # Input: folder path figs, table for peak amp/lat of 2 hz and 5 hz, all groups being plotted
    # Output: figures in folder Avrec1stPeak of the first peak response and latency for all groups

    foldername = "Avrec1Peak"
    if !isdir(joinpath(figs,foldername))
        mkdir(joinpath(figs,foldername))
    end

    LayList = unique(Tab[:,:Layer])

    for iLay = 1:length(LayList)
        ### peak amp by measurement per Layer ###
        Tab_Sort = Tab[Tab[:,:Layer] .== LayList[iLay],:]
        Tab_Sortamp = filter(row -> ! isnan(row.PeakAmp), Tab_Sort)
        Tab_Sortrms = filter(row -> ! isnan(row.RMS), Tab_Sort)

        Title = whichpeak * " peak amplitude of " * LayList[iLay] * " at " * whichstim * " " * stimtype * " "
        peakplot = @df Tab_Sortamp groupedboxplot(:Measurement, :PeakAmp, group = :Group, bar_position = :dodge, lab= ["Control" "Treated" "Virus Control"], title=Title, xlab = "Measurement", ylab = "Peak Amplitude [mV/mm²]")

        name = joinpath(figs,foldername,Title) * trialtype * savetype
        savefig(peakplot, name);

        Title = whichpeak * " peak latency of " * LayList[iLay] * " at " * whichstim * " " * stimtype * " "
        peakplot = @df Tab_Sortamp groupedboxplot(:Measurement, :PeakLat, group = :Group, bar_position = :dodge, lab= ["Control" "Treated" "Virus Control"], title=Title, xlab = "Measurement", ylab = "Peak Latency [ms]")

        name = joinpath(figs,foldername,Title) * trialtype * savetype
        savefig(peakplot, name);

        Title = whichpeak * " RMS of " * LayList[iLay] * " at " * whichstim * " " * stimtype * " "
        peakplot = @df Tab_Sortrms groupedboxplot(:Measurement, :RMS, group = :Group, bar_position = :dodge, lab= ["Control" "Treated" "Virus Control"], title=Title, xlab = "Measurement", ylab = "RMS [mV/mm²]")

        name = joinpath(figs,foldername,Title) * trialtype * savetype
        savefig(peakplot, name);

    end
end