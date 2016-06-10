%���׷���
cost_buy = 0.0002;
cost_sell = 0.0012;
w = windmatlab;

%��������
trade_date = textread('data/list.txt','%s');
trade_date = sort(trade_date);
m = length(trade_date);

%������
today = trade_day_offset(w, datestr(date,'yyyymmdd'), 0);
next_fenji_cfzs_day = today;
date_range = w.tdays(char(trade_date(1)), char(trade_date(m)));
n = length(date_range);
net_value = zeros(n);
j = 1;
%�ֽ𡢳ֹɴ��롢�ݶ�
cash = 100;
elements = [];
fprintf('--------------------------------\n');
for i=1:1:n
    date_range(i) = cellstr(datestr(date_range(i),'yyyymmdd'));
    fprintf('[����][%s]\n', char(date_range(i)));
    [cash, elements] = handle_stock_bonus(w, date_range{i}, cash, elements);
    if (j < m && isequal(trade_date(j), date_range(i)))
         %fprintf('%d %d\n', i, j);
         [code_list, weight] = load_trade_list(char(date_range(i)));
         [cash, elements] = my_sell(w, date_range{i}, cash, elements, cost_sell);
         [cash, elements] = my_buy(w, date_range{i}, cash, code_list, weight, cost_buy);
         % �������֮�������һ���ּ����������
         next_fenji_cfzs_day = get_fenji_cfzs_day(w, elements, trade_date{j}, today);
         j = j + 1;
    end;
    
    [elements] = sell_fenjiB(w, date_range{i}, elements, cost_buy, cost_sell);
    
    if (isequal(date_range{i}, next_fenji_cfzs_day))
        [elements] = handle_fenji_cfzs(w, char(date_range(i)), elements);
        next_fenji_cfzs_day = get_fenji_cfzs_day(w, elements, trade_day_offset(w, date_range{i}, 1), today);
    end;
    
    net_value(i) = calc_netvalue(w, date_range{i}, cash, elements, 1);
    fprintf('[��ֵ][%f]\n', net_value(i));
    fprintf('--------------------------------\n');
end
