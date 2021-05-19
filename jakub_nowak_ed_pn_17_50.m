%% ZADANIE Z EKSPLORACJI DANYCH JAKUB NOWAK PONIEDZIAŁEK GODZINA 17:50

clear all; close all; clc;
% Wczytanie danych
data = load('Dane_2021L.mat');
% Wybranie danych które będą analizowane (POLSKA/WĘGRY)
data_pl = data.values_PL;
data_hun = data.values_Hungary;



%% ZAD 1 

%Obliczenie przyrostów:
%% Absolutny / bezwzględny

figure(1)
tiledlayout(2,1)

abs_diff_pl = abs(diff(data_pl));
abs_diff_hun = abs(diff(data_hun));

ax1 = nexttile;
plot(abs_diff_pl)
title(ax1, 'Polska')
ylabel(ax1, 'Przyrost bezwzględny')

ax2 = nexttile;
plot(abs_diff_hun)
title(ax2, 'Węgry')
ylabel(ax2, 'Przyrost bezwzględny')


%% Względny

figure(2)
tiledlayout(2,1)

rel_diff_pl = diff(data_pl); % ./ data_pl(1:length(data_pl) - 1);
rel_diff_hun = diff(data_hun); %./ data_hun(1:length(data_hun) - 1);

ax1 = nexttile;
plot(rel_diff_pl)
title(ax1, 'Polska')
ylabel(ax1, 'Przyrost względny')

ax2 = nexttile;
plot(rel_diff_hun)
title(ax1, 'Węgry')
ylabel(ax1, 'Przyrost względny')


%% Logarmiczny

figure(3)
tiledlayout(2,1)

log_diff_pl = diff(log(data_pl));
log_diff_hun = diff(log(data_hun));

ax1 = nexttile;
plot(log_diff_pl)
title(ax1, 'Polska')
ylabel(ax1, 'Przyrost logarytmiczny')

ax2 = nexttile;
plot(log_diff_hun)
title(ax1, 'Węgry')
ylabel(ax1, 'Przyrost logarytmiczny')




%% Srednia & STD
mean_pl = mean(data_pl);
std_pl = std(data_pl);
err_pl = [mean_pl - std_pl, mean_pl + std_pl];

mean_hun = mean(data_hun);
std_hun = std(data_hun);
err_hun = [mean_hun - std_hun, mean_hun + std_hun];


%% ZAD 2
% Dopasowanie trendu liniowego
figure(4)
tiledlayout(2,1)

x_pl = linspace(0,length(data_pl),length(data_pl));
p_pl = polyfit(x_pl, data_pl, 1);
y_pl = polyval(p_pl, x_pl);
err_pl = sqrt(mean((y_pl-data_pl.').^2));

x_hun = linspace(0,length(data_hun),length(data_hun));
p_hun = polyfit(x_hun, data_hun, 1);
y_hun = polyval(p_hun, x_hun);
err_hun = sqrt(mean((y_hun-data_hun.').^2));

ax1 = nexttile;
plot(data_pl)
hold on
plot(x_pl, y_pl)
title(ax1, 'Polska dopasowanie liniowe, błąd dopasowania = ', num2str(err_pl));
hold off
grid on

ax2 = nexttile;
plot(data_hun)
hold on
plot(x_hun, y_hun)
title(ax2, 'Węgry dopasowanie liniowe, błąd dopasowania = ', num2str(err_hun))
hold off
grid on

%Jak widać błąd jest ponad dwukrotnie niższy dla dopasowania trendu
%liniowego dla danych dla Węgier.

%% ZAD3
% Moving average
figure(5);
tiledlayout(2,1)
k = [5, 22];
ma_pl_5 = movmean(data_pl, k(1));
err_ma_pl_5 = sqrt(mean((ma_pl_5.'-data_pl.').^2));
ma_pl_22 = movmean(data_pl, k(2));
err_ma_pl_22 = sqrt(mean((ma_pl_22.'-data_pl.').^2));
ma_hun_5 = movmean(data_hun, k(1));
err_ma_hun_5 = sqrt(mean((ma_hun_5.'-data_hun.').^2));
ma_hun_22 = movmean(data_hun, k(2));
err_ma_hun_22 = sqrt(mean((ma_hun_22.'-data_hun.').^2));

ax1 = nexttile;
plot(data_pl)
hold on
plot(ma_pl_5)
title(ax1, sprintf('MA POLSKA k= 5 i 22'));
plot(ma_pl_22)
hold off
grid on

ax2 = nexttile;
plot(data_hun)
hold on
plot(ma_hun_5)
title(ax2, sprintf('MA WĘGRY k= 5 i 22'));
plot(ma_hun_22)

hold off
grid on

%NAJMNIEJSZY BŁĄD DOPASOWANIA DLA ŚREDNIEJ KRĄCZĄCEJ OTRZYMUJEMY DLA
%ŚREDNIEJ O STAŁEJ K = 5 dla WĘGIER. WSZYSTKIE WYNIKI TO:
%węgry k = 22 -> 247.9943
%węgry k = 5 -> 94.2064
%polska k = 22 -> 644.0212
%polska k = 5 -> 179.69.18

%% ZAD 4
%Aproksymacja srednią kroczącą k = 5, 10, 22, 50 oraz wielomianem stopnia
%1,2,3

data_pl_100 = data_pl(end - 100+1:end)
data_hun_100 = data_hun(end - 100+1:end)

ks = [5, 10, 22, 50];
datas = [[data_pl_100]; [data_hun_100]]
figure(6);
for i=1:length(ks)
    subplot(7, 1, i)
    clear data
    data = movmean(data_pl_100, ks(i));
    err = sqrt(mean((data.'-data_pl_100.').^2));
    plot(data); title(sprintf("POLSKA MA K= %f, ERR= %f", ks(i), err))
end

for i=1:3
    subplot(7, 1, 4+i)
    clear data
    x_data = linspace(0,length(data_pl_100),length(data_pl_100));
    p= polyfit(x_data, data_pl_100, i);
    y = polyval(p, x_data);
    err = sqrt(mean((y-data_pl_100.').^2));
    plot(y); title(sprintf("POLSKA_100 wielomian stopien = %f, ERR= %f", i, err))
end


% DLA ZMIENNYCH DLA POLSKI NAJLEPIEJ DOKONAĆ APROKSYMACJI ŚREDNIĄ KROCZĄCĄ
% Z K = 5 WYNIKI ZOSTAŁY PRZEDSTAWIONE W OPISIE OSI WYKRESÓW

figure(7);
for i=1:length(ks)
    subplot(7, 1, i)
    clear data
    data = movmean(data_hun_100, ks(i));
    err = sqrt(mean((data.'-data_hun_100.').^2));
    plot(data); title(sprintf("WĘGRY_100 MA K= %f, ERR= %f", ks(i), err))
end

for i=1:3
    subplot(7, 1, 4+i)
    clear data
    x_data = linspace(0,length(data_hun_100),length(data_hun_100));
    p= polyfit(x_data, data_hun_100, i);
    y = polyval(p, x_data);
    err = sqrt(mean((y-data_hun_100.').^2));
    plot(y); title(sprintf("WĘGRY_100 WIELOMIAN stopien = %f, ERR= %f", i, err))
end

% JEŚLI CHODZI O NAJLEPSZE DOPASOWANIE DLA OSTATNICH 100 PRÓBEK DLA WĘGIER
% WYNIK JEST TAKI SAM JAK DLA POLSKI, NAJLEPSZE DOPASOWANIE ZNAJDZIEMY PRZY
% SREDNIEJ KROCZĄCEJ Z K=5, WYNIKI RÓWIEŻ PRZEDSTAWIONO NA WYKRESACH.





    
        


