clear;
clc;
close all;
%% SALUDO E INGRESO DE DATOS DE LA GEOMETRIA DE LA ESTRUCTURA
fprintf('<strong>                 PC2:CALCULADORA B�SICA DE DEFORMACIONES</strong> \n');
fprintf('<strong>luisCermeno</strong>\n');
fprintf('<strong>v2019</strong>\n');
fprintf('\nSe abrir� una ventana con el gr�fico de su estructura.\n');
fprintf('Por favor no cerrarlo.\n');
fprintf('Acoplar el command window a la izquierda para una mejor experiencia.\n\n');
fprintf('<strong>1.GEOMETR�A DE LO ELEMENTOS</strong>\n')
fprintf('El nodo B se ubicar� en el origen de coordenadas.\n');
fprintf('A su vez,es punto de uni�n de las dos barras y ser� cargado.\n');
fprintf('La ubicaci�n de cada elemento esta definido por dos puntos:\n');
fprintf('El nodo B y su apoyo\n');

%preparacion de la ventana para graficar los elementos%
tamano=get(0,'ScreenSize');
figure('position',[tamano(3)/2 0 tamano(3)/2 tamano(4)]);
plot(0,0,'ko','linewidth',4);
txttitle=('ESTRUCTURA DE 2 BARRAS APOYADAS:');
title(txttitle);
text(-0.4,0,'B')
hold on;
grid on;
%matrices que almacenaran la informacion dada por el usuario%
xap=zeros(2,1);%para almacenar las coordenadas x de los apoyos%
yap=zeros(2,1);%para almacenar las coordenadas y de los apoyos%
A=zeros(2,1);%para almacenar las areas de las barras%
E=zeros(2,1);%para almacenar los modulos de elasticidad de las barras%

for i=1:2%iterativa para pedir datos%
    fprintf('<strong>ELEMENTO #%d: </strong> \n',i);
    xap(i)=input('Ingrese la coordenada x de su apoyo (m):  \n');
    yap(i)=input('Ingrese la coordenada y de su apoyo (m):  \n');
    %grafica de la barra segun las coordenas ingresadas%
    %las variables creadas en esta parte son triviales para el calculo, se usan temporalmente para graficar%
    Xgraf=[0 xap(i)];
    Ygraf=[0 yap(i)];
    Xmin=min(vertcat(xap,0));
    Xmax=max(xap);
    Ymin=min(yap);
    Ymax=max(yap);
    switch i
        case 1
            text(xap(i)-0.4,yap(i),'A')
        case 2
            text(xap(i)-0.4,yap(i),'C')  
    end
    axis([(Xmin-2) (Xmax+2) (Ymin-2) (Ymax+2)]);
    grid on;
    hold on;
    plot(Xgraf,Ygraf,'b','linewidth',4);
    plot(xap(i)+0.1,yap(i),'k<','linewidth',4);
    %se pide el area y el modulo de elasticidad%
    A(i)=input('Ingrese el �rea transversal de la barra (mm^2):  \n');
    E(i)=input('Ingrese el m�dulo de elasticidad de la barra (GPa):  \n');
    
   
end
%se pide las componentes de la carga en el nodo b%
fprintf('<strong>2.CARGA SOBRE EL NODO B</strong>\n')
Px=input('Ingrese la componente horizontal de la carga (N):  \n');
Py=input('Ingrese la componente vertical de la carga (N):  \n');
Pxy=sqrt(Px^2+Py^2);%modulo de la carga%
%grafica del vector de la carga%
txt = ['',num2str(Pxy),'N'];
text(-0.25,-0.5,txt)
quiver(0,0,Px/Pxy,Py/Pxy,'b','linewidth',1.5);

%% IMPRESI�N DE DATOS INGRESADOS
fprintf('<strong>Datos de entrada:\n</strong>\n');
fprintf('Barra X(apoyo)\tY(apoyo)\tArea(mm2)\tM�dulo de elasticidad(GPa)\n');
for i=1:2
 fprintf('%2d\t%8.3f\t%8.3f\t%8.3f\t%8.3f\n',i,xap(i),yap(i),A(i),E(i));   
end

%% C�LCULOS
%matrices que almacenaran calculos parciales necesarios%
P=[Px;Py];%para almacenar componentes de la carga sobre el nodo B%
ang=zeros(2,1);%para almacenar los angulos de inclinacion de las barras(en radianes%
l=zeros(2,1);%para almacenar la longitud de las barras (en metros)%
for i=1:2%se calcula la inclinacion y longitud de las barras con la iterativa%
    ang(i)= atan(yap(i)/xap(i));
    l(i)= sqrt(xap(i)^2 + yap(i)^2);
end
%se calculan cosenos y senos de los angulos para poder darle direccion a las fuerzas internas%
c1= cos(ang(1));
c2= cos(ang(2));
s1= sin(ang(1));
s2= sin(ang(2));
Direccion=[[c1; s1],[c2; s2]];
%Se hallan las fuerzan internas mediante el equilibrio en el nodo%
F=-inv(Direccion)*P;%las fuerzas internas se almacenan en la matrix F%
Esf=F./A;%Se hallan los esfuerzos F/A%
Def=(F.*(l*1000))./((E.*1000).*A);%Se hallan las deformaciones PL/EA%

%Se calculan los desplazamientos en B mediante ecuaciones halladas manualmente con geometr�a
%La demostracion esta en la parte manual
%Desplazamientos por deformacion de la barra 1
d1=abs(Def(1))/cos(pi/2-abs(ang(1))-abs(ang(2)));
dx1=d1*sin(abs(ang(2)));
dy1=d1*cos(abs(ang(2)));
if F(1)>0
    dx1=-dx1;
    dy1=-dy1;
elseif F(1)==0
    dx1=0;
    dy1=0;
end
%Desplazamientos por deformacion de la barra 2
d2=abs(Def(2))/cos(pi/2-abs(ang(1))-abs(ang(2)));
dx2=d2*sin(abs(ang(1)));
dy2=d2*cos(abs(ang(1)));
if F(2)>0
    dx2=-dx2;
elseif F(1)==0
    dx2=0;
    dy2=0;
else
    dy2=-dy2;
end
%Suma de contribuciones
x=dx1+dx2;%desplazamiento total en x
y=dy1+dy2;%desplazamiento total en y

%% IMPRESI�N DE RESULTADOS
fprintf('<strong>3.RESULTADOS</strong>\n')
fprintf('Barra\tLongitud(m)\tInclinaci�n\tFuerza(N)\t�rea(mm2)\tEsfuerzo(MPa)\tDeformaci�n(mm)\n');
for i=1:2
 fprintf('%2d\t %8.3f\t  %8.3f\t    %8.3f\t%8.3f\t%8.3f\t  %8.3f\n',i,l(i),ang(i)*180/pi,F(i),A(i),Esf(i),Def(i));   
end
fprintf('El desplazamiento del punto B ser�:\n');
fprintf('Horizontal: %8.3f mm\n',x);
fprintf('Vertical:   %8.3f mm\n',y);

