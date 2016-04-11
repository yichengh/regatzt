% 卖出所有头寸
% cash表示持有的现金数量
% holdling_list和share_list表示证券代码和份额
function [cash, holding_list, share_list] = my_sell(w, date, cash, holding_list, share_list, cost_sell)
	cash_sell = calc_netvalue(w, date, 0, holding_list, share_list);
    cash_sell = cash_sell * (1 - cost_sell); % 扣除交易费用
    cash = cash + cash_sell;
    holding_list = [];
    share_list = [];
end