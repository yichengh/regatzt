% ����ּ�����Ĳ��������
% TODO: A:B����5:5�Ƿ���Ҫ���⴦��
function [cash, holding_list, share_list] = handle_fenji_cfzs(w, date, cash, holding_list, share_list)
    n = length(holding_list);
    for i=1:1:n
        tmp = char(holding_list(i));
        tmp = tmp(1:3);
        if (~isequal(tmp, '150') && ~isequal(tmp, '502'))
            continue;
        end
        %fprintf('%s is fenji\n', char(holding_list(i)));
        %�����յ���ͣ��
        [code_mother, code_class_a, code_class_b, type] = get_fenji_details(w, date, holding_list(i));
        para = strcat('windcode=', holding_list(i));
        para = strcat(para, ';startdate=', date, ';enddate=', date);
        [w_wset_data]=w.wset('fundspitandconvert',para);
    end
end