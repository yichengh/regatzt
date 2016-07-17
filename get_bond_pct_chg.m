% ��ȡծȯ��Ȩ�ǵ���
% ���ǵ���������-�������ǵ�����<0.1%�����ж�Ϊ��Ȩ��
% ��Ȩ��ʹ�á������ǵ��������ݣ��ǳ�Ȩ�ղ��õġ��ǵ��������ݡ�
function [pct_chg] = get_bound_pct_chg(w, code_list, date)
    pre_close=w.wsd(code_list,'pre_close',date,date,'PriceAdj=CP');
    close=w.wsd(code_list,'close',date,date,'PriceAdj=CP');
    pct=w.wsd(code_list,'pct_chg',date,date,'PriceAdj=CP');
    if (iscell(pct))
        pct = cell2mat(pct);
    end
    if (iscell(pre_close))
        pre_close = cell2mat(pre_close);
    end
    if (iscell(close))
        close = cell2mat(close);
    end
    pct(isnan(pct))=0;
    pre_close(isnan(pre_close))=100;
    close(isnan(close))=100;
    xrday=find(pct-100*(close-pre_close)./pre_close<-0.1);
    pct(xrday)=100*(close(xrday)-pre_close(xrday))./pre_close(xrday);
    pct_chg = pct;
end