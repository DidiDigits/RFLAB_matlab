%%% This program acquires and displays the waveform captured by InfiniiVision DSO-X 3014T.
%%% In this program:
%%% Number of points to digitize -- points
%%% Chanel to digitize -- chanel
%%% The function uses AutoScale to automatically configure the oscilloscope to best display the input signal
%%% Sets the acquisition to Normal: In this mode at slower time/div settings, extra samples are decimated
%%% Transfers waveform data in BYTE format to enable 8-bit access
%%% The function returns the measured time and voltage --- osc_time, osc_voltage

global scope

%%%% Create comunicacion with Keysight InfiniiVision DSO-X 3014T
VISA_address='USB0::0x2A8D::0x1768::MY55120187::0::INSTR';
scope = visa('keysight',VISA_address);

% Change input buffer size
buffer = points*8;
set (scope,'InputBufferSize',(buffer+256));

% Open conection
try
    fopen(scope);
    set(scope,'timeout',10);
catch exception %problem occurred throw error message
     uiwait(msgbox('Error occurred trying to connect to the InfiniiVision DSO-X 3014T, verify correct IP address','Error Message','error'));
     rethrow(exception);
end

%Query identity string and report
fprintf (scope, '*IDN?');
idn = fscanf (scope);

%Clear previous data
fprintf (scope, '*CLS');

%Initialize the instrument to a preset state:
fprintf (scope, '*RST');

%Autoscale for unknown waveforms
fprintf (scope, 'AUToscale'); %Autoscale all channels

%Selecting the Acquisition Parameters
fprintf(scope,'ACQuire:TYPE NORMal');
fprintf(scope,':ACQuire:COMPlete 100');

%Digitaze signal in indicated chanel
chanel_str = num2str(chanel);
fprintf(scope,append(':DIGitize CHANnel',chanel_str));

%Fetch data
[osc_time,osc_voltage]=sample_data_InfiniiVision(points,chanel)

plot(osc_time,osc_voltage);
 
% Close connection
fclose(scope)

end