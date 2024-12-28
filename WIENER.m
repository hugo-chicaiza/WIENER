% 6. La señal de entrada de un filtro adaptativo de primer orden se describe
% mediante 
% x(k)=sqrt(2)x1(k)+x2(k)+2*x3(k)
% donde x1(k) y x2(k) son procesos AR de primer orden y no correlacionados
% entre sí, teniendo ambos varianza unitaria. Estas señales se generan
% aplicando ruidos blancos distintos de primer orden cuyos polos se sitúan
% en -0.5 y sqrt(2)/2, respectivamente. La señal x3(k) es un ruido blanco
% con varianza unitaria y no correlacionada con x1(k) y x2(k)
% 1. Calcule la matriz de autocorrelación de la señal de entrada
% 2. Si la señal deseada está formada por (1/2)*x3(k), calcular la solución 
% de Wiener



%% Proceso AR con ruido blanco
close all;
clear all;
%Creación de ruido del proceso AR
randn('state',0)
%Longitud de la señal
N=2;
M=N; % M es el orden del filtro
a1=sqrt(2); a2=0.99;
u=0;
for var=0.1:0.05:1
    
    %Modelamiento proceso AR
    %Fórmulas obtenidas del libro de Diniz para modelamiento con polos;
    s1=-0.5; s2=(sqrt(2))/2;
    x1=randn(1,1);
    x2=randn(1,1);
    for n=2:N
        x1(n,1)=s1*x1(n-1)+sqrt(var-s1.^2)*randn(1,1);
        x2(n,1)=s2*x2(n-1)+sqrt(var-s2.^2)*randn(1,1);
    end
    %Ruido de la señal x3, generación
    x3=wgn(N,1,0);
    %Sumatoría se las señales con ruido
    x=x1+x2+x3;
    
    % length sale para posiciones en la matriz, al ser toeplitz se genera vector;
    length=(0:(M-1));
    rterm=(a1^2*((1-s1)^2)*((-s1).^abs(length))/((1-s1^2)))+(a2^2*(1-s2)^2*((-s2).^abs(length))/((1-s2^2))+s1^2+s2);
    R=toeplitz(rterm);
    
    %Señal deseada
    d=1/2*x3;
    
    %Vector p;
    %P=zeros(1,M);
    P = mean(d .* x');
    
    %Filtro de Wiener
    wo=inv(R)*P';
    y=filter(wo,1,x);
    %wo=[7/48;-1/48];
    %Gráficos de resultados
    figure();
    plot(x); hold on;
    plot(y);plot (d);
    legend('x(k)','y(k)','d(k)');
    title ('Filtro de Wiener: Proceso AR con ruido blanco');
    hold on;
    ylabel('Amplitud de la señal')
    hold off
    
    figure();
    subplot(3,1,1)
    plot(abs(x)); hold on; title('Señal entrada X[k]:Proceso AR con ruido blanco')
    subplot(3,1,2)
    plot(abs(y)); hold on; title('Señal estimada Y[k]:Proceso AR con ruido blanco')
    subplot(3,1,3)
    plot(abs(d)); hold on; title('Señal deseada d[K]: Proceso AR con ruido blanco')
    
end