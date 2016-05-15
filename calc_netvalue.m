% 计算当前头寸在某个交易日的净值
% cash表示持有的现金数量
% holdling_list和share_list表示证券代码和份额
function net_value = calc_netvalue(w, date, cash, holding_list, share_list, ifprint)
    n = length(holding_list);
    net_value = cash;
    if (ifprint == 1)
        fprintf('当前持仓\n');
    end
    if (n > 0)
        [w_wsd_data,w_wsd_codes,w_wsd_fields,w_wsd_times,w_wsd_errorid,w_wsd_reqid] = w.wsd(holding_list,'close',date,date);
        for i=1:n
            net_value = net_value + share_list(i) * w_wsd_data(i);
            if (ifprint == 1)
                fprintf('-%s 份额%f 价格%f\n', holding_list{i}, share_list(i), w_wsd_data(i));
            end
        end
    end
end