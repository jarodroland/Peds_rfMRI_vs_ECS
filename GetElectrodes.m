%% Returns the electrode data for each subject

function [elecCoords, elecNames, elecSide] = GetElectrodes(patid)
inDir = [GetDataDir(), 'freesurfer\'];
namesFilename = [inDir patid '_Pre\elec_recon\' patid '_Pre.electrodeNames'];
assert(exist(namesFilename, 'file') == 2, 'Error: electrodeNames file not found');

% parse electrode names
hFileNames = fopen(namesFilename);
elecNames = textscan(hFileNames, '%s', 'delimiter', sprintf('\n'));
fclose(hFileNames);
elecNames = elecNames{1};
elecNames = elecNames(3:end);
tokens = regexp(elecNames, '(.+\d+) [GSD] ([LR])', 'tokens');
elecNames = cellfun(@(x) x{1}{1}, tokens, 'UniformOutput', false);
elecSide = cellfun(@(x) x{1}{2}, tokens, 'UniformOutput', false);

% parse electrode coords
coordsFilename = [inDir patid '_Pre\elec_recon\ElectrodeROIs\' patid '_ElecROI_on_333.4dfp.img'];
elecROIData = Read4dfp(coordsFilename);
assert(size(elecROIData, 4) == length(elecNames), 'Error: Number of electrodes names does not match number of electrode ROIs')

numElec = size(elecROIData, 4);
elecCoords = zeros(numElec, 3);

% loop through electrodes and find electrode voxel
for elecNum = 1:numElec
    elecROI = squeeze(elecROIData(:, :, :, elecNum));
    elecInd = find(squeeze(elecROIData(:, :, :, elecNum)));
    assert(length(elecInd) == 1, ['Error: More than 1 electrode voxel found for electrode index ' num2str(elecNum)]);
    [elecX, elecY, elecZ] = ind2sub(size(elecROI), elecInd);
    elecCoords(elecNum, :) = [elecX, elecY, elecZ];
    
end %for elecNum

end %function
