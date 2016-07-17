% 给定债券每日持仓计算净值
w = windmatlab;
upper_rate = 0.1; %单个品种持仓比例上限

filename = 'data1.txt';
fid = fopen(strcat('data/', filename));
C = textscan(fid, '%s %s');
code_list = C{2};
date_list = C{1};
fclose(fid);

L = length(code_list);

cash = 100;
elements = [];

today = trade_day_offset(w, date_list{1}, -1);
p = 1;
while p<=L;
    today = trade_day_offset(w, today, 1);
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
    fprintf('%s %f\n', today, cash);
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