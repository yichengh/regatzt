% ��������ͷ��
% cash��ʾ���е��ֽ�����
% elements��ʾ��ǰ�ֲ�
function [cash, elements] = my_sell(w, date, cash, elements, cost_sell)
	cash_sell = calc_netvalue(w, date, 0, elements, 0);
    cash_sell = cash_sell * (1 - cost_sell); % �۳����׷���
    cash = cash + cash_sell;
    elements = [];
end