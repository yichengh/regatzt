% 处理分级基金的拆分与折算（折算当天停牌）
% TODO: A:B不是5:5是否需要特殊处理
function [cash, holding_list, share_list] = handle_fenji_cfzs(w, date, cash, holding_list, share_list)
    n = length(holding_list);
    for i=1:1:n
        tmp = char(holding_list(i));
        tmp = tmp(1:3);
        if (~isequal(tmp, '150') && ~isequal(tmp, '502'))
            continue;
        end
        %fprintf('%s is fenji\n', char(holding_list(i)));
        %获取分级基金信息
        [code_mother, code_class_a, code_class_b, type] = get_fenji_details(w, date, holding_list(i));
        %获取折算信息
        [data0]=w.wset('fundspitandconvert',strcat('windcode=', code_mother, ';startdate=', date, ';enddate=', date))
        [data1]=w.wset('fundspitandconvert',strcat('windcode=', code_class_a, ';startdate=', date, ';enddate=', date));
        [data2]=w.wset('fundspitandconvert',strcat('windcode=', code_class_b, ';startdate=', date, ';enddate=', date));
        whos
        if ~iscell(data0)
            fprintf('不在折算日\n');
            continue;
        end
        if ~iscell(data2)
            fprintf('定折\n');
        else
            fprintf('非定折\n');
        end
    end
end