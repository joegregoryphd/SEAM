function [TransmissionStartTime, TransmissionReceiptDuration] = CommsWindowExo(MissionTime, FileName, Access, DataSize, DataRate)

% Function to calculate transmission time

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

close all
clc

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


% Define Constants
MarsEarthDistance = 300000000000; %metres
SpeedofLight = 300000000; %m/s
InitialRow = 2;
Window = 0;
TransmissionConstant = 1; %minutes
if Access == "GS"
    DistanceConstant = round(MarsEarthDistance/(SpeedofLight*60),3);
elseif Access == "ROV"
    DistanceConstant = 0;
end
TransmissionDuration = ((DataSize/DataRate)/60)+TransmissionConstant; %minutes
TransmissionReceiptDuration = TransmissionDuration + DistanceConstant;

% Read Excel data into Array
VisibilityData = xlsread(FileName,'Export');

% Interested in Rover or GS visibility?
if Access == "GS"
    Col = 2;
elseif Access == "ROV"
    Col = 3;
end

% Find the current status of visibility
for ii = InitialRow:500
    StepTime = VisibilityData(ii+1,1);
    if StepTime > MissionTime
        CurrentStatus = VisibilityData(ii,Col);
        CurrentRow = ii;
        break
    end 
end

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

while Window == 0
    % Determine visibility window, check if big enough
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

%Print results
TransmissionDuration;
TransmissionReceiptDuration;
MissionTime;
TransmissionStartTime;
WindowStopTime;
Window;

end
        