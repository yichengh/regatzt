% 获取分级基金明细
% 输入母基金、A类或B类的代码（三者之一）
% 返回% 输入母基金、A类或B类的代码
% type 返回输入代码的类别，0表示母基金，1表示A类，2表示B类
function [code_mother, code_class_a, code_class_b, type] = get_fenji_details(w, date, code)
    para = strcat('date=', date, ';windcode=', code);
    % 利用WSET中的基金/分级基金明细来获取信息，但母基金数据不准确。
    [data] = w.wset('leveragedfundinfo', para);
    code_class_a = data(5);
    code_class_b = data(7);
    
    % 利用WSD中的基本资料/分级基金资料中的分级基金母基金代码，获取母基金代码
    [code_mother] = w.wsd(char(code), 'fund_smfcode', char(date), char(date));
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