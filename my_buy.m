% 买入证券
% cash表示持有的现金数量
% elements代表持仓列表
function [cash, elements] = my_buy(w, date, cash, code_list, weight, cost_buy)     
    [w_wsd_data,w_wsd_codes,w_wsd_fields,w_wsd_times,w_wsd_errorid,w_wsd_reqid] = w.wsd(code_list,'close',date,date);
    %holding_list = code_list;
    %share_list = weight;
    n = length(code_list);
    elements = [];
    for i=1:n
        share = cash * weight(i) / w_wsd_data(i);
        share = share * (1 - cost_buy);
        [~,~,~,type] = get_fenji_details(w, date, code_list{i});
        if (type == -1)
            elements = [elements, generate_element(code_list{i}, share, 0)];
        else
            elements = [elements, generate_element(code_list{i}, share, type)];
        end
        fprintf('[买入][%s][份额%f][均价%f]\n',code_list{i},share,w_wsd_data(i));
    end
    cash = 0;
end