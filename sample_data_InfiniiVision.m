function [osc_time,osc_voltage] = sample_data_InfiniiVision(points,chanel)
%%% This function returns the waveform aqcuire by InfiniiVision DSO-X 3014T.
%%% This function utilizes a global VISA connection with the oscilloscope 
%%% In this function:
%%% Number of points to digitize -- points
%%% Chanel to digitize -- chanel
%%% Acquires the waveform displayed on the oscilloscope screen.
%%% Transfers waveform data in BYTE format to enable 8-bit access
%%% The function returns the measured time and voltage --- osc_time, osc_voltage

global scope %%% VISA connection

%Indicate format and chanel to acquire data
chanel_str = num2str(chanel);
fprintf(scope,append(':WAVeform:SOURce CHANnel',chanel_str));
fprintf(scope,':WAVeform:FORMat BYTE');
points_str = num2str(points);
fprintf(scope,append(':WAVeform:POINts ',points_str));  

% Request Osciloscope scaling information 
fprintf(scope,':WAVEFORM:PREAMBLE?');
preamble=str2num(fscanf(scope)); %Converts preamble information to a numeric vector
xincrement=preamble(5);
xorigin=preamble(6);
xreference=preamble(7);
yincrement=preamble(8); 
yorigin=preamble(9);
yreference=preamble(10);

%Request osciloscope waveform
fprintf(scope,':WAVeform:DATA?');
data_raw=fread(scope);

%Remove header and terminator data
header=str2num(char(data_raw(2)))+2;
data_value=data_raw(header+1:end-1);

%Data conversion
osc_voltage=((data_value-yreference)*yincrement)+ yorigin;
osc_time=[([1:1:length(osc_voltage)]-xreference)*xincrement]+xorigin;

end