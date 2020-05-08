clear;
clc;
close all;

%% SALUDO %%
fprintf('<strong>                 PC4:CALCULADORA B�SICA DE DEFORMACIONES POR TORCI�N</strong> \n');
fprintf('<strong>luisCermeno</strong>\n');
fprintf('<strong>v2019</strong>\n');
fprintf('Los grupos de unidades con las que trabaja este programa son:\n');
fprintf('SI\t\t\t\t\t\t   :(mm),(mm2),(MPa),(N.mm)\n');
fprintf('Uso com�n en Estados Unidos:(in),(in2),(psi),(lb.in)\n');
fprintf('Ingrese los datos utilizando �nicamente uno de estos grupos de unidades.\n');
fprintf('Los resultados estar�n en el grupo de unidades que usted eligi� para el ingreso.\n');

%% INGRESO DE DATOS POR EL USUARIO %%
datosok=0; %Se crea una variable centinela que verificara que los datos ingresados sean de la conformidad del usuario
while datosok==0%Esta iterativa ser� controlada por el centinela,si el usuario no esta conforme con sus datos, los podr� ingresar nuevamente.
    fprintf('<strong> \n\t\tEJE "AB" DE N ELEMENTOS CIL�NDRICOS EMPOTRADO EN AMBOS EXTREMOS </strong>\n')
    fprintf('<strong> \t\t\t\t\t\tY SOMETIDOS A N TORSORES.</strong>\n\n')
    %% Ingreso de los datos (elementos de las barras y condiciones del medio)
    fprintf('<strong>1.INGRESO DE DATOS DEL EJE AB</strong>\n')
    n=input('<strong>Ingrese el n�mero de elementos del eje:</strong> \n');
    fprintf('');
    %Se definen matrices verticales de n filas que almacenaran los datos de
    %los elementos que conforman el eje
    L = zeros(n,1);%Para las longitudes de cada elemento
    Re = zeros(n,1);%Para los radios exteriores de cada elemento
    Ri = zeros(n,1);%Para los radios interiores de cada elemento
    G = zeros(n,1);%Para los modulos de corte de cada elemento
    T = zeros(n,1);%Para los torsores externos de cada elemento
    DeformacionesA = zeros(n,1);%Para las deformaciones de cada elemento
    %La matriz para esfuerzos en cada elemento se definir� al momento de hacer los c�lculos
    fprintf('\nA continuaci�n ingrese los siguientes datos para cada elemento:\n');
    fprintf('[Longitud Radio_exterior Radio_interior M�dulo_de_Corte Torsor_aplicado_en_su_extremo_frontera]\n');
    fprintf('Ejemplo de formato para ingreso: \n');
    fprintf('Datos: [200 25 0 77200 1400000]\n');
    fprintf('NOTAS: \n');
    fprintf('-Si el extremo frontera corresponde al empotramiento B ingresar un valor de cero para el torsor.\n');
    fprintf('-Si el elemento es s�lido ingresar un valor de cero para el radio interior.\n');
    %Se establece una iterativa para pedir los datos de cada elemento
    for i=1:n
        fprintf('<strong> \nElemento n�mero %d: </strong>\n',i);
        datos=input('Datos: ');%Se pide una matriz de ingreso
        %Los elementos de la matriz de ingreso se van almacenando en los espacios de las matrices creadas anteriormente%
        L(i,1)=datos(1);
        Re(i,1)=datos(2);
        Ri(i,1)=datos(3);
        G(i,1)=datos(4);
        T(i,1)=datos(5);
    end
    
    %% Impresi�n de los datos ingresados
    %Todos los comandos son con prop�sito de formato de impresi�n para lograr que el
    %usuario reconozca los datos que ingres�, considero trivial su
    %explicaci�n.
    fprintf('<strong> \n3.DATOS INGRESADOS</strong>\n');
    fprintf('<strong>EJE AB:\n</strong>');
    fprintf('Elemento\tLongitud(mm,in)\tRadio exterior(mm,in)\tRadio interior(mm,in)\tModulo de Corte(MPa,psi)\n');
    for i=1:n
    fprintf('%2d\t\t\t %8.3f\t\t %8.3f\t\t\t\t%8.3f\t\t\t\t\t%10.2e \n',i,L(i,1),Re(i,1),Ri(i,1),G(i,1));   
    end
    fprintf('<strong>TORSORES EXTERNOS:\n</strong>');
    fprintf('Elemento\tTorsor aplicado en su extremo frontera(N.mm,lb.in)\n');
    for i=1:n
    fprintf('%2d\t\t\t%10.2e\n',i,T(i,1));   
    end
    %% Verifiaci�n los datos ingresados
    fprintf('<strong> \n�Los datos ingresados son correctos?</strong>\n');
    datosok=input('1:SI,SON CORRECTOS. 0:NO,QUIERO REINGRESAR LOS DATOS.\n');%Aqu� el usuario ingresar� el valor de la variable centinela creada al principio
    %Si la variable es 1, pasar� la condicion de la iterativa y se
    %procedera a realizar los c�lculos
    %Si es 0,entonces se repetir� TODO el ingreso de datos.
end

%% C�LCULOS

    %% C�lculo de los los momentos polares de inercia para cada elemento
    J = zeros(n,1);%Matriz de almacenamiento
    for i=1:n
    J(i,1)=0.5*pi*((Re(i,1)^4)-(Ri(i,1)^4));       
    end    
    %% Principio de Superposici�n
    %Giro de B en ESTADO I (solamente por torsores externos)
    GirobI=0;
    i=n;
    %Por medio de una iterativa de calcula la sumatoria de todos los giros
    %relativos
    Ti=0;
    while i>0
    Ti=Ti+T(i,1);
    girorel=(Ti*L(i,1))/(J(i,1)*G(i,1));
    GirobI=GirobI+girorel;
    i=i-1;
    end
    %Giro de B en ESTADO II (solamente por torsor reacci�n en B)
    syms B;
    %Por medio de una iterativa de calcula la sumatoria de todos los giros
    %relativos
    GirobII=0;
    i=n;
    while i>0 %Sumatoria de todos los giros
    girorel=(B*L(i,1))/(J(i,1)*G(i,1));
    GirobII=GirobII+girorel;
    i=i-1;
    end
    %% SOLUCI�N PARA B.
    %Planteo y soluci�n de la ecuaci�n de compatibilidad para hallar el
    %torsor reacci�n en B.
    compatibilidad=GirobI+GirobII==0;
    B=eval(solve(compatibilidad,B));%Se halla el torsor reacci�n "B".
    %% SOLUCI�N PARA A.
    %Por equilibrio se halla A
    torexternos=0;
    for i=1:n%Sumatoria de los torsores externos
    torexternos=T(i,1)+torexternos;
    end
    syms A;
    equilibriorot=torexternos+B+A==0;%ecuacion de equilibrio rotacional
    A=eval(solve(equilibriorot,A));%Se halla el torsor reacci�n "A".
    
    %% C�lculo de los esfuerzos cortantes y giros para los ejes.
    %Se crean matrices que almacenaran los datos.
    Girosrel = zeros(n,1);
    Girosab = zeros(n,1);
    Esfuerzomax= zeros(n,1);
    Esfuerzomin= zeros(n,1);
    %Calculo de giros relativos y esfuerzos cortantes(max y min).
    Ti=A;%Ti ser� la fuerza interna en el elemento,comienza siendo A para el elemento 1.
    for i=1:n
    Girosrel(i,1)=(Ti*L(i,1))/(J(i,1)*G(i,1));
    Esfuerzomax(i,1)=(Ti*Re(i,1))/J(i,1);
    Esfuerzomin(i,1)=(Ti*Ri(i,1))/J(i,1);
    Ti=Ti+T(i,1);%Actualizacion de la fuerza interna
    end
    %Calculo de giros absolutos
    Giroacum=0;
    for i=1:n
    Girosab(i,1)=Giroacum+Girosrel(i,1);
    Giroacum=Giroacum+Girosab(i,1);
    end

%% IMPRESI�N DE RESULTADOS
%Todos los comandos son con prop�sito de formato de impresi�n para lograr que el
%usuario reconozca lea e interprete los resultados calculados anteriormente, considero trivial su
%explicaci�n.

fprintf('<strong> \n4.RESULTADOS:</strong>\n')
fprintf('La reacci�n en el empotramiento A es de: %8.3f (N.mm;lb.in) \n',A);
fprintf('La reacci�n en el empotramiento B es de: %8.3f (N.mm;lb.in) \n',B);
fprintf('<strong>ESFUERZOS CORTANTES:\n</strong>');
fprintf('Elemento\tEsfuerzo cortante max (MPa,psi)\tEsfuerzo cortante min (MPa,psi)\n');
for i=1:n
    fprintf('%2d\t\t\t%8.3f\t\t\t\t\t\t%8.3f\n',i,Esfuerzomax(i,1),Esfuerzomin(i,1));
end
fprintf('<strong>GIROS:\n</strong>');
fprintf('Elemento\tGiro relativo(rad)\tGiro absoluto del extremo frontera(rad)\n');
for i=1:n
    fprintf('%2d\t\t\t%8.3f\t\t\t%8.3f\n',i,Girosrel(i,1),Girosab(i,1));
end

        
        
