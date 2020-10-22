function t = getTableAnalysis(peakAnalysis)
%Reads an analysis structure and builds a table with values for 
%the displayed table
%Part of SpectralMeasurements
%Copyright NYU 2019
%Develloiped by Juan Villegas
%04/08/2019

    sizeP = length(peakAnalysis);
    
    peak = 1:sizeP;
    wav = peakAnalysis.wav;
    fsr = peakAnalysis.fsr;
    fwhm = peakAnalysis.fwhm;
    q = peakAnalysis.q;
    ng = peakAnalysis.ng;
    a = peakAnalysis.adB;
                    
    t = table(peak,wav,fsr,fwhm,q,ng,a);
end