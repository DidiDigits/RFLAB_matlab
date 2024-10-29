function agilent87106B_arduino(RFPath)
%%% The Agilent 87106B is a single pole, six throw RF switch.
%%% This function enables selection of the desired RF path to enable with arduino.
%%% To prevent multiple RF path engagement, the function first disables any other path that was active.

%%% This function requires installation of the Matlab Support Package for Arduino Hardware.

%%%% Create comunicacion with Arduino Uno
  %a = arduino('com3','uno');
  
  
  %%% D7 al pin azul - 8
  
%%% Open all RF paths
  writeDigitalPin(a, 'D13', 0); %Path1
  writeDigitalPin(a, 'D12', 0); %Path2
  writeDigitalPin(a, 'D11', 0); %Path3
  writeDigitalPin(a, 'D10', 0); %Path4
  writeDigitalPin(a, 'D9', 0);  %Path5
  writeDigitalPin(a, 'D8', 0);  %Path6
  writeDigitalPin(a, 'D7', 1); %**Open all paths
  
%%% Close desired RF path
  writeDigitalPin(a, 'Seleccionar', 1);
  
%%% Open desired RF path
  writeDigitalPin(a, 'Seleccionar', 0);
  
end
  