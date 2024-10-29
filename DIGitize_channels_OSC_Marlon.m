function DIGitize_channels_OSC(n,avg,type_points,points)
global osc
% n      --> number of channels to digitize
%            if n = 2 then channel 1 and channel 2 will be digitize
% points --> number of points of each waveform
%     ss = instrfind; % Lista de los equipos que estan conectados, que se han 
%                     % conectado y que se han accesado en algun momento
%                     % indicando su estado, la variable ss es una estructura

% :WAVeform:POINts <# points>
% <# points> ::= {100 | 250 | 500 | 1000 | <points mode>}
% if waveform points mode is NORMal
% <# points> ::= {100 | 250 | 500 | 1000 | 2000 | 5000 | 10000 | 20000
% | 50000 | 100000 | 200000 | 500000 | 1000000 | 2000000
% | 4000000 | 8000000 | <points mode>}
% if waveform points mode is MAXimum or RAW
% <points mode> ::= {NORMal | MAXimum | RAW}

% :WAVeform:POINts:MODE <points_mode>
% <points_mode> ::= {NORMal | MAXimum | RAW}
% Considerations for MAXimum or RAW data retrieval: 
% * The instrument must be stopped (see the :STOP command (see page 223) or
%   the :DIGitize command (see page 199) in the root subsystem) in order to return
%   more than the measurement record.
% * :TIMebase:MODE must be set to MAIN.
% * :ACQuire:TYPE must be set to NORMal or HRESolution.
% * MAXimum or RAW will allow up to 4,000,000 points to be returned. The
%   number of points returned will vary as the instrument's configuration is
%   changed. Use the :WAVeform:POINts? MAXimum query to determine the
%   maximum number of points that can be retrieved at the current settings.

% DIGitize [<source>[,..,<source>]] 
%// <source> ::= {CHANnel<n> | DIGital<d> | POD{1 | 2} | BUS{1 | 2} | FUNCtion | MATH | SBUS{1 | 2}} 
% for the MSO models. It causes the instrument to acquire waveforms according to the settings of the 
% :ACQuire commands subsystem.
if avg == 1
    fprintf(osc,'ACQuire:TYPE NORMal');
else
    fprintf(osc,'ACQuire:TYPE AVERage');
    fprintf(osc,[':ACQuire:COUNt ',num2str(avg)]);
end
fprintf(osc,':ACQuire:COMPlete 100');                                  % The parameter determines the percentage of the time buckets that must be "full" before an acquisition is considered complete. The only legal value for the :COMPlete command is 100.
fprintf(osc,':WAVeform:FORMat ASCii');                                 % ASCii formatted data converts the internal integer data values to real Y-axis values.
fprintf(osc,[':WAVeform:POINts ',num2str(points)]);                    % The :WAVeform:POINts command sets the number of waveform points to be transferred with the :WAVeform:DATA? query.
fprintf(osc,[':WAVeform:POINts:MODE ',type_points]);


q = length(n);
switch q
    case 1
        fprintf(osc,[':DIGitize CHANnel',num2str(n(1))]);
    case 2
        fprintf(osc,[':DIGitize CHANnel',num2str(n(1)),',CHANnel',num2str(n(2))]);
    case 3 
        fprintf(osc,[':DIGitize CHANnel',num2str(n(1)),',CHANnel',num2str(n(2)),',CHANnel',num2str(n(3))]);
    case 4
        fprintf(osc,':DIGitize CHANnel1,CHANnel2,CHANnel3,CHANnel4');
end
%query(osc,'*OPC?');
                   
