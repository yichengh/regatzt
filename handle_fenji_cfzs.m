% 处理分级基金的拆分与折算（拆分折算日次日停牌）
% TODO: A:B不是5:5需要特殊处理（拆分时需要特殊处理，除此之外是否还需要别的处理？）
function [cash, holding_list, share_list] = handle_fenji_cfzs(w, date, cash, holding_list, share_list)
    n = length(holding_list);
    %存储由于母基金拆分可能带来的新的持仓
    m = 0;
    new_holding_list = [];%cell(1,n*2);
    new_share_list = [];
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
        [data0]=w.wset('fundspitandconvert',strcat('windcode=', code_mother, ';startdate=', date, ';enddate=', date));
        [data1]=w.wset('fundspitandconvert',strcat('windcode=', code_class_a, ';startdate=', date, ';enddate=', date));
        [data2]=w.wset('fundspitandconvert',strcat('windcode=', code_class_b, ';startdate=', date, ';enddate=', date));
        %获取折算拆分比例，默认值为1
        ratio_a = 1.0;
        ratio_b = 1.0;
        share_mother = 0;
        if (iscell(data1)) ratio_a = data1{5}; end
        if (iscell(data2)) ratio_b = data2{5}; end
        
        if ~iscell(data0)
           % fprintf('不在折算日\n');
            continue;
        end

        if ~iscell(data2)
            fprintf('%s产生定折\n', holding_list{i});
            fprintf('折算拆分比例: A %f B %f\n', ratio_a, ratio_b);
            %定折只对A类处理
            if (type ~= 1) continue; end
            %获取拆分折算日净值母基金净值
            net_value_mother = data0{7};
            share_mother = ((ratio_a - 1) / net_value_mother) * share_list(i);
        else
            fprintf('%s产生非定折\n', holding_list{i});
            fprintf('折算拆分比例: A %f B %f\n', ratio_a, ratio_b);
            if (type == 1) 
                %当前处理的是A类
                tmp = min(ratio_b, 1);
                share_mother = (ratio_a - tmp) * share_list(i);
                share_list(i) = share_list(i) * tmp;
            else
                %当前处理的是B类
                if (ratio_b > 1)
                    %比1多的部分折为母基金
                    share_mother = (ratio_b - 1) * share_list(i);
                else
                    %B类份额按比例减少
                    share_list(i) = share_list(i) * ratio_b;
                end
            end
        end
        if (share_mother > 0)
            m = m + 1;
            new_holding_list{m} = char(code_class_a);
            new_share_list(m) = share_mother / 2;
            m = m + 1;
            new_holding_list{m} = char(code_class_b);
            new_share_list(m) = share_mother / 2;
        end
    end %for
    
    %处理new_holding_list中的元素，加入到原list中
    for i=1:1:m
        find = 0;
        for j=1:1:n
            if (isequal(new_holding_list(i), holding_list(j)))
                share_list(j) = share_list(j) + new_share_list(i);
                find = 1;
                break
            end
        end
        if (find == 0)
            n = n + 1;
            holding_list{n} = new_holding_list{i};
            share_list(n) = new_share_list(i);
        end
    end
end