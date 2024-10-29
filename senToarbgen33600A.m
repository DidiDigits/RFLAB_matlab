function senToarbgen(arb_waveform,amplitude,sRate,name)
%%% Sends an arbitraty waveform to Keysight Waveform Generator 33622A 
%%% This function requires:
%%% The waveform data -- arb
%%% The amplitud of the waveform -- amplitude
%%% The specified sample rate per second -- sRate
%%% The name to indentify the funcion in the equipment

%%%% Create comunicacion with Waveform Generator 33622A
VISA_address= 'USB0::0x0957::0x5707::MY53805023::0::INSTR';
fgen = visa('keysight',VISA_address);

% Change ouput buffer size
buffer = length(arb_waveform)*8;
set (fgen,'OutputBufferSize',(buffer+125));

% Open conection
try
    fopen(fgen);
    set(fgen,'timeout',10);
catch exception %problem occurred throw error message
     uiwait(msgbox('Error occurred trying to connect to the 33622, verify correct IP address','Error Message','error'));
     rethrow(exception);
end

%Query Idendity string and report
fprintf (fgen, '*IDN?');
idn = fscanf (fgen);
fprintf (idn)
fprintf ('\n\n')

%Clear previous data
fprintf (fgen, '*CLS');

%Reset instrument
fprintf (fgen, '*RST');

%Ensure waveform data is a column vector
if isrow(arb_waveform) == 0
    arb_waveform = arb_waveform';
end

%Set the waveform data to single precision
arb_waveform = single(arb_waveform);

%Scale data between 1 and -1
mx = max(abs(arb_waveform));
arb_waveform = (1*arb_waveform)/mx;

%Send waveform to 33600
fprintf(fgen, 'SOURce1:DATA:VOLatile:CLEar'); %Clear volatile memory
fprintf(fgen, 'FORM:BORD SWAP');  %Sets the byte order used in binary (LSB) data point transfers in the block mode
arbBytes=num2str(length(arb_waveform) * 4); %# of bytes required for arb
header= ['SOURce1:DATA:ARBitrary ' name ', #' num2str(length(arbBytes)) arbBytes]; %create header
binblockBytes = typecast(arb_waveform, 'uint8');  %convert datapoints to binary before sending
fwrite(fgen, [header binblockBytes], 'uint8'); %combine header and datapoints then send to instrument
fprintf(fgen, '*WAI');   %Make sure no other commands are exectued until arb is done downloadin

%Set desired configuration for channel 1
command = ['SOURce1:FUNCtion:ARBitrary ' name];
fprintf(fgen,command); % set current arb waveform to defined arb testrise
command = ['MMEM:STOR:DATA1 "INT:\' name '.arb"'];
fprintf(fgen,command);

command = ['SOURCE1:FUNCtion:ARB:SRATe ' num2str(sRate)]; %create sample rate command
fprintf(fgen,command);%set sample rate
fprintf(fgen,'SOURce1:FUNCtion ARB'); % turn on arb function
command = ['SOURCE1:VOLT ' num2str(amplitude)]; %create amplitude command
fprintf(fgen,command); %send amplitude command
fprintf(fgen,'SOURCE1:VOLT:OFFSET 0'); % set offset to 0 V
fprintf(fgen,'OUTPUT1 ON'); %Enable Output for channel 1
%fprintf('Arb waveform downloaded to channel 1\n\n') %print waveform has been downloaded

%Read Error
fprintf(fgen, 'SYST:ERR?');
errorstr = fscanf (fgen);

% Error checking
if strncmp (errorstr, '+0,"No error"',13)
   errorcheck = 'Arbitrary waveform generated without any error\n';
   fprintf (errorcheck)
else
   errorcheck = ['Error reported: ', errorstr];
   fprintf (errorcheck)
end

% Close connection
fclose(fgen);

end