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
