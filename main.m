%交易费用
cost_buy = 0.0002;
cost_sell = 0.0012;
w = windmatlab;

%调仓日期
trade_date = textread('data/list.txt','%s');
trade_date = sort(trade_date)
m = length(trade_date);

%交易日
date_range = w.tdays(char(trade_date(1)), char(trade_date(m)));
n = length(date_range)
net_value = zeros(n);
j = 1;
%现金、持股代码、份额
cash = 100;
holding_list = [];
share_list = [];
for i=1:1:n
    date_range(i) = cellstr(datestr(date_range(i),'yyyymmdd'));
    [cash, holding_list, share_list] = handle_stock_bonus(w, char(date_range(i)), cash, holding_list, share_list);
    if (j < m && isequal(trade_date(j), date_range(i)))
         %fprintf('%d %d\n', i, j);
         [code_list, weight] = load_trade_list(char(date_range(i)));
         [cash, holding_list, share_list] = my_sell(w, char(date_range(i)), cash, holding_list, share_list, cost_sell);
         [cash, holding_list, share_list] = my_buy(w, char(date_range(i)), cash, code_list, weight, cost_buy);
         j = j + 1;
    end;
    fprintf('%s ', char(date_range(i)));
    net_value(i) = calc_netvalue(w, char(date_range(i)), cash, holding_list, share_list);
    fprintf('net value %f\n', net_value(i));
end
