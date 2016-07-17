% 生成一个证券信息元素
% type 0 股票 1 分级A 2 分级B  3 债券
function [ele] = generate_element(code, share, type)
    ele.code = code;
    ele.share = share;
    ele.type = type;
end