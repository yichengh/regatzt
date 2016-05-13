% ����ּ�����Ĳ�������㣨���㵱��ͣ�ƣ�
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
        %��ȡ�ּ�������Ϣ
        [code_mother, code_class_a, code_class_b, type] = get_fenji_details(w, date, holding_list(i));
        %��ȡ������Ϣ
        [data0]=w.wset('fundspitandconvert',strcat('windcode=', code_mother, ';startdate=', date, ';enddate=', date))
        [data1]=w.wset('fundspitandconvert',strcat('windcode=', code_class_a, ';startdate=', date, ';enddate=', date));
        [data2]=w.wset('fundspitandconvert',strcat('windcode=', code_class_b, ';startdate=', date, ';enddate=', date));
        whos
        if ~iscell(data0)
            fprintf('����������\n');
            continue;
        end
        if ~iscell(data2)
            fprintf('����\n');
        else
            fprintf('�Ƕ���\n');
        end
    end
end