function [date] = trade_day_offset(w, date, offset)
    date = w.tdaysoffset(offset, date);
    date=datestr(date,'yyyymmdd');
end