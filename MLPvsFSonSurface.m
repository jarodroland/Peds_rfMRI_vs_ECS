%% Plot maps of thresholded MLP results and FreeSurfer Rolandic cortex on the brain surface

flags.plotMLP       = false;%true;%
flags.plotFreesurf  = false;%true;%
flags.saveFigures   = false;%true;%

%% init vars
inDir = GetDataDir();%'E:\Data\Grid\';
outDir = fullfile(getenv('HOME'), 'Dropbox', 'Research', 'Peds rsfMRI-Grid', 'Figures', 'MLPvsFS');

patidList = GetPatidListMotorOnly();
% patidList = {'EP186'}; % view from medial
% patidList = {'EP193'}; % view from above
numPatid = length(patidList);
mlpNetworks = {'DAN', 'VAN', 'MOT', 'VIS', 'FPC', 'LAN', 'DMN', 'noise'};
numRSNs = 7; %8;    %NOTE: use 8 to include Noise network
rsnMotorSensory = 3;
currentRSN      = rsnMotorSensory;% rsnSpeech;% 
allSensitivitySpecificity = zeros(numPatid, 2);

mlpThresh = 0.89;                               %MAGICNUMBER: threshold determined by Youdan's J in ROC analysis

% codes for surface maps
mapMLP  = 1;
mapFS   = 2;
mapBoth = 3;
combinedColormap = [    0.5,  0.5,  0.5;    % grey
                        1.0,  0.25, 0.25;   % red
                        0.25, 0.25, 1.0;    % blue
                        0.25, 1.0,  0.25;   % green
                   ];

if(flags.plotFreesurf || flags.plotMLP) 
    figMontage = figure();
end

%% loop through patids
for patidIdx = 1:numPatid%1%
    patid = patidList{patidIdx};

    % load electrode coordinates
    elecFilename = fullfile(inDir, 'freesurfer', [patid '_Pre'], 'elec_recon', [patid '_Pre.LEPTO']);
    hElecFile = fopen(elecFilename);
    [~] = textscan(hElecFile, '%*[^\n]', 2);            % remove the first 2 lines (header) from .LEPTO file
    electrodesCell = textscan(hElecFile, '%f %f %f');
    fclose(hElecFile);
    electrodes = [electrodesCell{1}, electrodesCell{2}, electrodesCell{3}];
    numElec = length(electrodes);

    % load electrode names
    elecNamesFilename = fullfile(inDir, 'freesurfer', [patid '_Pre'], 'elec_recon', [patid '_Pre.electrodeNames']);
    hNamesFile = fopen(elecNamesFilename);
    [~] = textscan(hNamesFile, '%*[^\n]', 2);            % remove the first 2 lines (header)
    namesCell = textscan(hNamesFile, '%s %c %c');
    fclose(hNamesFile);
    elecNames = namesCell{1};
    elecNamesIdx = num2cell(1:length(elecNames))';
    elecNamesMap = containers.Map(elecNames, elecNamesIdx);

    % determine side by average X coordinate
    if(mean(electrodes(:, 1)) > 0)
        side = 'r';
    else
        side = 'l';
    end

    % load surface model
    pialFilename = fullfile(inDir, 'freesurfer', [patid '_Pre'], 'surf', [side 'h.pial']);
    [verts, faces] = read_surf(pialFilename);
    faces = faces + 1;
    numVerts = length(verts);

    % map each vertex as MLP, FS, or both
    combinedMap = zeros(numVerts, 1);
    
    % load MLP weights
    weightsFilename = fullfile(inDir, 'freesurfer', [patid '_Pre'], [side 'h.MLP.motor.w']);
    [weightsList, weightsVerts] = read_wfile(weightsFilename);
    weightsMappedToVerts = zeros(numVerts, 1);
    weightsMappedToVerts(weightsVerts + 1) = weightsList;
    combinedMap(weightsMappedToVerts > mlpThresh) = mapMLP;
    
    % load aparc annotation
    aparcFilename = fullfile(inDir, 'freesurfer', [patid '_Pre'], 'label', [side 'h.aparc.annot']);
    [aparcVerts, aparcLabel, aparcColorTable] = read_annotation(aparcFilename, 0);
    aparcVerts = aparcVerts + 1;
    assert(length(aparcVerts) == numVerts, 'Error: Mis-match number vertices in annot');
    aparcLabel = aparcLabel(1:numVerts);
    aparcColorMap = aparcColorTable.table(:, 1:3) ./ 255;       % scale RGB colors to [0, 1]
    
    % covert aparcLabel to Rolandic mask
    preCentralID  = find(not( cellfun('isempty', strfind(aparcColorTable.struct_names, 'precentral')) ));       % find ID of precentral label
    postCentralID = find(not( cellfun('isempty', strfind(aparcColorTable.struct_names, 'postcentral')) ));      % find ID of postcentral label
    paraCentralID = find(not( cellfun('isempty', strfind(aparcColorTable.struct_names, 'paracentral')) ));      % find ID of paracentral label
    combinedMap(aparcLabel == aparcColorTable.table(preCentralID, 5)) = combinedMap(aparcLabel == aparcColorTable.table(preCentralID, 5)) + mapFS;
    combinedMap(aparcLabel == aparcColorTable.table(postCentralID, 5)) = combinedMap(aparcLabel == aparcColorTable.table(postCentralID, 5)) + mapFS;
    combinedMap(aparcLabel == aparcColorTable.table(paraCentralID, 5)) = combinedMap(aparcLabel == aparcColorTable.table(paraCentralID, 5)) + mapFS;
    

%% Calculate sensitivity & specificity for MLP vs Freesurfer
% (FP) False Positive = MLP only : mapMLP            : red
% (FN) False Negative = FS only  : mapFS             : blue
% (TP) True Positive  = MLP & FS : mapMLP + mapFS    : green
% (TN) True Negative  = neighter : 0                 : grey

falsePos = size(combinedMap(combinedMap == mapMLP));
falseNeg = size(combinedMap(combinedMap == mapFS));
truePos = size(combinedMap(combinedMap == mapMLP + mapFS));
trueNeg = size(combinedMap(combinedMap == 0));

sensitivity = truePos / (truePos + falseNeg);
specificity = trueNeg / (trueNeg + falsePos);
allSensitivitySpecificity(patidIdx, :) = [sensitivity, specificity];


%% Plotting
    if(flags.plotFreesurf || flags.plotMLP) % if we're plotting then this figure handle is already available
        ax = subplot(4, 4, patidIdx);

        % plot surface
        hSurf = trisurf(faces, verts(:, 1), verts(:, 2), verts(:, 3), combinedMap);
        colormap(combinedColormap);
        shading interp;%flat;%

        % turn off axis box clipping
        ax.Clipping = 'off';

        % beautify figure
        axis off
        axis tight;
        axis equal;
        axis vis3d          % hold camera position when rotating figure

        % setup lighting and camera
        lighting gouraud;
        material([0.3, 0.8, 0.2 10 1.0]);%dull;%
        lightObj = light;
        if(side == 'l')
            lightObj.Position = [-1 0 1];
            view(270, 0);                   % lateral view
        else
            lightObj.Position = [1 0 1];
            view(90, 0);                    % medial view
        end

        if(strcmp(patid, 'EP186'))
            lightObj.Position = [-1 0 1];
            view(270, 0);
        end

    %     title([patid ' - Motor']);
    end %if(flags.plotFreesurf || flags.plotMLP)
    
end %for patidIdx

%% Mean sensitivity & specificity
fprintf( 'Mean Sensitivity = %2.2f and Specificity = %2.2f \n', mean(allSensitivitySpecificity(:, 1)), mean(allSensitivitySpecificity(:, 2)) );


%% Saving
if(flags.saveFigures)
    outFile = [outDir 'MLPvsFSmontage'];
    
    figMontage.InvertHardcopy = 'off';     % prevents messing up the white electrode colors
    saveas(figMontage, [outFile '.png']);
    savefig(figMontage, [outFile '.fig']);
    close(figMontage)
end

