%Symmetric Coevolution
%Jacob Palmer - jacob.palmer@zoo.ox.ac.uk
clc;clear;
%April 19, 2021

%------------------------Leave alone-------------------------------------
n = 3;             %no touchy fishy 
r = zeros(1,n+1);    
r(:,:) = 1;        %Growth rate
tend = 100000;      %Time
Nu1 = 1;
Nu2 = Nu1;
Kn1 = 5;
Kn2 = 5;

%Kmi = 1; %Big number = High MIC.  Low number = low Mic (narrow)
Kmr = 1000;
%Kms = 2; 
Km = 0.05;

DEG = 1;        %0 for no degradation. 1 for degradation

HCE = 1;

%---------------------------Looping------------------------------------
dp = 49;                    %Spectrum steps
dp3 = 99;                    %Production steps
AS = 90;                  %What % increase should the early arriver have before the late arriver

GamRi0 = 0;        %Production rate
GamRiF = 0.95;
GamRs0 = GamRi0;
GamRsF = GamRiF;
GamRr = 0;

cm = 1;           %number of community members 
E = 15;

cy = 0.000;       %Community abundance T0
Sy = 0.000;            %Niche competitor abundance T0
Pry = 0;        %Producer Abundance T0 (resident)
Piy = 0.0001;

Perc1 = AS/2/100*Piy + Piy;
Perc2 = AS/100*Piy + Piy;

Kms0 = Km;
KmsF = 3;
Kmi0 = Km;
KmiF = KmsF;

gamS0 = 0;        %Toxin abundance (Niche Competitor) T0
gamr0 = 0;        %Toxin abundance (resident) T0
gami0 = 0;        %Toxin abundance (invader) T0

NO1 = 0.3;        %Niche overlaps
NO2 = 0;

if DEG == 0
    gamD = .75;         %Constant degradation term
elseif DEG == 1
    gamD = 1;           %Modifier of toxin absorption
end
%--------------------------Leave alone-------------------------------------
tspan = [0 tend];
jt = (KmiF-Kmi0)/dp;
gi = (GamRiF-GamRi0)/dp3;
gr = (GamRsF-GamRs0)/dp3;
GamIndex = GamRi0:gi:GamRiF;

rc = 0; ic = 0; gc = 0; gt = 0;
endvali = zeros(dp3+1,dp3+1);
endvalP = zeros(dp3+1,dp3+1);
endvalM = zeros(dp3+1,dp3+1);
endvali0 = zeros(dp3+1,dp3+1);
SigmaDiag = zeros(1,dp+1);
ESSr = zeros(1,dp+1);
y = [Sy Pry Piy cy gamS0 gamr0 gami0 Nu1 Nu2];
y0 = y;
cr = 0;
eCelery = cell(1,dp+1);

tic
%-------------------------Spectrum------------------------------
for Kmi = Kmi0:jt:KmiF
    Kms = Kmi;
    ic = ic + 1
    gc = 0;
        %------------------Production rate focal------------------
        for GamRi = GamRi0:gi:GamRiF
            gc = gc + 1;
            gt = 0;
            %---------------Production rate resident---------------
            for GamRS = GamRs0:gr:GamRsF
                gt = gt + 1;
                y = [Sy Pry Piy cy gamS0 gamr0 gami0 Nu1 Nu2];
                y0 = y;
                %First time - Early focal Alone
                ci = GamRi; 
                cS = GamRS;
                eventfunc = @(t,y) steadystateNutEx_EarlyTox1(t, y, r, cS, ci, cr, gamD,Kn1,Kn2,Kmi,Kmr,Kms,Km,NO1,NO2,E,DEG,HCE,Perc1);
                optionsode=odeset('Events',eventfunc, 'NonNegative',1:9);
                [t,y,te,ye,ie] = ode45(@(t,y) LVfunc_Ex(t, y, r, cS, ci, cr, gamD,Kn1,Kn2,Kmi,Kmr,Kms,Km,NO1,NO2,E,HCE),tspan, y0,optionsode);
                Q = [t,y];
                %Add Community
                Q(end,5) = Piy;
                y0 = Q(end,2:10);
                eventfunc = @(t,y) steadystateNutEx_EarlyTox2(t, y, r, cS, ci, cr, gamD,Kn1,Kn2,Kmi,Kmr,Kms,Km,NO1,NO2,E,DEG,HCE,Perc2);
                optionsode=odeset('Events',eventfunc, 'NonNegative',1:9);
                [t,y,te,ye,ie] = ode45(@(t,y) LVfunc_Ex(t, y, r, cS, ci, cr, gamD,Kn1,Kn2,Kmi,Kmr,Kms,Km,NO1,NO2,E,HCE),tspan, y0,optionsode);
                Q = [t,y];
                %Add Late Arriver
                Q(end,2) = Piy;
                y0 = Q(end,2:10);
                eventfunc = @(t,y) steadystateNutEx(t, y, r, cS, ci, cr, gamD,Kn1,Kn2,Kmi,Kmr,Kms,Km,NO1,NO2,E,DEG,HCE);
                optionsode=odeset('Events',eventfunc, 'NonNegative',1:9);
                [t,y,te,ye,ie] = ode45(@(t,y) LVfunc_Ex(t, y, r, cS, ci, cr, gamD,Kn1,Kn2,Kmi,Kmr,Kms,Km,NO1,NO2,E,HCE),tspan, y0,optionsode);
                Q = [t,y];
                endvalM(gc,gt) = Q(end,4);

                %do it again, but this time favouring the conspecific
                y = [Piy Pry Sy cy gamS0 gamr0 gami0 Nu1 Nu2];  %Note that I just moved location of Piy and Sy.  Conspecific is still y1 and focal is y3
                y0 = y;
                eventfunc = @(t,y) steadystateNutEx_EarlyTox1(t, y, r, cS, ci, cr, gamD,Kn1,Kn2,Kmi,Kmr,Kms,Km,NO1,NO2,E,DEG,HCE,Perc1);
                optionsode=odeset('Events',eventfunc, 'NonNegative',1:9);
                [t,y,te,ye,ie] = ode45(@(t,y) LVfunc_Ex(t, y, r, cS, ci, cr, gamD,Kn1,Kn2,Kmi,Kmr,Kms,Km,NO1,NO2,E,HCE),tspan, y0,optionsode);
                R = [t,y];
                
                %add the community
                R(end,5) = Piy;
                y0 = R(end,2:10);
                eventfunc = @(t,y) steadystateNutEx_EarlyTox2(t, y, r, cS, ci, cr, gamD,Kn1,Kn2,Kmi,Kmr,Kms,Km,NO1,NO2,E,DEG,HCE,Perc2);
                optionsode=odeset('Events',eventfunc, 'NonNegative',1:9);
                [t,y,te,ye,ie] = ode45(@(t,y) LVfunc_Ex(t, y, r, cS, ci, cr, gamD,Kn1,Kn2,Kmi,Kmr,Kms,Km,NO1,NO2,E,HCE),tspan, y0,optionsode);
                R = [t,y];
                
                %Add focal
                R(end,4) = Piy;
                y0 = R(end, 2:10);
                eventfunc = @(t,y) steadystateNutEx(t, y, r, cS, ci, cr, gamD,Kn1,Kn2,Kmi,Kmr,Kms,Km,NO1,NO2,E,DEG,HCE);
                optionsode=odeset('Events',eventfunc, 'NonNegative',1:9);
                [t,y,te,ye,ie] = ode45(@(t,y) LVfunc_Ex(t, y, r, cS, ci, cr, gamD,Kn1,Kn2,Kmi,Kmr,Kms,Km,NO1,NO2,E,HCE),tspan, y0,optionsode);
                R = [t,y];
                endvalP(gc,gt) = R(end,4);
                
                endvali(gc,gt) = (Q(end,4)+R(end,4))/2;

            end
        end
        eCelery{1,ic} = endvali;

end   

save('C:\Users\jdpal\Desktop\Local\PNAS_Revisions\Data\Supplement3b_EarlyToxins_AS_90_GamRiF_0-95_dp_49_dp3_99','eCelery')


tim = toc
persec = (dp*dp3*dp3) / tim
% load splat
% sound(y,Fs)
