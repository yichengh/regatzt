%交易费用
cost_buy = 0.0002;
cost_sell = 0.0012;
w = windmatlab;

%调仓日期
trade_date = textread('data/list.txt','%s');
trade_date = sort(trade_date);
m = length(trade_date);

%交易日
today = trade_day_offset(w, datestr(date,'yyyymmdd'), 0);
next_fenji_cfzs_day = today;
date_range = w.tdays(char(trade_date(1)), char(trade_date(m)));
n = length(date_range)
net_value = zeros(n);
j = 1;
%现金、持股代码、份额
cash = 100;
holding_list = [];
share_list = [];
fprintf('--------------------------------\n');
for i=1:1:n
    date_range(i) = cellstr(datestr(date_range(i),'yyyymmdd'));
    fprintf('%s\n', char(date_range(i)));
    [cash, holding_list, share_list] = handle_stock_bonus(w, char(date_range(i)), cash, holding_list, share_list);
    if (j < m && isequal(trade_date(j), date_range(i)))
         %fprintf('%d %d\n', i, j);
         [code_list, weight] = load_trade_list(char(date_range(i)));
         [cash, holding_list, share_list] = my_sell(w, char(date_range(i)), cash, holding_list, share_list, cost_sell);
         [cash, holding_list, share_list] = my_buy(w, char(date_range(i)), cash, code_list, weight, cost_buy);
         % 买次买完之后更新下一个分级拆分折算日
         next_fenji_cfzs_day = get_fenji_cfzs_day(w, holding_list, trade_date{j}, today);
         j = j + 1;
    end;
    if (isequal(date_range{i}, next_fenji_cfzs_day))
        [cash, holding_list, share_list] = handle_fenji_cfzs(w, char(date_range(i)), cash, holding_list, share_list);
        next_fenji_cfzs_day = get_fenji_cfzs_day(w, holding_list, trade_day_offset(w, date_range{i}, 1), today);
    end;
    net_value(i) = calc_netvalue(w, char(date_range(i)), cash, holding_list, share_list, 1);
    fprintf('净值 %f\n', net_value(i));
    fprintf('--------------------------------\n');
end
