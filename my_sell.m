% ��������ͷ��
% cash��ʾ���е��ֽ�����
% holdling_list��share_list��ʾ֤ȯ����ͷݶ�
function [cash, holding_list, share_list] = my_sell(w, date, cash, holding_list, share_list, cost_sell)
	cash_sell = calc_netvalue(w, date, 0, holding_list, share_list);
    cash_sell = cash_sell * (1 - cost_sell); % �۳����׷���
    cash = cash + cash_sell;
    holding_list = [];
    share_list = [];
end