clear;
clc;
close all;
%% SALUDO 
fprintf('<strong>                 CALCULADORA DEL M�DULO DE ELASTICIDAD </strong>\n');
fprintf('<strong>      Y DIAGRAMAS DE FUERZAS INTERNAS PARA ENSAYOS DE VIGAS A FLEXI�N</strong>\n\n');
fprintf('<strong>luisCermeno</strong>\n');
fprintf('<strong>v2019</strong>\n');
fprintf('NOTA: Para una mejor experiencia de usuario, usar dos ventanas simult�neas,\n');
fprintf('para ver los gr�ficos y para ingresar los datos.\n\n');
%% GRAFICA PRELIMINAR DE UNA VIGA EJEMPLO PARA EL USUARIO.
%Para empezar, se abre una ventana con una viga ejemplo para que sea mas
%facil ingresar los datos, todos los comandos son con prop�sito de formato.
tamano=get(0,'ScreenSize');
figure('Name','DATOS A INGRESAR','NumberTitle','off','position',[0 0 tamano(3) tamano(4)]);
subplot(3,1,1);
grid on;
hold on;
%estos valores son aleatorios para poder graficar la viga ejemplo
l=0.9;
a=0.155;
b=0.155;
d=0.45;
txttitle='FORMATO DE INGRESO DE DATOS';
title(txttitle);
axis([-0.3*l 1.3*l -3 3]);
coordxviga=[0,0,l,l,0];%Se definen los puntos para graficar la viga
coordyviga=[0,0.25,0.25,0,0];
viga=polyshape(coordxviga,coordyviga);%Se definen la viga como un pol�gono;
plot(viga);%Representacion grafica de la viga
plot(a,-0.1*l,'k^','linewidth',2);%Representacion grafica del primer apoyo
text(a,-0.4*l,'R1')
plot(l-b,-0.1*l,'k^','linewidth',2);%Representacion grafica del segundo apoyo
text(l-b,-0.4*l,'R2')
%Acotaciones
txt = 'Pi';
text(d,2.25,txt)
quiver(d,2.25,0,-1,2,'b','linewidth',1.5);

quiver(0,-1.5,1,0,l,'k.');
quiver(0,-1.7,0,1,0.4,'k.');
quiver(l,-1.7,0,1,0.4,'k.');
txt = 'l total';
text(0.4*l,-1.7,txt)

quiver(a/2,-1,-1,0,a/2,'k');
quiver(a/2,-1,1,0,a/2,'k');
quiver(0,-1.2,0,1,0.4,'k.');
quiver(a,-1.2,0,1,0.4,'k.');
txt = 'a';
text(a/2,-1.2,txt)

quiver(l-0.5*b,-1,-1,0,0.5*b,'k');
quiver(l-0.5*b,-1,1,0,0.5*b,'k');
quiver(l-b,-1.2,0,1,0.4,'k.');
quiver(l,-1.2,0,1,0.4,'k.');
txt = 'b';
text(l-0.5*b,-1.2,txt)

quiver(0,1.5,1,0,d,'k.');
quiver(0,1.3,0,1,0.4,'k.');
quiver(d,1.3,0,1,0.4,'k.');
txt = 'di';
text(0.5*d,1.7,txt)

%% INGRESO DE DATOS DE LA GEOMETR�A DE LA VIGA
fprintf('<strong>1.GEOMETR�A DE LA VIGA Y DISTRIBUCION DE APOYOS</strong>\n\n')
%La viga de ingreso se va graficando en tiempo real conforme el usuario ingrese los
%datos
subplot(3,1,2);
grid on;
hold on;
    %Ingreso de la longitud
fprintf('Porfavor ingrese los siguientes datos seg�n el gr�fico mostrado:\n')
l=input('l total(en metros): ');
%Con el l ingresado se grafica la viga
txttitle=['VIGA DE ',num2str(l),' METROS SIMPLEMENTE APOYADA'];
title(txttitle);
axis([-0.3*l 1.3*l -3 3]);
coordxviga=[0,0,l,l,0];%Se definen los puntos para graficar la viga
coordyviga=[0,0.25,0.25,0,0];
viga=polyshape(coordxviga,coordyviga);%Se definen la viga como un pol�gono;
plot(viga);%Representacion grafica de la viga
quiver(0,-1.5,1,0,l,'k.');
quiver(0,-1.7,0,1,0.4,'k.');
quiver(l,-1.7,0,1,0.4,'k.');
txt = [num2str(l),' m'];
text(0.45*l,-1.7,txt)
    %Ingreso de a
a=input('a(en metros): ');
plot(a,-0.1*l,'k^','linewidth',2);%Representacion grafica del primer apoyo
text(a,-0.4*l,'R1')
if a>0
quiver(a/2,-1,-1,0,a/2,'k');
quiver(a/2,-1,1,0,a/2,'k');
quiver(0,-1.2,0,1,0.4,'k.');
quiver(a,-1.2,0,1,0.4,'k.');
txt = [num2str(a),' m'];
text(a/4,-1.2,txt)
end
    %Ingreso de b
b=input('b(en metros): ');
plot(l-b,-0.1*l,'k^','linewidth',2);%Representacion grafica del segundo apoyo
text(l-b,-0.4*l,'R2')
if b>0
quiver(l-0.5*b,-1,-1,0,0.5*b,'k');
quiver(l-0.5*b,-1,1,0,0.5*b,'k');
quiver(l-b,-1.2,0,1,0.4,'k.');
quiver(l,-1.2,0,1,0.4,'k.');
txt = [num2str(b),' m'];
text(l-0.75*b,-1.2,txt)
end
%% INGRESO DE LOS DATOS DE LAS CARGAS CONCENTRADAS
fprintf('\n<strong>2.DISTRIBUCI�N DE LAS CARGAS CONCENTRADAS</strong>\n\n')
Np=input('<strong>Ingrese el n�mero de cargas concentadas:</strong>');
%Se definen dos matrices verticales de Np*1 elementos que almacenaran los
%datos de las cargas
Modulo = zeros(Np,1);
Distancias = zeros(Np,1);
%Se establece una iterativa para pedir los datos de cada carga
i=1;
while i<=Np
    centinela=0;%Se define una variable centinela para evaluar el caso de ingreso de un dato erroneo
    while centinela==0
        fprintf('<strong>CARGA N�MERO %d: </strong> \n',i);
        d=input('d(en metros): ');
        if d<=l%Condicion que evalua el centinela%
            centinela=1;
            %Si se pasa el filtro, se procede a almacenar el dato de la
            %distancia en las matrices antes creadas y a solicitar el m�dulo
            Distancias(i,1)=d;
            P=input('P(en Newtons,positivo hacia abajo): ');
            Modulo(i,1)=P;
            %Se grafica la carga en el gr�fico antes abierto
            txt = ['',num2str(P),'N'];
            text(d,2.25,txt)
            quiver(d,2.25,0,-1,2,'b','linewidth',1.5);
            i=i+1;
        else %Si no se pasa el filtro, aparece un mensaje de error, y se regresa al comienzo de la iterativa
            centinela=0;
            fprintf('\nERROR:La distancia de aplicaci�n no puede superar la longitud de la viga, reingrese datos.\n\n');
        end
    end
end
fprintf('\n');

%% INGRESO DE LOS DATOS DE LAS CARGAS DISTRIBUIDAS
fprintf('<strong>3.DISTRIBUCION DE LAS CARGAS LINEALMENTE DISTRIBUIDAS</strong>\n\n')
Nw=input('<strong>Ingrese el numero de cargas distribuidas:</strong>');
%Se definen tres matrices verticales de Nw*1 elementos que almacenaran los
%datos de las cargas distribuidas
W = zeros(Nw,1);
D1 = zeros(Nw,1);
D2 = zeros(Nw,1);
%Se establece una iterativa para pedir los datos de cada carga
i=1;
while i<=Nw %INGRESO DE CARGAS%kn
    centinela=0;%Se define una variable centinela para evaluar el caso de ingreso de un dato erroneo%
    while centinela==0
        fprintf('<strong>CARGA DISTRIBUIDA NUMERO %d: </strong> \n',i);
        d1i=input('Ingrese la distancia desde el extremo izquierdo hasta el primer punto(m):');
        d2i=input('Ingrese la distancia desde el extremo izquierdo hasta el segundo punto(m):');
        if d1i<=l && d2i<=l %Condicion que evalua el centinela%
            %Si se pasa el filtro, se procede a almacenar el dato de la
            %distancia en las matrices antes creadas y a solicitar el m�dulo
            centinela=1;
            D1(i,1)=d1i;
            D2(i,1)=d2i;
            wi=input('Ingrese la magnitud de la carga distribuida por metro lineal (N/m)[Positivo hacia abajo]: ');
            W(i,1)=wi;
            %Se grafica la carga en el gr�fico antes abierto%
            txt = ['',num2str(wi),'N/m'];
            text(d1i+((d2i-d1i)/2),2,txt);
            for k=d1i:0.1:d2i%para graficar varias flechas para la carga distribuida se aplica una iterativa%
            quiver(k,1.25,0,-1,'k');
            end
            i=i+1;
            plot([d1i,d2i],[1.25,1.25],'k');
        else %Si no se pasa el filtro, aparece un mensaje de error, y se regresa al comienzo de la iterativa.%
            centinela=0;
            fprintf('<strong>\n ERROR:La distancia de aplicaci�n no puede superar la longitud de la viga, reingrese datos.</strong>\n\n');
        end
    end
end
fprintf('\n');

%% EST�TICA: SOLUCION A LAS REACCIONES
syms R2;
syms R1;
%Se procede a concatenar los datos recopilados a dos matrices: Distanciastot y Cargastot,para luego llevarlas a la ecuacion de
%equilibrio con respecto al primer apoyo y luego resolverlas.
%Concatenacion de los datos de cargas concentradas:
DistanciasR1=Distancias-a;
lRB=(l-b-a);
Distanciastot=vertcat(DistanciasR1,lRB);
Cargastot=vertcat(Modulo,-R2);%se concatena la inc�gnita%
%Concatenacion de los datos de cargas distribuidas:
longcarga=D2-D1;
Fequiv=longcarga.*W;
distFequiv=(longcarga/2)+D1-a;
Cargastot=vertcat(Cargastot,Fequiv);
Distanciastot=vertcat(Distanciastot,distFequiv);
%Planteo de ecuacion de equilibrio rotacional(con respecto al primer apoyo)%
Momentos=Distanciastot.*Cargastot;
equilibriotras=sum(Momentos)==0;%sumatoria de momentos=0%
solequilibriotras=solve(equilibriotras);
R2=eval(solequilibriotras);%se halla R2%
%Planteo de ecuacion de traslacional en eje Y(con respecto al primer apoyo)%
equilibriotras=sum(Cargastot)+R1==0;%sumatoria de fuerzas=0%
solequilibriotras=solve(equilibriotras);
R1=-eval(solequilibriotras);%se halla R1%
%Con los valores de R1 y R2, se plotean en el gr�fico.
txtR1 = ['= ',num2str(R1),' N'];%muestra resultados en el gr�fico%
txtR2 = ['= ',num2str(R2),' N'];%muestra resultados en el gr�fico%
text(0.0625*l,-0.4*l,txtR1);%muestra resultados en el gr�fico%
text((l-b)+0.0625*l,-0.4*l,txtR2);%muestra resultados en el gr�fico%

%% CALCULOS PARA LOS GR�FICOS DE FUERZAS INTERNAS%
%Para el calculo de los gr�ficos se divide la viga en infinitesimales de
%longitud 0.001 para cada cual hay una cortante producida por ya sea por los apoyos,
%las cargas concentradas y/o las cargas distribuidas. Al plotear la posicion de
%cada infinitesimal y la sumatoria de todas estas cortantes se genera visualmente la
%curva de los diagramas.
dx=0.001;
posicion=0:dx:l;%se crea la matriz posicion que va desde 0 hasta "l" espaciando una longitud de 0.001.
                       %FUERZA CORTANTE%
Ncortantes=(l/dx)+1;%es el numero de cortantes infinitesimales para las cuales se repetira la iterativa
%CONTRIBUCION DE LAS REACCIONES%
DIFreacciones=zeros(1,Ncortantes);
for inf=1:Ncortantes
    DIFcortantes=zeros(1,Ncortantes);
    if inf<=((a/dx)+1)
        DIFcortantes(inf)=0;
    elseif inf<=((l-b)/dx)+1
        DIFcortantes(inf)=R1;
    else
        DIFcortantes(inf)=R1+R2;
    end
    DIFreacciones=DIFreacciones+DIFcortantes;
end
%CONTRIBUCION DE LAS CARGAS CONCENTRADAS%
DIFcargastot=zeros(1,Ncortantes);
for Ncarga=1:Np
    DIFcarga=zeros(1,Ncortantes);
    for inf=1:Ncortantes
        DIFcortantes=zeros(1,Ncortantes);

        if inf<=(Distancias(Ncarga,1)/dx)+1
            DIFcortantes(inf)=0;
        else
            DIFcortantes(inf)=-Modulo(Ncarga,1);
        end
    DIFcarga=DIFcarga+DIFcortantes;
    end
    DIFcargastot=DIFcargastot+DIFcarga;
end
%CONTRIBUCION DE LAS CARGAS DISTRIBUIDAS%
DIFdistribuidastot=zeros(1,Ncortantes);
for Ncarga=1:Nw
    DIFdistribuidas=zeros(1,Ncortantes);
    for inf=1:Ncortantes
        DIFcortantes=zeros(1,Ncortantes);
        if inf<=(D1(Ncarga,1)/dx)+1
            DIFcortantes(inf)=0;
        elseif inf>(D1(Ncarga,1)/dx)+1 && inf<=(D2(Ncarga,1)/dx)+1
            x=dx*inf;
            dl=x-D1(Ncarga,1);
            DIFcortantes(inf)=-W(Ncarga,1)*dl;
        else
            DIFcortantes(inf)=-Fequiv(Ncarga,1);
        end
    DIFdistribuidas=DIFdistribuidas+DIFcortantes;
    end
DIFdistribuidastot=DIFdistribuidastot+DIFdistribuidas;
end
%Suma de contribuciones:
Cortantes=DIFreacciones+DIFcargastot+DIFdistribuidastot;
                        %MOMENTO FLECTOR%
%%Como ya tenemos cada cortante infinitesimal,el momento flector solo se define
%como las las areas diferenciales del grafico de cortantes%%
DIFmomentos=zeros(1,Ncortantes);
for inf=2:Ncortantes
    DIFmomentos(inf)=DIFmomentos(inf-1)+Cortantes(inf)*dx;%se le va sumando cada
    %peque�a area diferencial%
end
%Finalmente se voltean las matrices de diferenciales para su mejor manejo
%al momento de plotearlas
posicion=horzcat(posicion,l);
Cortantes=horzcat(Cortantes,0);
DIFmomentos=horzcat(DIFmomentos,0);
%% INGRESO DE DATOS DE LA SECCI�N TRANSVERSAL
%Se piden los datos de la secci�n para el c�lculo de la inercia
fprintf('<strong>4.SECCI�N TRANSVERSAL</strong> \n\n')
bseccion=input('Ingrese el ancho de la secci�n (mm):');
pseccion=input('Ingrese el espesor de la secci�n (mm):');
fprintf('\n');
%% VIGA SOLUCIONADA
%Se vuelve a plotear la viga ta solucionada en otra ventana
figure('Name','FUERZAS INTERNAS EN VIGA SIMPLEMENTE APOYADA','NumberTitle','off','position',[0 0 tamano(3) tamano(4)]);
subplot(3,1,1);
grid on
hold on
txttitle=['VIGA DE ',num2str(l),' METROS SIMPLEMENTE APOYADA (',num2str(bseccion),'mm x',num2str(pseccion),' mm)'];
title(txttitle);
axis([-0.3*l 1.3*l -3 3]);
    %Representacion grafica de la viga
coordxviga=[0,0,l,l,0];%Se definen los puntos para graficar la viga
coordyviga=[0,0.25,0.25,0,0];
viga=polyshape(coordxviga,coordyviga);%Se definen la viga como un pol�gono;
plot(viga);
    %Cotas para l
quiver(0,-1.5,1,0,l,'k.');
quiver(0,-1.7,0,1,0.4,'k.');
quiver(l,-1.7,0,1,0.4,'k.');
txt = [num2str(l),' m'];
text(0.45*l,-1.7,txt)
    %Representacion grafica del primer apoyo
plot(a,-0.1*l,'k^','linewidth',2);
text(a,-0.4*l,'R1')
    %Cotas para a
if a>0
quiver(a/2,-1,-1,0,a/2,'k');
quiver(a/2,-1,1,0,a/2,'k');
quiver(0,-1.2,0,1,0.4,'k.');
quiver(a,-1.2,0,1,0.4,'k.');
txt = [num2str(a),' m'];
text(a/4,-1.2,txt)
end
    %Representacion grafica del segundo apoyo
plot(l-b,-0.1*l,'k^','linewidth',2);
text(l-b,-0.4*l,'R2')
    %Cotas para b
if b>0
quiver(l-0.5*b,-1,-1,0,0.5*b,'k');
quiver(l-0.5*b,-1,1,0,0.5*b,'k');
quiver(l-b,-1.2,0,1,0.4,'k.');
quiver(l,-1.2,0,1,0.4,'k.');
txt = [num2str(b),' m'];
text(l-0.75*b,-1.2,txt)
end
    %Resultados de las reacciones
txtR1 = ['= ',num2str(R1),' N'];%muestra resultados en el gr�fico%
txtR2 = ['= ',num2str(R2),' N'];%muestra resultados en el gr�fico%
text(0.0625*l,-0.4*l,txtR1);%muestra resultados en el gr�fico%
text((l-b)+0.0625*l,-0.4*l,txtR2);%muestra resultados en el gr�fico%
i=1;
    %Cotas para las fuerzas
while i<=Np
            d=Distancias(i,1);
            P=Modulo(i,1);
            %Se grafica la carga en el gr�fico antes abierto
            txt = ['',num2str(P),'N'];
            text(d,2.25,txt)
            quiver(d,2.25,0,-1,2,'b','linewidth',1.5);
            i=i+1;
end

%% PLOTEO DEL GR�FICO DE FUERZAS CORTANTES
%Calculo maximos m�nmos y ceros%
[Vmin,Vminlugar]=min(Cortantes);%comando que retorna el minimo valor de la matriz y su lugar en entero
[Vmax,Vmaxlugar]=max(Cortantes);%comando que retorna el maximo valor de la matriz y su lugar en entero
encontrado=0;
while encontrado==0 %iterativa para hallar la posicion del cero%
    for i=1:Ncortantes
        if Cortantes(i)==0
            encontrado=1;
            Vcerolugar=i;
        end
    end
end
Vmin=round(Vmin,2);%redondear a dos decimales%
Vmax=round(Vmax,2);%redondear a dos decimales%
Vminx=round((Vminlugar-1)*dx,2);%halla la posici�n x del Vmin y redondea a 2 decimales%
Vmaxx=round((Vmaxlugar-1)*dx,2);%halla la posici�n x del Vmax y redondea a 2 decimales%
Vcerox=round((Vcerolugar-1)*dx,2);%halla la posici�n x del cero y redondea a 2 decimales%
%Se calcula la cortante maxima absoluto
if abs(Vmax)>=abs(Vmin)
    Vmaxabs=Vmax;
else
    Vmaxabs=abs(Vmin);
end

%Nombres y escala a los ejes%
subplot(3,1,2);
hold on;
grid on;
axis([-0.3*l 1.3*l -Vmaxabs-Vmaxabs*0.5 Vmaxabs+Vmaxabs*0.5]);
xlabel('Posici�n(m)');
ylabel('Fuerza Cortante(N)');
title('DIAGRAMA DE FUERZA CORTANTE');

%Muestra en texto los puntos notables%
%Vmax
txtVmax=['Vmax= ',num2str(Vmax),' N'];
%txtVmaxx=['x= ',num2str(Vmaxx),'m'];
text(1.1*l,8/8*Vmaxabs,txtVmax);
%text(l+0.5*l,6/8*Vmaxabs,txtVmaxx);
%Vmin
txtVmin=['Vmin= ',num2str(Vmin),' N'];
%txtVminx=['x= ',num2str(Vminx),' m'];
text(1.1*l,2/8*Vmaxabs,txtVmin);
%text(l+0.5*l,0/8*Vmaxabs,txtVminx);
%Vcero
%txtVcero='V=0';
%txtVcerox=['x= ',num2str(Vcerox),' m'];
%text(l+0.5*l,-4/8*Vmaxabs,txtVcero);
%text(l+0.5*l,-6/8*Vmaxabs,txtVcerox);

%Por ultimo se plotea la viga...
coordxviga=[0,0,l,l,0];%Se definen los puntos para graficar la viga
coordyviga=[0,Vmax*0.1,Vmax*0.1,0,0];
viga=polyshape(coordxviga,coordyviga);%Se definen la viga como un pol�gono
plot(viga);
%Se plotean los soportes.
plot([a l-b], [-0.1*Vmaxabs -0.1*Vmaxabs],'k^','linewidth',2);
%Y finalmente se plotea la curva...
plot(posicion,Cortantes,'k');
%Notar que es un ploteo de varios puntos con coordenadas X de la matriz
%"posicion" y con coordenadas Y de la matriz "Cortantes"


%% PLOTEO DEL GR�FICO DE MOMENTOS FLECTORES
%Calculo maximos m�nmos y ceros%
[Mmin,Mminlugar]=min(DIFmomentos);
[Mmax,Mmaxlugar]=max(DIFmomentos);
encontrado=0;
while encontrado==0
    for i=1:Ncortantes
        if DIFmomentos(i)==0
            encontrado=1;
            Mcerolugar=i;
        end
    end
end%iterativa para hallar la posicion del cero%
Mminx=round((Mminlugar-1)*dx,2);
Mmaxx=round((Mmaxlugar-1)*dx,2);
Mcerox=round((Mcerolugar-1)*dx,2);
%Se calcula el momento flector maximo absoluto
if abs(Mmax)>=abs(Mmin)
    Mmaxabs=Mmax;
else
    Mmaxabs=abs(Mmin);
end

%Nombre y escala a los ejes
subplot(3,1,3);
hold on;
grid on;
axis([-0.3*l 1.3*l -Mmaxabs-Mmaxabs*0.5 Mmaxabs+Mmaxabs*0.5]);
xlabel('Posici�n(m)');
ylabel('Momento flector(N/m)');
title('DIAGRAMA DE MOMENTO FLECTOR');

%Muestra en texto los puntos notables%
    %Mmax
txtMmax=['Mmax= ',num2str(Mmax),' N.m'];
%txtMmaxx=['x= ',num2str(Mmaxx),'m'];
text(1.1*l,8/8*Mmaxabs,txtMmax);
%text(l+0.5*l,6/8*Mmaxabs,txtMmaxx);
    %Mmin
txtMmin=['Mmin= ',num2str(Mmin),' N.m'];
%txtMminx=['x= ',num2str(Mminx),' m'];
text(1.1*l,2/8*Mmaxabs,txtMmin);
%text(l+0.5*l,0/8*Mmaxabs,txtMminx);
    %Mcero
%txtMcero='M=0';
%txtMcerox=['x= ',num2str(Mcerox),' m'];
%text(l+0.5*l,-4/8*Mmaxabs,txtMcero);
%text(l+0.5*l,-6/8*Mmaxabs,txtMcerox);

%Por ultimo se plotea la viga..
coordxviga=[0,0,l,l,0];%Se definen los puntos para graficar la viga
coordyviga=[0,Mmaxabs*0.1,Mmaxabs*0.1,0,0];
viga=polyshape(coordxviga,coordyviga);%Se definen la viga como un pol�gono
plot(viga);
%..Se plotean los soportes...
plot([a l-b], [-0.1*Mmaxabs -0.1*Mmaxabs],'k^','linewidth',2);
%...Y finalmente se plotea la curva.
plot(posicion,DIFmomentos,'k');
%Notar que es un ploteo de varios puntos con coordenadas X de la matriz
%"posicion" y con coordenadas Y de la matriz "DIFmomentos"


%% RESULTADOS EN EL COMMAND WINDOW.
fprintf('<strong>           RESULTADOS:</strong>\n')
fprintf('<strong>Los valores de las reacciones son:</strong> \n');
fprintf('R1 = %1.2f N\n',R1);
fprintf('R2 = %1.2f N\n',R2);
fprintf('<strong>Las m�ximas fuerzas internas absolutas que experimentar� la viga son:</strong> \n');
fprintf('Vmaxabs = %1.2f N\n',Vmaxabs);
fprintf('Mmaxabs = %1.2f N.m\n',Mmaxabs);
fprintf('NOTA:Los gr�ficos estan adjuntos en la ventana de la viga.\n');
%Una vez que el usuario analiza los resultados de la est�tica y fuerzas
%internas se le consulta si quiere analizar la deflexi�n si esque ya ha realizado un ensayo
%previamente y que el programa le calule el m�dulo de elasticidad
input('<strong>---PRESIONE ENTER PARA ANALIZAR LA DEFLEXI�N, SE ABRIR� OTRA VENTANA PARA GRAFICOS---</strong>\n')
fprintf('ENSAYO 1: Viga sometida a flexi�n pura con dos cargas id�nticas en sus extremos.\n');
fprintf('ENSAYO 2: Viga sometida a flexi�n simple por una carga en su extremo.\n');
fprintf('ENSAYO 3: Viga sometida a flexi�n simple por una carga en el punto medio.\n\n');
tipo=input('Ingrese el tipo de ensayo realizado (1,2 o 3): ');
fprintf('\n');
if tipo==1
Deflexmax=input('Ingrese la deflexi�n m�xima que experiment� la viga en el ensayo(mm): ');
end
if tipo==2
Deflexmax=input('Ingrese la deflexi�n m�xima que experiment� la viga en el ensayo(mm): ');
end
if tipo==3
Deflexmax=input('Ingrese la deflexi�n m�xima que experiment� la viga en el ensayo(mm): ');
end
%% C�LCULO DE MODULO DE ELASTICIDAD
%Seg�n el tipo de ensayo el programa calulo el E, la formulaci�n se realiz�
%manualmente
Ix=1/12*(bseccion*pseccion^3);
if tipo==1
L_int=l-a-b;
E=((1000*Mmaxabs)*((L_int*1000)^2))/(8*Deflexmax*Ix);%Formula deducida manualmente
end
if tipo==2
L_int=l-a-b;
E=0.0642*(Mmaxabs*1000*(1000*L_int)^2)/(Deflexmax*Ix);%Formula deducida manualmente
end
if tipo==3
L_int=l-a-b;
E=(P*(L_int*1000)^3)/(48*Deflexmax*Ix);%Formula deducida manualmente
end
%% PLOTEO DE LA CURVA EL�STICA Y RESULTADO DE E.
%En una nueva ventana se plotea la curva el�stica
tamano=get(0,'ScreenSize');
figure('Name','DEFLEXI�N EN VIGA SIMPLEMENTE APOYADA','NumberTitle','off','position',[0 0 tamano(3) tamano(4)]);
grid on;
hold on;
subplot(3,1,2);
hold on;
grid on;
axis([-0.3*l 1.3*l -Deflexmax-Deflexmax*0.5 Deflexmax+Deflexmax*0.5]);
xlabel('Posici�n(m)');
ylabel('Deflexi�n (mm)');
title('DIAGRAMA DE DEFLEXI�N');
%Se plotea la viga
coordxviga=[0,0,l,l,0];%Se definen los puntos para graficar la viga
coordyviga=[0,Deflexmax*0.1,Deflexmax*0.1,0,0];
viga=polyshape(coordxviga,coordyviga);%Se definen la viga como un pol�gono
plot(viga);
%Se plotean los soportes.
plot([a l-b], [-Deflexmax*0.1 -Deflexmax*0.1],'k^','linewidth',2);
%...Y finalmente se plotea la curva el��tica dependiendo del tipo de ensayo.

if tipo==1
    for s=0:0.001:((l-a-b))
    xi=a+s;
    smm=s*1000;
    yi=(1000*Mmin*(smm)^2)/(2*E*Ix)-(1000*Mmin*(l-a-b)*(1000*smm))/(2*E*Ix);%formula deducida manualmente
    plot(xi,yi,'.','Color','r','MarkerSize',1.5);
    if s==(l-a-b)/2%condicional anidada para acotar la deflexion maxima
        Deflemax=yi;
        txt=['Deflexi�n m�xima= ',num2str(yi,3),' mm'];
        text(l/2+0.1*l,Deflemax,txt);
        txt=['E= ',num2str(E),' MPa'];
        text(l/2+0.1*l,1.2*Deflemax,txt);
    end
    end
end

if tipo==2 
    for s=0:0.001:(L_int)
    xi=s;
    smm=s*1000;
    yi=(1/(6*E*Ix))*(Mmaxabs*1000*(1000*L_int)^2)*((smm/(1000*L_int))-(smm/(1000*L_int))^3);%formula deducida manualmente producto de la segunda integral del momento flector
    plot(xi,yi,'.','Color','r','MarkerSize',1.5);
    end
    txt=['Deflexi�n m�xima= ',num2str(Deflexmax,3),' mm'];
    text(l/2+0.1*l,Deflexmax,txt);
    txt=['E= ',num2str(E),' MPa'];
    text(l/2+0.1*l,1.2*Deflexmax,txt);
end

if tipo==3
    for s=0:0.001:(0.5*L_int)
    xi=a+s;
    smm=s*1000;
    yi=(P*smm^3)*(1/(12*E*Ix))-(smm*P*(L_int*1000)^2)*(1/(16*E*Ix));%formula deducida manualmente producto de la segunda integral del momento flector
    plot(xi,yi,'.','Color','r','MarkerSize',1.5);
    end
    for s=0:0.001:(0.5*L_int)
    xi=a+s;
    smm=s*1000;
    yi=(P*smm^3)*(1/(12*E*Ix))-(smm*P*(L_int*1000)^2)*(1/(16*E*Ix));%formula deducida manualmente producto de la segunda integral del momento flector
    plot(-xi+2*a+L_int,yi,'.','Color','r','MarkerSize',1.5);
    end
    txt=['Deflexi�n m�xima= ',num2str(Deflexmax,3),' mm'];
    text(l/2+0.1*l,-Deflexmax,txt);
    txt=['E= ',num2str(E),' MPa'];
    text(l/2+0.1*l,-1.2*Deflexmax,txt);
end

%FIN DEL C�DIGO.

