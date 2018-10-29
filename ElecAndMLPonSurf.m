%% Plot electrodes on the brain surface with MLP statistical map (or Freesurfer parcellation). All subjects data in a montage figure.

flags.plotMLP       = true;%false;%
flags.plotFreesurf  = false;%true;%
flags.saveFigures   = false;%true;%

%% init vars
inDir = GetDataDir();%'E:\Data\Grid\';
outDir = fullfile(getenv('USERPROFILE'), 'Dropbox', 'Research', 'Peds rsfMRI-Grid', 'Figures', 'ElecOnSurface');

patidList = GetPatidListMotorOnly();
numPatid = length(patidList);
mlpNetworks = {'DAN', 'VAN', 'MOT', 'VIS', 'FPC', 'LAN', 'DMN', 'noise'};
numRSNs = 7; %8;    %NOTE: use 8 to include Noise network
rsnMotorSensory = 3;
rsnSpeech       = 6;
currentRSN      = rsnMotorSensory;% rsnSpeech;% 

% create colormap to use with MLP
numStep = 100;
% delta = (1:numStep)' ./ numStep;                                  % linear easing function
delta = -(cos( pi * ((1:numStep) ./ numStep) .^2 )' - 1) / 2;       % in/out sine squared easing function
% mlpColormap = [0.001 + (0.999 * delta), 0.5 - (0.5 * delta), 0.5 - (0.5 * delta)];
brightnessLevel = 0.7;   
mlpColormap = [brightnessLevel + ((1-brightnessLevel) * delta), brightnessLevel - (brightnessLevel * delta), brightnessLevel - (brightnessLevel * delta)];


%% loop through patids
for patidIdx = 1:numPatid%9:9%2:2%
    patid = patidList{patidIdx};

    % get stim mapping results
    stimResults = GetStimMappingResults(patid);
    
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

    % load MLP weights
    weightsFilename = fullfile(inDir, 'freesurfer', [patid '_Pre'], [side 'h.MLP.motor.w']);
    [weightsList, weightsVerts] = read_wfile(weightsFilename);
    weightsMapped = zeros(length(verts), 1);
    weightsMapped(weightsVerts + 1) = weightsList;
    
    % load aparc annotation
    aparcFilename = fullfile(inDir, 'freesurfer', [patid '_Pre'], 'label', [side 'h.aparc.annot']);
    [aparcVerts, aparcLabel, aparcColorTable] = read_annotation(aparcFilename, 0);
    aparcVerts = aparcVerts + 1;
    assert(length(aparcVerts) == numVerts, 'Error: Mis-match number vertices in annot');
    aparcLabel = aparcLabel(1:numVerts);
    aparcColorMap = aparcColorTable.table(:, 1:3) ./ 255;       % scale RGB colors to [0, 1]
    
    % convert aparcLabel to color map
    numLabels = length(aparcColorMap);
    aparcColor = zeros(numVerts, 1);        % color map
    for labelIdx = 1:numLabels
        aparcColor(aparcLabel == aparcColorTable.table(labelIdx, 5)) = labelIdx;     %MAGICNUMBER: structure ID is in the 5th column
    end
%     aparcColor = zeros(numVerts, 3);        % true color
%     for labelIdx = 1:numLabels
%         indices = find(aparcLabel == aparcColorTable.table(labelIdx, 5));         %MAGICNUMBER: structure ID is in the 5th column
%         numIndices = length(indices);
%         aparcColor(indices, :) = repmat(aparcColorMap(labelIdx, :), numIndices, 1);
%     end
%     aparcColor = reshape(aparcColor, [numVerts, 1, 3]);
    
    %% Plotting
    ax = subplot(3, 6, patidIdx);
    
    % plot MLP maps
    if(flags.plotMLP)               % plot surface w/ MLP
        trisurf(faces, verts(:, 1), verts(:, 2), verts(:, 3), weightsMapped);
        colormap(mlpColormap);
        caxis([0.0 1.0])
        shading interp;
    % plot Freesurfer parcelation
    elseif(flags.plotFreesurf)      % plot surface w/ aparc
        hSurf = trisurf(faces, verts(:, 1), verts(:, 2), verts(:, 3), aparcColor);
        colormap(aparcColorMap);
        shading flat;
        caxis([1 numLabels]);
    end
    
    % turn off axis box clipping
    ax.Clipping = 'off';

    % assign electrode colors per stim mapping results
    elecColors = repmat([0, 0, 0], numElec, 1);
    motorColor = [1, 1, 1];%[0, 0, 1];%
    for elecIdx = 1:length(stimResults.Motor)
        elecColors(elecNamesMap(stimResults.Motor{elecIdx}), :) = motorColor;
    end
    for elecIdx = 1:length(stimResults.Sensory)
        elecColors(elecNamesMap(stimResults.Sensory{elecIdx}), :) = motorColor;
    end

    % dilate electrodes out to not overlap surface
%     electrodes = electrodes * 1.02;     
    elecShift = 10;
    if((side == 'l') || (strcmp(patid, 'EP186')))
        elecShift = -elecShift;
    end
    
    % plot electrodes
    hold on
    for elecIdx = 1:numElec
        plot3(electrodes(elecIdx, 1) + elecShift, electrodes(elecIdx, 2), electrodes(elecIdx, 3), '.', 'Color', elecColors(elecIdx, :), 'MarkerSize', 12.5)%, 'MarkerEdgeColor', 'k')%30)
    end

    % beautify figure
    axis off
    axis tight;
    axis equal;

    % setup lighting and camera
    lighting gouraud;
    material([0.3, 0.8, 0.2 10 1.0]);%dull;%
    lightObj = light;
    if(side == 'l')
        lightObj.Position = [-1 0 1];
        view(270, 0);                   % lateral view
    else
        lightObj.Position = [1 0 1];
        view(90, 0);
    end
    
    if(strcmp(patid, 'EP186'))
        lightObj.Position = [-1 0 1];
        view(270, 0);
    end

    %% Saving
    if(flags.saveFigures)
        if(flags.plotMLP)
            outFile = [outDir patid '_ElectOnSurf_motor_mlp'];
        elseif(flags.plotFreesurf)
            outFile = [outDir patid '_ElectOnSurf_motor_freesurf'];
        end
        figSurf.InvertHardcopy = 'off';     % prevents messing up the white electrode colors
        saveas(figSurf, [outFile '.png']);
        savefig(figSurf, [outFile '.fig']);
        close(figSurf)
    end
    
end %for patidIdx

