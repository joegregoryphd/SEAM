function [GS, TransmissionStartTime, TransmissionDuration] = CommsWindow(MissionTime, FileName, DataSize, DataRate)

% Function to identify ground stations and calculate downlink times

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

close all
clc

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% Define Constants

InitialStep = 2;
MaxWindow = 0;
TransmissionConstant = 1; %minutes
TransmissionDuration = ((DataSize/DataRate)/60)+TransmissionConstant; %minutes

% Read Excel data into Array

VisibilityData = xlsread(FileName,'Export');

% Calculate windows at SVA, KIR, TRO

while MaxWindow == 0
    [a,b,c,d,e,f] = Window(InitialStep, VisibilityData, MissionTime, TransmissionDuration);
    MaxWindow = a;
    SVAWindow = b;
    KIRWindow = c;
    TROWindow = d;
    InitialStep = e+1;
    TransmissionStartTime = f;
end

% Choose which ground station to downlink to

if     MaxWindow == SVAWindow
    GS = "SVA";
elseif MaxWindow == KIRWindow
    GS = "KIR";
elseif MaxWindow == TROWindow
    GS = "TRO";
end
    
end


function [MaxWindow, SVAWindow, KIRWindow, TROWindow, Step, TransmissionStartTime] = Window(InitialStep, VisibilityData, MissionTime, TransmissionDuration)

% Find the current status of ground stations

for ii = InitialStep:500
    
    ArrayTime = VisibilityData(ii+1,1);
    
    if ArrayTime > MissionTime
        SVA = VisibilityData(ii,2);
        KIR = VisibilityData(ii,3);
        TRO = VisibilityData(ii,4);
        Step = ii;
        break
    end 
end

% Determine Downlink start time

if SVA+KIR+TRO>0
    TransmissionStartTime = MissionTime;
else
    Step = ii+1;
    TransmissionStartTime = VisibilityData(Step,1);
    SVA = VisibilityData(Step,2);
    KIR = VisibilityData(Step,3);
    TRO = VisibilityData(Step,4);
end

% Determine ground station visibility windows

if SVA == 1
    for ii = Step+1:500   
        if VisibilityData(ii,2) == 0
            SVAStopTime = VisibilityData(ii,1);
            SVAWindow = SVAStopTime - TransmissionStartTime;
            if SVAWindow < TransmissionDuration
                SVAWindow = 0;
            end
            break
        end
    end
else
    SVAWindow=0;
end

if KIR == 1
    for ii = Step+1:500   
        if VisibilityData(ii,3) == 0
            KIRStopTime = VisibilityData(ii,1);
            KIRWindow = KIRStopTime - TransmissionStartTime;
            if KIRWindow < TransmissionDuration
                KIRWindow = 0;
            end
            break
        end
    end
else
    KIRWindow=0;
end

if TRO == 1
    for ii = Step+1:500   
        if VisibilityData(ii,4) == 0
            TROStopTime = VisibilityData(ii,1);
            TROWindow = TROStopTime - TransmissionStartTime;
            if TROWindow < TransmissionDuration
                TROWindow = 0;
            end
            break
        end
    end
else
    TROWindow = 0;
end

MaxWindowArray = [SVAWindow, KIRWindow, TROWindow];
MaxWindow = max(MaxWindowArray);

end
        
        