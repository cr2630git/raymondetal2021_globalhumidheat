

reloadstatsandbasedata=0; %15 min
readsavedailymax=0; %35 hours total
    actualmax=1; %default is 1
determine90warmestdays=0; %8 min per year
determine3warmestmonths=0; %1 min
corestats=0; %15 hours total (5 hours for each of MSE, Qh, and Ql)
    domsepart=1;
    doqhpart=1;
    doqlpart=1;
whereextremesoccur=0;
globalstats=0; %7.5 hr total (3 hours for MSE, 4.5 hours for Qh+Ql) 
readsst=0; %10 min
makearrwithp999andp99gridptdaysonly=0; %2 hours
p999pblheights=0; %1 hr 40 min
pblheightsforprofileextremedays=0; %2 hours
dateofalltimemax=0; %3.5 hours
timelineaddition_smonly=0; %adds soil moisture
    if timelineaddition_smonly==1
    beginrow=200;endrow=480;
    begincol=200;endcol=1360;
    end
timelineaddition_preciponly=0; %adds CHIRPS precip data
    if timelineaddition_preciponly==1
    beginrow=200;endrow=480;
    begincol=200;endcol=1360;
    end
quicksstanoms=0;
quickpressureanoms=0;
quickprecipanoms=0; %45 min total
getfulldistnsoftimelinevariables=0; %3.5 hours per year
    if getfulldistnsoftimelinevariables==1
    reloadalldataforyear=1;
    end
getfulldistnsofspecificvars=0;
    dolwsw=0; %20 min per year
    douvw=1; %20 min per year
makefinalfigures=1;
    mapandlatprofilefigure=0; %figure 1
    bigtimelinefigure=0; %figure 3
        btfprelimcalc=0; %reloading: 3 min per year; then, about 40 min for 6 years
            doasoffset=0; %if 1, lines up all extreme-MSE occurrences at the same column of extrarr
            subregtodo=0; %if doing a subreg at all, which one? (0 means all of them)
            startvar=1;stopvar=15; %defaults are 1 and 15
            usingchirpsforpg=1;
            mainlevel=3;secondarylevel=2; %options are 3 (corresponding to 100m), 2 (corresponding to 700mb), or 1 (corresponding to 300mb)
            doserioustroubleshooting=0;
        btffinalcalcandplot=1; %30 sec
            inclmss=0;
            if btffinalcalcandplot==1;smoothamts=[3;3;3;3];end
    variouscompositemaps=0;
    venndiagram=1; %30 min for dolhf, doshf, or douvandw; 3 min for reloadandplotall; creates figure 4 and figure s15
        dosw=0;dolhf=0;doshf=0;douvandw=0;dossts=0;doqbelowmtns=0;dorh=0;
        reloadandplotall=1;
            makefigs11=1;
            inclneighbors=1; %default is 0
    actualtimeseriessifigure=0; %figures s1-s4
        subreg1=1;subreg2=5;
        if actualtimeseriessifigure==1;smoothamts=[1;1;1;1];end
    regioncomparisonsifigure=0; %figure s2
    sstanomsifigure=0; %figure s10
    amazonterrainsifigure=0;
    moistenthalpywetbulbsifigure=0;
    
    
    
    
startyear=1979;stopyear=2018;numyears=stopyear-startyear+1;

cp=1005.7; %J K^-1 kg^-1
lv=2.265.*10.^6; %J/kg

icloud='~/Library/Mobile Documents/com~apple~CloudDocs/';
figloc=strcat(icloud,'General_Academics/Research/Heat_Humidity_Limits/');
mainera5dir='/Volumes/ExternalDriveZ/ERA5_Hourly_Data/';
processedera5dir='/Volumes/ExternalDriveZ/ERA5_HHLcalcs/';
echo off;echo off all;
format shortG;

monthnames={'jan';'feb';'mar';'apr';'may';'jun';'jul';'aug';'sep';'oct';'nov';'dec'};
monstarts=[1;32;60;91;121;152;182;213;244;274;305;335];
monstops=[31;59;90;120;151;181;212;243;273;304;334;365];
rowstems={'rows1to100';'rows101to200';'rows201to300';'rows301to400';'rows401to500';'rows501to600';'rows601to700';'rows701to721'};
numrows=[100;100;100;100;100;100;100;21];
    
lats1x1=89.5:-1:-89.5;lons1x1=-179.5:1:179.5;
for row=1:180
    for col=1:360
        latsarray1x1(row,col)=lats1x1(row);
        lonsarray1x1(row,col)=lons1x1(col);
    end
end
nceplatvec=90:-2.5:-90;nceplonvec=-177.5:2.5:180;
for row=1:73
    for col=1:144
        nceplatarr(row,col)=nceplatvec(row);
        nceplonarr(row,col)=nceplonvec(col);
    end
end
exist mllats_unrotated;
if ans==0
    mllatlonspacing=0.28125;
    mllat=90-mllatlonspacing/2:-mllatlonspacing:-90+mllatlonspacing/2;
    mllon=[mllatlonspacing/2:mllatlonspacing:180-mllatlonspacing/2 -180+mllatlonspacing/2:mllatlonspacing:-mllatlonspacing/2];
    for i=1:1280
        for j=1:640
            mllats_unrotated(i,j)=mllat(j);
            mllons_unrotated(i,j)=mllon(i);
        end
    end
end

%Sample Persian Gulf point: row 262, col 933
%Sample Pakistan point: row 248, col 1005
%Sample e South Asia point: row 272, col 1072
%Sample Amazon point: row 379, col 469

%321x1440 grids represent 45N-35S -- i.e. 721x1440 rows 181-501
%281x1440 grids represent 40N-30S

%Persian Gulf -- 18.5-35 N, 43.5-62.25 E
    %south shore subreg: 23-25.5 N, 52.13-56.13 E
%Pakistan -- 21.5-38 N, 62.5-77.25 E
    %northern Indus subreg: 30-35 N, 69.63-73.13 E
%E S Asia -- 15-27.5 N, 78.75-98.75 E
    %ne India subreg: 20-27 N, 84.88-89.88 E
%Gulf of California -- 23.25-28.75 N, 110-104.5 W
%W Amazon -- 18.75-2.5 S, 75-61.25 W
    %subreg: 18.5-13 S, 68.88-61.88 W
%Red Sea -- 13-26 N, 34-44 E
%N Australia -- 21-11 S, 133-143 E
%Midwest US -- 28-50 N, 103-82 W
%Caspian Sea -- 33-49 N, 44-60 E
regnames={'Persian Gulf';'Pakistan';'E South Asia';'Gulf of California';'W Amazon';'Red Sea';'N Australia';'Midwest US';'Caspian Sea';'E China';...
    'N South America';'E Mexico';'SE S America';'W Africa';'Southeast Asia';'Maritime Continent';'Central Africa';'Gulf of Aden';'E Amazon'};
regnames_shorter={'Persian Gulf';'Pakistan';'E South Asia';'Gulf of Calif.';'W Amazon';'Red Sea';'N Australia';'MW US';'Caspian';'E China';...
    'N S Amer.';'E Mexico';'SE S Amer.';'W Africa';'SE Asia';'Maritime Cont.';'C Africa';'Gulf of Aden';'E Amazon'};
regnames_veryshort={'PG';'NW SAsia';'E SAsia';'GoC';'W Amaz';'Red';'N Aus';'MW US';'Casp';'E China';...
    'N SAmer';'E Mex';'SE SAmer';'W Afr';'SE Asia';'M Cont';'C Africa';'GoA';'E Amaz'};
regnamesforfigs={'persiangulf';'pakistan';'esasia';'gulfofcalif';'wamazon';'redsea';'naustralia';'midwestus';'caspiansea';'echina';...
    'nsamer';'emex';'sesamer';'wafrica';'seasia';'maritimecont';'cafrica';'gulfofaden';'eamaz'};
%Latitude/longitude bounds for each region
regsouthbounds=[18.5;21.5;15;21.75;-18.75;13;-21;29;35;27.5;4.25;15.75;-30.75;8.25;11.75;-2.5;-3;10;-22.5];
regnorthbounds=[35;38;27.5;32.75;-2.5;26;-11;45;49;39.5;11.5;22.5;-22.5;18.75;25;4;5.5;18.5;0];
regwestbounds=[43.5;62.5;78;-115;-75;34;119;-98;44.25;103.5;-78.25;-99.25;-60.25;-15.75;102.25;100.25;14.75;44;-61.25];
regeastbounds=[62.25;78;98.75;-104.5;-61.25;44;143;-84.5;60;121.75;-62.5;-87.5;-45.25;-0.75;116.75;118;24.75;53.5;-51.25];
subregsouthbounds=[23;30;20;0;-18.5];subregnorthbounds=[25.5;35;27;0;-13];
subregwestbounds=[52.13;69.63;84.88;0;-68.88];subregeastbounds=[56.13;73.13;89.88;0;-61.88];
%Regional bounds using ERA5 721x1440 grid
actualrowstarts=[221;209;251;230;371;257;405;181;165;203;315;271;451;286;261;345;339;287;361];
actualrowstops=[287;275;301;274;436;309;445;245;221;251;344;298;484;328;314;371;373;321;451];
actualcolstarts=[894.5;970.5;1032.5;260.5;420.5;856.5;1196.5;328.5;897.5;1134.5;...
    407.5;323.5;479.5;657.5;1129.5;1121.5;779.5;896.5;475.5];
actualcolstops=[969.5;1032.5;1115.5;302.5;475.5;896.5;1292.5;382.5;960.5;1207.5;...
    470.5;370.5;539.5;717.5;1187.5;1192.5;819.5;934.5;515.5];
actualcolstartsalt=[174.5;250.5;312.5;980.5;1140.5;136.5;476.5;1048.5;177.5;414.5;...
    1127.5;1043.5;1199.5;1377.5;409.5;401.5;59.5;176.5;1195.5];
actualcolstopsalt=[249.5;312.5;395.5;1022.5;1195.5;176.5;572.5;1102.5;240.5;487.5;...
    1190.5;1090.5;1259.5;1437.5;467.5;472.5;99.5;214.5;1235.5];
%Regional bounds using unrotated regional-subset model-level grid
mlstartrows=[156;223;281;890;1014;122;474];mlstoprows=[221;275;351;908;1062;156;508]; %using mllons_unrotated
mlstartcols=[197;186;223;219;330;229;360];mlstopcols=[254;244;267;237;387;274;395]; %using mllats_unrotated


subregrowstarts=[259;221;253;0;413];subregrowstops=[269;241;281;0;435];subregcolstarts=[929;999;1060;0;445];subregcolstops=[945;1013;1080;0;473];


%Model levels (approximately):
%137 -- 1012 mb -- 10 m
%135 -- 1007 mb -- 54 m
%133 -- 1000 mb -- 107 m
%130 -- 989 mb -- 205 m
%127 -- 974 mb -- 334 m
%124 -- 955 mb -- 501 m
%118 -- 900 mb -- 987 m
%114 -- 850 mb -- 1460 m
%105 -- 700 mb
%96 -- 500 mb
%83 -- 300 mb
%74 -- 200 mb

%Using pressurefromelev.m:
avgelevs_era5levs=[11700;9050;5470;2900;1350;880;430;213;0];
avgelevs_soundinglevs=[11700;9050;5470;2900;1350;880;430;213;127;42];
avgelevs_mllevs=[11700;9100;5550;3000;1450;970;480;310;180;100;45;0];

pressures_forml=[200;300;500;700;850;900;954;975;990;1000;1006;1012];
mlevels=[10;54;107;205;334;501;987;1460;3000;5500;9100;11700]; %approximate heights above ground, in meters
mls_retrieved=[74;83;96;105;114;118;124;127;130;133;135;137]; %ordinates of retrieved levels, spanning from 200 to sfc (or more, when sfc is above sea level)
mls_retrieved_uvw=[74;83;96;100;[105:137]'];%mls_retrieved_uvw=mls_retrieved;
mls_retrieved_9=[74;83;96;105;114;118;124;127;133];

currentfirstyearcalc=1979;currentlastyearcalc=2018;numyearscalc=currentlastyearcalc-currentfirstyearcalc+1;
monthstarts_daily=[1;32;60;91;121;152;182;213;244;274;305;335];
monthends_daily=[31;59;90;120;151;181;212;243;273;304;334;365];




if reloadstatsandbasedata==1
    setup_nctoolbox;
    thisfile=load(strcat(processedera5dir,'mseqhqlstats'));
    maxmsebypoint=thisfile.maxmsebypoint;p999msebypoint=thisfile.p999msebypoint;p99msebypoint=thisfile.p99msebypoint;p50msebypoint=thisfile.p50msebypoint;
    maxqhbypoint=thisfile.maxqhbypoint;p99qhbypoint=thisfile.p99qhbypoint;p50qhbypoint=thisfile.p50qhbypoint;
    maxqlbypoint=thisfile.maxqlbypoint;p99qlbypoint=thisfile.p99qlbypoint;p50qlbypoint=thisfile.p50qlbypoint;
    p50mseglobal=thisfile.p50mseglobal;p90mseglobal=thisfile.p90mseglobal;p99mseglobal=thisfile.p99mseglobal;
    p995mseglobal=thisfile.p995mseglobal;p999mseglobal=thisfile.p999mseglobal;p9999mseglobal=thisfile.p9999mseglobal;
    maxmse_latbandavg=thisfile.maxmse_latbandavg;maxqh_latbandavg=thisfile.maxqh_latbandavg;maxql_latbandavg=thisfile.maxql_latbandavg;
    p999mse_latbandavg=thisfile.p999mse_latbandavg;
    p99mse_latbandavg=thisfile.p99mse_latbandavg;p99qh_latbandavg=thisfile.p99qh_latbandavg;p99ql_latbandavg=thisfile.p99ql_latbandavg;
    p50mse_latbandavg=thisfile.p50mse_latbandavg;
    maxmsebyyear=temp.maxmsebyyear;
    pct9999msebyyear=temp.pct9999msebyyear;
    pct999msebyyear=temp.pct999msebyyear;
    pct99msebyyear=temp.pct99msebyyear;
    pct90msebyyear=temp.pct90msebyyear;
    pct50msebyyear=temp.pct50msebyyear;
    pct9999qhbyyearERA5=temp.pct9999qhbyyearERA5;
    pct999qhbyyearERA5=temp.pct999qhbyyearERA5;
    pct99qhbyyearERA5=temp.pct99qhbyyearERA5;
    pct90qhbyyearERA5=temp.pct90qhbyyearERA5;
    pct50qhbyyearERA5=temp.pct50qhbyyearERA5;
    pct9999qlbyyearERA5=temp.pct9999qlbyyearERA5;
    pct999qlbyyearERA5=temp.pct999qlbyyearERA5;
    pct99qlbyyearERA5=temp.pct99qlbyyearERA5;
    pct90qlbyyearERA5=temp.pct90qlbyyearERA5;
    pct50qlbyyearERA5=temp.pct50qlbyyearERA5;
    temp=load(strcat(icloud,'General_Academics/Research/Basics/Basics_ERA5/latlonarray'));era5latarray=temp.latarray;era5lonarray=temp.lonarray;
        era5lonarray=[era5lonarray(:,721:1440) era5lonarray(:,1:720)];
    temp=ncread('elevera5.nc','z');elevera5=(squeeze(temp(:,:,1))./9.81)';
        elevera5=[elevera5(:,721:1440) elevera5(:,1:720)];
    temp=load(strcat(processedera5dir,'extrememsearrays'));
    codes=temp.codes;
    temp=load(strcat(processedera5dir,'variabilitystats_global'));
    assocqh_global=temp.assocqh_global;
    assocql_global=temp.assocql_global;
    dates_global=temp.dates_global;
    msep99_global=temp.msep99_global;
    p99cbygridpt=temp.p99cbygridpt;
    assocqh_max_global=temp.assocqh_max_global;assocqh_min_global=temp.assocqh_min_global;
    assocqh_mean_global=temp.assocqh_mean_global;
    assocqh_mean_global_nonextreme=temp.assocqh_mean_global_nonextreme;
    assocql_max_global=temp.assocql_max_global;assocql_min_global=temp.assocql_min_global;
    assocql_mean_global=temp.assocql_mean_global;
    assocql_mean_global_nonextreme=temp.assocql_mean_global_nonextreme;
    assocpsfc_global=temp.assocpsfc_global;
    assocpsfc_mean_global=temp.assocpsfc_mean_global;
    assoct_global=temp.assoct_global;assoct_mean_global=temp.assoct_mean_global;
    assoctd_global=temp.assoctd_global;assoctd_mean_global=temp.assoctd_mean_global;
    assoctimeofmax_global=temp.assoctimeofmax_global;
    assoctimeofmax_mean_global=temp.assoctimeofmax_mean_global;
    assoctimeofmax_mode_global=temp.assoctimeofmax_mode_global;
    temp=load(strcat(processedera5dir,'toppctilestats'));
    arrwithallp999=temp.arrwithallp999;
    arrwithallp995=temp.arrwithallp995;
    arrwithallp99=temp.arrwithallp99;
    arrwithallp99formidlats=temp.arrwithallp99formidlats;
    temp=load(strcat(processedera5dir,'variabilitystats_local'));
    assocqh_local=temp.assocqh_local;
    assocqh_mean_local=temp.assocqh_mean_local;
    assocql_local=temp.assocql_local;
    assocql_mean_local=temp.assocql_mean_local;
    dates_local=temp.dates_local;
    msethispct_local=temp.msethispct_local;
    nonextremecbygridpt=temp.nonextremecbygridpt;
    temp=load(strcat(processedera5dir,'variabilitystats_addendum'));
    assoct_local=temp.assoct;
    assoctd_local=temp.assoctd;
    assocpsfc_local=temp.assocpsfc;
    assoctimeofmax_local=temp.assoctimeofmax;
    assoct_mean_local=temp.assoct_mean_local; %for all locations, exceeding their local p99 MSE
    assoctd_mean_local=temp.assoctd_mean_local;
    assocpsfc_mean_local=temp.assocpsfc_mean_local;
    assoctimeofmax_mean_local=temp.assoctimeofmax_mean_local;
    temp=load(strcat(processedera5dir,'pblhp999days.mat'));
    p999pblharr=temp.p999pblharr;
    saveddateinfo=temp.saveddateinfo;
    temp=load(strcat(processedera5dir,'climtopmsedays'));
    topdays=temp.topdays;
    temp=load(strcat(processedera5dir,'timeofmaxmse'));
    finalmaxyears=temp.finalmaxyears;
    finalmaxdoys=temp.finalmaxdoys;
    finalmaxhours=temp.finalmaxhours;
    temp=load(strcat(processedera5dir,'qhqlofmaxmse'));
    qhattimeofalltimemax=temp.qhattimeofalltimemax;
    qlattimeofalltimemax=temp.qlattimeofalltimemax;
    temp=load(strcat(icloud,'General_Academics/Research/Heat_Humidity_Limits/oisstarrays.mat'));
    globalmaxsstbyyear=temp.globalmaxsstbyyear;
    globaltropmeansstbyyear=temp.globaltropmeansstbyyear;
    temp=load(strcat(processedera5dir,'vertprofilearrays'));
    msep9Xera5=temp.msep9X;msep9Xera5unadj=temp.msep9Xera5unadj;
    mse_remainderera5=temp.mse_remainder;mse_remainderera5unadj=temp.mse_remainderera5unadj;
    malrp9Xera5=temp.malrp9X;
    malr_remainderera5=temp.malr_remainder;
    twcompositebg=temp.twcompositebyreg;
    twcompositesoundings=temp.twcompositesoundings;
    tcompositesoundings=temp.tcompositebyreg;
    tdcompositesoundings=temp.tdcompositebyreg;
    winddircompositesoundings=temp.winddircompositebyreg;
    windspdcompositesoundings=temp.windspdcompositebyreg;
    numsoundinglevels=temp.numsoundinglevels;
    msecompositesoundings=temp.msecompositesoundings;
    msecompositebyreg=temp.msecompositebyreg;
    saturationmsep9Xera5=temp.saturationmseera5;saturationmsep9Xera5unadj=temp.saturationmseera5unadj;
    tp9Xera5=temp.tp9Xera5;tp9Xera5unadj=temp.tp9Xera5unadj;
    qp9Xera5=temp.qp9Xera5;qp9Xera5unadj=temp.qp9Xera5unadj;
    t_remainderera5=temp.t_remainderera5;t_remainderera5unadj=temp.t_remainderera5unadj;
    q_remainderera5=temp.q_remainderera5;q_remainderera5unadj=temp.q_remainderera5unadj;
    saturationmse_remainderera5=temp.saturationmse_remainderera5;saturationmse_remainderera5unadj=temp.saturationmse_remainderera5unadj;
    newarrwithtprofilep9X=temp.newarrwithtprofilep9X;
    newarrwithqprofilep9X=temp.newarrwithqprofilep9X;
    newarrwithtprofile_remainder=temp.newarrwithtprofile_remainder;
    newarrwithqprofile_remainder=temp.newarrwithqprofile_remainder;
    newsavethedatesandlocsp9X=temp.newsavethedatesandlocsp9X;
    newsavethedatesandlocs_remainder=temp.newsavethedatesandlocs_remainder;
    newiiconversion=temp.newiiconversion;
    newiiconversion_remainder=temp.newiiconversion_remainder;
    temp=load(strcat(processedera5dir,'pblhforprofiles.mat'));
    pblhmeanprofileextremedays=temp.pblhmeanprofileextremedays;
    pblhdistnprofileextremedays=temp.pblhdistnprofileextremedays;
    regsubsetexpalltogether=temp.regsubsetexpalltogether;
    pblhmeanprofileremainderdays=temp.pblhmeanprofileremainderdays;
    pblhdistnprofileremainderdays=temp.pblhdistnprofileremainderdays;
    regsubsetexpalltogether_remainder=temp.regsubsetexpalltogether_remainder;
    temp=load(strcat(processedera5dir,'msebudgetoutput.mat'));
    iediff_final=temp.iediff_final;
    adv_horiz_final=temp.adv_horiz_final;
    adv_vert_final=temp.adv_vert_final;
    netsolar_final=temp.netsolar_final;
    netthermal_final=temp.netthermal_final;
    sfcsensible_final=temp.sfcsensible_final;
    sfclatent_final=temp.sfclatent_final;
    
    temp=load(strcat(processedera5dir,'someotherclimostats'));
    meanannualrh=temp.meanannualrh;
end

exist lsmask;
if ans==0
    lsmask=ncread(strcat(icloud,'General_Academics/Research/Basics/Basics_ERA5/lsmask_era5.nc'),'lsm');lsmask=lsmask';
    lsmask=[lsmask(:,721:1440) lsmask(:,1:720)];
end

if readsavedailymax==1
    setup_nctoolbox;
    exist elevera5;
    if ans==0
        temp=ncread('elevera5.nc','z');elevera5=(squeeze(temp(:,:,1))./9.81)';
        elevera5=[elevera5(:,721:1440) elevera5(:,1:720)];
        temp=load(strcat(icloud,'General_Academics/Research/Basics/Basics_ERA5/latlonarray'));era5latarray=temp.latarray;era5lonarray=temp.lonarray;
        era5lonarray=[era5lonarray(:,721:1440) era5lonarray(:,1:720)];
    end
    for year=currentfirstyearcalc:currentlastyearcalc
        if year<=1999;extdriveloc='F/ERA5_Hourly_Data_1979to1999';else;extdriveloc='Z/ERA5_Hourly_Data';end
        file=ncgeodataset(strcat('/Volumes/ExternalDrive',extdriveloc,'/ttd_world_',num2str(year),'.grib'));
        psfcfile=ncgeodataset(strcat('/Volumes/ExternalDriveC/ERA5_Hourly_Data_PandGHonly/psfc_world_',num2str(year),'.grib'));
        
        %Calculate daily-max MSE, as well as its *simultaneous* components Qh and Ql, at each gridpt

        daysperarray=365;
        dailymaxmserows1to100=NaN.*ones(daysperarray,100,1440);dailymaxmserows101to200=NaN.*ones(daysperarray,100,1440);
        dailymaxmserows201to300=NaN.*ones(daysperarray,100,1440);dailymaxmserows301to400=NaN.*ones(daysperarray,100,1440);
        dailymaxmserows401to500=NaN.*ones(daysperarray,100,1440);dailymaxmserows501to600=NaN.*ones(daysperarray,100,1440);
        dailymaxmserows601to700=NaN.*ones(daysperarray,100,1440);dailymaxmserows701to721=NaN.*ones(daysperarray,21,1440);
        qhrows1to100=NaN.*ones(daysperarray,100,1440);qhrows101to200=NaN.*ones(daysperarray,100,1440);
        qhrows201to300=NaN.*ones(daysperarray,100,1440);qhrows301to400=NaN.*ones(daysperarray,100,1440);
        qhrows401to500=NaN.*ones(daysperarray,100,1440);qhrows501to600=NaN.*ones(daysperarray,100,1440);
        qhrows601to700=NaN.*ones(daysperarray,100,1440);qhrows701to721=NaN.*ones(daysperarray,21,1440);
        qlrows1to100=NaN.*ones(daysperarray,100,1440);qlrows101to200=NaN.*ones(daysperarray,100,1440);
        qlrows201to300=NaN.*ones(daysperarray,100,1440);qlrows301to400=NaN.*ones(daysperarray,100,1440);
        qlrows401to500=NaN.*ones(daysperarray,100,1440);qlrows501to600=NaN.*ones(daysperarray,100,1440);
        qlrows601to700=NaN.*ones(daysperarray,100,1440);qlrows701to721=NaN.*ones(daysperarray,21,1440);

        loopstartdays=[1;38;74;111;147;184;220;257;293;330];loopnumdays=36;

        numloops=10; %number of loops is large enough to not cause a Java-heap-memory error
        sz=2920/numloops;
        for loop=1:numloops
        %for loop=1:1

            %2 min from here
            ttemp=file{'2_metre_temperature_surface'};echo off; %T in K
            t=double(ttemp.data(sz*loop-(sz-1):sz*loop,:,:));clear ttemp;
            tdtemp=file{'2_metre_dewpoint_temperature_surface'};echo off; %Td in K
            td=double(tdtemp.data(sz*loop-(sz-1):sz*loop,:,:))-273.15;clear tdtemp;

            psfctemp=psfcfile{'Surface_pressure_surface'};echo off; %in Pa
            psfc=double(psfctemp.data(sz*loop-(sz-1):sz*loop,:,:));clear psfctemp;
            psfc=cat(3,psfc(:,:,721:1440),psfc(:,:,1:720)); 
            %...to here

            %This calculation exactly follows Matthews 2018 figure 2
            %2 min from here
            vp=calcvpfromTd(td); %in Pa
            mr=622.197.*(vp./(psfc-vp))./1000;clear vp;
            omega=calcqfromTd_dynamicP(td,psfc);clear td;clear psfc; %convert to unitless specific humidity

            %cp=1005.7.*(1+1.83.*mr);clear mr; %J K^-1 kg^-1; Stull, Practical Meteorology
            cp=(1005.7.*(1-mr))+(mr.*(1-mr).*1850);clear mr; %J K^-1 kg^-1; Stull, Practical Meteorology
            qh=cp.*t;clear cp;

            lv=1918.46.*((t./(t-33.91)).^2);clear t; %J/kg; Henderson-Sellers 1984
            ql=lv.*omega;clear lv;clear omega; %kJ/kg
            
            elevarraytomatch=[elevera5(:,721:1440) elevera5(:,1:720)];
            %gz=elevarraytomatch.*9.81;gz_rep=repmat(gz,[1 1 292]);gz_rep=permute(gz_rep,[3 1 2]);

            %mse=(qh+ql+gz_rep)./1000; %kJ/kg
            mse=(qh+ql)./1000; %kJ/kg
            
            if rem(loop/2,1)==0 %even loop
                istart=12;iend=loopnumdays*8+4;
            else %odd loop
                istart=8;iend=loopnumdays*8;
            end
            %...to here
            
            

            for i=istart:8:iend %each run of this loop represents a single day
                if actualmax==1 %MSE calculated from 3-hourly combinations of T and Td
                    if rem(loop/2,1)==0
                        day=loopstartdays(loop)+(i-4)/8-1;
                    else
                        day=loopstartdays(loop)+i/8-1;
                    end
                    [a,b]=max(mse(i-7:i,:,:));
                    a=squeeze(a);b=squeeze(b);

                    dailymaxmserows1to100(day,:,:)=a(1:100,:);dailymaxmserows101to200(day,:,:)=a(101:200,:);
                    dailymaxmserows201to300(day,:,:)=a(201:300,:);dailymaxmserows301to400(day,:,:)=a(301:400,:);
                    dailymaxmserows401to500(day,:,:)=a(401:500,:);dailymaxmserows501to600(day,:,:)=a(501:600,:);
                    dailymaxmserows601to700(day,:,:)=a(601:700,:);dailymaxmserows701to721(day,:,:)=a(701:721,:);
                    
                    %'Max' includes values for hour of max MSE and a bunch of NaNs otherwise
                    toreplace=b~=1;testqh_thisday1=qh(i-8+1,:,:);testqh_thisday1(toreplace)=NaN;
                    toreplace=b~=2;testqh_thisday2=qh(i-8+2,:,:);testqh_thisday2(toreplace)=NaN;
                    toreplace=b~=3;testqh_thisday3=qh(i-8+3,:,:);testqh_thisday3(toreplace)=NaN;
                    toreplace=b~=4;testqh_thisday4=qh(i-8+4,:,:);testqh_thisday4(toreplace)=NaN;
                    toreplace=b~=5;testqh_thisday5=qh(i-8+5,:,:);testqh_thisday5(toreplace)=NaN;
                    toreplace=b~=6;testqh_thisday6=qh(i-8+6,:,:);testqh_thisday6(toreplace)=NaN;
                    toreplace=b~=7;testqh_thisday7=qh(i-8+7,:,:);testqh_thisday7(toreplace)=NaN;
                    toreplace=b~=8;testqh_thisday8=qh(i-8+8,:,:);testqh_thisday8(toreplace)=NaN;
                    tmp=cat(1,testqh_thisday1,testqh_thisday2,testqh_thisday3,testqh_thisday4,testqh_thisday5,testqh_thisday6,testqh_thisday7,testqh_thisday8);
                    qhrows1to100(day,:,:)=squeeze(max(tmp(:,1:100,:)));
                    qhrows101to200(day,:,:)=squeeze(max(tmp(:,101:200,:)));
                    qhrows201to300(day,:,:)=squeeze(max(tmp(:,201:300,:)));
                    qhrows301to400(day,:,:)=squeeze(max(tmp(:,301:400,:)));
                    qhrows401to500(day,:,:)=squeeze(max(tmp(:,401:500,:)));
                    qhrows501to600(day,:,:)=squeeze(max(tmp(:,501:600,:)));
                    qhrows601to700(day,:,:)=squeeze(max(tmp(:,601:700,:)));
                    qhrows701to721(day,:,:)=squeeze(max(tmp(:,701:721,:)));
                    
                    toreplace=b~=1;testql_thisday1=ql(i-8+1,:,:);testql_thisday1(toreplace)=NaN;
                    toreplace=b~=2;testql_thisday2=ql(i-8+2,:,:);testql_thisday2(toreplace)=NaN;
                    toreplace=b~=3;testql_thisday3=ql(i-8+3,:,:);testql_thisday3(toreplace)=NaN;
                    toreplace=b~=4;testql_thisday4=ql(i-8+4,:,:);testql_thisday4(toreplace)=NaN;
                    toreplace=b~=5;testql_thisday5=ql(i-8+5,:,:);testql_thisday5(toreplace)=NaN;
                    toreplace=b~=6;testql_thisday6=ql(i-8+6,:,:);testql_thisday6(toreplace)=NaN;
                    toreplace=b~=7;testql_thisday7=ql(i-8+7,:,:);testql_thisday7(toreplace)=NaN;
                    toreplace=b~=8;testql_thisday8=ql(i-8+8,:,:);testql_thisday8(toreplace)=NaN;
                    tmp=cat(1,testql_thisday1,testql_thisday2,testql_thisday3,testql_thisday4,testql_thisday5,testql_thisday6,testql_thisday7,testql_thisday8);
                    qlrows1to100(day,:,:)=squeeze(max(tmp(:,1:100,:)));
                    qlrows101to200(day,:,:)=squeeze(max(tmp(:,101:200,:)));
                    qlrows201to300(day,:,:)=squeeze(max(tmp(:,201:300,:)));
                    qlrows301to400(day,:,:)=squeeze(max(tmp(:,301:400,:)));
                    qlrows401to500(day,:,:)=squeeze(max(tmp(:,401:500,:)));
                    qlrows501to600(day,:,:)=squeeze(max(tmp(:,501:600,:)));
                    qlrows601to700(day,:,:)=squeeze(max(tmp(:,601:700,:)));
                    qlrows701to721(day,:,:)=squeeze(max(tmp(:,701:721,:)));
                    
                    dooldway=0;
                    if dooldway==1
                        for row=1:100;for col=1:1440;qhrows1to100(day,row,col)=qh(i-8+(b(row,col)),row,col);
                                qlrows1to100(day,row,col)=ql(i-8+(b(row,col)),row,col);end;end
                        for row=1:100;for col=1:1440;qhrows101to200(day,row,col)=qh(i-8+(b(row,col)),row+100,col);
                                qlrows101to200(day,row,col)=ql(i-8+(b(row,col)),row+100,col);end;end
                        for row=1:100;for col=1:1440;qhrows201to300(day,row,col)=qh(i-8+(b(row,col)),row+200,col);
                                qlrows201to300(day,row,col)=ql(i-8+(b(row,col)),row+200,col);end;end
                        for row=1:100;for col=1:1440;qhrows301to400(day,row,col)=qh(i-8+(b(row,col)),row+300,col);
                                qlrows301to400(day,row,col)=ql(i-8+(b(row,col)),row+300,col);end;end
                        for row=1:100;for col=1:1440;qhrows401to500(day,row,col)=qh(i-8+(b(row,col)),row+400,col);
                                qlrows401to500(day,row,col)=ql(i-8+(b(row,col)),row+400,col);end;end
                        for row=1:100;for col=1:1440;qhrows501to600(day,row,col)=qh(i-8+(b(row,col)),row+500,col);
                                qlrows501to600(day,row,col)=ql(i-8+(b(row,col)),row+500,col);end;end
                        for row=1:100;for col=1:1440;qhrows601to700(day,row,col)=qh(i-8+(b(row,col)),row+600,col);
                                qlrows601to700(day,row,col)=ql(i-8+(b(row,col)),row+600,col);end;end
                        for row=1:21;for col=1:1440;qhrows701to721(day,row,col)=qh(i-8+(b(row,col)),row+700,col);
                                qlrows701to721(day,row,col)=ql(i-8+(b(row,col)),row+700,col);end;end
                    end
                else %MSE calculated from daily-mean Td and daily-max T (to compare against results from daily model data)
                    day=loopstartdays(loop)+i/8-1;
                    a=max(qh(i-7:i,:,:));a=squeeze(a);
                    c=mean(ql(i-7:i,:,:));c=squeeze(c);

                    dailymaxmserows1to100(day,:,:)=a(1:100,:)+c(1:100,:);dailymaxmserows101to200(day,:,:)=a(101:200,:)+c(101:200,:);
                    dailymaxmserows201to300(day,:,:)=a(201:300,:)+c(201:300,:);dailymaxmserows301to400(day,:,:)=a(301:400,:)+c(301:400,:);
                    dailymaxmserows401to500(day,:,:)=a(401:500,:)+c(401:500,:);dailymaxmserows501to600(day,:,:)=a(501:600,:)+c(501:600,:);
                    dailymaxmserows601to700(day,:,:)=a(601:700,:)+c(601:700,:);dailymaxmserows701to721(day,:,:)=a(701:721,:)+c(701:721,:);

                    qhrows1to100(day,:,:)=a(1:100,:);qhrows101to200(day,:,:)=a(101:200,:);qhrows201to300(day,:,:)=a(201:300,:);
                    qhrows301to400(day,:,:)=a(301:400,:);qhrows401to500(day,:,:)=a(401:500,:);qhrows501to600(day,:,:)=a(501:600,:);
                    qhrows601to700(day,:,:)=a(601:700,:);qhrows701to721(day,:,:)=a(701:721,:);

                    qlrows1to100(day,:,:)=c(1:100,:);qlrows101to200(day,:,:)=c(101:200,:);qlrows201to300(day,:,:)=c(201:300,:);
                    qlrows301to400(day,:,:)=c(301:400,:);qlrows401to500(day,:,:)=c(401:500,:);qlrows501to600(day,:,:)=c(501:600,:);
                    qlrows601to700(day,:,:)=c(601:700,:);qlrows701to721(day,:,:)=c(701:721,:);
                end
            end
            clear ttemp;clear tdtemp;
            fprintf('Finished loop %d\n',loop);
        end
        %Save this year's arrays of daily-max MSE and its components Qh and Ql
        if actualmax==1
            save(strcat(processedera5dir,'msedailymaxarray',num2str(year)),'dailymaxmserows1to100','dailymaxmserows101to200',...
                'dailymaxmserows201to300','dailymaxmserows301to400','dailymaxmserows401to500','dailymaxmserows501to600',...
                'dailymaxmserows601to700','dailymaxmserows701to721');disp('Saved file 1');

            save(strcat(processedera5dir,'qharray',num2str(year)),'qhrows1to100','qhrows101to200',...
                'qhrows201to300','qhrows301to400','qhrows401to500','qhrows501to600',...
                'qhrows601to700','qhrows701to721');disp('Saved file 2');

            save(strcat(processedera5dir,'qlarray',num2str(year)),'qlrows1to100','qlrows101to200',...
                'qlrows201to300','qlrows301to400','qlrows401to500','qlrows501to600',...
                'qlrows601to700','qlrows701to721');disp('Saved file 3');
        elseif actualmax==0
            save(strcat(processedera5dir,'msedailymaxarray',num2str(year),'MODELCOMP'),...
                'dailymaxmserows1to100','dailymaxmserows101to200',...
                'dailymaxmserows201to300','dailymaxmserows301to400','dailymaxmserows401to500','dailymaxmserows501to600',...
                'dailymaxmserows601to700','dailymaxmserows701to721');

            save(strcat(processedera5dir,'qharray',num2str(year),'MODELCOMP'),'qhrows1to100','qhrows101to200',...
                'qhrows201to300','qhrows301to400','qhrows401to500','qhrows501to600',...
                'qhrows601to700','qhrows701to721');

            save(strcat(processedera5dir,'qlarray',num2str(year),'MODELCOMP'),'qlrows1to100','qlrows101to200',...
                'qlrows201to300','qlrows301to400','qlrows401to500','qlrows501to600',...
                'qlrows601to700','qlrows701to721');
        end
        clear file;clear psfcfile;fprintf('Finished year %d\n',year);disp(clock);
    end
    clear dailymaxmserows1to100;clear dailymaxmserows101to200;clear dailymaxmserows201to300;clear dailymaxmserows301to400;
    clear dailymaxmserows401to500;clear dailymaxmserows501to600;clear dailymaxmserows601to700;clear dailymaxmserows701to721;
    clear qhrows1to100;clear qhrows101to200;clear qhrows201to300;clear qhrows301to400;
    clear qhrows401to500;clear qhrows501to600;clear qhrows601to700;clear qhrows701to721;
    clear qlrows1to100;clear qlrows101to200;clear qlrows201to300;clear qlrows301to400;
    clear qlrows401to500;clear qlrows501to600;clear qlrows601to700;clear qlrows701to721;
    clear qh;clear ql;clear mse;
    clear qh_all;clear ql_all;
    disp(clock);
end



%Determine 90 warmest days at each gridpt, to use as climatological
    %summer for further calculations (8 min per year)
if determine90warmestdays==1
    topdays=NaN.*ones(90,721,1440);disp('line 186');disp(clock);
    for rowset=1:8
        if rowset~=8;bigmsearray=NaN.*ones(numyearscalc,365,100,1440);else;bigmsearray=NaN.*ones(numyearscalc,365,21,1440);end
        for year=currentfirstyearcalc:currentlastyearcalc
            datafile=load(strcat(processedera5dir,'msedailymaxarray',num2str(year)));

            if rowset==1
                bigmsearray(year-(currentfirstyearcalc-1),:,:,:)=datafile.dailymaxmserows1to100;
            elseif rowset==2
                bigmsearray(year-(currentfirstyearcalc-1),:,:,:)=datafile.dailymaxmserows101to200;
            elseif rowset==3
                bigmsearray(year-(currentfirstyearcalc-1),:,:,:)=datafile.dailymaxmserows201to300;
            elseif rowset==4
                bigmsearray(year-(currentfirstyearcalc-1),:,:,:)=datafile.dailymaxmserows301to400;
            elseif rowset==5
                bigmsearray(year-(currentfirstyearcalc-1),:,:,:)=datafile.dailymaxmserows401to500;
            elseif rowset==6
                bigmsearray(year-(currentfirstyearcalc-1),:,:,:)=datafile.dailymaxmserows501to600;
            elseif rowset==7
                bigmsearray(year-(currentfirstyearcalc-1),:,:,:)=datafile.dailymaxmserows601to700;
            else
                bigmsearray(year-(currentfirstyearcalc-1),:,:,:)=datafile.dailymaxmserows701to721;
            end
        end

        %Actual calculation
        meanmsebyday=squeeze(mean(bigmsearray,1,'omitnan'));
        [msedaysranked,indices]=sort(meanmsebyday,1,'MissingPlacement','first');
        indices=flip(indices,1);
        if rowset<=7
            topdays(:,rowset*100-99:rowset*100,:)=indices(1:90,:,:);
        else
            topdays(:,701:721,:)=indices(1:90,:,:);
        end
    end
    save(strcat(processedera5dir,'climtopmsedays'),'topdays','-append');
end

if determine3warmestmonths==1
    for i=1:721
       for j=1:1440
           sumbymonth(1)=sum(topdays(:,i,j)<=31);sumbymonth(2)=sum(topdays(:,i,j)>=32 & topdays(:,i,j)<=59);
           sumbymonth(3)=sum(topdays(:,i,j)>=60 & topdays(:,i,j)<=90);sumbymonth(4)=sum(topdays(:,i,j)>=91 & topdays(:,i,j)<=120);
           sumbymonth(5)=sum(topdays(:,i,j)>=121 & topdays(:,i,j)<=151);sumbymonth(6)=sum(topdays(:,i,j)>=152 & topdays(:,i,j)<=181);
           sumbymonth(7)=sum(topdays(:,i,j)>=182 & topdays(:,i,j)<=212);sumbymonth(8)=sum(topdays(:,i,j)>=213 & topdays(:,i,j)<=243);
           sumbymonth(9)=sum(topdays(:,i,j)>=244 & topdays(:,i,j)<=273);sumbymonth(10)=sum(topdays(:,i,j)>=274 & topdays(:,i,j)<=304);
           sumbymonth(11)=sum(topdays(:,i,j)>=305 & topdays(:,i,j)<=334);sumbymonth(12)=sum(topdays(:,i,j)>=335 & topdays(:,i,j)<=365);
           [~,topmonth]=max(sumbymonth);
           sumbymonth(topmonth)=0;[~,secondtopmonth]=max(sumbymonth);
           sumbymonth(secondtopmonth)=0;[~,thirdtopmonth]=max(sumbymonth);
           
           topmonths(i,j)=topmonth;
           secondtopmonths(i,j)=secondtopmonth;
           thirdtopmonths(i,j)=thirdtopmonth;
       end
    end
    save(strcat(processedera5dir,'climtopmsedays'),'topmonths','secondtopmonths','thirdtopmonths','-append');
end


if corestats==1
    if domsepart==1
        maxmsebypoint=NaN.*ones(721,1440);p999msebypoint=NaN.*ones(721,1440);p99msebypoint=NaN.*ones(721,1440);
        p95msebypoint=NaN.*ones(721,1440);p90msebypoint=NaN.*ones(721,1440);p50msebypoint=NaN.*ones(721,1440);
        for setofrows=4:4:size(numrows,1)
            tic;
            %loop 1
            if setofrows<=7
                dailymaxmsetheserows_allyears=NaN.*ones(numyearscalc,365,400,360);
                r1=1;r2=100;r3=101;r4=200;r5=201;r6=300;r7=301;r8=400;
            else
                dailymaxmsetheserows_allyears=NaN.*ones(numyearscalc,365,321,360);
                r1=1;r2=100;r3=101;r4=200;r5=201;r6=300;r7=301;r8=321;
            end

            for year=currentfirstyearcalc:currentlastyearcalc
                file=load(strcat(processedera5dir,'msedailymaxarray',num2str(year)));
                temp=eval(['file.dailymaxmse' rowstems{setofrows-3} ';']);
                dailymaxmsetheserows_allyears(year-(currentfirstyearcalc-1),:,r1:r2,:)=temp(:,:,1:360);
                temp=eval(['file.dailymaxmse' rowstems{setofrows-2} ';']);
                dailymaxmsetheserows_allyears(year-(currentfirstyearcalc-1),:,r3:r4,:)=temp(:,:,1:360);
                temp=eval(['file.dailymaxmse' rowstems{setofrows-1} ';']);
                dailymaxmsetheserows_allyears(year-(currentfirstyearcalc-1),:,r5:r6,:)=temp(:,:,1:360);
                temp=eval(['file.dailymaxmse' rowstems{setofrows} ';']);clear file;
                dailymaxmsetheserows_allyears(year-(currentfirstyearcalc-1),:,r7:r8,:)=temp(:,:,1:360);
                clear temp;
            end
            %Max, median, and 99th percentile of MSE over the climatological warmest 90 days
            for row=1:r8
                actualrow=row+(setofrows-4)*100;  
                thesetopdays=squeeze(topdays(:,actualrow,1:360));
                mse_climwarmdaysonly=squeeze(dailymaxmsetheserows_allyears(:,thesetopdays,row,:)); 
                    %result is same as reading indices contained in ROWS of thesetopdays, then in COLS 
                for col=1:360
                    allvalsthiscol=mse_climwarmdaysonly(:,col*90-89:col*90,col);
                    maxmsebypoint(actualrow,col)=nanmax(reshape(allvalsthiscol,[numyearscalc*90 1]));
                    p999msebypoint(actualrow,col)=quantile(reshape(allvalsthiscol,[numyearscalc*90 1]),0.999);
                    p99msebypoint(actualrow,col)=quantile(reshape(allvalsthiscol,[numyearscalc*90 1]),0.99);
                    p50msebypoint(actualrow,col)=quantile(reshape(allvalsthiscol,[numyearscalc*90 1]),0.50);
                end
                %For verification:
                %plot(squeeze(mse_climwarmdaysonly_new(1,1:90,23)));
                    %should be identical to 
                %plot(squeeze(dailymaxmsetheserows_allyears(1,thesetopdays(1:90,1),row,23)))
            end
            clear mse_climwarmdaysonly;clear dailymaxmsetheserows_allyears;
            disp('finished loop 1');toc;

            %loop 2
            if setofrows<=7
                dailymaxmsetheserows_allyears=NaN.*ones(numyearscalc,365,400,360);
                r1=1;r2=100;r3=101;r4=200;r5=201;r6=300;r7=301;r8=400;
            else
                dailymaxmsetheserows_allyears=NaN.*ones(numyearscalc,365,321,360);
                r1=1;r2=100;r3=101;r4=200;r5=201;r6=300;r7=301;r8=321;
            end

            for year=currentfirstyearcalc:currentlastyearcalc
                file=load(strcat(processedera5dir,'msedailymaxarray',num2str(year)));
                temp=eval(['file.dailymaxmse' rowstems{setofrows-3} ';']);
                dailymaxmsetheserows_allyears(year-(currentfirstyearcalc-1),:,r1:r2,:)=temp(:,:,361:720);
                temp=eval(['file.dailymaxmse' rowstems{setofrows-2} ';']);
                dailymaxmsetheserows_allyears(year-(currentfirstyearcalc-1),:,r3:r4,:)=temp(:,:,361:720);
                temp=eval(['file.dailymaxmse' rowstems{setofrows-1} ';']);
                dailymaxmsetheserows_allyears(year-(currentfirstyearcalc-1),:,r5:r6,:)=temp(:,:,361:720);
                temp=eval(['file.dailymaxmse' rowstems{setofrows} ';']);clear file;
                dailymaxmsetheserows_allyears(year-(currentfirstyearcalc-1),:,r7:r8,:)=temp(:,:,361:720);
                clear temp;
            end
            %Max, median, and 99th percentile of MSE over the climatological warmest 90 days
            for row=1:r8
                actualrow=row+(setofrows-4)*100;
                thesetopdays=squeeze(topdays(:,actualrow,361:720));
                mse_climwarmdaysonly=squeeze(dailymaxmsetheserows_allyears(:,thesetopdays,row,:)); 
                for col=361:720
                    col_alt=col-360;
                    allvalsthiscol=mse_climwarmdaysonly(:,col_alt*90-89:col_alt*90,col_alt);
                    maxmsebypoint(actualrow,col)=nanmax(reshape(allvalsthiscol,[numyearscalc*90 1]));
                    p999msebypoint(actualrow,col)=quantile(reshape(allvalsthiscol,[numyearscalc*90 1]),0.999);
                    p99msebypoint(actualrow,col)=quantile(reshape(allvalsthiscol,[numyearscalc*90 1]),0.99);
                    p50msebypoint(actualrow,col)=quantile(reshape(allvalsthiscol,[numyearscalc*90 1]),0.50);
                end
            end
            clear mse_climwarmdaysonly;clear dailymaxmsetheserows_allyears;
            disp('finished loop 2');

            %loop 3
            if setofrows<=7
                dailymaxmsetheserows_allyears=NaN.*ones(numyearscalc,365,400,360);
                r1=1;r2=100;r3=101;r4=200;r5=201;r6=300;r7=301;r8=400;
            else
                dailymaxmsetheserows_allyears=NaN.*ones(numyearscalc,365,321,360);
                r1=1;r2=100;r3=101;r4=200;r5=201;r6=300;r7=301;r8=321;
            end

            for year=currentfirstyearcalc:currentlastyearcalc
                file=load(strcat(processedera5dir,'msedailymaxarray',num2str(year)));
                temp=eval(['file.dailymaxmse' rowstems{setofrows-3} ';']);
                dailymaxmsetheserows_allyears(year-(currentfirstyearcalc-1),:,r1:r2,:)=temp(:,:,721:1080);
                temp=eval(['file.dailymaxmse' rowstems{setofrows-2} ';']);
                dailymaxmsetheserows_allyears(year-(currentfirstyearcalc-1),:,r3:r4,:)=temp(:,:,721:1080);
                temp=eval(['file.dailymaxmse' rowstems{setofrows-1} ';']);
                dailymaxmsetheserows_allyears(year-(currentfirstyearcalc-1),:,r5:r6,:)=temp(:,:,721:1080);
                temp=eval(['file.dailymaxmse' rowstems{setofrows} ';']);clear file;
                dailymaxmsetheserows_allyears(year-(currentfirstyearcalc-1),:,r7:r8,:)=temp(:,:,721:1080);
                clear temp;
            end
            %Max, median, and 99th percentile of MSE over the climatological warmest 90 days
            for row=1:r8
                actualrow=row+(setofrows-4)*100;
                thesetopdays=squeeze(topdays(:,actualrow,721:1080));
                mse_climwarmdaysonly=squeeze(dailymaxmsetheserows_allyears(:,thesetopdays,row,:)); 
                for col=721:1080
                    col_alt=col-720;
                    allvalsthiscol=mse_climwarmdaysonly(:,col_alt*90-89:col_alt*90,col_alt);
                    maxmsebypoint(actualrow,col)=nanmax(reshape(allvalsthiscol,[numyearscalc*90 1]));
                    p999msebypoint(actualrow,col)=quantile(reshape(allvalsthiscol,[numyearscalc*90 1]),0.999);
                    p99msebypoint(actualrow,col)=quantile(reshape(allvalsthiscol,[numyearscalc*90 1]),0.99);
                    p50msebypoint(actualrow,col)=quantile(reshape(allvalsthiscol,[numyearscalc*90 1]),0.50);
                end
            end
            clear mse_climwarmdaysonly;clear dailymaxmsetheserows_allyears;
            disp('finished loop 3');

            %loop 4
            if setofrows<=7
                dailymaxmsetheserows_allyears=NaN.*ones(numyearscalc,365,400,360);
                r1=1;r2=100;r3=101;r4=200;r5=201;r6=300;r7=301;r8=400;
            else
                dailymaxmsetheserows_allyears=NaN.*ones(numyearscalc,365,321,360);
                r1=1;r2=100;r3=101;r4=200;r5=201;r6=300;r7=301;r8=321;
            end

            for year=currentfirstyearcalc:currentlastyearcalc
                file=load(strcat(processedera5dir,'msedailymaxarray',num2str(year)));
                temp=eval(['file.dailymaxmse' rowstems{setofrows-3} ';']);
                dailymaxmsetheserows_allyears(year-(currentfirstyearcalc-1),:,r1:r2,:)=temp(:,:,1081:1440);
                temp=eval(['file.dailymaxmse' rowstems{setofrows-2} ';']);
                dailymaxmsetheserows_allyears(year-(currentfirstyearcalc-1),:,r3:r4,:)=temp(:,:,1081:1440);
                temp=eval(['file.dailymaxmse' rowstems{setofrows-1} ';']);
                dailymaxmsetheserows_allyears(year-(currentfirstyearcalc-1),:,r5:r6,:)=temp(:,:,1081:1440);
                temp=eval(['file.dailymaxmse' rowstems{setofrows} ';']);clear file;
                dailymaxmsetheserows_allyears(year-(currentfirstyearcalc-1),:,r7:r8,:)=temp(:,:,1081:1440);
                clear temp;
            end
            %Max, median, and 99th percentile of MSE over the climatological warmest 90 days
            for row=1:r8
                actualrow=row+(setofrows-4)*100;
                thesetopdays=squeeze(topdays(:,actualrow,1081:1440));
                mse_climwarmdaysonly=squeeze(dailymaxmsetheserows_allyears(:,thesetopdays,row,:)); 
                for col=1081:1440
                    col_alt=col-1080;
                    allvalsthiscol=mse_climwarmdaysonly(:,col_alt*90-89:col_alt*90,col_alt);
                    maxmsebypoint(actualrow,col)=nanmax(reshape(allvalsthiscol,[numyearscalc*90 1]));
                    p999msebypoint(actualrow,col)=quantile(reshape(allvalsthiscol,[numyearscalc*90 1]),0.999);
                    p99msebypoint(actualrow,col)=quantile(reshape(allvalsthiscol,[numyearscalc*90 1]),0.99);
                    p50msebypoint(actualrow,col)=quantile(reshape(allvalsthiscol,[numyearscalc*90 1]),0.50);
                end
            end
            clear mse_climwarmdaysonly;clear dailymaxmsetheserows_allyears;
            disp('finished loop 4');
            fprintf('Row set is %d for MSE\n',setofrows);disp(clock);
            save(strcat(processedera5dir,'mseqhqlstatsMAY2021'),'maxmsebypoint','p999msebypoint','p99msebypoint','p50msebypoint','-append');
        end
        clear temp;
        disp(clock);
    end


    if doqhpart==1
        rowstems={'rows1to100';'rows101to200';'rows201to300';'rows301to400';'rows401to500';'rows501to600';'rows601to700';'rows701to721'};
        numrows=[100;100;100;100;100;100;100;21];
        maxqhbypoint=NaN.*ones(721,1440);p999qhbypoint=NaN.*ones(721,1440);p99qhbypoint=NaN.*ones(721,1440);p50qhbypoint=NaN.*ones(721,1440);
        for setofrows=4:4:size(numrows,1)
            tic;
            %loop 1
            if setofrows<=7
                qhtheserows_allyears=NaN.*ones(numyearscalc,365,400,360);
                r1=1;r2=100;r3=101;r4=200;r5=201;r6=300;r7=301;r8=400;
            else
                qhtheserows_allyears=NaN.*ones(numyearscalc,365,321,360);
                r1=1;r2=100;r3=101;r4=200;r5=201;r6=300;r7=301;r8=321;
            end

            for year=currentfirstyearcalc:currentlastyearcalc
                file=load(strcat(processedera5dir,'qharray',num2str(year)));
                temp=eval(['file.qh' rowstems{setofrows-3} ';']);
                qhtheserows_allyears(year-(currentfirstyearcalc-1),:,r1:r2,:)=temp(:,:,1:360);
                temp=eval(['file.qh' rowstems{setofrows-2} ';']);
                qhtheserows_allyears(year-(currentfirstyearcalc-1),:,r3:r4,:)=temp(:,:,1:360);
                temp=eval(['file.qh' rowstems{setofrows-1} ';']);
                qhtheserows_allyears(year-(currentfirstyearcalc-1),:,r5:r6,:)=temp(:,:,1:360);
                temp=eval(['file.qh' rowstems{setofrows} ';']);clear file;
                qhtheserows_allyears(year-(currentfirstyearcalc-1),:,r7:r8,:)=temp(:,:,1:360);
                clear temp;
            end
            %Max, median, and 99th percentile of qh over the climatological warmest 90 days
            for row=1:r8
                actualrow=row+(setofrows-4)*100;  
                thesetopdays=squeeze(topdays(:,actualrow,1:360));
                qh_climwarmdaysonly=squeeze(qhtheserows_allyears(:,thesetopdays,row,:)); 
                    %result is same as reading indices contained in ROWS of thesetopdays, then in COLS 
                for col=1:360
                    allvalsthiscol=qh_climwarmdaysonly(:,col*90-89:col*90,col);
                    maxqhbypoint(actualrow,col)=nanmax(reshape(allvalsthiscol,[numyearscalc*90 1]));
                    p999qhbypoint(actualrow,col)=quantile(reshape(allvalsthiscol,[numyearscalc*90 1]),0.999);
                    p99qhbypoint(actualrow,col)=quantile(reshape(allvalsthiscol,[numyearscalc*90 1]),0.99);
                    p50qhbypoint(actualrow,col)=quantile(reshape(allvalsthiscol,[numyearscalc*90 1]),0.50);
                end
                %For verification:
                %plot(squeeze(qh_climwarmdaysonly_new(1,1:90,23)));
                    %should be identical to 
                %plot(squeeze(qhtheserows_allyears(1,thesetopdays(1:90,1),row,23)))
            end
            clear qh_climwarmdaysonly;clear qhtheserows_allyears;
            disp('finished loop 1');toc;

            %loop 2
            if setofrows<=7
                qhtheserows_allyears=NaN.*ones(numyearscalc,365,400,360);
                r1=1;r2=100;r3=101;r4=200;r5=201;r6=300;r7=301;r8=400;
            else
                qhtheserows_allyears=NaN.*ones(numyearscalc,365,321,360);
                r1=1;r2=100;r3=101;r4=200;r5=201;r6=300;r7=301;r8=321;
            end

            for year=currentfirstyearcalc:currentlastyearcalc
                file=load(strcat(processedera5dir,'qharray',num2str(year)));
                temp=eval(['file.qh' rowstems{setofrows-3} ';']);
                qhtheserows_allyears(year-(currentfirstyearcalc-1),:,r1:r2,:)=temp(:,:,361:720);
                temp=eval(['file.qh' rowstems{setofrows-2} ';']);
                qhtheserows_allyears(year-(currentfirstyearcalc-1),:,r3:r4,:)=temp(:,:,361:720);
                temp=eval(['file.qh' rowstems{setofrows-1} ';']);
                qhtheserows_allyears(year-(currentfirstyearcalc-1),:,r5:r6,:)=temp(:,:,361:720);
                temp=eval(['file.qh' rowstems{setofrows} ';']);clear file;
                qhtheserows_allyears(year-(currentfirstyearcalc-1),:,r7:r8,:)=temp(:,:,361:720);
                clear temp;
            end
            %Max, median, and 99th percentile of qh over the climatological warmest 90 days
            for row=1:r8
                actualrow=row+(setofrows-4)*100;
                thesetopdays=squeeze(topdays(:,actualrow,361:720));
                qh_climwarmdaysonly=squeeze(qhtheserows_allyears(:,thesetopdays,row,:)); 
                for col=361:720
                    col_alt=col-360;
                    allvalsthiscol=qh_climwarmdaysonly(:,col_alt*90-89:col_alt*90,col_alt);
                    maxqhbypoint(actualrow,col)=nanmax(reshape(allvalsthiscol,[numyearscalc*90 1]));
                    p999qhbypoint(actualrow,col)=quantile(reshape(allvalsthiscol,[numyearscalc*90 1]),0.999);
                    p99qhbypoint(actualrow,col)=quantile(reshape(allvalsthiscol,[numyearscalc*90 1]),0.99);
                    p50qhbypoint(actualrow,col)=quantile(reshape(allvalsthiscol,[numyearscalc*90 1]),0.50);
                end
            end
            clear qh_climwarmdaysonly;clear qhtheserows_allyears;
            disp('finished loop 2');

            %loop 3
            if setofrows<=7
                qhtheserows_allyears=NaN.*ones(numyearscalc,365,400,360);
                r1=1;r2=100;r3=101;r4=200;r5=201;r6=300;r7=301;r8=400;
            else
                qhtheserows_allyears=NaN.*ones(numyearscalc,365,321,360);
                r1=1;r2=100;r3=101;r4=200;r5=201;r6=300;r7=301;r8=321;
            end

            for year=currentfirstyearcalc:currentlastyearcalc
                file=load(strcat(processedera5dir,'qharray',num2str(year)));
                temp=eval(['file.qh' rowstems{setofrows-3} ';']);
                qhtheserows_allyears(year-(currentfirstyearcalc-1),:,r1:r2,:)=temp(:,:,721:1080);
                temp=eval(['file.qh' rowstems{setofrows-2} ';']);
                qhtheserows_allyears(year-(currentfirstyearcalc-1),:,r3:r4,:)=temp(:,:,721:1080);
                temp=eval(['file.qh' rowstems{setofrows-1} ';']);
                qhtheserows_allyears(year-(currentfirstyearcalc-1),:,r5:r6,:)=temp(:,:,721:1080);
                temp=eval(['file.qh' rowstems{setofrows} ';']);clear file;
                qhtheserows_allyears(year-(currentfirstyearcalc-1),:,r7:r8,:)=temp(:,:,721:1080);
                clear temp;
            end
            %Max, median, and 99th percentile of qh over the climatological warmest 90 days
            for row=1:r8
                actualrow=row+(setofrows-4)*100;
                thesetopdays=squeeze(topdays(:,actualrow,721:1080));
                qh_climwarmdaysonly=squeeze(qhtheserows_allyears(:,thesetopdays,row,:)); 
                for col=721:1080
                    col_alt=col-720;
                    allvalsthiscol=qh_climwarmdaysonly(:,col_alt*90-89:col_alt*90,col_alt);
                    maxqhbypoint(actualrow,col)=nanmax(reshape(allvalsthiscol,[numyearscalc*90 1]));
                    p999qhbypoint(actualrow,col)=quantile(reshape(allvalsthiscol,[numyearscalc*90 1]),0.999);
                    p99qhbypoint(actualrow,col)=quantile(reshape(allvalsthiscol,[numyearscalc*90 1]),0.99);
                    p50qhbypoint(actualrow,col)=quantile(reshape(allvalsthiscol,[numyearscalc*90 1]),0.50);
                end
            end
            clear qh_climwarmdaysonly;clear qhtheserows_allyears;
            disp('finished loop 3');

            %loop 4
            if setofrows<=7
                qhtheserows_allyears=NaN.*ones(numyearscalc,365,400,360);
                r1=1;r2=100;r3=101;r4=200;r5=201;r6=300;r7=301;r8=400;
            else
                qhtheserows_allyears=NaN.*ones(numyearscalc,365,321,360);
                r1=1;r2=100;r3=101;r4=200;r5=201;r6=300;r7=301;r8=321;
            end

            for year=currentfirstyearcalc:currentlastyearcalc
                file=load(strcat(processedera5dir,'qharray',num2str(year)));
                temp=eval(['file.qh' rowstems{setofrows-3} ';']);
                qhtheserows_allyears(year-(currentfirstyearcalc-1),:,r1:r2,:)=temp(:,:,1081:1440);
                temp=eval(['file.qh' rowstems{setofrows-2} ';']);
                qhtheserows_allyears(year-(currentfirstyearcalc-1),:,r3:r4,:)=temp(:,:,1081:1440);
                temp=eval(['file.qh' rowstems{setofrows-1} ';']);
                qhtheserows_allyears(year-(currentfirstyearcalc-1),:,r5:r6,:)=temp(:,:,1081:1440);
                temp=eval(['file.qh' rowstems{setofrows} ';']);clear file;
                qhtheserows_allyears(year-(currentfirstyearcalc-1),:,r7:r8,:)=temp(:,:,1081:1440);
                clear temp;
            end
            %Max, median, and 99th percentile of qh over the climatological warmest 90 days
            for row=1:r8
                actualrow=row+(setofrows-4)*100;
                thesetopdays=squeeze(topdays(:,actualrow,1081:1440));
                qh_climwarmdaysonly=squeeze(qhtheserows_allyears(:,thesetopdays,row,:)); 
                for col=1081:1440
                    col_alt=col-1080;
                    allvalsthiscol=qh_climwarmdaysonly(:,col_alt*90-89:col_alt*90,col_alt);
                    maxqhbypoint(actualrow,col)=nanmax(reshape(allvalsthiscol,[numyearscalc*90 1]));
                    p999qhbypoint(actualrow,col)=quantile(reshape(allvalsthiscol,[numyearscalc*90 1]),0.999);
                    p99qhbypoint(actualrow,col)=quantile(reshape(allvalsthiscol,[numyearscalc*90 1]),0.99);
                    p50qhbypoint(actualrow,col)=quantile(reshape(allvalsthiscol,[numyearscalc*90 1]),0.50);
                end
            end
            clear qh_climwarmdaysonly;clear qhtheserows_allyears;
            disp('finished loop 4');
            fprintf('Row set is %d for qh\n',setofrows);disp(clock);
            save(strcat(processedera5dir,'mseqhqlstatsMAY2021'),'maxqhbypoint','p999qhbypoint','p99qhbypoint','p50qhbypoint','-append');
        end
        clear temp;
        disp(clock);
    end



    if doqlpart==1
        rowstems={'rows1to100';'rows101to200';'rows201to300';'rows301to400';'rows401to500';'rows501to600';'rows601to700';'rows701to721'};
        numrows=[100;100;100;100;100;100;100;21];
        maxqlbypoint=NaN.*ones(721,1440);p999qlbypoint=NaN.*ones(721,1440);p99qlbypoint=NaN.*ones(721,1440);p50qlbypoint=NaN.*ones(721,1440);
        for setofrows=4:4:size(numrows,1)
            tic;
            %loop 1
            if setofrows<=7
                qltheserows_allyears=NaN.*ones(numyearscalc,365,400,360);
                r1=1;r2=100;r3=101;r4=200;r5=201;r6=300;r7=301;r8=400;
            else
                qltheserows_allyears=NaN.*ones(numyearscalc,365,321,360);
                r1=1;r2=100;r3=101;r4=200;r5=201;r6=300;r7=301;r8=321;
            end

            for year=currentfirstyearcalc:currentlastyearcalc
                file=load(strcat(processedera5dir,'qlarray',num2str(year)));
                temp=eval(['file.ql' rowstems{setofrows-3} ';']);
                qltheserows_allyears(year-(currentfirstyearcalc-1),:,r1:r2,:)=temp(:,:,1:360);
                temp=eval(['file.ql' rowstems{setofrows-2} ';']);
                qltheserows_allyears(year-(currentfirstyearcalc-1),:,r3:r4,:)=temp(:,:,1:360);
                temp=eval(['file.ql' rowstems{setofrows-1} ';']);
                qltheserows_allyears(year-(currentfirstyearcalc-1),:,r5:r6,:)=temp(:,:,1:360);
                temp=eval(['file.ql' rowstems{setofrows} ';']);clear file;
                qltheserows_allyears(year-(currentfirstyearcalc-1),:,r7:r8,:)=temp(:,:,1:360);
                clear temp;
            end
            %Max, median, and 99th percentile of ql over the climatological warmest 90 days
            for row=1:r8
                actualrow=row+(setofrows-4)*100;  
                thesetopdays=squeeze(topdays(:,actualrow,1:360));
                ql_climwarmdaysonly=squeeze(qltheserows_allyears(:,thesetopdays,row,:)); 
                    %result is same as reading indices contained in ROWS of thesetopdays, then in COLS 
                for col=1:360
                    allvalsthiscol=ql_climwarmdaysonly(:,col*90-89:col*90,col);
                    maxqlbypoint(actualrow,col)=nanmax(reshape(allvalsthiscol,[numyearscalc*90 1]));
                    p999qlbypoint(actualrow,col)=quantile(reshape(allvalsthiscol,[numyearscalc*90 1]),0.999);
                    p99qlbypoint(actualrow,col)=quantile(reshape(allvalsthiscol,[numyearscalc*90 1]),0.99);
                    p50qlbypoint(actualrow,col)=quantile(reshape(allvalsthiscol,[numyearscalc*90 1]),0.50);
                end
                %For verification:
                %plot(squeeze(ql_climwarmdaysonly_new(1,1:90,23)));
                    %should be identical to 
                %plot(squeeze(qltheserows_allyears(1,thesetopdays(1:90,1),row,23)))
            end
            clear ql_climwarmdaysonly;clear qltheserows_allyears;
            disp('finished loop 1');toc;

            %loop 2
            if setofrows<=7
                qltheserows_allyears=NaN.*ones(numyearscalc,365,400,360);
                r1=1;r2=100;r3=101;r4=200;r5=201;r6=300;r7=301;r8=400;
            else
                qltheserows_allyears=NaN.*ones(numyearscalc,365,321,360);
                r1=1;r2=100;r3=101;r4=200;r5=201;r6=300;r7=301;r8=321;
            end

            for year=currentfirstyearcalc:currentlastyearcalc
                file=load(strcat(processedera5dir,'qlarray',num2str(year)));
                temp=eval(['file.ql' rowstems{setofrows-3} ';']);
                qltheserows_allyears(year-(currentfirstyearcalc-1),:,r1:r2,:)=temp(:,:,361:720);
                temp=eval(['file.ql' rowstems{setofrows-2} ';']);
                qltheserows_allyears(year-(currentfirstyearcalc-1),:,r3:r4,:)=temp(:,:,361:720);
                temp=eval(['file.ql' rowstems{setofrows-1} ';']);
                qltheserows_allyears(year-(currentfirstyearcalc-1),:,r5:r6,:)=temp(:,:,361:720);
                temp=eval(['file.ql' rowstems{setofrows} ';']);clear file;
                qltheserows_allyears(year-(currentfirstyearcalc-1),:,r7:r8,:)=temp(:,:,361:720);
                clear temp;
            end
            %Max, median, and 99th percentile of ql over the climatological warmest 90 days
            for row=1:r8
                actualrow=row+(setofrows-4)*100;
                thesetopdays=squeeze(topdays(:,actualrow,361:720));
                ql_climwarmdaysonly=squeeze(qltheserows_allyears(:,thesetopdays,row,:)); 
                for col=361:720
                    col_alt=col-360;
                    allvalsthiscol=ql_climwarmdaysonly(:,col_alt*90-89:col_alt*90,col_alt);
                    maxqlbypoint(actualrow,col)=nanmax(reshape(allvalsthiscol,[numyearscalc*90 1]));
                    p999qlbypoint(actualrow,col)=quantile(reshape(allvalsthiscol,[numyearscalc*90 1]),0.999);
                    p99qlbypoint(actualrow,col)=quantile(reshape(allvalsthiscol,[numyearscalc*90 1]),0.99);
                    p50qlbypoint(actualrow,col)=quantile(reshape(allvalsthiscol,[numyearscalc*90 1]),0.50);
                end
            end
            clear ql_climwarmdaysonly;clear qltheserows_allyears;
            disp('finished loop 2');

            %loop 3
            if setofrows<=7
                qltheserows_allyears=NaN.*ones(numyearscalc,365,400,360);
                r1=1;r2=100;r3=101;r4=200;r5=201;r6=300;r7=301;r8=400;
            else
                qltheserows_allyears=NaN.*ones(numyearscalc,365,321,360);
                r1=1;r2=100;r3=101;r4=200;r5=201;r6=300;r7=301;r8=321;
            end

            for year=currentfirstyearcalc:currentlastyearcalc
                file=load(strcat(processedera5dir,'qlarray',num2str(year)));
                temp=eval(['file.ql' rowstems{setofrows-3} ';']);
                qltheserows_allyears(year-(currentfirstyearcalc-1),:,r1:r2,:)=temp(:,:,721:1080);
                temp=eval(['file.ql' rowstems{setofrows-2} ';']);
                qltheserows_allyears(year-(currentfirstyearcalc-1),:,r3:r4,:)=temp(:,:,721:1080);
                temp=eval(['file.ql' rowstems{setofrows-1} ';']);
                qltheserows_allyears(year-(currentfirstyearcalc-1),:,r5:r6,:)=temp(:,:,721:1080);
                temp=eval(['file.ql' rowstems{setofrows} ';']);clear file;
                qltheserows_allyears(year-(currentfirstyearcalc-1),:,r7:r8,:)=temp(:,:,721:1080);
                clear temp;
            end
            %Max, median, and 99th percentile of ql over the climatological warmest 90 days
            for row=1:r8
                actualrow=row+(setofrows-4)*100;
                thesetopdays=squeeze(topdays(:,actualrow,721:1080));
                ql_climwarmdaysonly=squeeze(qltheserows_allyears(:,thesetopdays,row,:)); 
                for col=721:1080
                    col_alt=col-720;
                    allvalsthiscol=ql_climwarmdaysonly(:,col_alt*90-89:col_alt*90,col_alt);
                    maxqlbypoint(actualrow,col)=nanmax(reshape(allvalsthiscol,[numyearscalc*90 1]));
                    p999qlbypoint(actualrow,col)=quantile(reshape(allvalsthiscol,[numyearscalc*90 1]),0.999);
                    p99qlbypoint(actualrow,col)=quantile(reshape(allvalsthiscol,[numyearscalc*90 1]),0.99);
                    p50qlbypoint(actualrow,col)=quantile(reshape(allvalsthiscol,[numyearscalc*90 1]),0.50);
                end
            end
            clear ql_climwarmdaysonly;clear qltheserows_allyears;
            disp('finished loop 3');

            %loop 4
            if setofrows<=7
                qltheserows_allyears=NaN.*ones(numyearscalc,365,400,360);
                r1=1;r2=100;r3=101;r4=200;r5=201;r6=300;r7=301;r8=400;
            else
                qltheserows_allyears=NaN.*ones(numyearscalc,365,321,360);
                r1=1;r2=100;r3=101;r4=200;r5=201;r6=300;r7=301;r8=321;
            end

            for year=currentfirstyearcalc:currentlastyearcalc
                file=load(strcat(processedera5dir,'qlarray',num2str(year)));
                temp=eval(['file.ql' rowstems{setofrows-3} ';']);
                qltheserows_allyears(year-(currentfirstyearcalc-1),:,r1:r2,:)=temp(:,:,1081:1440);
                temp=eval(['file.ql' rowstems{setofrows-2} ';']);
                qltheserows_allyears(year-(currentfirstyearcalc-1),:,r3:r4,:)=temp(:,:,1081:1440);
                temp=eval(['file.ql' rowstems{setofrows-1} ';']);
                qltheserows_allyears(year-(currentfirstyearcalc-1),:,r5:r6,:)=temp(:,:,1081:1440);
                temp=eval(['file.ql' rowstems{setofrows} ';']);clear file;
                qltheserows_allyears(year-(currentfirstyearcalc-1),:,r7:r8,:)=temp(:,:,1081:1440);
                clear temp;
            end
            %Max, median, and 99th percentile of ql over the climatological warmest 90 days
            for row=1:r8
                actualrow=row+(setofrows-4)*100;
                thesetopdays=squeeze(topdays(:,actualrow,1081:1440));
                ql_climwarmdaysonly=squeeze(qltheserows_allyears(:,thesetopdays,row,:)); 
                for col=1081:1440
                    col_alt=col-1080;
                    allvalsthiscol=ql_climwarmdaysonly(:,col_alt*90-89:col_alt*90,col_alt);
                    maxqlbypoint(actualrow,col)=nanmax(reshape(allvalsthiscol,[numyearscalc*90 1]));
                    p999qlbypoint(actualrow,col)=quantile(reshape(allvalsthiscol,[numyearscalc*90 1]),0.999);
                    p99qlbypoint(actualrow,col)=quantile(reshape(allvalsthiscol,[numyearscalc*90 1]),0.99);
                    p50qlbypoint(actualrow,col)=quantile(reshape(allvalsthiscol,[numyearscalc*90 1]),0.50);
                end
            end
            clear ql_climwarmdaysonly;clear qltheserows_allyears;
            disp('finished loop 4');
            fprintf('Row set is %d for ql\n',setofrows);disp(clock);
            save(strcat(processedera5dir,'mseqhqlstatsMAY2021'),'maxqlbypoint','p999qlbypoint','p99qlbypoint','p50qlbypoint','-append');
        end
        clear temp;
    end


    exist topdays;if ans==0;datafile=load(strcat(processedera5dir,'climtopmsedays'));topdays=datafile.topdays;end
    
    
    %Average these statistics by latitude band (2 sec)
    if domsepart==1;clear maxmse_latbandavg;clear p999mse_latbandavg;clear p99mse_latbandavg;clear p95mse_latbandavg;clear p90mse_latbandavg;clear p50mse_latbandavg;end
    if doqhpart==1;clear p99qh_latbandavg;end;if doqlpart==1;clear maxql_latbandavg;clear p99ql_latbandavg;end
    newi=1;
    for i=1:4:717
        if domsepart==1
        maxmse_latbandavg(newi)=nanmax(nanmax(maxmsebypoint(i:i+3,:),[],2));
        p999mse_latbandavg(newi)=mean(mean(p999msebypoint(i:i+3,:),2,'omitnan'),'omitnan');
        p99mse_latbandavg(newi)=mean(mean(p99msebypoint(i:i+3,:),2,'omitnan'),'omitnan');
        p50mse_latbandavg(newi)=mean(mean(p50msebypoint(i:i+3,:),2,'omitnan'),'omitnan');
        end
        
        if doqhpart==1
        maxqh_latbandavg(newi)=nanmax(nanmax(maxqhbypoint(i:i+3,:),[],2));
        p99qh_latbandavg(newi)=mean(mean(p99qhbypoint(i:i+3,:),2,'omitnan'),'omitnan');
        end
        if doqlpart==1
        maxql_latbandavg(newi)=nanmax(nanmax(maxqlbypoint(i:i+3,:),[],2));
        p99ql_latbandavg(newi)=mean(mean(p99qlbypoint(i:i+3,:),2,'omitnan'),'omitnan');
        end
        newi=newi+1;
    end
    if domsepart==1;save(strcat(processedera5dir,'mseqhqlstats'),...
            'maxmse_latbandavg','p999mse_latbandavg','p99mse_latbandavg','p50mse_latbandavg','-append');end
    if doqhpart==1;save(strcat(processedera5dir,'mseqhqlstats'),'maxqh_latbandavg','p99qh_latbandavg','-append');end
    if doqlpart==1;save(strcat(processedera5dir,'mseqhqlstats'),'maxql_latbandavg','p99ql_latbandavg','-append');end
    
    
    
    %Global max Qh of 329.5 corresponds to a temperature of ~53 C (128 F)
    %Global max Ql of 83.8 corresponds to a dewpoint of ~34.7 C (94.5 F)
    figure(802);clf;imagescnan(maxmsebypoint);colorbar;
    p99qh_latbandavg=mean(p99qhbypoint,2,'omitnan');p50qh_latbandavg=mean(p50qhbypoint,2,'omitnan');
    p99ql_latbandavg=mean(p99qlbypoint,2,'omitnan');p50ql_latbandavg=mean(p50qlbypoint,2,'omitnan');
    figure(803);clf;imagescnan(maxqhbypoint);colorbar;
    figure(804);clf;imagescnan(maxqlbypoint);colorbar;
    figure(805);clf;imagescnan(maxqhbypoint-p99qhbypoint);colorbar;
    figure(806);clf;imagescnan(maxqlbypoint-p99qlbypoint);colorbar;
    
    %quick global stats OF GRIDPT MAXES, for use later on
    temp=reshape(maxmsebypoint,[721*1440 1]);
    p50mseglobal=quantile(temp,0.5); %global median (~340.6)
    p90mseglobal=quantile(temp,0.9); %top 10% of global gridpoints (~363.1)
    p99mseglobal=quantile(temp,0.99); %top 1% of global gridpoints (~375.2)
    p995mseglobal=quantile(temp,0.995); %top 0.5% of global gridpoints (~377.8)
    p999mseglobal=quantile(temp,0.999); %top 0.1% of global gridpoints (~384.3)
    p9999mseglobal=quantile(temp,0.9999); %top 0.01% of global gridpoints (~391.2)
    
    temp=reshape(maxqhbypoint,[721*1440 1]);
    p50qhglobal=quantile(temp,0.5); %global median (~303.4)
    p90qhglobal=quantile(temp,0.9); %top 10% of global gridpoints (~314.8)
    p99qhglobal=quantile(temp,0.99); %top 1% of global gridpoints (~323.3)
    p995qhglobal=quantile(temp,0.995); %top 0.5% of global gridpoints (~324.3)
    p999qhglobal=quantile(temp,0.999); %top 0.1% of global gridpoints (~326.0)
    p9999qhglobal=quantile(temp,0.9999); %top 0.01% of global gridpoints (~328.9)
    
    temp=reshape(maxqlbypoint,[721*1440 1]);
    p50qlglobal=quantile(temp,0.5); %global median (~37.9)
    p90qlglobal=quantile(temp,0.9); %top 10% of global gridpoints (~53.2)
    p99qlglobal=quantile(temp,0.99); %top 1% of global gridpoints (~61.6)
    p995qlglobal=quantile(temp,0.995); %top 0.5% of global gridpoints (~63.3)
    p999qlglobal=quantile(temp,0.999); %top 0.1% of global gridpoints (~68.1)
    p9999qlglobal=quantile(temp,0.9999); %top 0.01% of global gridpoints (~74.2)
    
    save(strcat(processedera5dir,'mseqhqlstats'),'p50mseglobal','p90mseglobal',...
        'p99mseglobal','p995mseglobal','p999mseglobal','p9999mseglobal','p50qhglobal','p90qhglobal',...
        'p99qhglobal','p995qhglobal','p999qhglobal','p9999qhglobal','p50qlglobal','p90qlglobal',...
        'p99qlglobal','p995qlglobal','p999qlglobal','p9999qlglobal','-append');
end



if whereextremesoccur==1
    exist p50pts;
    if ans==0
        temp=load(strcat(processedera5dir,'extrememsearrays'));
        p50pts=temp.p50pts;p90pts=temp.p90pts;p99pts=temp.p99pts;p999pts=temp.p999pts;p9999pts=temp.p9999pts;
    end
    
    %Global map of where extremes occur
    p50pts=reshape(p50ptshelper,[vvnumyears 361 1440 12]);p50ptsallmonths=squeeze(nanmax(nanmax(p50pts,[],4),[],1));
    p90pts=reshape(p90ptshelper,[vvnumyears 361 1440 12]);p90ptsallmonths=squeeze(nanmax(nanmax(p90pts,[],4),[],1));
    p99pts=reshape(p99ptshelper,[vvnumyears 361 1440 12]);p99ptsallmonths=squeeze(nanmax(nanmax(p99pts,[],4),[],1));
    p999pts=reshape(p999ptshelper,[vvnumyears 361 1440 12]);p999ptsallmonths=squeeze(nanmax(nanmax(p999pts,[],4),[],1));
    p9999pts=reshape(p9999ptshelper,[vvnumyears 361 1440 12]);p9999ptsallmonths=squeeze(nanmax(nanmax(p9999pts,[],4),[],1));
    save(strcat(processedera5dir,'extrememsearrays'),'p50pts','p90pts','p99pts','p999pts','p9999pts','-append');
    %figure(971);clf;imagescnan(p90ptsallmonths);
    %figure(972);clf;imagescnan(p99ptsallmonths);
    %figure(973);clf;imagescnan(p999ptsallmonths);
    %figure(974);clf;imagescnan(p9999ptsallmonths);
    for i=1:361
        for j=1:1440
            if p9999ptsallmonths(i,j)==1
                codes(i,j)=5;
            elseif p999ptsallmonths(i,j)==1
                codes(i,j)=4;
            elseif p99ptsallmonths(i,j)==1
                codes(i,j)=3;
            elseif p90ptsallmonths(i,j)==1
                codes(i,j)=2;
            else
                codes(i,j)=1;
            end
        end
    end
    save(strcat(processedera5dir,'extrememsearrays'),'codes','-append');
end


%Calculation of global and latitude-band annual stats in reanalysis, for direct comparison against models in modelprojs figure
if globalstats==1
    calcmse=1;calcqhql=1;
    for year=currentfirstyearcalc:currentlastyearcalc
        if calcmse==1
            clear dailymaxmseallrows;
            thismsefile=load(strcat(processedera5dir,'msedailymaxarray',num2str(year)));
            for setofrows=1:8
                temp=eval(['thismsefile.dailymaxmse' rowstems{setofrows} ';']);
                if setofrows<=7
                    dailymaxmseallrows(1:365,setofrows*100-99:setofrows*100,:)=temp;
                else
                    dailymaxmseallrows(1:365,701:721,:)=temp;
                end
                clear temp;
            end
            clear thismsefile;

            %Max and other percentiles
            maxmsebyyear(year-currentfirstyearcalc+1)=nanmax(reshape(dailymaxmseallrows,[365*721*1440 1]));
            pct9999msebyyear(year-currentfirstyearcalc+1)=quantile(reshape(dailymaxmseallrows,[365*721*1440 1]),0.9999);
            pct999msebyyear(year-currentfirstyearcalc+1)=quantile(reshape(dailymaxmseallrows,[365*721*1440 1]),0.999);
            pct99msebyyear(year-currentfirstyearcalc+1)=quantile(reshape(dailymaxmseallrows,[365*721*1440 1]),0.99);
            pct90msebyyear(year-currentfirstyearcalc+1)=quantile(reshape(dailymaxmseallrows,[365*721*1440 1]),0.9);
            pct50msebyyear(year-currentfirstyearcalc+1)=quantile(reshape(dailymaxmseallrows,[365*721*1440 1]),0.5);
        end
        if calcqhql==1
            clear qhallrows;clear qlallrows;
            qhfile=load(strcat(processedera5dir,'qharray',num2str(year)));
            qlfile=load(strcat(processedera5dir,'qlarray',num2str(year)));
            for setofrows=1:8
                temp=eval(['qhfile.qh' rowstems{setofrows} ';']);
                if setofrows<=7
                    qhallrows(1:365,setofrows*100-99:setofrows*100,:)=temp;
                else
                    qhallrows(1:365,701:721,:)=temp;
                end
                temp=eval(['qlfile.ql' rowstems{setofrows} ';']);
                if setofrows<=7
                    qlallrows(1:365,setofrows*100-99:setofrows*100,:)=temp;
                else
                    qlallrows(1:365,701:721,:)=temp;
                end
                clear temp;
            end
            clear qhfile;clear qlfile;

            %Max and other percentiles
            maxqhbyyear(year-currentfirstyearcalc+1)=nanmax(reshape(qhallrows,[365*721*1440 1]));
            pct9999qhbyyear(year-currentfirstyearcalc+1)=quantile(reshape(qhallrows,[365*721*1440 1]),0.9999);
            pct999qhbyyear(year-currentfirstyearcalc+1)=quantile(reshape(qhallrows,[365*721*1440 1]),0.999);
            pct99qhbyyear(year-currentfirstyearcalc+1)=quantile(reshape(qhallrows,[365*721*1440 1]),0.99);
            pct90qhbyyear(year-currentfirstyearcalc+1)=quantile(reshape(qhallrows,[365*721*1440 1]),0.9);
            pct50qhbyyear(year-currentfirstyearcalc+1)=quantile(reshape(qhallrows,[365*721*1440 1]),0.5);
            maxqlbyyear(year-currentfirstyearcalc+1)=nanmax(reshape(qlallrows,[365*721*1440 1]));
            pct9999qlbyyear(year-currentfirstyearcalc+1)=quantile(reshape(qlallrows,[365*721*1440 1]),0.9999);
            pct999qlbyyear(year-currentfirstyearcalc+1)=quantile(reshape(qlallrows,[365*721*1440 1]),0.999);
            pct99qlbyyear(year-currentfirstyearcalc+1)=quantile(reshape(qlallrows,[365*721*1440 1]),0.99);
            pct90qlbyyear(year-currentfirstyearcalc+1)=quantile(reshape(qlallrows,[365*721*1440 1]),0.9);
            pct50qlbyyear(year-currentfirstyearcalc+1)=quantile(reshape(qlallrows,[365*721*1440 1]),0.5);

        end
        disp(year);disp(clock);
    end
    if calcqhql==1
        maxqhbyyearERA5=maxqhbyyear;
        pct9999qhbyyearERA5=pct9999qhbyyear;
        pct999qhbyyearERA5=pct999qhbyyear;
        pct99qhbyyearERA5=pct99qhbyyear;
        pct90qhbyyearERA5=pct90qhbyyear;
        pct50qhbyyearERA5=pct50qhbyyear;
        maxqlbyyearERA5=maxqlbyyear;
        pct9999qlbyyearERA5=pct9999qlbyyear;
        pct999qlbyyearERA5=pct999qlbyyear;
        pct99qlbyyearERA5=pct99qlbyyear;
        pct90qlbyyearERA5=pct90qlbyyear;
        pct50qlbyyearERA5=pct50qlbyyear;
        save(strcat(processedera5dir,'mseqhqlstats'),...
            'maxqhbyyear','pct9999qhbyyearERA5','pct999qhbyyearERA5','pct99qhbyyearERA5',...
            'pct90qhbyyearERA5','pct50qhbyyearERA5',...
            'maxqlbyyearERA5','pct9999qlbyyearERA5','pct999qlbyyearERA5','pct99qlbyyearERA5',...
            'pct90qlbyyearERA5','pct50qlbyyearERA5','-append');
    end
end





%Get annual timeseries of annual maximum SST at each point, from which a
    %global annual-maximum timeseries can be easily constructed
if readsst==1
    globalmaxsstbypt=zeros(1440,720,40);
    globalmeansstbypt=zeros(1440,720,40);
    for year=1982:2014
        for mon=1:12
            if mon<=9;mzero='0';else;mzero='';end
            sstdata=load(strcat('/Volumes/ExternalDriveC/NOAA_OISST_Daily_Data_Mat/',num2str(year),'/',...
            'tos_',num2str(year),'_',mzero,num2str(mon),'.mat'));
            sstdata=eval(['sstdata.tos_' num2str(year) '_' mzero num2str(mon) ';']);
            sstdata=sstdata{3};
            
            globalmaxsstbypt(:,:,year-1978)=max(globalmaxsstbypt(:,:,year-1978),max(sstdata,[],3));
            
            sstdatasum=squeeze(sum(sstdata,3));
            globalmeansstbypt(:,:,year-1978)=globalmeansstbypt(:,:,year-1978)+sstdatasum;
            if sstdata(592,402)>=35;disp('Stopped!');return;end
        end
        if rem(year,4)==0;yl=366;else;yl=365;end
        globalmeansstbypt(:,:,year-1978)=globalmeansstbypt(:,:,year-1978)./yl;
        
        if rem(year,5)==0;disp(year);end
    end
    for year=1979:2018
        for mon=1:12
            if mon<=9;mzero='0';else;mzero='';end
            for day=1:28
                if day<=9;dzero='0';else;dzero='';end
                sstdata=ncread(strcat('/Volumes/ExternalDriveC/NOAA_OISST_Daily_Data/oisst-avhrr-v02r01.',...
                    num2str(year),mzero,num2str(mon),dzero,num2str(day),'.nc'),'sst');
                
                globalmaxsstbypt(:,:,year-1978)=max(globalmaxsstbypt(:,:,year-1978),sstdata);
                
                globalmeansstbypt(:,:,year-1978)=globalmeansstbypt(:,:,year-1978)+sstdata;
            end
        end
        globalmeansstbypt(:,:,year-1978)=globalmeansstbypt(:,:,year-1978)./(28*12);
    end
    save(strcat(icloud,'General_Academics/Research/Heat_Humidity_Limits/oisstarrays.mat'),'globalmaxsstbypt','globalmeansstbypt','-append');
    
    
    %Remove bad data
    globalmaxsstbypt(355:369,392:403,38)=NaN;globalmaxsstbypt(508:518,391:401,38)=NaN;
    globalmaxsstbypt(588:597,396:404,38)=NaN;globalmaxsstbypt(587:599,396:405,34)=NaN;
    globalmaxsstbypt(750:758,387:392,32)=NaN;
    
    
    temp=load(strcat(icloud,'General_Academics/Research/Heat_Humidity_Limits/oisstarrays.mat'));
    globalmaxsstbypt=temp.globalmaxsstbypt;
    globalmeansstbypt=temp.globalmeansstbypt;
    
    
    globalmaxsstbyyear=squeeze(max(squeeze(max(globalmaxsstbypt,[],1)),[],1));
    invalid=globalmaxsstbyyear==0;globalmaxsstbyyear(invalid)=NaN;
    globaltropmeansstbyyear=squeeze(mean(squeeze(mean(globalmeansstbypt(:,240:480,:),1)),1));
    invalid=globaltropmeansstbyyear==0;globaltropmeansstbyyear(invalid)=NaN;
    globalmidlatmeansstbyyear=squeeze(mean(squeeze(mean(globalmeansstbypt(:,140:220,:),1,'omitnan')),1,'omitnan'));
    invalid=globalmidlatmeansstbyyear==0;globalmidlatmeansstbyyear(invalid)=NaN;
    save(strcat(icloud,'General_Academics/Research/Heat_Humidity_Limits/oisstarrays.mat'),...
        'globalmaxsstbyyear','globaltropmeansstbyyear','globalmidlatmeansstbyyear','-append');
end





if makearrwithp999andp99gridptdaysonly==1
    %First, only get data for points that have exceeded global MSE threshold
    p90ptsallmonths=squeeze(nanmax(nanmax(p90pts,[],4),[],1));
    p99ptsallmonths=squeeze(nanmax(nanmax(p99pts,[],4),[],1));
    p999ptsallmonths=squeeze(nanmax(nanmax(p999pts,[],4),[],1));
    p9999ptsallmonths=squeeze(nanmax(nanmax(p9999pts,[],4),[],1));
    for i=1:361
        for j=1:1440
            if p9999ptsallmonths(i,j)==1
                codes(i,j)=5;
            elseif p999ptsallmonths(i,j)==1
                codes(i,j)=4;
            elseif p99ptsallmonths(i,j)==1
                codes(i,j)=3;
            elseif p90ptsallmonths(i,j)==1
                codes(i,j)=2;
            else
                codes(i,j)=1;
            end
        end
    end
    clear p90ptsallmonths;clear p99ptsallmonths;clear p999ptsallmonths;clear p9999ptsallmonths;
    
    
    minrow=1000;maxrow=0;
    for i=1:size(codes,1)
        for j=1:size(codes,2)
            if codes(i,j)>=4
                if i>maxrow
                    maxrow=i;
                end
                if i<minrow
                    minrow=i;
                end
            end
        end
    end
    
    p999dayc=0;p995dayc=0;p99dayc=0;clear arrwithallp999;clear arrwithallp995;clear arrwithallp99;
    for year=currentfirstyearcalc:currentlastyearcalc
        msedata=load(strcat(processedera5dir,'msedailymaxarray',num2str(year)));
        dailymaxmserows201to300=msedata.dailymaxmserows201to300;
        dailymaxmserows301to400=msedata.dailymaxmserows301to400;
        dailymaxmserows401to500=msedata.dailymaxmserows401to500;
        clear msedata;
        msearr=cat(2,dailymaxmserows201to300,dailymaxmserows301to400,dailymaxmserows401to500);
        clear dailymaxmserows201to300;clear dailymaxmserows301to400;clear dailymaxmserows401to500;
        for doy=1:365
            temp=squeeze(msearr(doy,:,:));
            newtemp=[temp(:,721:1440) temp(:,1:720)];clear temp;
            msearr(doy,:,:)=newtemp;clear newtemp;
        end
        
        
        %Find days that contain the exceedances of interest, i.e. those
        %that have MSE>=p999mseglobal and (separately) MSE>=p99mseglobal
        %These will be investigated in subdaily detail
        for day=1:size(msearr,1)
            for row=1:size(msearr,2)
                for col=1:size(msearr,3)
                    if msearr(day,row,col)>=p999mseglobal
                        p999dayc=p999dayc+1;
                        arrwithallp999(p999dayc,1)=year;
                        arrwithallp999(p999dayc,2)=day;
                        arrwithallp999(p999dayc,3)=row+200;
                        arrwithallp999(p999dayc,4)=col;
                    end
                    if msearr(day,row,col)>=p995mseglobal
                        p995dayc=p995dayc+1;
                        arrwithallp995(p995dayc,1)=year;
                        arrwithallp995(p995dayc,2)=day;
                        arrwithallp995(p995dayc,3)=row+200;
                        arrwithallp995(p995dayc,4)=col;
                    end
                    if msearr(day,row,col)>=p99mseglobal
                        p99dayc=p99dayc+1;
                        arrwithallp99(p99dayc,1)=year;
                        arrwithallp99(p99dayc,2)=day;
                        arrwithallp99(p99dayc,3)=row+200;
                        arrwithallp99(p99dayc,4)=col;
                    end
                end
            end
        end
    end
    save(strcat(processedera5dir,'toppctilestats'),'arrwithallp999','arrwithallp995','arrwithallp99','-append');
end



%PBL heights for 99.9th-percentile extreme-MSE days
if p999pblheights==1 
    remake=0;exist p999pblharr;
    if ans==0
        if remake==1
            pblhc=0;clear p999pblharr;clear saveddateinfo;
            for year=currentfirstyearcalc:currentlastyearcalc
            %for year=2017:2018
                temp=find(arrwithallp999(:,1)==year);yearsubset=arrwithallp999(temp,:);
                firstday=yearsubset(1,2);
                lastday=yearsubset(end,2);
                placetostart=round2(firstday/36,1,'ceil');
                placetostop=round2(lastday/36,1,'ceil');

                file=ncgeodataset(strcat('/Volumes/ExternalDriveD/ERA5_Hourly_Data_PBLheight_only/pblh_world_',num2str(year),'.grib'));
                pblhtemp=file{'Boundary_layer_height_surface'};echo off;
                for loop=placetostart:min(placetostop,10)
                    pblh=double(pblhtemp.data(36*8*loop-(36*8)+1:36*8*loop,:,:));clear newpblh;

                    for i=1:size(yearsubset,1) %across all p99.9 gridpt-days in this year
                        if yearsubset(i,2)>=36*loop-35 && yearsubset(i,2)<=36*loop %day is in the right window for this loop
                            daywithinloop=yearsubset(i,2)-(36*loop-35)+1;
                            if yearsubset(i,4)>720;colalt=yearsubset(i,4)-720;else;colalt=yearsubset(i,4)+720;end
                            pblhc=pblhc+1;
                            if daywithinloop*8-23<1
                                numtofillleft=abs(daywithinloop*8-23-1);
                                sp999pblharr(pblhc,:)=[zeros(numtofillleft,1);
                                    pblh(max(daywithinloop*8-23,1):min(daywithinloop*8+16,36*8),yearsubset(i,3),colalt)];
                            elseif daywithinloop*8+16>36*8
                                numtofillright=abs(daywithinloop*8+16-288);
                                p999pblharr(pblhc,:)=[pblh(max(daywithinloop*8-23,1):min(daywithinloop*8+16,36*8),yearsubset(i,3),colalt);...
                                    zeros(numtofillright,1)];
                            else
                                p999pblharr(pblhc,:)=pblh(max(daywithinloop*8-23,1):min(daywithinloop*8+16,36*8),yearsubset(i,3),colalt);
                            end
                            saveddateinfo(pblhc,:)=yearsubset(i,:);
                        else
                        end
                    end
                end
                clear pblhtemp;disp(year);disp(clock);
            end
            invalid=p999pblharr==0;p999pblharr(invalid)=NaN;
            save(strcat(processedera5dir,'pblhp999days.mat'),'p999pblharr','saveddateinfo','-append');
        end
    end
    
    clear arrwithpblh_daily;
    arrwithpblh_daily(:,1)=max(p999pblharr(:,1:8),[],2);
    arrwithpblh_daily(:,2)=max(p999pblharr(:,9:16),[],2);
    arrwithpblh_daily(:,3)=max(p999pblharr(:,17:24),[],2);
    arrwithpblh_daily(:,4)=max(p999pblharr(:,25:32),[],2);
    arrwithpblh_daily(:,5)=max(p999pblharr(:,33:40),[],2);
end







%Same as p999pblheights loop but exactly for the p9X extreme-MSE days as computed in tqvertprofiles
if pblheightsforprofileextremedays==1
    pblhmeanprofileextremedays=NaN.*ones(7,721,1440);pblhdistnprofileextremedays=cell(7,721,1440);
    for regloop=1:7
        if regloop==1
            regname='persiangulf';firstmonth=5;lastmonth=9;maxdesiredelev=40;
            firstpreslevel_era5=1000;
            startyear=2017;stopyear=2018;
            pblhc_toskip=[];
        elseif regloop==2
            regname='pakistan';firstmonth=5;lastmonth=9;maxdesiredelev=120;
            firstpreslevel_era5=975;
            startyear=2015;stopyear=2018;
            pblhc_toskip=[57;81;82];
        elseif regloop==3
            regname='eindiabangla';firstmonth=5;lastmonth=9;maxdesiredelev=40;
            firstpreslevel_era5=1000;
            startyear=2015;stopyear=2018;
            pblhc_toskip=[];
        elseif regloop==4
            regname='gulfofcalif';firstmonth=5;lastmonth=9;maxdesiredelev=425;
            firstpreslevel_era5=950;
            startyear=2009;stopyear=2018;
            pblhc_toskip=[];
        elseif regloop==5
            regname='wamazon';firstmonth=11;lastmonth=3;maxdesiredelev=210;
            firstpreslevel_era5=975;
            startyear=2014;stopyear=2018;
            pblhc_toskip=[];
        elseif regloop==6
            regname='redsea';firstmonth=5;lastmonth=9;maxdesiredelev=40;
            firstpreslevel_era5=1000;
            startyear=2015;stopyear=2018;
            pblhc_toskip=[];
        elseif regloop==7
            regname='naustralia';firstmonth=11;lastmonth=3;maxdesiredelev=40;
            firstpreslevel_era5=1000;
            startyear=2010;stopyear=2018;
            pblhc_toskip=[];
        end
        actualrowstart=actualrowstarts(regloop);actualrowstop=actualrowstops(regloop);
        actualcolstart=actualcolstarts(regloop);actualcolstop=actualcolstops(regloop);
        if rem(actualcolstart,1)==0.5 %need to do some averaging
            colstart1=actualcolstart-0.5;colstart2=actualcolstart+0.5;colstop1=actualcolstop-0.5;colstop2=actualcolstop+0.5;
        else
            colstart1=actualcolstart;colstart2=actualcolstart;colstop1=actualcolstop;colstop2=actualcolstop;
        end
        
        %Subset to get only days in the years and region of interest
        if regloop==1
            temp=find(arrwithallp999(:,1)>=startyear & arrwithallp999(:,1)<=stopyear);yearssubset=arrwithallp999(temp,:);
        elseif regloop==4 || regloop==7
            temp=find(arrwithallp99(:,1)>=startyear & arrwithallp99(:,1)<=stopyear);yearssubset=arrwithallp99(temp,:);
        else
            temp=find(arrwithallp995(:,1)>=startyear & arrwithallp995(:,1)<=stopyear);yearssubset=arrwithallp995(temp,:);
        end
        newro=0;clear regsubset;
        for ro=1:size(yearssubset,1)
            if yearssubset(ro,3)>=actualrowstart && yearssubset(ro,3)<=actualrowstop && ...
                yearssubset(ro,4)>=colstart2 && yearssubset(ro,4)<=colstop1
                newro=newro+1;
                regsubset(newro,:)=yearssubset(ro,:);
            end
        end
        
        pblhc_tentative=0;pblhc=0;clear arrwithpblh;clear arrwithpblh_remainder;
        onetoonevec=1:size(regsubset,1);knowndiff=0;
        pblhc_rem=0;
        clear indexincluded;
        clear newregsubset;clear newregsubset_remainder;
        %Adjust so that columns match those in newsavethedatesandlocsp9X
        if abs(mean(newsavethedatesandlocs_remainder{regloop}(:,4))-mean(newsavethedatesandlocsp9X{regloop}(:,4)))>5
            for row=1:size(newsavethedatesandlocs_remainder{regloop},1)
                if newsavethedatesandlocs_remainder{regloop}(row,4)>720
                    newsavethedatesandlocs_remainder{regloop}(row,4)=newsavethedatesandlocs_remainder{regloop}(row,4)-720;
                else
                    newsavethedatesandlocs_remainder{regloop}(row,4)=newsavethedatesandlocs_remainder{regloop}(row,4)+720;
                end
            end
        end
        newsavethedatesandlocs_remainder{regloop}=sortrows(newsavethedatesandlocs_remainder{regloop},[1 2]);
                
                
        for year=startyear:stopyear
            %temp=find(regsubset(:,1)==year);thisyearonly=regsubset(temp,:);
            temp=find(newsavethedatesandlocsp9X{regloop}==year);thisyearonly=newsavethedatesandlocsp9X{regloop}(temp,:);
            temp=find(newsavethedatesandlocs_remainder{regloop}==year);thisyearonly_remainder=newsavethedatesandlocs_remainder{regloop}(temp,:);
            
            if size(thisyearonly,1)>=1
                firstday=thisyearonly(1,2);firstday_rem=thisyearonly_remainder(1,2);
                lastday=thisyearonly(end,2);lastday_rem=thisyearonly_remainder(end,2);
                placetostart=min(round2(firstday/36,1,'ceil'),round2(firstday_rem/36,1,'ceil'));
                placetostop=max(round2(lastday/36,1,'ceil'),round2(lastday_rem/36,1,'ceil'));

                file=ncgeodataset(strcat('/Volumes/ExternalDriveD/ERA5_Hourly_Data_PBLheight_only/pblh_world_',num2str(year),'.grib'));
                pblhtemp=file{'Boundary_layer_height_surface'};clear file;echo off;
                for loop=placetostart:placetostop
                    if loop<=10
                        pblh=double(pblhtemp.data(36*8*loop-(36*8)+1:36*8*loop,:,:));
                    else %i.e. loop is at end of year
                        pblh=double(pblhtemp.data(36*8*loop-(36*8)+1:end,:,:));
                    end

                    dothis=0;
                    if dothis==1
                    for i=1:size(thisyearonly,1) %across all extreme gridpt-days in this year and region
                        if elevera5(thisyearonly(i,3),thisyearonly(i,4))<=maxdesiredelev %gridpt is low-enough elevation
                            if thisyearonly(i,2)>=36*loop-35 && thisyearonly(i,2)<=36*loop %day is in the right window for this loop
                                daywithinloop=thisyearonly(i,2)-(36*loop-35)+1;
                                pblhc_tentative=pblhc_tentative+1;
                                continueon=1;
                                %if pblhc_tentative==80;return;end
                                if size(pblhc_toskip,1)>=1
                                    %if checkifthingsareelementsofvector(newiiconversion{regloop}(pblhc),pblhc_toskip)
                                    if pblhc_tentative<=size(newiiconversion{regloop},2)
                                        if newiiconversion{regloop}(pblhc_tentative)~=onetoonevec(pblhc_tentative)+knowndiff
                                            continueon=0;
                                            disp('Skipping at least one value of pblhc\n');
                                            knowndiff=knowndiff+((newiiconversion{regloop}(pblhc_tentative))-(onetoonevec(pblhc_tentative)+knowndiff));
                                        end
                                    end
                                end
                                if continueon==1
                                    pblhc=pblhc+1;
                                    if daywithinloop*8-23<1
                                        numtofillleft=abs(daywithinloop*8-23-1);
                                        p999pblharr(pblhc,:)=[zeros(numtofillleft,1);
                                            pblh(max(daywithinloop*8-23,1):min(daywithinloop*8+16,36*8),thisyearonly(i,3),thisyearonly(i,4))];
                                    elseif daywithinloop*8+16>36*8
                                        numtofillright=abs(daywithinloop*8+16-288);
                                        p999pblharr(pblhc,:)=[pblh(max(daywithinloop*8-23,1):min(daywithinloop*8+16,36*8),thisyearonly(i,3),thisyearonly(i,4));...
                                            zeros(numtofillright,1)];
                                    else
                                        p999pblharr(pblhc,:)=pblh(max(daywithinloop*8-23,1):min(daywithinloop*8+16,36*8),thisyearonly(i,3),thisyearonly(i,4));
                                    end
                                    newregsubset(pblhc,:)=thisyearonly(i,:);
                                end
                            end
                        end
                    end
                    end
                    
                    for i=1:size(thisyearonly,1) %across all p9X gridpt-days in this year and region
                        if thisyearonly(i,2)>=36*loop-35 && thisyearonly(i,2)<=36*loop %day is in the right window for this loop
                            daywithinloop=thisyearonly(i,2)-(36*loop-35)+1;
                            pblhc=pblhc+1;
                            if daywithinloop*8-23<1
                                numtofillleft=abs(daywithinloop*8-23-1);
                                p999pblharr(pblhc,:)=[zeros(numtofillleft,1);
                                    pblh(max(daywithinloop*8-23,1):min(daywithinloop*8+16,size(pblh,1)),...
                                    thisyearonly(i,3),thisyearonly(i,4))];
                            elseif daywithinloop*8+16>36*8
                                numtofillright=abs(daywithinloop*8+16-288);
                                p999pblharr(pblhc,:)=[pblh(max(daywithinloop*8-23,1):min(daywithinloop*8+16,size(pblh,1)),...
                                    thisyearonly(i,3),thisyearonly(i,4));...
                                    zeros(numtofillright,1)];
                            else
                                p999pblharr(pblhc,:)=pblh(max(daywithinloop*8-23,1):min(daywithinloop*8+16,size(pblh,1)),...
                                    thisyearonly(i,3),thisyearonly(i,4));
                            end
                            newregsubset(pblhc,:)=thisyearonly(i,:);
                        end
                    end
                    
                    
                    %Also pull data for non-extreme days (i.e. the 'remainder' ones)
                    %fprintf('Number of remainder gridpts in this year: %d\n',size(thisyearonly_remainder,1));
                    for i=1:size(thisyearonly_remainder,1) %across all 'remainder' gridpt-days in this year and region
                        if thisyearonly_remainder(i,2)>=36*loop-35 && thisyearonly_remainder(i,2)<=36*loop %day is in the right window for this loop
                            daywithinloop=thisyearonly_remainder(i,2)-(36*loop-35)+1;
                            pblhc_rem=pblhc_rem+1;
                            if daywithinloop*8-23<1
                                numtofillleft=abs(daywithinloop*8-23-1);
                                arrwithpblh_remainder(pblhc_rem,:)=[zeros(numtofillleft,1);
                                    pblh(max(daywithinloop*8-23,1):min(daywithinloop*8+16,size(pblh,1)),...
                                    thisyearonly_remainder(i,3),thisyearonly_remainder(i,4))];
                            elseif daywithinloop*8+16>36*8
                                numtofillright=abs(daywithinloop*8+16-288);
                                arrwithpblh_remainder(pblhc_rem,:)=[pblh(max(daywithinloop*8-23,1):min(daywithinloop*8+16,size(pblh,1)),...
                                    thisyearonly_remainder(i,3),thisyearonly_remainder(i,4));...
                                    zeros(numtofillright,1)];
                            else
                                if loop<=10 %normal
                                    arrwithpblh_remainder(pblhc_rem,:)=pblh(max(daywithinloop*8-23,1):min(daywithinloop*8+16,size(pblh,1)),...
                                        thisyearonly_remainder(i,3),thisyearonly_remainder(i,4));
                                else %special (end of year)
                                    arrwithpblh_remainder(pblhc_rem,17:24)=pblh(max(daywithinloop*8-7,1):min(daywithinloop*8,size(pblh,1)),...
                                        thisyearonly_remainder(i,3),thisyearonly_remainder(i,4));
                                end
                            end
                            newregsubset_remainder(pblhc_rem,:)=thisyearonly_remainder(i,:);
                        end
                    end
                end
            end
            clear pblhtemp;disp(year);disp(clock);
        end

        invalid=p999pblharr==0;p999pblharr(invalid)=NaN;
        invalid=arrwithpblh_remainder==0;arrwithpblh_remainder(invalid)=NaN;

        clear arrwithpblh_daily;clear arrwithpblh_daily_remainder;
        arrwithpblh_daily(:,1)=max(p999pblharr(:,1:8),[],2);
        arrwithpblh_daily(:,2)=max(p999pblharr(:,9:16),[],2);
        arrwithpblh_daily(:,3)=max(p999pblharr(:,17:24),[],2);
        arrwithpblh_daily(:,4)=max(p999pblharr(:,25:32),[],2);
        arrwithpblh_daily(:,5)=max(p999pblharr(:,33:40),[],2);
        arrwithpblh_daily_remainder(:,1)=max(arrwithpblh_remainder(:,1:8),[],2);
        arrwithpblh_daily_remainder(:,2)=max(arrwithpblh_remainder(:,9:16),[],2);
        arrwithpblh_daily_remainder(:,3)=max(arrwithpblh_remainder(:,17:24),[],2);
        arrwithpblh_daily_remainder(:,4)=max(arrwithpblh_remainder(:,25:32),[],2);
        arrwithpblh_daily_remainder(:,5)=max(arrwithpblh_remainder(:,33:40),[],2);
                
        clear regsubsetexp;clear regsubsetexp_remainder;
        regsubsetexp=[newregsubset arrwithpblh_daily [1:size(newregsubset,1)]']; %add ordinate
        regsubsetexpsorted=sortrows(regsubsetexp,[3,4]); %so all days for a given gridpt are grouped together
        regsubsetexp_remainder=[newregsubset_remainder arrwithpblh_daily_remainder [1:size(newregsubset_remainder,1)]']; %add ordinate
        regsubsetexpsorted_remainder=sortrows(regsubsetexp_remainder,[3,4]); %so all days for a given gridpt are grouped together
        
        %Verify results are correct!
        if size(regsubsetexpsorted,1)~=size(newarrwithtprofilep9X{regloop},1)
            disp('Stopped at line 4221');return;
        elseif size(regsubsetexpsorted_remainder,1)~=size(newarrwithtprofile_remainder{regloop},1)
            disp('Stopped at line 4223');return;
        end
        
        %final pbl-height statistics for extreme-MSE days at each gridpoint in this region
        thisptstartpos=1;prevrow=0;prevcol=0;thisgridptc=1;
        for i=1:size(regsubsetexpsorted,1)
            currow=regsubsetexpsorted(i,3);curcol=regsubsetexpsorted(i,4);
            if currow==prevrow && curcol==prevcol
                thisgridptc=thisgridptc+1;
            else %finished, so sum up (through the previous i)
                %column 7 -- middle day (i.e. extreme-MSE day) of the 5 days pulled
                pblhmeanprofileextremedays(regloop,currow,curcol)=mean(mean(regsubsetexpsorted(thisptstartpos:i-1,7),'omitnan'),'omitnan');
                pblhdistnprofileextremedays{regloop,currow,curcol}=[regsubsetexpsorted(thisptstartpos:i-1,1:2) regsubsetexpsorted(thisptstartpos:i-1,7)];
                
                thisptstartpos=i+1;
                thisgridptc=1;
            end
            prevrow=currow;prevcol=curcol;
        end
        regsubsetexpalltogether{regloop}=regsubsetexp;
        
        %final pbl-height statistics for 'remainder' days at each gridpoint in this region
        thisptstartpos=1;prevrow=0;prevcol=0;thisgridptc=1;
        thisptstartpos=1;prevrow=0;prevcol=0;thisgridptc=1;
        for i=1:size(regsubsetexpsorted_remainder,1)
            currow=regsubsetexpsorted_remainder(i,3);curcol=regsubsetexpsorted_remainder(i,4);
            if currow==prevrow && curcol==prevcol
                thisgridptc=thisgridptc+1;
            else %finished, so sum up (through the previous i)
                %column 7 -- middle day (i.e. extreme-MSE day) of the 5 days pulled
                pblhmeanprofileremainderdays(regloop,currow,curcol)=mean(mean(regsubsetexpsorted_remainder(thisptstartpos:i-1,7),'omitnan'),'omitnan');
                pblhdistnprofileremainderdays{regloop,currow,curcol}=...
                    [regsubsetexpsorted_remainder(thisptstartpos:i-1,1:2) regsubsetexpsorted_remainder(thisptstartpos:i-1,7)];
                
                thisptstartpos=i+1;
                thisgridptc=1;
            end
            prevrow=currow;prevcol=curcol;
        end
        regsubsetexpalltogether_remainder{regloop}=regsubsetexp_remainder;
        
        disp('line 1810');disp(regloop);disp(clock);
    end
    save(strcat(processedera5dir,'pblhforprofiles.mat'),'pblhmeanprofileextremedays','pblhdistnprofileextremedays',...
        'regsubsetexpalltogether','pblhmeanprofileremainderdays','pblhdistnprofileremainderdays','regsubsetexpalltogether_remainder','-append');
end
%Soundings that demonstrate the very sharp vertical moisture gradients:
%http://weather.uwyo.edu/cgi-bin/sounding?region=mideast&TYPE=TEXT%3ALIST&YEAR=2017&MONTH=08&FROM=0712&TO=0712&STNM=41024



%Time of day of all-time maximum MSE at each gridpoint (regardless of the MSE value)
if dateofalltimemax==1
    finalmaxyears=NaN.*ones(721,1440);finalmaxdoys=NaN.*ones(721,1440);
    for rowset=1:8
        if rowset~=8;numrowshere=100;else;numrowshere=21;end
        bigmsearray=NaN.*ones(numyearscalc,365,numrowshere,1440);
        for year=currentfirstyearcalc:currentlastyearcalc
            datafile=load(strcat(processedera5dir,'msedailymaxarray',num2str(year)));

            if rowset==1
                bigmsearray(year-(currentfirstyearcalc-1),:,:,:)=datafile.dailymaxmserows1to100;
            elseif rowset==2
                bigmsearray(year-(currentfirstyearcalc-1),:,:,:)=datafile.dailymaxmserows101to200;
            elseif rowset==3
                bigmsearray(year-(currentfirstyearcalc-1),:,:,:)=datafile.dailymaxmserows201to300;
            elseif rowset==4
                bigmsearray(year-(currentfirstyearcalc-1),:,:,:)=datafile.dailymaxmserows301to400;
            elseif rowset==5
                bigmsearray(year-(currentfirstyearcalc-1),:,:,:)=datafile.dailymaxmserows401to500;
            elseif rowset==6
                bigmsearray(year-(currentfirstyearcalc-1),:,:,:)=datafile.dailymaxmserows501to600;
            elseif rowset==7
                bigmsearray(year-(currentfirstyearcalc-1),:,:,:)=datafile.dailymaxmserows601to700;
            else
                bigmsearray(year-(currentfirstyearcalc-1),:,:,:)=datafile.dailymaxmserows701to721;
            end
        end

        %When did max value at each gridpt occur?
        bigmsearray=permute(bigmsearray,[2 1 3 4]);
        bigmsearray_resh=reshape(bigmsearray,[numyearscalc*365,numrowshere,1440]);clear bigmsearray;
        [maxs,maxtimes]=max(bigmsearray_resh);maxs=squeeze(maxs);maxtimes=squeeze(maxtimes);
        maxyears=round2(maxtimes/365,1,'ceil')+currentfirstyearcalc-1;
        maxdoys=rem(maxtimes,365);lastdays=maxdoys==0;maxdoys(lastdays)=365;

        if rowset<=7
            finalmaxyears(rowset*100-99:rowset*100,:)=maxyears;
            finalmaxdoys(rowset*100-99:rowset*100,:)=maxdoys;
        else
            finalmaxyears(701:721,:)=maxyears;
            finalmaxdoys(701:721,:)=maxdoys;
        end
        fprintf('Finished rowset %d\n',rowset);
    end
    save(strcat(processedera5dir,'timeofmaxmseNEW'),'finalmaxyears','finalmaxdoys','-append');
    clear bigmsearray_resh;
end



if timelineaddition_preciponly==1
    %Quickly get full distributions for precipitation only (as opposed to getfulldistns loop, which laboriously does this for all variables)
    %10 min
    totalcnh=0;totalcsh=0;
    cbypt=zeros(721,1440);preciptimeline=cell(721,1440);datestimeline=cell(721,1440);yeartimeline=cell(721,1440);
    for year=startyear:stopyear
        preciptemp=ncread(strcat('/Volumes/ExternalDriveC/CHIRPS_Precipitation/chirps-v2.0.',num2str(year),'.days_p25.nc'),'precip');
        clear precipdata;
        for day=1:365
            precipthisday=squeeze(preciptemp(:,:,day));precipthisday=flipud(precipthisday');
            precipdata(day,:,:)=precipthisday;
        end
        
        totalcnh=totalcnh+153*8;totalcsh=totalcsh+151*8;
        for regnum=1:5
            if regnum~=4
                row1=actualrowstarts(regnum);row2=actualrowstops(regnum);col1=actualcolstarts(regnum)-0.5;col2=actualcolstops(regnum)+0.5;
                row1adj=row1-160;row2adj=row2-160;
                
                if regnum<=3
                    precipdata_wsonly=squeeze(precipdata(121:273,row1adj:row2adj,col1:col2));
                else
                    precipdata_wsonly=cat(1,squeeze(precipdata(305:365,row1adj:row2adj,col1:col2)),squeeze(precipdata(1:90,row1adj:row2adj,col1:col2)));
                end
                
                for daywithin=5:size(precipdata_wsonly,1)
                    for iwithin=1:size(precipdata_wsonly,2)
                        for jwithin=1:size(precipdata_wsonly,3)
                            cbypt(iwithin+row1-1,jwithin+col1-1)=cbypt(iwithin+row1-1,jwithin+col1-1)+1;
                            
                            preciptimeline{iwithin+row1-1,jwithin+col1-1}(cbypt(iwithin+row1-1,jwithin+col1-1),:)=precipdata_wsonly(daywithin-4:daywithin,iwithin,jwithin);
                            
                            if regnum<=3
                                datestimeline{iwithin+row1-1,jwithin+col1-1}(cbypt(iwithin+row1-1,jwithin+col1-1),1)=120+daywithin;
                                yeartimeline{iwithin+row1-1,jwithin+col1-1}(cbypt(iwithin+row1-1,jwithin+col1-1),1)=year;
                            else
                                datestimeline{iwithin+row1-1,jwithin+col1-1}(cbypt(iwithin+row1-1,jwithin+col1-1),1)=304+daywithin;
                                if 304+daywithin>365
                                    datestimeline{iwithin+row1-1,jwithin+col1-1}(cbypt(iwithin+row1-1,jwithin+col1-1),1)=304+daywithin-365;
                                end
                                yeartimeline{iwithin+row1-1,jwithin+col1-1}(cbypt(iwithin+row1-1,jwithin+col1-1),1)=year;
                            end
                        end
                    end
                end
            end
        end
        disp(year);
    end
    
    save(strcat(processedera5dir,'fulldistnarraysPRECIPITATIONONLY2018.mat'),'preciptimeline','datestimeline','yeartimeline','-v7.3');
end


if quicksstanoms==1
    for regloop=1:5
        if regloop~=4
        if regloop==1 || regloop==2
            temp=find(arrwithallp999(:,1)>=startyear & arrwithallp999(:,1)<=stopyear);thisarr=arrwithallp999(temp,:);
        else
            temp=find(arrwithallp99(:,1)>=startyear & arrwithallp99(:,1)<=stopyear);thisarr=arrwithallp99(temp,:);
        end
        
        row1=actualrowstarts(regloop);row2=actualrowstops(regloop);
        col1=actualcolstarts(regloop)-0.5;col2=actualcolstops(regloop)+0.5;
        
        newro=0;clear regsubset;
        for ro=1:size(thisarr,1)
            if thisarr(ro,3)>=row1 && thisarr(ro,3)<=row2 && thisarr(ro,4)>=col1 && thisarr(ro,4)<col2
                newro=newro+1;
                regsubset(newro,:)=thisarr(ro,:);
            end
        end
        regsubsetchron=sortrows(regsubset,[1 2]);
        
        %At how many points was threshold exceeded in this region? (if only a few, don't want to use...)
        prevyr=regsubsetchron(1,1);prevdoy=regsubsetchron(1,2);indexoflast=0;clear countsofdays;
        for row=2:size(regsubsetchron,1)
            thisyr=regsubsetchron(row,1);thisdoy=regsubsetchron(row,2);
            if thisyr~=prevyr || thisdoy~=prevdoy
                totalcofthisdoy=row-indexoflast;
                countsofdays(thisyr-min(regsubsetchron(:,1))+1,thisdoy)=totalcofthisdoy;
                indexoflast=row;
                prevyr=thisyr;prevdoy=thisdoy;
            end
        end
        alldaysc=reshape(countsofdays,[size(countsofdays,1)*size(countsofdays,2),1]);
        theseverytopdays=alldaysc>=quantile(alldaysc,0.95);
        theseverytopdays=reshape(theseverytopdays,[size(countsofdays,1),size(countsofdays,2)]);
        
        %Read SST for these 'very top' days
        compositec=0;prevyr=0;justread=zeros(40,365);clear bigsstarr;
        for row=1:size(regsubsetchron,1)
            yr=regsubsetchron(row,1);
            if yr>=1982
                relyr=yr-min(regsubsetchron(:,1))+1;
                doy=regsubsetchron(row,2);

                if yr~=prevyr
                    sstarray=ncread(strcat('/Volumes/ExternalDriveC/NOAA_OISST_Daily_Anoms/sst.day.anom.',num2str(yr),'.v2.nc'),'anom');
                    if rem(yr,10)==0;fprintf('Just reread SST data for year %d\n',yr);end
                    prevyr=yr;
                end

                if theseverytopdays(relyr,doy)==1 && justread(relyr,doy)==0
                    compositec=compositec+1;
                    bigsstarr(compositec,:,:)=sstarray(:,201:521,doy);
                    justread(relyr,doy)=1;
                end
            end
        end
        invalid=abs(bigsstarr)>50;bigsstarr(invalid)=NaN;
        meansstanom{regloop}=squeeze(mean(bigsstarr));
        numdaysused(regloop)=size(bigsstarr,1);
        
        %troubleshooting
        for yr=1982:2018
            sstarray=ncread(strcat('/Volumes/ExternalDriveC/NOAA_OISST_Daily_Anoms/sst.day.anom.',num2str(yr),'.v2.nc'),'anom');
            relyr=yr-1981;overallmeanatptofinterest(relyr)=sstarray(203,210,226);
        end
        end
    end
    save('/Volumes/ExternalDriveC/NOAA_OISST_Daily_Anoms/anomsforhhlproject.mat','meansstanom','numdaysused');
end


if quickpressureanoms==1
    allpsfc1=[];allpsfc5=[];
    for regloop=1:5
        if regloop~=4
        if regloop==1 || regloop==2
            temp=find(arrwithallp999(:,1)>=2014 & arrwithallp999(:,1)<=2017);thisarr=arrwithallp999(temp,:);
        else
            temp=find(arrwithallp99(:,1)>=2014 & arrwithallp99(:,1)<=2017);thisarr=arrwithallp99(temp,:);
        end
        
        row1=actualrowstarts(regloop);row2=actualrowstops(regloop);
        col1=actualcolstarts(regloop)-0.5;col2=actualcolstops(regloop)+0.5;
        
        newro=0;clear regsubset;
        for ro=1:size(thisarr,1)
            if thisarr(ro,3)>=row1 && thisarr(ro,3)<=row2 && thisarr(ro,4)>=col1 && thisarr(ro,4)<col2
                newro=newro+1;
                regsubset(newro,:)=thisarr(ro,:);
            end
        end
        regsubsetchron=sortrows(regsubset,[1 2]);
        
        %At how many points was threshold exceeded in this region? (if only a few, don't want to use...)
        prevyr=regsubsetchron(1,1);prevdoy=regsubsetchron(1,2);indexoflast=0;clear countsofdays;
        for row=2:size(regsubsetchron,1)
            thisyr=regsubsetchron(row,1);thisdoy=regsubsetchron(row,2);
            if thisyr~=prevyr || thisdoy~=prevdoy
                totalcofthisdoy=row-indexoflast;
                countsofdays(thisyr-min(regsubsetchron(:,1))+1,thisdoy)=totalcofthisdoy;
                indexoflast=row;
                prevyr=thisyr;prevdoy=thisdoy;
            end
        end
        alldaysc=reshape(countsofdays,[size(countsofdays,1)*size(countsofdays,2),1]);
        theseverytopdays=alldaysc>=quantile(alldaysc,0.95);
        theseverytopdays=reshape(theseverytopdays,[size(countsofdays,1),size(countsofdays,2)]);
        
        %Read pressure for these 'very top' days
        compositec=0;prevyr=0;justread=zeros(4,365);clear bigpsfcarr;
        for row=1:size(regsubsetchron,1)
            yr=regsubsetchron(row,1);
            relyr=yr-min(regsubsetchron(:,1))+1;
            doy=regsubsetchron(row,2);
            
            if yr~=prevyr
                psfcfile=ncgeodataset(strcat('/Volumes/ExternalDriveC/ERA5_Hourly_Data_PandGHonly/psfc_world_',num2str(yr),'.grib'));
                psfctemp=psfcfile{'Surface_pressure_surface'};echo off; %in Pa
                psfc1=double(psfctemp.data(1:8:2920,201:500,420:1116));psfc5=double(psfctemp.data(5:8:2920,201:500,420:1116));clear psfctemp; %centered on 0
                %psfc1=cat(3,psfc1(:,:,721:1440),psfc1(:,:,1:720));psfc5=cat(3,psfc5(:,:,721:1440),psfc5(:,:,1:720)); 
                prevyr=yr;
            end
            
            if theseverytopdays(relyr,doy)==1 && justread(relyr,doy)==0
                compositec=compositec+1;
                bigpsfcarr(compositec,:,:)=(psfc1(doy,:,:)+psfc5(doy,:,:))./2;
                justread(relyr,doy)=1;
            end
        end
        save(strcat(processedera5dir,'psfcarraysreg',num2str(regloop)),'bigpsfcarr','-v7.3');
        
        if regloop==1
            for yr=2014:2017
            psfcfile=ncgeodataset(strcat('/Volumes/ExternalDriveC/ERA5_Hourly_Data_PandGHonly/psfc_world_',num2str(yr),'.grib'));
            psfctemp=psfcfile{'Surface_pressure_surface'};echo off; %in Pa
            psfc1=double(psfctemp.data(1:8:2920,201:500,420:1116));psfc5=double(psfctemp.data(5:8:2920,201:500,420:1116));clear psfctemp;
            allpsfc1=cat(1,allpsfc1,psfc1);allpsfc5=cat(1,allpsfc5,psfc5);clear psfc1;clear psfc5;
            end
        end
        end
    end
    
    dailymeanpsfc=(allpsfc1+allpsfc5)./2;clear allpsfc1;clear allpsfc5;
    dailymeanpsfc=cat(3,NaN.*ones(1460,300,419),dailymeanpsfc,NaN.*ones(1460,300,324));
    
    f=load(strcat(processedera5dir,'psfcarraysreg1'));bigpsfcarr1=f.bigpsfcarr;
    f=load(strcat(processedera5dir,'psfcarraysreg2'));bigpsfcarr2=f.bigpsfcarr;
    f=load(strcat(processedera5dir,'psfcarraysreg3'));bigpsfcarr3=f.bigpsfcarr;
    f=load(strcat(processedera5dir,'psfcarraysreg5'));bigpsfcarr5=f.bigpsfcarr;
    
    %Create figure
    %Use subregrowstarts to really zero in on the places that matter most in each region (to characterize seasons when extreme days occur)
    figure(81);clf;curpart=1;highqualityfiguresetup;
    for regloop=1:5
        if regloop~=4
            if regloop<=3;regord=regloop;else;regord=4;end
            thisarr=eval(['bigpsfcarr' num2str(regloop) ';']);thisarr=cat(3,NaN.*ones(size(thisarr,1),300,419),thisarr,NaN.*ones(size(thisarr,1),300,324));
            clear thisarrasanom;
            if regloop==1
                regname='persian-gulf-greater';wsstart=150;wsstop=240;
            elseif regloop==2
                regname='pakistan-muchgreater';wsstart=140;wsstop=230;
            elseif regloop==3
                regname='eindia-sm';wsstart=140;wsstop=230;
            else
                regname='northern-south-america-sm';wsstart=1;wsstop=90;
            end
            thisarrasanom=squeeze(mean(thisarr))-squeeze(mean(cat(1,dailymeanpsfc(wsstart:wsstop,:,:),dailymeanpsfc(wsstart+365:wsstop+365,:,:),dailymeanpsfc(wsstart+730:wsstop+730,:,:),dailymeanpsfc(wsstart+1095:wsstop+1095,:,:))));
            thisarrasanom=cat(1,thisarrasanom,zeros(221,1440));thisarrasanom=cat(1,zeros(200,1440),thisarrasanom);
            thisarrasanom=thisarrasanom./100;invalid=isnan(thisarrasanom);thisarrasanom(invalid)=0;
            data={era5latarray;era5lonarray;thisarrasanom}; %in hPa
            vararginnew={'datatounderlay';data;'underlaycaxismin';-2;'underlaycaxismax';2;'mystepunderlay';1;...
                'underlaycolormap';colormaps('classy rainbow','more','not');'overlaynow';0;'nonewfig';1;'variable';'generic scalar'};
            datatype='custom';
            
            if regloop>=2;subplot(2,2,regord);end
            plotModelData(data,regname,vararginnew,datatype);
            
            if regloop==1
                set(gca,'Position',[0.01 0.55 0.48 0.37]);
            elseif regloop==2
                set(gca,'Position',[0.52 0.55 0.48 0.37]);
            elseif regloop==3
                set(gca,'Position',[0.01 0.05 0.48 0.37]);
            elseif regloop==5
                set(gca,'Position',[0.52 0.05 0.48 0.37]);
            end
        end
    end
    figname='pressureanomcomposite';curpart=2;highqualityfiguresetup;
end


if quickprecipanoms==1
    for regloop=1:5
        if regloop~=4
        if regloop==1 || regloop==2
            temp=find(arrwithallp999(:,1)>=2014 & arrwithallp999(:,1)<=2017);thisarr=arrwithallp999(temp,:);
        else
            temp=find(arrwithallp99(:,1)>=2014 & arrwithallp99(:,1)<=2017);thisarr=arrwithallp99(temp,:);
        end
        
        row1=subregrowstarts(regloop);row2=subregrowstops(regloop);
        col1=subregcolstarts(regloop);col2=subregcolstops(regloop);
        if col1>720;col1alt=col1-720;col2alt=col2-720;else;col1alt=col1+720;col2alt=col2+720;end %because array is centered on 180
        
        newro=0;clear regsubset;
        for ro=1:size(thisarr,1)
            if thisarr(ro,3)>=row1 && thisarr(ro,3)<=row2 && thisarr(ro,4)>=col1 && thisarr(ro,4)<col2
                newro=newro+1;
                regsubset(newro,:)=thisarr(ro,:);
            end
        end
        regsubsetchron=sortrows(regsubset,[1 2]);
        
        %At how many points was threshold exceeded in this region? (if only a few, don't want to use...)
        prevyr=regsubsetchron(1,1);prevdoy=regsubsetchron(1,2);indexoflast=0;clear countsofdays;
        for row=2:size(regsubsetchron,1)
            thisyr=regsubsetchron(row,1);thisdoy=regsubsetchron(row,2);
            if thisyr~=prevyr || thisdoy~=prevdoy
                totalcofthisdoy=row-indexoflast;
                countsofdays(thisyr-min(regsubsetchron(:,1))+1,thisdoy)=totalcofthisdoy;
                indexoflast=row;
                prevyr=thisyr;prevdoy=thisdoy;
            end
        end
        alldaysc=reshape(countsofdays,[size(countsofdays,1)*size(countsofdays,2),1]);
        theseverytopdays=alldaysc>=2; %require at least 2 gridpts in this subregion above the global p99 on a given day
        theseverytopdays=reshape(theseverytopdays,[size(countsofdays,1),size(countsofdays,2)]);
        
        %Read precip for these 'very top' days
        compositec=0;prevyr=0;justread=zeros(4,365);clear bigpreciparr;
        for row=1:size(regsubsetchron,1)
            yr=regsubsetchron(row,1);
            relyr=yr-min(regsubsetchron(:,1))+1;
            doy=regsubsetchron(row,2);
            
            if yr~=prevyr
                precipfile=ncgeodataset(strcat('/Volumes/ExternalDriveD/ERA5_variousvariables/precip_world_',num2str(yr),'.grib'));
                preciptemp=precipfile{'Total_precipitation_surface_1_Hour_Accumulation'};echo off;
                precip=double(preciptemp.data(1:2920,row1-20:row2+20,col1alt-20:col2alt+20));clear preciptemp; %centered on 180
                prevyr=yr;
            end
            
            if theseverytopdays(relyr,doy)==1 && justread(relyr,doy)==0 && regsubsetchron(row,3)>=row1 && regsubsetchron(row,3)<=row2 &&...
                    regsubsetchron(row,4)>=col1 && regsubsetchron(row,4)<=col2
            %if justread(relyr,doy)==0
                compositec=compositec+1;
                bigpreciparr(compositec,:,:,:)=precip(doy*8-7:doy*8,:,:);
                justread(relyr,doy)=1;
            end
            if rem(row,25)==0;fprintf('Completed row %d for region %d\n',row,regloop);end
        end
        if regloop==1
            save(strcat(processedera5dir,'preciparraysreg1'),'bigpreciparr');
        elseif regloop==2
            save(strcat(processedera5dir,'preciparraysreg2'),'bigpreciparr');
        elseif regloop==3
            save(strcat(processedera5dir,'preciparraysreg3'),'bigpreciparr');
        elseif regloop==5
            save(strcat(processedera5dir,'preciparraysreg5'),'bigpreciparr');
        end
        
        end
    end
    
    %Create climo
    for regloop=1:5
        row1=subregrowstarts(regloop);row2=subregrowstops(regloop);
        col1=subregcolstarts(regloop);col2=subregcolstops(regloop);
        if col1>720;col1alt=col1-720;col2alt=col2-720;else;col1alt=col1+720;col2alt=col2+720;end %because array is centered on 180
        arrayforclimo=NaN.*ones(3,2920,row2-row1+41,col2-col1+41);
        if regloop~=4
            for yr=2014:2016
                precipfile=ncgeodataset(strcat('/Volumes/ExternalDriveD/ERA5_variousvariables/precip_world_',num2str(yr),'.grib'));
                preciptemp=precipfile{'Total_precipitation_surface_1_Hour_Accumulation'};echo off;clear precipfile;
                precip=double(preciptemp.data(1:2920,row1-20:row2+20,col1alt-20:col2alt+20));clear preciptemp; %centered on 180
                arrayforclimo(yr-2013,:,:,:)=precip;clear precip;
                disp(yr);
            end
            regionalclimoprecip=squeeze(mean(arrayforclimo));
            clear meanpreciptracebypoint;
            for i=row1-20:row2+20
                for j=col1-20:col2+20
                    allprecipthispoint=NaN.*ones(90,8);
                    for k=1:90
                        allprecipthispoint(k,:)=regionalclimoprecip(topdays(k,i,j)*8-7:topdays(k,i,j)*8,i-(row1-20)+1,j-(col1-20)+1);
                    end
                    meanpreciptracebypoint(i-(row1-20)+1,j-(col1-20)+1,:)=squeeze(mean(allprecipthispoint));
                end
            end
            regmeanpreciptrace=squeeze(mean(mean(meanpreciptracebypoint)));
            save(strcat(processedera5dir,'precipclimoarrayreg',num2str(regloop)),'meanpreciptracebypoint');
        end
    end
end



%Enables the calculation of standardized anomalies for the final figures
if getfulldistnsoftimelinevariables==1
    beginrow=201;endrow=481;begincol=201;endcol=1361;
        
    exist weightsforeach;
    if ans==0;temp=load(strcat(processedera5dir,'percentilesofothervariables.mat'));weightsforeach=temp.weightsforeach;end
    exist topdays;
    if ans==0;temp=load(strcat(processedera5dir,'climtopmsedays'));topdays=temp.topdays;end
    exist p99msebypoint;
    if ans==0;thisfile=load(strcat(processedera5dir,'mseqhqlstats'));p99msebypoint=thisfile.p99msebypoint;end
    
    for year=startyear:stopyear
        countsbygridpt=zeros(721,1440); 
        cbygridpttimeline=zeros(721,1440);msetimeline=cell(721,1440);
        datestimeline=cell(721,1440);timeofmaxtimeline=cell(721,1440);
        qhtimeline=cell(721,1440);qltimeline=cell(721,1440);
        pblhtimeline=cell(721,1440);preciptimeline=cell(721,1440);precipchirpstimeline=cell(721,1440);msstimeline=cell(721,1440);
        sfcsensibletimeline=cell(721,1440);sfclatenttimeline=cell(721,1440);
        lwtimeline=cell(721,1440);swtimeline=cell(721,1440);
        utimeline=cell(721,1440);vtimeline=cell(721,1440);wtimeline=cell(721,1440);
    
        if year<=2013;modellevdataloc='ExternalDriveF/ERA5_modelleveldata_0000to2013';else;modellevdataloc='ExternalDriveD/ERA5_modelleveldata';end
        
        if reloadalldataforyear==1
        setup_nctoolbox;
        
        %Load temperature, dewpoint, and surface pressure
        file=ncgeodataset(strcat(mainera5dir,'ttd_world_',num2str(year),'.grib'));
        ttemp=file{'2_metre_temperature_surface'};echo off;
        tdtemp=file{'2_metre_dewpoint_temperature_surface'};echo off;clear file;
        psfcfile=ncgeodataset(strcat('/Volumes/ExternalDriveC/ERA5_Hourly_Data_PandGHonly/psfc_world_',num2str(year),'.grib'));
        psfctemp=psfcfile{'Surface_pressure_surface'};echo off;
        
        %Load daily pblh data
        file=ncgeodataset(strcat('/Volumes/ExternalDriveC/ERA5_Hourly_Data_PBLheight_only/pblh_world_',num2str(year),'.grib'));
        pblhtemp=file{'Boundary_layer_height_surface'};echo off;clear file;
        
        %Load precipitation
        file=ncgeodataset(strcat('/Volumes/ExternalDriveD/ERA5_variousvariables/precip_world_',num2str(year),'.grib'));
        preciptemp=file{'Total_precipitation_surface_1_Hour_Accumulation'};echo off;clear file;
        
        %Load daily CHIRPS precip
        chirpspreciptemp=ncread(strcat('/Volumes/ExternalDriveC/CHIRPS_Precipitation/chirps-v2.0.',num2str(year),'.days_p25.nc'),'precip');
        clear chirpsprecipdata_year;
        for day=1:365
            chirpsprecipthisday=squeeze(chirpspreciptemp(:,:,day));chirpsprecipthisday=flipud(chirpsprecipthisday');
            chirpsprecipdata_year(day,:,:)=chirpsprecipthisday;
        end
        
        %Load surface fluxes
        file=ncgeodataset(strcat('/Volumes/ExternalDriveD/ERA5_variousvariables/sfcsensiblelatentflux_world_',num2str(year),'.grib'));
        sfcsensibletemp=file{'Surface_sensible_heat_flux_surface_1_Hour_Accumulation'};echo off;
        sfclatenttemp=file{'Surface_latent_heat_flux_surface_1_Hour_Accumulation'};echo off;clear file;
        

                        
        
        %Get MSE data for each day in this year
        maxdailymse=NaN.*ones(364,721,1440);
        for i=1:364
            adj=0;
            
            t=double(ttemp.data(i*8-7-adj:i*8-adj,:,:));
            td=double(tdtemp.data(i*8-7-adj:i*8-adj,:,:))-273.15;
            psfc=squeeze(double(psfctemp.data(i*8-7-adj:i*8-adj,:,:)));clear newpsfc;
            for h=1:size(psfc,1)
                temp=squeeze(psfc(h,:,:));
                newtemp=[temp(:,721:1440) temp(:,1:720)];
                newpsfc(h,:,:)=newtemp;
            end
            psfc=newpsfc;

            clear qh;clear ql;clear hourlymse;

            mr=calcmrfromvpandpsfc(calcvpfromTd(td),psfc)./1000;
            omega=calcqfromTd_dynamicP(td,psfc); %convert to unitless specific humidity
            cp=(1005.7.*(1-mr))+(mr.*(1-mr).*1850);clear mr;
            qh=cp.*t;clear cp;
            lv=1918.46.*((t./(t-33.91)).^2); %J/kg; Henderson-Sellers 1984
            ql=lv.*omega;clear lv; %J/kg
            hourlymse=(qh+ql)./1000;
            
            maxdailymse(i,:,:)=squeeze(max(hourlymse));  
        end
        disp('At line 2300, done with part I for timelineoffactors');disp(clock);
        
        end
        
        elevera5_180=[elevera5(:,721:1440) elevera5(:,1:720)]; %centered on 180
        
        
        %If day is a member of topdays for a particular gridpoint,calculation continues 
        disp('Starting DOY calculation');disp(clock);
        for doy=3:363 %to avoid end-of-year problems
            
            monofdoy=DOYtoMonth(doy,year);domofdoy=DOYtoDOM(doy,year);
            if monofdoy<=9;mzero='0';else;mzero='';end
            if monofdoy+1<=9;mzeroplus='0';else;mzeroplus='';end
            if monofdoy-1<=9;mzerominus='0';else;mzerominus='';end
            
            if monofdoy~=3 && monofdoy~=4 && ~(monofdoy==2 && domofdoy>=27) && ~(monofdoy==5 && domofdoy<=2) %can't/don't have data in these ranges
                if (monofdoy==1 || monofdoy==5) && domofdoy==1 %first day of (a) first month whose data we have
                    file=ncgeodataset(strcat('/Volumes/',modellevdataloc,'/tendrad_',num2str(year),mzero,num2str(monofdoy),'.grib'));
                    lwtemp=file{'mttlwr'};swtemp=file{'mttswr'};echo off;
                    file=ncgeodataset(strcat('/Volumes/',modellevdataloc,'/uvw_',num2str(year),mzero,num2str(monofdoy),'.grib'));
                    utemp=file{'u'};vtemp=file{'v'};wtemp=file{'w'};echo off;clear file;
                elseif domofdoy==1 %first day of another month whose data we have
                    file=ncgeodataset(strcat('/Volumes/',modellevdataloc,'/tendrad_',num2str(year),mzero,num2str(monofdoy),'.grib'));
                    lwtemp=file{'mttlwr'};swtemp=file{'mttswr'};echo off;
                    file=ncgeodataset(strcat('/Volumes/',modellevdataloc,'/tendrad_',num2str(year),mzerominus,num2str(monofdoy-1),'.grib'));
                    lwtempprevmon=file{'mttlwr'};swtempprevmon=file{'mttswr'};echo off;
                    file=ncgeodataset(strcat('/Volumes/',modellevdataloc,'/uvw_',num2str(year),mzero,num2str(monofdoy),'.grib'));
                    utemp=file{'u'};vtemp=file{'v'};wtemp=file{'w'};echo off;
                    file=ncgeodataset(strcat('/Volumes/',modellevdataloc,'/uvw_',num2str(year),mzerominus,num2str(monofdoy-1),'.grib'));
                    utempprevmon=file{'u'};vtempprevmon=file{'v'};wtempprevmon=file{'w'};echo off;clear file;
                elseif (monofdoy==1 || monofdoy==5 || monofdoy==7 || monofdoy==8 || monofdoy==10) && domofdoy==30 %nearing the end of a month, for which we have data for the following month also
                    file=ncgeodataset(strcat('/Volumes/',modellevdataloc,'/tendrad_',num2str(year),mzeroplus,num2str(monofdoy+1),'.grib'));
                    lwtempnextmon=file{'mttlwr'};swtempnextmon=file{'mttswr'};echo off;
                    file=ncgeodataset(strcat('/Volumes/',modellevdataloc,'/uvw_',num2str(year),mzeroplus,num2str(monofdoy+1),'.grib'));
                    utempnextmon=file{'u'};vtempnextmon=file{'v'};wtempnextmon=file{'w'};echo off;clear file;
                elseif (monofdoy==6 || monofdoy==9 || monofdoy==11) && domofdoy==29 %nearing the end of a month, for which we have data for the following month also
                    file=ncgeodataset(strcat('/Volumes/',modellevdataloc,'/tendrad_',num2str(year),mzeroplus,num2str(monofdoy+1),'.grib'));
                    lwtempnextmon=file{'mttlwr'};swtempnextmon=file{'mttswr'};echo off;
                    file=ncgeodataset(strcat('/Volumes/',modellevdataloc,'/uvw_',num2str(year),mzeroplus,num2str(monofdoy+1),'.grib'));
                    utempnextmon=file{'u'};vtempnextmon=file{'v'};wtempnextmon=file{'w'};echo off;clear file;
                elseif (monofdoy==2 && domofdoy==27) %nearing the end of a month, for which we have data for the following month also
                    file=ncgeodataset(strcat('/Volumes/',modellevdataloc,'/tendrad_',num2str(year),mzeroplus,num2str(monofdoy+1),'.grib'));
                    lwtempnextmon=file{'mttlwr'};swtempnextmon=file{'mttswr'};echo off;
                    file=ncgeodataset(strcat('/Volumes/',modellevdataloc,'/uvw_',num2str(year),mzeroplus,num2str(monofdoy+1),'.grib'));
                    utempnextmon=file{'u'};vtempnextmon=file{'v'};wtempnextmon=file{'w'};echo off;clear file;
                elseif (monofdoy==1 && domofdoy==3) || (monofdoy==5 && domofdoy==3) %Jan 3rd or May 3rd
                    file=ncgeodataset(strcat('/Volumes/',modellevdataloc,'/tendrad_',num2str(year),mzero,num2str(monofdoy),'.grib'));
                    lwtemp=file{'mttlwr'};swtemp=file{'mttswr'};echo off;
                    file=ncgeodataset(strcat('/Volumes/',modellevdataloc,'/uvw_',num2str(year),mzero,num2str(monofdoy),'.grib'));
                    utemp=file{'u'};vtemp=file{'v'};wtemp=file{'w'};echo off;clear file;
                    if monofdoy==5 && domofdoy==2
                        file=ncgeodataset(strcat('/Volumes/',modellevdataloc,'/tendrad_',num2str(year),mzerominus,num2str(monofdoy-1),'.grib'));
                        lwtempprevmon=file{'mttlwr'};swtempprevmon=file{'mttswr'};echo off;
                        file=ncgeodataset(strcat('/Volumes/',modellevdataloc,'/uvw_',num2str(year),mzerominus,num2str(monofdoy-1),'.grib'));
                        utempprevmon=file{'u'};vtempprevmon=file{'v'};wtempprevmon=file{'w'};echo off;clear file;
                    end
                end
            
                startdays_10thsofyr=[1;38;74;111;147;184;220;257;293;330];stopdays_tenperiods=[37;73;110;146;183;219;256;292;329;365];
                continueon=0;
                for miniloop=1:10
                    if doy>=startdays_10thsofyr(miniloop)+2 && doy<=stopdays_tenperiods(miniloop)-2;continueon=1;end
                end
                
                if continueon==1
                    %Retrieve data at the start of a segment of days
                    for miniloop=1:10
                        if doy==startdays_10thsofyr(miniloop)+2
                            firstindex=startdays_10thsofyr(miniloop)*8-7;lastindex=stopdays_tenperiods(miniloop)*8;
                        end
                    end
                    
                    thisdayisastartday=0;
                    for miniloop=1:10
                        if doy==startdays_10thsofyr(miniloop)+2;thisdayisastartday=1;end
                    end
                    
                    if thisdayisastartday==1
                        %as necessary, shift columns so arrays are centered on 0
                        t=double(ttemp.data(firstindex:lastindex,beginrow:endrow,:));t=circshift(t,[0 0 721]);
                        td=double(tdtemp.data(firstindex:lastindex,beginrow:endrow,:))-273.15;td=circshift(td,[0 0 721]);
                        psfc=squeeze(double(psfctemp.data(firstindex:lastindex,beginrow:endrow,:))); %already centered on 0
                        clear qh;clear ql;clear hourlymse;

                        pblhdata=double(pblhtemp.data(firstindex:lastindex,beginrow:endrow,:));pblhdata=circshift(pblhdata,[0 0 721]);

                        precipdata=double(preciptemp.data(firstindex:lastindex,beginrow:endrow,:));precipdata=circshift(precipdata,[0 0 721]);
                        
                        precipchirpsdata=chirpsprecipdata_year((firstindex+7)/8:lastindex/8,beginrow-160:endrow-160,:); %already centered on 0

                        sfcsensibledata=double(sfcsensibletemp.data(firstindex:lastindex,beginrow:endrow,:));sfcsensibledata=circshift(sfcsensibledata,[0 0 721]);
                        sfclatentdata=double(sfclatenttemp.data(firstindex:lastindex,beginrow:endrow,:));sfclatentdata=circshift(sfclatentdata,[0 0 721]);

                        mr=calcmrfromvpandpsfc(calcvpfromTd(td),psfc)./1000;
                        omega=calcqfromTd_dynamicP(td,psfc);clear psfc; %convert to unitless specific humidity
                        cp=(1005.7.*(1-mr))+(mr.*(1-mr).*1850);clear mr;
                        qh=cp.*t;clear cp;
                        lv=1918.46.*((t./(t-33.91)).^2); %J/kg; Henderson-Sellers 1984
                        ql=lv.*omega;clear lv;clear omega; %J/kg
                        hourlymse=(qh+ql)./1000;
                        
                        t=t(:,:,begincol:endcol);td=td(:,:,begincol:endcol);pblhdata=pblhdata(:,:,begincol:endcol);
                        precipdata=precipdata(:,:,begincol:endcol);precipchirpsdata=precipchirpsdata(:,:,begincol:endcol);
                        sfcsensibledata=sfcsensibledata(:,:,begincol:endcol);sfclatentdata=sfclatentdata(:,:,begincol:endcol);
                        qh=qh(:,:,begincol:endcol);ql=ql(:,:,begincol:endcol);hourlymse=hourlymse(:,:,begincol:endcol);
                    end                


                    %Load lw & sw radiation temperature tendencies
                    %Also load velocities
                    if monofdoy==2 || monofdoy==4 || monofdoy==6 || monofdoy==8 || monofdoy==9 || monofdoy==11 || monofdoy==1
                        lenofprevmon=31;
                    elseif monofdoy==5 || monofdoy==7 || monofdoy==10 || monofdoy==12
                        lenofprevmon=30;
                    else
                        lenofprevmon=28;
                    end
                    if monofdoy==1 || monofdoy==3 || monofdoy==5 || monofdoy==7 || monofdoy==8 || monofdoy==10 || monofdoy==12
                        lenofcurmon=31;
                    elseif monofdoy==4 || monofdoy==6 || monofdoy==9 || monofdoy==11
                        lenofcurmon=30;
                    else
                        lenofcurmon=28;
                    end
                    
                    %In these files, first timestep of year is 9:00 1 Jan, so need to go 3 timesteps earlier to match other files
                    %Levels retrieved are 300mb, 700mb, 100m --> these correspond to 2,4,9 for lw, and 2,4, 10 for uvw
                    %A day runs from e.g. timestep 6 (0:00 2 Jan) to timestep 13 (21:00 2 Jan)
                    adj=3;didsomething=0;
                    if domofdoy<=3 && doy>=4
                        daystouseinprevmon=3-domofdoy+1;startdayinprevmon=lenofprevmon-daystouseinprevmon+1;daystouseincurmon=5-daystouseinprevmon+1;
                        starthour_prevmon=(startdayinprevmon+1)*8-7-adj;stophour_prevmon=lenofprevmon*8;stophour_curmon=daystouseincurmon*8-adj;
                        lwdata1=cat(1,double(lwtempprevmon.data(starthour_prevmon:stophour_prevmon,2,:,:)),double(lwtemp.data(1:stophour_curmon,2,:,:)));
                        lwdata2=cat(1,double(lwtempprevmon.data(starthour_prevmon:stophour_prevmon,4,:,:)),double(lwtemp.data(1:stophour_curmon,4,:,:)));
                        lwdata3=cat(1,double(lwtempprevmon.data(starthour_prevmon:stophour_prevmon,9,:,:)),double(lwtemp.data(1:stophour_curmon,9,:,:)));
                        swdata1=cat(1,double(swtempprevmon.data(starthour_prevmon:stophour_prevmon,2,:,:)),double(swtemp.data(1:stophour_curmon,2,:,:)));
                        swdata2=cat(1,double(swtempprevmon.data(starthour_prevmon:stophour_prevmon,4,:,:)),double(swtemp.data(1:stophour_curmon,4,:,:)));
                        swdata3=cat(1,double(swtempprevmon.data(starthour_prevmon:stophour_prevmon,9,:,:)),double(swtemp.data(1:stophour_curmon,9,:,:)));
                        udata1=cat(1,double(utempprevmon.data(starthour_prevmon:stophour_prevmon,2,:,:)),double(utemp.data(1:stophour_curmon,2,:,:)));
                        udata2=cat(1,double(utempprevmon.data(starthour_prevmon:stophour_prevmon,4,:,:)),double(utemp.data(1:stophour_curmon,4,:,:)));
                        udata3=cat(1,double(utempprevmon.data(starthour_prevmon:stophour_prevmon,10,:,:)),double(utemp.data(1:stophour_curmon,10,:,:)));
                        vdata1=cat(1,double(vtempprevmon.data(starthour_prevmon:stophour_prevmon,2,:,:)),double(vtemp.data(1:stophour_curmon,2,:,:)));
                        vdata2=cat(1,double(vtempprevmon.data(starthour_prevmon:stophour_prevmon,4,:,:)),double(vtemp.data(1:stophour_curmon,4,:,:)));
                        vdata3=cat(1,double(vtempprevmon.data(starthour_prevmon:stophour_prevmon,10,:,:)),double(vtemp.data(1:stophour_curmon,10,:,:)));
                        wdata1=cat(1,double(wtempprevmon.data(starthour_prevmon:stophour_prevmon,2,:,:)),double(wtemp.data(1:stophour_curmon,2,:,:)));
                        wdata2=cat(1,double(wtempprevmon.data(starthour_prevmon:stophour_prevmon,4,:,:)),double(wtemp.data(1:stophour_curmon,4,:,:)));
                        wdata3=cat(1,double(wtempprevmon.data(starthour_prevmon:stophour_prevmon,10,:,:)),double(wtemp.data(1:stophour_curmon,10,:,:)));
                        didsomething=1;
                    elseif domofdoy>=lenofcurmon-1
                        daystouseinnextmon=domofdoy-(lenofcurmon-2);
                        starthour_prevmon=(domofdoy-2)*8-7-adj;stophour_prevmon=lenofcurmon*8;stophour_curmon=daystouseinnextmon*8-adj;
                        lwdata1=cat(1,double(lwtemp.data(starthour_prevmon:stophour_prevmon,2,:,:)),double(lwtempnextmon.data(1:stophour_curmon,2,:,:)));
                        lwdata2=cat(1,double(lwtemp.data(starthour_prevmon:stophour_prevmon,4,:,:)),double(lwtempnextmon.data(1:stophour_curmon,4,:,:)));
                        lwdata3=cat(1,double(lwtemp.data(starthour_prevmon:stophour_prevmon,9,:,:)),double(lwtempnextmon.data(1:stophour_curmon,9,:,:)));
                        swdata1=cat(1,double(swtemp.data(starthour_prevmon:stophour_prevmon,2,:,:)),double(swtempnextmon.data(1:stophour_curmon,2,:,:)));
                        swdata2=cat(1,double(swtemp.data(starthour_prevmon:stophour_prevmon,4,:,:)),double(swtempnextmon.data(1:stophour_curmon,4,:,:)));
                        swdata3=cat(1,double(swtemp.data(starthour_prevmon:stophour_prevmon,9,:,:)),double(swtempnextmon.data(1:stophour_curmon,9,:,:)));
                        udata1=cat(1,double(utemp.data(starthour_prevmon:stophour_prevmon,2,:,:)),double(utempnextmon.data(1:stophour_curmon,2,:,:)));
                        udata2=cat(1,double(utemp.data(starthour_prevmon:stophour_prevmon,4,:,:)),double(utempnextmon.data(1:stophour_curmon,4,:,:)));
                        udata3=cat(1,double(utemp.data(starthour_prevmon:stophour_prevmon,10,:,:)),double(utempnextmon.data(1:stophour_curmon,10,:,:)));
                        vdata1=cat(1,double(vtemp.data(starthour_prevmon:stophour_prevmon,2,:,:)),double(vtempnextmon.data(1:stophour_curmon,2,:,:)));
                        vdata2=cat(1,double(vtemp.data(starthour_prevmon:stophour_prevmon,4,:,:)),double(vtempnextmon.data(1:stophour_curmon,4,:,:)));
                        vdata3=cat(1,double(vtemp.data(starthour_prevmon:stophour_prevmon,10,:,:)),double(vtempnextmon.data(1:stophour_curmon,10,:,:)));
                        wdata1=cat(1,double(wtemp.data(starthour_prevmon:stophour_prevmon,2,:,:)),double(wtempnextmon.data(1:stophour_curmon,2,:,:)));
                        wdata2=cat(1,double(wtemp.data(starthour_prevmon:stophour_prevmon,4,:,:)),double(wtempnextmon.data(1:stophour_curmon,4,:,:)));
                        wdata3=cat(1,double(wtemp.data(starthour_prevmon:stophour_prevmon,10,:,:)),double(wtempnextmon.data(1:stophour_curmon,10,:,:)));
                        didsomething=1;
                    elseif doy>=4
                        starthour=(domofdoy-2)*8-7-adj;stophour=(domofdoy+2)*8-adj;
                        lwdata1=double(lwtemp.data(starthour:stophour,2,:,:));
                        lwdata2=double(lwtemp.data(starthour:stophour,4,:,:));
                        lwdata3=double(lwtemp.data(starthour:stophour,9,:,:));
                        swdata1=double(swtemp.data(starthour:stophour,2,:,:));
                        swdata2=double(swtemp.data(starthour:stophour,4,:,:));
                        swdata3=double(swtemp.data(starthour:stophour,9,:,:));
                        udata1=double(utemp.data(starthour:stophour,2,:,:));
                        udata2=double(utemp.data(starthour:stophour,4,:,:));
                        udata3=double(utemp.data(starthour:stophour,10,:,:));
                        vdata1=double(vtemp.data(starthour:stophour,2,:,:));
                        vdata2=double(vtemp.data(starthour:stophour,4,:,:));
                        vdata3=double(vtemp.data(starthour:stophour,10,:,:));
                        wdata1=double(wtemp.data(starthour:stophour,2,:,:));
                        wdata2=double(wtemp.data(starthour:stophour,4,:,:));
                        wdata3=double(wtemp.data(starthour:stophour,10,:,:));
                        didsomething=1;
                    end
                    
                    if didsomething==1
                        lwdata=cat(2,lwdata1,lwdata2,lwdata3);
                        swdata=cat(2,swdata1,swdata2,swdata3);
                        udata=cat(2,udata1,udata2,udata3);
                        vdata=cat(2,vdata1,vdata2,vdata3);
                        wdata=cat(2,wdata1,wdata2,wdata3);
                    end


                    %Main calculation continues
                    arrsz=size(t,1);nr=endrow-beginrow+1;nc=endcol-begincol+1;

                    datestimelineTEMP=[(doy-2).*ones(8,1);(doy-1).*ones(8,1);doy.*ones(8,1);(doy+1).*ones(8,1);(doy+2).*ones(8,1)];
                    datestimelineTEMP=repmat(datestimelineTEMP,[1 nr nc]);    

                    if doy<=stopdays_tenperiods(1)-2
                        thisdayrelative=doy;
                    elseif doy<=stopdays_tenperiods(2)-2
                        thisdayrelative=doy-(startdays_10thsofyr(2)-1);
                    elseif doy<=stopdays_tenperiods(3)-2
                        thisdayrelative=doy-(startdays_10thsofyr(3)-1);
                    elseif doy<=stopdays_tenperiods(4)-2
                        thisdayrelative=doy-(startdays_10thsofyr(4)-1);
                    elseif doy<=stopdays_tenperiods(5)-2
                        thisdayrelative=doy-(startdays_10thsofyr(5)-1);
                    elseif doy<=stopdays_tenperiods(6)-2
                        thisdayrelative=doy-(startdays_10thsofyr(6)-1);
                    elseif doy<=stopdays_tenperiods(7)-2
                        thisdayrelative=doy-(startdays_10thsofyr(7)-1);
                    elseif doy<=stopdays_tenperiods(8)-2
                        thisdayrelative=doy-(startdays_10thsofyr(8)-1);
                    elseif doy<=stopdays_tenperiods(9)-2
                        thisdayrelative=doy-(startdays_10thsofyr(9)-1);
                    elseif doy<=stopdays_tenperiods(10)-2
                        thisdayrelative=doy-(startdays_10thsofyr(10)-1);
                    end

                    for k=begincol:endcol
                        for j=beginrow:endrow
                            if (j>=actualrowstarts(1) && j<=actualrowstops(1) && k>=actualcolstarts(1)-0.5 && k<=actualcolstops(1)+0.5) || ...
                               (j>=actualrowstarts(2) && j<=actualrowstops(2) && k>=actualcolstarts(2)-0.5 && k<=actualcolstops(2)+0.5) || ...
                               (j>=actualrowstarts(3) && j<=actualrowstops(3) && k>=actualcolstarts(3)-0.5 && k<=actualcolstops(3)+0.5) || ...
                               (j>=actualrowstarts(5) && j<=actualrowstops(5) && k>=actualcolstarts(5)-0.5 && k<=actualcolstops(5)+0.5)
                                if (j>=actualrowstarts(5) && j<=actualrowstops(5) && k>=actualcolstarts(5)-0.5 && k<=actualcolstops(5)+0.5);amazpt=1;else;amazpt=0;end

                                if sum(~isnan(hourlymse(:,j-(beginrow-1),k-(begincol-1))))>0 && sum(hourlymse(:,j-(beginrow-1),k-(begincol-1)))~=0
                                    passedseasoncheck=0;
                                    if amazpt==0
                                        if ismember(doy,topdays(:,j,k));passedseasoncheck=1;end
                                    elseif amazpt==1
                                        if doy>=350 || doy<=95;passedseasoncheck=1;end
                                    end

                                    if passedseasoncheck==1
                                        countsbygridpt(j,k)=countsbygridpt(j,k)+1;
                                        msetimeline{j,k}(countsbygridpt(j,k),1:40)=hourlymse((thisdayrelative-2)*8-7:(thisdayrelative+2)*8,j-(beginrow-1),k-(begincol-1));
                                        qhtimeline{j,k}(countsbygridpt(j,k),1:40)=qh((thisdayrelative-2)*8-7:(thisdayrelative+2)*8,j-(beginrow-1),k-(begincol-1));
                                        qltimeline{j,k}(countsbygridpt(j,k),1:40)=ql((thisdayrelative-2)*8-7:(thisdayrelative+2)*8,j-(beginrow-1),k-(begincol-1));
                                        pblhtimeline{j,k}(countsbygridpt(j,k),:)=pblhdata((thisdayrelative-2)*8-7:(thisdayrelative+2)*8,j-(beginrow-1),k-(begincol-1));

                                        sfcsensibletimeline{j,k}(countsbygridpt(j,k),:)=sfcsensibledata((thisdayrelative-2)*8-7:(thisdayrelative+2)*8,j-(beginrow-1),k-(begincol-1));
                                        sfclatenttimeline{j,k}(countsbygridpt(j,k),:)=sfclatentdata((thisdayrelative-2)*8-7:(thisdayrelative+2)*8,j-(beginrow-1),k-(begincol-1));
                                        
                                        if didsomething==1
                                            lwtimeline{j,k}(countsbygridpt(j,k),:,:)=lwdata(:,:,j-(beginrow-1),k-(begincol-1));
                                            swtimeline{j,k}(countsbygridpt(j,k),:,:)=swdata(:,:,j-(beginrow-1),k-(begincol-1));
                                            utimeline{j,k}(countsbygridpt(j,k),:,:)=udata(:,:,j-(beginrow-1),k-(begincol-1));
                                            vtimeline{j,k}(countsbygridpt(j,k),:,:)=vdata(:,:,j-(beginrow-1),k-(begincol-1));
                                            wtimeline{j,k}(countsbygridpt(j,k),:,:)=wdata(:,:,j-(beginrow-1),k-(begincol-1));
                                        end

                                        precipsum=zeros(40,1);
                                        for ww=1:size(weightsforeach{j,k},1)
                                            if weightsforeach{j,k}(ww,2)>=beginrow && weightsforeach{j,k}(ww,2)<=endrow &&...
                                                    weightsforeach{j,k}(ww,3)>=begincol && weightsforeach{j,k}(ww,3)<=endcol
                                                thisval=precipdata((thisdayrelative-2)*8-7:(thisdayrelative+2)*8,...
                                                    weightsforeach{j,k}(ww,2)-(beginrow-1),weightsforeach{j,k}(ww,3)-(begincol-1));
                                                for ll=1:40
                                                    if ~isnan(thisval);precipsum(ll)=precipsum(ll)+thisval(ll);end
                                                end
                                            end
                                        end
                                        preciptimeline{j,k}(countsbygridpt(j,k),:)=precipsum;
                                        
                                        precipchirpssum=zeros(5,1);
                                        for ww=1:size(weightsforeach{j,k},1)
                                            if weightsforeach{j,k}(ww,2)>=beginrow && weightsforeach{j,k}(ww,2)<=endrow &&...
                                                    weightsforeach{j,k}(ww,3)>=begincol && weightsforeach{j,k}(ww,3)<=endcol
                                                thisval=precipchirpsdata(thisdayrelative-2:thisdayrelative+2,...
                                                    weightsforeach{j,k}(ww,2)-(beginrow-1),weightsforeach{j,k}(ww,3)-(begincol-1));
                                                for ll=1:5
                                                    if ~isnan(thisval);precipchirpssum(ll)=precipchirpssum(ll)+thisval(ll);end
                                                end
                                            end
                                        end
                                        precipchirpstimeline{j,k}(countsbygridpt(j,k),:)=precipchirpssum;

                                        datestimeline{j,k}(countsbygridpt(j,k),:)=datestimelineTEMP(:,j-(beginrow-1),k-(begincol-1));
                                        [~,timeofmax]=max(hourlymse(17:24,j-(beginrow-1),k-(begincol-1)));
                                    end
                                end
                            end
                        end
                    end
                    clear datestimelineTEMP;
                end
            end
            if rem(doy,10)==0;disp(doy);disp(clock);end
        end
        
        clear ttemp;clear tdtemp;clear psfctemp;clear pblhtemp;clear preciptemp;clear precipchirpstemp;
        clear lwtemp;clear lwtempprevmon;clear lwtempnextmon;clear swtemp;clear swtempprevmon;clear swtempnextmon;
        clear utemp;clear utempprevmon;clear utempnextmon;clear vtemp;clear vtempprevmon;clear vtempnextmon;clear wtemp;clear wtempprevmon;clear wtempnextmon;
        clear sfcsensibletemp;clear sfclatenttemp;clear t500temp;clear q500temp;
        
       
        %Option 2: Save data in separate files (necessary because frequent crashing when attempting to save everything)
        save(strcat(processedera5dir,'fulldistnarrays',num2str(year),'_countsbygridpt.mat'),'countsbygridpt');
        save(strcat(processedera5dir,'fulldistnarrays',num2str(year),'_cbygridpttimeline.mat'),'cbygridpttimeline');
        save(strcat(processedera5dir,'fulldistnarrays',num2str(year),'_datestimeline.mat'),'datestimeline');
        save(strcat(processedera5dir,'fulldistnarrays',num2str(year),'_msetimeline.mat'),'msetimeline');
        save(strcat(processedera5dir,'fulldistnarrays',num2str(year),'_qhtimeline.mat'),'qhtimeline');
        save(strcat(processedera5dir,'fulldistnarrays',num2str(year),'_qltimeline.mat'),'qltimeline');
        save(strcat(processedera5dir,'fulldistnarrays',num2str(year),'_pblhtimeline.mat'),'pblhtimeline');
        save(strcat(processedera5dir,'fulldistnarrays',num2str(year),'_preciptimeline.mat'),'preciptimeline');
        save(strcat(processedera5dir,'fulldistnarrays',num2str(year),'_precipchirpstimeline.mat'),'precipchirpstimeline');
        save(strcat(processedera5dir,'fulldistnarrays',num2str(year),'_sfcsensibletimeline.mat'),'sfcsensibletimeline');
        save(strcat(processedera5dir,'fulldistnarrays',num2str(year),'_sfclatenttimeline.mat'),'sfclatenttimeline');
        if year==2017 %more extremes in this year than any other, resulting in a larger file size 
            save(strcat(processedera5dir,'fulldistnarrays',num2str(year),'_lwtimeline.mat'),'lwtimeline','-v7.3');
            save(strcat(processedera5dir,'fulldistnarrays',num2str(year),'_swtimeline.mat'),'swtimeline','-v7.3');
            save(strcat(processedera5dir,'fulldistnarrays',num2str(year),'_utimeline.mat'),'utimeline','-v7.3');
            save(strcat(processedera5dir,'fulldistnarrays',num2str(year),'_vtimeline.mat'),'vtimeline','-v7.3');
            save(strcat(processedera5dir,'fulldistnarrays',num2str(year),'_wtimeline.mat'),'wtimeline','-v7.3');
        else
            save(strcat(processedera5dir,'fulldistnarrays',num2str(year),'_lwtimeline.mat'),'lwtimeline');
            save(strcat(processedera5dir,'fulldistnarrays',num2str(year),'_swtimeline.mat'),'swtimeline');
            save(strcat(processedera5dir,'fulldistnarrays',num2str(year),'_utimeline.mat'),'utimeline');
            save(strcat(processedera5dir,'fulldistnarrays',num2str(year),'_vtimeline.mat'),'vtimeline');
            save(strcat(processedera5dir,'fulldistnarrays',num2str(year),'_wtimeline.mat'),'wtimeline');
        end
    end
    fprintf('At line 2650, done with part III for fulldistns and year %d\n',year);disp(clock);
end





if getfulldistnsofspecificvars==1
    exist topdays;
    if ans==0
        temp=load(strcat(processedera5dir,'climtopmsedays'));topdays=temp.topdays;
    end
    
    if dolwsw==1
        cbypt=zeros(721,1440);lwtimeline=cell(721,1440);swtimeline=cell(721,1440);datestimelinelwsw=cell(721,1440);yeartimelinelwsw=cell(721,1440);
        for year=2014:2017
            for doy=3:363 %to avoid end-of-year problems

                monofdoy=DOYtoMonth(doy,year);domofdoy=DOYtoDOM(doy,year);
                if monofdoy<=9;mzero='0';else;mzero='';end
                if monofdoy+1<=9;mzeroplus='0';else;mzeroplus='';end
                if monofdoy-1<=9;mzerominus='0';else;mzerominus='';end

                if monofdoy~=3 && monofdoy~=4 && ~(monofdoy==2 && domofdoy>=27) && ~(monofdoy==5 && domofdoy<=2) && ~(year==2014 && doy>=119 && doy<=153) %can't/don't have data in these ranges
                    if (monofdoy==1 || monofdoy==5) && domofdoy==1 %first day of a first month whose data we have
                        file=ncgeodataset(strcat('/Volumes/ExternalDriveD/ERA5_modelleveldata/tendrad_',num2str(year),mzero,num2str(monofdoy),'.grib'));
                        lwtemp=file{'mttlwr'};swtemp=file{'mttswr'};echo off;
                     elseif domofdoy==1 %first day of another month whose data we have
                        file=ncgeodataset(strcat('/Volumes/ExternalDriveD/ERA5_modelleveldata/tendrad_',num2str(year),mzero,num2str(monofdoy),'.grib'));
                        lwtemp=file{'mttlwr'};swtemp=file{'mttswr'};echo off;
                        file=ncgeodataset(strcat('/Volumes/ExternalDriveD/ERA5_modelleveldata/tendrad_',num2str(year),mzerominus,num2str(monofdoy-1),'.grib'));
                        lwtempprevmon=file{'mttlwr'};swtempprevmon=file{'mttswr'};echo off;
                    elseif (monofdoy==1 || monofdoy==5 || monofdoy==7 || monofdoy==8 || monofdoy==10) && domofdoy==30 %nearing the end of a month, for which we have data for the following month also
                        file=ncgeodataset(strcat('/Volumes/ExternalDriveD/ERA5_modelleveldata/tendrad_',num2str(year),mzeroplus,num2str(monofdoy+1),'.grib'));
                        lwtempnextmon=file{'mttlwr'};swtempnextmon=file{'mttswr'};echo off;
                    elseif (monofdoy==6 || monofdoy==9 || monofdoy==11) && domofdoy==29 %nearing the end of a month, for which we have data for the following month also
                        file=ncgeodataset(strcat('/Volumes/ExternalDriveD/ERA5_modelleveldata/tendrad_',num2str(year),mzeroplus,num2str(monofdoy+1),'.grib'));
                        lwtempnextmon=file{'mttlwr'};swtempnextmon=file{'mttswr'};echo off;
                    elseif (monofdoy==2 && domofdoy==27) %nearing the end of a month, for which we have data for the following month also
                        file=ncgeodataset(strcat('/Volumes/ExternalDriveD/ERA5_modelleveldata/tendrad_',num2str(year),mzeroplus,num2str(monofdoy+1),'.grib'));
                        lwtempnextmon=file{'mttlwr'};swtempnextmon=file{'mttswr'};echo off;
                    elseif (monofdoy==1 && domofdoy==3) || (monofdoy==5 && domofdoy==3) || (year==2014 && monofdoy==6 && domofdoy==3) %Jan 3rd, May 3rd, or Jun 3rd 2014
                        file=ncgeodataset(strcat('/Volumes/ExternalDriveD/ERA5_modelleveldata/tendrad_',num2str(year),mzero,num2str(monofdoy),'.grib'));
                        lwtemp=file{'mttlwr'};swtemp=file{'mttswr'};echo off;
                        if monofdoy==5 && domofdoy==2
                            file=ncgeodataset(strcat('/Volumes/ExternalDriveD/ERA5_modelleveldata/tendrad_',num2str(year),mzerominus,num2str(monofdoy-1),'.grib'));
                            lwtempprevmon=file{'mttlwr'};swtempprevmon=file{'mttswr'};echo off;
                        end
                    end
                    
                    startdays_10thsofyr=[1;38;74;111;147;184;220;257;293;330];stopdays_tenperiods=[37;73;110;146;183;219;256;292;329;365];
                    continueon=0;
                    for miniloop=1:10
                        if doy>=startdays_10thsofyr(miniloop)+2 && doy<=stopdays_tenperiods(miniloop)-2;continueon=1;end
                    end
                    
                    if continueon==1
                        %Retrieve data at the start of a segment of days
                        for miniloop=1:10
                            if doy==startdays_10thsofyr(miniloop)+2
                                firstindex=startdays_10thsofyr(miniloop)*8-7;lastindex=stopdays_tenperiods(miniloop)*8;
                            end
                        end
                        %2014 needs special treatment because May is missing
                        if year==2014 && doy==154
                            firstindex=startdays_10thsofyr(5)*8-7;lastindex=stopdays_tenperiods(5)*8;
                        end

                        thisdayisastartday=0;
                        for miniloop=1:10
                            if doy==startdays_10thsofyr(miniloop)+2;thisdayisastartday=1;end
                            if year==2014 && doy==154;thisdayisastartday=1;end
                        end               


                        %Load lw & sw radiation temperature tendencies
                        if monofdoy==2 || monofdoy==4 || monofdoy==6 || monofdoy==8 || monofdoy==9 || monofdoy==11 || monofdoy==1
                            lenofprevmon=31;
                        elseif monofdoy==5 || monofdoy==7 || monofdoy==10 || monofdoy==12
                            lenofprevmon=30;
                        else
                            lenofprevmon=28;
                        end
                        if monofdoy==1 || monofdoy==3 || monofdoy==5 || monofdoy==7 || monofdoy==8 || monofdoy==10 || monofdoy==12
                            lenofcurmon=31;
                        elseif monofdoy==4 || monofdoy==6 || monofdoy==9 || monofdoy==11
                            lenofcurmon=30;
                        else
                            lenofcurmon=28;
                        end

                        %In these files, first timestep of year is 9:00 1 Jan, so need to go 3 timesteps earlier to match other files
                        %Levels retrieved are 300mb, 700mb, 100m --> these correspond to 2,4,9 for lw, and 2,4, 10 for uvw
                        %A day runs from e.g. timestep 6 (0:00 2 Jan) to timestep 13 (21:00 2 Jan)
                        adj=3;didsomething=0;
                        if domofdoy<=3 && doy>=4
                            daystouseinprevmon=3-domofdoy+1;startdayinprevmon=lenofprevmon-daystouseinprevmon+1;daystouseincurmon=5-daystouseinprevmon+1;
                            starthour_prevmon=(startdayinprevmon+1)*8-7-adj;stophour_prevmon=lenofprevmon*8;stophour_curmon=daystouseincurmon*8-adj;
                            lwdata1=cat(1,double(lwtempprevmon.data(starthour_prevmon:stophour_prevmon,2,:,:)),double(lwtemp.data(1:stophour_curmon,2,:,:)));
                            lwdata2=cat(1,double(lwtempprevmon.data(starthour_prevmon:stophour_prevmon,4,:,:)),double(lwtemp.data(1:stophour_curmon,4,:,:)));
                            lwdata3=cat(1,double(lwtempprevmon.data(starthour_prevmon:stophour_prevmon,9,:,:)),double(lwtemp.data(1:stophour_curmon,9,:,:)));
                            swdata1=cat(1,double(swtempprevmon.data(starthour_prevmon:stophour_prevmon,2,:,:)),double(swtemp.data(1:stophour_curmon,2,:,:)));
                            swdata2=cat(1,double(swtempprevmon.data(starthour_prevmon:stophour_prevmon,4,:,:)),double(swtemp.data(1:stophour_curmon,4,:,:)));
                            swdata3=cat(1,double(swtempprevmon.data(starthour_prevmon:stophour_prevmon,9,:,:)),double(swtemp.data(1:stophour_curmon,9,:,:)));
                            didsomething=1;
                        elseif domofdoy>=lenofcurmon-1
                            daystouseinnextmon=domofdoy-(lenofcurmon-2);
                            starthour_prevmon=(domofdoy-2)*8-7-adj;stophour_prevmon=lenofcurmon*8;stophour_curmon=daystouseinnextmon*8-adj;
                            lwdata1=cat(1,double(lwtemp.data(starthour_prevmon:stophour_prevmon,2,:,:)),double(lwtempnextmon.data(1:stophour_curmon,2,:,:)));
                            lwdata2=cat(1,double(lwtemp.data(starthour_prevmon:stophour_prevmon,4,:,:)),double(lwtempnextmon.data(1:stophour_curmon,4,:,:)));
                            lwdata3=cat(1,double(lwtemp.data(starthour_prevmon:stophour_prevmon,9,:,:)),double(lwtempnextmon.data(1:stophour_curmon,9,:,:)));
                            swdata1=cat(1,double(swtemp.data(starthour_prevmon:stophour_prevmon,2,:,:)),double(swtempnextmon.data(1:stophour_curmon,2,:,:)));
                            swdata2=cat(1,double(swtemp.data(starthour_prevmon:stophour_prevmon,4,:,:)),double(swtempnextmon.data(1:stophour_curmon,4,:,:)));
                            swdata3=cat(1,double(swtemp.data(starthour_prevmon:stophour_prevmon,9,:,:)),double(swtempnextmon.data(1:stophour_curmon,9,:,:)));
                            didsomething=1;
                        elseif doy>=4
                            starthour=(domofdoy-2)*8-7-adj;stophour=(domofdoy+2)*8-adj;
                            lwdata1=double(lwtemp.data(starthour:stophour,2,:,:));
                            lwdata2=double(lwtemp.data(starthour:stophour,4,:,:));
                            lwdata3=double(lwtemp.data(starthour:stophour,9,:,:));
                            swdata1=double(swtemp.data(starthour:stophour,2,:,:));
                            swdata2=double(swtemp.data(starthour:stophour,4,:,:));
                            swdata3=double(swtemp.data(starthour:stophour,9,:,:));
                            didsomething=1;
                        end

                        if didsomething==1
                            lwdata=cat(2,lwdata1,lwdata2,lwdata3);
                            swdata=cat(2,swdata1,swdata2,swdata3);
                        end


                        %Main calculation continues
                        arrsz=size(t,1);nr=endrow-beginrow+1;nc=endcol-begincol+1;

                        datestimelineTEMP=[(doy-2).*ones(8,1);(doy-1).*ones(8,1);doy.*ones(8,1);(doy+1).*ones(8,1);(doy+2).*ones(8,1)];
                        datestimelineTEMP=repmat(datestimelineTEMP,[1 nr nc]);
                        yeartimelineTEMP=[year.*ones(40,1)];
                        yeartimelineTEMP=repmat(yeartimelineTEMP,[1 nr nc]);    

                        if doy<=stopdays_tenperiods(1)-2
                            thisdayrelative=doy;
                        elseif doy<=stopdays_tenperiods(2)-2
                            thisdayrelative=doy-(startdays_10thsofyr(2)-1);
                        elseif doy<=stopdays_tenperiods(3)-2
                            thisdayrelative=doy-(startdays_10thsofyr(3)-1);
                        elseif doy<=stopdays_tenperiods(4)-2
                            thisdayrelative=doy-(startdays_10thsofyr(4)-1);
                        elseif doy<=stopdays_tenperiods(5)-2
                            thisdayrelative=doy-(startdays_10thsofyr(5)-1);
                        elseif doy<=stopdays_tenperiods(6)-2
                            thisdayrelative=doy-(startdays_10thsofyr(6)-1);
                        elseif doy<=stopdays_tenperiods(7)-2
                            thisdayrelative=doy-(startdays_10thsofyr(7)-1);
                        elseif doy<=stopdays_tenperiods(8)-2
                            thisdayrelative=doy-(startdays_10thsofyr(8)-1);
                        elseif doy<=stopdays_tenperiods(9)-2
                            thisdayrelative=doy-(startdays_10thsofyr(9)-1);
                        elseif doy<=stopdays_tenperiods(10)-2
                            thisdayrelative=doy-(startdays_10thsofyr(10)-1);
                        end

                        %disp('line 10708');disp(clock);
                        %for k=begincol:endcol
                        %    for j=beginrow:endrow
                        for k=1:1440
                            for j=1:721
                                if (j>=actualrowstarts(1) && j<=actualrowstops(1) && k>=actualcolstarts(1)-0.5 && k<=actualcolstops(1)+0.5) || ...
                                   (j>=actualrowstarts(2) && j<=actualrowstops(2) && k>=actualcolstarts(2)-0.5 && k<=actualcolstops(2)+0.5) || ...
                                   (j>=actualrowstarts(3) && j<=actualrowstops(3) && k>=actualcolstarts(3)-0.5 && k<=actualcolstops(3)+0.5) || ...
                                   (j>=actualrowstarts(5) && j<=actualrowstops(5) && k>=actualcolstarts(5)-0.5 && k<=actualcolstops(5)+0.5)
                                    %if sum(~isnan(hourlymse(:,j-(beginrow-1),k-(begincol-1))))>0 && sum(hourlymse(:,j-(beginrow-1),k-(begincol-1)))~=0
                                        if ismember(doy,topdays(:,j,k))
                                            cbypt(j,k)=cbypt(j,k)+1;
                                            if didsomething==1
                                                lwtimeline{j,k}(cbypt(j,k),:,:)=lwdata(:,:,j-(beginrow-1),k-(begincol-1));
                                                swtimeline{j,k}(cbypt(j,k),:,:)=swdata(:,:,j-(beginrow-1),k-(begincol-1));
                                            end

                                            datestimelinelwsw{j,k}(cbypt(j,k),:)=datestimelineTEMP(:,j-(beginrow-1),k-(begincol-1));
                                            yeartimelinelwsw{j,k}(cbypt(j,k),:)=yeartimelineTEMP(:,j-(beginrow-1),k-(begincol-1));
                                        end
                                    %end
                                end
                            end
                        end
                        clear datestimelineTEMP;
                    end
                end
                if rem(doy,20)==0;fprintf('Year is %d and doy is %d for lwsw recalculation\n',year,doy);end
            end
        end
        save(strcat(processedera5dir,'fulldistnarraysLWSWONLY2017.mat'),'lwtimeline','swtimeline','datestimelinelwsw','yeartimelinelwsw','-v7.3');
    end
    
    if douvw==1
        cbypt=zeros(721,1440);utimeline=cell(721,1440);vtimeline=cell(721,1440);wtimeline=cell(721,1440);datestimelineuvw=cell(721,1440);yeartimelineuvw=cell(721,1440);
        for year=2014:2017
            for doy=3:363 %to avoid end-of-year problems

                monofdoy=DOYtoMonth(doy,year);domofdoy=DOYtoDOM(doy,year);
                if monofdoy<=9;mzero='0';else;mzero='';end
                if monofdoy+1<=9;mzeroplus='0';else;mzeroplus='';end
                if monofdoy-1<=9;mzerominus='0';else;mzerominus='';end

                if monofdoy~=3 && monofdoy~=4 && ~(monofdoy==2 && domofdoy>=27) && ~(monofdoy==5 && domofdoy<=2) && ~(year==2014 && doy>=119 && doy<=153) %can't/don't have data in these ranges
                    if (monofdoy==1 || monofdoy==5) && domofdoy==1 %first day of a first month whose data we have
                        file=ncgeodataset(strcat('/Volumes/ExternalDriveD/ERA5_modelleveldata/uvw_',num2str(year),mzero,num2str(monofdoy),'.grib'));
                        utemp=file{'u'};vtemp=file{'v'};wtemp=file{'w'};echo off;clear file;
                     elseif domofdoy==1 %first day of another month whose data we have
                        file=ncgeodataset(strcat('/Volumes/ExternalDriveD/ERA5_modelleveldata/uvw_',num2str(year),mzero,num2str(monofdoy),'.grib'));
                        utemp=file{'u'};vtemp=file{'v'};wtemp=file{'w'};echo off;
                        file=ncgeodataset(strcat('/Volumes/ExternalDriveD/ERA5_modelleveldata/uvw_',num2str(year),mzerominus,num2str(monofdoy-1),'.grib'));
                        utempprevmon=file{'u'};vtempprevmon=file{'v'};wtempprevmon=file{'w'};echo off;clear file;
                    elseif (monofdoy==1 || monofdoy==5 || monofdoy==7 || monofdoy==8 || monofdoy==10) && domofdoy==30 %nearing the end of a month, for which we have data for the following month also
                        file=ncgeodataset(strcat('/Volumes/ExternalDriveD/ERA5_modelleveldata/uvw_',num2str(year),mzeroplus,num2str(monofdoy+1),'.grib'));
                        utempnextmon=file{'u'};vtempnextmon=file{'v'};wtempnextmon=file{'w'};echo off;clear file;
                    elseif (monofdoy==6 || monofdoy==9 || monofdoy==11) && domofdoy==29 %nearing the end of a month, for which we have data for the following month also
                        file=ncgeodataset(strcat('/Volumes/ExternalDriveD/ERA5_modelleveldata/uvw_',num2str(year),mzeroplus,num2str(monofdoy+1),'.grib'));
                        utempnextmon=file{'u'};vtempnextmon=file{'v'};wtempnextmon=file{'w'};echo off;clear file;
                    elseif (monofdoy==2 && domofdoy==27) %nearing the end of a month, for which we have data for the following month also
                        file=ncgeodataset(strcat('/Volumes/ExternalDriveD/ERA5_modelleveldata/uvw_',num2str(year),mzeroplus,num2str(monofdoy+1),'.grib'));
                        utempnextmon=file{'u'};vtempnextmon=file{'v'};wtempnextmon=file{'w'};echo off;clear file;
                    elseif (monofdoy==1 && domofdoy==3) || (monofdoy==5 && domofdoy==3) || (year==2014 && monofdoy==6 && domofdoy==3) %Jan 3rd, May 3rd, or Jun 3rd 2014
                        file=ncgeodataset(strcat('/Volumes/ExternalDriveD/ERA5_modelleveldata/uvw_',num2str(year),mzero,num2str(monofdoy),'.grib'));
                        utemp=file{'u'};vtemp=file{'v'};wtemp=file{'w'};echo off;clear file;
                        if monofdoy==5 && domofdoy==2
                            file=ncgeodataset(strcat('/Volumes/ExternalDriveD/ERA5_modelleveldata/uvw_',num2str(year),mzerominus,num2str(monofdoy-1),'.grib'));
                            utempprevmon=file{'u'};vtempprevmon=file{'v'};wtempprevmon=file{'w'};echo off;clear file;
                        end
                    end
                    
                    startdays_10thsofyr=[1;38;74;111;147;184;220;257;293;330];stopdays_tenperiods=[37;73;110;146;183;219;256;292;329;365];
                    continueon=0;
                    for miniloop=1:10
                        if doy>=startdays_10thsofyr(miniloop)+2 && doy<=stopdays_tenperiods(miniloop)-2;continueon=1;end
                    end
                    
                    if continueon==1
                        %Retrieve data at the start of a segment of days
                        for miniloop=1:10
                            if doy==startdays_10thsofyr(miniloop)+2
                                firstindex=startdays_10thsofyr(miniloop)*8-7;lastindex=stopdays_tenperiods(miniloop)*8;
                            end
                        end
                        %2014 needs special treatment because May is missing
                        if year==2014 && doy==154
                            firstindex=startdays_10thsofyr(5)*8-7;lastindex=stopdays_tenperiods(5)*8;
                        end

                        thisdayisastartday=0;
                        for miniloop=1:10
                            if doy==startdays_10thsofyr(miniloop)+2;thisdayisastartday=1;end
                            if year==2014 && doy==154;thisdayisastartday=1;end
                        end               


                        %Load lw & sw radiation temperature tendencies
                        if monofdoy==2 || monofdoy==4 || monofdoy==6 || monofdoy==8 || monofdoy==9 || monofdoy==11 || monofdoy==1
                            lenofprevmon=31;
                        elseif monofdoy==5 || monofdoy==7 || monofdoy==10 || monofdoy==12
                            lenofprevmon=30;
                        else
                            lenofprevmon=28;
                        end
                        if monofdoy==1 || monofdoy==3 || monofdoy==5 || monofdoy==7 || monofdoy==8 || monofdoy==10 || monofdoy==12
                            lenofcurmon=31;
                        elseif monofdoy==4 || monofdoy==6 || monofdoy==9 || monofdoy==11
                            lenofcurmon=30;
                        else
                            lenofcurmon=28;
                        end

                        %In these files, first timestep of year is 9:00 1 Jan, so need to go 3 timesteps earlier to match other files
                        %Levels retrieved are 300mb, 700mb, 100m --> these correspond to 2,4,9 for lw, and 2,4, 10 for uvw
                        %A day runs from e.g. timestep 6 (0:00 2 Jan) to timestep 13 (21:00 2 Jan)
                        adj=3;didsomething=0;
                        if domofdoy<=3 && doy>=4
                            daystouseinprevmon=3-domofdoy+1;startdayinprevmon=lenofprevmon-daystouseinprevmon+1;daystouseincurmon=5-daystouseinprevmon+1;
                            starthour_prevmon=(startdayinprevmon+1)*8-7-adj;stophour_prevmon=lenofprevmon*8;stophour_curmon=daystouseincurmon*8-adj;
                            udata1=cat(1,double(utempprevmon.data(starthour_prevmon:stophour_prevmon,2,:,:)),double(utemp.data(1:stophour_curmon,2,:,:)));
                            udata2=cat(1,double(utempprevmon.data(starthour_prevmon:stophour_prevmon,4,:,:)),double(utemp.data(1:stophour_curmon,4,:,:)));
                            udata3=cat(1,double(utempprevmon.data(starthour_prevmon:stophour_prevmon,10,:,:)),double(utemp.data(1:stophour_curmon,10,:,:)));
                            vdata1=cat(1,double(vtempprevmon.data(starthour_prevmon:stophour_prevmon,2,:,:)),double(vtemp.data(1:stophour_curmon,2,:,:)));
                            vdata2=cat(1,double(vtempprevmon.data(starthour_prevmon:stophour_prevmon,4,:,:)),double(vtemp.data(1:stophour_curmon,4,:,:)));
                            vdata3=cat(1,double(vtempprevmon.data(starthour_prevmon:stophour_prevmon,10,:,:)),double(vtemp.data(1:stophour_curmon,10,:,:)));
                            wdata1=cat(1,double(wtempprevmon.data(starthour_prevmon:stophour_prevmon,2,:,:)),double(wtemp.data(1:stophour_curmon,2,:,:)));
                            wdata2=cat(1,double(wtempprevmon.data(starthour_prevmon:stophour_prevmon,4,:,:)),double(wtemp.data(1:stophour_curmon,4,:,:)));
                            wdata3=cat(1,double(wtempprevmon.data(starthour_prevmon:stophour_prevmon,10,:,:)),double(wtemp.data(1:stophour_curmon,10,:,:)));
                            didsomething=1;
                        elseif domofdoy>=lenofcurmon-1
                            daystouseinnextmon=domofdoy-(lenofcurmon-2);
                            starthour_prevmon=(domofdoy-2)*8-7-adj;stophour_prevmon=lenofcurmon*8;stophour_curmon=daystouseinnextmon*8-adj;
                            udata1=cat(1,double(utemp.data(starthour_prevmon:stophour_prevmon,2,:,:)),double(utempnextmon.data(1:stophour_curmon,2,:,:)));
                            udata2=cat(1,double(utemp.data(starthour_prevmon:stophour_prevmon,4,:,:)),double(utempnextmon.data(1:stophour_curmon,4,:,:)));
                            udata3=cat(1,double(utemp.data(starthour_prevmon:stophour_prevmon,10,:,:)),double(utempnextmon.data(1:stophour_curmon,10,:,:)));
                            vdata1=cat(1,double(vtemp.data(starthour_prevmon:stophour_prevmon,2,:,:)),double(vtempnextmon.data(1:stophour_curmon,2,:,:)));
                            vdata2=cat(1,double(vtemp.data(starthour_prevmon:stophour_prevmon,4,:,:)),double(vtempnextmon.data(1:stophour_curmon,4,:,:)));
                            vdata3=cat(1,double(vtemp.data(starthour_prevmon:stophour_prevmon,10,:,:)),double(vtempnextmon.data(1:stophour_curmon,10,:,:)));
                            wdata1=cat(1,double(wtemp.data(starthour_prevmon:stophour_prevmon,2,:,:)),double(wtempnextmon.data(1:stophour_curmon,2,:,:)));
                            wdata2=cat(1,double(wtemp.data(starthour_prevmon:stophour_prevmon,4,:,:)),double(wtempnextmon.data(1:stophour_curmon,4,:,:)));
                            wdata3=cat(1,double(wtemp.data(starthour_prevmon:stophour_prevmon,10,:,:)),double(wtempnextmon.data(1:stophour_curmon,10,:,:)));
                            didsomething=1;
                        elseif doy>=4
                            starthour=(domofdoy-2)*8-7-adj;stophour=(domofdoy+2)*8-adj;
                            udata1=double(utemp.data(starthour:stophour,2,:,:));
                            udata2=double(utemp.data(starthour:stophour,4,:,:));
                            udata3=double(utemp.data(starthour:stophour,10,:,:));
                            vdata1=double(vtemp.data(starthour:stophour,2,:,:));
                            vdata2=double(vtemp.data(starthour:stophour,4,:,:));
                            vdata3=double(vtemp.data(starthour:stophour,10,:,:));
                            wdata1=double(wtemp.data(starthour:stophour,2,:,:));
                            wdata2=double(wtemp.data(starthour:stophour,4,:,:));
                            wdata3=double(wtemp.data(starthour:stophour,10,:,:));
                            didsomething=1;
                        end

                        if didsomething==1
                            udata=cat(2,udata1,udata2,udata3);
                            vdata=cat(2,vdata1,vdata2,vdata3);
                            wdata=cat(2,wdata1,wdata2,wdata3);
                        end


                        %Main calculation continues
                        arrsz=size(t,1);nr=endrow-beginrow+1;nc=endcol-begincol+1;

                        datestimelineTEMP=[(doy-2).*ones(8,1);(doy-1).*ones(8,1);doy.*ones(8,1);(doy+1).*ones(8,1);(doy+2).*ones(8,1)];
                        datestimelineTEMP=repmat(datestimelineTEMP,[1 nr nc]);
                        yeartimelineTEMP=[year.*ones(40,1)];
                        yeartimelineTEMP=repmat(yeartimelineTEMP,[1 nr nc]);    

                        if doy<=stopdays_tenperiods(1)-2
                            thisdayrelative=doy;
                        elseif doy<=stopdays_tenperiods(2)-2
                            thisdayrelative=doy-(startdays_10thsofyr(2)-1);
                        elseif doy<=stopdays_tenperiods(3)-2
                            thisdayrelative=doy-(startdays_10thsofyr(3)-1);
                        elseif doy<=stopdays_tenperiods(4)-2
                            thisdayrelative=doy-(startdays_10thsofyr(4)-1);
                        elseif doy<=stopdays_tenperiods(5)-2
                            thisdayrelative=doy-(startdays_10thsofyr(5)-1);
                        elseif doy<=stopdays_tenperiods(6)-2
                            thisdayrelative=doy-(startdays_10thsofyr(6)-1);
                        elseif doy<=stopdays_tenperiods(7)-2
                            thisdayrelative=doy-(startdays_10thsofyr(7)-1);
                        elseif doy<=stopdays_tenperiods(8)-2
                            thisdayrelative=doy-(startdays_10thsofyr(8)-1);
                        elseif doy<=stopdays_tenperiods(9)-2
                            thisdayrelative=doy-(startdays_10thsofyr(9)-1);
                        elseif doy<=stopdays_tenperiods(10)-2
                            thisdayrelative=doy-(startdays_10thsofyr(10)-1);
                        end

                        for k=1:1440
                            for j=1:721
                                if (j>=actualrowstarts(1) && j<=actualrowstops(1) && k>=actualcolstarts(1)-0.5 && k<=actualcolstops(1)+0.5) || ...
                                   (j>=actualrowstarts(2) && j<=actualrowstops(2) && k>=actualcolstarts(2)-0.5 && k<=actualcolstops(2)+0.5) || ...
                                   (j>=actualrowstarts(3) && j<=actualrowstops(3) && k>=actualcolstarts(3)-0.5 && k<=actualcolstops(3)+0.5) || ...
                                   (j>=actualrowstarts(5) && j<=actualrowstops(5) && k>=actualcolstarts(5)-0.5 && k<=actualcolstops(5)+0.5)
                                    if ismember(doy,topdays(:,j,k))
                                        cbypt(j,k)=cbypt(j,k)+1;
                                        if didsomething==1
                                            utimeline{j,k}(cbypt(j,k),:,:)=udata(:,:,j-(beginrow-1),k-(begincol-1));
                                            vtimeline{j,k}(cbypt(j,k),:,:)=vdata(:,:,j-(beginrow-1),k-(begincol-1));
                                            wtimeline{j,k}(cbypt(j,k),:,:)=wdata(:,:,j-(beginrow-1),k-(begincol-1));
                                        end

                                        datestimelineuvw{j,k}(cbypt(j,k),:)=datestimelineTEMP(:,j-(beginrow-1),k-(begincol-1));
                                        yeartimelineuvw{j,k}(cbypt(j,k),:)=yeartimelineTEMP(:,j-(beginrow-1),k-(begincol-1));
                                    end
                                end
                            end
                        end
                        clear datestimelineTEMP;
                    end
                end
                if rem(doy,20)==0;fprintf('Year is %d and doy is %d for uvw recalculation\n',year,doy);end
            end
        end

        save(strcat(processedera5dir,'fulldistnarraysUVWONLY2017.mat'),'utimeline','vtimeline','wtimeline','datestimelineuvw','yeartimelineuvw','-v7.3');
    end
end


if makefinalfigures==1
    finalfigures;
end


clear invalid;

