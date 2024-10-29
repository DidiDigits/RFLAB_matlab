%%% Program for reading all four s-parameters from Agilent 8753ES
%%% In this program:
%%% All parameters are sourced from Channel 1, thats because in the 8753ES, most variables are independent across channels.
%%% The funcion returns the S-parameters data in a complex vector
%%% Frequency-related values are calculated considering a linear frequency sweep

global vna

%%% Create comunicacion with Agilent 8753ES
VISA_address='GPIB0::16::INSTR';
vna = visa('keysight',VISA_address);

%%% Change input buffer size to maximum for a read of 1601 data points
buffer = (1601*16)+4;
set (vna,'InputBufferSize',buffer);
%%% Clear the input buffer
flushinput(vna);

% Open conection
try
    fopen(vna);
    set(vna,'timeout',15);
catch exception %problem occurred throw error message
     uiwait(msgbox('Error occurred trying to connect to the Agilent 8753ES, verify correct IP address','Error Message','error'));
     rethrow(exception);
end

%Query identity string and report
fprintf (vna, '*IDN?');
idn = fscanf (vna);

%Select CHANEL 1 as the active Chanel.
% fprintf(vna,'OPC?')  %% Verificar
% flag = fscanf (vna);
fprintf(vna,'CHAN1'); 

%Set the measurement mode and get trace data.
fprintf(vna,'S11');
fprintf(vna,'SMIC'); %Set Smith chart as display format 
S11 = getDataTrace8753ES;

fprintf(vna,'S12');
fprintf(vna,'SMIC'); %Set Smith chart as display format 
S12 = getDataTrace8753ES;

fprintf(vna,'S21');
fprintf(vna,'SMIC'); %Set Smith chart as display format 
S21 = getDataTrace8753ES;

fprintf(vna,'S22');
fprintf(vna,'SMIC'); %Set Smith chart as display format 
[S22,Freq] = getDataTrace8753ES;

fclose(vna)
