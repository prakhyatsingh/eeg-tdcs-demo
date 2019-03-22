% prepData
%
% This script will help convert xdf into .mat file
% by doing the following:
% 1. Loading XDF
% 2. figure out eeg adn trigger 
% 3. truncate base on trigger into 7 data segments
% 4. Save out those 7 individual data segments in to 7  .mat files
%
% - DTN: 3/22/2019 (Prakhyat)

%% Clearing all variables adn setting directories.

ccc;
inFile = '/Users/pk/Downloads/eeg-tdcs-demo/data/raw/S01_20180604_V01A.xdf';
outDir = '/Users/pk/Downloads/eeg-tdcs-demo/data/processed';

%% Look up files and load XDF

[streams, fileheader] = load_xdf(inFile);

%% Finding the correct data streams

for i = 1:length(streams)
    if strcmp(streams{i}.info.name, 'BrainAmpSeries')
        eegInd = i;
    else
        trigInd = i;
    end
end

%% Extracting out the EEG data and info

eeg = (streams{eegInd}.time_series).';
eeg_time = streams{eegInd}.time_stamps;

nEEGsamples = numel(eeg_time);
fs_eeg = 1/mean(diff(streams{eegInd}.time_stamps));

%% Extracting the trigger data and info

markers = (streams{trigInd}.time_series).';
markers_time = streams{trigInd}.time_stamps;

nMarkers = numel(markers_time(:));
trigger = zeros(nMarkers, 1);

for m = 1: nMarkers
    trigger(m) = str2num(markers{m});
end

%% Mark off data segments for each trial block

fprintf('\nMark the start of each trial block');
figure;
plot(markers_time, trigger, '.');
[starts, ~] = ginput(7); % 7 Blocks
close all;

fprintf('\nMark the end of each trial block');
figure;
plot(markers_time, trigger, '.');
[ends, ~] = ginput(7);
close all;
