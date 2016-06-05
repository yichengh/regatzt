% 卖出所有头寸
% cash表示持有的现金数量
% elements表示当前持仓
function [cash, elements] = my_sell(w, date, cash, elements, cost_sell)
	cash_sell = calc_netvalue(w, date, 0, elements, 0);
    cash_sell = cash_sell * (1 - cost_sell); % 扣除交易费用
    cash = cash + cash_sell;
    elements = [];
end