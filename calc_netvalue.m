% 计算当前头寸在某个交易日的净值
% cash表示持有的现金数量
% elements表示当前持仓
function net_value = calc_netvalue(w, date, cash, elements, ifprint)
    n = length(elements);
    net_value = cash;
    if (ifprint == 1)
        fprintf('[当前持仓数量][%d]\n', n);
    end
    if (n > 0)
        [w_wsd_data,w_wsd_codes,w_wsd_fields,w_wsd_times,w_wsd_errorid,w_wsd_reqid] = w.wsd({elements.code},'close',date,date);
        for i=1:n
            net_value = net_value + elements(i).share * w_wsd_data(i);
            if (ifprint == 1)
                fprintf('[%s][份额%f][价格%f]\n', elements(i).code, elements(i).share, w_wsd_data(i));
            end
        end
    end
end