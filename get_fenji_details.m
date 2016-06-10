% 获取分级基金明细
% 输入母基金、A类或B类的代码（三者之一）
% 返回母基金、A类和B类的代码
% type 返回输入代码的类别，0表示母基金，1表示A类，2表示B类，-1表示不是分级基金
function [code_mother, code_class_a, code_class_b, type] = get_fenji_details(w, date, code)
    code_mother = 'error';
    code_class_a = 'error';
    code_class_b = 'error';
    type = -1;
    if (~isequal(code(1:3), '150') && ~isequal(code(1:3), '502') && ~isequal(code(1:2), '16'))
        return;
    end
    date = trade_day_offset(w, date, 0);
    para = strcat('date=', date, ';windcode=', code);
    % 利用WSET中的基金/分级基金明细来获取信息，但母基金数据不准确。
    [data] = w.wset('leveragedfundinfo', para);
    if length(data) < 2 
        return 
    end
    code_class_a = data(5);
    code_class_b = data(7);
    
    % 利用WSD中的基本资料/分级基金资料中的分级基金母基金代码，获取母基金代码
    [code_mother] = w.wsd(code, 'fund_smfcode', date, date);
    type = 0;
    if (char(code_mother) == char(code))
        type = 0;
    end;
    if (char(code_class_a) == char(code))
        type = 1;
    end;
    if (char(code_class_b) == char(code))
        type = 2;
    end;
end