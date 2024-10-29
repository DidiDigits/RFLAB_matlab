function [meas_voltage,meas_current] = powersupply9115(MaxCurrent,Voltage_Value)
%%% This function set current and voltage values for power supply BK Precision 9115
%%% This function allows the user to:
%%% Set the maximum output current value ---- MaxCurrent [A]
%%% Set the voltage ---- Voltage_Value [V]
%%% The function returns the measured voltage and current values ---- meas_current [A], meas_voltage [V]

%%%% Create comunicacion with BK PRECISION 9115
VISA_address='USB0::0xFFFF::0x9115::600422010707430027::0::INSTR';
f_ps = visa('keysight',VISA_address);
 
% Open conection
fopen(f_ps);

%Query identity string and report
fprintf (f_ps, '*IDN?');
idn = fscanf (f_ps);

%Reset instrument
fprintf (f_ps, '*RST');

% Set the maximum output current value
Current_str = num2str(MaxCurrent);
fprintf(f_ps,append('SOURce:CURRent:LEVel:IMMediate:AMPLitude ',Current_str , 'mA'));

% Set the voltage value
Voltage_str = num2str(Voltage_Value);
fprintf(f_ps,append('SOURce:VOLTage:LEVel:IMMediate:AMPLitude ',Voltage_str));

% Set Output state ON
fprintf(f_ps,'SOURce:OUTPut:STATe ON');

pause(1) %% Waits 1 seconds for the Power Supply to set the current and voltage

% Measure Voltage
fprintf (f_ps, 'MEASure:SCALar:VOLTage:DC?');
meas_voltage = fscanf (f_ps);

% Measure Current
fprintf (f_ps, 'MEASure:SCALar:CURRent:DC?');
meas_current = fscanf (f_ps);

%Close connection
fclose(f_ps);
end