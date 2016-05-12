% 处理分级基金的拆分与折算

function [cash, holding_list, share_list] = handle_fenji_cfzs(w, date, cash, holding_list, share_list)
    n = length(holding_list);
    for i=1:1:n
        tmp = char(holding_list(i));
        tmp = tmp(1:3);
        if (~isequal(tmp, '150') && ~isequal(tmp, '502'))
            continue;
        end
        %fprintf('%s is fenji\n', char(holding_list(i)));
        %折算日当天停牌
        para = strcat('windcode=', holding_list(i));
        para = strcat(para, ';startdate=', date, ';enddate=', date);
        [w_wset_data]=w.wset('fundspitandconvert',para);
    end
end