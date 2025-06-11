function [GS, TransmissionStartTime, TransmissionDuration] = SEAMCommsWindowTypeA(MissionTime, FileName, DataSize, DataRate)

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
% SEAM Comms Window Script: Type A
% Uplink (TC / Mode Request) and Downlink (TM)
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
% Type A:
% The spacecraft and the ground segment can communicate directly
% (i.e. no relay required)
% The ground segment contains up to three ground stations
% This script identifies the best ground station to transmit via
%  - based on visibility over the tranmission period
%  - based on STK data stored in Excel
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% Prepare MATLAB

close all
clc

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% Define Constants

InitialStep = 2;
MaxWindow = 0;
TransmissionConstant = 1; %minutes
TransmissionDuration = ((DataSize/DataRate)/60)+TransmissionConstant; %minutes

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% Read Excel data into Array

VisibilityData = xlsread(FileName,'Export');

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% Calculate windows at GS1, GS2, GS3

while MaxWindow == 0
    [a,b,c,d,e,f] = Window(InitialStep, VisibilityData, MissionTime, TransmissionDuration);
    MaxWindow = a;
    GS1Window = b;
    GS2Window = c;
    GS3Window = d;
    InitialStep = e+1;
    TransmissionStartTime = f;
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% Choose which ground station to downlink to

if     MaxWindow == GS1Window
    GS = "GS1";
elseif MaxWindow == GS2Window
    GS = "GS2";
elseif MaxWindow == GS3Window
    GS = "GS3";
end
    
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

function [MaxWindow, GS1Window, GS2Window, GS3Window, Step, TransmissionStartTime] = Window(InitialStep, VisibilityData, MissionTime, TransmissionDuration)

% Function: Calculate windows at GS1, GS2, GS3

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% Find the current status of ground stations

for ii = InitialStep:500
    
    ArrayTime = VisibilityData(ii+1,1);
    
    if ArrayTime > MissionTime
        GS1 = VisibilityData(ii,2);
        GS2 = VisibilityData(ii,3);
        GS3 = VisibilityData(ii,4);
        Step = ii;
        break
    end 
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% Determine Downlink start time

if GS1+GS2+GS3>0
    TransmissionStartTime = MissionTime;
else
    Step = ii+1;
    TransmissionStartTime = VisibilityData(Step,1);
    GS1 = VisibilityData(Step,2);
    GS2 = VisibilityData(Step,3);
    GS3 = VisibilityData(Step,4);
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% Determine ground station visibility windows

if GS1 == 1
    for ii = Step+1:500   
        if VisibilityData(ii,2) == 0
            GS1StopTime = VisibilityData(ii,1);
            GS1Window = GS1StopTime - TransmissionStartTime;
            if GS1Window < TransmissionDuration
                GS1Window = 0;
            end
            break
        end
    end
else
    GS1Window=0;
end

if GS2 == 1
    for ii = Step+1:500   
        if VisibilityData(ii,3) == 0
            GS2StopTime = VisibilityData(ii,1);
            GS2Window = GS2StopTime - TransmissionStartTime;
            if GS2Window < TransmissionDuration
                GS2Window = 0;
            end
            break
        end
    end
else
    GS2Window=0;
end

if GS3 == 1
    for ii = Step+1:500   
        if VisibilityData(ii,4) == 0
            GS3StopTime = VisibilityData(ii,1);
            GS3Window = GS3StopTime - TransmissionStartTime;
            if GS3Window < TransmissionDuration
                GS3Window = 0;
            end
            break
        end
    end
else
    GS3Window = 0;
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% Final Values

MaxWindowArray = [GS1Window, GS2Window, GS3Window];
MaxWindow = max(MaxWindowArray);

end
        
        