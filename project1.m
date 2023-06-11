clc
clear all
close all


f = fred

startdate = '01/01/1994';
enddate = '01/01/2023';


kor_data = fetch(f,'NGDPRSAXDCKRQ',startdate,enddate)

k_year = kor_data.Data(:,1);
k_y = kor_data.Data(:,2);
[kcycle, ktrend] = qmacro_hpfilter(log(k_y), 6.75);


jpn_data = fetch(f,'JPNRGDPEXP',startdate,enddate);

j_year =jpn_data.Data(:,1);
j_y = jpn_data.Data(:,2);
[jcycle, jtrend] = qmacro_hpfilter(log(j_y), 6.75);


kor_std = std(kcycle)*100;


jpn_std = std(jcycle)*100;


corr_coeff = corrcoef(k_y, j_y);
corr_coeff = corr_coeff(1, 2);


figure
plot(k_year, kcycle, 'b')
hold on
plot(j_year, jcycle, 'r')
datetick('x', 'yyyy')
xlabel('Year')
ylabel('Detrended Log Real GDP')
title('Detrended Log Real GDP Comparison')
legend('Korea', 'Japan')
grid on


disp(['Korea GDP Standard Deviation: ', num2str(kor_std)]);
disp(['Japan GDP Standard Deviation: ', num2str(jpn_std)]);
disp(['Correlation Coefficient: ', num2str(corr_coeff)]);



function [ytilde,tauGDP] = qmacro_hpfilter(y, lam)

T = size(y,1);

% Hodrick-Prescott filter
A = zeros(T,T);

% unusual rows
A(1,1)= lam+1; A(1,2)= -2*lam; A(1,3)= lam;
A(2,1)= -2*lam; A(2,2)= 5*lam+1; A(2,3)= -4*lam; A(2,4)= lam;

A(T-1,T)= -2*lam; A(T-1,T-1)= 5*lam+1; A(T-1,T-2)= -4*lam; A(T-1,T-3)= lam;
A(T,T)= lam+1; A(T,T-1)= -2*lam; A(T,T-2)= lam;

% generic rows
for i=3:T-2
    A(i,i-2) = lam; A(i,i-1) = -4*lam; A(i,i) = 6*lam+1;
    A(i,i+1) = -4*lam; A(i,i+2) = lam;
end

tauGDP = A\y;

% detrended GDP
ytilde = y-tauGDP;

end
