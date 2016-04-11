% ���㵱ǰͷ����ĳ�������յľ�ֵ
% cash��ʾ���е��ֽ�����
% holdling_list��share_list��ʾ֤ȯ����ͷݶ�
function net_value = calc_netvalue(w, date, cash, holding_list, share_list)
    n = length(holding_list);
    net_value = cash;
    if (n > 0)
        [w_wsd_data,w_wsd_codes,w_wsd_fields,w_wsd_times,w_wsd_errorid,w_wsd_reqid] = w.wsd(holding_list,'close',date,date);
        for i=1:n
            net_value = net_value + share_list(i) * w_wsd_data(i);
        end
    end
end