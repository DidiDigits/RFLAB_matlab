function [data,freq] = GetDataTrace8753ES
%%% This program reads Agilent 8753ES binary data trace display in IEEE 64 bit format. 
%%% This function utilizes a global VISA connection with the vna
%%% The array header is used to determine the length of the array
%%% If data is displayed in polar or smith chart the data is allocated in an complex vector
%%% The data reflects all the post processing such as: time domain, gating, electrical delay, trace math, smoothing
%%% Frequency-related values are calculated considering a linear frequency sweep

global vna %%%Visa connection 

%Select form 3 format
fprintf(vna,'FORM3');
pause(1);
fprintf(vna,'OUTPFORF');
pause(2);


%Read out #A from binblock
header_1=fread(vna, 2, 'char'); 
header_1 = char(header_1);  

%Read out block size
header2=fread(vna, 1, 'uint16'); 
header2=swapbytes(typecast(uint16(header2), 'uint16'));
number_bytes=double(header2);

%Read out trace data
data_read = fread(vna, number_bytes/8, 'double');  
data_pre = swapbytes(data_read);

%Ask display format
fprintf(vna,'SMIC?');
flag_smith_char = fscanf(vna);
flag_smith = str2double(flag_smith_char);

fprintf(vna,'POLA?');
flag_polar_char = fscanf(vna);
flag_polar = str2double(flag_polar_char);

% Create complex vector if data is complex
       if flag_polar == 1 || flag_smith == 1
         %Create complex vector
         num_pairs = length(data_pre) / 2;  % Calculate the number of pairs
         data = complex(data_pre(1:2:end), data_pre(2:2:end));
       else
         data = data_pre;
       end
            
%Calculate frequency point data
fprintf(vna,'POIN?');
n_points = str2double(fscanf(vna));
fprintf(vna,'STAR?')
f_start = str2double(fscanf(vna));
fprintf(vna,'SPAN?');
f_span = str2double(fscanf(vna));

f_inc=f_span/(n_points-1);
freq_array = f_start + (0:n_points-1) * f_inc;  % Generate Frequency array
freq = freq_array'
end
       
