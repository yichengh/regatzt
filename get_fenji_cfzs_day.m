% ����Ŀǰ�ĳֲ֣���ȡ[start_date, end_date]�ڼ�ĵ�һ������������������
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
    fprintf('��һ����������� %s\n', date);
end