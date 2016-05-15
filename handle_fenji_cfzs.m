% ����ּ�����Ĳ�������㣨��������մ���ͣ�ƣ�
% TODO: A:B����5:5��Ҫ���⴦�����ʱ��Ҫ���⴦������֮���Ƿ���Ҫ��Ĵ�����
function [cash, holding_list, share_list] = handle_fenji_cfzs(w, date, cash, holding_list, share_list)
    n = length(holding_list);
    %�洢����ĸ�����ֿ��ܴ������µĳֲ�
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
        %��ȡ�ּ�������Ϣ
        [code_mother, code_class_a, code_class_b, type] = get_fenji_details(w, date, holding_list(i));
        %��ȡ������Ϣ
        [data0]=w.wset('fundspitandconvert',strcat('windcode=', code_mother, ';startdate=', date, ';enddate=', date));
        [data1]=w.wset('fundspitandconvert',strcat('windcode=', code_class_a, ';startdate=', date, ';enddate=', date));
        [data2]=w.wset('fundspitandconvert',strcat('windcode=', code_class_b, ';startdate=', date, ';enddate=', date));
        %��ȡ�����ֱ�����Ĭ��ֵΪ1
        ratio_a = 1.0;
        ratio_b = 1.0;
        share_mother = 0;
        if (iscell(data1)) ratio_a = data1{5}; end
        if (iscell(data2)) ratio_b = data2{5}; end
        
        if ~iscell(data0)
           % fprintf('����������\n');
            continue;
        end

        if ~iscell(data2)
            fprintf('%s��������\n', holding_list{i});
            fprintf('�����ֱ���: A %f B %f\n', ratio_a, ratio_b);
            %����ֻ��A�ദ��
            if (type ~= 1) continue; end
            %��ȡ��������վ�ֵĸ����ֵ
            net_value_mother = data0{7};
            share_mother = ((ratio_a - 1) / net_value_mother) * share_list(i);
        else
            fprintf('%s�����Ƕ���\n', holding_list{i});
            fprintf('�����ֱ���: A %f B %f\n', ratio_a, ratio_b);
            if (type == 1) 
                %��ǰ�������A��
                tmp = min(ratio_b, 1);
                share_mother = (ratio_a - tmp) * share_list(i);
                share_list(i) = share_list(i) * tmp;
            else
                %��ǰ�������B��
                if (ratio_b > 1)
                    %��1��Ĳ�����Ϊĸ����
                    share_mother = (ratio_b - 1) * share_list(i);
                else
                    %B��ݶ��������
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
    
    %����new_holding_list�е�Ԫ�أ����뵽ԭlist��
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