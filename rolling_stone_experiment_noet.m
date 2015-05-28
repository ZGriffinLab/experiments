% Rolling Stone - main experiment script
%
% Authors: Ariel Sibille and Rhoda Jiao
%
%created hevily referencing EyelinkPicture.m, the METS program, and Calzone
%

% import lab's custom package
import cog_comm_tools.*;
import custom.*;

% font settings
fontFace = 'Arial';
fontSize = 30;
fontStyle = 1;

%screen resolution for running on the eyetracker computer
screenResolution = [1152 864];


% EXPERIMENTAL CONSTANTS

%default voicekey threshold
vk = .1;

interStimuliInterval = 1.0;

%length of time given for subject to speak
speakingTimeOut = 10;

%delay timer
dt = 0.5;

%calibration
commandwindow;

dummymode = 0;
% experiment block
try
    % SETUP EXPERIMENT
    initializeAudioExperiment();
    initializeExperiment();
    
    %get list of audio devices
    devices = PsychPortAudio('GetDevices');
     
    % initialize the window
    [window, resolution] = initializeWindow(fontFace, fontSize, fontStyle, screenResolution);
    width = resolution.width;
    height = resolution.height;
    
    % get participant information
    participantId = initializeParticipant(window);
    
    % multiple choice question to determine counterbalance group
    %1: Left, exp group 1
    %2: Left, exp group 2
    %3: Right, exp group 1
    %4: Right, exp group 2
    choiceList = [Choice('1!',1) Choice('2@',2) Choice('3#',3) Choice('4$',4)];
    counterbalanceGroup = multipleChoiceDialog(window, 'Enter counterbalance group:', choiceList);
    
    % LOADING STIMULI
    
    % loading all these stimuli will take awhile
    displayTextCentered(window, 'Initializing ...');
    
    %stimuli loading optimized for readability
    
    % load audio stimuli
    %stimulus map for neutral statements for the experimental stimuli
    NExpStimMap = containers.Map();
    
    %stimulus map for biased statements for the experimental stimuli
    BExpStimMap = containers.Map();
    
    %stimulus map for true statements for the neutral stimuli
    YNeutStimMap = containers.Map();
    
    %stimulus map for false statements for the neutral stimuli
    NNeutStimMap = containers.Map();
    
    % stimulus map for left experimental pictures
    LeftVisMap = containers.Map();
    
    %stimulus map for right experimental pictures
    RightVisMap = containers.Map();
    
    %stimulus map for neutral pictures
    NeutVisMap = containers.Map();
    
    %hardcoded TODO
    midX = round(width / 2);
    yPos = round(height / 3);
    
    %load experimental stimuli
    for i=1:30,
        key = sprintf('c%02d', i);
        %load neutral audio questions
        file = sprintf('stimuli/audio/%s_n.wav', key);
        NExpStimMap(key) = AudioStim(key, file);
        %load left images
        file = sprintf('stimuli/visual/%sl.jpg', key);
        LeftVisMap(key) = ImageStim(key, file, midX, yPos, key);
        %load right images
        file = sprintf('stimuli/visual/%sr.jpg', key);
        RightVisMap(key) = ImageStim(key, file, midX, yPos, key);
    end 
    
    %load biased audio stimuli for experimental pictures
    %these aren't in a loop because of they weren't regularly split into
    %do/pp
    BExpStimMap('c01') = AudioStim('c01', 'stimuli/audio/c01_pp.wav');
    BExpStimMap('c02') = AudioStim('c02', 'stimuli/audio/c02_pp.wav');
    BExpStimMap('c03') = AudioStim('c03', 'stimuli/audio/c03_do.wav'); 
    BExpStimMap('c04') = AudioStim('c04', 'stimuli/audio/c04_pp.wav');
    BExpStimMap('c05') = AudioStim('c05', 'stimuli/audio/c05_pp.wav');
    BExpStimMap('c06') = AudioStim('c06', 'stimuli/audio/c06_pp.wav');   
    BExpStimMap('c07') = AudioStim('c01', 'stimuli/audio/c07_pp.wav');
    BExpStimMap('c08') = AudioStim('c08', 'stimuli/audio/c08_do.wav');
    BExpStimMap('c09') = AudioStim('c09', 'stimuli/audio/c09_do.wav');
    BExpStimMap('c10') = AudioStim('c10', 'stimuli/audio/c10_pp.wav');
    BExpStimMap('c11') = AudioStim('c11', 'stimuli/audio/c11_pp.wav');
    BExpStimMap('c12') = AudioStim('c12', 'stimuli/audio/c12_do.wav');
    BExpStimMap('c13') = AudioStim('c13', 'stimuli/audio/c13_do.wav');
    BExpStimMap('c14') = AudioStim('c14', 'stimuli/audio/c14_do.wav');
    BExpStimMap('c15') = AudioStim('c15', 'stimuli/audio/c15_pp.wav');   
    BExpStimMap('c16') = AudioStim('c16', 'stimuli/audio/c16_pp.wav');
    BExpStimMap('c17') = AudioStim('c17', 'stimuli/audio/c17_do.wav');
    BExpStimMap('c18') = AudioStim('c18', 'stimuli/audio/c18_pp.wav');
    BExpStimMap('c19') = AudioStim('c19', 'stimuli/audio/c19_do.wav');
    BExpStimMap('c20') = AudioStim('c20', 'stimuli/audio/c20_pp.wav');  
    BExpStimMap('c21') = AudioStim('c21', 'stimuli/audio/c21_do.wav');
    BExpStimMap('c22') = AudioStim('c22', 'stimuli/audio/c22_do.wav');
    BExpStimMap('c23') = AudioStim('c23', 'stimuli/audio/c23_do.wav');
    BExpStimMap('c24') = AudioStim('c24', 'stimuli/audio/c24_do.wav');
    BExpStimMap('c25') = AudioStim('c25', 'stimuli/audio/c25_do.wav');
    BExpStimMap('c26') = AudioStim('c26', 'stimuli/audio/c26_do.wav');
    BExpStimMap('c27') = AudioStim('c27', 'stimuli/audio/c27_pp.wav');
    BExpStimMap('c28') = AudioStim('c28', 'stimuli/audio/c28_pp.wav');
    BExpStimMap('c29') = AudioStim('c29', 'stimuli/audio/c29_do.wav');
    BExpStimMap('c30') = AudioStim('c30', 'stimuli/audio/c30_pp.wav');
    
 
    %loading neutral stimuli
    for i=1:38,
        key = sprintf('f%02d', i);
        file = sprintf('stimuli/audio/%s_n.wav', key);
        NNeutStimMap(key) = AudioStim(key, file);
        file = sprintf('stimuli/audio/%s_y.wav', key);
        YNeutStimMap(key) = AudioStim(key, file);
        file = sprintf('stimuli/visual/%s.jpg', key);
        NeutVisMap(key) = ImageStim(key, file, midX, yPos, key);
    end    
    
    %create an array of the neutral stimuli keys
    neutStims = {'f01', 'f02', 'f03', 'f04', 'f05', 'f06', 'f07', 'f08', 'f09', 'f10', 'f11', 'f12', 'f13', 'f14', 'f15', 'f16', 'f17', 'f18', 'f20', 'f21', 'f22', 'f23', 'f24', 'f25', 'f26', 'f27', 'f28', 'f29', 'f30', 'f34'};
    
    %creates an array of the practice stimuli out of the remaining neutral
    %stimuli
    testStims = {'f32', 'f33', 'f35', 'f36', 'f37', 'f38'};
    
    %create an audio stimulus map for the test stimuli
    testStimsMap = containers.Map();
    
    %fill audio stimulus map for test stimuli
    for i = 1:length(testStims);
        %add yes questions to map
        key = sprintf('%sy', testStims{1,i});
        testStimsMap(key) = YNeutStimMap(testStims{1,i});
    end
    
    for i = 1:length(testStims);
        %add no questions to map
        key = sprintf('%sn', testStims{1,i});
        testStimsMap(key) = NNeutStimMap(testStims{1,i});
    end
    
    %yeses and nos hardcoded
    testStims = {'f32y', 'f33n', 'f35y', 'f36n', 'f37y', 'f38n'};
    
    %create the audio and visual stimulus maps
    audStimsMap = containers.Map();
    vizStimsMap = containers.Map();
    
    %put the yes and no questions for the neutral images into the audio
    %stimulus map
    for i = 1:30;
        key = sprintf('%sy', neutStims{1,i});
        audStimsMap(key) = YNeutStimMap(neutStims{1,i});
        key = sprintf('%sn', neutStims{1,i});
        audStimsMap(key) = NNeutStimMap(neutStims{1,i});
    end
       
       
    %create arrays for the experimental keys for the counterbalance groups
    expGroup1 = {'c19', 'c22', 'c23', 'c21', 'c29', 'c26', 'c08', 'c12', 'c10', 'c05', 'c07', 'c15', 'c18', 'c02', 'c30'};
    
    expGroup2 = {'c14', 'c17', 'c13', 'c03', 'c25', 'c24', 'c09', 'c01', 'c20', 'c11', 'c04', 'c28', 'c16', 'c27', 'c06'};
    
    
    %adds the experimental audio stimuli to the audio map according to the
    %counterbalance group
    for i=1:length(expGroup1),
        %for groups 1 or 3 add biased questions for counterbalance group 1
        if (counterbalanceGroup == 1 || counterbalanceGroup == 3)
            audStimsMap(expGroup1{1, i}) = BExpStimMap(expGroup1{1, i});
        else
        %for groups 2 or 4 add neutral questions for counterbalance group 1    
            audStimsMap(expGroup1{1,i}) = NExpStimMap(expGroup1{1, i});
        end
    end
    for i = 1:length(expGroup2),
        %for groups 1 or 3 add neutral questions for counterbalance group 2
        if (counterbalanceGroup == 1 || counterbalanceGroup == 3)
            audStimsMap(expGroup2{1, i}) = NExpStimMap(expGroup2{1, i});
        else
        %for groups 2 or 4 add biased questions for counterbalance group 2
            audStimsMap(expGroup2{1, i}) = BExpStimMap(expGroup2{1, i});
        end
    end
    
    %load neutral audio stimuli into the audio map
    for i=1:length(neutStims),
        key = sprintf('%sy', neutStims{1, i});
        audStimsMap(key) = YNeutStimMap(neutStims{1, i});
        key = sprintf('%sn', neutStims{1, i});
        audStimsMap(key) = NNeutStimMap(neutStims{1, i});
    end
    
    %load the experimental visual stimuli into the audio map according to
    %the counterbalance group
    for i=1:length(expGroup1),
        %if in counterbalance group 1 or 2, use left visual stimuli
        if(counterbalanceGroup == 1 || counterbalanceGroup == 2)
            vizStimsMap(expGroup1{1, i}) = LeftVisMap(expGroup1{1, i});
            vizStimsMap(expGroup2{1, i}) = LeftVisMap(expGroup2{1, i});
        else
        %if in counterbalance group 3 or 4, use right visual stimuli
            vizStimsMap(expGroup1{1, i}) = RightVisMap(expGroup1{1, i});
            vizStimsMap(expGroup2{1, i}) = RightVisMap(expGroup2{1, i});
        end
    end
    
    %load all neutral visual stimuli into the visual stimulus map
    for i=1:length(neutStims),
        vizStimsMap(neutStims{1, i}) = NeutVisMap(neutStims{1, i}); 
    end
    
    %creates an array of the list of all of the keys for the experimental
    %groups and the neutral stimuli (both yes and no questions) to be used
    %to determine the order of the stimuli in the experiment
    
    stimOrder =  {'f17y', 'f15n', 'c03', 'f11y', 'f34y', 'c30', 'f14n', 'f17n', 'c26', 'f16n', 'f07y', 'c15', 'f30n', 'f23n', 'c21'...
                  'f04y', 'f10y', 'c02', 'f18n', 'f21n', 'c13', 'f24y', 'f27y', 'c29', 'f24n', 'f13n', 'c11', 'f11n', 'f03y', 'c28'...
                  'f25y', 'f08n', 'c04', 'f22n', 'f30y', 'c05', 'f29y', 'f06y', 'c20', 'f18y', 'f08y', 'c14', 'f04n', 'f12y', 'c22'... 
                  'f26y', 'f09n', 'c25', 'f01n', 'f23y', 'c18', 'f16y', 'f07n', 'c01', 'f28y', 'f02n', 'c07', 'f19n', 'f12n', 'c10'... 
                  'f06n', 'f10n', 'c09', 'f02y', 'f21y', 'c24', 'f01y', 'f20n', 'c19', 'f27n', 'f13y', 'c16', 'f14y', 'f15y', 'c06'...
                  'f05n', 'f20y', 'c17', 'f03n', 'f22y', 'c08', 'f29n', 'f05y', 'c12', 'f25n', 'f09y', 'c23', 'f26n', 'f28n', 'c27'};
    
    % set up data files
    stimandOrder = TDFLog(['participants/' participantId '/' participantId '_rs_stimandOrder.txt'], true);
    expData = TDFLog(['participants/' participantId '/' participantId '_rs_exp_data.txt'], true);
    
    % define column labels for stimuli and order file
    %setup of datafiles 
    stimandOrder.add('participant');
    stimandOrder.add('stim');
    stimandOrder.add('biased');
    stimandOrder.add('trial');
    stimandOrder.add('audio_file_name');
    stimandOrder.add('stim_file_name');
    stimandOrder.add('counterbalance_group');
    stimandOrder.add('');
    stimandOrder.nextRow();
    
    %define column labels for transcription data file
    %experimental data only
    expData.add('participant');
    expData.add('stim');
    expData.add('biased');
    expData.add('trial');
    expData.add('audio_file_name');
    expData.add('stim_file_name');
    expData.add('counterbalance_group');
    expData.add('');
    expData.nextRow();
    
    % sound check
    micCheck(window, participantId);
    
    % clear screen
    cog_comm_tools.clearWindow(window);
    
    % Hide the mouse cursor;
    Screen('HideCursorHelper', window);

    % pahandle = PsychPortAudio('Open' [, deviceid][, mode][, reqlatencyclass][, freq][, channels][, buffersize][, suggestedLatency][, selectchannels][, specialFlags=0]);
    % This returns a handle to the audio device:
    pahandle = PsychPortAudio('Open', [], 2, 0, 44100, 1);
    
    %In 'runMode' 1, the audio hardware and processing don't shut down at
    %the end of audio playback. Instead, everything remains active in a ''hot standby'' state.
    PsychPortAudio('RunMode', pahandle, 1);

    % instructions for participant
    displayInstructions(window, 'You will hear a question and then a picture will appear. Answer either "yes" or "no" to the question, then describe what''s happening in the picture.');
    
    %continue instructions
    displayInstructions(window, 'The next few pictures will be for practice.');

    %PRACTICE TRIALS
    
    testTrials = 1;
    
    while(testTrials <= length(testStims))
        
        %clear window
        cog_comm_tools.fillWindow(window, [255 255 255]);
        cog_comm_tools.displayWindow(window);
       
        %get audio stimulus for the practice trial
        audioStim = testStimsMap(testStims{1, testTrials});
        
        %play audio stimulus
        playAudioStim(audioStim);
        
        %check for halt
        checkForEscapeKeyToHalt();
        
        % record a few samples before we actually start displaying
        % otherwise you may lose a few msec of data 
        WaitSecs(0.1);
        
        %create name for the audio recording file
        audioRecordingName = sprintf('%s_practice_%s', participantId, testStims{1, testTrials});
        
        %load image file for display
        imgfile = sprintf('stimuli/visual/%s.jpg', testStims{1, testTrials}(1:3)); 
        imdata=imread(imgfile);
        imageTexture=Screen('MakeTexture',window, imdata);
        Screen('DrawTexture', window, imageTexture);   
                 
        %flip screen and begin recording audio data
        responseTime = flipScreenRecordVoiceKeyEyelink(window, participantId, speakingTimeOut, audioRecordingName, vk, pahandle);
 
        %add trial information to the stimulus/order log
        stimandOrder.add(participantId);
        stimandOrder.add(testStims(1, testTrials));
        flag = testStims{1, testTrials}(4);
        if(flag == 'n')
            stimandOrder.add('n');
        else
            stimandOrder.add('y');
        end
        stimandOrder.add(sprintf('test %02d', testTrials));
        stimandOrder.add(audioRecordingName);
        stimandOrder.add(imgfile);
        stimandOrder.add(int2str(counterbalanceGroup));
        stimandOrder.add('');
        stimandOrder.nextRow();
        
        %increment test trials counter
        testTrials = testTrials + 1;
        
        WaitSecs(interStimuliInterval);
    end 
    
    %EXPERIMENTAL TRIALS
    displayInstructions(window, 'Do you have any questions? Ask the experimenter.');
    
    displayInstructions(window, 'We will now begin the experiment.');
    
    currentTrial = 1;
    while (currentTrial <= length(stimOrder))
        
        %set name for audio recording
        audioRecordingName = sprintf('%s_exp_%s', participantId, stimOrder{1, currentTrial});
        %clear window
        cog_comm_tools.fillWindow(window, [255 255 255]);
        cog_comm_tools.displayWindow(window);
        
        % record a few samples before we actually start displaying
        % otherwise you may lose a few msec of data 
        WaitSecs(0.1);
        
        % get appropriate audio and visual stimuli
        audioStim = audStimsMap(stimOrder{1, currentTrial});
        
        %play audio stimulus
        playAudioStim(audioStim);
        
        %check for halt
        checkForEscapeKeyToHalt();
        
         %draw, not display, the image stimulus
         %If image is experimental, check counterbalance to see whether or
         %not it's supposed to be a left or right image and append the 
         %proper orientation to the image name. If image is
         %neutral, just grab the image name.
        if(stimOrder{1, currentTrial}(1) == 'c')
        if (counterbalanceGroup == 1 || counterbalanceGroup == 2)
        imgfile = sprintf('stimuli/visual/%sl.jpg', stimOrder{1, currentTrial}(1:3));
        else
            imgfile = sprintf('stimuli/visual/%sr.jpg', stimOrder{1, currentTrial}(1:3));
        end
         else
             imgfile = sprintf('stimuli/visual/%s.jpg', stimOrder{1, currentTrial}(1:3));
        end
        
        %clear screen and draw image 
        imdata=imread(imgfile);
        imageTexture=Screen('MakeTexture',window, imdata);
        Screen('DrawTexture', window, imageTexture);   
            
        %flip screen and begin recording audio data
        responseTime = flipScreenRecordVoiceKeyEyelink(window, participantId, speakingTimeOut, audioRecordingName, vk, pahandle);

        % add info to stimulus/order log and experimental log
        stimandOrder.add(participantId);
        stimandOrder.add(stimOrder{1, currentTrial});
        flag = stimOrder{1, currentTrial}(length(stimOrder{1, currentTrial}));
        start = stimOrder{1, currentTrial}(1);
        if(flag == 'n')
            stimandOrder.add('n');
        end
        if(flag == 'y')
            stimandOrder.add('y');
        end
        %these ifs separated from the other ones for readability
        if(((counterbalanceGroup == 1 || counterbalanceGroup == 3) && ismember(stimOrder(1, currentTrial), expGroup2)) || ((counterbalanceGroup == 2 || counterbalanceGroup == 4) && ismember(stimOrder(1, currentTrial), expGroup1)))
            stimandOrder.add('n');
        end
        if(((counterbalanceGroup == 1 || counterbalanceGroup == 3) && ismember(stimOrder(1, currentTrial), expGroup1)) || ((counterbalanceGroup == 2 || counterbalanceGroup == 4) && ismember(stimOrder(1, currentTrial), expGroup2)))
            stimandOrder.add('y');
        end
            stimandOrder.add(sprintf('%02d', currentTrial));
            stimandOrder.add(audioRecordingName);
            stimandOrder.add(imgfile);
            stimandOrder.add(int2str(counterbalanceGroup));
            stimandOrder.add('');
            stimandOrder.nextRow();
        
        %add information to the experimental log only if the image was an
        %experimental image
        if (start == 'c')
            expData.add(participantId);
            expData.add(stimOrder(1, currentTrial));
            if(((counterbalanceGroup == 1 || counterbalanceGroup == 3) && ismember(stimOrder(1, currentTrial), expGroup2)) || ((counterbalanceGroup == 2 || counterbalanceGroup == 4) && ismember(stimOrder(1, currentTrial), expGroup1)))
                expData.add('n');
            end
            if(((counterbalanceGroup == 1 || counterbalanceGroup == 3) && ismember(stimOrder(1, currentTrial), expGroup1)) || ((counterbalanceGroup == 2 || counterbalanceGroup == 4) && ismember(stimOrder(1, currentTrial), expGroup2)))
                expData.add('y');
            end
            expData.add(sprintf('%02d', currentTrial));
            expData.add(audioRecordingName);
            expData.add(imgfile);
            expData.add(int2str(counterbalanceGroup));
            expData.add('');
            expData.nextRow();    
        end
        
        % end trial
        currentTrial = currentTrial + 1;        
       
    end
    
    % debriefing questions??
    displayInstructions(window, 'You have completed the experiment! \n\nPlease answer a question before we tell you about the experiment. Your response should be typed, not spoken.');
    
    questionFile = [ participantId '_rs_debriefing_responses.txt'];
    
    debriefingLog = TDFLog(['participants/' participantId '/' questionFile], true);
    debriefingLog.add('participant');
    debriefingLog.add('question_num');
    debriefingLog.add('question');
    debriefingLog.add('response');
    debriefingLog.nextRow();
    
    question_num = 1;
    
    dbquestion = 'Please state the hypothesis that you think this experiment \nis testing.';
    debriefingLog.add(participantId);
    debriefingLog.add(num2str(question_num));
    debriefingLog.add(dbquestion);
    debriefingLog.add(getStringInputWithQuestion(window, dbquestion));
    debriefingLog.nextRow(); 
    
    shutDownExperiment();
  
catch
    % the catch section executes in case of an error in the try section 
    % clean up
    shutDownExperiment();
    
    % we want to rethrow the error so we can see what happened
    psychrethrow(psychlasterror);
end
    
    
    
    
    
    
    
    
    
    
    
    
    
    