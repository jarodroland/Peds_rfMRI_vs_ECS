function stimResults = GetStimMappingResults(patid)
% def data
% fxnMotor = {'Motor'};
% fxnSensory = {'Sensory'};
% fxnSpeech = {'Speech'};

% assign stimulation mapping results to electrodes
if(strcmp(patid, 'EP174'))
%     stimResults.Total      = 64;
    stimResults.Motor      = {'Main11'; 'Main15'; 'Main20'; 'Main21'; 'Main22'; 'Main23'; 'Main33'; 'Main34'; 'Main36'; 'Main37'; 'Main38'; ...
                              'Main41'; 'Main42'; 'Main43'; 'Main44'; 'Main45'; 'Main46'; 'Main49'; 'Main50'; 'Main51'; 'Main52'; 'Main53'; 'Main54'; 'Main55'; ...
                              'Main61'; 'Main62'; 'Main63'; 'Main14'; 'Main31'}; % stimulation at 1-4 milliamps in Grid (G) contacts 11, 15, 20-23, 33-34, 36-38, 41-46, 49-55, and 61-63 precipitated right finger, hand, and arm movements.
%     stimResults.Motor      = [11, 15, 20:23, 33:34, 36:38, 41:46, 49:55, 61:63]; % stimulation at 1-4 milliamps in Grid (G) contacts 11, 15, 20-23, 33-34, 36-38, 41-46, 49-55, and 61-63 precipitated right finger, hand, and arm movements.
%     stimResults.Motor      = [stimResults.Motor, 14, 31];    % contacts 14 and 31 at 4 milliamps precipitated contraction of the tongue.
    stimResults.Sensory    = {'Main57'; 'Main58'; 'Main59'; 'Main60'};  % contacts 57 and 58 at 2 milliamps precipitated a "feeling inside" his right arm. contacts 59 and 60 at 2-4 milliamps precipitated a sensation in his right shoulder and chest.
%     stimResults.Sensory    = 57:60;  % contacts 57 and 58 at 2 milliamps precipitated a "feeling inside" his right arm. contacts 59 and 60 at 2-4 milliamps precipitated a sensation in his right shoulder and chest.
    stimResults.Speech     = {'Main2'};     % high levels of stimulation (8 milliamps) on one contact (G) 2.

%     % Old Format
%     numElec = 64;
%     stimData = cell(numElec, 1);
%     stimData([11, 15, 20:23, 33:34, 36:38, 41:46, 49:55, 61:63]) = fxnMotor; % stimulation at 1-4 milliamps in Grid (G) contacts 11, 15, 20-23, 33-34, 36-38, 41-46, 49-55, and 61-63 precipitated right finger, hand, and arm movements.
%     stimData([14 31]) = fxnMotor;    % contacts 14 and 31 at 4 milliamps precipitated contraction of the tongue.
%     stimData(57:60) = fxnSensory;  % contacts 57 and 58 at 2 milliamps precipitated a "feeling inside" his right arm. contacts 59 and 60 at 2-4 milliamps precipitated a sensation in his right shoulder and chest.
%     stimData(2) = fxnSpeech;     % high levels of stimulation (8 milliamps) on one contact (G) 2.

elseif(strcmp(patid, 'EP175')) % All electrodes over the 64-contact grid, as well as the 8-contact lateral frontal grid, were stimulated. However, there were no consistent motor responses or other stereotypical findings upon stimulation of other electrodes on the grids.
    stimResults.Motor      = {}; 
    stimResults.Sensory    = {'Main61', 'Main62', 'Main63', 'Main64'}; % Over the region of the superior posterior aspect of the 64-contact grid (electrodes G61-G64), there appeared to be a consistent behavioral response in the patient where she would look at her hand, suggesting an area of sensory function for the left hand.
    stimResults.Speech     = {}; % 

elseif(strcmp(patid, 'EP176')) % grid only : Mapping was performed over the more anterior inferior aspect of an 8 x 8 grid over the left lateral temporal and perirolandic head regions.  Mapping was not performed from the three 1 x 6 subtemporal strips and a 1 x 6 posterior strip.
    stimResults.Motor      = {}; % No motor/sensory stimulation mapping performed
    stimResults.Sensory    = {}; % 
    stimResults.Speech     = {'Main26'; 'Main27'; 'Main28'}; % Unreliable - Sensations and language function was assessed by the ability to name objects on cards.  Of note, this was a suboptimal study due to the patient's difficulty in naming objects prior to electrocortical stimulation.  Responses were compared to previous neuropsychological evaluation in October of last year, with an apparent deterioration.  As such, the findings are deemed unreliable as we could only consistently use three cards for identification. 

elseif(strcmp(patid, 'EP178'))
    stimResults.Motor      = {'Main17'; 'Main18'; 'Main19'; 'Main20'; 'Main25'; 'Main26'; 'Main27'; 'Main28'; 'Main35'; 'Main36'; ...
                              'Main50'; 'Main51'; 'Main52'; 'Main53'; 'Main59'; 'Main60'; 'Main61' }; % 2-8 milliamps in Grid contacts 50-53 resulted in finger flexion and closure of the patient's left hand. 4-8 milliamps in Grid contacts 59-61 resulted in left arm adduction (59-60) and extension (60-61)
                              % 4-8 milliamps in Grid contacts 59-61 resulted in left arm adduction (59-60) and extension (60-61)
                              % 4-8 milliamps in Grid contacts 17, 18, 19, 20, 25, 26, 27, 28, 35, and 36 produced tongue withdrawal and sensations in the lower jaw and lips.
%     stimResults.Motor      = [stimResults.Motor, PIH2]; % 2-4 milliamps in PIH strip contact 2 resulted in a sudden left leg movement characterized by flexion at the knee.
%     stimResults.Motor      = [stimResults.Motor, AIH1:2]; % 2 milliamps at AIH 1-2 resulted in multijoint movements on his left side, and perhaps his whole body
    stimResults.Sensory    = {'Main63'; 'Main64'}; % 2 milliamps at G63-64 resulted in a report of leg/foot sensation.
    stimResults.Speech     = {}; % 
    % ?Eye Opening? - 1-4 milliamps produced eye opening and diffuse torso and trunk tingling in Grid contacts 1 through 16.
    % The lower part of the grid became more challenging to map, as the patient began to report sensations, and perform movements with sham stimulation (her heard the buzz, but no current was injected).
    
elseif(strcmp(patid, 'EP179'))
    stimResults.Motor      = {'Main1'; 'Main2'; 'Main3'; 'Main4'; 'Main5'; 'Main6'; 'Main9'; 'Main10'; 'Main11'; 'Main12'; 'Main13'; 'Main14'; ...
                              'Main18'; 'Main19'; 'Main20'; 'Main21'; 'Main22'; 'Main23'; 'Main26'; 'Main27'; 'Main28'; 'Main29'; 'Main30'; ... 
                              'Main31'; 'Main38'; 'Main39'; 'Main40'; 'Main46'; 'Main47'; 'Main48'; ...
                              'SP1'; 'SP2'; 'SP3'; 'SP4'}; % SP 3, 4 resulted in right foot movements.
    stimResults.Sensory    = {'Main7'; 'Main8'; 'Main15'; 'Main16'; 'Main24'; 'Main32'; ...
                              'SP5'; 'SP6'; 'PP5'; 'PP6'; ... % SP 5,6  and PP 5,6 resulted in an abnormal sensation in the right lower extremity
                              'AIH1'; 'AIH2'; 'AIH3'; 'AIH4'; 'AIH5'; 'AIH6'};  % 2 milliamps in contacts AIH 1, 2, 3,4 resulted in a sensation of bilateral lower extremity "tingling."
                                                                                % 2 milliamps in contacts AIH 4,5 resulted in left greater than right lower extremity "tingling" and in contacts AIH 5,6 resulted in left lower extremity "tingling".
                                                                                % 1 milliamp in contacts MIH 3,4 resulted in a sensation of left lower extremity "tingling."
    stimResults.Speech     = {'Main25'; 'Main17'}; % anomia: 2-4 milliamps in contacts G25, 17 resulted in the patient being unable to name pictures on standardized naming cards.
    stimResults.Vision     = {'Main1'; 'Main2'}; % 2 milliamps in contacts PP 1,2 resulted in a sensation of flashing lights.

elseif(strcmp(patid, 'EP180'))
    stimResults.Motor      = {'Main15'; 'Main16'; 'Main21'; 'Main22'; 'Main23'; 'Main24'; 'Main29'; 'Main30'; 'Main31'; 'Main32'; 'Main39'; 'Main40'; 'Main47'; 'Main48'; 'Main55'; 'Main56'};
%     stimResults.Motor      = [47, 48, 55, 56]; % eye deviation to the left were elicited at electrode pairs  55-56 and 47-48 at 6 mA
%     stimResults.Motor      = [stimResults.Motor, 55, 56]; % eye deviation to the left were elicited at electrode pairs  55-56 and 47-48 at 6 mA
%     stimResults.Motor      = [stimResults.Motor, 39, 40, 31, 32]; % At 39-40 at 4 mA the tongue and left face were activated with sensation in left thumb.  This same feeling and left face movement occurred at 31-32 at 6 mA.
%     stimResults.Motor      = [stimResults.Motor, 23, 24]; % At 23-24 at 2 mA the tongue deviated to the left.
%     stimResults.Motor      = [stimResults.Motor, 15, 16]; % At 15-16 at 2mA the tongue was drawn in.
%     stimResults.Motor      = [stimResults.Motor, 29, 30]; % At 29-30 at 8mA the eyes and jaw opened.
%     stimResults.Motor      = [stimResults.Motor, 21, 22]; % At 21-22 the left face moved at 2 mA.
%     stimResults.Motor      = [stimResults.Motor, 22, 23]; % At 22-23 the tongue deviated to the left at 2mA.
%     stimResults.Motor      = [stimResults.Motor, 30, 31]; % At 30-31 the left face moved with stimulation at 4 mA.
    stimResults.Sensory    = {}; % 
    stimResults.Speech     = {}; % No interruption of language function was noted by stimulation of electrodes 3-4, 5-6, 11-12, 19-20, 27-28, 35-36, 43-44, 51-52, 59-60, 1-2, 9-10, 17-18, 25-26, and 33-34 at 8 mA.

elseif(strcmp(patid, 'EP181')) % stimulate pairs of electrodes along a 64-contact subdural grid (G) that had been placed over the left lateral frontal lobe as well as two interhemispheric strips (AM, PM) over the left mesiofrontal lobe.
    stimResults.Motor      = {'Main45'; 'Main46'; 'Main53'; 'Main54'}; % 8 milliamps in grid contacts 45, 46 produced subtle pursing of the lips.
%     stimResults.Motor      = [stimResults.Motor, 53, 54]; % 8 milliamps in grid contacts 53, 54 produced subtle jerking movements of the jaw.
    stimResults.Sensory    = {}; % 
    stimResults.Speech     = {}; % 

elseif(strcmp(patid, 'EP182')) % Mapping was performed over the entirety of the intracranial placement, including an 8 x 8 grid placed over the left lateral frontal head region, two frontopolar 1 x 6 strips, two depth electrodes targeted at the area of suspected dysplasia, as well as a posterior horizontally oriented 1 x 6 strip extending over the parietal head region.
    stimResults.Motor      = {'Main15'; 'Main16'; 'Main39'; 'Main40'}; % pairs 15-16 causing right index finger flexion
%     stimResults.Motor      = [stimResults.Motor, 39, 40]; % pairs 39-40 causing tongue twitching and stuttering
    stimResults.Sensory    = {'Main53'; 'Main54'; 'Main55'; 'Main56'; 'Main61'; 'Main62'}; % Pairs 55-56 resulted in bilateral lower lip tingling.
%     stimResults.Sensory    = [stimResults.Sensory, 53, 54, 61, 62]; % For pairs 53-54, and 61-62, _'s left eye "pulled".
    stimResults.Speech     = {'Main13'; 'Main14'; 'Main47'; 'Main48'; 'Main63'; 'Main64'}; % pairs 47-48 causing anomia.  When questioned, Catlin stated that she knew the object on the card but "my tongue wouldn't move".
%     stimResults.Speech     = [stimResults.Speech, 13, 14]; % Pairs 13-14 caused expressive aphasia.
%     stimResults.Speech     = [stimResults.Speech, 63, 64]; % pairs 63-64, Catlin could not follow commands, as she did not appear to understand the instructions, consistent with receptive aphasia.  
    % strips:
%     stimResults.Motor      = [stimResults.Motor, FP1:2]; % frontopolar strips, electrode pairs 1-2 of the more superior strip resulted in left eye twitching.  
%     stimResults.Motor      = [stimResults.Motor, P5:6]; % parietal strip, the more proximal pairs of electrodes 5-6 caused the first 2 fingers of _'s right hand to twitch, 
    
elseif(strcmp(patid, 'EP183')) % his extraoperative cortical stimulation mapping was remarkable for a lack of any identification of eloquent cortex over the region of the left lateral temporal grid.
    stimResults.Motor      = {}; % completed over the temporal grid, without language, motor, or sensory localization.
    stimResults.Sensory    = {}; % 
    stimResults.Speech     = {}; % No language deficits were detected.

elseif(strcmp(patid, 'EP184')) % stimulate pairs of electrodes along a 64-contact subdural grid and seven 1 x 6 contact strips that had been placed over the right hemisphere
    stimResults.Motor      = {'Main46'; 'Main47'; 'Main48'; 'Main54'; 'Main55'; 'Main56'; 'Main63'; 'Main64'}; % 8-10 milliamps in grid contact pairs 47-48 (diffuse hand), 55-56 (index finger extension), 63-64 (diffuse hand), 46-47 (thumb twitching), and 54-55 (thumb twitching).
    stimResults.Sensory    = {'Main3'; 'Main4'; 'Main5'; 'Main6'}; % 2-4 milliamps and posterior interhemispheric (PIH) strip contact pairs 3-4 (leg and foot), 5-6 (thigh), and 4-5 (foot).
    stimResults.Speech     = {}; % 

elseif(strcmp(patid, 'EP185')) % Other electrode pairs that were mapped and did not stimulate a response included the remainder of the anterior three rows of electrode pairs, also including electrode pairs in the most posterior row, 1-2, 17-18, and 57-58.  Mapping was terminated at that time due to consistent precipitation of patient crying with stimulation.
    stimResults.Motor      = {'Main5'; 'Main6'; 'Main13'; 'Main14'}; % electrode pairs 5-6, including with repetitive stimulation, caused left arm internal rotation and flexion.
%     stimResults.Motor      = [stimResults.Motor, 13, 14]; % electrode pairs 13-14, immediately inferior to electrode pair 5-6, revealed wrist extension.
    stimResults.Sensory    = {}; % 
    stimResults.Speech     = {}; % 

elseif(strcmp(patid, 'EP186')) % only strips mapped, mesial right frontal grid not mapped
    stimResults.Motor      = {'RPI1'; 'RPI2'; 'RPI3'; 'RPI4'}; % RPI strip: contacts 1-2 at 3 milliamps led to left ankle dorsiflexion and left leg external rotation. strip contacts 2-3 at 4 milliamps led to left leg external rotation, left arm extension, and right shoulder movements. strip contacts 3-4 at 5 milliamps led to left leg internal rotation. strip contacts 4-5 and 5-6 at 8 milliamps led to no effect.
    stimResults.Sensory    = {'RPI3'}; % RPI strip contacts 3 resulted in a funny feeling, left lower extremity internal rotation, left upper extremity extension, and right shoulder movements indicating a location over the right supplementary motor cortex.
    stimResults.Speech     = {}; % stimulation did not interrupt language with stimulation of the right temporoparietal strips, though the electrode coverage was not dense over this region.
    % RMI contacts 1-2, LML contacts 1-2 and 3-4, and LPL contacts 1-2, 3-4, and 5-6 at 8 milliamps led to no effect on her ability to repeat words.

elseif(strcmp(patid, 'EP187')) % stimulate pairs of electrodes along a 60 contact subdural grid (G) and one 6 contact posterior subtemporal strip (PST) % G57 would have been the most superior and posterior contact but was removed along with its adjacent contacts (a 2x2 corner of the grid including G57, G58, G49, and G50) to allow the remainder of the 8x8 grid to fit within the dura.
                                % electrodes G 51-56 and 56-64 are labeled MainTopRows 1-6 & 7-12
    stimResults.Motor      = {'MainTopRows10'; 'MainTopRows11'; 'MainTopRows12'} ; % G62-64 identified that represented right hand motor. Stimulation of G63 and G64 and G63 and G62 but not G61 and G62 resulted in right fifth finger movement as well as a tingling sensation in the right 3-5 fingers.
    stimResults.Sensory    = {'MainTopRows7'; 'MainTopRows8'; 'MainTopRows9'; 'MainTopRows10'; 'MainTopRows5'; 'MainTopRows6'; 'Main47'; 'Main48'; 'Main37'; 'Main38'; 'Main39'; 'Main40'; 'Main41'; 'Main42'; 'Main33'; 'Main34'}; % Stimulation of the G59-62, G55-56, G47-48, G37-40, G41-42, G33-34 produced tingling sensation in the right hand and fingers.
    %     stimResults.Sensory    = [Main2_59, Main2_60, Main2_61, Main2_62, Main2_55, Main2_56, 47, 48, 37, 38, 39, 40, 41, 42, 33, 34]; % Stimulation of the G59-62, G55-56, G47-48, G37-40, G41-42, G33-34 produced tingling sensation in the right hand and fingers.
    stimResults.Speech     = {'Main30'; 'Main31'; 'Main32'; 'Main15'; 'Main16'}; % G32, G31, G30 and G16 and G15 resulted in anomia.
    stimResults.Vision     = {'Main3'; 'Main11'; 'Main18'; 'Main26'}; % G3/G11 and G18/26 pairs produced visual flashes, indicating visual cortex.

elseif(strcmp(patid, 'EP188'))
    stimResults.Motor      = {'Main5'; 'Main6'; 'Main7'; 'Main13'; 'Main14'; 'Main15'; 'Main20'; 'Main21'; 'Main22'; 'Main23'; 'Main30'; 'Main35'; 'Main36'}; % 2-4 milliamps in Grid contacts 6/7, 14/15, and 22/23 produced right hand movement.
%     stimResults.Motor      = [stimResults.Motor, 5, 13, 20, 21, 35, 36]; % 2-6 milliamps in Grid contacts 5/6, 13/14, 14/15, 20/ 21, 21/22, and 35/36 produced facial motor movements.
%     stimResults.Motor      = [stimResults.Motor, 30]; % 2 milliamps in Grid contacts 30/22 produced tongue movement.
    stimResults.Sensory    = {}; 
    stimResults.Speech     = {}; % No areas of speech/language production were identified

elseif(strcmp(patid, 'EP189'))
    stimResults.Motor      = {'RMI1'; 'RMI2'; 'RMI3'; 'RMI4'; ...
                              'AG6'; 'AG7'; 'AG11'; 'AG12'; 'AG13'; 'AG14'; 'AG16'; 'AG17'; ...
                              'PG1'; 'PG2'; 'PG3'; 'PG4'; 'PG6'; 'PG7'; 'PG8'; 'PG9'; 'PG11'; 'PG13'; 'PG18'};
%     stimResults.Motor      = [RMI1, RMI2]; % 1 milliamp in RMI1/2 resulted in knee flexion in the patient's left leg and no after-discharges.
%     stimResults.Motor      = [stimResults.Motor, RMI3, RMI4, PG6, PG11]; % RMI2-4, PG 6, PG 11 identified as leg sensation.
%     stimResults.Motor      = [stimResults.Motor, AG11, AG12]; % 2 milliamps in AG 11/12 produced left arm flexion
%     stimResults.Motor      = [stimResults.Motor, PG8, PG9]; % 2 milliamps in PG 8/9 resulted in left thumb movement
%     stimResults.Motor      = [stimResults.Motor, AG16, AG17]; % 2 milliamps in AG16/17 resulted in left shoulder movement
%     stimResults.Motor      = [stimResults.Motor, PG1, PG2]; % 1 milliamp in PG1/2 resulted in left shoulder movement
%     stimResults.Motor      = [stimResults.Motor, PG1, PG6]; % 2 milliamps in PG 1/6 resulted in left shoulder movement
%     stimResults.Motor      = [stimResults.Motor, PG6, PG7]; % 2 milliamps in PG 6/7 resulted in simultaneous "tickling" sensation in the patient's left shoulder and left shoulder movement
%     stimResults.Motor      = [stimResults.Motor, PG3, PG8]; % 2 milliamps in PG 3/8 resulted in left wrist movement
%     stimResults.Motor      = [stimResults.Motor, PG4, PG9]; % 4 milliamps of PG 4/9 resulted in left thumb movement
%     stimResults.Motor      = [stimResults.Motor, PG8, PG13]; % 2 milliamps of PG 8/13 resulted in left hand movement
%     stimResults.Motor      = [stimResults.Motor, PG13, PG18]; % 6 milliamps of PG 13/18 resulted in left index finger movement
%     stimResults.Motor      = [stimResults.Motor, AG6, AG7]; % 6 and 7 milliamps in AG 6/7 resulted in head movement to the right
%     stimResults.Motor      = [stimResults.Motor, AG13, AG14]; % 3 milliamps in AG 13/14 resulted in head and mouth movement to the left and after-discharges.

      stimResults.Sensory      = {'RMI2'; 'RMI3'; 'RMI4'; ...
                                'PG2'; 'PG3'; 'PG4'; 'PG6'; 'PG7'; 'PG11'; 'PG12'; 'PG13'; 'PG14'; 'PG16'; 'PG17'; ...
                                'AG15'; 'AG18'; 'AG19'; 'AG20'};
%     stimResults.Sensory      = [RMI2, RMI3]; % 1 milliamp in RMI2/3 resulted in a tingling sensation in the medial portion of the patient's lower left leg
%     stimResults.Sensory      = [stimResults.Sensory, RMI3, RMI4]; % RMI3/4 resulted in a tingling sensation in the anterior portion of the patient's lower left leg
%     stimResults.Sensory      = [stimResults.Sensory, PG6, PG11]; % 3 milliamps in PG6/11 resulted in a tingling sensation in the posterior portion of the patient's left upper leg
%     stimResults.Sensory      = [stimResults.Sensory, PG11, PG12, PG16, PG17]; % PG11-12, PG16-17 identified as sensation in the contralateral (right) leg.
%     stimResults.Sensory      = [stimResults.Sensory, PG11, PG16]; % 8 milliamps in PG11/16 resulted in tingling in the medial portion of the patient's right upper leg
%     stimResults.Sensory      = [stimResults.Sensory, PG12, PG17]; % 3 milliamps in PG12/17 resulted in tingling of the patient's right toes along and left trunk

%     stimResults.Sensory      = [stimResults.Sensory, AG18, AG19, AG15, AG20, PG2, PG3, PG4, PG6, PG7, PG13, PG14]; % AG 18-19, AG 15, AG 20, PG2-4, PG 6-7, PG 13-14) identified as left arm, hand, or shoulder sensation
                                    % 2 milliamps in AG 18/19 resulted in a vibration sensation in the patient's left finger and no after-discharges. 
                                    % Stimulation at 3 milliamps in AG 15/20 resulted in sensory changes in the patient's left thumb and after-discharges. Stimulation at 2 milliamps in PG 3/4 resulted in a tingling sensation in the patient's left fingers and no after-discharges. 
                                    % Stimulation at 2 milliamps in PG 6/7 resulted in simultaneous "tickling" sensation in the patient's left shoulder and left shoulder movement and no after-discharges. 
                                    % Stimulation at 2 milliamps in PG 13/14 resulted in a tingling sensation in the patient's left palm and fingers and no after-discharges. 
                                    % Stimulation at 1 milliamp in PG 2/7 resulted in a tingling sensation in the patient's left shoulder and no after-discharges.  
                                    % Stimulation in PG 7/12 resulted in a "tickling" sensation in the patient's left shoulder and arm and no after-discharges.
    stimResults.Speech     = {}; % 
    % Bedside somatosensory evoked potentials identified the central sulcus is located between the following contacts listed from superior to inferior:  PG7 and PG2; PG13 and PG8; AG19 and AG14; and AG20 and AG15.

elseif(strcmp(patid, 'EP190'))
    stimResults.Motor      = {'Main5'; 'Main6'; 'Main7'; 'Main8'; 'Main13'; 'Main14'; 'Main15'; 'Main16'; 'Main23'; 'Main24'; 'Main31'; 'FR1'; 'FR2'; 'FR3'; 'FR4'; 'FR5'};
%     stimResults.Motor      = [8 16]; % 2 milliamps in grid contacts 8 and 16 (G8/G16) resulted in right facial movement 
%     stimResults.Motor      = [stimResults.Motor, 24]; % 3-4 milliamps in Grid contacts 16 and 24 resulted in right facial twitching
%     stimResults.Motor      = [stimResults.Motor, 7, 15]; % 2 milliamps in Grid contacts 7 and 15 resulted in right facial twitching
%     stimResults.Motor      = [stimResults.Motor, 23]; % 2 milliamps in Grid contacts 23 and 15 resulted in right facial twitching
%     stimResults.Motor      = [stimResults.Motor, 6, 14]; % 4 milliamps in Grid contacts 6 and 14 resulted in right facial twitching that progressed to a right focal motor seizure of the right lower face
%     stimResults.Motor      = [stimResults.Motor, 31]; % 4 milliamps with grid contacts 23 and 31 resulted in tongue movement
%     stimResults.Motor      = [stimResults.Motor, 5, 13]; % G5 and G13 resulted in tongue movement and sensation.
%     stimResults.Motor      = [stimResults.Motor, FR1, FR2]; % 2 milliamps in the frontal strip contacts 1 and 2 (FR1/FR2) resulted in head turning to the right
%     stimResults.Motor      = [stimResults.Motor, FR3, FR4]; % 2-4 milliamps in the frontal strip contacts 3 and 4 (FR3/FR4) resulted in right hand and arm pulling upwards
%     stimResults.Motor      = [stimResults.Motor, FR4, FR5]; % 2 milliamps in the frontal strip contacts 4 and 5 (FR4/FR5) resulted in right hand clasping and thumb flexion
    stimResults.Sensory    = {'Main4'; 'Main12'; 'Main24'; 'Main32'; 'FR5'; 'FR6'};
%     stimResults.Sensory    = [24, 32]; % 4 milliamps in grid contacts 24 and 32 (G24/32) resulted in a painful sensory sensation in the right hand and palm
%     stimResults.Sensory    = [stimResults.Sensory, 4, 12]; % 6 milliamps with grid contacts 4 and 12 resulted in a sensation in his mouth
%     stimResults.Sensory    = [stimResults.Sensory, FR5, FR6]; % 1-2 milliamps in the frontal strip contacts 5 and 6 (FR5/FR6) resulted in a painful sensory sensation in the right hand and palm.
    stimResults.Speech     = {'Main20'; 'Main28'}; % 1-6 milliamps with grid contacts 20 and 28 resulted in a speech arrest with multiple attempts
%     stimResults.Speech     = [20, 28]; % 1-6 milliamps with grid contacts 20 and 28 resulted in a speech arrest with multiple attempts
    % 49 and 57 resulted in right facial twitching and after discharges.  Of note, repeat stimulation on the second day of mapping with Grid contacts 49 and 57 did not result in any apparent clinical response.

elseif(strcmp(patid, 'EP191')) % pairs of electrodes stimulated included grid electrodes G3 and G4, G4 and G5, G7 and G8, G12 and G13, G15 and G16, G20 and G21, G21 and 22, G23 and G24, G27 and G28, G28 and G29, G35 and G36, G36 and G37, G40 and G41, G41 and G42.
    stimResults.Motor      = {'Main4'; 'Main5'; 'Main7'; 'Main8'; 'Main12'; 'Main13'; 'Main14'; 'Main15'; 'Main16'; 'Main21'; 'Main22'; 'Main23'; 'Main24'; ...
                              'Main28'; 'Main29'; 'Main36'; 'Main37'; 'Main43'; 'Main44'};
%     stimResults.Motor      = [4, 5]; % Movement of the right hand and flexion of the right bicep occurred with stimulation of G4 and G5 at 4 mA, as well as at 5 mA
%     stimResults.Motor      = [stimResults.Motor, 7, 8]; % rotation of the right shoulder occurred with stimulation of G7 and G8 at 6 mA
%     stimResults.Motor      = [stimResults.Motor, 12, 13]; % Flexion of the right arm and movement of the right hand occurred with stimulation of G12 and G13 at 3mA
%     stimResults.Motor      = [stimResults.Motor, 15, 16]; % Extension of the right wrist and movement of the hand occurred with stimulation of G15 and G16 at 6 mA
%     stimResults.Motor      = [stimResults.Motor, 21, 22]; % Movement of the right hand occurred with stimulation of G21 and G22 at 3 mA.
%     stimResults.Motor      = [stimResults.Motor, 23, 24]; % Movement of the right hand and flexion of the right arm occurred with stimulation of G23 and G24 at 10 mA.
%     stimResults.Motor      = [stimResults.Motor, 28, 29]; % Movement of the mouth occurred with stimulation of G28 and G29 at 7 mA.  
%     stimResults.Motor      = [stimResults.Motor, 36, 37]; % Protrusion of the tongue occurred with stimulation of G36 and G37 at 6 mA.
%     stimResults.Motor      = [stimResults.Motor, 43, 44]; % Chewing movements occurred with stimulation of G43 and G44 at 5 mA.
%     stimResults.Motor      = [stimResults.Motor, 13, 14]; % Movement of the right hand and fingers occurred with stimulation of G13 and G14 at 3 mA
    stimResults.Sensory    = {}; % 
    stimResults.Speech     = {}; % 

elseif(strcmp(patid, 'EP192')) % Nihon Kohden PE210 system.  
    % G 3-8 and 11-16 -> MainBot 1-6 and 7-12
    % G 17-64 -> MainTop 1-48
    stimResults.Motor      = {'MainBot7'; 'MainBot8'; ...
                              'MainTop11'; 'MainTop12'; 'MainTop13'; 'MainTop14'; 'MainTop19'; 'MainTop20'; 'MainTop21'; 'MainTop22'; 'MainTop27'; 'MainTop28'; 'MainTop29'; ...
                              'MainTop30'; 'MainTop31'; 'MainTop32'; 'MainTop35'; 'MainTop36'; 'MainTop37'; 'MainTop38'; 'MainTop44'; 'MainTop45'; 'MainTop46'; 'MainTop47'; ...
                              'AH1'; 'AH2'; 'AH3'};
%     stimResults.Motor      = [61, 62]; % Head tilt to the left occurred with stimulation of G62 and G61 at 8 mA.
%     stimResults.Motor      = [stimResults.Motor, 53, 54]; % Flexion of the left arm and movement of the left hand occurred with stimulation of G54 and G53 at 4 mA.
%     stimResults.Motor      = [stimResults.Motor, 45, 46]; % Left third digit extension occurred with stimulation of G46 and G45 at 3 mA.
%     stimResults.Motor      = [stimResults.Motor, 37, 38]; % Flexion of the left thumb occurred with stimulation of G38 and G37 at 2 mA.
%     stimResults.Motor      = [stimResults.Motor, 29, 30]; % Perioral movement of the face occurred with stimulation of G30 and G29 at 4 mA.
%     stimResults.Motor      = [stimResults.Motor, 51, 52]; % Movement of the left thumb, flexion of the left wrist and flexion of the left bicep occurred with stimulation of G52 and G51 at 3 mA.
%     stimResults.Motor      = [stimResults.Motor, 43, 44]; % Movement of the left greater than right eyelid occurred with stimulation of G44 and G43 at 6 mA.
%     stimResults.Motor      = [stimResults.Motor, 35, 36]; % Movement of the mouth occurred with stimulation of G36 and G35 at 5 mA.
%     stimResults.Motor      = [stimResults.Motor, 27, 28]; % Movement of the lips occurred with stimulation of G28 and G27 at 3 mA and with stimulation of G20 and G19 at 7 mA.
%     stimResults.Motor      = [stimResults.Motor, 11, 12]; % Movement of the chin occurred with stimulation of G12 and G11 at 6 mA.
%     stimResults.Motor      = [stimResults.Motor, 47, 48]; % Flexion of the left 5th digit occurred with stimulation of G48 and G47 at 8 mA.
%     stimResults.Motor      = [stimResults.Motor, 60, 61]; % Abduction of the left arm occurred with stimulation of G61 and G60 at 8 mA.
%     stimResults.Motor      = [stimResults.Motor, 62, 63]; % Head turning to the right occurred with stimulation of G63 and G62 at 7 mA.
%     stimResults.Motor      = [stimResults.Motor, AH1, AH2, AH3]; % Movement of the face occurred with stimulation of AH 2 and AH1 at 5 mA. Movement of the face occurred with stimulation of AH3 and AH2 at 5 mA.
    stimResults.Sensory    = {}; % 
    stimResults.Speech     = {}; % 

elseif(strcmp(patid, 'EP193')) % Nihon Kohden PE210 system. 
    stimResults.Motor      = {'LG1'; 'LG2'; 'LG6'; 'LG7'; 'LG8'; 'LG11'; 'LG12'; 'LG13'; 'LG16'; 'LG17'; 'LG18'; ...
                              'IHG2'; 'IHG6'; 'IHG7'; 'IHG8'; 'IHG9'; 'IHG10'; 'IHG11'; 'IHG12'; 'IHG13'; 'IHG14'; 'IHG15'; 'IHG16'; 'IHG17'; 'IHG18'; 'IHG19'; ... 
                              'PIH1'; 'PIH2'; 'PIH3'; 'PIH4'};
%     stimResults.Motor      = [1, 2]; % Right arm movement occurred with stimulation of LG2 and LG1 at 6mA.
%     stimResults.Motor      = [stimResults.Motor, 6, 7, 8]; % Right finger extension occurred with stimulation of LG8 and LG7 at 5mA. Right finger flexion occurred with stimulation of LG7 and LG6 at 3mA.
%     stimResults.Motor      = [stimResults.Motor, 11, 12, 13]; % Right index finger movement occurred with stimulation of LG13 and LG12 at 2mA and LG12 and LG11 at 2mA.
%     stimResults.Motor      = [stimResults.Motor, 16, 17, 18]; % Right thumb and index finger movement occurred with stimulation of LG18 and LG17 at 4mA. Right thumb movement occurred with stimulation of LG17 and LG16 at 3mA.
%     stimResults.Motor      = [stimResults.Motor, IHG9, IHG10]; % Right foot movement occurred with stimulation of IHG9 and IHG10 at 5mA
%     stimResults.Motor      = [stimResults.Motor, IHG14, IHG15]; % Right foot movement occurred with stimulation of IHG14 and IHG15 at 1mA
%     stimResults.Motor      = [stimResults.Motor, PIH3, PIH4]; % Right foot movement occurred at PIH4 and PIH3 at 7mA
%     stimResults.Motor      = [stimResults.Motor, IHG11, IHG12]; % Right leg movement occurred with stimulation of IHG11 and IHG12 at 4mA.
%     stimResults.Motor      = [stimResults.Motor, IHG7, IHG8]; % Right leg movement occurred with stimulation of IHG7 and IHG8 at 4mA
%     stimResults.Motor      = [stimResults.Motor, IHG12, IHG13]; % Right leg movement occurred with stimulation of IHG12 and IHG13 at 4mA
%     stimResults.Motor      = [stimResults.Motor, PIH2, PIH3, PIH4]; % Right leg movement occurred with stimulation of PIH3 and PIH2 at 6mA. Right leg movement occurred with stimulation of PIH3 and PIH4 at 8mA
%     stimResults.Motor      = [stimResults.Motor, IHG16, IHG17]; % Right shoulder and arm movement occurred with stimulation of IHG17 and IHG16 at 3mA.
%     stimResults.Motor      = [stimResults.Motor, PIH1]; % Right foot movement occurred with stimulation of PIH1 and PIH2 at 8mA
%     stimResults.Motor      = [stimResults.Motor, IHG17, IHG18, IHG19]; % Right foot movement occurred with stimulation of IHG18 and IHG19 at 2mA. Right foot movement occurred with stimulation of IHG17 and IHG18 at 2mA.
%     stimResults.Motor      = [stimResults.Motor, IHG8, IHG9]; % Right leg movement occurred with stimulation at IHG8 and IHG9 at 3mA
%     stimResults.Motor      = [stimResults.Motor, IHG6, IHG7]; % Right shoulder and arm motor: Right arm and shoulder movement occurred with stimulation of IHG6 and IHG7 at 7mA. Right shoulder movement occurred with stimulation of IHG7 and IHG8
%     stimResults.Motor      = [stimResults.Motor, IHG2]; % Right shoulder movement occurred with stimulation of IHG2 and IHG7 at 7mA

    stimResults.Sensory    = {'LG2'; 'LG3'; 'LG4'; 'LG5'; 'LG7'; 'LG8'; 'LG9'; 'LG10'; ...
                              'IHG7'; 'IHG8'; 'IHG9'; 'IHG10'; 'IHG11'; 'IHG12'; 'IHG13'; 'IHG14'; 'IHG15'; 'IHG16'; 'IHG19'; 'IHG20'};
%     stimResults.Sensory    = [2, 3, 4, 5]; % Right leg numbness occurred with stimulation of LG5 and LG4 at 4mA. Right leg numbness occurred with stimulation of LG4 and LG3 at 4mA. Right shoulder numbness occurred with stimulation of LG3 and LG2 at 6mA.
%     stimResults.Sensory    = [stimResults.Sensory, 9, 10]; % Right hand numbness occurred with stimulation of LG10 and LG9 at 4mA.
%     stimResults.Sensory    = [stimResults.Sensory, 7, 8]; % Right hand numbness occurred with stimulation of LG8 and LG7 at 4mA.
%     stimResults.Sensory    = [stimResults.Sensory, IHG14, IGH15]; % Right foot (sole) numbness occurred with simulation of IHG14 and IHG15 at 2mA.
%     stimResults.Sensory    = [stimResults.Sensory, IHG7, IHG8]; % Right leg numbness occurred with stimulation of IHG7 and IHG8 at 3mA.
%     stimResults.Sensory    = [stimResults.Sensory, IHG19, IHG20]; % Right leg numbness occurred with stimulation of IHG20 and IHG19 at 3mA.
%     stimResults.Sensory    = [stimResults.Sensory, IHG11, IHG12]; % Right lateral leg numbness occurred with stimulation of IHG12 and IHG11 at 3mA. Right leg numbness occurred with stimulation of IGH11 and IHG12 at 4mA.
%     stimResults.Sensory    = [stimResults.Sensory, IHG9, IHG10]; % Right leg numbness from the foot up to the leg occurred with stimulation of IHG9 and IHG10 at 5mA. 
%     stimResults.Sensory    = [stimResults.Sensory, IHG13, IHG14, IHG15]; % Right foot (sole) numbness occurred with stimulation of IHG13 and IHG14 at 2mA. Right foot (sole) numbness occurred with stimulation of IHG14 and IHG15 at 2mA
%     stimResults.Sensory    = [stimResults.Sensory, IHG16]; % The patient reported right arm "symptoms," which was interpreted as numbness, with stimulation of IHG11 and IHG16 at 4mA and IHG7 and IHG12 at 4mA.

    stimResults.Speech     = {}; % 
    % Motor representation of the right foot and leg lies under IHG7, IHG8, IHG9, IHG10, IHG11, IHG12, IHG13, IHG14, IHG15, and PIH2.
    % Motor representation of the right shoulder and arm lies under IHG16, IHG17, LG1, and LG2.
    % Motor representation of the right hand including finger and thumb movement lies under LG6, LG7, LG12, LG13, LG16, LG17, and LG18.
    % A positive sensory response occurred in the right foot and leg with stimulation of IHG7, IHG11, IHG12, IHG14, IHG15, IHG19, IHG20, LG3, LG4, and LG5.
    % A positive sensory response occurred in the right shoulder under LG3 and right hand at LG7, LG8, LG9, and LG10.
    % Motor representation of the right foot and leg lies under PIH1, PIH2, PIH3, PIH4, IHG8, IHG9, IHG17, IHG18, and IHG19.
    % A positive sensory response occurred in the right foot and leg with stimulation of IHG9, IHG10, IHG13, IHG14, and IHG5.
    % Motor representation of the right shoulder and arm lies under IHG6, IHG7, IHG8, IHG11, IHG12, IHG16, and IHG17.
    % Complex and atypical motor movements of the right arm, leg, and trunk occurred with stimulation of IHG3, IHG8, IHG11, IHG12, and IHG13.
    
elseif(strcmp(patid, 'EP194')) % Nihon Kohden PE210 system.  The following pairs of electrodes were stimulated: G43 and G44, G51 and G52, G59 and G60, G45 and G46, G53 and G54, G61 and G62, G37 and G38, G60 and G61.
    % G 1-6 & 9-14 -> MainTop 1-6 & 7-12; G 17-64 -> MainBottom 1-48
    stimResults.Motor      = {}; % 
    stimResults.Sensory    = {}; % 
    stimResults.Speech     = {}; % 
    stimResults.Vision     = {'MainBottom44'; 'MainBottom45'};
%     stimResults.Vision     = [60, 61]; % Cortical visual representation lies under G60 and G61. stimulation of G60 and G61, the patient had a pause in reading, which he attributed to blurry vision. He had more difficulty with words on the right side of the page, though he could recognize letters.  No abrupt changes of pure letter blindness were present.
    % All other electrode pairs produced no response with currents up to 8mA.

elseif(strcmp(patid, 'EP195')) %Nihon Kohden PE210 
    stimResults.Motor      = {'Main7'; 'Main8'; 'Main15'; 'Main16'; 'LF1'; 'LF2'; 'LF3'; 'LF4'; 'LF6'; 'LF7'; 'LF8'; 'LF9'};
%     stimResults.Motor      = [16, 8]; % Rightward tongue movement and the sensation of tingling occurred with stimulation of G16 and G8 at 4mA.
%     stimResults.Motor      = [stimResults.Motor, 15, 7]; % Tongue movement and the sensation of tingling occurred with stimulation of G15 and G7
% %     stimResults.Motor      = [stimResults.Motor, LF1, LF2]; % Right face movement occurred with stimulation of LF1 and LF2 at 6mA
%     stimResults.Motor      = [stimResults.Motor, LF3, LF4, LF6, LF7, LF8, LF9]; % Mouth movement occurred with stimulation of LF3 and LF4 at 2mA, LF6 and LF7 at 4mA, and LF8 and LF9 at 2mA
    stimResults.Sensory    = {'Main7'; 'Main8'; 'Main14'; 'Main15'; 'Main16'};
%     stimResults.Sensory    = [stimResults.Sensory, 14, 15, 16]; % Tongue tingling occurred with stimulation of G15 and G16 at 4mA. Tongue tingling involving the right side occurred with stimulation of G15 and G14 at 4mA.
%     stimResults.Sensory    = [stimResults.Sensory, 7, 8]; % throat sensation with stimulation of G8 and G7 at 4mA.
%     stimResults.Sensory    = [stimResults.Sensory, ]; % 
%     stimResults.Sensory    = [stimResults.Sensory, ]; % 
%     stimResults.Sensory    = [stimResults.Sensory, ]; % 
    stimResults.Speech     = {'Main1'; 'Main9'; 'PST9'; 'PST10'; 'PST4'; 'PST5'};
%     stimResults.Speech     = [1, 9]; % A pause in object naming occurred with stimulation of G9 and G1 at 4mA
%     stimResults.Speech     = [stimResults.Speech, PST9, PST10, PST4, PST5]; % A pause in object naming occurred with stimulation of PST10 and PST9 at 8mA, PST4 and PST5 at 6mA, PST10 and PST5 at 4mA, PST9 and PST4 at 8mA, and G9 and G1 at 4mA
    % Motor representation of the face, mouth, and tongue lies under LF1, LF2, LF3, LF4, LF6, LF7, LF8, LF9, G7, and G15.
    % Sensory representation of the tongue and throat lies under G15, G16, G7, and G8.
    % Expressive language function lies under PST4, PST5, PST9, and PST10.
    % Sensory representation of the tongue lies under G14 and G15. No expressive or receptive language function was identified.
    % Sensory representation of the tongue was also found in the anterior superior portion of the grid (G), particularly in contacts G8, G15, and G16.
    % Expressive language function was found in the superior portion of the posterior subtemporal (PST) grid, particularly in contacts G4, G5, G9, and G10.
    % The facial tingling that occurred with stimulation of the inferior posterior portion of the grid (G) was most likely non-cortical in origin, and most likely represented stimulation of the facial nerve.  -  stimResults.Sensory    = [stimResults.Sensory, 17, 18, 25]; % Right face tingling occurred with stimulation of G25 and G17 at 4mA. Right face tingling occurred with stimulation of G17 and G18 at 4mA, 6mA, and 8mA.

else
    error(['Error: Unknown patid: ' patid]);
end

end