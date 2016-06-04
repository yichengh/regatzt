% 根据目前的持仓，获取[start_date, end_date]期间的第一个发生拆分折算的日期
function [date] = get_fenji_cfzs_day(w, holding_list, start_date, end_date)
    n = length(holding_list);
    date_list = [];
    for i=1:n
        [data]=w.wset('fundspitandconvert',strcat('windcode=', holding_list{i}, ';startdate=', start_date, ';enddate=', end_date));
        if (length(data) > 2)
            date_list = [date_list, data(:,4)'];
        end
    end
    date_list = cellstr(datestr(date_list, 'yyyymmdd'));
    date_list = sort(date_list);
    if (isempty(date_list))
        date = end_date;
    else
        date = date_list{1};
    end
    fprintf('下一个拆分折算日 %s\n', date);
end