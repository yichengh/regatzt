% 可转债回测
function [] = run_kzz(w, filename)
upper_rate = 0.2; %单个品种持仓比例上限

% txt read
% input_file = strcat(filename, '.txt');
% fid = fopen(strcat('data/', input_file));
% C = textscan(fid, '%s %s');
% code_list = C{2};
% date_list = C{1};
% fclose(fid);

% xls read
[~,~,RAW]=xlsread(strcat('data/', filename));
n = length(RAW);
code_list = RAW(2:n,3);
date_list = RAW(2:n,1);

output_file = strcat(filename, '_result.txt');
fid = fopen(strcat('data/', output_file), 'w');
L = length(code_list);

cash = 100;
elements = [];

today = trade_day_offset(w, date_list{1}, -1);
trade_days = w.tdays(date_list{1},date_list{L});
p = 1; q = 1;
while p<=L;
    today = trade_days(q); q = q + 1;
    today = datestr(today,'yyyymmdd');
    if (length(elements) > 0)
        codes = {elements.code};
        pct = get_bond_pct_chg(w, codes, today);
        %sum = 0;
        for i=1:length(elements)
            elements(i).share = elements(i).share * (1 + pct(i) / 100);
            cash = cash + elements(i).share;
        end
        elements = [];
    end
    fprintf(fid, '%s %.2f\r\n', today, cash);
    fprintf('%s %.2f\n', today, cash);
    now_date = datestr(date_list(p),'yyyymmdd');
    if (isequal(today, now_date))
        for i=1:length(elements)
            cash = cash + elements(i).share;
        end
        elements = [];
        j = p;
        while (j <= L && isequal(date_list{j},date_list{p}))
            elements = [elements, generate_element(code_list{j}, 0.0, 3)];
            j = j + 1;
        end
        n = length(elements);
        use = 0;
        for i=1:n
            elements(i).share = cash * min(1./n, upper_rate);
            use = use + elements(i).share;
        end
        cash = cash - use;
        p = j;
    end
end

fclose(fid);
end