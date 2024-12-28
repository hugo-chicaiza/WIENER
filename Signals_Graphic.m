% Parámetros
N = 1000; % Número de muestras

% Cargar dos archivos de audio (asegúrate de tener dos archivos de audio en formato WAV)
% [x, fs_x] = audioread('sonido.wav'); % Comentamos la carga de x desde un archivo de audio
[s, fs_s] = audioread('vocales.wav'); % Señal de entrada s(n)

% Generar una señal de ruido aleatorio para x
x = randn(size(s));

% Ajustar el tamaño de las señales si son de diferente longitud
min_len = min(length(x), length(s));
x = x(1:min_len);
s = s(1:min_len);

v = 1* s;
% Calcular energía de la señal
E = sum(v.^2);

% Calcular potencia de la señal
P = E /(2*N+1);

% Calcular el umbral Y en función de la potencia
ventana = 64; % Tamaño de la ventana para dividir la señal (puedes ajustar este valor)
solapamiento = 2; % Solapamiento entre ventanas (puedes ajustar este valor)

% Dividir la señal en tramos utilizando la función buffer
tramos = buffer(s, ventana, solapamiento);

% Calcular la varianza de cada tramo
vars = var(tramos);

% Graficar la varianza por tramo
figure(1);
plot(vars);
title('Varianza por Tramo');
xlabel('Número de Tramo');
ylabel('Varianza');

PFA = 0.0001; % Probabilidad de falsa alarma
Q_inv_PFA = qfuncinv(PFA); % Inversa de la función Q con PFA
Y = sqrt(vars * E) * Q_inv_PFA;

% Calcular T(x)
Tx = sum(x .* v);

% Graficar las señales de entrada y salida

figure(2);

subplot(3,1,1);
plot(s);
title('Señal de Entrada s(n)');
xlabel('Tiempo');
ylabel('Amplitud');

subplot(3,1,2);
plot(x);
title('Señal de Entrada x(n)');
xlabel('Tiempo');
ylabel('Amplitud');


subplot(3,1,3);
Tx_line = Tx * ones(size(Y));

plot([Y], 'r--', 'LineWidth', 1);
hold on;
plot(Tx_line, 'go', 'MarkerSize', 1, 'LineWidth', 2); % Línea verde para Tx
hold off;

xlabel('Tiempo');
ylabel('Variación del umbral');
title('Umbral y valor de Tx');
legend('Umbral Y', 'T(x)', 'Location', 'best');
% Mostrar la potencia calculada
disp(['La potencia de la señal es: ', num2str(P)]);
disp(['El umbral es: ', num2str(Y)]);
disp(['El valor de Tx: ', num2str(Tx)]);


% Identificar tramos donde Y es menor que Tx
% Encontrar las partes del umbral que son menores a Tx_line
% Encontrar las partes del umbral que son menores a Tx_line
superadas = Y < Tx_line;

% Sustituir las partes superadas por el valor específico
umbral_superado =  superadas;

% Crear una figura nueva para mostrar las partes superadas
figure(4);
plot(umbral_superado, 'b', 'LineWidth', 2);
title('Partes del Umbral Superadas por Tx');
xlabel('Tiempo');
ylabel('Valor');

% Mostrar las partes superadas en la figura principal
figure(2);
subplot(3,1,3);
hold on;
plot(umbral_superado, 'b', 'LineWidth', 2);
hold off;
legend('Umbral Y', 'T(x)', 'Partes Superadas', 'Location','best');

figure(5)
subplot(2,1,1);
plot(s*umbral_superado, 'b', 'LineWidth', 2);
title('Señal de Entrada s(n) con partes superadas por Tx');
xlabel('Tiempo');
ylabel('Amplitud');

subplot(2,1,2);
plot(x*umbral_superado, 'b', 'LineWidth', 2);
title('Señal de Entrada x(n) (Ruido Aleatorio) con partes superadas por Tx');
xlabel('Tiempo');
ylabel('Amplitud');
