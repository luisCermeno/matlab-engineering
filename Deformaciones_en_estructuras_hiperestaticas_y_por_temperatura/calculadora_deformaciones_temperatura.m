clear;
clc;
close all;

%% SALUDO %%
fprintf('<strong>                 PC3:CALCULADORA B�SICA DE DEFORMACIONES POR TEMPERATURA</strong> \n');
fprintf('<strong>luisCermeno</strong>\n');
fprintf('<strong>v2019</strong>\n');
fprintf('Los grupos de unidades con las que trabaja este programa son:\n');
fprintf('SI:\t\t\t\t\t\t\t(mm),(mm2),(MPa),(/�C)\n');
fprintf('Uso com�n en Estados Unidos:(in),(in2),(psi),(/�F)\n');
fprintf('Ingrese los datos utilizando �nicamente uno de estos grupos de unidades.\n');
fprintf('Los resultados estar�n en el grupo de unidades que usted eligi� para el ingreso.\n');

%% INGRESO DE DATOS POR EL USUARIO %%
datosok=0; %Se crea una variable centinela que verificara que los datos ingresados sean de la conformidad del usuario
while datosok==0%Esta iterativa ser� controlada por el centinela,si el usuario no esta conforme con sus datos, los podr� ingresar nuevamente.
    %% Elecci�n del modelo de problema %%
    centinela=0;%Este otro centinela con su respectiva iterativa verifican que el tipo de problema que usuario elige sea uno de los dos presentados.
    while centinela==0
        fprintf('<strong> \n�QU� TIPO DE PROBLEMA DESEA RESOLVER?</strong>\n');
        fprintf('1.Una barra (A) de n elementos sometida a un incremento de temperatura con una restricci�n en sus extremos.\n');
        fprintf('2.Dos barras opuestas (A y B) de n elementos sometidas a un incremento de temperatura.\n');
        tipo=input('Ingrese el tipo de problema: (escriba "1" o "2")\n');
        switch tipo
            case 1
            fprintf('<strong>                 BARRA "A" DE N ELEMENTOS SOMETIDA A UN CAMBIO DE TEMPERATURA CON UNA RESTRICCI�N EN SUS EXTREMOS</strong>\n')
            centinela=1;
            case 2
            fprintf('<strong>                 DOS BARRAS OPUESTAS "A y B" DE N ELEMENTOS SOMETIDAS A UN CAMBIO DE TEMPERATURA</strong> \n')
            centinela=1;
            otherwise
            fprintf('\n ERROR: TIPO DE PROBLEMA INCOREECTO ELIJA UNICAMENTE "1" o "2".\n\n');
            centinela=0;%Si el el tipo que el usuario elige no es ni 1 ni 2, entonces se le pedir� que ingrese nuevamente, la iterativa se repetir�.
        end
    end
    
    %% Ingreso de los datos (elementos de las barras y condiciones del medio)
    fprintf('<strong>1.INGRESO DE DATOS DE LA BARRA A</strong>\n')
    na=input('<strong>Ingrese el n�mero de elementos de la barra A:</strong> \n');
    fprintf('');
    %Se definen matrices verticales de na filas que almacenaran los datos de los elementos que conforman la barra A
    LongitudA = zeros(na,1);%Para las longitudes de cada elemento
    AreaA = zeros(na,1);%Para las areas transversales de cada elemento
    EA = zeros(na,1);%Para los m�dulos de elasticidad de cada elemento
    CoefA = zeros(na,1);%Para los coeficientes de dilataci�n t�rmica de cada elemento
    DeformacionesA = zeros(na,1);%Para las deformaciones de cada elemento
    %La matriz para esfuerzos en cada elemento se definir� al momento de hacer los c�lculos
    fprintf('Por favor ingrese los siguientes datos para cada elemento:(separados por un espacio y encerrados por corchetes)\n');
    fprintf('[Longitud �rea_transversal M�dulo de elasticidad Coeficiente_de_dilataci�n_t�rmica]\n');
    fprintf('Ejemplo de formato para ingreso: [250 706.858 200000 0.0000117]\n');
    %Se establece una iterativa para pedir los datos de cada elemento
    for i=1:na
        fprintf('<strong>Elemento n�mero %d: </strong> \n',i);
        datos=input('Datos: ');%Se pide una matriz de ingreso
        LongitudA(i,1)=datos(1);%Los elementos de la matriz de ingreso... 
        AreaA(i,1)=datos(2);%...se van almacenando en los espacios...
        EA(i,1)=datos(3);% ...de las matrices creadas anteriormente
        CoefA(i,1)=datos(4);
    end
    %Si el usuario ha elegido trabajar con dos barras opuestas se procede a
    %pedir los datos de la barra B. Se sigue el mismo procedimiento que para la
    %barra A.
    if tipo==2    
        fprintf('<strong> \n1.INGRESO DE DATOS DE LA BARRA B</strong>\n')
        nb=input('<strong>Ingrese el n�mero de elementos de la barra B:</strong> \n');
        fprintf('');
        LongitudB = zeros(nb,1);
        AreaB = zeros(nb,1);
        EB = zeros(nb,1);
        CoefB = zeros(nb,1);
        DeformacionesB = zeros(nb,1);
        for i=1:nb
            fprintf('<strong>Elemento n�mero %d: </strong> \n',i);
            datos=input('Datos: ');
            LongitudB(i,1)=datos(1);
            AreaB(i,1)=datos(2);
            EB(i,1)=datos(3);
            CoefB(i,1)=datos(4);
        end
    end
    %Se piden los datos de temperatura y separaciones
    fprintf('<strong> \n2.INGRESO DE DATOS DE LA CONFIGURACI�N DEL MEDIO</strong>\n')
    deltaT=input('Ingrese la variaci�n de temperatura:(positivo es un incremento y negativo es una disminuci�n)\n');

    switch tipo
        case 1
    s=input('Ingrese la separaci�n entre la barra y la pared r�gida:\n');
        case 2
    s=input('Ingrese la separaci�n entre las barras:\n');
    end
    
    %% Impresi�n de los datos ingresados
    %Todos los comandos son con prop�sito de formato de impresi�n para lograr que el
    %usuario reconozca los datos que ingres�, considero trivial su
    %explicaci�n.
    fprintf('<strong> \n3.DATOS INGRESADOS</strong>\n');
    fprintf('<strong>TIPO DE PROBLEMA A RESOLVER:\n</strong>');
    switch tipo
        case 1
        fprintf('Una barra (A) de %2d elementos sometida a un incremento de temperatura con una restricci�n en sus extremos.\n',na);

        case 2
        fprintf('Dos barras opuestas (A y B) de %2d y %2d elementos respectivamente sometidas a un incremento de temperatura.\n',na,nb);
    end
    fprintf('<strong>PARA BARRA A:\n</strong>');
    fprintf('Elemento\tLongitud(mm,in)\tArea(mm2,in2)\tM�dulo de elasticidad(MPa,psi)\tCoeficiente de dilataci�n t�rmica(/�C,/�F)\n');
    for i=1:na
     fprintf('%2d\t\t\t %8.3f\t\t %8.3f\t\t%10.2e\t\t\t\t\t%10.2e \n',i,LongitudA(i,1),AreaA(i,1),EA(i,1),CoefA(i,1));   
    end

    if tipo==2
        fprintf('<strong>PARA BARRA B:\n</strong>');
        fprintf('Elemento\tLongitud(mm,in)\tArea(mm2,in2)\tM�dulo de elasticidad(MPa,psi)\tCoeficiente de dilataci�n t�rmica(/�C,/�F)\n');
        for i=1:nb
         fprintf('%2d\t\t\t %8.3f\t\t %8.3f\t\t%10.2e\t\t\t\t\t%10.2e \n',i,LongitudB(i,1),AreaB(i,1),EB(i,1),CoefB(i,1));   
        end
    end
    switch tipo
        case 1
        fprintf('<strong>CONFIGURACI�N DEL MEDIO:\n</strong>');
        fprintf('Variaci�n de temperatura(�C,�F)\tSeparaci�n con la pared r�gida(mm,in)\n');
        fprintf('%8.3f\t\t\t\t\t\t%8.3f\n',deltaT,s);
        case 2
        fprintf('<strong>CONFIGURACI�N DEL MEDIO:\n</strong>');
        fprintf('Variaci�n de temperatura(�C,�F)\tSeparaci�n entre las barras(mm,in)\n');
        fprintf('%8.3f\t\t\t\t\t\t%8.3f\n',deltaT,s);
    end
    
    %% Verifiaci�n los datos ingresados
    fprintf('<strong> \n�Los datos ingresados son correctos?</strong>\n');
    datosok=input('1:SI,SON CORRECTOS. 0:NO,QUIERO REINGRESAR LOS DATOS.\n');%Aqu� el usuario ingresar� el valor de la variable centinela creada al principio
    %Si la variable es 1, pasar� la condicion de la iterativa y se
    %procedera a realizar los c�lculos
    %Si es 0,entonces se repetir� TODO el ingreso de datos.
end

%% C�LCULOS
    %% C�lculo de las deformaciones de cada barra utilizando el principio de superposici�n.
    %Para la barra A:
    
    %Deformacion en ESTADO I (solamente por variacion de temperatura)
    deftempA=0;
    for i=1:na%Sumatoria de todas las deformaciones de cada elemento
    defn=deltaT*CoefA(i,1)*LongitudA(i,1);
    deftempA=deftempA+defn;
    end
    %Deformacion en ESTADO II (solamente por fuerzas de compresi�n.)
    defcompresionA=0;
    syms R;
    for i=1:na%Sumatoria de todas las deformaciones de cada elemento
    defn=-(R*LongitudA(i,1))/(EA(i,1)*AreaA(i,1));
    defcompresionA=defcompresionA+defn;
    end
    %SUPERPOSICION DE ESTADOS
    deltaA=defcompresionA+deftempA;
    deftempB=0;%Notar que la deformaci�n de B por temperatura es cero si se se ha elegido el tipo 1, de la misma forma
    % su deformacion total de esta forma no afectara a la ecuaci�n de compatibilidad.
    deltaB=0;
    
    %Para la barra B (unicamente si es que se ha elegido el tipo 2 de problema):
    
    if tipo==2
        %Deformacion en ESTADO I (solamente por variacion de temperatura)
        deftempB=0;
        for i=1:nb
            defn=deltaT*CoefB(i,1)*LongitudB(i,1);
            deftempB=deftempB+defn;
        end
        %Deformacion en ESTADO II (solamente por fuerzas de compresi�n.)
        defcompresionB=0;
        for i=1:nb
            defn=-(R*LongitudB(i,1))/(EB(i,1)*AreaB(i,1));
            defcompresionB=defcompresionB+defn;
        end 
        %SUPERPOSICION DE ESTADOS
        deltaB=defcompresionB+deftempB;%Si se ha elegido el tipo 2 de problema
        %la deformaci�n en B si tomar� un valor/
    end
    %% SOLUCI�N PARA R.
    if deftempA+deftempB>s %Verificacion que la deformacion por temperatura sobrepasa la separacion.
        %Planteo y soluci�n de la ecuaci�n de compatibilidad para hallar la fuerza de compresi�n
        compatibilidad=deltaA+deltaB==s;
        R=eval(solve(compatibilidad,R));%Se halla la fuerza de compresion "R".
    else
        R=0;%En caso contrario R ser� cero y no habr�n esfuerzos en las barras.
    end
    
    %% C�lculo de los esfuerzos y deformaciones para las barras
    %Para la barra A:
    EsfuerzosA=-R./AreaA;%Reci�n se crea la matriz de esfuerzos%
    DeformaciontotalA=0;
    for i=1:na%Iterativa con dos fines:
    DeformacionesA(i,1)=deltaT*CoefA(i,1)*LongitudA(i,1)-(R*LongitudA(i,1))/(EA(i,1)*AreaA(i,1));%Halla la deformacion de cada elemento
    DeformaciontotalA=DeformaciontotalA+DeformacionesA(i,1);%Los acumula para halla la deformaci�n total de la barra A.
    end
    %Para la barra B (unicamente si es que se ha elegido el tipo 2 de problema):
    %El c�lculo es id�ntico%
    if tipo==2
        EsfuerzosB=-R./AreaB;    
        DeformaciontotalB=0;
        for i=1:nb
        DeformacionesB(i,1)=deltaT*CoefB(i,1)*LongitudB(i,1)-(R*LongitudB(i,1))/(EB(i,1)*AreaB(i,1));
        DeformaciontotalB=DeformaciontotalB+DeformacionesB(i,1);
        end
    end

%% IMPRESI�N DE RESULTADOS
%Todos los comandos son con prop�sito de formato de impresi�n para lograr que el
%usuario reconozca lea e interprete los resultados calculados anteriormente, considero trivial su
%explicaci�n.

fprintf('<strong> \n4.RESULTADOS:</strong>\n')
switch tipo
    case 1   
        fprintf('La fuerza de compresi�n que experimenta la barra A es de: %8.3f (N,lb) \n',R);
        fprintf('La deformaci�n total que experimenta la barra A es de:%8.3f (mm,in) \n',DeformaciontotalA);
        fprintf('Elemento\tEsfuerzo(MPa,psi)\tDeformaci�n(mm,in)\n');
        for i=1:na
         fprintf('%2d\t\t\t %8.3f\t\t%8.3f\n',i,EsfuerzosA(i,1),DeformacionesA(i,1));   
        end
    case 2
        fprintf('La fuerza de compresi�n que experimentan las barras es de: %8.3f (N,lb) \n',R);
        fprintf('La deformaci�n total que experimenta la barra A es de:%8.3f (mm,in) \n',DeformaciontotalA);
        fprintf('La deformaci�n total que experimenta la barra B es de:%8.3f (mm,in) \n',DeformaciontotalB);
        fprintf('<strong>PARA BARRA A:\n</strong>');
        fprintf('Elemento\tEsfuerzo(MPa,psi)\tDeformaci�n(mm,in)\n');
        for i=1:na
         fprintf('%2d\t\t\t %8.3f\t\t%8.3f\n',i,EsfuerzosA(i,1),DeformacionesA(i,1));   
        end
        fprintf('<strong>PARA BARRA B:\n</strong>');
        fprintf('Elemento\tEsfuerzo(MPa,psi)\tDeformaci�n(mm,in)\n');
        for i=1:na
        fprintf('%2d\t\t\t %8.3f\t\t%8.3f\n',i,EsfuerzosB(i,1),DeformacionesB(i,1));   
        end
end
        
        
