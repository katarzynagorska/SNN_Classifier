%% Przygotowanie matlaba
clc;
clear;
close all;

%% Wczytanie danych
data_raw = importdata('K_7.txt', ' ',1);
data = data_raw.data(:,1:5);
%% Deklaracja zmiennych
var_count=4;
class_count=3;
sample_count=size(data,1);

%% Deklaracja tablic
data_norm=zeros(sample_count,var_count);
data_centr=zeros(sample_count,var_count);
labels=-1*ones(sample_count,class_count);
avg=zeros(var_count,1);

cos2=zeros(var_count);
var_ranking=zeros(class_count,var_count);
original_var_no=1:1:var_count;

%% Centralizacja
for i=1:1:var_count,
   avg(i)=mean(data(:,i));
   data_centr(:,i)=data(:,i)-avg(i);
  % data_norm(:,i)=data(:,i)-avg(i);
end

%% Normalizacja - Dodano normalizacjê do przednia³u [0,1]
for i=1:1:var_count
   minX = min(data_centr(:,i));
   maxX = max(data_centr(:,i));
   
   data_norm(:,i) = (data_centr(:,i) - minX)/(maxX - minX)*2-1;
end

%% Etykiety klas
for i=1:1:sample_count,
   labels(i,data(i,var_count+1))=1;
end
%% Selekcja metod¹ Grama-Schmidta

%Powtarzamy dla ka¿dej klasy
for class_no=1:1:class_count,
    data_ort=data_norm;
    %Wyliczamy dla ka¿dej zmiennej
    for sel_feature_no=1:1:var_count,
        cos2=zeros(var_count,1);
        %Obliczenie wartoœci cosinusa theta
        for var_no=sel_feature_no:1:var_count,
            exp1=0;
            exp2=0;
            exp3=0;
           for i=1:1:sample_count,
               exp1=exp1+data_ort(i,var_no)*labels(i,class_no);
               exp2=exp2+data_ort(i,var_no)^2;
               exp3=exp3+labels(class_no)^2;
           end
           cos2(var_no)=exp1^2/(exp2*exp3);
        end 
        
        %Znajdujemy zmienn¹, dla której wartoœæ cos jest najwiêksza
        [max_r, var_idx]=max(cos2);
        var_ranking(class_no,sel_feature_no)=original_var_no(var_idx);
        temp=data_ort(:,sel_feature_no);
        data_ort(:,sel_feature_no)=data_ort(:,var_idx);
        data_ort(:,var_idx)=temp;
        
        temp=original_var_no(sel_feature_no);
        original_var_no(sel_feature_no)=original_var_no(var_idx);
        original_var_no(var_idx)=temp;
        
        % Ortogonalizacja danych        
        for i=sel_feature_no+1:1:var_count,
            V=data_ort(:,sel_feature_no);
            U=data_ort(:,i);
            UprojV=((U'*V)/(V'*V))*V;
            UortV=U-UprojV;
            data_ort(:,i)=UortV;
        end
        
    end
    
    % Wyœwietlenie rankingu danych
    var_ranking
    
%     % Wyœwietlanie klasy na tle innych na podstawie rankingu zmiennych
%     figure(3140+class_no);
%     % Dodanie tytu³u dla wiêkszej czytelnoœci
%     idx_pos=find(data(:,5)==class_no);
%     idx_neg=find(data(:,5)~=class_no);
%     %plot(data(idx_pos,var_ranking(class_no,1)),data(idx_pos,var_ranking(class_no,2)),'ro');
%     plot(data(idx_pos,3),data(idx_pos,4),'ro');
%     hold on;
%     %plot(data(idx_neg,var_ranking(class_no,1)),data(idx_neg,var_ranking(class_no,2)),'k.');
%     plot(data(idx_neg,3),data(idx_neg,4),'k.');
%     title(sprintf('Prezentacja klasy  %d na podstawie wybranych zmiennych wejœciowych: x%d i x%d', class_no,var_ranking(class_no,1),var_ranking(class_no,2)))

    
%     % Moja do testów - klasa na tle pozosta³ych; zmienne 2 i 4
%     figure(class_no*100+2*10+4);
%     % Dodanie tytu³u dla wiêkszej czytelnoœci
%     idx_pos=find(data(:,5)==class_no);
%     idx_neg=find(data(:,5)~=class_no);
%     %plot(data(idx_pos,var_ranking(class_no,1)),data(idx_pos,var_ranking(class_no,2)),'ro');
%     plot(data(idx_pos,2),data(idx_pos,4),'ro');
%     hold on;
%     %plot(data(idx_neg,var_ranking(class_no,1)),data(idx_neg,var_ranking(class_no,2)),'k.');
%     plot(data(idx_neg,2),data(idx_neg,4),'k.');
%     title(sprintf('Prezentacja klasy  %d na podstawie wybranych zmiennych wejœciowych: 2 i 4', class_no,var_ranking(class_no,1),var_ranking(class_no,2)))

    
end
%% Wizualizacja danych
% 
% class1_idx = find(data(:,5)==1);
% class2_idx = find(data(:,5)==2);
% class3_idx = find(data(:,5)==3);
% 
% for i=1:3
%     for j=i+1:4
%         figure(10*i+j)
%         plot(data(class1_idx,i),data(class1_idx,j),'r.')
%         hold on
%         plot(data(class2_idx,i),data(class2_idx,j),'b.')
%         hold on
%         plot(data(class3_idx,i),data(class3_idx,j),'g.')
%         hold on;
%         xlabel(sprintf('x%d',i))
%         ylabel(sprintf('x%d',j))
%         legend('Klasa 1','Klasa 2','Klasa 3')
%         title(sprintf('Wizualizacja danych na podstawie wybranych zmiennych wejœciowych x%d i x%d',i,j))
%        % axis([-2 2 -2 2])
%     end
% end
%% Podzia³ danych na zbiór testowy i ucz¹cy
test_set = data_norm(1:sample_count/2,:);
test_set(:,5)=data(1:sample_count/2,5);
test_labels = labels(1:sample_count/2,:);

learn_set = data_norm(sample_count/2+1:sample_count,:);
learn_set(:,5) = data(sample_count/2+1:sample_count,5);
learn_labels = labels(sample_count/2+1:sample_count,:);

%% Wizualizacja zbiorów
% test_class1_idx = find(test_set(:,5)==1);
% test_class2_idx = find(test_set(:,5)==2);
% test_class3_idx = find(test_set(:,5)==3);
% 
% 
% figure(1)
% plot(test_set(test_class1_idx,2),test_set(test_class1_idx,4),'ro')
% hold on
% plot(test_set(test_class2_idx,2),test_set(test_class2_idx,4),'bo')
% hold on
% plot(test_set(test_class3_idx,2),test_set(test_class3_idx,4),'go')
% hold on;
% xlabel(sprintf('x%d',2))
% ylabel(sprintf('x%d',4))
% axis([-2 0.5 -1 1])
% legend('Klasa 1','Klasa 2','Klasa 3')
% title('Zbior testowy')
% 
% learn_class1_idx = find(learn_set(:,5)==1);
% learn_class2_idx = find(learn_set(:,5)==2);
% learn_class3_idx = find(learn_set(:,5)==3);
% 
% 
% figure(2)
% plot(learn_set(learn_class1_idx,2),learn_set(learn_class1_idx,4),'ro')
% hold on
% plot(learn_set(learn_class2_idx,2),learn_set(learn_class2_idx,4),'bo')
% hold on
% plot(learn_set(learn_class3_idx,2),learn_set(learn_class3_idx,4),'go')
% hold on;
% xlabel(sprintf('x%d',2))
% ylabel(sprintf('x%d',4))
% axis([-2 0.5 -1 1])
% legend('Klasa 1','Klasa 2','Klasa 3')
% title('Zbior uczacy')