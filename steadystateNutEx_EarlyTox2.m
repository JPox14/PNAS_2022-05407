function [value,isterminal,direction] = steadystateNutEx_EarlyTox2(t, y, r, cS, ci, cr, gamD,Kn1,Kn2,Kmi,Kmr,Kms,Km,NO1,NO2,E,DEG,HCE,Perc2)


%must decide what to do below
if DEG == 1
    dy = LVfunc_Ex(t, y, r, cS, ci, cr, gamD,Kn1,Kn2,Kmi,Kmr,Kms,Km,NO1,NO2,E,HCE);
else
    dy = LVfunc_Ex_NoDeg(t, y, r, cS, ci, cr, gamD,Kn1,Kn2,Kmi,Kmr,Kms,Km,NO1,NO2,E,HCE);
end
    
%Record when steady state is reached
SS = y(3)+y(1);

val1 = Perc2 - SS;

value = val1;
isterminal = 1;
direction = -1;

end