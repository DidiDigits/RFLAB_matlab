%%%% This code creates communication with KEITHLEY2602A
%%% It also sets up the initial parameters
gg=instrfind('PrimaryAddress',26);

if ~isempty(gg)
    fclose(gg);
    clear gg
end

inst='ni';
bit=0;

kei = gpib(inst,bit,26);
    set(kei, 'OutputBufferSize',3000);
    set(kei, 'TimeOut', 50);
    fopen(kei)
    
    %%%%%%=============================
%% Set up KEITHLEY
%%%%%%=============================
      
    fprintf(kei,'status.reset()')
    fprintf(kei,'errorqueue.clear()')

    fprintf(kei,'smub.measure.nplc=25')               	 
    fprintf(kei,'smua.measure.nplc=25')

    fprintf(kei,'smua.source.offmode = smua.OUTPUT_NORMAL')
    fprintf(kei,'smub.source.offmode = smub.OUTPUT_NORMAL')
  
    