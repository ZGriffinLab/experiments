% Generic eyetracking experiment script
% obviously not actually functional
%
% Author: Ariel Sibille
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

    % load audio and visual stimuli

    % set up data files
    stimandOrder = TDFLog(['participants/' participantId '/' participantId 'yourexpnamehere.txt'], true);

    % define column labels for stimuli and order file
    %setup of datafiles
    stimandOrder.add('participant');
    stimandOrder.add('stim');
    stimandOrder.add('biased');
    stimandOrder.add('trial');
    stimandOrder.add('audio_file_name');
    stimandOrder.add('stim_file_name');
    stimandOrder.add('counterbalance_group');
    stimandOrder.add('response time');
    stimandOrder.add('vkok');
    stimandOrder.add('wav file duration');
    stimandOrder.add('');
    stimandOrder.nextRow();

    % sound check
    micCheck(window, participantId);
    % make connection with eyelink host computer and return defaults for
    % calibration
    e1 = initializeEyelink(window, resolution);

    % clear screen
    cog_comm_tools.clearWindow(window);


    % open a file for our experiment
    %warning to future programmers: the EDF filename has to be <= 8 chars
    fileName = ['yourexp' participantId '.edf'];

    %check that EDF opened properly
    i = Eyelink('Openfile', fileName);
    if i~=0
        fprintf('Cannot create EDF file ''%s'' ', fileName);
        cleanup;
        return;
    end

    % Calibrate the eye tracker
    % setup the proper calibration foreground and background colors
    e1.backgroundcolour = WhiteIndex(window);
    e1.foregroundcolour = 0;
    EyelinkUpdateDefaults(e1);
    % Hide the mouse cursor;
    Screen('HideCursorHelper', window);

    % screen_pixel_coords is set in EyelinkDoTrackerSetup call
    EyelinkDoTrackerSetup(e1);

    % pahandle = PsychPortAudio('Open' [, deviceid][, mode][, reqlatencyclass][, freq][, channels][, buffersize][, suggestedLatency][, selectchannels][, specialFlags=0]);
    % This returns a handle to the audio device:
    pahandle = PsychPortAudio('Open', [], 2, 0, 44100, 1);

    %In 'runMode' 1, the audio hardware and processing don't shut down at
    %the end of audio playback. Instead, everything remains active in a ''hot standby'' state.
    PsychPortAudio('RunMode', pahandle, 1);

    % instructions for participant
    displayInstructions(window, 'Whatever instructions you want here.');

    %experimental goodness begins here
    currentTrial = 1;

    while (currentTrial <= length of your stimulus list here)
        %set name for audio recording
        audioRecordingName = sprintf('%s_exp_%s', participantId, your stimulus name);
        %clear window
        cog_comm_tools.fillWindow(window, [255 255 255]);
        cog_comm_tools.displayWindow(window);

        % Sending a 'TRIALID' message to mark the start of a trial in Data
        % Viewer.  This is different than the start of recording message
        % START that is logged when the trial recording begins. The viewer
        % will not parse any messages, events, or samples, that exist in
        % the data file prior to this message.
        trialId = [ participantId '_exp_' stimOrder{1, currentTrial} ];
        EyelinkSetTrialId(trialId);

        % This supplies the title at the bottom of the eyetracker display
        Eyelink('command', 'record_status_message "EXP TRIAL %d/%d  %s"', currentTrial, however many trials you have, your stimulus);

        %ready eyelink for command and clear eyelink screen
        Eyelink('Command', 'set_idle_mode');
        WaitSecs(0.05);
        Eyelink('command', 'clear_screen %d', 0);


        % Do a drift correction at the beginning of each trial
        EyelinkDoDriftCorrection(e1, width/2, 200);

        Eyelink('Command', 'set_idle_mode');
        WaitSecs(0.05);

        %draw, not display, the image stimulus
         %If image is experimental, check counterbalance to see whether or
         %not it's supposed to be a left or right image and append the
         %proper orientation to the image name. If image is
         %neutral, just grab the image name.

        %add interest area file to edf
        Eyelink('Message', '!V IAREA FILE %s', iafile);

        %add the image pathname information to the edf file
        Eyelink('Message', '!V IMGLOAD FILL %s', imgfile);

        % get appropriate audio and visual stimuli

        %play audio stimulus
        playAudioStim(audioStim);

        %check for halt
        checkForEscapeKeyToHalt();

        %clear screen and draw image
        Screen('FillRect', window, e1.backgroundcolour);
        imdata=imread(imgfile);
        imageTexture=Screen('MakeTexture',window, imdata);
        Screen('DrawTexture', window, imageTexture);

        %flip screen and begin recording audio data
        [trigger, responseTime, wavDuration] = flipScreenRecordVoiceKeyEyelinkSt(window, participantId, speakingTimeOut, audioRecordingName, vk, pahandle);

        % the trial is ok... (required at end of trial)
        EyelinkTrialOk();

        % Clear the display
        Screen('FillRect', window, e1.backgroundcolour);
     	  Screen('Flip', window);
        Eyelink('Message', 'BLANK_SCREEN');
        % adds 100 msec of data to catch final events
        WaitSecs(0.1);

        % add info to stimulus/order log and experimental log
        

        % give another pause if needed, allow for halt
        WaitSecs(0.001);

        %add trial variable information to edf file
        Eyelink('Message', '!V TRIAL_VAR index %d', i);
        Eyelink('Message', '!V TRIAL_VAR imgfile %s', bmpfile);

        % Sending a 'TRIAL_RESULT' message to mark the end of a trial in
        % Data Viewer. This is different than the end of recording message
        % END that is logged when the trial recording ends. The viewer will
        % not parse any messages, events, or samples that exist in the data
        % file after this message.
        Eyelink('Message', 'TRIAL_RESULT 0')
        % end trial
        currentTrial = currentTrial + 1;

    end

    % debriefing questions
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

    % end the experiment
    Eyelink('Command', 'set_idle_mode');
    WaitSecs(0.5);
    Eyelink('CloseFile');

    %save edf file to participant's 'eyelink' folder
    displayTextCentered(window, 'Transferring Eyelink data...');
    EyelinkSaveFile(fileName, participantId);

    shutDownExperiment();

catch
    % the catch section executes in case of an error in the try section
    % clean up
    shutDownExperiment();

    % we want to rethrow the error so we can see what happened
    psychrethrow(psychlasterror);
end
