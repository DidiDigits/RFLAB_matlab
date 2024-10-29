function [meas_voltage_chA, meas_current_chA, meas_voltage_chB, meas_current_chB] = powersupplyKeith2602A(kei,mode_srcA,Value_srcA,outputA,mode_srcB,Value_srcB,outputB)
%%% This function set current or voltage values for both channels on power supply Keithley2602A
%%% This function allows the user to:
%%% Set the operation mode for each source ---- mode_srcA, mode_srcB [current] or [voltage]
%%% Set the voltage or current value ---- Value_srcA, Value_srcB. The value units are in [A] or [V]
%%% Turn the source ON or OFF --- [ON] or [OFF]
%%% The function returns the measured voltage and current values for each channel ---- meas_current_chA [A], meas_voltage_chA [V], meas_current_chB [A], meas_voltage_chB [V]

%Set power supply display configuration
fprintf(kei,'display.screen = display.SMUA_SMUB ') %Show both channels
fprintf(kei,'display.smua.measure.func = display.MEASURE_DCAMPS ')  %Display measurement in Ampers
fprintf(kei,'display.smub.measure.func = display.MEASURE_DCAMPS ') %Display measurement in Ampers
fprintf(kei,'display.smua.digits = display.DIGITS_5_5 ') %Display resolution Ch A
fprintf(kei,'display.smub.digits = display.DIGITS_5_5 ') %Display resolution Ch B


% Choose operation mode between voltaje or current source for source A
    switch lower(mode_srcA)
            case 'current' 
            fprintf(kei,'smua.source.func=smua.OUTPUT_DCAMPS ')
            fprintf(kei,['smua.source.leveli= ',num2str(Value_srcA)])
            case 'voltage'
            fprintf(kei,'smua.source.func=smua.OUTPUT_DCVOLTS ')  %% Voltage source
            fprintf(kei,['smua.source.levelv= ',num2str(Value_srcA)])
    end
    
% Choose operation mode between voltaje or current source B
    switch lower(mode_srcB)
            case 'current' 
            fprintf(kei,'smub.source.func=smub.OUTPUT_DCAMPS ')
            fprintf(kei,['smub.source.leveli= ',num2str(Value_srcB)])
            case 'voltage'
            fprintf(kei,'smub.source.func=smub.OUTPUT_DCVOLTS ')  %% Voltage source
            fprintf(kei,['smub.source.levelv= ',num2str(Value_srcB)])
    end    
 
     % Turn on or of the power supply source A
     switch lower(outputA)
         case 'on'
            fprintf(kei,'smua.source.output=smua.OUTPUT_ON ')
         case 'off'   
            fprintf(kei,'smua.source.output=smua.OUTPUT_OFF ') 
     end

      % Turn on or of the power supply source B
     switch lower(outputB)
         case 'on'
            fprintf(kei,'smub.source.output=smub.OUTPUT_ON ')
         case 'off'   
            fprintf(kei,'smub.source.output=smub.OUTPUT_OFF ') 
     end

     % Measure voltage and current channel A
     fprintf(kei,'print(smua.measure.iv())');
     pause(0.5)
     meas_chA = str2num(fscanf(kei));
     meas_voltage_chA = meas_chA(2);
     meas_current_chA = meas_chA(1);

      % Measure voltage and current channel B
     fprintf(kei,'print(smub.measure.iv())');
     pause(0.5)
     meas_chB = str2num(fscanf(kei));  
     meas_voltage_chB = meas_chB(2);
     meas_current_chB = meas_chB(1);
 end
 
 