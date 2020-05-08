clear;
clc;
close all;
%% SALUDO E INGRESO DE DATOS DE LA GEOMETRIA DE LA VIGA
fprintf('<strong>                 CALCULADORA DE EQUILIBRIO DE VIGAS</strong> \n');
fprintf('<strong>luisCermeno</strong>\n');
fprintf('<strong>v2019</strong>\n');
fprintf('\n*****Se abrir� una ventana con el gr�fico de su viga, por favor no cerrarlo*****.\n');
fprintf('\n*****Mantener maximizado para una mejor experiencia*****.\n\n');
fprintf('<strong>1.GEOMETR�A DE LA VIGA Y DISTRIBUCION DE APOYOS</strong>\n\n')
l=input('Ingrese la medida del largo de la viga(m):\n');
a=input('Ingrese la distancia desde el extremo izquierdo hasta el primer apoyo(m): \n');
b=input('Ingrese la distancia desde el extremo derecho hasta el segundo apoyo(m):  \n');
%% GRAFICA PRELIMINAR DE LA VIGA PARA EL USUARIO
coordxviga=[0,0,l,l,0];%Se definen los puntos para graficar la viga
coordyviga=[0,0.25,0.25,0,0];
viga=polyshape(coordxviga,coordyviga);%Se definen la viga como un pol�gono
tamano=get(0,'ScreenSize');
figure('position',[tamano(3)/2 0 tamano(3)/2 tamano(4)]);
subplot(3,1,1);
grid on;
hold on;
plot([a l-b], [-0.1 -0.1],'k^','linewidth',2);
plot(viga);%Representacion grafica de la viga
axis([-1 (l+1) -3 3])
txttitle=['VIGA DE ',num2str(l),' METROS SIMPLEMENTE APOYADA'];
title(txttitle);
text(a,-1,'R1')
text(l-b,-1,'R2')
quiver(a,-1.5,0,1,1.5,'k.','linewidth',1.5)%Representacion grafica de reacciones
quiver(l-b,-1.5,0,1,1.5,'k.','linewidth',1.5)%Representacion grafica de reacciones
%% INGRESO DE LOS DATOS DE LAS CARGAS CONCENTRADAS
fprintf('<strong>2.DISTRIBUCI�N DE LAS CARGAS CONCENTRADAS</strong> \n\n')
Np=input('<strong>Ingrese el n�mero de cargas concentadas:</strong> \n');
fprintf('\n');
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
        d=input('Ingrese la distancia desde el extremo izquierdo hasta el punto de aplicaci�n (m):  \n');
        if d<=l%Condicion que evalua el centinela%
            centinela=1;
            %Si se pasa el filtro, se procede a almacenar el dato de la
            %distancia en las matrices antes creadas y a solicitar el m�dulo
            Distancias(i,1)=d;
            P=input('Ingrese la magnitud de la carga vertical (N):[Positivo hacia abajo]\n');
            fprintf('\n');
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

%% INGRESO DE LOS DATOS DE LAS CARGAS DISTRIBUIDAS
fprintf('<strong>3.DISTRIBUCION DE LAS CARGAS LINEALMENTE DISTRIBUIDAS</strong> \n\n')
Nw=input('<strong>Ingrese el numero de cargas distribuidas:</strong> \n');
fprintf('\n');
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
        d1i=input('Ingrese la distancia desde el extremo izquierdo hasta el primer punto(m):  \n');
        d2i=input('Ingrese la distancia desde el extremo izquierdo hasta el segundo punto(m): \n');
        if d1i<=l && d2i<=l %Condicion que evalua el centinela%
            %Si se pasa el filtro, se procede a almacenar el dato de la
            %distancia en las matrices antes creadas y a solicitar el m�dulo
            centinela=1;
            D1(i,1)=d1i;
            D2(i,1)=d2i;
            wi=input('Ingrese la magnitud de la carga distribuida por metro lineal (N/m):[Positivo hacia abajo] \n');
            fprintf('\n');
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

%% SOLUCION A LAS REACCIONES
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
%MUESTRA RESULTADOS%
fprintf('<strong>           RESULTADOS:</strong> \n\n\n')
fprintf('<strong>Los valores de las reacciones son:</strong> \n');
fprintf('R1 = %1.2f\n',R1);
fprintf('R2 = %1.2f\n',R2);
fprintf('\n*****Los gr�ficos estan adjuntos en la ventana de la viga*****.\n\n');
txtR1 = ['=',num2str(R1),' N'];%muestra resultados en el gr�fico%
txtR2 = ['=',num2str(R2),' N'];%muestra resultados en el gr�fico%
text(a+0.2,-1,txtR1);%muestra resultados en el gr�fico%
text(l-b+0.2,-1,txtR2);%muestra resultados en el gr�fico%
%% CALCULO DE GR�FICOS DE FUERZAS INTERNAS%
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
%% MOSTRAR GR�FICOS
subplot(3,1,2);
hold on;
plot(viga);
posicion=horzcat(posicion,l);
Cortantes=horzcat(Cortantes,0);
DIFmomentos=horzcat(DIFmomentos,0);
plot(posicion,Cortantes,'k');
plot([a l-b], [-0.1 -0.1],'k^','linewidth',2);
grid on;
%FORMATO PARA EL GRAFICO DE CORTANTES%
%Calculo y Muestra de maximos m�nmos y ceros%
[Vmin,Vminlugar]=min(Cortantes);
[Vmax,Vmaxlugar]=max(Cortantes);
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
Vmax=round(Vmax,2);
Vminx=round((Vminlugar-1)*dx,2);
Vmaxx=round((Vmaxlugar-1)*dx,2);
Vcerox=round((Vcerolugar-1)*dx,2);
%Muestra en texto los puntos notables%
txtVmax=['Vmax= ',num2str(Vmax),' N'];
txtVmaxx=['x= ',num2str(Vmaxx),'m'];
text(l+0.5,Vmax,txtVmax);
text(l+0.5,7/8*Vmax,txtVmaxx);
txtVmin=['Vmin= ',num2str(Vmin),' N'];
txtVminx=['x= ',num2str(Vminx),' m'];
text(l+0.5,1/2*Vmax,txtVmin);
text(l+0.5,3/8*Vmax,txtVminx);
txtVcero=['V=0, x= ',num2str(Vcerox),' m'];
text(l/2,1,txtVcero);
%Nombres a los ejes%
axis([-1 l+1 Vmin-1 Vmax+1]);
xlabel('Posici�n(m)');
ylabel('Fuerza Cortante(KN)');
title('Diagrama de fuerzas cortantes');

%FORMATO PARA EL GRAFICO DE Momentos%
%todos los comandos son similares al grafico de cortantes.
subplot(3,1,3);
hold on;
plot(viga);
plot(posicion,DIFmomentos,'k');
plot([a l-b], [-0.1 -0.1],'k^','linewidth',2);
grid on;
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
end
Mmin=round(Mmin,2);
Mmax=round(Mmax,2);
Mminx=round((Mminlugar-1)*dx,2);
Mmaxx=round((Mmaxlugar-1)*dx,2);
Mcerox=round((Mcerolugar-1)*dx,2);
txtMmax=['Mmax= ',num2str(Mmax),' N/m'];
txtMmaxx=['x= ',num2str(Mmaxx),'m'];
text(l+0.5,Mmax,txtMmax);
text(l+0.5,7/8*Mmax,txtMmaxx);
txtMmin=['Mmin= ',num2str(Mmin),' N/m'];
txtMminx=['x= ',num2str(Mminx),' m'];
text(l+0.5,1/2*Mmax-6,txtMmin);
text(l+0.5,3/8*Mmax-8,txtMminx);
txtMcero=['M=0, x= ',num2str(Mcerox),' m'];
text(l/2,1,txtMcero);
axis([-1 l+1 min(DIFmomentos)-1 max(DIFmomentos+1)]);
xlabel('Posici�n(m)');
ylabel('Momento flector(KN/m)');
title('Diagrama de momento flector');



