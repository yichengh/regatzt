function [code_list, weight] = load_trade_list(filename)
    %filename
    fid = fopen(filename);
    C = textscan(fid, '%s %f');
    code_list = C{1};
    weight = C{2};
    fclose(fid);
end