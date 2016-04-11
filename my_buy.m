% 买入证券
% cash表示持有的现金数量
% code_list和weight表示买入的证券代码和权重
function [cash, holding_list, share_list] = my_buy(w, date, cash, code_list, weight, cost_buy)     
    [w_wsd_data,w_wsd_codes,w_wsd_fields,w_wsd_times,w_wsd_errorid,w_wsd_reqid] = w.wsd(code_list,'close',date,date);
    holding_list = code_list;
    share_list = weight;
    n = length(holding_list);
    for i=1:n
        share_list(i) = cash * weight(i) / w_wsd_data(i);
        share_list(i) = share_list(i) * (1 - cost_buy);
    end
    cash = 0;
end