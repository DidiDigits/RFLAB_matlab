% Escribe una grupo de parámetros S 
% medidos en formato touchstone
% ====function mat2tou(DATOS,fcia,formato,comentarios,dir_sal,ar_sal)
% * DATOS -> es una matriz en donde la 1er columna
%   es la frecuencia, y las columnas restantes
%   son la parte real e imaginaria (o magnitud y fase)
%   de los parámetros S. 
% * El orden de los parámetros S 
%   debe ser S11,S21,S12,S22
% * fcia -> es una cadena que indica las unidades de 
%   frecuencia que se esten manejando (GHz,MHz,KHz,Hz)
% * formato -> es una cadena que indica si los parámetros S
%   son parte real e imaginaria (RI) o 
%   Magnitud y angulo (MA) dB-angulo
% * Comentarios -> es el encabezado del archivo
% * La impedancia normalizada va a ser igual a 50 ohms
% * dir_sal -> Es el directorio en donde se desea guardar el archivo touchstone
% * ar_sal -> Es el nombre del archivo touchstone
% * Si no se indica dir_sal y ar_sal, la función pedira se indique 
%   el directorio y el nombre del arhivo touchstone
%
% Maya Enero/1999


 function mat2tou(DATOS,fcia,formato,comentarios,dir_sal,ar_sal)

  
  [m,n]=size(DATOS);
  
  if n==3   % parámetros S de un monopuerto
   ar_tipo='*.s1p';
  elseif n==9 % parámetros S de un bipuerto
   ar_tipo='*.s2p';
  else
  error('Faltan valores de S')
  end   

  [mc,nc]=size(comentarios);
  
 if nargin<5
 % Abriendo archivo en donde se gaurdaran los datos   
 [ar_sal,dir_sal]=uiputfile(ar_tipo,'Nombre del archivo touchstone');
 end
 
 if ar_sal~=0
 
 fp=fopen([dir_sal,ar_sal],'wt');
 %ENCABEZADO
 for k=1:mc
 fprintf(fp,'! %s\n',comentarios(k,:));
 end

 fprintf(fp,'# %s S %s R 50\n',fcia,formato);   % Tipo de datos

 % escritura de frecuencia y parámetros S

for k=1:m,
 for l=1:n
 
 %if k~=m
  if l~=n 
%   fprintf(fp,'%3.6f  ',DATOS(k,l));
    fprintf(fp,'%e  ',DATOS(k,l));

  else
%   fprintf(fp,'%3.6f\n',DATOS(k,l));
    fprintf(fp,'%e\n',DATOS(k,l));
  end
 %else
 %  fprintf(fp,'%3.6f  ',DATOS(k,l));
 %end

 end
end;

fclose(fp);

end
