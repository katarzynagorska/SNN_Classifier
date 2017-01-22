my_var_selection

%% 0 - Przygotowanie danych
selected = [2 4]; %Wybrane zmienne x2 i x4

% 1. Kolumna - x2, 2.kolumna x4, 3.kolumna etykieta
test_set_selected = [test_set(:,selected(1)) test_set(:,selected(2))];
test_classes = test_set(:,5);
learn_set_selected = [learn_set(:,selected(1)) learn_set(:,selected(2))];
learn_classes = learn_set(:,5);

% % Wykorzystane póŸniej do rysowania wykresów
learn_class1_idx = find(learn_set(:,5)==1);
learn_class2_idx = find(learn_set(:,5)==2);
learn_class3_idx = find(learn_set(:,5)==3);

% % Wykorzystywane pozniej do policzenia wskaznikow
test_class1_idx = find(test_set(:,5)==1);
test_class2_idx = find(test_set(:,5)==2);
test_class3_idx = find(test_set(:,5)==3);

%% 1 - Trzy niezale¿ne klasyfikatory binarne z jednym neuronem wyjœciowym

%------------------------------------------------------------------------
% Klasyfikator klasy class_no
%------------------------------------------------------------------------
class_no = 3;
learn_classes = double(learn_classes==class_no)*2-1; %1 gdy nale¿y do klasy class_no, -1 w p.p.
test_classes = double(test_classes==class_no)*2-1; %1 gdy nale¿y do klasy class_no, -1 w p.p.

%% 2 - Uczenie sieci pierwszej koncepcji
%close all

efforts = 10; % Liczba testowanych wag dla danej architektury
neurons = 3;  %Liczba neuronów w warstwie ukrytej

test_size = size(test_set_selected);
test_size = test_size(1);
% Prealokacja
outputs1 = zeros(test_size,efforts);
out_modified = outputs1;


%Tablice podsumowuj¹ce wskaŸniki klasyfikatorów
summary = zeros(5,efforts);             %Dla klasyfikatora binarnego

%% 3a - Testy i wybór klasyfikatorów binarnych

% sprintf('Dla %d neuronow',neurons)
% for j=1:efforts
%     [net]=train_net(learn_set_selected,learn_classes,neurons);
%     % Prezentacja wyników
%     % Wizualizacja zbiorów
%     figure(j)
%     plot(learn_set(learn_class1_idx,2),learn_set(learn_class1_idx,4),'ro')
%     hold on
%     plot(learn_set(learn_class2_idx,2),learn_set(learn_class2_idx,4),'bo')
%     hold on
%     plot(learn_set(learn_class3_idx,2),learn_set(learn_class3_idx,4),'go')
%     hold on;
%     xlabel(sprintf('x%d',2))
%     ylabel(sprintf('x%d',4))
%     axis([-1 1 -1 1])
%     legend('Klasa 1','Klasa 2','Klasa 3')
%
%     sprintf('Wartoœci dla próby nr: %d', j)
%     input_weights=net.IW{1,1}
%     input_biases=net.b{1}
%     % Rysowanie sieci
%     for i=1:size(input_weights,1)
%         plotpc(input_weights(i,:),input_biases(i));
%     end;
%
%  %   'Testowanie'
%
%     % Testowanie sieci
%     outputs1(:,j) = sim(net,test_set_selected')  ;
%     out_modified(:,j) = double(outputs1(:,j)>0);
%
%   %  'Zapis danych do wyliczen'
%
%     out(:,1)=outputs1(:,j);
%     out(:,2)=out_modified(:,j);
%     out(:,3)=test_classes;
%     out(:,4)=((out(:,2)==1)&(out(:,3)== 1)); %TP
%     out(:,5)=((out(:,2)==0)&(out(:,3)==-1)); %TN
%     out(:,6)=((out(:,2)==0)&(out(:,3)== 1)); %FN
%     out(:,7)=((out(:,2)==1)&(out(:,3)==-1)); %FP
%
%     out;
%
% %    'WskaŸniki'
%
%     TP = sum(out(:,4));
%     TN = sum(out(:,5));
%     FP = sum(out(:,6));
%     FN = sum(out(:,7));
%     sprintf('Czy zgadza siê P+N?')
%     (TP+TN+FN+FP)==test_size
%
%     sprintf('WskaŸniki dla próby %d',j);
%
%     tp_rate=TP/(FN+TP);
%     fp_rate=FP/(TN+FP);
%     precisi=TP/(TP+FP);
%     specify=TN/(FP+TN);
%     accurac=(TP+TN)/(TP+TN+FP+FN);
%
%     summary(1,j)=tp_rate;
%     summary(2,j)=fp_rate;
%     summary(3,j)=precisi;
%     summary(4,j)=specify;
%     summary(5,j)=accurac;
%
% end
%
% summary

%% 3b - Testy i wybór pojedynczego klasyfikatora dla trzech klas
%close all;
%clc;

fprintf('Start symulacji\n');

efforts = 1;  %Liczba testowanych wag dla danej architektury
neurons = 3;    %Liczba neuronów w warstwie ukrytej
treshold = 0;  %Prog wykorzystywany do oceny jakoœci klasyfikacji

test_labels;
learn_labels;

%Tablice podsumowuj¹ce wskaŸniki klasyfikatorów
summary_3 = zeros(5,efforts*3);         %Dla klasyfikatora 3 klas

%Tablica na wyniki klasyfikacji
outputs2 = zeros(test_size,3);



for j=1:efforts
    [net]=train_net(learn_set_selected,learn_labels,neurons);
    % Prezentacja wyników
    % Wizualizacja zbiorów
    %     figure(j)
    %     plot(learn_set(learn_class1_idx,2),learn_set(learn_class1_idx,4),'ro')
    %     hold on
    %     plot(learn_set(learn_class2_idx,2),learn_set(learn_class2_idx,4),'bo')
    %     hold on
    %     plot(learn_set(learn_class3_idx,2),learn_set(learn_class3_idx,4),'go')
    %     hold on;
    %     xlabel(sprintf('x%d',2))
    %     ylabel(sprintf('x%d',4))
    %     axis([-1 1 -1 1])
    %     legend('Klasa 1','Klasa 2','Klasa 3')
    %     title(sprintf('Klasyfikator 3 klas z %d neuronami w warstwie ukrytej', neurons))
    outputs2 = sim(net,test_set_selected');
    
    tab = outputs2';
    tab(:,4)=max(outputs2)';
    
    %Zwycieza klasa o najwyzszym wyniku
    % TODO wykorzystaæ zapis matlaba zamiast pêtli for
    for i=1:test_size
        if (tab(i,1)==tab(i,4))
            tab(i,5)=1;
        elseif (tab(i,2)==tab(i,4))
            tab(i,5)=2;
        else
            tab(i,5)=3;
        end
    end
    
    %Wyniki klasyfikacji
    results(:,1) = tab(:,5);
    %Rzeczywista przynale¿noœæ do klas
    results(:,2) = test_set(:,5);
    
    %Obliczanie wskaŸnikó jakoœci klasyfikacji dla ka¿dej z klas
    for i=1:3
             
        TP = sum((results(:,1)==i)&(results(:,2)==i));
        TN = sum((results(:,1)~=i)&(results(:,2)~=i));
        FP = sum((results(:,1)==i)&(results(:,2)~=i));
        FN = sum((results(:,1)~=i)&(results(:,2)==i));
             
        tp_rate=TP/(FN+TP)*100;
        fp_rate=FP/(TN+FP)*100;
        precisi=TP/(TP+FP)*100;
        specify=TN/(FP+TN)*100;
        accurac=(TP+TN)/(TP+TN+FP+FN)*100;
        
        %Dodawanie wyników do tablicy z podsumowaniem
        summary(1,3*(j-1)+i) = tp_rate;
        summary(2,3*(j-1)+i) = fp_rate;
        summary(3,3*(j-1)+i) = precisi;
        summary(4,3*(j-1)+i) = specify;
        summary(5,3*(j-1)+i) = accurac;
        
        if i == 3
            test(:,:) = summary(:,j+i-3:j+i-1);
            %Chcemy, ¿eby dok³adnooœæ by³a jak najwy¿sza
            if sum(test(1,1:3))/3>=treshold
                
                
                
%                 fprintf('Klasa %d\n\n',i);
%                 fprintf('TP %d\nTN %d\nFP %d\nFN %d\n\n',TP,TN,FP,FN);
%                 fprintf('TP RATE %3.2f\nFP RATE %3.2f\nPRECISION %3.2f\nSPECIFITY %3.2f\nACCURACY %3.2f\n\n',tp_rate,fp_rate,precisi,specify,accurac);

                figure(j)
                plot(learn_set(learn_class1_idx,2),learn_set(learn_class1_idx,4),'ro')
                hold on
                plot(learn_set(learn_class2_idx,2),learn_set(learn_class2_idx,4),'bo')
                hold on
                plot(learn_set(learn_class3_idx,2),learn_set(learn_class3_idx,4),'go')
                hold on;
                xlabel(sprintf('x%d',2))
                ylabel(sprintf('x%d',4))
                axis([-1 1 -1 1])
                legend('Klasa 1','Klasa 2','Klasa 3')
                title(sprintf('Klasyfikator 3 klas z %d neuronami w warstwie ukrytej', neurons))
                
                sprintf('Wartoœci dla próby nr: %d (%d neurony w warstwie ukrytej)', j, neurons)
                input_weights=net.IW{1,1}
                input_biases=net.b{1}
                
                test(:,:)
                
                % Rysowanie sieci
                for k=1:size(input_weights,1)
                    plotpc(input_weights(k,:),input_biases(k));
                end               
            end
        end        
    end
end

% summary';
fprintf('Koniec symulacji\n');

