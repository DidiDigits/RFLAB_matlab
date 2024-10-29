% function [f,S,formato,encab]=tou2mat(archivo,pto)
% 
% Lee archivos en formato Touchstone
% devolviendo una matriz, con el vector de 
% frecuencias y los parametros S, en el formato:
%
% fcia(GHz) S=[S11 S21 S12 S22]
%
% Si se indica también devuelve en una matriz de cadenas con el formato
% y el encabezado del archivo
%
% Como variables de entrada se deben indicar:
% archivo --->  el nombre del archivo
% ptos  ---->    1, 2, 3 o 4 (uno, dos, tres o cuatro puertos respectivamente)
%
% 
% Maya   18/Nov/99
%  
%======================================
%
%  Se modifico la variable de entrada 'pto' por 'ptos', para que sea mas
%  indicativo
%
% Maya   17/Junio/2004
%  
%======================================
%
% En ocasiones los arhivos no contienen un encabezado con informacion
% adicional. En dichos casos se considera el enviar una cadena vacia, sin 
% caracteres, para evitar errores de ejecucion. Si existe, entonces se
% identifica esta cabecera y tambien se extrae su informacion
%
%
% Maya   17/Junio/2004
%  
%======================================
%

function [f,S,formato,encab]=tou2mat(archivo,ptos)

nombre=fopen(archivo);
linea=1;
p=1;
q=0;


 while linea~=-1
    clear linea   
    if ptos==1
        [A,cont]=fscanf(nombre,'%e %e %e',3);
    elseif ptos==2
        [A,cont]=fscanf(nombre,'%le %le %le %le %le %le %le %le %le',9);
    elseif ptos==3
        [A,cont]=fscanf(nombre,'%e %e %e %e %e %e %e %e %e',19);
    elseif ptos==4
       [A,cont]=fscanf(nombre,'%e %e %e %e %e %e %e %e %e',33);
    elseif ptos==5
       [A,cont]=fscanf(nombre,'%e %e %e %e %e %e %e %e %e',51);
    elseif ptos==6
       [A,cont]=fscanf(nombre,'%e %e %e %e %e %e %e %e %e',73);
    else
        show('Número de puertos no contemplados'), break   
    end
    
%    linea=fgetl(nombre) 
%    if isempty(linea), linea=1; end
    
    if cont~=0
       datos(p,:)=A.';
       p=p+1;   
       linea=1;  
    else
       
    linea=fgetl(nombre);
       if isempty(linea), linea=1; end

       %% Identificando cabecera de informacion
       if strcmp('!',linea(1)) 
          if q==0
             encab(1,:)=linea;
             q=1;
          else
             encab=str2mat(encab,linea);   
          end
          
       end
       
       %% Identificando formato de los datos
       if strcmp('#',linea(1)) 
          formato=linea;
       end
    end
    clear A cont
 end
 
  % Identificando el formato de la frecuencia 
 
 indf=find(formato=='H');
 if isempty(indf), indf=find(formato=='h'); end
 
 if ~strcmp('G',formato(1,indf-1)) & ~strcmp('g',formato(1,indf-1))  % Frecuencia con formato diferente a GHz
    if strcmp(' ',formato(1,indf-1))
       f(:,1)=datos(:,1)*1e-9;  % Cambiando de HZ a GHZ       
    elseif strcmp('K',formato(1,indf-1)) | strcmp('k',formato(1,indf-1))
       f(:,1)=datos(:,1)*1e-6;  % Cambiando de KHZ a GHZ
    elseif strcmp('M',formato(1,indf-1)) | strcmp('m',formato(1,indf-1))
       f(:,1)=datos(:,1)*1e-3;  % Cambiando de MHZ a GHZ
    end
 else
    f=datos(:,1);  % En GHz directamente
 end
 
 
 
 
  % Identificando si los parámetros S estan dados en parte real e imaginaria

indI=find(formato=='I');    % Formato RI
if isempty(indI), indI=find(formato=='i'); end

inddB=find(formato=='B');  % Formato dB
if isempty(inddB), inddB=find(formato=='b'); end

temp=datos(:,[2:size(datos,2)]);
n=size(temp,2);
qq=1;

if ~isempty(indI)   % Formato RI
       for pp=1:2:n
          S(:,qq)=temp(:,pp)+j.*temp(:,pp+1);
          qq=qq+1;
       end
elseif ~isempty(inddB)   % Formato dB
      for pp=1:2:n
          S(:,qq)=(10.^(temp(:,pp)./10)).*exp(j.*temp(:,pp+1)*pi/180);
          qq=qq+1;
      end   
else  % Formato MA 
      for pp=1:2:n
          S(:,qq)=temp(:,pp).*exp(j.*temp(:,pp+1)*pi/180);
          qq=qq+1;
      end
end


%% Si cabecera no existe o es conjunto,
%% la generamos como una matriz sin caracteres
if exist('encab','var')~=1 | isempty(encab)
encab=' ';
end

%fclose(nombre);       