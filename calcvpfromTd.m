function vp = calcvpfromTd(Td)
%Calculate vapor pressure (Pa) from Td (C)
%Formula from Huang 2018, https://journals.ametsoc.org/view/journals/apme/57/6/jamc-d-17-0334.1.xml

Td_as1d=reshape(Td,[size(Td,1)*size(Td,2)*size(Td,3)*size(Td,4),1]);
vp_pos=exp(34.494-(4924.99./(Td_as1d+237.1)))./((Td_as1d+105).^1.57);
vp_neg=exp(43.494-(6545.8./(Td_as1d+278)))./((Td_as1d+868).^2);

vp(Td_as1d>0)=vp_pos(Td_as1d>0);
vp(Td_as1d<=0)=vp_neg(Td_as1d<=0);



vp=reshape(vp,[size(Td,1),size(Td,2),size(Td,3),size(Td,4)]);


end

