% 6. La se�al de entrada de un filtro adaptativo de primer orden se describe
% mediante 
% x(k)=sqrt(2)x1(k)+x2(k)+2*x3(k)
% donde x1(k) y x2(k) son procesos AR de primer orden y no correlacionados
% entre s�, teniendo ambos varianza unitaria. Estas se�ales se generan
% aplicando ruidos blancos distintos de primer orden cuyos polos se sit�an
% en -0.5 y sqrt(2)/2, respectivamente. La se�al x3(k) es un ruido blanco
% con varianza unitaria y no correlacionada con x1(k) y x2(k)
% 1. Calcule la matriz de autocorrelaci�n de la se�al de entrada
% 2. Si la se�al deseada est� formada por (1/2)*x3(k), calcular la soluci�n 
% de Wiener



%% Proceso AR con ruido blanco
close all;
clear all;
%Creaci�n de ruido del proceso AR
randn('state',0)
%Longitud de la se�al
N=2;
M=N; % M es el orden del filtro
a1=sqrt(2); a2=0.99;
u=0;
for var=0.1:0.05:1
    
    %Modelamiento proceso AR
    %F�rmulas obtenidas del libro de Diniz para modelamiento con polos;
    s1=-0.5; s2=(sqrt(2))/2;
    x1=randn(1,1);
    x2=randn(1,1);
    for n=2:N
        x1(n,1)=s1*x1(n-1)+sqrt(var-s1.^2)*randn(1,1);
        x2(n,1)=s2*x2(n-1)+sqrt(var-s2.^2)*randn(1,1);
    end
    %Ruido de la se�al x3, generaci�n
    x3=wgn(N,1,0);
    %Sumator�a se las se�ales con ruido
    x=x1+x2+x3;
    
    % length sale para posiciones en la matriz, al ser toeplitz se genera vector;
    length=(0:(M-1));
    rterm=(a1^2*((1-s1)^2)*((-s1).^abs(length))/((1-s1^2)))+(a2^2*(1-s2)^2*((-s2).^abs(length))/((1-s2^2))+s1^2+s2);
    R=toeplitz(rterm);
    
    %Se�al deseada
    d=1/2*x3;
    
    %Vector p;
    %P=zeros(1,M);
    P = mean(d .* x');
    
    %Filtro de Wiener
    wo=inv(R)*P';
    y=filter(wo,1,x);
    %wo=[7/48;-1/48];
    %Gr�ficos de resultados
    figure();
    plot(x); hold on;
    plot(y);plot (d);
    legend('x(k)','y(k)','d(k)');
    title ('Filtro de Wiener: Proceso AR con ruido blanco');
    hold on;
    ylabel('Amplitud de la se�al')
    hold off
    
    figure();
    subplot(3,1,1)
    plot(abs(x)); hold on; title('Se�al entrada X[k]:Proceso AR con ruido blanco')
    subplot(3,1,2)
    plot(abs(y)); hold on; title('Se�al estimada Y[k]:Proceso AR con ruido blanco')
    subplot(3,1,3)
    plot(abs(d)); hold on; title('Se�al deseada d[K]: Proceso AR con ruido blanco')
    
end