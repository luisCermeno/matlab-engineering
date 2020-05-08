clear;
clc;
close all;

%% SALUDO %%
fprintf('<strong>             PC6:Calculadora de Distribuci�n de Esfuerzos en perfiles de pared delgada</strong> \n');
fprintf('<strong>luisCermeno</strong>\n');
fprintf('<strong>v2019</strong>\n');
fprintf('Los grupos de unidades con las que trabaja este programa son:\n');
fprintf('SI\t\t\t\t\t\t   :(mm),(mm2),(MPa),(N.mm)\n');
fprintf('Ingrese los datos utilizando �nicamente uno de este grupos de unidades.\n');

%% INGRESO DE DATOS POR EL USUARIO %%
datosok=0; %Se crea una variable centinela que verificara que los datos ingresados sean de la conformidad del usuario
fprintf('<strong> \n1.INGRESO DE DATOS:</strong>\n')
fprintf('Este programa resuelve la distribuci�n de esfuerzos cortantes generados\n')
fprintf('por la aplicaci�n de una fuerza cortante vertical en cualquier punto (x,y)\n')
fprintf('en un perfil de pared delgada abierto cuyo modelo y dimensiones se mostraran\n')
fprintf('a continuaci�n:\n')%Se indica que se mostrara una imagen modelo.

input('\n-PRESIONE ENTER PARA CONTINUAR-\n');

%Se crea un pol�gono en forma del perfil con el fin de guiar al usuario en el ingreso de datos,no es una parte necesaria para el resultado.
%Se definen los puntos para graficar el perfil en sentido antihorario

tamano=get(0,'ScreenSize');%devuelve el tama�o de la pantalla en el formato [Xmin Ymin Xmax Ymax]
figure('Name','DATOS A INGRESAR','NumberTitle','off','position',[0 0 tamano(3) tamano(4)]);%ajusta la ventana a pantalla completa
rel_asp=tamano(3)/tamano(4);%calcula la relaci�n de aspecto de la pantalla,se usara para ajustar ejes
grid on;
hold on;
h=150;%para graficar el perfil se toma como ejemplo h=150,luego ese h tomara el valor que ingresara el usuario
coordxperfil=[-3*h/10,3*h/10,3*h/10,3*h/10-h/50,3*h/10-h/50,-3*h/10+h/50,-3*h/10+h/50,3*h/10-h/50,3*h/10-h/50,3*h/10,3*h/10,-3*h/10,-3*h/10];
coordyperfil=[-h/2,-h/2,0-h/100,0-h/100,-h/2+h/50,-h/2+h/50,h/2-h/50,h/2-h/50,0+h/100,0+h/100,h/2,h/2,-h/2];
perfil=polyshape(coordxperfil,coordyperfil);%Se definen la viga como un pol�gono
plot(perfil);%Ploteo del perfil
axis([rel_asp*(-h/2-h/6),rel_asp*(h/2+h/6),-h/2-h/6,h/2+h/6]);%se acomodan los ejes a la pantalla.
%los siguientes comandos son para el formato de cotas textos,etc. Su
%explicaci�n es trivial y no influye en el calculo.
txtF='V';
text(3*h/20,3*h/20+h/8,txtF,'Color','red');
txtcoord='(x,y)';
text(3*h/20,3*h/20,txtcoord);
quiver(3*h/20,3*h/20+h/4,0,-1,h/4,'r');
text(-3*h/10+h/15,-3*h/20,'El centroide es el origen de coordenadas');
plot(0,0,'o','Color','k','LineWidth',2);
quiver(3*h/10+2*h/50,0,0,1,h/2,'k');
quiver(3*h/10+2*h/50,0,0,-1,h/2,'k');
txth='h';
text(3*h/10+4*h/50,0,txth);
quiver(0,h/2+2*h/50,1,0,3*h/10,'k');
quiver(0,h/2+2*h/50,-1,0,3*h/10,'k');
txtancho='3h/5';
text(0,h/2+4*h/50,txtancho);
txtt='t = h/50';
text(-h/2,0,txtt);
title('SECCION: PERFIL DE PARED DELGADA ABIERTO');
txtA='A';
text(3*h/10,h/50,txtA);
txtB='B';
text(3*h/10,h/2,txtB);
txtD='D';
text(-3*h/10-h/50,h/2,txtD);
txtE='E';
text(-3*h/10-h/50,-h/2,txtE);
txtF='F';
text(3*h/10,-h/2,txtF);
txtG='G';
text(3*h/10,-h/50,txtG);


%Una vez que el usuario revisa la figura mostrada, ya puede ingresar los
%datos:

while datosok==0%Esta iterativa ser� controlada por el centinela,si el usuario no esta conforme con sus datos, los podr� ingresar nuevamente.
    fprintf('De acuerdo con la imagen, por favor ingrese los siguientes datos:\n');%a continuacion se piden los datos
    h=input('-h [en mm]: ');
    V=input('-V [en N]: ');
    x=input('-Punto de aplicaci�n(coordenada x) [en mm]: ');
    y=input('-Punto de aplicaci�n(coordenada y) [en mm]: ');
     
    %% Impresi�n de los datos ingresados
    %Se impimen los datos ingresados para que el usuario verifique sus datos y darle una oportunidad de cambiarlos.
    fprintf('<strong> \n2.DATOS INGRESADOS</strong>\n');
    fprintf('Altura de la viga: %d (mm)\n',h);
    fprintf('Fuerza Cortante Vertical: %d (N)\n',V);
    fprintf('Coodenada X del punto de aplicaci�n: %d (mm)\n',x);
    fprintf('Coodenada Y del punto de aplicaci�n: %d (mm)\n',y);
    
    %% Verifiaci�n los datos ingresados
    fprintf('<strong> \n�Los datos ingresados son correctos?</strong>\n');
    datosok=input('1:SI,SON CORRECTOS. 0:NO,QUIERO REINGRESAR LOS DATOS.\n');%Aqu� el usuario ingresar� el valor de la variable centinela creada al principio
    %Si la variable es 1, pasar� la condicion de la iterativa y se
    %procedera a realizar los c�lculos
    %Si es 0,entonces se repetir� TODO el ingreso de datos.
end

%% C�LCULOS, MUESTRA DE RESULTADOS
%Para el calculo se utiliza la formulaci�n obtenida manualmente, el programa solo
%reemplaza con los datos ingresados y grafica. Para ver el razonamiento de
%las formulas revisar el informe (comprobaci�n manual).
T=(0.708*h+x)*V;
cortmax_flex=(58.923*V)/h^2;
cortmax_tor=2403.8*T*(1/h^3);

%Muestra resultados:
fprintf('<strong> \n3.RESULTADOS:</strong>\n')
fprintf('Torsor generado por de la carga: %10.2e (N.mm) \n',T);
fprintf('Esfuerzos m�ximos: \n');
fprintf('Por flexi�n : %3.2f (MPa) \n',cortmax_flex);
fprintf('Por cortante (en los bordes del perfil): %3.2f (Mpa) \n',cortmax_tor);
fprintf('\nA continuaci�n, la distribuci�n de esfuerzos cortantes se mostrar� en dos vertanas emergentes.\n');

input('\n-PRESIONE ENTER PARA CONTINUAR-\n');

%% GR�FICA DE ESFUERZOS CORTANTES POR FLEXI�N
%Grafica del perfil,cotas,puntos,etc:
%Nuevamente se plotea el poligono del perfil,los comandos son similares a
%los anteriores
figure('Name','ESFUERZOS CORTANTES POR FLEXI�N','NumberTitle','off','position',[0 0 tamano(3) tamano(4)]);%ajusta la ventana a pantalla completa
grid on;
hold on;
axis([rel_asp*(-h/2-h/6),rel_asp*(h/2+h/6),-h/2-h/6,h/2+h/6]);
title('DISTRIBUCI�N DE ESFUERZOS CORTANTES POR FLEXI�N');
plot(perfil);
plot(0,0,'o','Color','k','LineWidth',2);
quiver(3*h/10-2*h/50,0,0,1,h/2,'k');
quiver(3*h/10-2*h/50,0,0,-1,h/2,'k');
txth=['',num2str(h),'mm'];
text(3*h/10-4*h/50,0,txth);
quiver(0,h/2-2*h/50,1,0,3*h/10,'k');
quiver(0,h/2-2*h/50,-1,0,3*h/10,'k');
txtancho=['',num2str(3*h/5),'mm'];
text(0,h/2-4*h/50,txtancho);
txtt=['t = ',num2str(h/50),'mm'];
text(0,-h/4,txtt);

%Grafica de esfuerzos:

%El m�todo utilizado es el dibujo de las curvas
%mediante ploteo de muchos puntos, mediante iterativa el programa calcula
%el valor del esfuerzo para puntos con un espaciado de 0.1 y lo plotea,
%esto al final crea la ilusi�n de generar una curva continua.%las
%coordenadas de dichos puntos est�n parametrados por las ecuaciones
%deducidas manualmente, por lo que el programa solo reemplaza y plotea
%muchas veces.

%NOTA:La direcci�n de s depende de que parte del perfil se analice, para m�s
%detalle ver la deducci�n manual de las ecuaciones.

%Grafica en AB
for s=0:0.1:(h/2)
yi=s;
esf=53.57*(s^2)*V*1/(h^4);%formula deducida manualmente
xi=(3*h/10)+esf;%el esfuerzo se suma para que la curva qude por la derecha de AB
plot(xi,yi,'.','Color','r','MarkerSize',1.5);
if s==h/2%condicional anidada para extrear el esfuerzo en B, acotarlo y cerrar la grafica
    maxAB=esf;
    txt=['',num2str(maxAB,3),'MPa'];
    text(3*h/10+maxAB,h/2,txt);
    xi=[3*h/10,3*h/10+maxAB];
    yi=[h/2,h/2];
    plot(xi,yi,'Color','r','MarkerSize',1.5);%linea que cierra el grafico
end
end
%Grafica en FG
for s=0:0.1:(h/2)
yi=-s;
esf=53.57*(s^2)*V*1/(h^4);%formula deducida manualmente
xi=(3*h/10)+esf;
plot(xi,yi,'.','Color','r','MarkerSize',1.5);
if s==h/2%condicional anidada para extrear el esfuerzo en F, acotarlo y cerrar la grafica
    txt=['',num2str(maxAB,3),'MPa'];
    text(3*h/10+maxAB,-h/2,txt);
    xi=[3*h/10,3*h/10+maxAB];
    yi=[-h/2,-h/2];
    plot(xi,yi,'Color','r','MarkerSize',1.5);%linea que cierra el grafico
end
end
%Grafica en DB
for s=0:0.1:(3*h/5)
xi=(3*h/10)-s;
esf=13.39*(1/h^2)*V+53.57*(1/h^3)*V*s;%formula deducida manualmente
yi=h/2+esf;
plot(xi,yi,'.','Color','r','MarkerSize',1.5);
if s==0%subiterativa para acotar y cerrar la grafica
    txt=['',num2str(maxAB,3),'MPa'];
    text(3*h/10,h/2+maxAB,txt);
    xi=[3*h/10,3*h/10];
    yi=[h/2,h/2+maxAB];
    plot(xi,yi,'Color','r','MarkerSize',1.5);
end
if s==3*h/5%subiterativa para extrear el esfuerzo en D, acotarlo y cerrar la grafica
    maxBD=esf;
    txt=['',num2str(maxBD,3),'MPa'];
    text(-3*h/10,h/2+maxBD,txt);
    xi=[-3*h/10,-3*h/10];
    yi=[h/2,h/2+maxBD];
    plot(xi,yi,'Color','r','MarkerSize',1.5);
end
end
%Grafica en EF
for s=0:0.1:(3*h/5)
xi=(3*h/10)-s;
esf=13.39*(1/h^2)*V+53.57*(1/h^3)*V*s;
yi=-h/2-esf;
plot(xi,yi,'.','Color','r','MarkerSize',1.5);
if s==0
    txt=['',num2str(maxAB,3),'MPa'];
    text(3*h/10,-h/2-maxAB,txt);
    xi=[3*h/10,3*h/10];
    yi=[-h/2,-h/2-maxAB];
    plot(xi,yi,'Color','r','MarkerSize',1.5);
end
if s==3*h/5
    maxBD=esf;
    txt=['',num2str(maxBD,3),'MPa'];
    text(-3*h/10,-h/2-maxBD,txt);
    xi=[-3*h/10,-3*h/10];
    yi=[-h/2,-h/2-maxBD];
    plot(xi,yi,'Color','r','MarkerSize',1.5);
end
end
%Grafico en DE
for s=0:0.1:(h)
yi=h/2-s;
esf=(V*45.53*(1/(h^2)))+53.57*(1/(h^5))*(h-s)*h*s*V;
xi=(-3*h/10)-esf;
plot(xi,yi,'.','Color','r','MarkerSize',1.5);
if s==0
    txt=['',num2str(maxBD,3),'MPa'];
    text(-3*h/10-maxBD,h/2,txt);
    xi=[-3*h/10,-3*h/10-maxBD];
    yi=[h/2,h/2];
    plot(xi,yi,'Color','r','MarkerSize',1.5);
end
if s==h/2
    maxDE=esf;
    txt=['',num2str(maxDE,3),'MPa'];
    text(-3*h/10-maxDE,0,txt);
end

if s==h
    txt=['',num2str(maxBD,3),'MPa'];
    text(-3*h/10-maxBD,-h/2,txt);
    xi=[-3*h/10,-3*h/10-maxBD];
    yi=[-h/2,-h/2];
    plot(xi,yi,'Color','r','MarkerSize',1.5);
end
end
%Finalmente se reajustan los ejes para que entren las nuevas curvas
%creadas
axis([rel_asp*(-h/2-h/6-maxBD),rel_asp*(h/2+h/6+maxBD),-h/2-h/6-maxBD,h/2+h/6+maxBD])%acomodacion final de los ejes.

%% GR�FICA DE ESFUERZOS CORTANTES POR TORSI�N
if T~=0%Esta iterativa al principio verifica que la fuerza cortante genere torsor,si no hay no se grafica.
    %Grafica de la rebanada diferencial,cotas,puntos,torsor,etc:
    figure('Name','ESFUERZOS CORTANTES POR TORCI�N (REBANADA DE PARED DELGADA)','NumberTitle','off','position',[0 0 tamano(3) tamano(4)]);%ajusta la ventana a pantalla completa
    grid on;
    hold on;
    axis([rel_asp*(-h/2-h/6),rel_asp*(h/2+h/6),-h/2-h/6,h/2+h/6]);%se acomodan los ejes a la pantalla.
    title('DISTRIBUCI�N DE ESFUERZOS CORTANTES POR TORCI�N EN UNA REBANADA DEL PERFIL');
    coordxdif=[-3*h/10,3*h/10,3*h/10,-3*h/10,-3*h/10];
    coordydif=[-h/2,-h/2,h/2,h/2,-h/2];
    diferencial=polyshape(coordxdif,coordydif);%Se define el elemento diferencial como un pol�gono
    plot(diferencial);
    if T>0  %condicional para plotear el torsor, a su vez se aprovecha para extraer el signo y almacenarlo en la variable signotorsor.
    signotorsor=1;
    txtT=['T = ',num2str(T/1000000),' kN.m (horario)'];
    text(-3*h/20,-h/2+h/15,txtT);
    else
    signotorsor=-1;
    txtT=['T = ',num2str(T/1000000),' kN.m (antihorario)'];
    text(-3*h/20,-h/2+h/15,txtT);   
    end
    quiver(3*h/10+2*h/50,0,0,1,h/2,'k');
    quiver(3*h/10+2*h/50,0,0,-1,h/2,'k');
    txth=['',num2str(h),'mm'];
    text(3*h/10+4*h/50,0,txth);
    quiver(0,h/2+2*h/50,1,0,3*h/10,'k');
    quiver(0,h/2+2*h/50,-1,0,3*h/10,'k');
    txtancho=['',num2str(3*h/5),'mm'];
    text(0,h/2+4*h/50,txtancho);
    txtt=['t = ',num2str(h/50),'mm'];
    text(0,-h/2+h/25,txtt);
    
    %Grafico de la recta que une los esfuerzos cortantes maximos en las
    %caras interior y exterior.Dependiento del signo del torsor la recta tendr� pendiente positiva o
    %negativa
    m=-signotorsor*(h/2)/(3*h/10);%se halla la pendiente de la recta
    xi=[-3*h/10,3*h/10];
    yi=[signotorsor*h/2,signotorsor*-h/2];
    plot(xi,yi,'Color','r','MarkerSize',1.5);%se unen las coordenadas con una recta
    %Grafico de la recta horizontal
    xi=[-3*h/10,3*h/10];
    yi=[0,0];
    plot(xi,yi,'Color','r','MarkerSize',1.5);
    
    %Grafico de los vectores de esfuerzo en la superficie de la secci�n
    %transversal,el s va desde la cara exterior(signo negativo) hasta la
    %cara interior(signo positivo)
    
    for s=-3*h/10:5:3*h/10 %se plotean varios vectores para diferentes valores de s,espaciado en 5 unidades
    esf=m*s;%el esfuerzo como sigue una relaci�n lineal estar� dado por y=mx
    signo=esf/abs(esf);%se extrae el signo del esfuerzo para darle sentido al vector
    quiver(s,0,0,signo,abs(esf),'r');%se plotea el respectivo vector   
    end    
    %Acotaciones de puntos
    txt=['',num2str(cortmax_tor,3),'MPa'];
    text(-3*h/10,signotorsor*h/2,txt,'Color','red');
    txt=['',num2str(cortmax_tor,3),'MPa'];
    text(3*h/10,signotorsor*-h/2,txt,'Color','red');
    
end

 