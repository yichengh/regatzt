% �����Ʊ�ֺ죬�ı��ֽ����ͳֹ�����
% ��ʱ��������ɵ���������Ĵ���ʽ TODO: ��ɵĴ���
% ����˰(����taxes)�̶�Ϊ20% TODO����𻯵ĺ���˰
function [cash, elements] = handle_stock_bonus(w, date, cash, elements)
    taxes = 0.2;
    para = strcat('startdate=', date, ';enddate=', date);
    para = strcat(para, ';field=wind_code,cash_payout_ratio,stock_split_ratio,stock_dividend_ratio,rights_issue_price,rights_issue_ratio,ex_dividend_note');
    % 1 ���� 2 ��Ϣ���� 3 ת������ 4 �͹ɱ��� 5 ��ɼ۸� 6 ��ɱ��� 7 ��Ȩ˵��
    [bouns_data] = w.wset('CorporationAction',para);
    n = length(elements);
    m = size(bouns_data, 1);
    if ~iscell(bouns_data)
        return
    end
    for i=1:1:n
        for j=1:1:m
            if (elements(i).code == char(bouns_data(j,1)))
                fprintf('%s %s %s\n', date, elements(i).code, bouns_data{j,7});
                cash = cash + cell2mat(bouns_data(j, 2)) * elements(i).share * (1 - taxes);
                elements(i).share = elements(i).share * (1 + cell2mat(bouns_data(j, 3)) + cell2mat(bouns_data(j, 4)) + cell2mat(bouns_data(j, 6)));
            end
        end
    end
end