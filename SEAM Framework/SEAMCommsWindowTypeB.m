function [TransmissionStartTime, TransmissionReceiptDuration] = SEAMCommsWindowTypeB(MissionTime, FileName, Access, DataSize, DataRate)

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
% SEAM Comms Window Script: Type B
% Uplink (TC / Mode Request) and Downlink (TM)
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
% Type B:
% The spacecraft and the ground segment cannot communicate directly
% (i.e. a relay is required)
% (e.g. Ground Station --> Mars Orbiter --> Mars Rover)
% The ground segment contains one ground station (e.g. DSN)
% This script calculates the time required to transmit and receive
%  - based on visibility and distance between transmitter and receiver
%  - based on STK data stored in Excel
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% Prepare MATLAB

close all
clc

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% Define Constants
GS_Relay_Distance = 300000000000; %metres
SC_Relay_Distance = 0; %metres
SpeedofLight = 300000000; %m/s
InitialRow = 2;
Window = 0;
TransmissionConstant = 1; %minutes
if Access == "GS"
    DistanceConstant = round(GS_Relay_Distance/(SpeedofLight*60),3);
elseif Access == "SC"
    DistanceConstant = round(SC_Relay_Distance/(SpeedofLight*60),3);
end
TransmissionDuration = ((DataSize/DataRate)/60)+TransmissionConstant; %minutes
TransmissionReceiptDuration = TransmissionDuration + DistanceConstant;

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% Read Excel data into Array

VisibilityData = xlsread(FileName,'Export');

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% Interested in Rover or GS visibility?

if Access == "GS"
    Col = 2;
elseif Access == "SC"
    Col = 3;
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% Find the current status of visibility

for ii = InitialRow:500
    StepTime = VisibilityData(ii+1,1);
    if StepTime > MissionTime
        CurrentStatus = VisibilityData(ii,Col);
        CurrentRow = ii;
        break
    end 
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% Determine earliest possible transmission start time

if CurrentStatus == 1
    TransmissionStartTime = MissionTime;
    TransmissionStartRow = CurrentRow;
else
    for Search = CurrentRow+1:500
        if VisibilityData(Search,Col) == 1
            TransmissionStartTime = VisibilityData(Search,1);
            TransmissionStartRow = Search;
            break
        end
    end
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% Determine visibility window, check if big enough

while Window == 0
    for ii = TransmissionStartRow+1:500
        if VisibilityData(ii,Col) == 0
                WindowStopTime = VisibilityData(ii,1);
                Window = WindowStopTime - TransmissionStartTime;
            if Window < TransmissionDuration
                Window = 0;
            end
            break
        end
    end
    if Window > 0
        break
    else
        TransmissionStartRow = TransmissionStartRow + 1;
    end
    for Search = TransmissionStartRow+1:500
        if VisibilityData(Search,Col) == 1
            TransmissionStartTime = VisibilityData(Search,1);
            TransmissionStartRow = Search;
            break
        end
    end
end

end
        