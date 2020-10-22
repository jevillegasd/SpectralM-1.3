function measurement = newMeasurement(spectra)
%This functions creates a new measurement data class an initilizes all its
%members, in case a spectra is input it saves that spectra to the variable
%measurement.spectra.
%Part of Spectral Measurements
%Copyright (C) NYU 2019
%Developed by Juan Villegas, 8/01/2019

            if nargin <1, spectra = zeros(0,2); end
            measurement = {};
            measurement.ID = randi(1e6);
            measurement.time = now();
                sweepParam = {};
                sweepParam.channel = 1;
                sweepParam.power = 3;
                sweepParam.starWav = min(spectra(:,2));
                sweepParam.stopWav = min(spectra(:,2));
                try sweepParam.step = spectra(2,2)-spectra(1,2);
                    catch, sweepParam.step = 0;end
                sweepParam.sweepSpeed = 0;
                sweepParam.range = round(max(spectra(:,1)),-1);
            measurement.sweepParam=sweepParam;
            s = size(spectra);
            measurement.spectra = spectra;
                analysisParam = {};
                analysisParam.filter = {};  %Peak detection filters
                analysisParam.type = 'Not defined';    %Type of resonator
                analysisParam.L = 0;        %Cavity length or branch difference 
                analysisParam.ne = 1;       %Effective index of the waveguide used
                analysisParam.windowSc = 0; %Fraction of data to make the Lorentizan fit (realtive to the FSR)_
            measurement.analysisParam = analysisParam;
                peakAnalysis = {};
                peakAnalysis.nop = 0;       %Number of peaks found
                peakAnalysis.pks = [];
                peakAnalysis.wav = [];
                peakAnalysis.fsr = [];
                peakAnalysis.fwhm = [];
                peakAnalysis.q = [];
                peakAnalysis.ng = [];
                peakAnalysis.a =[];
                peakAnalysis.adB =[];
                    filter = {};
                    filter.stat = [];
                    filter.param = [];
                peakAnalysis.filter = filter;
            measurement.peakAnalysis =peakAnalysis;
                var = [0,0,0];
            measurement.var = var;
end