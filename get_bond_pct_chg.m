% 获取债券复权涨跌幅
% “涨跌幅”数据-“净价涨跌幅”<0.1%，则判断为除权日
% 除权日使用“净价涨跌幅“数据，非除权日采用的“涨跌幅”数据。
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