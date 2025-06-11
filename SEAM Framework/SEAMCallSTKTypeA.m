function [GS1Duration, GS2Duration,GS3Duration]=SEAMCallSTKTypeA(StartT,StopT,GS1_Lat, GS1_Long, GS2_Lat, GS2_Long, GS3_Lat, GS3_Long,SMA,Ecc,I,AoP,RAAN,TA)

%% 1. Pre-processing:
% The actions in this section perform the necessary pre-processing

%% 1a. Time/Date Formats:
% The required time formats are defined

%This is the format that needs to go into STK
formatOut = 'dd mmm yyyy HH:MM:SS.FFF';
%this is for calcs I'm doing 
TimeDifference= 'HH:MM:SS.FFF';
%this is the format that comes out of STK
formatIn = 'dd mm yy HH MM SS FFF';


%% 2. STK link:
% The actions in this section are those that are performed through the
% MATLAB-STK link

%% 2a. calling STK:
% STK is opened via MATLAB

app = actxserver('STK11.application');
app.UserControl = 1;
root = app.Personality2;

%% 2b. Setting times:
% The 'start' and 'stop' times from CSM are put into the STK input format

start_time=datestr(datenum(StartT,'ddmmyyHHMMSSFFF',2000),formatOut);
stop_time=datestr(datenum(StopT,'ddmmyyHHMMSSFFF',2000),formatOut);

%% 2c. Setting up the STK scenrio:
% Define the scenario

% Name the scenario (e.g. 'SEAM_Example')
scenario = root.Children.New('eScenario','SEAM_TypeA');
% Set start and stop times of scenario 
scenario.SetTimePeriod(start_time,stop_time);
scenario.StartTime = start_time;
scenario.StopTime = stop_time; 
root.ExecuteCommand('Animate * Reset');

%% 2d. Adding objects to the scenario:

% Add Ground Station 1 to the scenario
facility1 = scenario.Children.New('eFacility','GroundStation_1');
%Setting position of Ground Station, from values in CSM 
facility1.Position.AssignGeodetic(GS1_Lat,GS1_Long,0); 

% Add Ground Station 2 to the scenario
facility2 = scenario.Children.New('eFacility','GroundStation_2');
%Setting position of Ground Station, from values in CSM 
facility2.Position.AssignGeodetic(GS2_Lat,GS2_Long,0); 

% Add Ground Station 3 to the scenario
facility3 = scenario.Children.New('eFacility','GroundStation_3');
%Setting position of Ground Station, from values in CSM 
facility3.Position.AssignGeodetic(GS3_Lat,GS3_Long,0); 


%Adding Satellite to the scenario
satellite = scenario.Children.New('eSatellite','Biomass');

%% 2e. Defining orbit in STK:
% Define the orbit of the satellite in the scenario

% Calculate PA and AA from SMA and Ecc
Rp = SMA*(1-Ecc);
Ra = SMA*(1+Ecc);
PA = Rp - 6378.137;
AA = Ra - 6378.137;

% Call satellite to set orbit 
keplerian = satellite.Propagator.InitialState.Representation.ConvertTo('eOrbitStateClassical');
% Define orbital element types
%   - Periapsis/Apoapsis rather than Ecc/SMA)
%   - True Anomaly is in use
%   - RAAN instead of LAN 
keplerian.SizeShapeType = 'eSizeShapeAltitude';
keplerian.LocationType = 'eLocationTrueAnomaly';
keplerian.Orientation.AscNodeType = 'eAscNodeRAAN';
% Set orbital values, from values in CSM
keplerian.SizeShape.PerigeeAltitude = PA;
keplerian.SizeShape.ApogeeAltitude = AA;
keplerian.Orientation.Inclination = I;
keplerian.Orientation.ArgOfPerigee = AoP;
keplerian.Orientation.AscNode.Value = RAAN;
% Assign the True Anomaly
keplerian.Location.Value = TA;
% Assign the orbit to the satellite 
satellite.Propagator.InitialState.Representation.Assign(keplerian);
% Propagate the satellite through the orbit 
satellite.Propagator.Propagate;

%% 2f. Adding features to the Satellite: 
% Add features such as cameras with a specific field of view to
% the satellite

% Add in antenna to Satellite_Example
sensorGS = satellite.Children.New('eAntenna', 'Antenna');


%% 2g. Getting access times:
% Use STK to compute access times for the defined ground stations / targets

%Getting Ground Station 1 access times
accessGS1 = satellite.GetAccessToObject(facility1);
accessGS1.ComputeAccess
accessGS1 = accessGS1.DataProviders.Item('Access Data').Exec(scenario.StartTime,scenario.StopTime);
accessGS1StartTimes = accessGS1.DataSets.GetDataSetByName('Start Time').GetValues;
accessGS1StopTimes = accessGS1.DataSets.GetDataSetByName('Stop Time').GetValues;

%Getting Ground Station 2 access times
accessGS2 = satellite.GetAccessToObject(facility2);
accessGS2.ComputeAccess
accessGS2 = accessGS2.DataProviders.Item('Access Data').Exec(scenario.StartTime,scenario.StopTime);
accessGS2StartTimes = accessGS2.DataSets.GetDataSetByName('Start Time').GetValues;
accessGS2StopTimes = accessGS2.DataSets.GetDataSetByName('Stop Time').GetValues;

%Getting Ground Station 3 access times
accessGS3 = satellite.GetAccessToObject(facility3);
accessGS3.ComputeAccess
accessGS3 = accessGS3.DataProviders.Item('Access Data').Exec(scenario.StartTime,scenario.StopTime);
accessGS3StartTimes = accessGS3.DataSets.GetDataSetByName('Start Time').GetValues;
accessGS3StopTimes = accessGS3.DataSets.GetDataSetByName('Stop Time').GetValues;

%% 3. Post-processing values:
% These actions are performed in MATLAB - not in STK

%% 3.1 Save target access times:
% Use MATLAB to save the access times to the targets

% No Target defined

%% 3.2 Save ground station access times:
% Use MATLAB to save the access times to the ground stations

%Ground Station 1 - Start times, Stop times, Access times
accessGS1StartTimesstr=datestr(accessGS1StartTimes,formatIn,2000);
accessGS1StartTimes_M=datenum(accessGS1StartTimesstr,formatIn);
accessGS1StopTimesstr=datestr(accessGS1StopTimes,formatIn,2000);
accessGS1StopTimes_M=datenum(accessGS1StopTimesstr,formatIn);
GS1Duration_M=accessGS1StopTimes_M-accessGS1StartTimes_M;
GS1Duration=datestr(GS1Duration_M,TimeDifference);

%Ground Station 2 - Start times, Stop times, Access times
accessGS2StartTimesstr=datestr(accessGS2StartTimes,formatIn,2000);
accessGS2StartTimes_M=datenum(accessGS2StartTimesstr,formatIn);
accessGS2StopTimesstr=datestr(accessGS2StopTimes,formatIn,2000);
accessGS2StopTimes_M=datenum(accessGS2StopTimesstr,formatIn);
GS2Duration_M=accessGS2StopTimes_M-accessGS2StartTimes_M;
GS2Duration=datestr(GS2Duration_M,TimeDifference);

%Ground Station 3 - Start times, Stop times, Access times
accessGS3StartTimesstr=datestr(accessGS3StartTimes,formatIn,2000);
accessGS3StartTimes_M=datenum(accessGS3StartTimesstr,formatIn);
accessGS3StopTimesstr=datestr(accessGS3StopTimes,formatIn,2000);
accessGS3StopTimes_M=datenum(accessGS3StopTimesstr,formatIn);
GS3Duration_M=accessGS3StopTimes_M-accessGS3StartTimes_M;
GS3Duration=datestr(GS3Duration_M,TimeDifference);

%% 3.3 Save data while testing
%To save files when testing: 
%save('StopTimes.Mat','accessStopTimesstr','accessGSStopTimesstr','VolcanoDuration','GSDuration')

% Make sure the file path is specified
FileLoc = 'C:\Users\jg0852\OneDrive - University of Bristol\PhD\6. Model\1. Joe Gregory\SEAM\Active\SEAM General Pack\SEAMExcelModelTypeA.xlsx';

% Save results to file location
GS1 = [accessGS1StartTimes,accessGS1StopTimes];
GS2 = [accessGS2StartTimes,accessGS2StopTimes];
GS3 = [accessGS3StartTimes,accessGS3StopTimes];
xlswrite(FileLoc,GS1, 'GS1', 'B2');
xlswrite(FileLoc,GS2, 'GS2', 'B2');
xlswrite(FileLoc,GS3, 'GS3', 'B2');


end 