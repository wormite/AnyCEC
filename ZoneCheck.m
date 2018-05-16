%% see paper Asymmetric design for Compound Elliptical Concentrators (CEC)
%% and its geometric flux implications for zone description, Figure 4.
function zone = ZoneCheck(source_left,source_right,x1,x2,P)
flag1 = CrossProduct(source_left-P,x1);
flag2 = CrossProduct(source_right-P,x2);
if(flag1>0&&flag2<0)
    zone = 3;
elseif(flag1<0&&flag2>0)
    zone = 4;
elseif(flag1==0&&flag2==0)
    zone = 0;
elseif(flag1>0&&flag2>=0)
    zone = 1;
else
    zone = 2;
end
end