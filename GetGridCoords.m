function [elecCoords, elecNames] = GetGridCoords(patid)
%% Returns the electrodes coordinates for each patient

%% init vars
inDir = GetDataDir();
% outDir = [getenv('USERPROFILE') '\Dropbox\Research\Peds rsfMRI-Grid\Figures'];

% patid = 'EP174';

filenameElecID      = [inDir 'freesurfer\' patid '_Pre\elec_recon\' patid '_Pre.electrodeNames'];
filenameElecCoords  = [inDir 'freesurfer\' patid '_Pre\elec_recon\' patid '_Pre.coords_pial_on_T1'];

%% load data
% read electrode names/IDs
hFileElecID = fopen(filenameElecID);
elecNamesTxt = textscan(hFileElecID, '%s %s %s');
fclose(hFileElecID);
elecNames = elecNamesTxt{1, 1};
elecNames = elecNames(3:end);

% read electrode coordinates
hFileElecCoords = fopen(filenameElecCoords);
elecCoordsTxt = textscan(hFileElecID, '%f %f %f');
fclose(hFileElecCoords);
elecCoords = [elecCoordsTxt{1, 1}, elecCoordsTxt{1, 2}, elecCoordsTxt{1, 3}];

assert(length(elecCoords) == length(elecNames), 'Error: Different number of electrodes coordinates and names.');

end %function elecNames = GetGridCoords()