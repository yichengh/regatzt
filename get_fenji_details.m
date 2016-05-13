% ��ȡ�ּ�������ϸ
% ����ĸ����A���B��Ĵ��루����֮һ��
% ����% ����ĸ����A���B��Ĵ���
% type ���������������0��ʾĸ����1��ʾA�࣬2��ʾB��
function [code_mother, code_class_a, code_class_b, type] = get_fenji_details(w, date, code)
    para = strcat('date=', date, ';windcode=', code);
    % ����WSET�еĻ���/�ּ�������ϸ����ȡ��Ϣ����ĸ�������ݲ�׼ȷ��
    [data] = w.wset('leveragedfundinfo', para);
    code_class_a = data(5);
    code_class_b = data(7);
    
    % ����WSD�еĻ�������/�ּ����������еķּ�����ĸ������룬��ȡĸ�������
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