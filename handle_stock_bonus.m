% 处理股票分红，改变现金量和持股数量
% 暂时不考虑配股等特殊情况的处理方式 TODO: 配股的处理
% 红利税(变量taxes)固定为20% TODO：差别化的红利税
function [cash, holding_list, share_list] = handle_stock_bonus(w, date, cash, holding_list, share_list)
    taxes = 0.2;
    para = strcat('startdate=', date, ';enddate=', date);
    para = strcat(para, ';field=wind_code,cash_payout_ratio,stock_split_ratio,stock_dividend_ratio,rights_issue_price,rights_issue_ratio,ex_dividend_note');
    % 1 代码 2 派息比例 3 转增比例 4 送股比例 5 配股价格 6 配股比例 7 除权说明
    [bouns_data] = w.wset('CorporationAction',para);
    n = length(holding_list);
    m = size(bouns_data, 1);
    for i=1:1:n
        for j=1:1:m
            if (isequal(holding_list(i), bouns_data(j,1)))
                fprintf('%s %s %s\n', char(date), char(holding_list(i)), char(bouns_data(j,7)));
                cash = cash + cell2mat(bouns_data(j, 2)) * share_list(i) * (1 - taxes);
                share_list(i) = share_list(i) * (1 + cell2mat(bouns_data(j, 3)) + cell2mat(bouns_data(j, 4)) + cell2mat(bouns_data(j, 6)));
            end
        end
    end
end