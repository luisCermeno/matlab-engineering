clear;
clc;
close all;

%% SALUDO %%
fprintf('<strong>                 PC5:CALCULADORA B�SICA DE Madmisible y Vadmisible en vigas de perfil W</strong> \n');
fprintf('<strong>luisCermeno</strong>\n');
fprintf('<strong>v2019</strong>\n');
fprintf('<strong>SEMESTRE ACADEMICO: 2019-1</strong>\n\n');
fprintf('Los grupos de unidades con las que trabaja este programa son:\n');
fprintf('SI\t\t\t\t\t\t   :(mm),(mm2),(MPa),(N.mm)\n');
fprintf('Ingrese los datos utilizando �nicamente uno de este grupos de unidades.\n');

%% INGRESO DE DATOS POR EL USUARIO %%
datosok=0; %Se crea una variable centinela que verificara que los datos ingresados sean de la conformidad del usuario
fprintf('<strong> \n1.INGRESO DE DATOS:</strong>\n')
while datosok==0%Esta iterativa ser� controlada por el centinela,si el usuario no esta conforme con sus datos, los podr� ingresar nuevamente.
    fprintf('Por favor ingrese los siguientes datos de el material:\n');
    normaladm=input('Esfuerzo Normal Admisible (Mpa): ');
    cortanteadm=input('Esfuerzo Cortante Admisible (Mpa): ');
    fprintf('\nA continuaci�n ingrese los siguientes datos de el perfil:\n');
    fprintf('[Peralte(d) Ancho del ala(bf) Espesor del ala(tf) Espesor del alma(tw) Momento de Inercia X(Ix)]\n');
    fprintf('Ejemplo de formato para ingreso: \n');
    fprintf('Datos: [678 254 16.3 11.7 1190000000]\n');
    fprintf('NOTA:El momento de inercia es respecto al eje X centroidal horizontal \n');
    datos=input('Datos: ');%Se pide una matriz de ingreso
    %Los elementos de la matriz de ingreso se almacenan en las variables siguientes:%
     d=datos(1);
     bf=datos(2);
     tf=datos(3);
     tw=datos(4);
     Ix=datos(5);
     
    %% Impresi�n de los datos ingresados
    %Todos los comandos son con prop�sito de formato de impresi�n para lograr que el
    %usuario reconozca los datos que ingres�, considero trivial su
    %explicaci�n.
    fprintf('<strong> \n2.DATOS INGRESADOS</strong>\n');
    fprintf('Esfuerzo normal admisible %d (Mpa/Psi)\n',normaladm);
    fprintf('Esfuerzo cortante admisible %d (Mpa/Psi)\n',cortanteadm);
    fprintf('Peralte(mm)\tAncho del ala(mm)\tEspesor del ala(mm)\tEspesor del alma(mm)\tMomento de Inercia X(mm^4)\n');
    fprintf('%8.3f\t\t %8.3f\t\t\t\t%8.3f\t\t\t\t%8.3f\t\t\t\t\t%10.2e \n',d,bf,tf,tw,Ix);   
    %% Verifiaci�n los datos ingresados
    fprintf('<strong> \n�Los datos ingresados son correctos?</strong>\n');
    datosok=input('1:SI,SON CORRECTOS. 0:NO,QUIERO REINGRESAR LOS DATOS.\n');%Aqu� el usuario ingresar� el valor de la variable centinela creada al principio
    %Si la variable es 1, pasar� la condicion de la iterativa y se
    %procedera a realizar los c�lculos
    %Si es 0,entonces se repetir� TODO el ingreso de datos.
end

%% C�LCULOS, GRAFICOS Y RESULTADOS
%C�lculo del Momento Flector Admisible y Fuerza Cortante Admisible.
%Para el calculo se utiliza la formulaci�n obtenida manualmente, el programa solo
%reemplaza con los datos ingresados
Madm=(normaladm*Ix*2)/d;
Qmax=(((d-tf)/2)*tf*bf)+(((d-2*tf)^2)/8)*tw;
Vadm=(cortanteadm*Ix*tw)/Qmax;

%Muestra resultados:
fprintf('<strong> \n3.RESULTADOS:</strong>\n')
fprintf('El momento flector admisible es : %10.2e (N.mm) \n',Madm);
fprintf('La fuerza cortante admisible es : %10.2e (N) \n',Vadm);

% GRAFICA DE ESFUERZOS NORMALES
 %Se crea un pol�gono en forma de viga (visto de perfil)con el fin de dar un mejor aspecto en el formato
 %del gr�fico,no es una parte necesaria para el resultado.
coordxviga=[-normaladm-200,0,0,-normaladm-200,-normaladm-200];%Se definen los puntos para graficar la viga
coordyviga=[-d/2,-d/2,d/2,d/2,-d/2];
viga=polyshape(coordxviga,coordyviga);%Se definen la viga como un pol�gono
coordxala1=[-normaladm-200,0,0,-normaladm-200,-normaladm-200];%Se definen los puntos para graficar la viga
coordyala1=[-d/2,-d/2,-d/2+tf,-d/2+tf,-d/2];
ala1=polyshape(coordxala1,coordyala1);%Se definen el ala inferior como un pol�gono
coordxala2=[-normaladm-200,0,0,-normaladm-200,-normaladm-200];%Se definen los puntos para graficar el ala inferior
coordyala2=[d/2-tf,d/2-tf,d/2,d/2,d/2-tf];%Se definen los puntos para graficar el ala superior
ala2=polyshape(coordxala2,coordyala2);%Se definen el ala superior como un pol�gono
tamano=get(0,'ScreenSize');
figure('position',[tamano(3)/2 0 tamano(3)/2 tamano(4)]);
subplot(2,1,1);%Se establecen dos graficos en una sola ventana
grid on;
hold on;
plot(viga);%Representacion grafica del alma
plot(ala1);%Representacion grafica del ala inferior
plot(ala2);%Representacion grafica del ala superior
%Se nombra los ejes y se pone titulo
axis([-normaladm-100,normaladm+100,-d/2-100,d/2+100]);
xlabel('Esfuerzo Normal (MPa)');
ylabel('Elevaci�n (mm)');
title('DISTRIBUCI�N DE ESFUERZOS NORMAL (VISTA PERFIL)');
%Se define la funcion a graficar, se utiliza la formulacion obtenida
%manualmente
y = -d/2:1/100:d/2;
x = -Madm*y/Ix;
plot(x,y,'r');
%Se crean rectas para que cierre el grafico
x =[-normaladm,0];
y =[d/2,d/2];
plot(x,y,'r');
x =[0,normaladm];
y =[-d/2,-d/2];
plot(x,y,'r');
%Se acotan los puntos importantes en el gr�fico con la herramienta txt.
txtMadm=['Madm = ',num2str(Madm,3),' N.mm'];
text(-normaladm,0,txtMadm);
txtnormalmin=['-',num2str(normaladm),' MPa'];
text(-normaladm,d/2,txtnormalmin);
txtnormalmax=['',num2str(normaladm),' MPa'];
text(normaladm,-d/2,txtnormalmax);


% GRAFICA DE ESFUERZOS CORTANTES
%Se indica que se va a graficar en el segundo subgrafico de la ventana
subplot(2,1,2);
grid on;
hold on;
plot(viga);%Representacion grafica de la viga
plot(ala1);
plot(ala2);
%Se nombra los ejes y se pone titulo
axis([-normaladm-100,normaladm+100,-d/2-100,d/2+100]);
xlabel('Esfuerzo Cortante (MPa)');
ylabel('Elevaci�n (mm)');
title('DISTRIBUCI�N DE ESFUERZOS CORTANTES (VISTA PERFIL)');
%Se define la funcion a graficar, se utiliza la formulacion obtenida
%manualmente, como tiene tres partes se utiliza tres veces el comando plot
y = (d/2-tf):1/100:(d/2);
x = (Vadm.*(y+((d/2)-y)/2).*((d/2)-y).*bf)/(Ix*bf);
plot(x,y,'r')

y = (-d/2):1/100:(-d/2+tf);
x = (Vadm.*(y+((d/2)-y)/2).*((d/2)-y).*bf)/(Ix*bf);
plot(x,y,'r')
%Para este tramo a continuacion, se crean variables adicionales q1 y c1,
%unicamente con el fin de facilitar el tipeo de la formula en el codigo, ya
%que la formulacion deducida es muy larga.
y = (-(d/2)+tf):1/100:((d/2)-tf);
q1=((d-tf)/2)*tf*bf;
c1=(d-2*tf)/2;
x = (Vadm*(q1+((y+c1)/2).*(c1-y).*tw))./(Ix*tw);
plot(x,y,'r')

%Se crean rectas para que cierre el grafico, a su vez se calculan los
%puntos notables del grafico
y=d/2-tf;
cortala=(Vadm.*(y+((d/2)-y)/2).*((d/2)-y).*bf)/(Ix*bf);
cortalma=(Vadm*(q1+((y+c1)/2).*(c1-y).*tw))./(Ix*tw);
y=0;
maxcortante=(Vadm*(q1+((y+c1)/2).*(c1-y).*tw))./(Ix*tw);

x =[cortala,cortalma];
y =[d/2-tf,d/2-tf];
plot(x,y,'r');
y =[-d/2+tf,-d/2+tf];
plot(x,y,'r');

%Se acotan los puntos importantes en el gr�fico con la herramienta txt.
txtVadm=['Vadm = ',num2str(Vadm,3),' N'];
text(-normaladm,0,txtVadm);
txtcortala=['',num2str(cortala,2),' MPa'];
text(cortala,d/2-tf,txtcortala);
text(cortala,-d/2+tf,txtcortala);
txtcortalma=['',num2str(cortalma,2),' MPa'];
text(cortalma,d/2-tf,txtcortalma);
text(cortalma,-d/2+tf,txtcortalma);
txtmaxcortante=['',num2str(maxcortante,2),' MPa'];
text(maxcortante,0,txtmaxcortante);
cortprom=Vadm/(tw*(d-2*tf));
txtCortprom=['Cort.Prom = ',num2str(cortprom,3),' N'];
text(normaladm,0,txtCortprom);


 