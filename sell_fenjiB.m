% ����������������ķּ�B
% ������B�Լ���ӦA��δȫ���ǵ�ͣ�����Ե��վ�����B��A��
function [elements] = sell_fenjiB(w, date, elements, cost_buy, cost_sell)
    i=0;
    while (i < length(elements))
        i = i + 1;
        if (elements(i).type ~= 2)
            continue
        end
        code_b = elements(i).code;
        [dataB]=w.wsd(code_b,'vwap,high,low,volume,pct_chg',date, date, cost_buy, cost_sell);
        % Bͣ��
        if (isnan(dataB(1)) || dataB(3) == 0)
            fprintf('[ͣ��][%s]\n', code_b);
            continue
        end
        % B��ͣ
        if (dataB(2)==dataB(3) && abs(dataB(5)) > 9.9)
            fprintf('[��ͣ][%s]\n', code_b);
            continue
        end;
        [~, code_a, ~, ~] =  get_fenji_details(w, date, code_b);
        [dataA]=w.wsd(code_a,'vwap,high,low,volume,pct_chg',date, date);
        code_a = char(code_a);
        % Aͣ��        
        if (isnan(dataA(1)) || dataA(3) == 0)
            fprintf('[ͣ��][%s]\n', code_a);
            continue
        end
        % A��ͣ
        if (abs(dataA(2)-dataA(3))<1e-7 && abs(dataA(5)) > 9.9)
            fprintf('[��ͣ][%s]\n', code_a);
            continue
        end;
        cash = elements(i).share * dataB(1) * (1-cost_sell);
        fprintf('[����][%s][�ݶ�%f][����%f]\n', code_b, elements(i).share, dataB(1));
        elements(i) = [];
        i = i - 1;
        %elements(1).code = '123';
        share = (cash / dataA(1)) * (1-cost_buy);
        fprintf('[����][%s][�ݶ�%f][����%f]\n', code_a, share, dataA(1));
        k = -1; %find(char({elements.code}) == char(code_a));
        for p=1:length(elements)
            if (elements(p).code == code_a)
                k = p;
                break
            end
        end
        
        if (k~=-1) 
            index = k;
            elements(index).share = elements(index).share + share;
        else
            fprintf('[����]\n');
        end
    end
    
end