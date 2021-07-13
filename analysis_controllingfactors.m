

reloadstatsandbasedata=0; %15 min
readsavedailymax=0; %35 hours total
    actualmax=1; %default is 1
determine90warmestdays=0; %8 min per year
determine3warmestmonths=0; %1 min
msecorestats=0; %35 hours total (20 min per year for each of MSE, Qh, and Ql)
    domsepart=1;
    doqhpart=1;
    doqlpart=1;
whereextremesoccur=0;
sstdaybyday=0; %1 hr
q500daybyday=0; %1 hr
pblhdaybyday=0; %1 hr 15 min
globalstats=0; %7.5 hr total (3 hours for MSE, 4.5 hours for Qh+Ql) 
readsst=0; %10 min
makearrwithp999andp99gridptdaysonly=0; %2 hours
makearrwithregtop1percent=0; %25 min
p999pblheights=0; %1 hr 40 min
allpblheights=0; %6 min per year when recalculating; 1 min for figure only
tqvertprofiles=0; %6 hours
    readsoundings=0;
pblheightsforprofileextremedays=0; %2 hours
dateofalltimemax=0; %3.5 hours
timelineaddition_smonly=0; %adds soil moisture
    if timelineaddition_smonly==1
    beginrow=200;endrow=480; %to speed up
    begincol=200;endcol=1360; %again, only when necessary to speed up, and at the cost of comprehensiveness
    end
timelineaddition_preciponly=0; %adds CHIRPS precip data
    if timelineaddition_preciponly==1
    beginrow=200;endrow=480; %to speed up
    begincol=200;endcol=1360; %again, only when necessary to speed up, and at the cost of comprehensiveness
    end
quicksstanoms=0;
quickpressureanoms=0;
quickprecipanoms=0; %45 min total
calcgloballidstrength=0; %about 2.5 hr per month
getfulldistnsoftimelinevariables=0; %3.5 hours per year; have done 2014-18
    if getfulldistnsoftimelinevariables==1
    reloadalldataforyear=1;
    domss=0;
    startyearforfulldistns=2013;stopyearforfulldistns=2017; %note that each year's files are saved separately
    saveallinone=0; %old default was 1, new default is 0
    end
suppfigamazonterrain=0; %INCLUDES SI FIG
getfulldistnsofspecificvars=0; %add sm and chirps precip here (currently as timelineaddition loops)
    dolwsw=0; %20 min per year
    douvw=1; %20 min per year
spedupcorestats_mse=0; %5 hours; replaces domsepart section of msecorestats; REDONE #3
spedupcorestats_qh=0; %5 hours; replaces doqhpart section of msecorestats; REDONE #4
spedupcorestats_ql=0; %5 hours; replaces doqlpart section of msecorestats; REDONE #5
suppfigmsetw=0; %30 sec; INCLUDES SI FIG
makefinalfigures=1;
    mapandlatprofilefigure=0; %figure 1
    bigtimelinefigure=0; %figure 3
        btfprelimcalc=0; %reloading: 3 min per year; then, about 40 min for 6 years
            %currently uses only chirps precip for 2013 and 2017 -- see about line 360 of finalfigures to remove this specification
            stdevorcentile='centile'; %'centile' or 'stdev'
            doasoffset=0; %if 1, lines up all extreme-MSE occurrences at the same column of extrarr
            subregtodo=0; %if doing a subreg at all, which one? (0 means all of them)
            startvar=1;stopvar=15; %defaults are 1 and 15
            firsttimelineyeartodo=2013;lasttimelineyeartodo=2018;
            needsadjusting2017=1; %temporary fix because 2017 files saved around June 1-2 accidentally incorporated a copy of 2013 also
            usingchirpsforpg=1;
            mainlevel=3;secondarylevel=2; %options are 3 (corresponding to 100m), 2 (corresponding to 700mb), or 1 (corresponding to 300mb)
            doserioustroubleshooting=0;
        btffinalcalcandplot=1; %30 sec
            btfapproach=3; %progressively preferable/more modern from 1 to 3
            inclmss=0;
            if btffinalcalcandplot==1;smoothamts=[3;3;3;3];end
    venndiagram=1; %30 min for dolhf, doshf, or douvandw; 3 min for reloadandplotall; creates figure 4 and figure s15
        dosw=0;dolhf=0;doshf=0;douvandw=0;domss1000500=0;domss850300=0;domss700300=0;dossts=0;doqbelowmtns=0;dostabil=0;dopsfc=0;dorh=0;
        reloadandplotall=1;
            makefigs11=1;
            addregoutlinestovenndiagram=1;
            inclneighbors=1; %default is 0
    dotimeseriesactualvalues=0; %figures s1-s4
        subreg1=1;subreg2=5;
        inclttdextension=0;
        if dotimeseriesactualvalues==1;smoothamts=[1;1;1;1];end
    compareregions=0; %figure s16
    sstanomsifigure=0; %figure s10
    
        

trytoejectdrives=0;
    try_d=0;try_c=1;try_z=1;
    
    
    
    

icloud='~/Library/Mobile Documents/com~apple~CloudDocs/';
figloc=strcat(icloud,'General_Academics/Research/Heat_Humidity_Limits/');
savedir=figloc;
echo off;echo off all;
format shortG;
startyear=1979;stopyear=2018;
monthnames={'jan';'feb';'mar';'apr';'may';'jun';'jul';'aug';'sep';'oct';'nov';'dec'};
monstarts=[1;32;60;91;121;152;182;213;244;274;305;335];
monstops=[31;59;90;120;151;181;212;243;273;304;334;365];
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
regsouthbounds=[18.5;21.5;15;21.75;-18.75;13;-21;29;35;27.5;...
    4.25;15.75;-30.75;8.25;11.75;-2.5;-3;10;-22.5];
regnorthbounds=[35;38;27.5;32.75;-2.5;26;-11;45;49;39.5;...
    11.5;22.5;-22.5;18.75;25;4;5.5;18.5;0];
regwestbounds=[43.5;62.5;78;-115;-75;34;119;-98;44.25;103.5;...
    -78.25;-99.25;-60.25;-15.75;102.25;100.25;14.75;44;-61.25];
regeastbounds=[62.25;78;98.75;-104.5;-61.25;44;143;-84.5;60;121.75;...
    -62.5;-87.5;-45.25;-0.75;116.75;118;24.75;53.5;-51.25];
subregsouthbounds=[23;30;20;0;-18.5];subregnorthbounds=[25.5;35;27;0;-13];
subregwestbounds=[52.13;69.63;84.88;0;-68.88];subregeastbounds=[56.13;73.13;89.88;0;-61.88];
%Regional bounds using ERA5 721x1440 grid
actualrowstarts=[221;209;251;230;371;257;405;181;165;203;...
    315;271;451;286;261;345;339;287;361];
actualrowstops=[287;275;301;274;436;309;445;245;221;251;...
    344;298;484;328;314;371;373;321;451];
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

%Next general topic: figure out a way to characterize subtropical &
%tropical high-MSE domains, either using vertical velocity or from the MSE data directly -- 
%the extent to which these truly exist, and if so what they look like, 
%will unlock a treasure trove of other interesting questions


if reloadstatsandbasedata==1
    setup_nctoolbox;
    thisfile=load('/Volumes/ExternalDriveZ/ERA5_Hourly_Data/mseqhqlstats');
    maxmsebypoint=thisfile.maxmsebypoint;p999msebypoint=thisfile.p999msebypoint;p99msebypoint=thisfile.p99msebypoint;p50msebypoint=thisfile.p50msebypoint;
    maxqhbypoint=thisfile.maxqhbypoint;p99qhbypoint=thisfile.p99qhbypoint;p50qhbypoint=thisfile.p50qhbypoint;
    maxqlbypoint=thisfile.maxqlbypoint;p99qlbypoint=thisfile.p99qlbypoint;p50qlbypoint=thisfile.p50qlbypoint;
    p50mseglobal=thisfile.p50mseglobal;p90mseglobal=thisfile.p90mseglobal;p99mseglobal=thisfile.p99mseglobal;
    p995mseglobal=thisfile.p995mseglobal;p999mseglobal=thisfile.p999mseglobal;p9999mseglobal=thisfile.p9999mseglobal;
    %maxmsebygridpt=thisfile.maxmsebygridpt;yearofmaxmsebygridpt=thisfile.yearofmaxmsebygridpt;
    %maxmsebyyearandlatbandERA5=thisfile.maxmsebyyearandlatbandERA5;
    %pct999msebyyearandlatbandERA5=thisfile.pct999msebyyearandlatbandERA5;
    %pct50msebyyearandlatbandERA5=thisfile.pct50msebyyearandlatbandERA5;
    %pct9999msebyyear=thisfile.pct9999msebyyear;pct999msebyyear=thisfile.pct999msebyyear;pct99msebyyear=thisfile.pct99msebyyear;
    %pct50msebyyear=thisfile.pct50msebyyear;
    maxmse_latbandavg=thisfile.maxmse_latbandavg;maxqh_latbandavg=thisfile.maxqh_latbandavg;maxql_latbandavg=thisfile.maxql_latbandavg;
    p999mse_latbandavg=thisfile.p999mse_latbandavg;
    p99mse_latbandavg=thisfile.p99mse_latbandavg;p99qh_latbandavg=thisfile.p99qh_latbandavg;p99ql_latbandavg=thisfile.p99ql_latbandavg;
    %p95mse_latbandavg=thisfile.p95mse_latbandavg;
    %p90mse_latbandavg=thisfile.p90mse_latbandavg;
    p50mse_latbandavg=thisfile.p50mse_latbandavg;
    temp=load('/Volumes/ExternalDriveZ/ERA5_HHLcalcs/mseqhqlstats');
    maxmsebyyear=temp.maxmsebyyear;
    %maxqlbyyear=thisfile.maxqlbyyear;
    %maxqhbyyearERA5=thisfile.maxqhbyyearERA5;
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
    temp=load('/Volumes/ExternalDriveZ/ERA5_Hourly_Data/extrememsearrays');
    codes=temp.codes;
    temp=load('/Volumes/ExternalDriveZ/ERA5_Hourly_Data/vvstats');
    %janp10=temp.janp10;febp10=temp.febp10;marp10=temp.marp10;aprp10=temp.aprp10;mayp10=temp.mayp10;junp10=temp.junp10;
    %julp10=temp.julp10;augp10=temp.augp10;sepp10=temp.sepp10;octp10=temp.octp10;novp10=temp.novp10;decp10=temp.decp10;
    %p50dailyvvcomposite=temp.p50dailyvvcomposite;
    p90dailyvvcomposite=temp.p90dailyvvcomposite;
    p99dailyvvcomposite=temp.p99dailyvvcomposite;
    p999dailyvvcomposite=temp.p999dailyvvcomposite;
    p9999dailyvvcomposite=temp.p9999dailyvvcomposite;
    cp=1005.7; %J K^-1 kg^-1
    lv=2.265.*10.^6; %J/kg
    p50dailyvvcompositebyreg=temp.p50dailyvvcompositebyreg;
    p90dailyvvcompositebyreg=temp.p90dailyvvcompositebyreg;
    p99dailyvvcompositebyreg=temp.p99dailyvvcompositebyreg;
    p999dailyvvcompositebyreg=temp.p999dailyvvcompositebyreg;
    temp=load('/Volumes/ExternalDriveZ/ERA5_Hourly_Data/variabilitystats_global');
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
    temp=load('/Volumes/ExternalDriveZ/ERA5_Hourly_Data/toppctilestats');
    arrwithallp999=temp.arrwithallp999;
    arrwithallp995=temp.arrwithallp995;
    arrwithallp99=temp.arrwithallp99;
    arrwithallp99formidlats=temp.arrwithallp99formidlats;
    loadrest=1;
    if loadrest==1
    temp=load('/Volumes/ExternalDriveZ/ERA5_Hourly_Data/variabilitystats_local');
    assocqh_local=temp.assocqh_local;
    assocqh_mean_local=temp.assocqh_mean_local;
    assocql_local=temp.assocql_local;
    assocql_mean_local=temp.assocql_mean_local;
    dates_local=temp.dates_local;
    msethispct_local=temp.msethispct_local;
    %assocpsfc_localnonextreme=temp.assocpsfc_localnonextreme;
    %assocqh_localnonextreme=temp.assocqh_localnonextreme;
    %assocql_localnonextreme=temp.assocql_localnonextreme;
    %assoct_localnonextreme=temp.assoct_localnonextreme;
    %assoctd_localnonextreme=temp.assoctd_localnonextreme;
    %assoctimeofmax_localnonextreme=temp.assoctimeofmax_localnonextreme;
    %datesnonextreme_local=temp.datesnonextreme_local;
    %msenonextreme_local=temp.msenonextreme_local;
    nonextremecbygridpt=temp.nonextremecbygridpt;
    %assocpsfc_mean_local_nonextreme=temp.assocpsfc_mean_local_nonextreme;
    %assoct_mean_local_nonextreme=temp.assoct_mean_local_nonextreme;
    %assoctd_mean_local_nonextreme=temp.assoctd_mean_local_nonextreme;
    %assoctimeofmax_mean_local_nonextreme=temp.assoctimeofmax_mean_local_nonextreme;
    %assoctimeofmax_mode_local_nonextreme=temp.assoctimeofmax_mode_local_nonextreme;
    temp=load('/Volumes/ExternalDriveZ/ERA5_Hourly_Data/variabilitystats_addendum');
    assoct_local=temp.assoct;
    assoctd_local=temp.assoctd;
    assocpsfc_local=temp.assocpsfc;
    assoctimeofmax_local=temp.assoctimeofmax;
    assoct_mean_local=temp.assoct_mean_local; %for all locations, exceeding their local p99 MSE
    assoctd_mean_local=temp.assoctd_mean_local;
    assocpsfc_mean_local=temp.assocpsfc_mean_local;
    assoctimeofmax_mean_local=temp.assoctimeofmax_mean_local;
    temp=load('/Volumes/ExternalDriveZ/ERA5_HHLcalcs/pblhp999days.mat');
    p999pblharr=temp.p999pblharr;
    saveddateinfo=temp.saveddateinfo;
    temp=load('/Volumes/ExternalDriveZ/ERA5_Hourly_Data/climtopmsedays');
    topdays=temp.topdays;
    temp=load('/Volumes/ExternalDriveZ/ERA5_HHLcalcs/timeofmaxmse');
    finalmaxyears=temp.finalmaxyears;
    finalmaxdoys=temp.finalmaxdoys;
    finalmaxhours=temp.finalmaxhours;
    temp=load('/Volumes/ExternalDriveZ/ERA5_HHLcalcs/qhqlofmaxmse');
    qhattimeofalltimemax=temp.qhattimeofalltimemax;
    qlattimeofalltimemax=temp.qlattimeofalltimemax;
    temp=load(strcat(icloud,'General_Academics/Research/Heat_Humidity_Limits/oisstarrays.mat'));
    globalmaxsstbyyear=temp.globalmaxsstbyyear;
    globaltropmeansstbyyear=temp.globaltropmeansstbyyear;
    temp=load('/Volumes/ExternalDriveZ/ERA5_Hourly_Data/vertprofilearrays');
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
    temp=load('/Volumes/ExternalDriveZ/ERA5_Hourly_Data/pblhforprofiles.mat');
    pblhmeanprofileextremedays=temp.pblhmeanprofileextremedays;
    pblhdistnprofileextremedays=temp.pblhdistnprofileextremedays;
    regsubsetexpalltogether=temp.regsubsetexpalltogether;
    pblhmeanprofileremainderdays=temp.pblhmeanprofileremainderdays;
    pblhdistnprofileremainderdays=temp.pblhdistnprofileremainderdays;
    regsubsetexpalltogether_remainder=temp.regsubsetexpalltogether_remainder;
    temp=load('/Volumes/ExternalDriveZ/ERA5_HHLcalcs/msebudgetoutput.mat');
    iediff_final=temp.iediff_final;
    adv_horiz_final=temp.adv_horiz_final;
    adv_vert_final=temp.adv_vert_final;
    netsolar_final=temp.netsolar_final;
    netthermal_final=temp.netthermal_final;
    sfcsensible_final=temp.sfcsensible_final;
    sfclatent_final=temp.sfclatent_final;
    havedonealready=0;
    if havedonealready==1
    temp=load('/Volumes/ExternalDriveZ/ERA5_HHLcalcs/msebudgetoutputSEP19.mat');
    finalmseallrows=temp.finalmseallrows;
    nonextrfinalmseallrows=temp.nonextrfinalmseallrows;
    initialmseallrows=temp.initialmseallrows;
    nonextrinitialmseallrows=temp.nonextrinitialmseallrows;
    hypothmseallrows=temp.hypothmseallrows;
    nonextrhypothmseallrows=temp.nonextrhypothmseallrows;
    finalieallrows=temp.finalieallrows;
    nonextrfinalieallrows=temp.nonextrfinalieallrows;
    initialieallrows=temp.initialieallrows;
    nonextrinitialieallrows=temp.nonextrinitialieallrows;
    horizadvallrows=temp.horizadvallrows;
    nonextrhorizadvallrows=temp.nonextrhorizadvallrows;
    vertadvallrows=temp.vertadvallrows;
    nonextrvertadvallrows=temp.nonextrvertadvallrows;
    lwallrows=temp.lwallrows;
    nonextrlwallrows=temp.nonextrlwallrows;
    swallrows=temp.swallrows;
    nonextrswallrows=temp.nonextrswallrows;
    sfclatentallrows=temp.sfclatentallrows;
    nonextrsfclatentallrows=temp.nonextrsfclatentallrows;
    sfcsensibleallrows=temp.sfcsensibleallrows;
    nonextrsfcsensibleallrows=temp.nonextrsfcsensibleallrows;
    finalpreslistallrows=temp.finalpreslistallrows;
    nonextrfinalpreslistallrows=temp.nonextrfinalpreslistallrows;
    finalpreslistallrowsalltimesteps=temp.finalpreslistallrowsalltimesteps;
    nonextrfinalpreslistallrowsalltimesteps=temp.nonextrfinalpreslistallrowsalltimesteps;
    finaltallrows=temp.finaltallrows;
    nonextrfinaltallrows=temp.nonextrfinaltallrows;
    finalqallrows=temp.finalqallrows;
    nonextrfinalqallrows=temp.nonextrfinalqallrows;
    initialtallrows=temp.initialtallrows;
    nonextrinitialtallrows=temp.nonextrinitialtallrows;
    initialqallrows=temp.initialqallrows;
    nonextrinitialqallrows=temp.nonextrinitialqallrows;
    finalmse12hrbeforeallrows=temp.finalmse12hrbeforeallrows;
    nonextrfinalmse12hrbeforeallrows=temp.nonextrfinalmse12hrbeforeallrows;
    finalt12hrbeforeallrows=temp.finalt12hrbeforeallrows;
    nonextrfinalt12hrbeforeallrows=temp.nonextrfinalt12hrbeforeallrows;
    finalq12hrbeforeallrows=temp.finalq12hrbeforeallrows;
    nonextrfinalq12hrbeforeallrows=temp.nonextrfinalq12hrbeforeallrows;
    finalie12hrbeforeallrows=temp.finalie12hrbeforeallrows;
    nonextrfinalie12hrbeforeallrows=temp.nonextrfinalie12hrbeforeallrows;
    end
    
    temp=load('/Volumes/ExternalDriveZ/ERA5_Hourly_Data/someotherclimostats');
    meanannualrh=temp.meanannualrh;
    dothis=0;
    if dothis==1
    temp=load('/Volumes/ExternalDriveZ/ERA5_HHLcalcs/percentilesofothervariables');
    globalsst_p999_forregcomparisons=temp.globalsst_p999_forregcomparisons;
    globalsst_p99_forregcomparisons=temp.globalsst_p99_forregcomparisons;
    globalsst_p90_forregcomparisons=temp.globalsst_p90_forregcomparisons;
    globalsst_p50_forregcomparisons=temp.globalsst_p50_forregcomparisons;
    globalvv_p999=temp.globalvv_p999;
    globalvv_p99=temp.globalvv_p99;
    globalvv_p90=temp.globalvv_p90;
    globalvv_p50=temp.globalvv_p50;
    globalsst_p999=temp.globalsst_p999;
    globalsst_p99=temp.globalsst_p99;
    globalsst_p90=temp.globalsst_p90;
    globalsst_p50=temp.globalsst_p50;
    globalq500_p999=temp.globalq500_p999;
    globalq500_p99=temp.globalq500_p99;
    globalq500_p90=temp.globalq500_p90;
    globalq500_p50=temp.globalq500_p50;
    globalpblhpct999=temp.globalpblhpct999;
    globalpblhpct99=temp.globalpblhpct99;
    globalpblhpct90=temp.globalpblhpct90;
    globalpblhpct50=temp.globalpblhpct50;
    %sst_forp999mse_byreg=temp.sst_forp999mse_byreg;
    %sst_forp99mse_byreg=temp.sst_forp99mse_byreg;
    %sst_forp90mse_byreg=temp.sst_forp90mse_byreg;
    %sst_forp50mse_byreg=temp.sst_forp50mse_byreg;
    maxdailysstbyreg_forp50mse_final=temp.maxdailysstbyreg_forp50mse_final;
    maxdailysstbyreg_forp90mse_final=temp.maxdailysstbyreg_forp90mse_final;
    maxdailysstbyreg_forp99mse_final=temp.maxdailysstbyreg_forp99mse_final;
    maxdailysstbyreg_forp999mse_final=temp.maxdailysstbyreg_forp999mse_final;
    q500_forp999mse_byreg=temp.q500_forp999mse_byreg;
    q500_forp99mse_byreg=temp.q500_forp99mse_byreg;
    q500_forp90mse_byreg=temp.q500_forp90mse_byreg;
    q500_forp50mse_byreg=temp.q500_forp50mse_byreg;
    msep999_regionalmeans=temp.msep999_regionalmeans;
    msep99_regionalmeans=temp.msep99_regionalmeans;
    msep90_regionalmeans=temp.msep90_regionalmeans;
    msep50_regionalmeans=temp.msep50_regionalmeans;
    msep999_regionalmaxes=temp.msep999_regionalmaxes;
    msep99_regionalmaxes=temp.msep99_regionalmaxes;
    msep90_regionalmaxes=temp.msep90_regionalmaxes;
    msep50_regionalmaxes=temp.msep50_regionalmaxes;
    pblh_forp999mse_byreg=temp.pblh_forp999mse_byreg;
    pblh_forp99mse_byreg=temp.pblh_forp99mse_byreg;
    pblh_forp90mse_byreg=temp.pblh_forp90mse_byreg;
    pblh_forp50mse_byreg=temp.pblh_forp50mse_byreg;
    end
    end
       
    dothis=0;
    if dothis==1
    temp=load(strcat('/Volumes/ExternalDriveZ/ERA5_HHLcalcs/timetracesarraysforyear',num2str(year),'.mat'));
    datestimelineFINAL=temp.datestimelineFINAL;
    msetimelineFINAL=temp.msetimelineFINAL;
    qhtimelineFINAL=temp.qhtimelineFINAL;
    qltimelineFINAL=temp.qltimelineFINAL;
    pblhtimelineFINAL=temp.pblhtimelineFINAL;
    preciptimelineFINAL=temp.preciptimelineFINAL;
    msstimelineFINAL=temp.msstimelineFINAL;
    sfcsensibletimelineFINAL=temp.sfcsensibletimelineFINAL;
    sfclatenttimelineFINAL=temp.sfclatenttimelineFINAL;
    lwtimelineFINAL=temp.lwtimelineFINAL;
    swtimelineFINAL=temp.swtimelineFINAL;
    utimelineFINAL=temp.utimelineFINAL;
    vtimelineFINAL=temp.vtimelineFINAL;
    wtimelineFINAL=temp.wtimelineFINAL;
    msetimelinenonextrFINAL=temp.msetimelinenonextrFINAL;
    qhtimelinenonextrFINAL=temp.qhtimelinenonextrFINAL;
    qltimelinenonextrFINAL=temp.qltimelinenonextrFINAL;
    pblhtimelinenonextrFINAL=temp.pblhtimelinenonextrFINAL;
    preciptimelinenonextrFINAL=temp.preciptimelinenonextrFINAL;
    msstimelinenonextrFINAL=temp.msstimelinenonextrFINAL;
    sfcsensibletimelinenonextrFINAL=temp.sfcsensibletimelinenonextrFINAL;
    sfclatenttimelinenonextrFINAL=temp.sfclatenttimelinenonextrFINAL;
    lwtimelinenonextrFINAL=temp.lwtimelinenonextrFINAL;
    swtimelinenonextrFINAL=temp.swtimelinenonextrFINAL;
    utimelinenonextrFINAL=temp.utimelinenonextrFINAL;
    vtimelinenonextrFINAL=temp.vtimelinenonextrFINAL;
    wtimelinenonextrFINAL=temp.wtimelinenonextrFINAL;
    temp=load(strcat('/Volumes/ExternalDriveZ/ERA5_HHLcalcs/timetracesarraysforyearSOILMOISTUREONLY',num2str(year),'.mat'));
    datestimelineFINALsm=temp.datestimelineFINAL;
    smtimelineFINAL=temp.smtimelineFINAL;
    smtimelinenonextrFINAL=temp.smtimelinenonextrFINAL;
    end
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
    %for year=currentfirstyearcalc:currentlastyearcalc
    for year=2019:2020
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
            
            %8 sec
            temptest=0;
            if temptest==1
            dayc=0;clear savedbs;
            for i=istart:8:iend
                [a,b]=max(mse(i-7:i,:,:));
                a=squeeze(a);b=squeeze(b);
                dayc=dayc+1;
                savedas(dayc,:,:)=a;
                savedbs(dayc,:,:)=i-8+b;
            end
            %...
            dailymaxmserows1to100(1:36,:,:)=savedas(:,1:100,:);
            %Create giant array indicating which Qh and Ql data to pull from (10 sec)
            giantarray=zeros(292,721,1440);thisloopstartday=loopstartdays(loop);
            %qhcolin=NaN.*ones(365,721,1440);
            for dayc=1:36
                %for j=1:721
                %    for k=1:1440
                        giantarray(savedbs(dayc,:,:),:,:)=1;
                        %qhcolin(dayc+thisloopstartday-1,:,:)=qh(savedbs(dayc,:,:),:,:);
                        %qlcolin(dayc+thisloopstartday-1,j,k)=ql(savedbs(dayc,:,:),:,:);
                 %   end
                %end
            end
            %10 sec
            %qh_all=NaN.*ones(size(qh,1),size(qh,2),size(qh,3));
            qh_all=qh;
            todo=giantarray==1;qh_all(~todo)=NaN;
            for j=1:721
                for k=1:1440
                    tocollapse=squeeze(qh_all(:,j,k));
                    qh_all_new(:,j,k)=tocollapse(~isnan(tocollapse));
                end
            end
            newqh_all=NaN.*ones(365,721,1440);
            colin=qh_all(~all(isnan(qh_all)));
            end
            

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
        %disp('line 668');return;
        savehere=1;
        if savehere==1
            if actualmax==1
                save(strcat('/Volumes/ExternalDriveZ/ERA5_Hourly_Data/msedailymaxarray',num2str(year)),'dailymaxmserows1to100','dailymaxmserows101to200',...
                    'dailymaxmserows201to300','dailymaxmserows301to400','dailymaxmserows401to500','dailymaxmserows501to600',...
                    'dailymaxmserows601to700','dailymaxmserows701to721');disp('Saved file 1');

                save(strcat('/Volumes/ExternalDriveZ/ERA5_Hourly_Data/qharray',num2str(year)),'qhrows1to100','qhrows101to200',...
                    'qhrows201to300','qhrows301to400','qhrows401to500','qhrows501to600',...
                    'qhrows601to700','qhrows701to721');disp('Saved file 2');

                save(strcat('/Volumes/ExternalDriveZ/ERA5_Hourly_Data/qlarray',num2str(year)),'qlrows1to100','qlrows101to200',...
                    'qlrows201to300','qlrows301to400','qlrows401to500','qlrows501to600',...
                    'qlrows601to700','qlrows701to721');disp('Saved file 3');
            elseif actualmax==0
                save(strcat('/Volumes/ExternalDriveZ/ERA5_Hourly_Data/msedailymaxarray',num2str(year),'MODELCOMP'),...
                    'dailymaxmserows1to100','dailymaxmserows101to200',...
                    'dailymaxmserows201to300','dailymaxmserows301to400','dailymaxmserows401to500','dailymaxmserows501to600',...
                    'dailymaxmserows601to700','dailymaxmserows701to721');

                save(strcat('/Volumes/ExternalDriveZ/ERA5_Hourly_Data/qharray',num2str(year),'MODELCOMP'),'qhrows1to100','qhrows101to200',...
                    'qhrows201to300','qhrows301to400','qhrows401to500','qhrows501to600',...
                    'qhrows601to700','qhrows701to721');

                save(strcat('/Volumes/ExternalDriveZ/ERA5_Hourly_Data/qlarray',num2str(year),'MODELCOMP'),'qlrows1to100','qlrows101to200',...
                    'qlrows201to300','qlrows301to400','qlrows401to500','qlrows501to600',...
                    'qlrows601to700','qlrows701to721');
            end
        else %save temporary files
            save(strcat('/Volumes/ExternalDriveZ/ERA5_Hourly_Data/msedailymaxarrayTEMP',num2str(year)),'dailymaxmserows1to100','dailymaxmserows101to200',...
                'dailymaxmserows201to300','dailymaxmserows301to400','dailymaxmserows401to500','dailymaxmserows501to600',...
                'dailymaxmserows601to700','dailymaxmserows701to721');

            save(strcat('/Volumes/ExternalDriveZ/ERA5_Hourly_Data/qharrayTEMP',num2str(year)),'qhrows1to100','qhrows101to200',...
                'qhrows201to300','qhrows301to400','qhrows401to500','qhrows501to600',...
                'qhrows601to700','qhrows701to721');

            save(strcat('/Volumes/ExternalDriveZ/ERA5_Hourly_Data/qlarrayTEMP',num2str(year)),'qlrows1to100','qlrows101to200',...
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
            datafile=load(strcat('/Volumes/ExternalDriveZ/ERA5_Hourly_Data/msedailymaxarray',num2str(year)));

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
    save('/Volumes/ExternalDriveZ/ERA5_Hourly_Data/climtopmsedays','topdays','-append');
    disp('line 683');disp(clock);
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
    save('/Volumes/ExternalDriveZ/ERA5_Hourly_Data/climtopmsedays','topmonths','secondtopmonths','thirdtopmonths','-append');
end

if msecorestats==1
    cd /Volumes/ExternalDriveZ/ERA5_Hourly_Data;
    exist topdays;if ans==0;datafile=load('/Volumes/ExternalDriveZ/ERA5_Hourly_Data/climtopmsedays');topdays=datafile.topdays;end
    
    rowstems={'rows1to100';'rows101to200';'rows201to300';'rows301to400';'rows401to500';'rows501to600';'rows601to700';'rows701to721'};
    numrows=[100;100;100;100;100;100;100;21];
    
    %Have to do loops four times, each time for 360 columns, to avoid overloading Matlab
    %Slight speed-up: take setofrows two at a time
    if domsepart==1
        maxmsebypoint=NaN.*ones(721,1440);p999msebypoint=NaN.*ones(721,1440);p99msebypoint=NaN.*ones(721,1440);
        p95msebypoint=NaN.*ones(721,1440);p90msebypoint=NaN.*ones(721,1440);p50msebypoint=NaN.*ones(721,1440);
        for setofrows=2:2:size(numrows,1)
            %loop 1
            if setofrows<=7
                %dailymaxmsetheserows_allyears=NaN.*ones(numyearscalc,365,100,360);
                %r1=1;r2=100;
                dailymaxmsetheserows_allyears=NaN.*ones(numyearscalc,365,200,360);
                r1=1;r2=100;r3=101;r4=200;
            else
                %dailymaxmsetheserows_allyears=NaN.*ones(numyearscalc,365,21,360);
                %r1=1;r2=21;
                dailymaxmsetheserows_allyears=NaN.*ones(numyearscalc,365,121,360);
                r1=1;r2=100;r3=101;r4=121;
            end

            for year=currentfirstyearcalc:currentlastyearcalc
                file=load(strcat('/Volumes/ExternalDriveZ/ERA5_Hourly_Data/msedailymaxarray',num2str(year)));
                temp=eval(['file.dailymaxmse' rowstems{setofrows-1} ';']);
                dailymaxmsetheserows_allyears(year-(currentfirstyearcalc-1),:,r1:r2,:)=temp(:,:,1:360);
                temp=eval(['file.dailymaxmse' rowstems{setofrows} ';']);clear file;
                dailymaxmsetheserows_allyears(year-(currentfirstyearcalc-1),:,r3:r4,:)=temp(:,:,1:360);
                clear temp;
            end
            %Max, median, and 99th percentile of MSE over the climatological warmest 90 days
            %for row=1:numrows(setofrows)
            for row=1:r4
                %actualrow=row+(setofrows-1)*100; 
                actualrow=row+(setofrows-2)*100;  
                thesetopdays=squeeze(topdays(:,actualrow,1:360));
                mse_climwarmdaysonly=squeeze(dailymaxmsetheserows_allyears(:,thesetopdays,row,:)); 
                    %result is same as reading indices contained in ROWS of thesetopdays, then in COLS 
                for col=1:360
                    disp('line 910');return;
                    allvalsthiscol=mse_climwarmdaysonly(:,col*90-89:col*90,col);
                    maxmsebypoint(actualrow,col)=nanmax(reshape(allvalsthiscol,[numyearscalc*90 1]));
                    p999msebypoint(actualrow,col)=quantile(reshape(allvalsthiscol,[numyearscalc*90 1]),0.999);
                    p99msebypoint(actualrow,col)=quantile(reshape(allvalsthiscol,[numyearscalc*90 1]),0.99);
                    %p95msebypoint(actualrow,col)=quantile(reshape(allvalsthiscol,[numyearscalc*90 1]),0.95);
                    %p90msebypoint(actualrow,col)=quantile(reshape(allvalsthiscol,[numyearscalc*90 1]),0.90);
                    p50msebypoint(actualrow,col)=quantile(reshape(allvalsthiscol,[numyearscalc*90 1]),0.50);
                end
                %For verification:
                %plot(squeeze(mse_climwarmdaysonly_new(1,1:90,23)));
                    %should be identical to 
                %plot(squeeze(dailymaxmsetheserows_allyears(1,thesetopdays(1:90,1),row,23)))
            end
            clear mse_climwarmdaysonly;clear dailymaxmsetheserows_allyears;
            disp('finished loop 1');

            %loop 2
            if setofrows<=7
                %dailymaxmsetheserows_allyears=NaN.*ones(numyearscalc,365,100,360);
                dailymaxmsetheserows_allyears=NaN.*ones(numyearscalc,365,200,360);
                r1=1;r2=100;r3=101;r4=200;
            else
                %dailymaxmsetheserows_allyears=NaN.*ones(numyearscalc,365,21,360);
                dailymaxmsetheserows_allyears=NaN.*ones(numyearscalc,365,121,360);
                r1=1;r2=100;r3=101;r4=121;
            end

            for year=currentfirstyearcalc:currentlastyearcalc
                file=load(strcat('/Volumes/ExternalDriveZ/ERA5_Hourly_Data/msedailymaxarray',num2str(year)));
                temp=eval(['file.dailymaxmse' rowstems{setofrows-1} ';']);
                dailymaxmsetheserows_allyears(year-(currentfirstyearcalc-1),:,r1:r2,:)=temp(:,:,361:720);
                temp=eval(['file.dailymaxmse' rowstems{setofrows} ';']);clear file;
                dailymaxmsetheserows_allyears(year-(currentfirstyearcalc-1),:,r3:r4,:)=temp(:,:,361:720);
                clear temp;
            end
            %Max, median, and 99th percentile of MSE over the climatological warmest 90 days
            %for row=1:numrows(setofrows)
            for row=1:r4
                %actualrow=row+(setofrows-1)*100;
                actualrow=row+(setofrows-2)*100;
                thesetopdays=squeeze(topdays(:,actualrow,361:720));
                mse_climwarmdaysonly=squeeze(dailymaxmsetheserows_allyears(:,thesetopdays,row,:)); 
                for col=361:720
                    col_alt=col-360;
                    allvalsthiscol=mse_climwarmdaysonly(:,col_alt*90-89:col_alt*90,col_alt);
                    maxmsebypoint(actualrow,col)=nanmax(reshape(allvalsthiscol,[numyearscalc*90 1]));
                    p999msebypoint(actualrow,col)=quantile(reshape(allvalsthiscol,[numyearscalc*90 1]),0.999);
                    p99msebypoint(actualrow,col)=quantile(reshape(allvalsthiscol,[numyearscalc*90 1]),0.99);
                    %p95msebypoint(actualrow,col)=quantile(reshape(allvalsthiscol,[numyearscalc*90 1]),0.95);
                    %p90msebypoint(actualrow,col)=quantile(reshape(allvalsthiscol,[numyearscalc*90 1]),0.90);
                    p50msebypoint(actualrow,col)=quantile(reshape(allvalsthiscol,[numyearscalc*90 1]),0.50);
                end
            end
            clear mse_climwarmdaysonly;clear dailymaxmsetheserows_allyears;
            disp('finished loop 2');

            %loop 3
            if setofrows<=7
                %dailymaxmsetheserows_allyears=NaN.*ones(numyearscalc,365,100,360);
                dailymaxmsetheserows_allyears=NaN.*ones(numyearscalc,365,200,360);
                r1=1;r2=100;r3=101;r4=200;
            else
                %dailymaxmsetheserows_allyears=NaN.*ones(numyearscalc,365,21,360);
                dailymaxmsetheserows_allyears=NaN.*ones(numyearscalc,365,121,360);
                r1=1;r2=100;r3=101;r4=121;
            end

            for year=currentfirstyearcalc:currentlastyearcalc
                file=load(strcat('/Volumes/ExternalDriveZ/ERA5_Hourly_Data/msedailymaxarray',num2str(year)));
                temp=eval(['file.dailymaxmse' rowstems{setofrows-1} ';']);
                dailymaxmsetheserows_allyears(year-(currentfirstyearcalc-1),:,r1:r2,:)=temp(:,:,721:1080);
                temp=eval(['file.dailymaxmse' rowstems{setofrows} ';']);clear file;
                dailymaxmsetheserows_allyears(year-(currentfirstyearcalc-1),:,r3:r4,:)=temp(:,:,721:1080);
                clear temp;
            end
            %Max, median, and 99th percentile of MSE over the climatological warmest 90 days
            %for row=1:numrows(setofrows)
            for row=1:r4
                %actualrow=row+(setofrows-1)*100;
                actualrow=row+(setofrows-2)*100;
                thesetopdays=squeeze(topdays(:,actualrow,721:1080));
                mse_climwarmdaysonly=squeeze(dailymaxmsetheserows_allyears(:,thesetopdays,row,:)); 
                for col=721:1080
                    col_alt=col-720;
                    allvalsthiscol=mse_climwarmdaysonly(:,col_alt*90-89:col_alt*90,col_alt);
                    maxmsebypoint(actualrow,col)=nanmax(reshape(allvalsthiscol,[numyearscalc*90 1]));
                    p999msebypoint(actualrow,col)=quantile(reshape(allvalsthiscol,[numyearscalc*90 1]),0.999);
                    p99msebypoint(actualrow,col)=quantile(reshape(allvalsthiscol,[numyearscalc*90 1]),0.99);
                    %p95msebypoint(actualrow,col)=quantile(reshape(allvalsthiscol,[numyearscalc*90 1]),0.95);
                    %p90msebypoint(actualrow,col)=quantile(reshape(allvalsthiscol,[numyearscalc*90 1]),0.90);
                    p50msebypoint(actualrow,col)=quantile(reshape(allvalsthiscol,[numyearscalc*90 1]),0.50);
                end
            end
            clear mse_climwarmdaysonly;clear dailymaxmsetheserows_allyears;
            disp('finished loop 3');

            %loop 4
            if setofrows<=7
                %dailymaxmsetheserows_allyears=NaN.*ones(numyearscalc,365,100,360);
                dailymaxmsetheserows_allyears=NaN.*ones(numyearscalc,365,200,360);
                r1=1;r2=100;r3=101;r4=200;
            else
                %dailymaxmsetheserows_allyears=NaN.*ones(numyearscalc,365,21,360);
                dailymaxmsetheserows_allyears=NaN.*ones(numyearscalc,365,121,360);
                r1=1;r2=100;r3=101;r4=121;
            end

            for year=currentfirstyearcalc:currentlastyearcalc
                file=load(strcat('/Volumes/ExternalDriveZ/ERA5_Hourly_Data/msedailymaxarray',num2str(year)));
                temp=eval(['file.dailymaxmse' rowstems{setofrows-1} ';']);
                dailymaxmsetheserows_allyears(year-(currentfirstyearcalc-1),:,r1:r2,:)=temp(:,:,1081:1440);
                temp=eval(['file.dailymaxmse' rowstems{setofrows} ';']);clear file;
                dailymaxmsetheserows_allyears(year-(currentfirstyearcalc-1),:,r3:r4,:)=temp(:,:,1081:1440);
                clear temp;
            end
            %Max, median, and 99th percentile of MSE over the climatological warmest 90 days
            %for row=1:numrows(setofrows)
            for row=1:r4
                %actualrow=row+(setofrows-1)*100;
                actualrow=row+(setofrows-2)*100;
                thesetopdays=squeeze(topdays(:,actualrow,1081:1440));
                mse_climwarmdaysonly=squeeze(dailymaxmsetheserows_allyears(:,thesetopdays,row,:)); 
                for col=1081:1440
                    col_alt=col-1080;
                    allvalsthiscol=mse_climwarmdaysonly(:,col_alt*90-89:col_alt*90,col_alt);
                    maxmsebypoint(actualrow,col)=nanmax(reshape(allvalsthiscol,[numyearscalc*90 1]));
                    p999msebypoint(actualrow,col)=quantile(reshape(allvalsthiscol,[numyearscalc*90 1]),0.999);
                    p99msebypoint(actualrow,col)=quantile(reshape(allvalsthiscol,[numyearscalc*90 1]),0.99);
                    %p95msebypoint(actualrow,col)=quantile(reshape(allvalsthiscol,[numyearscalc*90 1]),0.95);
                    %p90msebypoint(actualrow,col)=quantile(reshape(allvalsthiscol,[numyearscalc*90 1]),0.90);
                    p50msebypoint(actualrow,col)=quantile(reshape(allvalsthiscol,[numyearscalc*90 1]),0.50);
                end
            end
            clear mse_climwarmdaysonly;clear dailymaxmsetheserows_allyears;
            disp('finished loop 4');
            fprintf('Row set is %d for MSE\n',setofrows);disp(clock);
        end
        clear temp;
        save('/Volumes/ExternalDriveZ/ERA5_Hourly_Data/mseqhqlstatsMAY2021','maxmsebypoint','p999msebypoint','p99msebypoint','p95msebypoint','p90msebypoint','p50msebypoint','-append');
        disp(clock);
    end
    
    
    %Qh now
    %Have to do loops four times, each time for 360 columns, to avoid overloading Matlab
    if doqhpart==1
        maxqhbypoint=NaN.*ones(721,1440);p999qhbypoint=NaN.*ones(721,1440);p99qhbypoint=NaN.*ones(721,1440);p50qhbypoint=NaN.*ones(721,1440);
        for setofrows=1:size(numrows,1)
            %loop 1
            if setofrows<=7
                qhtheserows_allyears=NaN.*ones(numyearscalc,365,100,360);
            else
                qhtheserows_allyears=NaN.*ones(numyearscalc,365,21,360);
            end

            for year=currentfirstyearcalc:currentlastyearcalc
                temp=load(strcat('/Volumes/ExternalDriveZ/ERA5_Hourly_Data/qharray',num2str(year)));
                temp=eval(['temp.qh' rowstems{setofrows} ';']);
                qhtheserows_allyears(year-(currentfirstyearcalc-1),:,:,:)=temp(:,:,1:360);
                clear temp;
            end
            %Max, median, and 99th percentile of Qh over the climatological warmest 90 days
            for row=1:numrows(setofrows)
                actualrow=row+(setofrows-1)*100;
                thesetopdays=squeeze(topdays(:,actualrow,1:360));
                qh_climwarmdaysonly=squeeze(qhtheserows_allyears(:,thesetopdays,row,:)); 
                for col=1:360
                    allvalsthiscol=qh_climwarmdaysonly(:,col*90-89:col*90,col);
                    maxqhbypoint(actualrow,col)=nanmax(reshape(allvalsthiscol,[numyearscalc*90 1]));
                    p999qhbypoint(actualrow,col)=quantile(reshape(allvalsthiscol,[numyearscalc*90 1]),0.999);
                    p99qhbypoint(actualrow,col)=quantile(reshape(allvalsthiscol,[numyearscalc*90 1]),0.99);
                    p50qhbypoint(actualrow,col)=quantile(reshape(allvalsthiscol,[numyearscalc*90 1]),0.50);
                end
            end
            clear qh_climwarmdaysonly;clear qhtheserows_allyears;

            %loop 2
            if setofrows<=7
                qhtheserows_allyears=NaN.*ones(numyearscalc,365,100,360);
            else
                qhtheserows_allyears=NaN.*ones(numyearscalc,365,21,360);
            end

            for year=currentfirstyearcalc:currentlastyearcalc
                temp=load(strcat('/Volumes/ExternalDriveZ/ERA5_Hourly_Data/qharray',num2str(year)));
                temp=eval(['temp.qh' rowstems{setofrows} ';']);
                qhtheserows_allyears(year-(currentfirstyearcalc-1),:,:,:)=temp(:,:,361:720);
                clear temp;
            end
            %Max, median, and 99th percentile of Qh over the climatological warmest 90 days
            for row=1:numrows(setofrows)
                actualrow=row+(setofrows-1)*100;
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

            %loop 3
            if setofrows<=7
                qhtheserows_allyears=NaN.*ones(numyearscalc,365,100,360);
            else
                qhtheserows_allyears=NaN.*ones(numyearscalc,365,21,360);
            end

            for year=currentfirstyearcalc:currentlastyearcalc
                temp=load(strcat('/Volumes/ExternalDriveZ/ERA5_Hourly_Data/qharray',num2str(year)));
                temp=eval(['temp.qh' rowstems{setofrows} ';']);
                qhtheserows_allyears(year-(currentfirstyearcalc-1),:,:,:)=temp(:,:,721:1080);
                clear temp;
            end
            %Max, median, and 99th percentile of qh over the climatological warmest 90 days
            for row=1:numrows(setofrows)
                actualrow=row+(setofrows-1)*100;
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

            %loop 4
            if setofrows<=7
                qhtheserows_allyears=NaN.*ones(numyearscalc,365,100,360);
            else
                qhtheserows_allyears=NaN.*ones(numyearscalc,365,21,360);
            end

            for year=currentfirstyearcalc:currentlastyearcalc
                temp=load(strcat('/Volumes/ExternalDriveZ/ERA5_Hourly_Data/qharray',num2str(year)));
                temp=eval(['temp.qh' rowstems{setofrows} ';']);
                qhtheserows_allyears(year-(currentfirstyearcalc-1),:,:,:)=temp(:,:,1081:1440);
                clear temp;
            end
            %Max, median, and 99th percentile of qh over the climatological warmest 90 days
            for row=1:numrows(setofrows)
                actualrow=row+(setofrows-1)*100;
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
            fprintf('Row set is %d for Qh\n',setofrows);disp(clock);
        end
        clear temp;
        save('/Volumes/ExternalDriveZ/ERA5_Hourly_Data/mseqhqlstatsMAY2021','maxqhbypoint','p999qhbypoint','p99qhbypoint','p50qhbypoint','-append');
        disp('line 612');disp(clock);
    end
    

    %Ql now
    %Have to do loops four times, each time for 360 columns, to avoid overloading Matlab
    if doqlpart==1
        maxqlbypoint=NaN.*ones(721,1440);p999qlbypoint=NaN.*ones(721,1440);p99qlbypoint=NaN.*ones(721,1440);p50qlbypoint=NaN.*ones(721,1440);
        for setofrows=1:size(numrows,1)
            %loop 1
            if setofrows<=7
                qltheserows_allyears=NaN.*ones(numyearscalc,365,100,360);
            else
                qltheserows_allyears=NaN.*ones(numyearscalc,365,21,360);
            end

            for year=currentfirstyearcalc:currentlastyearcalc
                temp=load(strcat('/Volumes/ExternalDriveZ/ERA5_Hourly_Data/qlarray',num2str(year)));
                temp=eval(['temp.ql' rowstems{setofrows} ';']);
                qltheserows_allyears(year-(currentfirstyearcalc-1),:,:,:)=temp(:,:,1:360);
                clear temp;
            end
            %Max, median, and 99th percentile of ql over the climatological warmest 90 days
            for row=1:numrows(setofrows)
                actualrow=row+(setofrows-1)*100;
                thesetopdays=squeeze(topdays(:,actualrow,1:360));
                ql_climwarmdaysonly=squeeze(qltheserows_allyears(:,thesetopdays,row,:)); 
                for col=1:360
                    allvalsthiscol=ql_climwarmdaysonly(:,col*90-89:col*90,col);
                    maxqlbypoint(actualrow,col)=nanmax(reshape(allvalsthiscol,[numyearscalc*90 1]));
                    p999qlbypoint(actualrow,col)=quantile(reshape(allvalsthiscol,[numyearscalc*90 1]),0.999);
                    p99qlbypoint(actualrow,col)=quantile(reshape(allvalsthiscol,[numyearscalc*90 1]),0.99);
                    p50qlbypoint(actualrow,col)=quantile(reshape(allvalsthiscol,[numyearscalc*90 1]),0.50);
                end
            end
            clear ql_climwarmdaysonly;clear qltheserows_allyears;

            %loop 2
            if setofrows<=7
                qltheserows_allyears=NaN.*ones(numyearscalc,365,100,360);
            else
                qltheserows_allyears=NaN.*ones(numyearscalc,365,21,360);
            end

            for year=currentfirstyearcalc:currentlastyearcalc
                temp=load(strcat('/Volumes/ExternalDriveZ/ERA5_Hourly_Data/qlarray',num2str(year)));
                temp=eval(['temp.ql' rowstems{setofrows} ';']);
                qltheserows_allyears(year-(currentfirstyearcalc-1),:,:,:)=temp(:,:,361:720);
                clear temp;
            end
            %Max, median, and 99th percentile of ql over the climatological warmest 90 days
            for row=1:numrows(setofrows)
                actualrow=row+(setofrows-1)*100;
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

            %loop 3
            if setofrows<=7
                qltheserows_allyears=NaN.*ones(numyearscalc,365,100,360);
            else
                qltheserows_allyears=NaN.*ones(numyearscalc,365,21,360);
            end

            for year=currentfirstyearcalc:currentlastyearcalc
                temp=load(strcat('/Volumes/ExternalDriveZ/ERA5_Hourly_Data/qlarray',num2str(year)));
                temp=eval(['temp.ql' rowstems{setofrows} ';']);
                qltheserows_allyears(year-(currentfirstyearcalc-1),:,:,:)=temp(:,:,721:1080);
                clear temp;
            end
            %Max, median, and 99th percentile of ql over the climatological warmest 90 days
            for row=1:numrows(setofrows)
                actualrow=row+(setofrows-1)*100;
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

            %loop 4
            if setofrows<=7
                qltheserows_allyears=NaN.*ones(numyearscalc,365,100,360);
            else
                qltheserows_allyears=NaN.*ones(numyearscalc,365,21,360);
            end

            for year=currentfirstyearcalc:currentlastyearcalc
                temp=load(strcat('/Volumes/ExternalDriveZ/ERA5_Hourly_Data/qlarray',num2str(year)));
                temp=eval(['temp.ql' rowstems{setofrows} ';']);
                qltheserows_allyears(year-(currentfirstyearcalc-1),:,:,:)=temp(:,:,1081:1440);
                clear temp;
            end
            %Max, median, and 99th percentile of ql over the climatological warmest 90 days
            for row=1:numrows(setofrows)
                actualrow=row+(setofrows-1)*100;
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
            fprintf('Row set is %d for Ql\n',setofrows);disp(clock);
        end
        clear temp;
        save('/Volumes/ExternalDriveZ/ERA5_Hourly_Data/mseqhqlstatsMAY2021','maxqlbypoint','p999qlbypoint','p99qlbypoint','p50qlbypoint','-append');
        disp('line 738');disp(clock);
    end
    
    
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
    if domsepart==1;save('/Volumes/ExternalDriveZ/ERA5_Hourly_Data/mseqhqlstats',...
            'maxmse_latbandavg','p999mse_latbandavg','p99mse_latbandavg','p50mse_latbandavg','-append');end
    if doqhpart==1;save('/Volumes/ExternalDriveZ/ERA5_Hourly_Data/mseqhqlstats','maxqh_latbandavg','p99qh_latbandavg','-append');end
    if doqlpart==1;save('/Volumes/ExternalDriveZ/ERA5_Hourly_Data/mseqhqlstats','maxql_latbandavg','p99ql_latbandavg','-append');end
    
    
    
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
    
    save('/Volumes/ExternalDriveZ/ERA5_Hourly_Data/mseqhqlstats','p50mseglobal','p90mseglobal',...
        'p99mseglobal','p995mseglobal','p999mseglobal','p9999mseglobal','p50qhglobal','p90qhglobal',...
        'p99qhglobal','p995qhglobal','p999qhglobal','p9999qhglobal','p50qlglobal','p90qlglobal',...
        'p99qlglobal','p995qlglobal','p999qlglobal','p9999qlglobal','-append');
end



if whereextremesoccur==1
    exist p50pts;
    if ans==0
        temp=load('/Volumes/ExternalDriveZ/ERA5_Hourly_Data/extrememsearrays');
        p50pts=temp.p50pts;p90pts=temp.p90pts;p99pts=temp.p99pts;p999pts=temp.p999pts;p9999pts=temp.p9999pts;
    end
    
    %Global map of where extremes occur
    p50pts=reshape(p50ptshelper,[vvnumyears 361 1440 12]);p50ptsallmonths=squeeze(nanmax(nanmax(p50pts,[],4),[],1));
    p90pts=reshape(p90ptshelper,[vvnumyears 361 1440 12]);p90ptsallmonths=squeeze(nanmax(nanmax(p90pts,[],4),[],1));
    p99pts=reshape(p99ptshelper,[vvnumyears 361 1440 12]);p99ptsallmonths=squeeze(nanmax(nanmax(p99pts,[],4),[],1));
    p999pts=reshape(p999ptshelper,[vvnumyears 361 1440 12]);p999ptsallmonths=squeeze(nanmax(nanmax(p999pts,[],4),[],1));
    p9999pts=reshape(p9999ptshelper,[vvnumyears 361 1440 12]);p9999ptsallmonths=squeeze(nanmax(nanmax(p9999pts,[],4),[],1));
    save('/Volumes/ExternalDriveZ/ERA5_Hourly_Data/extrememsearrays','p50pts','p90pts','p99pts','p999pts','p9999pts','-append');
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
    save('/Volumes/ExternalDriveZ/ERA5_Hourly_Data/extrememsearrays','codes','-append');
    figure(1);clf;curpart=1;highqualityfiguresetup;%imagescnan(codes);colorbar;
    codes=[codes(:,721:1440) codes(:,1:720)];
    data={era5latarray(180:540,:);era5lonarray(180:540,:);codes};
    datatype='custom';region='world45s45n';
    vararginnew={'underlayvariable';'wet-bulb temp';'contour';0;...
        'underlaycaxismin';1;'underlaycaxismax';5;'overlaynow';0;'datatounderlay';data;'centeredon';0;'conttoplot';'all'};
    plotModelData(data,region,vararginnew,datatype);
    colormap(colormaps('blueyellowred','more','not'));
    figname='percentile_categories';curpart=2;highqualityfiguresetup;
end




%Similar to the above but retrieving the SSTs associated with
    %p99.99, p99.9, p99, and p50 MSE, composited across all such
    %occurrences in regions of interest
if sstdaybyday==1
    
    rowstems={'rows1to100';'rows101to200';'rows201to300';'rows301to400';'rows401to500';'rows501to600';'rows601to700';'rows701to721'};
    numrows=[100;100;100;100;100;100;100;21];
    
    %Set up to pull SSTs from the region or (in certain cases) the area immediately climatologically upwind of it
    rowstartsforssts=actualrowstarts;rowstopsforssts=actualrowstops;
    colstartsforssts=round(actualcolstartsalt);colstopsforssts=round(actualcolstopsalt);
    colstopsforssts(1)=colstopsforssts(1)-5;
    rowstopsforssts(2)=280;colstartsforssts(2)=252;colstopsforssts(2)=colstopsforssts(2)-8;
    colstartsforssts(3)=colstartsforssts(3)+10;colstopsforssts(3)=colstopsforssts(3)-20;
    rowstartsforssts(5)=rowstartsforssts(5)-20;rowstopsforssts(5)=rowstopsforssts(5)-20;
    colstartsforssts(5)=colstartsforssts(5)+20;colstopsforssts(5)=1322;
    
    
    belowp50cbyreg=zeros(5,1);p50cbyreg=zeros(5,1);p90cbyreg=zeros(5,1);p99cbyreg=zeros(5,1);p999cbyreg=zeros(5,1);
    clear belowp50dailysstcompositebyreg;clear p50dailysstcompositebyreg;clear p90dailysstcompositebyreg;clear p99dailysstcompositebyreg;
    clear p999dailysstcompositebyreg;
    
    for year=1993:2018
        %Load daily SST data
        dothis=1;
        if dothis==1
        temp=load('/Volumes/ExternalDriveC/Basics_OISST/gridptdaymean.mat');
        clear newoisstmean;
        oisstmean=temp.oisstmean;
        for dim1=1:size(oisstmean,1)
            temp=squeeze(oisstmean(dim1,:,:));
            flipped=flipud(temp');newoisstmean(dim1,:,:)=flipped; %centered on 180, north at top
        end
        oisstmean=newoisstmean(:,201:480,:);
        
        sstanom=ncread(strcat('/Volumes/ExternalDriveC/NOAA_OISST_Daily_Anoms/sst.day.anom.',num2str(year),'.v2.nc'),'anom');
        clear newsstanom;
        for dim3=1:size(sstanom,3)
            temp=squeeze(sstanom(:,:,dim3));
            flipped=flipud(temp');newsstanom(:,:,dim3)=flipped; %centered on 180, north at top
        end
        sstanom=newsstanom(201:480,:,:);
        sstanom=permute(sstanom,[3 1 2]);sstanom=sstanom(1:365,:,:);
        end
        
        %Load daily MSE data
        msefile=load(strcat('/Volumes/ExternalDriveZ/ERA5_Hourly_Data/msedailymaxarray',num2str(year)));
        msedata1=eval(['msefile.dailymaxmse' rowstems{3} ';']); %rows 201-300
        msedata2=eval(['msefile.dailymaxmse' rowstems{4} ';']); %rows 301-400
        msedata3=eval(['msefile.dailymaxmse' rowstems{5} ';']);msedata3=msedata3(:,1:80,:); %rows 401-480
        msedataall=cat(2,msedata1,msedata2,msedata3);
        clear newmsedataall;
        for dim3=1:size(msedataall,3)
            temp=squeeze(msedataall(:,:,dim3));
            flipped=temp';newmsedataall(:,:,dim3)=flipped; %centered on 180, north at top
        end
        msedataall=permute(newmsedataall,[2 1 3]);
            
        for regtodo=1:5
            if regtodo~=4
            msedata=msedataall(1:365,...
                actualrowstarts(regtodo)-200:actualrowstops(regtodo)-200,round(actualcolstartsalt(regtodo)):round(actualcolstopsalt(regtodo)));
            %msedatareshaped=reshape(msedata,[size(msedata,1)*size(msedata,2)*size(msedata,3) 1]);
            
            %For computing regional percentiles, but this only needed to be done once
            %msedata_allregionalmeans{regtodo}(year-1989,1:365)=squeeze(mean(squeeze(mean(msedata,3,'omitnan')),2,'omitnan'));
            %msedata_allregionalmaxes{regtodo}(year-1989,1:365)=squeeze(max(squeeze(max(msedata,[],3)),[],2));
            %%%
            dothis=1;
            if dothis==1
            sstdata=oisstmean(:,rowstartsforssts(regtodo)-200:rowstopsforssts(regtodo)-200,round(colstartsforssts(regtodo)):round(colstopsforssts(regtodo)))+...
                sstanom(:,rowstartsforssts(regtodo)-200:rowstopsforssts(regtodo)-200,round(colstartsforssts(regtodo)):round(colstopsforssts(regtodo)));
            %sstdatareshaped=reshape(sstdata,[size(sstdata,1)*size(sstdata,2)*size(sstdata,3) 1]);

            %Finally, do the evaluation of SSTs assoc with each MSE percentile in this region
            %Specifically: get regional mean of SSTs, conditioned on days when regional-mean MSE is above its 90th, 99th, etc. percentile
            for doy=1:365
                %thismeanmse=squeeze(mean(squeeze(mean(msedata(doy,:,:),3,'omitnan')),2,'omitnan'));
                thismaxmse=squeeze(max(squeeze(max(msedata(doy,:,:),[],3)),[],2));
                if thismaxmse>=msep999_regionalmaxes(regtodo)
                    p999cbyreg(regtodo)=p999cbyreg(regtodo)+1;
                    maxdailysstbyreg_forp999mse{regtodo}(p999cbyreg(regtodo))=double(max(max(sstdata(doy,:,:))));
                elseif thismaxmse>=msep99_regionalmaxes(regtodo)
                    p99cbyreg(regtodo)=p99cbyreg(regtodo)+1;
                    maxdailysstbyreg_forp99mse{regtodo}(p99cbyreg(regtodo))=double(max(max(sstdata(doy,:,:))));
                elseif thismaxmse>=msep90_regionalmaxes(regtodo)
                    p90cbyreg(regtodo)=p90cbyreg(regtodo)+1;
                    maxdailysstbyreg_forp90mse{regtodo}(p90cbyreg(regtodo))=double(max(max(sstdata(doy,:,:))));
                elseif thismaxmse>=msep50_regionalmaxes(regtodo)
                    p50cbyreg(regtodo)=p50cbyreg(regtodo)+1;
                    maxdailysstbyreg_forp50mse{regtodo}(p50cbyreg(regtodo))=double(max(max(sstdata(doy,:,:))));
                else
                    belowp50cbyreg(regtodo)=belowp50cbyreg(regtodo)+1;
                    maxdailysstbyreg_forbelowp50mse{regtodo}(belowp50cbyreg(regtodo))=double(max(max(sstdata(doy,:,:))));
                end
            end
            end
            dothis=0;
            if dothis==1
            a=sstdatareshaped(msedatareshaped>=p50mseglobal);
                meandailysstbyreg_forp50mse{regtodo}(p50cbyreg(regtodo):p50cbyreg(regtodo)+size(a,1)-1)=a;
                p50cbyreg(regtodo)=p50cbyreg(regtodo)+size(a,1);
            a=sstdatareshaped(msedatareshaped>=p90mseglobal);
                meandailysstbyreg_forp90mse{regtodo}(p90cbyreg(regtodo):p90cbyreg(regtodo)+size(a,1)-1)=a;
                p90cbyreg(regtodo)=p90cbyreg(regtodo)+size(a,1);
            a=sstdatareshaped(msedatareshaped>=p99mseglobal);
                meandailysstbyreg_forp99mse{regtodo}(p99cbyreg(regtodo):p99cbyreg(regtodo)+size(a,1)-1)=a;
                p99cbyreg(regtodo)=p99cbyreg(regtodo)+size(a,1);
            a=sstdatareshaped(msedatareshaped>=p999mseglobal);
                meandailysstbyreg_forp999mse{regtodo}(p999cbyreg(regtodo):p999cbyreg(regtodo)+size(a,1)-1)=a;
                p999cbyreg(regtodo)=p999cbyreg(regtodo)+size(a,1);
            a=sstdatareshaped(msedatareshaped>=p9999mseglobal);
                meandailysstbyreg_forp9999mse{regtodo}(p9999cbyreg(regtodo):p9999cbyreg(regtodo)+size(a,1)-1)=a;
                p9999cbyreg(regtodo)=p9999cbyreg(regtodo)+size(a,1);
            end
            end
        end
        %clear msedata;clear msedatareshaped;clear sstdatareshaped;

        disp('line 1960');disp(year);disp(clock);

        clear msefile;
    end
    return;
    for regtodo=1:5
        %sst_forp50mse_byreg(regtodo)=double(mean(p50dailysstcompositebyreg{regtodo},'omitnan'));
        %sst_forp90mse_byreg(regtodo)=double(mean(p90dailysstcompositebyreg{regtodo},'omitnan'));
        %sst_forp99mse_byreg(regtodo)=double(mean(p99dailysstcompositebyreg{regtodo},'omitnan'));
        %sst_forp999mse_byreg(regtodo)=double(mean(p999dailysstcompositebyreg{regtodo},'omitnan'));
        %sst_forp9999mse_byreg(regtodo)=double(mean(p9999dailysstcompositebyreg{regtodo},'omitnan'));
        maxdailysstbyreg_forp50mse_final(regtodo)=mean(maxdailysstbyreg_forp50mse{regtodo},'omitnan');
        maxdailysstbyreg_forp90mse_final(regtodo)=mean(maxdailysstbyreg_forp90mse{regtodo},'omitnan');
        maxdailysstbyreg_forp99mse_final(regtodo)=mean(maxdailysstbyreg_forp99mse{regtodo},'omitnan');
        maxdailysstbyreg_forp999mse_final(regtodo)=mean(maxdailysstbyreg_forp999mse{regtodo},'omitnan');
        
        %Only needs to be computed once
        %msep999_regionalmeans(regtodo)=quantile(reshape(msedata_allregionalmeans{regtodo},...
        %    [size(msedata_allregionalmeans{regtodo},1)*size(msedata_allregionalmeans{regtodo},2),1]),0.999);
        %msep99_regionalmeans(regtodo)=quantile(reshape(msedata_allregionalmeans{regtodo},...
        %    [size(msedata_allregionalmeans{regtodo},1)*size(msedata_allregionalmeans{regtodo},2),1]),0.99);
        %msep90_regionalmeans(regtodo)=quantile(reshape(msedata_allregionalmeans{regtodo},...
        %    [size(msedata_allregionalmeans{regtodo},1)*size(msedata_allregionalmeans{regtodo},2),1]),0.90);
        %msep50_regionalmeans(regtodo)=quantile(reshape(msedata_allregionalmeans{regtodo},...
        %    [size(msedata_allregionalmeans{regtodo},1)*size(msedata_allregionalmeans{regtodo},2),1]),0.50);
        
        %msep999_regionalmaxes(regtodo)=quantile(reshape(msedata_allregionalmaxes{regtodo},...
        %    [size(msedata_allregionalmaxes{regtodo},1)*size(msedata_allregionalmaxes{regtodo},2),1]),0.999);
        %msep99_regionalmaxes(regtodo)=quantile(reshape(msedata_allregionalmaxes{regtodo},...
        %    [size(msedata_allregionalmaxes{regtodo},1)*size(msedata_allregionalmaxes{regtodo},2),1]),0.99);
        %msep90_regionalmaxes(regtodo)=quantile(reshape(msedata_allregionalmaxes{regtodo},...
        %    [size(msedata_allregionalmaxes{regtodo},1)*size(msedata_allregionalmaxes{regtodo},2),1]),0.90);
        %msep50_regionalmaxes(regtodo)=quantile(reshape(msedata_allregionalmaxes{regtodo},...
        %    [size(msedata_allregionalmaxes{regtodo},1)*size(msedata_allregionalmaxes{regtodo},2),1]),0.50);
    end
    
    save('/Volumes/ExternalDriveZ/ERA5_HHLcalcs/percentilesofothervariables','maxdailysstbyreg_forp50mse_final','maxdailysstbyreg_forp90mse_final',...
        'maxdailysstbyreg_forp99mse_final','maxdailysstbyreg_forp999mse_final','msep999_regionalmaxes','msep99_regionalmaxes',...
        'msep90_regionalmaxes','msep50_regionalmaxes','-append');
end



%Similar to the above but retrieving the 500-mb specific humidities associated with
    %p99.99, p99.9, p99, and p50 MSE, composited across all such
    %occurrences in regions of interest
if q500daybyday==1
    rowstems={'rows1to100';'rows101to200';'rows201to300';'rows301to400';'rows401to500';'rows501to600';'rows601to700';'rows701to721'};
    numrows=[100;100;100;100;100;100;100;21];
   
    
    p50cbyreg=ones(5,1);p90cbyreg=ones(5,1);p99cbyreg=ones(5,1);p999cbyreg=ones(5,1);p9999cbyreg=ones(5,1);
    clear p50dailyq500compositebyreg;clear p90dailyq500compositebyreg;clear p99dailyq500compositebyreg;
    clear p999dailyq500compositebyreg;clear p9999dailyq500compositebyreg;
    
    for year=2014:2018
        %Load daily q500 data
        file=ncgeodataset(strcat('/Volumes/ExternalDriveD/ERA5_Tq_vertprofiles_only/tq_500_world_',num2str(year),'.grib'));
        qtemp=file{'Specific_humidity_isobaric'};echo off;
            
        %Load daily MSE data
        msefile=load(strcat('/Volumes/ExternalDriveZ/ERA5_Hourly_Data/msedailymaxarray',num2str(year)));
        msedata1=eval(['msefile.dailymaxmse' rowstems{3} ';']); %rows 201-300
        msedata2=eval(['msefile.dailymaxmse' rowstems{4} ';']); %rows 301-400
        msedata3=eval(['msefile.dailymaxmse' rowstems{5} ';']);msedata3=msedata3(:,1:80,:); %rows 401-480
        msedataall=cat(2,msedata1,msedata2,msedata3);
        clear newmsedataall;
        for dim1=1:size(msedataall,1)
            temp=squeeze(msedataall(dim1,:,:));
            flipped=temp';newmsedataall(dim1,:,:)=flipped; %centered on 180, north at top
        end
            
        for regtodo=1:5
            if regtodo~=4
            q500data=squeeze(double(qtemp.data(:,1,actualrowstarts(regtodo):actualrowstops(regtodo),...
                round(actualcolstartsalt(regtodo)):round(actualcolstopsalt(regtodo))))); %500mb
            clear q500datadaily;
            for hour=8:8:2920
                q500datadaily(hour/8,:,:)=mean(q500data(hour-7:hour,:,:));
            end
            
                
            msedata=msedataall(:,...
                actualrowstarts(regtodo)-200:actualrowstops(regtodo)-200,round(actualcolstartsalt(regtodo)):round(actualcolstopsalt(regtodo)));
            msedatareshaped=reshape(msedata,[size(msedata,1)*size(msedata,2)*size(msedata,3) 1]);

            q500datareshaped=reshape(q500datadaily,[size(msedata,1)*size(msedata,2)*size(msedata,3) 1]);
            
            %Finally, do the evaluation of SSTs assoc with each MSE percentile in this region
            a=q500datareshaped(msedatareshaped>=p50mseglobal);
                p50dailyq500compositebyreg{regtodo}(p50cbyreg(regtodo):p50cbyreg(regtodo)+size(a,1)-1)=a;
                p50cbyreg(regtodo)=p50cbyreg(regtodo)+size(a,1);
            a=q500datareshaped(msedatareshaped>=p90mseglobal);
                p90dailyq500compositebyreg{regtodo}(p90cbyreg(regtodo):p90cbyreg(regtodo)+size(a,1)-1)=a;
                p90cbyreg(regtodo)=p90cbyreg(regtodo)+size(a,1);
            a=q500datareshaped(msedatareshaped>=p99mseglobal);
                p99dailyq500compositebyreg{regtodo}(p99cbyreg(regtodo):p99cbyreg(regtodo)+size(a,1)-1)=a;
                p99cbyreg(regtodo)=p99cbyreg(regtodo)+size(a,1);
            a=q500datareshaped(msedatareshaped>=p999mseglobal);
                p999dailyq500compositebyreg{regtodo}(p999cbyreg(regtodo):p999cbyreg(regtodo)+size(a,1)-1)=a;
                p999cbyreg(regtodo)=p999cbyreg(regtodo)+size(a,1);
            a=q500datareshaped(msedatareshaped>=p9999mseglobal);
                p9999dailyq500compositebyreg{regtodo}(p9999cbyreg(regtodo):p9999cbyreg(regtodo)+size(a,1)-1)=a;
                p9999cbyreg(regtodo)=p9999cbyreg(regtodo)+size(a,1);
            end

        end
        clear msedata;clear msedatareshaped;clear qdata;clear q500datareshaped;

        disp('line 2035');disp(year);disp(clock);

        clear msefile;
    end
    for regtodo=1:5
        q500_forp50mse_byreg(regtodo)=double(mean(p50dailyq500compositebyreg{regtodo},'omitnan'));
        q500_forp90mse_byreg(regtodo)=double(mean(p90dailyq500compositebyreg{regtodo},'omitnan'));
        q500_forp99mse_byreg(regtodo)=double(mean(p99dailyq500compositebyreg{regtodo},'omitnan'));
        q500_forp999mse_byreg(regtodo)=double(mean(p999dailyq500compositebyreg{regtodo},'omitnan'));
        q500_forp9999mse_byreg(regtodo)=double(mean(p9999dailyq500compositebyreg{regtodo},'omitnan'));
    end
    save('/Volumes/ExternalDriveZ/ERA5_HHLcalcs/percentilesofothervariables','q500_forp50mse_byreg','q500_forp90mse_byreg',...
        'q500_forp99mse_byreg','q500_forp999mse_byreg','q500_forp9999mse_byreg','-append');
end


%Again similar to the above, but retrieving the PBL heights associated with
    %p99.99, p99.9, p99, and p50 MSE, composited across all such occurrences in regions of interest
if pblhdaybyday==1
    rowstems={'rows1to100';'rows101to200';'rows201to300';'rows301to400';'rows401to500';'rows501to600';'rows601to700';'rows701to721'};
    numrows=[100;100;100;100;100;100;100;21];
    
    p50cbyreg=ones(5,1);p90cbyreg=ones(5,1);p99cbyreg=ones(5,1);p999cbyreg=ones(5,1);p9999cbyreg=ones(5,1);
    clear p50dailypblhcompositebyreg;clear p90dailypblhcompositebyreg;clear p99dailypblhcompositebyreg;
    clear p999dailypblhcompositebyreg;clear p9999dailypblhcompositebyreg;
    
    for year=2005:2018
        %Load daily pblh data
        file=ncgeodataset(strcat('/Volumes/ExternalDriveD/ERA5_Hourly_Data_PBLheight_only/pblh_world_',num2str(year),'.grib'));
        pblhtemp=file{'Boundary_layer_height_surface'};echo off;clear file;
            
        %Load daily MSE data
        msefile=load(strcat('/Volumes/ExternalDriveZ/ERA5_Hourly_Data/msedailymaxarray',num2str(year)));
        msedata1=eval(['msefile.dailymaxmse' rowstems{3} ';']); %rows 201-300
        msedata2=eval(['msefile.dailymaxmse' rowstems{4} ';']); %rows 301-400
        msedata3=eval(['msefile.dailymaxmse' rowstems{5} ';']);msedata3=msedata3(:,1:80,:); %rows 401-480
        msedataall=cat(2,msedata1,msedata2,msedata3);clear msefile;
            
        for regtodo=1:5
            p50dailypblhcompositebyreg{regtodo}=[];p90dailypblhcompositebyreg{regtodo}=[];p99dailypblhcompositebyreg{regtodo}=[];
            p999dailypblhcompositebyreg{regtodo}=[];p999dailypblhcompositebyreg{regtodo}=[];
            if regtodo~=4
            pblhdata=squeeze(double(pblhtemp.data(:,actualrowstarts(regtodo):actualrowstops(regtodo),...
                round(actualcolstartsalt(regtodo)):round(actualcolstopsalt(regtodo)))));
            clear pblhdatadaily;
            for hour=8:8:2920
                pblhdatadaily(hour/8,:,:)=max(pblhdata(hour-7:hour,:,:));
            end
            pblhdata=pblhdatadaily;
                
            msedata=msedataall(:,...
                actualrowstarts(regtodo)-200:actualrowstops(regtodo)-200,round(actualcolstartsalt(regtodo)):round(actualcolstopsalt(regtodo)));
            msedatareshaped=reshape(msedata,[size(msedata,1)*size(msedata,2)*size(msedata,3) 1]);

            pblhdatareshaped=reshape(pblhdata,[size(msedata,1)*size(msedata,2)*size(msedata,3) 1]);
            
            %Finally, do the evaluation of PBL heights assoc with each MSE percentile in this region
            a=pblhdatareshaped(msedatareshaped>=p50mseglobal);
                p50dailypblhcompositebyreg{regtodo}(p50cbyreg(regtodo):p50cbyreg(regtodo)+size(a,1)-1)=a;
                p50cbyreg(regtodo)=p50cbyreg(regtodo)+size(a,1);
            a=pblhdatareshaped(msedatareshaped>=p90mseglobal);
                p90dailypblhcompositebyreg{regtodo}(p90cbyreg(regtodo):p90cbyreg(regtodo)+size(a,1)-1)=a;
                p90cbyreg(regtodo)=p90cbyreg(regtodo)+size(a,1);
            a=pblhdatareshaped(msedatareshaped>=p99mseglobal);
                p99dailypblhcompositebyreg{regtodo}(p99cbyreg(regtodo):p99cbyreg(regtodo)+size(a,1)-1)=a;
                p99cbyreg(regtodo)=p99cbyreg(regtodo)+size(a,1);
            a=pblhdatareshaped(msedatareshaped>=p999mseglobal);
                p999dailypblhcompositebyreg{regtodo}(p999cbyreg(regtodo):p999cbyreg(regtodo)+size(a,1)-1)=a;
                p999cbyreg(regtodo)=p999cbyreg(regtodo)+size(a,1);
            a=pblhdatareshaped(msedatareshaped>=p9999mseglobal);
                p9999dailypblhcompositebyreg{regtodo}(p9999cbyreg(regtodo):p9999cbyreg(regtodo)+size(a,1)-1)=a;
                p9999cbyreg(regtodo)=p9999cbyreg(regtodo)+size(a,1);
            end

        end
        clear msedata;clear msedatareshaped;clear pblhdata;clear pblhdatareshaped;

        disp('line 2232');disp(year);disp(clock);
    end
    for regtodo=1:5
        invalid=p50dailypblhcompositebyreg{regtodo}==0;p50dailypblhcompositebyreg{regtodo}(invalid)=NaN;
        invalid=p90dailypblhcompositebyreg{regtodo}==0;p90dailypblhcompositebyreg{regtodo}(invalid)=NaN;
        invalid=p99dailypblhcompositebyreg{regtodo}==0;p99dailypblhcompositebyreg{regtodo}(invalid)=NaN;
        invalid=p999dailypblhcompositebyreg{regtodo}==0;p999dailypblhcompositebyreg{regtodo}(invalid)=NaN;
        invalid=p9999dailypblhcompositebyreg{regtodo}==0;p9999dailypblhcompositebyreg{regtodo}(invalid)=NaN;
        pblh_forp50mse_byreg(regtodo)=double(mean(p50dailypblhcompositebyreg{regtodo},'omitnan'));
        pblh_forp90mse_byreg(regtodo)=double(mean(p90dailypblhcompositebyreg{regtodo},'omitnan'));
        pblh_forp99mse_byreg(regtodo)=double(mean(p99dailypblhcompositebyreg{regtodo},'omitnan'));
        pblh_forp999mse_byreg(regtodo)=double(mean(p999dailypblhcompositebyreg{regtodo},'omitnan'));
        pblh_forp9999mse_byreg(regtodo)=double(mean(p9999dailypblhcompositebyreg{regtodo},'omitnan'));
    end
    save('/Volumes/ExternalDriveZ/ERA5_HHLcalcs/percentilesofothervariables','pblh_forp50mse_byreg','pblh_forp90mse_byreg',...
        'pblh_forp99mse_byreg','pblh_forp999mse_byreg','pblh_forp9999mse_byreg','-append');
end


%Calculation of global and latitude-band annual stats in reanalysis, for direct comparison against models in modelprojs figure
if globalstats==1
    rowstems={'rows1to100';'rows101to200';'rows201to300';'rows301to400';'rows401to500';'rows501to600';'rows601to700';'rows701to721'};
    numrows=[100;100;100;100;100;100;100;21];
    calcmse=0;calcqhql=1;
    %for year=currentfirstyearcalc:currentlastyearcalc
    for year=2009:2018
        if calcmse==1
            clear dailymaxmseallrows;
            thismsefile=load(strcat('/Volumes/ExternalDriveZ/ERA5_Hourly_Data/msedailymaxarray',num2str(year)));
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

            %By latitude band
            for latband=4:4:720
                maxmsebyyearandlatband(year-currentfirstyearcalc+1,latband/4)=...
                    nanmax(reshape(dailymaxmseallrows(:,latband-3:latband,:),[365*4*1440 1]));
                pct9999msebyyearandlatband(year-currentfirstyearcalc+1,latband/4)=...
                    quantile(reshape(dailymaxmseallrows(:,latband-3:latband,:),[365*4*1440 1]),0.9999);
                pct999msebyyearandlatband(year-currentfirstyearcalc+1,latband/4)=...
                    quantile(reshape(dailymaxmseallrows(:,latband-3:latband,:),[365*4*1440 1]),0.999);
                pct99msebyyearandlatband(year-currentfirstyearcalc+1,latband/4)=...
                    quantile(reshape(dailymaxmseallrows(:,latband-3:latband,:),[365*4*1440 1]),0.99);
                pct90msebyyearandlatband(year-currentfirstyearcalc+1,latband/4)=...
                    quantile(reshape(dailymaxmseallrows(:,latband-3:latband,:),[365*4*1440 1]),0.9);
                pct50msebyyearandlatband(year-currentfirstyearcalc+1,latband/4)=...
                    quantile(reshape(dailymaxmseallrows(:,latband-3:latband,:),[365*4*1440 1]),0.5);
            end
        end
        if calcqhql==1
            clear qhallrows;clear qlallrows;
            qhfile=load(strcat('/Volumes/ExternalDriveZ/ERA5_Hourly_Data/qharray',num2str(year)));
            qlfile=load(strcat('/Volumes/ExternalDriveZ/ERA5_Hourly_Data/qlarray',num2str(year)));
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

            %By latitude band
            dolatband=0;
            if dolatband==1
            for latband=4:4:720
                maxqhbyyearandlatband(year-currentfirstyearcalc+1,latband/4)=...
                    nanmax(reshape(qhallrows(:,latband-3:latband,:),[365*4*1440 1]));
                pct9999qhbyyearandlatband(year-currentfirstyearcalc+1,latband/4)=...
                    quantile(reshape(qhallrows(:,latband-3:latband,:),[365*4*1440 1]),0.9999);
                pct999qhbyyearandlatband(year-currentfirstyearcalc+1,latband/4)=...
                    quantile(reshape(qhallrows(:,latband-3:latband,:),[365*4*1440 1]),0.999);
                pct99qhbyyearandlatband(year-currentfirstyearcalc+1,latband/4)=...
                    quantile(reshape(qhallrows(:,latband-3:latband,:),[365*4*1440 1]),0.99);
                pct90qhbyyearandlatband(year-currentfirstyearcalc+1,latband/4)=...
                    quantile(reshape(qhallrows(:,latband-3:latband,:),[365*4*1440 1]),0.9);
                pct50qhbyyearandlatband(year-currentfirstyearcalc+1,latband/4)=...
                    quantile(reshape(qhallrows(:,latband-3:latband,:),[365*4*1440 1]),0.5);
                maxqlbyyearandlatband(year-currentfirstyearcalc+1,latband/4)=...
                    nanmax(reshape(qlallrows(:,latband-3:latband,:),[365*4*1440 1]));
                pct9999qlbyyearandlatband(year-currentfirstyearcalc+1,latband/4)=...
                    quantile(reshape(qlallrows(:,latband-3:latband,:),[365*4*1440 1]),0.9999);
                pct999qlbyyearandlatband(year-currentfirstyearcalc+1,latband/4)=...
                    quantile(reshape(qlallrows(:,latband-3:latband,:),[365*4*1440 1]),0.999);
                pct99qlbyyearandlatband(year-currentfirstyearcalc+1,latband/4)=...
                    quantile(reshape(qlallrows(:,latband-3:latband,:),[365*4*1440 1]),0.99);
                pct90qlbyyearandlatband(year-currentfirstyearcalc+1,latband/4)=...
                    quantile(reshape(qlallrows(:,latband-3:latband,:),[365*4*1440 1]),0.9);
                pct50qlbyyearandlatband(year-currentfirstyearcalc+1,latband/4)=...
                    quantile(reshape(qlallrows(:,latband-3:latband,:),[365*4*1440 1]),0.5);
            end
            end
        end
        disp(year);disp(clock);
    end
    if calcmse==1
        maxmsebyyearandlatbandERA5=maxmsebyyearandlatband;
        pct9999msebyyearandlatbandERA5=pct9999msebyyearandlatband;
        pct999msebyyearandlatbandERA5=pct999msebyyearandlatband;
        pct99msebyyearandlatbandERA5=pct99msebyyearandlatband;
        pct90msebyyearandlatbandERA5=pct90msebyyearandlatband;
        pct50msebyyearandlatbandERA5=pct50msebyyearandlatband;
        save(strcat('/Volumes/ExternalDriveZ/ERA5_HHLcalcs/mseqhqlstats'),'maxmsebyyear','pct9999msebyyear',...
            'pct999msebyyear','pct99msebyyear','pct90msebyyear','pct50msebyyear',...
            'maxmsebyyearandlatbandERA5','pct9999msebyyearandlatbandERA5','pct999msebyyearandlatbandERA5','pct99msebyyearandlatbandERA5',...
            'pct90msebyyearandlatbandERA5','pct50msebyyearandlatbandERA5','-append');
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
        save(strcat('/Volumes/ExternalDriveZ/ERA5_HHLcalcs/mseqhqlstats'),...
            'maxqhbyyear','pct9999qhbyyearERA5','pct999qhbyyearERA5','pct99qhbyyearERA5',...
            'pct90qhbyyearERA5','pct50qhbyyearERA5',...
            'maxqlbyyearERA5','pct9999qlbyyearERA5','pct999qlbyyearERA5','pct99qlbyyearERA5',...
            'pct90qlbyyearERA5','pct50qlbyyearERA5','-append');
    end
    %Percentiles of 500mb specific humidity and vertical velocity
    %Compute climatology with only 5 years, for speed purposes
    for year=2014:2018
        file=ncgeodataset(strcat('/Volumes/ExternalDriveZ/ERA5_Hourly_Data/vv_world_',num2str(year),'.grib'));
        temp=file{'Vertical_velocity_isobaric'};echo off;
        myrandarray=randperm(2920,1000); %to cut down on array size and resultant computational sluggishness
        vv=NaN.*ones(1000,721,1440);
        for i=1:size(myrandarray,2);vv(i,:,:)=squeeze(double(temp.data(myrandarray(i),3,:,:)));if rem(i,100)==0;disp(i);end;end %500mb
        globalvv_p999(year-2013)=quantile(reshape(vv,[size(vv,1)*size(vv,2)*size(vv,3),1]),0.999);
        globalvv_p99(year-2013)=quantile(reshape(vv,[size(vv,1)*size(vv,2)*size(vv,3),1]),0.99);
        globalvv_p90(year-2013)=quantile(reshape(vv,[size(vv,1)*size(vv,2)*size(vv,3),1]),0.9);
        globalvv_p50(year-2013)=quantile(reshape(vv,[size(vv,1)*size(vv,2)*size(vv,3),1]),0.5);
    end
    %Then take means of annual p99.9
    globalvv_p999=mean(globalvv_p999);
    globalvv_p99=mean(globalvv_p99);
    globalvv_p90=mean(globalvv_p90);
    globalvv_p50=mean(globalvv_p50);
    save(strcat('/Volumes/ExternalDriveZ/ERA5_HHLcalcs/percentilesofothervariables'),...
        'globalvv_p999','globalvv_p99','globalvv_p90','globalvv_p50','-append');
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
    for year=2015:2018
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
    
    globalmaxsstformap=flipud(squeeze(max(globalmaxsstbypt,[],3))');
    globalmaxsstformap=[globalmaxsstformap(:,721:1440) globalmaxsstformap(:,1:720)];
    invalid=globalmaxsstformap==0;globalmaxsstformap(invalid)=NaN;
    
    figure(800);clf;curpart=1;highqualityfiguresetup;
    data={era5latarray;era5lonarray;globalmaxsstformap};
    datatype='custom';region='world';
    vararginnew={'underlayvariable';'sst';'contour';0;'underlaycaxismin';0;'underlaycaxismax';37;'overlaynow';0;'nansblack';1;...
        'datatounderlay';data;'colormap';colormaps('classy rainbow','more','not');'centeredon';0;'conttoplot';'all';'nonewfig';1};
    plotModelData(data,region,vararginnew,datatype);
    title('Maximum SST','fontsize',16,'fontweight','bold','fontname','arial');
    hcb=colorbar;hcb.Label.String=strcat(char(176),'C');hcb.Label.FontSize=14;hcb.Label.FontWeight='bold';hcb.Label.FontName='arial';
    set(hcb,'fontweight','bold','fontsize',12,'fontname','arial');
    figname='maxsstmap';curpart=2;highqualityfiguresetup;
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
        msedata=load(strcat('/Volumes/ExternalDriveZ/ERA5_Hourly_Data/msedailymaxarray',num2str(year)));
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
    save('/Volumes/ExternalDriveZ/ERA5_Hourly_Data/toppctilestats','arrwithallp999','arrwithallp995','arrwithallp99','-append');
end

if makearrwithregtop1percent==1
    %Regions are same as those used in PBL and vertical-profile loops below
    dayc=0;disp(clock);
    for year=currentfirstyearcalc:currentlastyearcalc
        msedata=load(strcat('/Volumes/ExternalDriveZ/ERA5_Hourly_Data/msedailymaxarray',num2str(year)));
        dailymaxmserows201to300=msedata.dailymaxmserows201to300;
        dailymaxmserows301to400=msedata.dailymaxmserows301to400;
        dailymaxmserows401to500=msedata.dailymaxmserows401to500;
        clear msedata;
        msearr=cat(2,dailymaxmserows201to300,dailymaxmserows301to400,dailymaxmserows401to500); %centered on Date Line
        clear dailymaxmserows201to300;clear dailymaxmserows301to400;clear dailymaxmserows401to500;
        for doy=1:365
            temp=squeeze(msearr(doy,:,:));
            newtemp=[temp(:,721:1440) temp(:,1:720)];clear temp; 
            msearr(doy,:,:)=newtemp;clear newtemp; %centered on Prime Meridian
        end
        
        bigarr_persiangulf(year-(currentfirstyearcalc-1),1:365,:,:)=msearr(1:365,40:66,914:949);
        bigarr_pakistan(year-(currentfirstyearcalc-1),1:365,:,:)=msearr(1:365,29:55,990:1009);
        bigarr_eindiabangla(year-(currentfirstyearcalc-1),1:365,:,:)=msearr(1:365,50:100,1035:1115);
        bigarr_gulfofcalif(year-(currentfirstyearcalc-1),1:365,:,:)=msearr(1:365,45:67,280:302);
        bigarr_wamazon(year-(currentfirstyearcalc-1),1:365,:,:)=msearr(1:365,170:235,420:475);
        bigarr_redsea(year-(currentfirstyearcalc-1),1:365,:,:)=msearr(1:365,62:103,857:900);
        bigarr_naustralia(year-(currentfirstyearcalc-1),1:365,:,:)=msearr(1:365,220:240,1260:1296);
    end
    
    %Get regional top 1% and top 0.1% values
    reshaped=reshape(bigarr_persiangulf,[size(bigarr_persiangulf,1)*size(bigarr_persiangulf,2)*size(bigarr_persiangulf,3)*size(bigarr_persiangulf,4),1]);
    regtop1pct(1)=quantile(reshaped,0.99);regtop0point1pct(1)=quantile(reshaped,0.999);
    reshaped=reshape(bigarr_pakistan,[size(bigarr_pakistan,1)*size(bigarr_pakistan,2)*size(bigarr_pakistan,3)*size(bigarr_pakistan,4),1]);
    regtop1pct(2)=quantile(reshaped,0.99);regtop0point1pct(2)=quantile(reshaped,0.999);
    reshaped=reshape(bigarr_eindiabangla,[size(bigarr_eindiabangla,1)*size(bigarr_eindiabangla,2)*size(bigarr_eindiabangla,3)*size(bigarr_eindiabangla,4),1]);
    regtop1pct(3)=quantile(reshaped,0.99);regtop0point1pct(3)=quantile(reshaped,0.999);
    reshaped=reshape(bigarr_gulfofcalif,[size(bigarr_gulfofcalif,1)*size(bigarr_gulfofcalif,2)*size(bigarr_gulfofcalif,3)*size(bigarr_gulfofcalif,4),1]);
    regtop1pct(4)=quantile(reshaped,0.99);regtop0point1pct(4)=quantile(reshaped,0.999);
    reshaped=reshape(bigarr_wamazon,[size(bigarr_wamazon,1)*size(bigarr_wamazon,2)*size(bigarr_wamazon,3)*size(bigarr_wamazon,4),1]);
    regtop1pct(5)=quantile(reshaped,0.99);regtop0point1pct(5)=quantile(reshaped,0.999);
    reshaped=reshape(bigarr_redsea,[size(bigarr_redsea,1)*size(bigarr_redsea,2)*size(bigarr_redsea,3)*size(bigarr_redsea,4),1]);
    regtop1pct(6)=quantile(reshaped,0.99);regtop0point1pct(6)=quantile(reshaped,0.999);
    reshaped=reshape(bigarr_naustralia,[size(bigarr_naustralia,1)*size(bigarr_naustralia,2)*size(bigarr_naustralia,3)*size(bigarr_naustralia,4),1]);
    regtop1pct(7)=quantile(reshaped,0.99);regtop0point1pct(7)=quantile(reshaped,0.999);
    save('/Volumes/ExternalDriveZ/ERA5_Hourly_Data/toppctilestats','regtop1pct','regtop0point1pct','-append');
    disp(clock);
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
                            %pblhcindex(pblhc,1)=year;
                            %pblhcindex(pblhc,2)=i;
                        else
                            %saveddateinfo(i,:)=NaN.*ones(1,4);
                        end
                    end
                end
                clear pblhtemp;disp(year);disp(clock);
            end
            invalid=p999pblharr==0;p999pblharr(invalid)=NaN;
            save('/Volumes/ExternalDriveZ/ERA5_HHLcalcs/pblhp999days.mat','p999pblharr','saveddateinfo','-append');
        end
    end
    
    clear arrwithpblh_daily;
    arrwithpblh_daily(:,1)=max(p999pblharr(:,1:8),[],2);
    arrwithpblh_daily(:,2)=max(p999pblharr(:,9:16),[],2);
    arrwithpblh_daily(:,3)=max(p999pblharr(:,17:24),[],2);
    arrwithpblh_daily(:,4)=max(p999pblharr(:,25:32),[],2);
    arrwithpblh_daily(:,5)=max(p999pblharr(:,33:40),[],2);
    
    %Calculate PBL-height mean for p99.9 MSE days at each gridpoint
    clear arrwithallp999exp;
    arrwithallp999exp=[saveddateinfo arrwithpblh_daily [1:size(saveddateinfo,1)]']; %add ordinate
    arrwithallp999expsorted=sortrows(arrwithallp999exp,[3,4]);
    
    thisptstartpos=1;prevrow=0;prevcol=0;thisgridptc=1;
    pblhmeanp999=NaN.*ones(721,1440);pblhdistnp999=cell(721,1440);gridptcarr=zeros(721,1440);
    for i=1:size(arrwithallp999expsorted,1) %array is centered on 180
        currow=arrwithallp999expsorted(i,3);curcol=arrwithallp999expsorted(i,4);
        if currow==prevrow && curcol==prevcol
            thisgridptc=thisgridptc+1;
        else %finished, so sum up
            %if thisgridptc>=3
                pblhmeanp999(currow,curcol)=mean(mean(arrwithallp999expsorted(thisptstartpos:i,7),'omitnan'),'omitnan'); %centered on 0
                pblhdistnp999{currow,curcol}=arrwithallp999expsorted(thisptstartpos:i,7); %centered on 0
            %end
            thisptstartpos=i+1;
            thisgridptc=1;
        end
        gridptcarr(currow,curcol)=gridptcarr(currow,curcol)+1;
        prevrow=currow;prevcol=curcol;
    end
    
    figure(55);clf;
    imagescnan(pblhmeanp999);colorbar;
    
    
    %Regional medians, e.g. for PG
    temp=pblhmeanp999(actualrowstarts(1):actualrowstops(1),actualcolstarts(1)-0.5:actualcolstops(1)-0.5);
    temp=reshape(temp,[size(temp,1)*size(temp,2),1]);
    pblhregmedian_persiangulf=quantile(temp,0.5);
end

%Daily-max PBL heights for all days
if allpblheights==1
    allpblhstartcol=150;allpblhstopcol=1249;
    exist allpblh;remake=0;
    if ans==0
        if remake==1 %8 hours
            %allpblhstartrow=201;allpblhstoprow=450;
            %allpblh=NaN.*ones(40,360,250,allpblhstopcol-allpblhstartcol+1);
            allpblh_60n60s=NaN.*ones(5,360,481,1440);
            %for year=currentfirstyearcalc:currentlastyearcalc
            for year=2000:2004
                file=ncgeodataset(strcat('/Volumes/ExternalDriveD/ERA5_Hourly_Data_PBLheight_only/pblh_world_',num2str(year),'.grib'));
                pblhtemp=file{'Boundary_layer_height_surface'};echo off;clear file;
                for loop=1:10
                    %pblh=double(pblhtemp.data(36*8*loop-(36*8)+1:36*8*loop,allpblhstartrow:allpblhstoprow,allpblhstartcol:allpblhstopcol));
                    pblh_60n60s=double(pblhtemp.data(36*8*loop-(36*8)+1:36*8*loop,120:600,:));

                    for i=8:8:288
                        %allpblh(year-(currentfirstyearcalc-1),(loop-1)*36+i/8,:,:)=squeeze(max(pblh(i-7:i,:,:)));
                        
                        allpblh_60n60s(year-1999,(loop-1)*36+i/8,:,:)=squeeze(max(pblh_60n60s(i-7:i,120:600,:)));
                    end

                end
                clear pblhtemp;disp(year);disp(clock);
            end
            %invalid=allpblh==0;allpblh(invalid)=NaN;
            %save('/Volumes/ExternalDriveZ/ERA5_HHLcalcs/allpblh.mat','allpblh','-v7.3');
            invalid=allpblh_trueglobal==0;allpblh_trueglobal(invalid)=NaN;
            save('/Volumes/ExternalDriveZ/ERA5_HHLcalcs/allpblh.mat','allpblh_trueglobal','-v7.3');
        else
            temp=load('/Volumes/ExternalDriveZ/ERA5_HHLcalcs/allpblh.mat');allpblh=temp.allpblh;
        end
    end
    
    %Global [actually 60N-60S, to avoid polar-night effects] 99.9th, 99th, 90th, and 50th percentiles OF LOW PBL, SO INVERTED FROM WHAT YOU'D OTHERWISE EXPECT
    globalpblhpct999=quantile(reshape(allpblh_60n60s,...
        [size(allpblh_60n60s,1)*size(allpblh_60n60s,2)*size(allpblh_60n60s,3)*size(allpblh_60n60s,4),1]),0.001);
    globalpblhpct99=quantile(reshape(allpblh_60n60s,...
        [size(allpblh_60n60s,1)*size(allpblh_60n60s,2)*size(allpblh_60n60s,3)*size(allpblh_60n60s,4),1]),0.01);
    globalpblhpct90=quantile(reshape(allpblh_60n60s,...
        [size(allpblh_60n60s,1)*size(allpblh_60n60s,2)*size(allpblh_60n60s,3)*size(allpblh_60n60s,4),1]),0.10);
    globalpblhpct50=quantile(reshape(allpblh_60n60s,...
        [size(allpblh_60n60s,1)*size(allpblh_60n60s,2)*size(allpblh_60n60s,3)*size(allpblh_60n60s,4),1]),0.50);
    save('/Volumes/ExternalDriveZ/ERA5_HHLcalcs/percentilesofothervariables',...
        'globalpblhpct999','globalpblhpct99','globalpblhpct90','globalpblhpct50','-append');
    
    %Take time median for MJJAS (NH) or NDJFM (SH)
    nhpts=reshape(allpblh(:,122:273,1:160,:),[40*152,160,allpblhstopcol-allpblhstartcol+1]);
    allpblhmedian(1:160,:)=quantile(nhpts,0.5);clear nhpts; %centered on 180
    
    shpts=cat(2,allpblh(:,304:360,161:250,:),allpblh(:,1:90,161:250,:));
    shpts=reshape(shpts,[40*147,90,allpblhstopcol-allpblhstartcol+1]);
    allpblhmedian(161:250,:)=quantile(shpts,0.5);clear shpts;
    
    pblhmeanp999=[pblhmeanp999(:,721:1440) pblhmeanp999(:,1:720)]; %now centered on 180
    
    %Regional means (for verification only)
    %persiangulf_all=mean(mean(allpblhmedian_p999ptsonly(40:66,60:95),'omitnan'),'omitnan');
    %pakistan_all=mean(mean(allpblhmedian_p999ptsonly(28:54,136:155)));
    %eastindiabangladesh_all=mean(mean(allpblhmedian_p999ptsonly(50:100,181:261)));
    %gulfofcalifornia_all=mean(mean(allpblhmedian_p999ptsonly(45:67,866:888)));
    %westamazon_all=mean(mean(allpblhmedian_p999ptsonly(170:235,1006:1061)));
    %redsea_all=mean(mean(allpblhmedian_p999ptsonly(62:103,3:46)));
    %northaustralia_all=mean(mean(allpblhmedian_p999ptsonly(220:240,406:442)));
    
    
    %Compare PBL heights on p999 days vs non-extreme warm-season days
    %Randomly select non-extreme warm-season days and points and extract
        %PBL data for them -- so that the spatial distribution of the 'overall' and 'p999' arrays are comparable
    for regloop=1:9
        if regloop<=3 || regloop==5 || regloop>=8
        alldata=allpblh(:,122:273,max(1,actualrowstarts(regloop)-(allpblhstartrow-1)):actualrowstops(regloop)-(allpblhstartrow-1),...
            max(1,actualcolstartsalt(regloop)-0.5-(allpblhstartcol-1)):actualcolstopsalt(regloop)-0.5-(allpblhstartcol-1)); %continues to be centered approx. on 180
        c=1;clear distnp999;numberbypoint=zeros(721,1440);distnoverall=[];
        for i=actualrowstarts(regloop):actualrowstops(regloop)
            for j=actualcolstarts(regloop)-0.5:actualcolstops(regloop)-0.5
                if size(pblhdistnp999{i,j},1)>=1
                    distnp999(c:c+size(pblhdistnp999{i,j},1)-1)=pblhdistnp999{i,j}; %centered on 0
                    c=c+size(pblhdistnp999{i,j},1);
                    numberbypoint(i,j)=size(pblhdistnp999{i,j},1);

                    alldatathispoint=alldata(:,:,i-(actualrowstarts(regloop)+1),j-(actualcolstarts(regloop)-0.5)+1);
                    alldatathispoint=reshape(alldatathispoint,[size(alldatathispoint,1)*size(alldatathispoint,2),1]);
                    randdata=alldatathispoint(randperm(size(alldatathispoint,1),numberbypoint(i,j)));
                    distnoverall=[distnoverall;randdata];
                end
            end
        end
        if regloop==1
            pgdistnp999=distnp999;pgdistnoverall=distnoverall;
        elseif regloop==2
            pakdistnp999=distnp999;pakdistnoverall=distnoverall;
        elseif regloop==3
            eibdistnp999=distnp999;eibdistnoverall=distnoverall;
        elseif regloop==5
            amazdistnp999=distnp999;amazdistnoverall=distnoverall;
        elseif regloop==8
            mwdistnp999=distnp999;mwdistnoverall=distnoverall;
        elseif regloop==9
            caspdistnp999=distnp999;caspdistnoverall=distnoverall;
        end
        end
    end
    clear alldata;
    
    
    
    %figure(78);clf;subplot(1,2,1);boxplot(pgdistnp999);subplot(1,2,2);boxplot(pgdistnoverall);
    %figure(79);clf;subplot(1,2,1);boxplot(pakdistnp999);subplot(1,2,2);boxplot(pakdistnoverall);
    %figure(80);clf;subplot(1,2,1);boxplot(eibdistnp999);subplot(1,2,2);boxplot(eibdistnoverall);
    %figure(81);clf;subplot(1,2,1);boxplot(gocdistnp999);subplot(1,2,2);boxplot(gocdistnoverall);
    %figure(82);clf;subplot(1,2,1);boxplot(amazdistnp999);subplot(1,2,2);boxplot(amazdistnoverall);
    makethis=0;
    if makethis==1
    figure(83);clf;
    subplot(2,2,1);[f,xi,b1]=ksdensity(pgdistnp999');plot(xi,f,'LineWidth',1.5,'Color','r');hold on;
    [f,xi,bw1]=ksdensity(pgdistnoverall,'Bandwidth',20);plot(xi,f,'LineWidth',1.5,'Color','b');
    xlim([0 5000]);title('Persian Gulf');
    subplot(2,2,2);[f,xi,b2]=ksdensity(pakdistnp999,'Bandwidth',60);plot(xi,f,'LineWidth',1.5,'Color','r');hold on;
    [f,xi,bw2]=ksdensity(pakdistnoverall);plot(xi,f,'LineWidth',1.5,'Color','b');
    xlim([0 5000]);title('Pakistan');
    subplot(2,2,3);[f,xi,b3]=ksdensity(eibdistnp999,'Bandwidth',30);plot(xi,f,'LineWidth',1.5,'Color','r');hold on;
    [f,xi,bw3]=ksdensity(eibdistnoverall);plot(xi,f,'LineWidth',1.5,'Color','b');
    xlim([0 5000]);title('E South Asia');
    %subplot(4,2,4);[f,xi,b4]=ksdensity(gocdistnp999);plot(xi,f,'LineWidth',1.5,'Color','r');hold on;
    %[f,xi,bw4]=ksdensity(gocdistnoverall,'Bandwidth',50);plot(xi,f,'LineWidth',1.5,'Color','b');
    %xlim([0 6000]);title('Gulf of California');
    subplot(2,2,4);[f,xi,b5]=ksdensity(amazdistnp999);plot(xi,f,'LineWidth',1.5,'Color','r');hold on;
    [f,xi,bw5]=ksdensity(amazdistnoverall);plot(xi,f,'LineWidth',1.5,'Color','b');
    xlim([0 5000]);title('Western Amazon Basin');
    end
    %subplot(4,2,6);[f,xi,b6]=ksdensity(redseadistnp999);plot(xi,f,'LineWidth',1.5,'Color','r');hold on;
    %[f,xi,bw6]=ksdensity(redseadistnoverall);plot(xi,f,'LineWidth',1.5,'Color','b');
    %xlim([0 6000]);title('Red Sea');
    %subplot(4,2,7);[f,xi,b7]=ksdensity(nausdistnp999);plot(xi,f,'LineWidth',1.5,'Color','r');hold on;
    %[f,xi,bw7]=ksdensity(nausdistnoverall);plot(xi,f,'LineWidth',1.5,'Color','b');
    %xlim([0 6000]);title('Northern Australia');
   
    %Histogram
    %Ensure normalization is proper by using bar plot instead
    figure(84);clf;curpart=1;highqualityfiguresetup;
    for loop=1:6
        if loop==1
            distnoverall=pgdistnoverall;distnp999=pgdistnp999;titletext='Persian Gulf';
        elseif loop==2
            distnoverall=pakdistnoverall;distnp999=pakdistnp999;titletext='Pakistan';
        elseif loop==3
            distnoverall=eibdistnoverall;distnp999=eibdistnp999;titletext='E South Asia';
        elseif loop==4
        %    distnoverall=gocdistnoverall;distnp999=gocdistnp999;titletext='Gulf of California';
        %elseif loop==5
            distnoverall=amazdistnoverall;distnp999=amazdistnp999;titletext='W Amazon';
        %elseif loop==6
        %    distnoverall=redseadistnoverall;distnp999=redseadistnp999;titletext='Red Sea';
        %elseif loop==7
        %    distnoverall=nausdistnoverall;distnp999=nausdistnp999;titletext='N Australia';
        elseif loop==5
            distnoverall=mwdistnoverall;distnp999=mwdistnp999;titletext='Midwest US';
        elseif loop==6
            distnoverall=caspdistnoverall;distnp999=caspdistnp999;titletext='Caspian Sea';
        end
        subplot(3,2,loop);hold on;
        numvalsbybin=zeros(50,1);binedge=0;
        for binstart=1:50
            numvalsbybin(binstart)=sum(find(distnoverall>=binedge & distnoverall<binedge+100));
            binedge=binedge+100;
        end
        b=bar(50:100:4950,numvalsbybin./sum(numvalsbybin),1);set(b,'facealpha',1,'facecolor',colors('histogram blue'),'edgecolor','none');

        numvalsbybin=zeros(50,1);binedge=0;
        for binstart=1:50
            numvalsbybin(binstart)=sum(find(distnp999>=binedge & distnp999<binedge+100));
            binedge=binedge+100;
        end
        b=bar(50:100:4950,numvalsbybin./sum(numvalsbybin),1);set(b,'facealpha',0.5,'facecolor',colors('dark red'),'edgecolor','none');
        
        ylim([0 0.32]);
        
        set(gca,'fontsize',10,'fontweight','bold','fontname','arial');
        xlabel('Height (m)','fontsize',10,'fontweight','bold','fontname','arial');
        title(titletext,'fontsize',12,'fontweight','bold','fontname','arial');
    end
    figname='PBL_regional_histograms';curpart=2;highqualityfiguresetup;
end


%This part also includes soundings, as a check on the somewhat suspicious
    %profiles that ERA5 has for certain regions (e.g. Amazon...)
%Varies the exact percentile (and the number of years) used to ensure a
    %sufficiently large sample size of extremes in each region
if tqvertprofiles==1
    completerestart=0;
    if completerestart==1
    clear msep9Xera5;clear mse_remainderera5;clear tp9Xera5;clear qp9Xera5;clear t_remainderera5;clear q_remainderera5;
    clear malrp9Xera5;clear malr_remainderera5;
    clear twcompositesoundings;clear tcompositesoundings;clear tdcompositesoundings;
    clear winddircompositesoundings;clear windspdcompositesoundings;clear msecompositesoundings;
    clear savethedatesandlocsera5;clear savethedatesandlocs_remainderera5;
    clear newsavethedatesandlocsp9X;clear newsavethedatesandlocs_remainder;clear newarrwithqprofilep9X;clear newarrwithtprofilep9X;
    end
    pressures_forsoundings=[200 300 500 700 850 900 950 975 985 995];
    pressures_forera5=[200 300 500 700 850 900 950 975 1000];
    %gothru=[9;8;9;7;8;9;9];
    
    for regloop=1:7
        if regloop==1
            regname='persiangulf';firstmonth=5;lastmonth=9;firstpreslevel_soundings=995;maxdesiredelev=40;
            firstpreslevel_era5=1000;
            startyear=2017;stopyear=2018;
            %Soundings are from Abu Dhabi, Muscat, and Dhahran
            soundingstouse={'AEM00041217';'MUM00041256';'SAM00040416'};
        elseif regloop==2
            regname='pakistan';firstmonth=5;lastmonth=9;firstpreslevel_soundings=985;maxdesiredelev=120;
            firstpreslevel_era5=975;
            startyear=2015;stopyear=2018;
            %Soundings are from Multan
            soundingstouse={'PKM00041675'};
        elseif regloop==3
            regname='eindiabangla';firstmonth=5;lastmonth=9;firstpreslevel_soundings=995;maxdesiredelev=40;
            firstpreslevel_era5=1000;
            startyear=2015;stopyear=2018;
            %Soundings are from Guwahati and Dhaka
            soundingstouse={'INM00042410';'BGM00041923'};
        elseif regloop==4
            regname='gulfofcalif';firstmonth=5;lastmonth=9;firstpreslevel_soundings=950;maxdesiredelev=425;
            firstpreslevel_era5=950;
            startyear=2009;stopyear=2018;
            %Soundings are from Empalme and Mazatlan
            soundingstouse={'MXM00076256';'MXM00076458'};
        elseif regloop==5
            regname='wamazon';firstmonth=11;lastmonth=3;firstpreslevel_soundings=975;maxdesiredelev=210;
            firstpreslevel_era5=975;
            startyear=2014;stopyear=2018;
            %Soundings are from Cruzeiro do Sul and Porto Velho
            soundingstouse={'BRM00082705';'BRM00082824'};
        elseif regloop==6
            regname='redsea';firstmonth=5;lastmonth=9;firstpreslevel_soundings=995;maxdesiredelev=40;
            firstpreslevel_era5=1000;
            startyear=2015;stopyear=2018;
            %Soundings are from Jeddah
            soundingstouse={'SAM00041024'};
        elseif regloop==7
            regname='naustralia';firstmonth=11;lastmonth=3;firstpreslevel_soundings=995;maxdesiredelev=40;
            firstpreslevel_era5=1000;
            startyear=2010;stopyear=2018;
            %Soundings are from East Arnhem and Weipa
            soundingstouse={'ASM00094150';'ASM00094170'};
        end
        actualrowstart=actualrowstarts(regloop);actualrowstop=actualrowstops(regloop);
        actualcolstart=actualcolstarts(regloop);actualcolstop=actualcolstops(regloop);
        
        %With sounding data, omit 1000 mb since some cities are slightly higher in elevation
        %The script readsoundingdata pulls data for the top 1% of Tw values at each location
        if readsoundings==1
            
        if firstpreslevel_soundings==995;numsoundinglevels(regloop)=10;elseif firstpreslevel_soundings==985;numsoundinglevels(regloop)=9;...
        elseif firstpreslevel_soundings==975;numsoundinglevels(regloop)=8;else;numsoundinglevels(regloop)=7;end
        twcomposite=NaN.*ones(size(soundingstouse,1),2,numsoundinglevels(regloop));
        tcomposite=NaN.*ones(size(soundingstouse,1),2,numsoundinglevels(regloop));
        tdcomposite=NaN.*ones(size(soundingstouse,1),2,numsoundinglevels(regloop));
        winddircomposite=NaN.*ones(size(soundingstouse,1),2,numsoundinglevels(regloop));
        windspdcomposite=NaN.*ones(size(soundingstouse,1),2,numsoundinglevels(regloop));
        if firstmonth>lastmonth %i.e. summer in the SH
            twcomposite_temp=NaN.*ones(2,size(soundingstouse,1),2,numsoundinglevels(regloop));
            tcomposite_temp=NaN.*ones(2,size(soundingstouse,1),2,numsoundinglevels(regloop));
            tdcomposite_temp=NaN.*ones(2,size(soundingstouse,1),2,numsoundinglevels(regloop));
            winddircomposite_temp=NaN.*ones(2,size(soundingstouse,1),2,numsoundinglevels(regloop));
            windspdcomposite_temp=NaN.*ones(2,size(soundingstouse,1),2,numsoundinglevels(regloop));
            for city=1:size(soundingstouse,1)
                [twcomposite_temp(1,city,:,:),tcomposite_temp(1,city,:,:),tdcomposite_temp(1,city,:,:),...
                    winddircomposite_temp(1,city,:,:),windspdcomposite_temp(1,city,:,:)]=...
                    readsoundingdata(strcat('/Volumes/ExternalDriveD/Soundings/',soundingstouse{city},'-data.txt'),...
                    1,firstpreslevel_soundings,numsoundinglevels(regloop),-10,1,firstmonth,12,0,0,0);
                fprintf('Completed the reading of soundings for city %d, region %d (part 1)\n',city,regloop);
            end
            for city=1:size(soundingstouse,1)
                [twcomposite_temp(2,city,:,:),tcomposite_temp(2,city,:,:),tdcomposite_temp(2,city,:,:),...
                    winddircomposite_temp(2,city,:,:),windspdcomposite_temp(2,city,:,:)]=...
                    readsoundingdata(strcat('/Volumes/ExternalDriveD/Soundings/',soundingstouse{city},'-data.txt'),...
                    1,firstpreslevel_soundings,numsoundinglevels(regloop),-10,1,1,lastmonth,0,0,0);
                fprintf('Completed the reading of soundings for city %d, region %d (part 2)\n',city,regloop);
            end
            twcomposite(city,:,:)=squeeze(mean(twcomposite_temp(:,city,:,:),1));
            tcomposite(city,:,:)=squeeze(mean(tcomposite_temp(:,city,:,:),1));
            tdcomposite(city,:,:)=squeeze(mean(tdcomposite_temp(:,city,:,:),1));
            winddircomposite(city,:,:)=squeeze(mean(winddircomposite_temp(:,city,:,:),1));
            windspdcomposite(city,:,:)=squeeze(mean(windspdcomposite_temp(:,city,:,:),1));
        else %much simpler
            for city=1:size(soundingstouse,1)
                [twcomposite(city,:,:),tcomposite(city,:,:),tdcomposite(city,:,:),...
                    winddircomposite(city,:,:),windspdcomposite(city,:,:)]=...
                    readsoundingdata(strcat('/Volumes/ExternalDriveD/Soundings/',soundingstouse{city},'-data.txt'),...
                    1,firstpreslevel_soundings,numsoundinglevels(regloop),-10,1,firstmonth,lastmonth,0,0,0);
                fprintf('Completed the reading of soundings for city %d, region %d\n',city,regloop);
            end
        end
        twcompositesoundings{regloop}=squeeze(mean(twcomposite,1,'omitnan')); %mean across cities
        tcompositesoundings{regloop}=squeeze(mean(tcomposite,1,'omitnan'));
        tdcompositesoundings{regloop}=squeeze(mean(tdcomposite,1,'omitnan'));
        winddircompositesoundings{regloop}=squeeze(mean(winddircomposite,1,'omitnan'));
        windspdcompositesoundings{regloop}=squeeze(mean(windspdcomposite,1,'omitnan'));
        
        %Also calculate MSE
        clear qh;clear ql;
        for lev=1:numsoundinglevels(regloop)
            pres_flipped=fliplr(pressures_forsoundings(1:numsoundinglevels(regloop)));
            thispres=100*pres_flipped(lev);

            mr=calcmrfromvpandpsfc(calcvpfromTd(tdcompositesoundings{regloop}(:,lev)),thispres)./1000;
            omega=calcqfromTd_dynamicP(tdcompositesoundings{regloop}(:,lev),thispres)./1000;%convert to unitless specific humidity

            cp=1005.7.*(1+1.83.*mr);clear mr; %J K^-1 kg^-1; Stull, Practical Meteorology
            qh=cp.*(tcompositesoundings{regloop}(:,lev)+273.15)./1000;clear cp;

            lv=1918.46.*(((tcompositesoundings{regloop}(:,lev)+273.15)./((tcompositesoundings{regloop}(:,lev)+273.15)-33.91)).^2); %J/kg; Henderson-Sellers 1984
            ql=lv.*omega;clear lv;clear omega; %J/kg

            msecompositesoundings{regloop}(1:2,10-numsoundinglevels(regloop)+lev)=qh+ql;
        end
        end
        
        
        %Now read in ERA5 data
        extremec=0;nonextremec=0;
        clear arrwithtprofile;clear arrwithqprofile;clear gridptlistbyprofilec;
        clear arrwithtprofile_remainder;clear arrwithqprofile_remainder;
        savethedatesandlocsera5{regloop}=zeros(1,4);savethedatesandlocs_remainderera5{regloop}=zeros(1,4);
        elevtouse=[elevera5(:,721:1440) elevera5(:,1:720)];
        
        if rem(actualcolstart,1)==0.5 %need to do some averaging
            colstart1=actualcolstart-0.5;colstart2=actualcolstart+0.5;colstop1=actualcolstop-0.5;colstop2=actualcolstop+0.5;
        else
            colstart1=actualcolstart;colstart2=actualcolstart;colstop1=actualcolstop;colstop2=actualcolstop;
        end
        if colstart1>720;colstart1alt=colstart1-720;else;colstart1alt=colstart1+720;end
        if colstop1>720;colstop1alt=colstop1-720;else;colstop1alt=colstop1+720;end
        
        for year=startyear:stopyear
            %Vertical-profile data
            file=ncgeodataset(strcat('/Volumes/ExternalDriveD/ERA5_Tq_vertprofiles_only/tq_vertprofile_',regname,'_',num2str(year),'.grib'));
            ttemp=file{'Temperature_isobaric'};echo off;
            qtemp=file{'Specific_humidity_isobaric'};echo off;
            %2-m data and settings
            file=ncgeodataset(strcat('/Volumes/ExternalDriveZ/ERA5_Hourly_Data/ttd_world_',num2str(year),'.grib'));
            t2mtemp=file{'2_metre_temperature_surface'};echo off;
            td2mtemp=file{'2_metre_dewpoint_temperature_surface'};echo off;
            psfcfile=ncgeodataset(strcat('/Volumes/ExternalDriveC/ERA5_Hourly_Data_PandGHonly/psfc_world_',num2str(year),'.grib'));
            psfctemp=psfcfile{'Surface_pressure_surface'};echo off;
            sz=292;
            
            if regloop==1
                temp=find(arrwithallp999(:,1)==year);yearsubset=arrwithallp999(temp,:);
            elseif regloop==4 || regloop==7
                temp=find(arrwithallp99(:,1)==year);yearsubset=arrwithallp99(temp,:);
            else
                temp=find(arrwithallp995(:,1)==year);yearsubset=arrwithallp995(temp,:);
            end
            newro=0;clear yearandregsubset;
            for ro=1:size(yearsubset,1)
                if yearsubset(ro,3)>=actualrowstart && yearsubset(ro,3)<=actualrowstop && ...
                    yearsubset(ro,4)>=colstart2 && yearsubset(ro,4)<=colstop1
                    newro=newro+1;
                    yearandregsubset(newro,:)=yearsubset(ro,:);
                end
            end
            %Sample sizes (example for 2016): 1575 for Persian Gulf (>99.9th), 64 for Pakistan (>99.5th), 565 for E India (>99.5th), 17 for Gulf of
            %Calif (>99th), 465 for W Amazon (>99.5th), 370 for Red Sea (>99.5th), 0 for N Australia (>99th)
            
            %Aggregate extreme data
            %Anything that refers to the 't' or 'q' arrays has to consider the fact that they unfortunately do not always perfectly match up
                %with the other arrays, thus requiring careful averaging to ensure consistency
            if newro>=1
                yearandregsubset=sortrows(yearandregsubset,2);
                if rem(actualcolstart,1)==0.5
                    t_regl=double(ttemp.data(:,1:gothru(regloop),:,:)); %to enable averaging
                    q_regl=double(qtemp.data(:,1:gothru(regloop),:,:));
                else
                    t_regl=double(ttemp.data(:,1:gothru(regloop),:,:));
                    q_regl=double(qtemp.data(:,1:gothru(regloop),:,:));
                end

                cthisloop=0;clear daysandgridptslist;
                for i=1:size(yearandregsubset,1) %across all extreme gridpt-days in this year
                    if elevera5(yearandregsubset(i,3),yearandregsubset(i,4))<=maxdesiredelev %gridpt is low-enough elevation
                        dayhere=yearandregsubset(i,2);
                        extremec=extremec+1;
                        if rem(actualcolstart,1)==0.5 %averaging over two adjacent columns
                            thistdata1=t_regl(dayhere*8-7:dayhere*8,:,yearandregsubset(i,3)-actualrowstart+1,yearandregsubset(i,4)-colstart1+1);
                            thistdata2=t_regl(dayhere*8-7:dayhere*8,:,yearandregsubset(i,3)-actualrowstart+1,yearandregsubset(i,4)-colstart2+1);
                            A=cat(3,thistdata1,thistdata2);thistdata=squeeze(mean(A,3));
                            thisqdata1=q_regl(dayhere*8-7:dayhere*8,:,yearandregsubset(i,3)-actualrowstart+1,yearandregsubset(i,4)-colstart1+1);
                            thisqdata2=q_regl(dayhere*8-7:dayhere*8,:,yearandregsubset(i,3)-actualrowstart+1,yearandregsubset(i,4)-colstart2+1);
                            A=cat(3,thisqdata1,thisqdata2);thisqdata=squeeze(mean(A,3));
                        else
                            thistdata=t_regl(dayhere*8-7:dayhere*8,:,yearandregsubset(i,3)-actualrowstart+1,yearandregsubset(i,4)-colstart1+1);
                            thisqdata=q_regl(dayhere*8-7:dayhere*8,:,yearandregsubset(i,3)-actualrowstart+1,yearandregsubset(i,4)-colstart1+1);
                        end
                        
                        %Also include 2-m T and q, and calculate this day's hourofmax using 2-m MSE
                        if yearandregsubset(i,4)>720;coladj=yearandregsubset(i,4)-720;else;coladj=yearandregsubset(i,4)+720;end
                        t2m=double(t2mtemp.data(dayhere*8-7:dayhere*8,yearandregsubset(i,3),coladj));
                        td2m=double(td2mtemp.data(dayhere*8-7:dayhere*8,yearandregsubset(i,3),coladj))-273.15;
                        
                        psfc=double(psfctemp.data(dayhere*8-7:dayhere*8,yearandregsubset(i,3),yearandregsubset(i,4)));
                        mr=calcmrfromvpandpsfc(calcvpfromTd(td2m),psfc)./1000;
                        omega=calcqfromTd_dynamicP(td2m,psfc)./1000; %convert to unitless specific humidity
                        cp=1005.7.*(1+1.83.*mr);clear mr; %J K^-1 kg^-1; Stull, Practical Meteorology
                        qh=cp.*t2m./1000;clear cp;
                        lv=1918.46.*((t2m./(t2m-33.91)).^2); %J/kg; Henderson-Sellers 1984
                        ql=lv.*omega;clear lv; %J/kg
                        mse=qh+ql;
                        [~,hourofmax]=max(mse); %hour of max only on this day, not across all days as was done before
                        
                        arrwithtprofile(extremec,1:gothru(regloop))=thistdata(hourofmax,:);arrwithtprofile(extremec,gothru(regloop)+1)=t2m(hourofmax);
                        arrwithqprofile(extremec,1:gothru(regloop))=thisqdata(hourofmax,:);arrwithqprofile(extremec,gothru(regloop)+1)=omega(hourofmax);
                        savethedatesandlocsera5{regloop}(extremec,:)=yearandregsubset(i,:);

                        cthisloop=cthisloop+1;
                        daysandgridptslist(cthisloop,1:3)=[dayhere yearandregsubset(i,3)-actualrowstart+1 yearandregsubset(i,4)-colstart1+1];
                    end
                end

                %Aggregate non-extreme data, for gridpts that *did* hit the desired extreme pctile during this year, 
                    %for making a 'non-extreme' composite
                if cthisloop>=1
                    cc=0;
                    for j=1:size(t_regl,3) %across rows in region
                        for k=1:size(t_regl,4) %across cols in region
                            truerow=j+actualrowstart-1;
                            if elevera5(truerow,k+colstart1-1)<=maxdesiredelev %gridpt is low-enough elevation
                                if colstart1>720;truecol=k+colstart1-1-720;else;truecol=k+colstart1-1+720;end

                                %First -- did this point hit the desired extreme pctile at least once during this year? 
                                foundthispt=0;l=1;
                                while l<=size(daysandgridptslist,1)
                                    if j==daysandgridptslist(l,2) && k==daysandgridptslist(l,3)
                                        foundthispt=1;foundat=l;
                                        l=size(daysandgridptslist,1)+1;
                                    else
                                        l=l+1;
                                    end 
                                end

                                %If so, get its values on 5 randomly-selected warm-season days when it *didn't* reach that level 
                                if foundthispt==1
                                    cc=cc+1;
                                    thehotday=daysandgridptslist(foundat,1);
                                    newdays=[thehotday-45+randperm(90,5)]';
                                    invalid=newdays<=0;newdays(invalid)=newdays(invalid)+365;
                                    invalid=newdays>365;newdays(invalid)=newdays(invalid)-365;
                                    
                                    for w=1:size(newdays,1) %loop across the non-extreme (if that's indeed what they are) days
                                        i=newdays(w);
                                        %Profile data
                                        thistdata=t_regl(i*8-7:i*8,:,j,k);
                                        thisqdata=q_regl(i*8-7:i*8,:,j,k);

                                        %Also include 2-m T and q, and calculate each day's hourofmax using 2-m MSE
                                        t2m=double(t2mtemp.data(i*8-7:i*8,truerow,truecol));
                                        td2m=double(td2mtemp.data(i*8-7:i*8,truerow,truecol))-273.15;
                                        psfc=double(psfctemp.data(i*8-7:i*8,truerow,truecol));
                                        mr=calcmrfromvpandpsfc(calcvpfromTd(td2m),psfc)./1000;
                                        omega=calcqfromTd_dynamicP(td2m,psfc)./1000; %convert to unitless specific humidity
                                        cp=1005.7.*(1+1.83.*mr);clear mr; %J K^-1 kg^-1; Stull, Practical Meteorology
                                        qh=cp.*t2m./1000;clear cp;
                                        lv=1918.46.*((t2m./(t2m-33.91)).^2); %J/kg; Henderson-Sellers 1984
                                        ql=lv.*omega;clear lv; %J/kg
                                        mse=qh+ql;
                                    
                                        thisptexceededp9Xonthisday=0;
                                        kk=1;
                                        while kk<=cthisloop
                                            d=daysandgridptslist(kk,1);r=daysandgridptslist(kk,2);c=daysandgridptslist(kk,3);
                                            if i==d && j==r && k==c
                                                thisptexceededp9Xonthisday=1;kk=cthisloop+1;
                                            else
                                                kk=kk+1;
                                            end
                                        end

                                        if thisptexceededp9Xonthisday~=1
                                            nonextremec=nonextremec+1;

                                            %Also include 2-m T and q, and calculate this day's hourofmax using 2-m MSE
                                            %relday=i-day1+1;
                                            [~,hourofmax]=max(mse);
                                                %hour of max only on this day, not across all days as was done before
                                                
                                            arrwithtprofile_remainder(nonextremec,1:gothru(regloop))=thistdata(hourofmax,:);
                                            arrwithtprofile_remainder(nonextremec,gothru(regloop)+1)=t2m(hourofmax);
                                            arrwithqprofile_remainder(nonextremec,1:gothru(regloop))=thisqdata(hourofmax,:);
                                            arrwithqprofile_remainder(nonextremec,gothru(regloop)+1)=omega(hourofmax);
                                                
                                            savethedatesandlocs_remainderera5{regloop}(nonextremec,:,:)=[year i truerow truecol];
                                        end
                                    end
                                end
                            end
                        end
                    end
                end
            end
            clear ttemp;clear qtemp;disp(regloop);disp(year);disp(clock);
        end
        
        
        %Compute profile for each hour at which a daily-max p9X MSE value occurred, 
            %averaged over all such points in each region
        
        %Redo after eliminating rows where final two columns are the same, as this
        %indicates that they pertain to gridpoints whose elevation is such
        %that the surface pressure is less than the pressure we're
        %interested in...
        newi=0;clear newiiconversion;
        for i=1:size(arrwithqprofile,1)
            if abs(arrwithqprofile(i,gothru(regloop)-1)-arrwithqprofile(i,gothru(regloop)))<=10^-5 || ...
                    abs(arrwithtprofile(i,gothru(regloop)-1)-arrwithtprofile(i,gothru(regloop)))<=10^-5
            else
                newi=newi+1;
                newarrwithqprofilep9X{regloop}(newi,:)=arrwithqprofile(i,:);
                newarrwithtprofilep9X{regloop}(newi,:)=arrwithtprofile(i,:);
                newsavethedatesandlocsp9X{regloop}(newi,1:4)=savethedatesandlocsera5{regloop}(i,1:4);
                newiiconversion{regloop}(newi)=i;
            end
        end
        
        newi=0;clear newiiconversion_remainder;
        for i=1:size(arrwithqprofile_remainder,1)
            if abs(arrwithqprofile_remainder(i,gothru(regloop)-1)-arrwithqprofile_remainder(i,gothru(regloop)))<=10^-5 || ...
                    abs(arrwithtprofile_remainder(i,gothru(regloop)-1)-arrwithtprofile_remainder(i,gothru(regloop)))<=10^-5
            else
                newi=newi+1;
                newarrwithqprofile_remainder{regloop}(newi,:)=arrwithqprofile_remainder(i,:);
                newarrwithtprofile_remainder{regloop}(newi,:)=arrwithtprofile_remainder(i,:);
                newsavethedatesandlocs_remainder{regloop}(newi,1:4)=savethedatesandlocs_remainderera5{regloop}(i,1:4);
                newiiconversion_remainder{regloop}(newi)=i;
            end
        end
        
        
        clear tmeanprofilep9Xera5;clear qmeanprofilep9Xera5;
        clear tmeanprofile_remainderera5;clear qmeanprofile_remainderera5;
        invalid=newarrwithtprofilep9X{regloop}==0;newarrwithtprofilep9X{regloop}(invalid)=NaN;
        invalid=newarrwithqprofilep9X{regloop}==0;newarrwithqprofilep9X{regloop}(invalid)=NaN;
        invalid=newarrwithtprofile_remainder{regloop}==0;newarrwithtprofile_remainder{regloop}(invalid)=NaN;
        invalid=newarrwithtprofile_remainder{regloop}==0;newarrwithtprofile_remainder{regloop}(invalid)=NaN;
                
        tmeanprofilep9Xera5=squeeze(mean(newarrwithtprofilep9X{regloop},'omitnan'));
        qmeanprofilep9Xera5=squeeze(mean(newarrwithqprofilep9X{regloop},'omitnan'));
        tmeanprofile_remainderera5=squeeze(mean(newarrwithtprofile_remainder{regloop},'omitnan'));
        qmeanprofile_remainderera5=squeeze(mean(newarrwithqprofile_remainder{regloop},'omitnan'));
        
        td=calcTdfromq(qmeanprofilep9Xera5.*1000);
        if gothru(regloop)==9;pres=[pressures_forera5 1000];elseif gothru(regloop)==7;pres=[pressures_forera5(1:7) 1000];else;pres=pressures_forera5;end
        mr=calcmrfromvpandpsfc(calcvpfromTd(td),100.*pres)./1000;
        cp=1005.7.*(1+1.83.*mr);clear mr; %J K^-1 kg^-1; Stull, Practical Meteorology
        qhp9X=cp.*tmeanprofilep9Xera5./1000;clear cp;
        lv=1918.46.*((tmeanprofilep9Xera5./(tmeanprofilep9Xera5-33.91)).^2); %J/kg; Henderson-Sellers 1984
        qlp9X=lv.*qmeanprofilep9Xera5; %J/kg
        msep9Xera5(regloop,1:gothru(regloop)+1)=qhp9X+qlp9X;
        
        td=calcTdfromq(qmeanprofile_remainderera5.*1000);
        mr=calcmrfromvpandpsfc(calcvpfromTd(td),100.*pres)./1000;
        cp=1005.7.*(1+1.83.*mr);clear mr; %J K^-1 kg^-1; Stull, Practical Meteorology
        qh_remainder=cp.*tmeanprofile_remainderera5./1000;clear cp;
        lv=1918.46.*((tmeanprofile_remainderera5./(tmeanprofile_remainderera5-33.91)).^2); %J/kg; Henderson-Sellers 1984
        ql_remainder=lv.*qmeanprofile_remainderera5; %J/kg
        mse_remainderera5(regloop,1:gothru(regloop)+1)=qh_remainder+ql_remainder;
        
        %%%Pakistan only (so far), to get distribution of msep9X sfc-850 differences%%%
        if regloop==0
        tdtestsfc=calcTdfromq(squeeze(newarrwithqprofilep9X{regloop}(:,hourofmax,gothru(regloop))));
        tdtest850=calcTdfromq(squeeze(newarrwithqprofilep9X{regloop}(:,hourofmax,5)));
        mrtestsfc=calcmrfromvpandpsfc(calcvpfromTd(tdtestsfc),100.*1000)./1000;
        mrtest850=calcmrfromvpandpsfc(calcvpfromTd(tdtest850),100.*1000)./1000;
        cptestsfc=1005.7.*(1+1.83.*mrtestsfc);clear mrtestsfc;
        cptest850=1005.7.*(1+1.83.*mrtest850);clear mrtest850;
        qhtestsfc=cptestsfc.*squeeze(newarrwithtprofilep9X{regloop}(:,hourofmax,gothru(regloop)))./1000;clear cptestsfc;
        qhtest850=cptest850.*squeeze(newarrwithtprofilep9X{regloop}(:,hourofmax,5))./1000;clear cptest850;
        lvtestsfc=1918.46.*((squeeze(newarrwithtprofilep9X{regloop}(:,hourofmax,gothru(regloop)))./(squeeze(newarrwithtprofilep9X{regloop}(:,hourofmax,gothru(regloop)))-33.91)).^2);
        lvtest850=1918.46.*((squeeze(newarrwithtprofilep9X{regloop}(:,hourofmax,5))./(squeeze(newarrwithtprofilep9X{regloop}(:,hourofmax,5))-33.91)).^2);
        qltestsfc=lvtestsfc.*squeeze(newarrwithqprofilep9X{regloop}(:,hourofmax,gothru(regloop)));clear lvtestsfc;
        qltest850=lvtest850.*squeeze(newarrwithqprofilep9X{regloop}(:,hourofmax,5));clear lvtest850;
        raymondtestsfc=qhtestsfc+qltestsfc;
        raymondtest850=qhtest850+qltest850;
        figure(842);clf;plot(raymondtestsfc-raymondtest850);
        clear theseelevs;
        for kk=1:size(newsavethedatesandlocsp9X{regloop},1)
        theseelevs(kk)=elevtouse(newsavethedatesandlocsp9X{regloop}(kk,1,3),newsavethedatesandlocsp9X{regloop}(kk,1,4));
        end
        figure(843);clf;
        scatter(theseelevs,raymondtestsfc-raymondtest850);
        end
        %%%
        
        
        
        %Include elevations to produce final MSE profiles
        temphere=fliplr(msep9Xera5(regloop,1:gothru(regloop)));
        addition=9.81.*flipud(avgelevs_era5levs(1:gothru(regloop)))'./1000;
        msep9Xera5(regloop,1:gothru(regloop))=temphere+addition;
        temphere=fliplr(mse_remainderera5(regloop,1:gothru(regloop)));
        mse_remainderera5(regloop,1:gothru(regloop))=temphere+addition;
        
        %Moist adiabiatic lapse rate (MALR) at hour of max Tw in this region
        for j=2:gothru(regloop)
            malrp9Xera5(regloop,j-1)=1000*(tmeanprofilep9Xera5(j)-tmeanprofilep9Xera5(j-1))/(abs(avgelevs_era5levs(j)-avgelevs_era5levs(j-1)));
            malr_remainderera5(regloop,j-1)=1000*(tmeanprofile_remainderera5(j)-tmeanprofile_remainderera5(j-1))/(abs(avgelevs_era5levs(j)-avgelevs_era5levs(j-1)));
        end
        
        %Compare to saturation MSE profile, following Larson & Hartmann 2003 (vertical line would mean that atmos T profile ~ moist adiabat)
        lv=1918.46.*((tmeanprofilep9Xera5./(tmeanprofilep9Xera5-33.91)).^2);
        satq=calcqfromTd_dynamicP(tmeanprofilep9Xera5-273.15,100.*pres);
        ql_satp9X=lv.*satq./1000;
        tempthing1{regloop}=qhp9X;tempthing2{regloop}=ql_satp9X;
        saturationmsep9Xera5(regloop,1:gothru(regloop))=qhp9X(1:end-1)*1000+ql_satp9X(1:end-1)*1000+9.81.*avgelevs_era5levs(1:gothru(regloop))';
        saturationmsep9Xera5(regloop,gothru(regloop)+1)=qhp9X(end)*1000+ql_satp9X(end)*1000+0;
        saturationmsep9X_noelev(regloop,1:gothru(regloop))=qhp9X(1:end-1)*1000+ql_satp9X(1:end-1)*1000;
        saturationmsep9X_noelev(regloop,gothru(regloop)+1)=qhp9X(end)*1000+ql_satp9X(end)*1000;
        
        lv=1918.46.*((tmeanprofile_remainderera5./(tmeanprofile_remainderera5-33.91)).^2);
        satq=calcqfromTd_dynamicP(tmeanprofile_remainderera5-273.15,100.*pres);
        ql_sat_remainder=lv.*satq./1000;
        tempthing1{regloop}=qh_remainder;tempthing2{regloop}=ql_sat_remainder;
        saturationmse_remainderera5(regloop,1:gothru(regloop))=qh_remainder(1:end-1)*1000+...
            ql_sat_remainder(1:end-1)*1000+9.81.*avgelevs_era5levs(1:gothru(regloop))';
        saturationmse_remainderera5(regloop,gothru(regloop)+1)=qh_remainder(end)*1000+ql_sat_remainder(end)*1000+0;
        saturationmse_remainder_noelev(regloop,1:gothru(regloop))=qh_remainder(1:end-1)*1000+ql_sat_remainder(1:end-1)*1000;
        saturationmse_remainder_noelev(regloop,gothru(regloop)+1)=qh_remainder(end)*1000+ql_sat_remainder(end)*1000;
        
        tp9Xera5(regloop,1:gothru(regloop)+1)=tmeanprofilep9Xera5;
        qp9Xera5(regloop,1:gothru(regloop)+1)=qmeanprofilep9Xera5;
        t_remainderera5(regloop,1:gothru(regloop)+1)=tmeanprofile_remainderera5;
        q_remainderera5(regloop,1:gothru(regloop)+1)=qmeanprofile_remainderera5;
    end
    invalid=msep9Xera5==0;msep9Xera5(invalid)=NaN;
    invalid=mse_remainderera5==0;mse_remainderera5(invalid)=NaN;
    
    if readsoundings==1
        save('/Volumes/ExternalDriveZ/ERA5_Hourly_Data/vertprofilearrays','twcompositesoundings','tcompositesoundings','tdcompositesoundings',...
        'winddircompositesoundings','windspdcompositesoundings','msecompositesoundings','numsoundinglevels','-append');
    end
        
    
    %Flip around MSE arrays which were improperly flipped...
    for reg=1:7
        msep9Xera5(reg,1:gothru(reg))=fliplr(msep9Xera5(reg,1:gothru(reg)));
        mse_remainderera5(reg,1:gothru(reg))=fliplr(mse_remainderera5(reg,1:gothru(reg)));
    end
    
    %Adjust profiles between 1000 and 850 mb, to reconcile sfc & non-sfc values (silly ERA5...)
    %Specifically: 
    %when sfc is 1000, adjust 975 by 5/6 of the discrepancy, 950 by 4/6, 900 by 2/6
    %when sfc is 975, adjust 950 by 4/5 of the discrepancy, 900 by 2/5
    %when sfc is 950, adjust 900 by 1/2 of the discrepancy
    msep9Xera5unadj=msep9Xera5;mse_remainderera5unadj=mse_remainderera5;
    saturationmsep9Xera5unadj=saturationmsep9Xera5;saturationmse_remainderera5unadj=saturationmse_remainderera5;
    tp9Xera5unadj=tp9Xera5;t_remainderera5unadj=t_remainderera5;
    qp9Xera5unadj=qp9Xera5;q_remainderera5unadj=q_remainderera5;
    for regloop=1:7
        for myloop=1:8
            if myloop==1
                thisprof=msep9Xera5(regloop,1:gothru(regloop)+1);
            elseif myloop==2
                thisprof=saturationmsep9Xera5(regloop,1:gothru(regloop)+1);
            elseif myloop==3
                thisprof=tp9Xera5(regloop,1:gothru(regloop)+1);
            elseif myloop==4
                thisprof=qp9Xera5(regloop,1:gothru(regloop)+1);
            elseif myloop==5
                thisprof=mse_remainderera5(regloop,1:gothru(regloop)+1);
            elseif myloop==6
                thisprof=saturationmse_remainderera5(regloop,1:gothru(regloop)+1);
            elseif myloop==7
                thisprof=t_remainderera5(regloop,1:gothru(regloop)+1);
            elseif myloop==8
                thisprof=q_remainderera5(regloop,1:gothru(regloop)+1);
            end
            
            discrepancy=thisprof(gothru(regloop))-thisprof(gothru(regloop)+1); %positive discrepancy means surface-pressure value (e.g. at 1000 mb) is greater than 2-m value
            newprof=thisprof;
            if gothru(regloop)==9 %sfc=1000 mb
                newprof(gothru(regloop))=thisprof(gothru(regloop))-discrepancy;
                newprof(gothru(regloop)-1)=thisprof(gothru(regloop)-1)-0.83*discrepancy;
                newprof(gothru(regloop)-2)=thisprof(gothru(regloop)-2)-0.67*discrepancy;
                newprof(gothru(regloop)-3)=thisprof(gothru(regloop)-3)-0.33*discrepancy;
            elseif gothru(regloop)==8 %sfc=975 mb
                newprof(gothru(regloop))=thisprof(gothru(regloop))-discrepancy;
                newprof(gothru(regloop)-1)=thisprof(gothru(regloop)-1)-0.8*discrepancy;
                newprof(gothru(regloop)-2)=thisprof(gothru(regloop)-2)-0.4*discrepancy;
            elseif gothru(regloop)==7 %sfc=950 mb
                newprof(gothru(regloop))=thisprof(gothru(regloop))-discrepancy;
                newprof(gothru(regloop)-1)=thisprof(gothru(regloop)-1)-0.5*discrepancy;
            end
            
            if myloop==1
                msep9Xera5(regloop,1:gothru(regloop)+1)=newprof;
            elseif myloop==2
                saturationmsep9Xera5(regloop,1:gothru(regloop)+1)=newprof;
            elseif myloop==3
                tp9Xera5(regloop,1:gothru(regloop)+1)=newprof;
            elseif myloop==4
                qp9Xera5(regloop,1:gothru(regloop)+1)=newprof;
            elseif myloop==5
                mse_remainderera5(regloop,1:gothru(regloop)+1)=newprof;
            elseif myloop==6
                saturationmse_remainderera5(regloop,1:gothru(regloop)+1)=newprof;
            elseif myloop==7
                t_remainderera5(regloop,1:gothru(regloop)+1)=newprof;
            elseif myloop==8
                q_remainderera5(regloop,1:gothru(regloop)+1)=newprof;
            end
        end
    end
    save('/Volumes/ExternalDriveZ/ERA5_Hourly_Data/vertprofilearrays','msep9Xera5','mse_remainderera5','malrp9Xera5','malr_remainderera5',...
        'saturationmsep9Xera5','tp9Xera5','qp9Xera5','t_remainderera5','q_remainderera5','msep9Xera5unadj','saturationmsep9Xera5unadj',...
        'tp9Xera5unadj','qp9Xera5unadj','saturationmse_remainderera5','saturationmse_remainderera5unadj',...
        't_remainderera5unadj','q_remainderera5unadj','mse_remainderera5unadj','newarrwithtprofilep9X','newarrwithqprofilep9X',...
        'newarrwithtprofile_remainder','newarrwithqprofile_remainder','newsavethedatesandlocsp9X','newsavethedatesandlocs_remainder',...
        'newiiconversion','newiiconversion_remainder','-append');
    save('/Volumes/ExternalDriveZ/ERA5_Hourly_Data/regionmetadata','actualrowstarts','actualrowstops','actualcolstarts','actualcolstops','-append');
    
    
    
    makeplots=0;
    if makeplots==1
        
    colorstouse=[colors('green');colors('blue');colors('gray');colors('purple');colors('forest green');colors('red');colors('orange')];
    
    figure(8031);clf;curpart=1;highqualityfiguresetup;
    for reg=1:7
        y=fliplr(pressures_forsoundings);
        y1=y((10-numsoundinglevels(reg))+1:end);
        %x1=msecompositesoundings{reg}(1,10-numsoundinglevels(reg)+1:end)-msecompositebyreg{reg}(1,10-numsoundinglevels(reg)+1);
        x1temp=msecompositesoundings{reg}(1,10-numsoundinglevels(reg)+1:end);
        x1addition=9.81.*flipud(avgelevs_soundinglevs(1:numsoundinglevels(reg)))'./1000;
        x1usual=x1temp+x1addition;
        x1=x1usual-x1usual(1);
        plot(x1,y1,'color',colorstouse(reg,:),'linewidth',1.5,'linestyle','--','marker','none');hold on;
        %yticklabels(y1);
        set(gca,'YDir','reverse');
        if reg==7;set(gca,'ytick',[pressures_forsoundings(1:8) 995]);end
        ylabel('Pressure (mb) for Soundings');
        ylim([200 1000]);
        set(gca,'YDir','reverse');
        if reg==7;yticklabels(fliplr([995 y1(3:10)]));end
        
        
        yyaxis right;
        y=fliplr(pressures_forera5);
        y2=y(9-gothru(reg)+1:end);
        %x2temp=fliplr(msep9Xera5(reg,1:gothru(reg)));
        %x2addition=9.81.*flipud(avgelevs_era5levs(1:gothru(reg)))'./1000;
        %x2usual=x2temp+x2addition;
        x2usual=msep9Xera5(reg,1:gothru(reg));
        x2=x2usual-x2usual(1);
        plot(x2,y2,'color',colorstouse(reg,:),'linestyle','-','linewidth',2,'marker','none');
        t=text(0.8,1-0.04*reg,regnames{reg},'color',colorstouse(reg,:),'units','normalized');
            set(t,'fontsize',12,'fontweight','bold','fontname','arial');
        set(gca,'ytick',pressures_forera5);
        set(gca,'YDir','reverse');
        yticklabels(fliplr(y2));
        ylabel('Pressure (mb) for ERA5');
        
        yyaxis left;
        if reg==7;yticklabels(fliplr([995 y1(3:10)]));end
    end
    %text(0.8,0.64,'Solid: Soundings','units','normalized','fontweight','bold','fontsize',12,'fontname','arial');
    %text(0.8,0.6,'Dashed: ERA5','units','normalized','fontweight','bold','fontsize',12,'fontname','arial');
    xlabel('MSE Difference from Lowest Available Level (J/kg)');
    set(gca,'fontsize',12,'fontweight','bold','fontname','arial');
    figname='vertprofiles_withsoundings_reltosfc';curpart=2;highqualityfiguresetup;
    
    figure(8032);clf;curpart=1;highqualityfiguresetup;
    for reg=1:7
        y=fliplr(pressures_forera5);
        y2=y(9-gothru(reg)+1:end);
        x2temp=fliplr(msep9Xera5(reg,1:gothru(reg)));
        x2addition=9.81.*flipud(avgelevs_era5levs(1:gothru(reg)))'./1000;
        x2=x2temp+x2addition;
        %x2=msep9Xera5(reg,1:gothru(reg));
        plot(x2,y2,'color',colorstouse(reg,:),'linestyle','-','linewidth',2,'marker','none');hold on;
        
        x3temp=fliplr(mse_remainderera5(reg,1:gothru(reg)));
        x3=x3temp+x2addition;
        %x3=mse_remainderera5(reg,1:gothru(reg));
        plot(x3,y2,'color',colorstouse(reg,:),'linestyle','-.','linewidth',1.5,'marker','none');
       
        
        t=text(0.7,1-0.04*reg,regnames{reg},'color',colorstouse(reg,:),'units','normalized');
            set(t,'fontsize',12,'fontweight','bold','fontname','arial');
        set(gca,'ytick',pressures_forera5);
        set(gca,'YDir','reverse');
        yticklabels(fliplr(y2));
        ylabel('Pressure (mb)');
    end
    %text(0.58,0.64,'Solid: Days with MSE > Global p99.5','units','normalized','fontweight','bold','fontsize',12,'fontname','arial');
    %text(0.58,0.6,'Dashed-Dotted: Comparable Non-Extreme Days','units','normalized','fontweight','bold','fontsize',12,'fontname','arial');
    xlabel('MSE (J/kg)');
    set(gca,'fontsize',12,'fontweight','bold','fontname','arial');
    figname='vertprofiles_withnonextreme';curpart=2;highqualityfiguresetup;
    
    figure(82);clf;curpart=1;highqualityfiguresetup;
    relstartxpos=[0;0.12;-0.13;-0.02;0.05;0.15;0.03];
    plotcircles=0;
    for reg=1:7
        subplot(1,7,reg);
        y=fliplr(pressures_forera5);
        y2=y(9-gothru(reg)+1:end);
        %x2temp=fliplr(msep9Xera5(reg,1:gothru(reg)));
        %x2addition=9.81.*flipud(avgelevs_era5levs(1:gothru(reg)))'./1000;
        %x2=x2temp+x2addition;
        x2=fliplr(msep9Xera5(reg,1:gothru(reg)));
        plot(x2,y2,'color',colorstouse(reg,:),'linestyle','-','linewidth',1.5,'marker','none');hold on;
        
        t=text(relstartxpos(reg),1.05,regnames_shorter{reg},'color',colorstouse(reg,:),'units','normalized');
            set(t,'fontsize',12,'fontweight','bold','fontname','arial');
        set(gca,'ytick',pressures_forera5);
        set(gca,'YDir','reverse');
        yticklabels([]);
        if reg==1;ylabel('Pressure (mb)');end
        xlim([220 400]);
        set(gca,'fontsize',11,'fontweight','bold','fontname','arial');
        ax1=gca;ax1.XColor=colorstouse(reg,:);ax1.YColor=colorstouse(reg,:);
        %xlabel('MSE (J/kg)');
        
        %Circle represents 2-m conditions
        if plotcircles==1
        th=0:pi/50:2*pi;centerx=msep9Xera5(reg,gothru(reg)+1);
        if gothru(reg)==9;centery=997.5;elseif gothru(reg)==8;centery=972.5;else;centery=947.5;end
        xunit=5*cos(th)+centerx;yunit=5*sin(th)+centery;
        plot(xunit,yunit);fill(xunit,yunit,colorstouse(reg,:));ylim([200 1005]);
        end
        
        %ax1pos=ax1.Position;
        %ax2=axes('Position',ax1pos,'XAxisLocation','top','YAxisLocation','right','Color','none');
        x3=fliplr(saturationmsep9Xera5(reg,1:gothru(reg)));
        y3=y2;hold on;
        %plot(x3./1000,y3,'Parent',ax2,'Color','k','linestyle','-','linewidth',1.5,'marker','none');
        plot(x3./1000,y3,'Color','k','linestyle','-','linewidth',1.5,'marker','none');
        
        set(gca,'ytick',pressures_forera5);
        set(gca,'YDir','reverse');
        yticklabels(fliplr(y2));
        xlim([300 425]);
        %ax2.XColor = colors('black');ax2.YColor = colors('black');
        %xlabel('Sat. MSE (kJ/kg)');
        %Circle represents 2-m saturation MSE
        if plotcircles==1
        th=0:pi/50:2*pi;centerx=saturationmsep9Xera5(reg,gothru(reg)+1)./1000;
        if gothru(reg)==9;centery=997.5;elseif gothru(reg)==8;centery=972.5;else;centery=947.5;end
        xunit=5*cos(th)+centerx;yunit=5*sin(th)+centery;
        plot(xunit,yunit);fill(xunit,yunit,'k');ylim([200 1005]);
        end
        
        if reg==3
            t=text(1.3,-0.06,'MSE (J/kg) [colors]','units','normalized','fontsize',12,'fontweight','bold','fontname','arial');set(t,'color',colors('pink'));
            text(1.2,-0.1,'Saturation MSE (J/kg)','units','normalized','fontsize',12,'fontweight','bold','fontname','arial');
        end
        
        set(gca,'fontsize',9,'fontweight','bold','fontname','arial');
    end
    figname='vertprofiles_withsaturation';curpart=2;highqualityfiguresetup;
    
    
    figure(804);clf;
    clear ptlist;
    for reg=2:7
        temp=squeeze(newsavethedatesandlocsp9X{reg});
        if size(temp,1)~=1
            temp=sortrows(temp,[3 4]);
            prevpt=[0 0];ptc=0;
            for i=1:size(temp,1)
                if temp(i,3)~=prevpt(1) || temp(i,4)~=prevpt(2) %new point
                    ptc=ptc+1;
                    ptlist{reg}(ptc,1:2)=temp(i,3:4);
                    ptlist{reg}(ptc,3)=1;
                    ptlist{reg}(ptc,4)=elevtouse(temp(i,3),temp(i,4));
                    prevpt=temp(i,3:4);
                else %same point
                    ptlist{reg}(ptc,3)=ptlist{reg}(ptc,3)+1;
                end
            end
        end
    end
    scatter(ptlist{reg}(:,3),ptlist{reg}(:,4)); %frequency (x) vs elevation (y)
    end
end

%Model-level data
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
            %for i=1:549469;if arrwithallp99(i,3)>=405 && arrwithallp99(i,3)<=445 && arrwithallp99(i,4)>=1253 && arrwithallp99(i,4)<=1292;disp(i);end;end
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
                                    %indexincluded(i)=1;
                                    %pblhcindex(pblhc,1)=year;
                                    %pblhcindex(pblhc,2)=i;
                                    newregsubset(pblhc,:)=thisyearonly(i,:);
                                end
                                %if pblhc==100;disp('line 4115');return;end
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

        %Ensure days line up between regsubset and arrwithpblh_daily --
        %this requires removing only those days with indexincluded==0,
        %currently just 15420 of regsubset (day 365, 2007)
        %thisyearonly_trim=[regsubset(1:15419,:);regsubset(15421:end,:)];
        %thisyearonly_trim=thisyearonly;
                
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
            %if currow==430 && curcol==1276;return;end %for troubleshooting
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
            %if currow==430 && curcol==1276;return;end %for troubleshooting
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
        
        disp('line 4265');disp(regloop);disp(clock);
    end
    save('/Volumes/ExternalDriveZ/ERA5_Hourly_Data/pblhforprofiles.mat','pblhmeanprofileextremedays','pblhdistnprofileextremedays',...
        'regsubsetexpalltogether','pblhmeanprofileremainderdays','pblhdistnprofileremainderdays','regsubsetexpalltogether_remainder','-append');
        
    %Regional medians
    %temp=pblhmeanp999(240:266,194:229);temp=reshape(temp,[size(temp,1)*size(temp,2),1]);
    %persiangulf=quantile(temp,0.5);
    %temp=pblhmeanp999(228:254,270:289);temp=reshape(temp,[size(temp,1)*size(temp,2),1]);
    %pakistan=quantile(temp,0.5);
    %temp=pblhmeanp999(250:300,315:395);temp=reshape(temp,[size(temp,1)*size(temp,2),1]);
    %eastindiabangladesh=quantile(temp,0.5);
    %temp=pblhmeanp999(245:267,1000:1022);temp=reshape(temp,[size(temp,1)*size(temp,2),1]);
    %gulfofcalifornia=quantile(temp,0.5);
    %temp=pblhmeanp999(370:435,1140:1195);temp=reshape(temp,[size(temp,1)*size(temp,2),1]);
    %westamazon=quantile(temp,0.5);
    %temp=pblhmeanp999(262:303,137:180);temp=reshape(temp,[size(temp,1)*size(temp,2),1]);
    %redsea=quantile(temp,0.5);
    %temp=pblhmeanp999(420:440,540:576);temp=reshape(temp,[size(temp,1)*size(temp,2),1]);
    %northaustralia=quantile(temp,0.5);
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
            datafile=load(strcat('/Volumes/ExternalDriveZ/ERA5_Hourly_Data/msedailymaxarray',num2str(year)));

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
    save('/Volumes/ExternalDriveZ/ERA5_HHLcalcs/timeofmaxmseNEW','finalmaxyears','finalmaxdoys','-append');
    clear bigmsearray_resh;
end







if timelineaddition_smonly==1
    rowstems={'rows1to100';'rows101to200';'rows201to300';'rows301to400';'rows401to500';'rows501to600';'rows601to700';'rows701to721'};
    colinc=zeros(721,1440);raymondc=zeros(721,1440);
    
    exist weightsforeach;
    if ans==0
        temp=load('/Volumes/ExternalDriveZ/ERA5_HHLcalcs/percentilesofothervariables.mat');weightsforeach=temp.weightsforeach;
    end
    
    exist topdays;
    if ans==0
        temp=load('/Volumes/ExternalDriveZ/ERA5_Hourly_Data/climtopmsedays');topdays=temp.topdays;
    end
    
    exist p99msebypoint;
    if ans==0
        thisfile=load('/Volumes/ExternalDriveZ/ERA5_Hourly_Data/mseqhqlstats');
        maxmsebypoint=thisfile.maxmsebypoint;p999msebypoint=thisfile.p999msebypoint;p99msebypoint=thisfile.p99msebypoint;p95msebypoint=thisfile.p95msebypoint;p50msebypoint=thisfile.p50msebypoint;
    end
    
        
    for year=2014:2018
        msefile=load(strcat('/Volumes/ExternalDriveZ/ERA5_Hourly_Data/msedailymaxarray',num2str(year)));
        %Load daily MSE data
        msedata1=eval(['msefile.dailymaxmse' rowstems{1} ';']);msedata2=eval(['msefile.dailymaxmse' rowstems{2} ';']);
        msedata3=eval(['msefile.dailymaxmse' rowstems{3} ';']);msedata4=eval(['msefile.dailymaxmse' rowstems{4} ';']);
        msedata5=eval(['msefile.dailymaxmse' rowstems{5} ';']);msedata6=eval(['msefile.dailymaxmse' rowstems{6} ';']);
        msedata7=eval(['msefile.dailymaxmse' rowstems{7} ';']);msedata8=eval(['msefile.dailymaxmse' rowstems{8} ';']);clear msefile;
        msedata=cat(2,msedata1,msedata2,msedata3,msedata4,msedata5,msedata6,msedata7,msedata8); %centered on Date Line
        clear msedata1;clear msedata2;clear msedata3;clear msedata4;clear msedata5;clear msedata6;clear msedata7;clear msedata8;
        disp('Finished MSE reading for timelineaddition');
        
        %Load temperature, dewpoint, and surface pressure
        file=ncgeodataset(strcat('/Volumes/ExternalDriveZ/ERA5_Hourly_Data/ttd_world_',num2str(year),'.grib'));
        ttemp=file{'2_metre_temperature_surface'};echo off;
        tdtemp=file{'2_metre_dewpoint_temperature_surface'};echo off;clear file;
        psfcfile=ncgeodataset(strcat('/Volumes/ExternalDriveC/ERA5_Hourly_Data_PandGHonly/psfc_world_',num2str(year),'.grib'));
        psfctemp=psfcfile{'Surface_pressure_surface'};echo off;clear psfcfile;
        
        %Load daily soil-moisture data
        file=ncgeodataset(strcat('/Volumes/ExternalDriveD/ERA5_variousvariables/soilmoisture_world_',num2str(year),'.grib'));
        smtemp=file{'Volumetric_soil_water_layer_1_layer_between_two_depths_below_surface_layer'};echo off;clear file;
        
        
        for k=1:1440
            for j=1:721
                randindex=randperm(90,1);
                wsday(j,k)=topdays(randindex,j,k);
            end
        end
        
        
        finaldaystaken=cell(721,1440);finalcenterdays=cell(721,1440);
        
        %Get data for each day in this year
        maxdailymse=NaN.*ones(size(msedata,1)-1,721,1440);
        for i=1:size(msedata,1)-1
            if (i>=38 && i<=73) || (i>=111 && i<=146) || ...
                    (i>=184 && i<=219) || (i>=257 && i<=292) || (i>=330)
                adj=4;
            else
                adj=0;
            end
            
            t=double(ttemp.data(i*8-7-adj:i*8-adj,:,:));
            td=double(tdtemp.data(i*8-7-adj:i*8-adj,:,:))-273.15;
            psfc=squeeze(double(psfctemp.data(i*8-7-adj:i*8-adj,:,:)));clear newpsfc;
            for h=1:size(psfc,1)
                temp=squeeze(psfc(h,:,:));
                newtemp=[temp(:,721:1440) temp(:,1:720)];
                newpsfc(h,:,:)=newtemp;clear newtemp;
            end
            psfc=newpsfc;clear newpsfc;

            clear qh;clear ql;clear hourlymse;

            mr=calcmrfromvpandpsfc(calcvpfromTd(td),psfc)./1000;
            omega=calcqfromTd_dynamicP(td,psfc)./1000; %convert to unitless specific humidity
            cp=1005.7.*(1+1.83.*mr);clear mr; %J K^-1 kg^-1; Stull, Practical Meteorology
            qh=cp.*t./1000;clear cp;
            lv=1918.46.*((t./(t-33.91)).^2); %J/kg; Henderson-Sellers 1984
            ql=lv.*omega;clear lv;clear omega; %J/kg
            hourlymse=qh+ql;clear qh;clear ql;
            
            maxdailymse(i,:,:)=squeeze(max(hourlymse));  
        end
        disp('At line 7648, done with part I for timelineaddition');disp(clock);
        
        %Sort by day -- this is to ensure that time traces aren't contaminated with other extreme days (20 min)
        for k=1:1440
            for j=1:721
                thisdata=squeeze(maxdailymse(:,j,k));
                A=[thisdata (1:364)'];B=sortrows(A,'descend');
                %Get list of days to use, keeping a 2-day berth around each
                clear daystaken;clear centerdays;
                daystaken=[B(1,2)-2:B(1,2)+2];centerdays=[B(1,2)];
                for row=2:364
                    if ~ismember(B(row,2)-2,daystaken) && ~ismember(B(row,2)-1,daystaken) && ~ismember(B(row,2),daystaken) &&...
                            ~ismember(B(row,2)+1,daystaken) && ~ismember(B(row,2)+2,daystaken)
                        daystaken=[daystaken B(row,2)-2:B(row,2)+2];
                        centerdays=[centerdays B(row,2)];
                    end
                end
                finaldaystaken{j,k}=daystaken;
                finalcenterdays{j,k}=centerdays;
            end
        end
        clear maxdailymse;
        disp('At line 7670, done with part II for timelineaddition');disp(clock);
        
        
        
        %If values exceed the LOCAL p99 MSE, then get assoc subdaily variables
        %Otherwise, if they're below, get assoc values for these randomly selected 'non-extreme' warm-season days
        disp(clock);
        for doy=3:363 %to avoid end-of-year problems
            if (doy>=38 && doy<=73) || (doy>=111 && doy<=146) || ...
                    (doy>=184 && doy<=219) || (doy>=257 && doy<=292) || (doy>=330)
                adj=4;
            else
                adj=0;
            end
            
            monofdoy=DOYtoMonth(doy,year);domofdoy=DOYtoDOM(doy,year);
        
            if (doy>=3 && doy<=35) || (doy>=40 && doy<=71) || (doy>=76 && doy<=108) || (doy>=113 && doy<=144) ||...
                        (doy>=149 && doy<=181) || (doy>=186 && doy<=217) || (doy>=222 && doy<=254) ||...
                        (doy>=259 && doy<=290) || (doy>=295 && doy<=327) || (doy>=332 && doy<=363)
                %Retrieve data at the start of a segment of days
                if doy==3 %this will be good up to and including doy==35
                    firstindex=1*8-7;lastindex=37*8;
                elseif doy==40 %this will be good through doy==71
                    firstindex=38*8-7;lastindex=73*8;
                elseif doy==76 %this will be good through doy==108
                    firstindex=74*8-7;lastindex=110*8;
                elseif doy==113
                    firstindex=111*8-7;lastindex=146*8;
                elseif doy==149
                    firstindex=147*8-7;lastindex=183*8;
                elseif doy==186
                    firstindex=184*8-7;lastindex=219*8;
                elseif doy==222
                    firstindex=220*8-7;lastindex=256*8;
                elseif doy==259
                    firstindex=257*8-7;lastindex=292*8;
                elseif doy==295
                    firstindex=293*8-7;lastindex=329*8;
                elseif doy==332
                    firstindex=330*8-7;lastindex=365*8;
                end     

                if doy==3 || doy==40 || doy==76 || doy==113 || doy==149 || doy==186 || doy==222 ||...
                        doy==259 || doy==295 || doy==332
                    t=double(ttemp.data(firstindex:lastindex,beginrow:endrow,begincol:endcol));
                    td=double(tdtemp.data(firstindex:lastindex,beginrow:endrow,begincol:endcol))-273.15;
                    psfc=squeeze(double(psfctemp.data(firstindex:lastindex,:,:)));
                    psfc=circshift(psfc,[0 0 721]); %shift columns so array is centered on 180
                    psfc=psfc(:,beginrow:endrow,begincol:endcol);
                    
                    mr=calcmrfromvpandpsfc(calcvpfromTd(td),psfc)./1000;
                    omega=calcqfromTd_dynamicP(td,psfc)./1000;clear psfc; %convert to unitless specific humidity
                    cp=1005.7.*(1+1.83.*mr);clear mr; %J K^-1 kg^-1; Stull, Practical Meteorology
                    qh=cp.*t./1000;clear cp;
                    lv=1918.46.*((t./(t-33.91)).^2); %J/kg; Henderson-Sellers 1984
                    ql=lv.*omega;clear lv;clear omega; %J/kg
                    hourlymse=qh+ql;clear qh;clear ql;
                    
                    arrsz=size(t,1);

                    smdata=squeeze(double(smtemp.data(firstindex:lastindex,1,:,:)));
                    smdata=cat(2,NaN.*ones(arrsz,200,1440),smdata,NaN.*ones(arrsz,200,1440));
                    smdata=circshift(smdata,[0 0 721]); %shift columns so array is centered on 180
                    smdata=smdata(:,beginrow:endrow,begincol:endcol);
                end
                
                
                nr=endrow-beginrow+1;nc=endcol-begincol+1;
                datestimelineTEMP=NaN.*ones(arrsz,nr,nc);
                msetimelineTEMP=NaN.*ones(arrsz,nr,nc);
                smtimelineTEMP=NaN.*ones(arrsz,nr,nc);
                
                if doy<=35
                    thisdayrelative=doy;
                elseif doy<=71
                    thisdayrelative=doy-37;
                elseif doy<=108
                    thisdayrelative=doy-73;
                elseif doy<=144
                    thisdayrelative=doy-110;
                elseif doy<=181
                    thisdayrelative=doy-146;
                elseif doy<=217
                    thisdayrelative=doy-183;
                elseif doy<=254
                    thisdayrelative=doy-219;
                elseif doy<=290
                    thisdayrelative=doy-256;
                elseif doy<=327
                    thisdayrelative=doy-292;
                elseif doy<=363
                    thisdayrelative=doy-329;
                end

                extremedays=squeeze(msedata(doy,beginrow:endrow,begincol:endcol))>=p99msebypoint(beginrow:endrow,begincol:endcol); 
                extrdays_3D=repmat(extremedays,[1 1 arrsz]);clear extremedays; %is this day an extreme one?
                extrdays_3D=permute(extrdays_3D,[3 1 2]);
                
                datestimelineTEMP=[(doy-2).*ones(8,1);(doy-1).*ones(8,1);doy.*ones(8,1);(doy+1).*ones(8,1);(doy+2).*ones(8,1)];
                datestimelineTEMP=repmat(datestimelineTEMP,[1 nr nc]);
                
                
                msetimelineTEMP(extrdays_3D)=hourlymse(extrdays_3D);
                smtimelineTEMP(extrdays_3D)=smdata(extrdays_3D);clear extrdays_3D;

                for k=begincol:endcol
                    for j=beginrow:endrow
                        if sum(~isnan(msetimelineTEMP(:,j-(beginrow-1),k-(begincol-1))))>0 && sum(msetimelineTEMP(:,j-(beginrow-1),k-(begincol-1)))~=0
                            colinc(j,k)=colinc(j,k)+1;
                            datestimeline{j,k}(colinc(j,k),:)=datestimelineTEMP(:,j-(beginrow-1),k-(begincol-1));
                            msetimeline{j,k}(colinc(j,k),:)=msetimelineTEMP((thisdayrelative-2)*8-7:(thisdayrelative+2)*8,j-(beginrow-1),k-(begincol-1));
                            smtimeline{j,k}(colinc(j,k),:)=smtimelineTEMP((thisdayrelative-2)*8-7:(thisdayrelative+2)*8,j-(beginrow-1),k-(begincol-1));

                            [~,timeofmax]=max(msetimelineTEMP(17:24,j-(beginrow-1),k-(begincol-1)));
                        end
                    end
                end
                clear smtimelineTEMP;clear msetimelineTEMP;clear datestimelineTEMP;
                
                for k=begincol:endcol
                    for j=beginrow:endrow
                        dothis=1;
                        if dothis==1
                        if doy==wsday(j,k)
                            raymondc(j,k)=raymondc(j,k)+1;
                            msetimelinenonextr{j,k}(raymondc(j,k),:)=hourlymse((thisdayrelative-2)*8-7:(thisdayrelative+2)*8,j-(beginrow-1),k-(begincol-1));
                            smtimelinenonextr{j,k}(raymondc(j,k),:)=smdata((thisdayrelative-2)*8-7:(thisdayrelative+2)*8,j-(beginrow-1),k-(begincol-1));

                            [~,timeofmax]=max(hourlymse(17:24,j-(beginrow-1),k-(begincol-1)));
                        end
                        end
                    end
                end
            end
            if rem(doy,30)==0;fprintf('Doy is %d\n',doy);end
        end
        clear smtemp;clear hourlymse;
        
        smtimelineFINAL=cell(721,1440);smtimelinenonextrFINAL=cell(721,1440);datestimelineFINAL=cell(721,1440);
        
        for k=begincol:endcol
            for j=beginrow:endrow
                newrowc=0;
                for row=1:size(datestimeline{j,k},1)
                    if ismember(datestimeline{j,k}(row,20),finalcenterdays{j,k})
                        newrowc=newrowc+1;
                        datestimelineFINAL{j,k}(newrowc,:)=datestimeline{j,k}(row,:);
                        smtimelineFINAL{j,k}(newrowc,:)=smtimeline{j,k}(row,:);
                    end
                end
                    
                newrowcnonextr=0;
                for row=1:size(msetimelinenonextr{j,k},1)
                    newrowcnonextr=newrowcnonextr+1;
                    smtimelinenonextrFINAL{j,k}(newrowcnonextr,:)=smtimelinenonextr{j,k}(row,:);
                end
            end
        end
        clear ttemp;clear tdtemp;clear psfctemp;
        fprintf('At line 7827, done with part III for timelineaddition and year %d\n',year);disp(clock);
        
        save(strcat('/Volumes/ExternalDriveZ/ERA5_HHLcalcs/timetracesarraysforyearSOILMOISTUREONLY',num2str(year),'.mat'),...
            'smtimelineFINAL','smtimelinenonextrFINAL','datestimelineFINAL');
    end
    disp('Please run remainder of loop manually.');return;
    
    %Eliminate duplicate rows and combine years together!! (10 min)
    %Note that 2016 and 2018 currently have wrong Psfc values and thus MSE
    %values, but this in principle does not affect the anomalies or the comparison of variables
    yearstoload=[2014;2015;2016];
    for i=1:size(yearstoload,1) %2 min
        year=yearstoload(i);
        thisfile=load(strcat('/Volumes/ExternalDriveZ/ERA5_HHLcalcs/timetracesarraysforyearSOILMOISTUREONLY',num2str(year),'.mat'));
        eval(['smtimelineFINAL' num2str(i) '=thisfile.smtimelineFINAL;']);
        eval(['smtimelinenonextrFINAL' num2str(i) '=thisfile.smtimelinenonextrFINAL;']);
    end
    smmerged=cell(721,1440);smmergednonextr=cell(721,1440);
    for k=begincol:endcol
        for j=beginrow:endrow
            %Remove duplicate rows, then combine across years
            unik1=unique(smtimelineFINAL1{j,k},'rows');unik2=unique(smtimelineFINAL2{j,k},'rows');unik3=unique(smtimelineFINAL3{j,k},'rows');smmerged{j,k}=cat(1,unik1,unik2);
            unik1=unique(smtimelinenonextrFINAL1{j,k},'rows');unik2=unique(smtimelinenonextrFINAL2{j,k},'rows');unik3=unique(smtimelinenonextrFINAL3{j,k},'rows');
                smmergednonextr{j,k}=cat(1,unik1,unik2);
        end
    end
    
    
    
    %Get gridpt means (2 min)
    smmean=NaN.*ones(721,1440,40);smmeannonextr=NaN.*ones(721,1440,40);
    for k=begincol:endcol
        for j=beginrow:endrow
            if size(smmerged{j,k},1)>=1
                invalid=smmerged{j,k}==0;smmerged{j,k}(invalid)=NaN;
                smmean(j,k,:)=mean(smmerged{j,k},1,'omitnan');
            end
            
            if size(smmergednonextr{j,k},1)>=1
                invalid=smmergednonextr{j,k}==0;smmergednonextr{j,k}(invalid)=NaN;
                smmeannonextr(j,k,:)=mean(smmergednonextr{j,k},1,'omitnan');
            end
        end
    end
    save('/Volumes/ExternalDriveZ/ERA5_HHLcalcs/timetracesSOILMOISTUREONLY.mat','smmean','smmeannonextr');
    
    %Regional means (10 sec)
    clear smmean_here;clear smmeannonextr_here;
    for regnum=1:5
        if regnum~=4
        if regnum>=1 && regnum<=5 %a previously defined (e.g. hotspot) region
            row1=actualrowstarts(regnum);row2=actualrowstops(regnum);col1=actualcolstartsalt(regnum)-0.5;col2=actualcolstopsalt(regnum)+0.5;
            if regnum==5;regord=4;else;regord=regnum;end %Amazon will be 4th region plotted
        elseif regnum==10 %other coordinates
            row1=450;row2=520;col1=1250;col2=1350;regord=5;
        end

        smmean_here(regord,:)=squeeze(mean(mean(smmean(row1:row2,col1:col2,:),'omitnan'),'omitnan'));
        smmeannonextr_here(regord,:)=squeeze(mean(mean(smmeannonextr(row1:row2,col1:col2,:),'omitnan'),'omitnan'));
        
        end
    end
    
    %Quickly get full distributions for soil moisture only (as opposed to getfulldistns loop, which laboriously does this for all variables)
    %10 min
    totalcnh=0;totalcsh=0;
    cbypt=zeros(721,1440);smtimeline=cell(721,1440);datestimeline=cell(721,1440);
    for year=2014:2018
        file=ncgeodataset(strcat('/Volumes/ExternalDriveD/ERA5_variousvariables/soilmoisture_world_',num2str(year),'.grib'));
        smtemp=file{'Volumetric_soil_water_layer_1_layer_between_two_depths_below_surface_layer'};echo off;clear file;
        
        totalcnh=totalcnh+153*8;totalcsh=totalcsh+151*8;
        for regnum=1:5
            if regnum~=4
                row1=actualrowstarts(regnum);row2=actualrowstops(regnum);col1=actualcolstarts(regnum)-0.5;col2=actualcolstops(regnum)+0.5;
                row1adj=row1-200;row2adj=row2-200;
                
                if regnum<=3
                    smdata=squeeze(double(smtemp.data(121*8-7:273*8,1,row1adj:row2adj,col1:col2)));
                else
                    smdata=cat(1,squeeze(double(smtemp.data(305*8-7:365*8,1,row1adj:row2adj,col1:col2))),squeeze(double(smtemp.data(1:90*8,1,row1adj:row2adj,col1:col2))));
                end
                
                for endhr=40:8:size(smdata,1)
                    for iwithin=1:size(smdata,2)
                        for jwithin=1:size(smdata,3)
                            cbypt(iwithin+row1-1,jwithin+col1-1)=cbypt(iwithin+row1-1,jwithin+col1-1)+1;
                            
                            smtimeline{iwithin+row1-1,jwithin+col1-1}(cbypt(iwithin+row1-1,jwithin+col1-1),:)=smdata(endhr-39:endhr,iwithin,jwithin);
                            
                            if regnum<=3
                                datestimeline{iwithin+row1-1,jwithin+col1-1}(cbypt(iwithin+row1-1,jwithin+col1-1),1)=116+endhr/8;
                                yeartimeline{iwithin+row1-1,jwithin+col1-1}(cbypt(iwithin+row1-1,jwithin+col1-1),1)=year;
                            else
                                datestimeline{iwithin+row1-1,jwithin+col1-1}(cbypt(iwithin+row1-1,jwithin+col1-1),1)=300+endhr/8;
                                if 300+endhr/8>365
                                    datestimeline{iwithin+row1-1,jwithin+col1-1}(cbypt(iwithin+row1-1,jwithin+col1-1),1)=300+endhr/8-365;
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
    
    save(strcat('/Volumes/ExternalDriveZ/ERA5_HHLcalcs/fulldistnarraysSOILMOISTUREONLY2018.mat'),'smtimeline','datestimeline','yeartimeline','-v7.3');
end


if timelineaddition_preciponly==1
    rowstems={'rows1to100';'rows101to200';'rows201to300';'rows301to400';'rows401to500';'rows501to600';'rows601to700';'rows701to721'};
    colinc=zeros(721,1440);raymondc=zeros(721,1440);
    
    exist weightsforeach;
    if ans==0
        temp=load('/Volumes/ExternalDriveZ/ERA5_HHLcalcs/percentilesofothervariables.mat');weightsforeach=temp.weightsforeach;
    end
    
    exist topdays;
    if ans==0
        temp=load('/Volumes/ExternalDriveZ/ERA5_Hourly_Data/climtopmsedays');topdays=temp.topdays;
    end
    
    exist p99msebypoint;
    if ans==0
        thisfile=load('/Volumes/ExternalDriveZ/ERA5_Hourly_Data/mseqhqlstats');
        maxmsebypoint=thisfile.maxmsebypoint;p999msebypoint=thisfile.p999msebypoint;p99msebypoint=thisfile.p99msebypoint;p95msebypoint=thisfile.p95msebypoint;p50msebypoint=thisfile.p50msebypoint;
    end
    
        
    for year=2014:2018
        msefile=load(strcat('/Volumes/ExternalDriveZ/ERA5_Hourly_Data/msedailymaxarray',num2str(year)));
        %Load daily MSE data
        msedata1=eval(['msefile.dailymaxmse' rowstems{1} ';']);msedata2=eval(['msefile.dailymaxmse' rowstems{2} ';']);
        msedata3=eval(['msefile.dailymaxmse' rowstems{3} ';']);msedata4=eval(['msefile.dailymaxmse' rowstems{4} ';']);
        msedata5=eval(['msefile.dailymaxmse' rowstems{5} ';']);msedata6=eval(['msefile.dailymaxmse' rowstems{6} ';']);
        msedata7=eval(['msefile.dailymaxmse' rowstems{7} ';']);msedata8=eval(['msefile.dailymaxmse' rowstems{8} ';']);clear msefile;
        msedata=cat(2,msedata1,msedata2,msedata3,msedata4,msedata5,msedata6,msedata7,msedata8); %centered on Date Line
        clear msedata1;clear msedata2;clear msedata3;clear msedata4;clear msedata5;clear msedata6;clear msedata7;clear msedata8;
        disp('Finished MSE reading for timelineaddition');
        
        %Load temperature, dewpoint, and surface pressure
        file=ncgeodataset(strcat('/Volumes/ExternalDriveZ/ERA5_Hourly_Data/ttd_world_',num2str(year),'.grib'));
        ttemp=file{'2_metre_temperature_surface'};echo off;
        tdtemp=file{'2_metre_dewpoint_temperature_surface'};echo off;clear file;
        psfcfile=ncgeodataset(strcat('/Volumes/ExternalDriveC/ERA5_Hourly_Data_PandGHonly/psfc_world_',num2str(year),'.grib'));
        psfctemp=psfcfile{'Surface_pressure_surface'};echo off;clear psfcfile;
        
        %Load daily precip data
        preciptemp=ncread(strcat('/Volumes/ExternalDriveC/CHIRPS_Precipitation/chirps-v2.0.',num2str(year),'.days_p25.nc'),'precip');
        
        
        for k=1:1440
            for j=1:721
                randindex=randperm(90,1);
                wsday(j,k)=topdays(randindex,j,k);
            end
        end
        
        
        finaldaystaken=cell(721,1440);finalcenterdays=cell(721,1440);
        
        %Get data for each day in this year
        maxdailymse=NaN.*ones(size(msedata,1)-1,721,1440);
        for i=1:size(msedata,1)-1
            if (i>=38 && i<=73) || (i>=111 && i<=146) || ...
                    (i>=184 && i<=219) || (i>=257 && i<=292) || (i>=330)
                adj=4;
            else
                adj=0;
            end
            
            t=double(ttemp.data(i*8-7-adj:i*8-adj,:,:));
            td=double(tdtemp.data(i*8-7-adj:i*8-adj,:,:))-273.15;
            psfc=squeeze(double(psfctemp.data(i*8-7-adj:i*8-adj,:,:)));clear newpsfc;
            for h=1:size(psfc,1)
                temp=squeeze(psfc(h,:,:));
                newtemp=[temp(:,721:1440) temp(:,1:720)];
                newpsfc(h,:,:)=newtemp;clear newtemp;
            end
            psfc=newpsfc;clear newpsfc;

            clear qh;clear ql;clear hourlymse;

            mr=calcmrfromvpandpsfc(calcvpfromTd(td),psfc)./1000;
            omega=calcqfromTd_dynamicP(td,psfc)./1000; %convert to unitless specific humidity
            cp=1005.7.*(1+1.83.*mr);clear mr; %J K^-1 kg^-1; Stull, Practical Meteorology
            qh=cp.*t./1000;clear cp;
            lv=1918.46.*((t./(t-33.91)).^2); %J/kg; Henderson-Sellers 1984
            ql=lv.*omega;clear lv;clear omega; %J/kg
            hourlymse=qh+ql;clear qh;clear ql;
            
            maxdailymse(i,:,:)=squeeze(max(hourlymse));  
        end
        disp('At line 7648, done with part I for timelineaddition');disp(clock);
        
        %Sort by day -- this is to ensure that time traces aren't contaminated with other extreme days (20 min)
        for k=1:1440
            for j=1:721
                thisdata=squeeze(maxdailymse(:,j,k));
                A=[thisdata (1:364)'];B=sortrows(A,'descend');
                %Get list of days to use, keeping a 2-day berth around each
                clear daystaken;clear centerdays;
                daystaken=[B(1,2)-2:B(1,2)+2];centerdays=[B(1,2)];
                for row=2:364
                    if ~ismember(B(row,2)-2,daystaken) && ~ismember(B(row,2)-1,daystaken) && ~ismember(B(row,2),daystaken) &&...
                            ~ismember(B(row,2)+1,daystaken) && ~ismember(B(row,2)+2,daystaken)
                        daystaken=[daystaken B(row,2)-2:B(row,2)+2];
                        centerdays=[centerdays B(row,2)];
                    end
                end
                finaldaystaken{j,k}=daystaken;
                finalcenterdays{j,k}=centerdays;
            end
        end
        clear maxdailymse;
        disp('At line 7670, done with part II for timelineaddition');disp(clock);
        
        
        
        %If values exceed the LOCAL p99 MSE, then get assoc subdaily variables
        %Otherwise, if they're below, get assoc values for these randomly selected 'non-extreme' warm-season days
        disp(clock);
        for doy=3:363 %to avoid end-of-year problems
            if (doy>=38 && doy<=73) || (doy>=111 && doy<=146) || ...
                    (doy>=184 && doy<=219) || (doy>=257 && doy<=292) || (doy>=330)
                adj=4;
            else
                adj=0;
            end
            
            monofdoy=DOYtoMonth(doy,year);domofdoy=DOYtoDOM(doy,year);
        
            if (doy>=3 && doy<=35) || (doy>=40 && doy<=71) || (doy>=76 && doy<=108) || (doy>=113 && doy<=144) ||...
                        (doy>=149 && doy<=181) || (doy>=186 && doy<=217) || (doy>=222 && doy<=254) ||...
                        (doy>=259 && doy<=290) || (doy>=295 && doy<=327) || (doy>=332 && doy<=363)
                %Retrieve data at the start of a segment of days
                if doy==3 %this will be good up to and including doy==35
                    firstindex=1*8-7;lastindex=37*8;
                elseif doy==40 %this will be good through doy==71
                    firstindex=38*8-7;lastindex=73*8;
                elseif doy==76 %this will be good through doy==108
                    firstindex=74*8-7;lastindex=110*8;
                elseif doy==113
                    firstindex=111*8-7;lastindex=146*8;
                elseif doy==149
                    firstindex=147*8-7;lastindex=183*8;
                elseif doy==186
                    firstindex=184*8-7;lastindex=219*8;
                elseif doy==222
                    firstindex=220*8-7;lastindex=256*8;
                elseif doy==259
                    firstindex=257*8-7;lastindex=292*8;
                elseif doy==295
                    firstindex=293*8-7;lastindex=329*8;
                elseif doy==332
                    firstindex=330*8-7;lastindex=365*8;
                end     

                if doy==3 || doy==40 || doy==76 || doy==113 || doy==149 || doy==186 || doy==222 ||...
                        doy==259 || doy==295 || doy==332
                    t=double(ttemp.data(firstindex:lastindex,beginrow:endrow,begincol:endcol));
                    td=double(tdtemp.data(firstindex:lastindex,beginrow:endrow,begincol:endcol))-273.15;
                    psfc=squeeze(double(psfctemp.data(firstindex:lastindex,:,:)));
                    psfc=circshift(psfc,[0 0 721]); %shift columns so array is centered on 180
                    psfc=psfc(:,beginrow:endrow,begincol:endcol);
                    
                    mr=calcmrfromvpandpsfc(calcvpfromTd(td),psfc)./1000;
                    omega=calcqfromTd_dynamicP(td,psfc)./1000;clear psfc; %convert to unitless specific humidity
                    cp=1005.7.*(1+1.83.*mr);clear mr; %J K^-1 kg^-1; Stull, Practical Meteorology
                    qh=cp.*t./1000;clear cp;
                    lv=1918.46.*((t./(t-33.91)).^2); %J/kg; Henderson-Sellers 1984
                    ql=lv.*omega;clear lv;clear omega; %J/kg
                    hourlymse=qh+ql;clear qh;clear ql;
                    
                    arrsz=size(t,1);

                    %precipdata=
                    smdata=squeeze(double(smtemp.data(firstindex:lastindex,1,:,:)));
                    smdata=cat(2,NaN.*ones(arrsz,200,1440),smdata,NaN.*ones(arrsz,200,1440));
                    smdata=circshift(smdata,[0 0 721]); %shift columns so array is centered on 180
                    smdata=smdata(:,beginrow:endrow,begincol:endcol);
                end
                
                
                nr=endrow-beginrow+1;nc=endcol-begincol+1;
                datestimelineTEMP=NaN.*ones(arrsz,nr,nc);
                msetimelineTEMP=NaN.*ones(arrsz,nr,nc);
                smtimelineTEMP=NaN.*ones(arrsz,nr,nc);
                
                if doy<=35
                    thisdayrelative=doy;
                elseif doy<=71
                    thisdayrelative=doy-37;
                elseif doy<=108
                    thisdayrelative=doy-73;
                elseif doy<=144
                    thisdayrelative=doy-110;
                elseif doy<=181
                    thisdayrelative=doy-146;
                elseif doy<=217
                    thisdayrelative=doy-183;
                elseif doy<=254
                    thisdayrelative=doy-219;
                elseif doy<=290
                    thisdayrelative=doy-256;
                elseif doy<=327
                    thisdayrelative=doy-292;
                elseif doy<=363
                    thisdayrelative=doy-329;
                end

                extremedays=squeeze(msedata(doy,beginrow:endrow,begincol:endcol))>=p99msebypoint(beginrow:endrow,begincol:endcol); 
                extrdays_3D=repmat(extremedays,[1 1 arrsz]);clear extremedays; %is this day an extreme one?
                extrdays_3D=permute(extrdays_3D,[3 1 2]);
                
                datestimelineTEMP=[(doy-2).*ones(8,1);(doy-1).*ones(8,1);doy.*ones(8,1);(doy+1).*ones(8,1);(doy+2).*ones(8,1)];
                datestimelineTEMP=repmat(datestimelineTEMP,[1 nr nc]);
                
                
                msetimelineTEMP(extrdays_3D)=hourlymse(extrdays_3D);
                smtimelineTEMP(extrdays_3D)=smdata(extrdays_3D);clear extrdays_3D;

                for k=begincol:endcol
                    for j=beginrow:endrow
                        if sum(~isnan(msetimelineTEMP(:,j-(beginrow-1),k-(begincol-1))))>0 && sum(msetimelineTEMP(:,j-(beginrow-1),k-(begincol-1)))~=0
                            colinc(j,k)=colinc(j,k)+1;
                            datestimeline{j,k}(colinc(j,k),:)=datestimelineTEMP(:,j-(beginrow-1),k-(begincol-1));
                            msetimeline{j,k}(colinc(j,k),:)=msetimelineTEMP((thisdayrelative-2)*8-7:(thisdayrelative+2)*8,j-(beginrow-1),k-(begincol-1));
                            smtimeline{j,k}(colinc(j,k),:)=smtimelineTEMP((thisdayrelative-2)*8-7:(thisdayrelative+2)*8,j-(beginrow-1),k-(begincol-1));

                            [~,timeofmax]=max(msetimelineTEMP(17:24,j-(beginrow-1),k-(begincol-1)));
                        end
                    end
                end
                clear smtimelineTEMP;clear msetimelineTEMP;clear datestimelineTEMP;
                
                for k=begincol:endcol
                    for j=beginrow:endrow
                        dothis=1;
                        if dothis==1
                        if doy==wsday(j,k)
                            raymondc(j,k)=raymondc(j,k)+1;
                            msetimelinenonextr{j,k}(raymondc(j,k),:)=hourlymse((thisdayrelative-2)*8-7:(thisdayrelative+2)*8,j-(beginrow-1),k-(begincol-1));
                            smtimelinenonextr{j,k}(raymondc(j,k),:)=smdata((thisdayrelative-2)*8-7:(thisdayrelative+2)*8,j-(beginrow-1),k-(begincol-1));

                            [~,timeofmax]=max(hourlymse(17:24,j-(beginrow-1),k-(begincol-1)));
                        end
                        end
                    end
                end
            end
            if rem(doy,30)==0;fprintf('Doy is %d\n',doy);end
        end
        clear smtemp;clear hourlymse;
        
        smtimelineFINAL=cell(721,1440);smtimelinenonextrFINAL=cell(721,1440);datestimelineFINAL=cell(721,1440);
        
        for k=begincol:endcol
            for j=beginrow:endrow
                newrowc=0;
                for row=1:size(datestimeline{j,k},1)
                    if ismember(datestimeline{j,k}(row,20),finalcenterdays{j,k})
                        newrowc=newrowc+1;
                        datestimelineFINAL{j,k}(newrowc,:)=datestimeline{j,k}(row,:);
                        smtimelineFINAL{j,k}(newrowc,:)=smtimeline{j,k}(row,:);
                    end
                end
                    
                newrowcnonextr=0;
                for row=1:size(msetimelinenonextr{j,k},1)
                    newrowcnonextr=newrowcnonextr+1;
                    smtimelinenonextrFINAL{j,k}(newrowcnonextr,:)=smtimelinenonextr{j,k}(row,:);
                end
            end
        end
        clear ttemp;clear tdtemp;clear psfctemp;
        fprintf('At line 7827, done with part III for timelineaddition and year %d\n',year);disp(clock);
        
        save(strcat('/Volumes/ExternalDriveZ/ERA5_HHLcalcs/timetracesarraysforyearSOILMOISTUREONLY',num2str(year),'.mat'),...
            'smtimelineFINAL','smtimelinenonextrFINAL','datestimelineFINAL');
    end
    disp('Please run remainder of loop manually.');return;
    
    %Eliminate duplicate rows and combine years together!! (10 min)
    %Note that 2016 and 2018 currently have wrong Psfc values and thus MSE
    %values, but this in principle does not affect the anomalies or the comparison of variables
    yearstoload=[2014;2015;2016];
    for i=1:size(yearstoload,1) %2 min
        year=yearstoload(i);
        thisfile=load(strcat('/Volumes/ExternalDriveZ/ERA5_HHLcalcs/timetracesarraysforyearSOILMOISTUREONLY',num2str(year),'.mat'));
        eval(['smtimelineFINAL' num2str(i) '=thisfile.smtimelineFINAL;']);
        eval(['smtimelinenonextrFINAL' num2str(i) '=thisfile.smtimelinenonextrFINAL;']);
    end
    smmerged=cell(721,1440);smmergednonextr=cell(721,1440);
    for k=begincol:endcol
        for j=beginrow:endrow
            %Remove duplicate rows, then combine across years
            unik1=unique(smtimelineFINAL1{j,k},'rows');unik2=unique(smtimelineFINAL2{j,k},'rows');unik3=unique(smtimelineFINAL3{j,k},'rows');smmerged{j,k}=cat(1,unik1,unik2);
            unik1=unique(smtimelinenonextrFINAL1{j,k},'rows');unik2=unique(smtimelinenonextrFINAL2{j,k},'rows');unik3=unique(smtimelinenonextrFINAL3{j,k},'rows');
                smmergednonextr{j,k}=cat(1,unik1,unik2);
        end
    end
    
    
    
    %Get gridpt means (2 min)
    smmean=NaN.*ones(721,1440,40);smmeannonextr=NaN.*ones(721,1440,40);
    for k=begincol:endcol
        for j=beginrow:endrow
            if size(smmerged{j,k},1)>=1
                invalid=smmerged{j,k}==0;smmerged{j,k}(invalid)=NaN;
                smmean(j,k,:)=mean(smmerged{j,k},1,'omitnan');
            end
            
            if size(smmergednonextr{j,k},1)>=1
                invalid=smmergednonextr{j,k}==0;smmergednonextr{j,k}(invalid)=NaN;
                smmeannonextr(j,k,:)=mean(smmergednonextr{j,k},1,'omitnan');
            end
        end
    end
    save('/Volumes/ExternalDriveZ/ERA5_HHLcalcs/timetracesSOILMOISTUREONLY.mat','smmean','smmeannonextr');
    
    %Regional means (10 sec)
    clear smmean_here;clear smmeannonextr_here;
    for regnum=1:5
        if regnum~=4
        if regnum>=1 && regnum<=5 %a previously defined (e.g. hotspot) region
            row1=actualrowstarts(regnum);row2=actualrowstops(regnum);col1=actualcolstartsalt(regnum)-0.5;col2=actualcolstopsalt(regnum)+0.5;
            if regnum==5;regord=4;else;regord=regnum;end %Amazon will be 4th region plotted
        elseif regnum==10 %other coordinates
            row1=450;row2=520;col1=1250;col2=1350;regord=5;
        end

        smmean_here(regord,:)=squeeze(mean(mean(smmean(row1:row2,col1:col2,:),'omitnan'),'omitnan'));
        smmeannonextr_here(regord,:)=squeeze(mean(mean(smmeannonextr(row1:row2,col1:col2,:),'omitnan'),'omitnan'));
        
        end
    end
    
    %Quickly get full distributions for precipitation only (as opposed to getfulldistns loop, which laboriously does this for all variables)
    %REPLACES EVERYTHING PRIOR IN THIS LOOP (OR SO I THINK...)
    %10 min
    totalcnh=0;totalcsh=0;
    cbypt=zeros(721,1440);preciptimeline=cell(721,1440);datestimeline=cell(721,1440);yeartimeline=cell(721,1440);
    for year=2014:2018
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
    
    save(strcat('/Volumes/ExternalDriveZ/ERA5_HHLcalcs/fulldistnarraysPRECIPITATIONONLY2018.mat'),'preciptimeline','datestimeline','yeartimeline','-v7.3');
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
    disp('Did not make SST-anom figure yet');return;
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
        save(strcat('/Volumes/ExternalDriveZ/ERA5_HHLcalcs/psfcarraysreg',num2str(regloop)),'bigpsfcarr','-v7.3');
        
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
    
    f=load('/Volumes/ExternalDriveZ/ERA5_HHLcalcs/psfcarraysreg1');bigpsfcarr1=f.bigpsfcarr;
    f=load('/Volumes/ExternalDriveZ/ERA5_HHLcalcs/psfcarraysreg2');bigpsfcarr2=f.bigpsfcarr;
    f=load('/Volumes/ExternalDriveZ/ERA5_HHLcalcs/psfcarraysreg3');bigpsfcarr3=f.bigpsfcarr;
    f=load('/Volumes/ExternalDriveZ/ERA5_HHLcalcs/psfcarraysreg5');bigpsfcarr5=f.bigpsfcarr;
    
    %Create figure
    %Use subregrowstarts to really zero in on the places that matter most in each region (to characterize seasons when extreme days occur)
    %subregrowstarts=[259;221;253;0;413];subregrowstops=[269;241;281;0;435];subregcolstarts=[929;999;1060;0;445];subregcolstops=[945;1013;1080;0;473];
    figure(81);clf;curpart=1;highqualityfiguresetup;
    for regloop=1:5
        if regloop~=4
            if regloop<=3;regord=regloop;else;regord=4;end
            thisarr=eval(['bigpsfcarr' num2str(regloop) ';']);thisarr=cat(3,NaN.*ones(size(thisarr,1),300,419),thisarr,NaN.*ones(size(thisarr,1),300,324));
            clear thisarrasanom;
            %for i=201:500
            %    for j=1:1440
            %        climohere=cat(1,dailymeanpsfc(topdays(:,i,j),i-200,j),dailymeanpsfc(365+topdays(:,i,j),i-200,j),dailymeanpsfc(730+topdays(:,i,j),i-200,j),dailymeanpsfc(1095+topdays(:,i,j),i-200,j));
            %        thisarrasanom(i,j)=squeeze(mean(thisarr(:,i-200,j)))-mean(climohere);
            %    end
            %end
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
        %theseverytopdays=alldaysc>=quantile(alldaysc,0.80);
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
            save('/Volumes/ExternalDriveZ/ERA5_HHLcalcs/preciparraysreg1','bigpreciparr');
        elseif regloop==2
            save('/Volumes/ExternalDriveZ/ERA5_HHLcalcs/preciparraysreg2','bigpreciparr');
        elseif regloop==3
            save('/Volumes/ExternalDriveZ/ERA5_HHLcalcs/preciparraysreg3','bigpreciparr');
        elseif regloop==5
            save('/Volumes/ExternalDriveZ/ERA5_HHLcalcs/preciparraysreg5','bigpreciparr');
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
            save(strcat('/Volumes/ExternalDriveZ/ERA5_HHLcalcs/precipclimoarrayreg',num2str(regloop)),'meanpreciptracebypoint');
        end
    end
    
    %dailymeanpsfc=cat(3,NaN.*ones(1460,300,419),dailymeanpsfc,NaN.*ones(1460,300,324));
    %Create figure
    %Use subregrowstarts to really zero in on the places that matter most in each region (to characterize seasons when extreme days occur)
    %subregrowstarts=[259;221;253;0;413];subregrowstops=[269;241;281;0;435];subregcolstarts=[929;999;1060;0;445];subregcolstops=[945;1013;1080;0;473];
    figure(81);clf;curpart=1;highqualityfiguresetup;
    for regloop=1:5
        if regloop~=4
            row1=subregrowstarts(regloop);row2=subregrowstops(regloop);
            col1=subregcolstarts(regloop);col2=subregcolstops(regloop);
        
            if regloop<=3;regord=regloop;else;regord=4;end
            tmp=load(strcat('/Volumes/ExternalDriveZ/ERA5_HHLcalcs/preciparraysreg',num2str(regloop)));thisarr=tmp.bigpreciparr;
            clear thisarrasanom;

            tmp=load(strcat('/Volumes/ExternalDriveZ/ERA5_HHLcalcs/precipclimoarrayreg',num2str(regloop)));meanpreciptracebypoint=tmp.meanpreciptracebypoint;
            
            if regloop==1
                regname='persian-gulf-slightlysmaller';wsstart=150;wsstop=240;minval=-1*10^-5;maxval=1*10^-5;intval=10^-6;
            elseif regloop==2
                regname='pakistan-slightlygreater';wsstart=140;wsstop=230;minval=-2*10^-4;maxval=2*10^-4;intval=10^-5;
            elseif regloop==3
                regname='eindia-evensmaller';wsstart=140;wsstop=230;minval=-5*10^-4;maxval=5*10^-4;intval=2*10^-5;
            else
                regname='wamazon-south';wsstart=1;wsstop=90;minval=-7*10^-4;maxval=7*10^-4;intval=2*10^-5;
            end
            thisarrasanom=squeeze(mean(thisarr))-permute(meanpreciptracebypoint,[3 1 2]);
            %thisarrasanom=cat(1,thisarrasanom,zeros(221,1440));thisarrasanom=cat(1,zeros(200,1440),thisarrasanom);
            data={era5latarray(row1-20:row2+20,col1-20:col2+20);era5lonarray(row1-20:row2+20,col1-20:col2+20);squeeze(mean(thisarrasanom))}; %in hPa
            vararginnew={'datatounderlay';data;'underlaycaxismin';minval;'underlaycaxismax';maxval;'mystepunderlay';intval;...
                'underlaycolormap';colormaps('q','more','not');'overlaynow';0;'nonewfig';1;'variable';'generic scalar'};
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
    figname='precipanomcomposite';curpart=2;highqualityfiguresetup;
end

%Mean lid strength for world, just to see what it looks like
if calcgloballidstrength==1
    setup_nctoolbox;
    thisyear=2017;
    
    ttdfile=ncgeodataset(strcat('/Volumes/ExternalDriveZ/ERA5_Hourly_Data/ttd_world_',num2str(thisyear),'.grib'));
    ttemp=ttdfile{'2_metre_temperature_surface'};echo off;
    tdtemp=ttdfile{'2_metre_dewpoint_temperature_surface'};echo off;clear ttdfile;
    
    pblhfile=ncgeodataset(strcat('/Volumes/ExternalDriveC/ERA5_Hourly_Data_PBLheight_only/pblh_world_',num2str(thisyear),'.grib'));
    pblhtemp=pblhfile{'Boundary_layer_height_surface'};echo off;clear pblhfile;
    psfcfile=ncgeodataset(strcat('/Volumes/ExternalDriveC/ERA5_Hourly_Data_PandGHonly/psfc_world_',num2str(thisyear),'.grib'));
    psfctemp=psfcfile{'Surface_pressure_surface'};echo off;clear psfcfile;
    
    pressures_forml=[200;300;500;700;850;900;954;975;1000];
    
    for thismonth=7:7
        if thismonth<=9;mzero='0';else;mzero='';end
        clear pblh;clear psfc;clear t2m;clear td2m;
        
        tprofile=ncread(strcat('/Volumes/ExternalDriveD/ERA5_Tq_vertprofiles_only/tq_vertprofile_world_',num2str(thisyear),mzero,num2str(thismonth),'.nc'),'t');
        qprofile=ncread(strcat('/Volumes/ExternalDriveD/ERA5_Tq_vertprofiles_only/tq_vertprofile_world_',num2str(thisyear),mzero,num2str(thismonth),'.nc'),'q');
        tprofile=tprofile(:,121:600,:,:);qprofile=qprofile(:,121:600,:,:);
        
        pblh=double(pblhtemp.data(monthstarts_daily(thismonth)*8-7:(monthstarts_daily(thismonth)+27)*8,121:600,:));pblh=permute(pblh,[3 2 1]);
        
        psfc=double(psfctemp.data(monthstarts_daily(thismonth)*8-7:(monthstarts_daily(thismonth)+27)*8,121:600,:));psfc=permute(psfc,[3 2 1]); %Pa
        for dim3=1:size(psfc,3)
            newpsfc(:,:,dim3)=[psfc(721:1440,:,dim3);psfc(1:720,:,dim3)];
        end
        psfc=newpsfc;clear newpsfc;
        
        t2m=double(ttemp.data(monthstarts_daily(thismonth)*8-7:(monthstarts_daily(thismonth)+27)*8,121:600,:));t2m=permute(t2m,[3 2 1]); %K
        
        td2m=double(tdtemp.data(monthstarts_daily(thismonth)*8-7:(monthstarts_daily(thismonth)+27)*8,121:600,:))-273.15;td2m=permute(td2m,[3 2 1]); %C
        
        
        vp=calcvpfromTd(td2m); %Pa
        mr=622.197.*(vp./(psfc-vp))./1000;clear vp;
        omega=calcqfromTd_dynamicP(td2m,psfc);clear td2m;
        cp=(1005.7.*(1-mr))+(mr.*(1-mr).*1850);clear mr;
        qh2m=cp.*t2m;clear cp; %J/kg
        lv=1918.46.*((t2m./(t2m-33.91)).^2);clear t2m;
        ql2m=lv.*omega;clear lv;clear omega; %J/kg
        mse2m=(qh2m+ql2m)./1000;clear qh2m;clear ql2m; %kJ/kg
                 
        elevs_here=elevera5';elevs_here=[elevs_here(721:1440,:);elevs_here(1:720,:)];elevs_here=elevs_here(:,121:600);
        
        %Get geopotential height of model levels (1 hour)
        clear z_ml;
        mls_retrieved=mls_retrieved_9;
        for aa=1:size(tprofile,4) %hours of month
            for kk=1:size(tprofile,3) %vertical levels
                clear t_here;clear q_here;clear psfc_here;clear ghsfc_here;
                k=mls_retrieved(kk);
                t_here=squeeze(tprofile(:,:,:,aa));t_here=permute(t_here,[3 1 2]);
                q_here=squeeze(qprofile(:,:,:,aa));q_here=permute(q_here,[3 1 2]);
                psfc_here=squeeze(psfc(:,:,aa))./100;
                ghsfc_here=squeeze(elevs_here);
                era5ghofmodellevels;
                z_ml(aa,kk,:,:)=gp_here./9.81;
                clear t_here;clear q_here;clear psfc_here;clear ghsfc_here;
            end
            if rem(aa,20)==0;fprintf('Completed hour=%d of %d at line 5647\n',aa,size(tprofile,4));disp(clock);end
        end
        clear psfc;
        %save('/Volumes/ExternalDriveZ/ERA5_HHLcalcs/lidarrays.mat','z_ml','-v7.3');
        
        %Compute MSE/Qh/Ql [profile] data
        %No need to include calculations at 200mb and 300mb
        pressures_forml=repmat(pressures_forml,[1,size(qprofile,1),size(qprofile,2),size(qprofile,4)]);pressures_forml=permute(pressures_forml,[2,3,1,4]);
        td=calcTdfromq(qprofile(:,:,3:9,:).*1000,pressures_forml(:,:,3:9,:)); %4 min
        vp=calcvpfromTd(td)./100; %6 min
        mr=622.197.*(vp./(pressures_forml(:,:,3:9,:)-vp))./1000;clear vp; %1 min; unitless
        omega=calcqfromTd_dynamicP(td,pressures_forml(:,:,3:9,:).*100);clear td; %13 min; convert to specific humidity
        omega_sat=calcqfromTd_dynamicP(tprofile(:,:,3:9,:)-273.15,pressures_forml(:,:,3:9,:).*100);clear pressures_forml; %8 min
        cp=(1005.7.*(1-mr))+(mr.*(1-mr).*1850);clear mr; %30 sec
        qh=cp.*tprofile(:,:,3:9,:);clear cp; %30 sec
        lv=1918.46.*((tprofile(:,:,3:9,:)./(tprofile(:,:,3:9,:)-33.91)).^2); %1 min; J/kg; Henderson-Sellers 1984
        ql=lv.*omega;clear omega; %1 min; J/kg
        ql_sat=lv.*omega_sat;clear lv;clear omega_sat; %1 min; J/kg
        z_ml_perm=permute(z_ml,[3 4 2 1]);clear z_ml;
        mse=(qh+ql+9.81.*z_ml_perm(:,:,3:9,:))./1000;clear ql; %3 min
        mse_sat=(qh+ql_sat+9.81.*z_ml_perm(:,:,3:9,:))./1000;clear qh;clear ql_sat; %3 min
                
        
        %Compute stability ('lid strength') as the difference between the 2-m
            %MSE and the maximum *saturated* MSE between the top of the PBL
            %and 500 mb (about 10 min)
        lastlevabove=NaN.*ones(size(mse2m,1),size(mse2m,2),size(mse2m,3));
        
        zat500mbabovepbl=squeeze(z_ml_perm(:,:,3,:))>pblh;
        zat700mbabovepbl=squeeze(z_ml_perm(:,:,4,:))>pblh;
        temp=(zat500mbabovepbl & ~zat700mbabovepbl);lastlevabove(temp)=3;clear zat500mbabovepbl; %PBL is between 500 and 700 mb
        
        zat850mbabovepbl=squeeze(z_ml_perm(:,:,5,:))>pblh;
        temp=(zat700mbabovepbl & ~zat850mbabovepbl);lastlevabove(temp)=4;clear zat700mbabovepbl;
        
        zat900mbabovepbl=squeeze(z_ml_perm(:,:,6,:))>pblh;
        temp=(zat850mbabovepbl & ~zat900mbabovepbl);lastlevabove(temp)=5;clear zat850mbabovepbl;
        
        zat950mbabovepbl=squeeze(z_ml_perm(:,:,7,:))>pblh;
        temp=(zat900mbabovepbl & ~zat950mbabovepbl);lastlevabove(temp)=6;clear zat900mbabovepbl;
        
        zat975mbabovepbl=squeeze(z_ml_perm(:,:,8,:))>pblh;
        temp=(zat950mbabovepbl & ~zat975mbabovepbl);lastlevabove(temp)=7;clear zat950mbabovepbl;
        
        zat1000mbabovepbl=squeeze(z_ml_perm(:,:,9,:))>pblh;
        temp=(zat975mbabovepbl & ~zat1000mbabovepbl);lastlevabove(temp)=8;clear zat975mbabovepbl;clear zat1000mbabovepbl;
        
        maxsatmsesofar=zeros(size(mse2m,1),size(mse2m,2),size(mse2m,3));
        for levindex=3:8
            lastlevaboveisthislevindex=lastlevabove==levindex;
            thesemsesats=zeros(size(mse2m,1),size(mse2m,2),size(mse2m,3));
            thesemsesats(lastlevaboveisthislevindex)=real(mse_sat(lastlevaboveisthislevindex));
            maxsatmsesofar=max(maxsatmsesofar,thesemsesats,'omitnan');
        end
        invalid=maxsatmsesofar==0;maxsatmsesofar(invalid)=NaN;
        
        maxsatmse=maxsatmsesofar;clear maxsatmsesofar;
        stabil=maxsatmse-mse2m;
        
        %Because this uses isobaric data, mask out everything below ~900mb (~1000 m)
        mountains=elevs_here>1000;mountains_rep=repmat(mountains,[1 1 size(stabil,3)]);
        stabil(mountains_rep)=NaN;
    end
    clear pblhtemp;clear psfctemp;clear ttemp;clear tdtemp;
    
    meanstabil_jul2017=squeeze(mean(stabil,3,'omitnan'));
    daytimemeanstabil_jul2017=squeeze(quantile(stabil,0.25,3));
    save('/Volumes/ExternalDriveZ/ERA5_HHLcalcs/lidarrays.mat','meanstabil_jul2017','daytimemeanstabil_jul2017');
    
    figure(300);clf;imagescnan(daytimemeanstabil_jul2017');colorbar;
end



clear invalid;




if makefinalfigures==1
    finalfigures;
end


%Essentially a replacement for the timelineoffactors loop, enabling the calculation of standardized anomalies for the final figures
if getfulldistnsoftimelinevariables==1
    rowstems={'rows1to100';'rows101to200';'rows201to300';'rows301to400';'rows401to500';'rows501to600';'rows601to700';'rows701to721'};
    beginrow=201;endrow=481;begincol=201;endcol=1361;
        
    exist weightsforeach;
    if ans==0
        temp=load('/Volumes/ExternalDriveZ/ERA5_HHLcalcs/percentilesofothervariables.mat');weightsforeach=temp.weightsforeach;
    end
    exist topdays;
    if ans==0
        temp=load('/Volumes/ExternalDriveZ/ERA5_Hourly_Data/climtopmsedays');topdays=temp.topdays;
    end
    exist p99msebypoint;
    if ans==0
        thisfile=load('/Volumes/ExternalDriveZ/ERA5_Hourly_Data/mseqhqlstats');p99msebypoint=thisfile.p99msebypoint;
    end
    exist elevera5;
    if ans==0
        temp=ncread('elevera5.nc','z');elevera5=(squeeze(temp(:,:,1))./9.81)';
        elevera5=[elevera5(:,721:1440) elevera5(:,1:720)];
    end
    
    disp('Starting year calculation at line 5594');
    for year=startyearforfulldistns:stopyearforfulldistns
        countsbygridpt=zeros(721,1440); 
        cbygridpttimeline=zeros(721,1440);msetimeline=cell(721,1440);
        datestimeline=cell(721,1440);timeofmaxtimeline=cell(721,1440);
        qhtimeline=cell(721,1440);qltimeline=cell(721,1440);
        pblhtimeline=cell(721,1440);preciptimeline=cell(721,1440);precipchirpstimeline=cell(721,1440);msstimeline=cell(721,1440);
        sfcsensibletimeline=cell(721,1440);sfclatenttimeline=cell(721,1440);
        lwtimeline=cell(721,1440);swtimeline=cell(721,1440);
        utimeline=cell(721,1440);vtimeline=cell(721,1440);wtimeline=cell(721,1440);
    
        if year==2013 || year==2017
        if year<=2013;modellevdataloc='ExternalDriveF/ERA5_modelleveldata_0000to2013';else;modellevdataloc='ExternalDriveD/ERA5_modelleveldata';end
        
        if reloadalldataforyear==1
        setup_nctoolbox;
        
        %Load temperature, dewpoint, and surface pressure
        file=ncgeodataset(strcat('/Volumes/ExternalDriveZ/ERA5_Hourly_Data/ttd_world_',num2str(year),'.grib'));
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
            if year>=2000 && year<=2018 %days were assigned incorrectly into msedata so post-hoc adjustments must be made (see troubleshooting.m)
                if i>=210 && i<=282
                    actuali=i+10;
                elseif i>=329
                    actuali=i+1;
                else
                    actuali=i;
                end
            else
                actuali=i;
            end

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
            %cp=1005.7.*(1+1.83.*mr);clear mr; %J K^-1 kg^-1; Stull, Practical Meteorology
            cp=(1005.7.*(1-mr))+(mr.*(1-mr).*1850);clear mr;
            qh=cp.*t;clear cp;
            lv=1918.46.*((t./(t-33.91)).^2); %J/kg; Henderson-Sellers 1984
            ql=lv.*omega;clear lv; %J/kg
            hourlymse=(qh+ql)./1000;
            
            maxdailymse(i,:,:)=squeeze(max(hourlymse));  
        end
        disp('At line 6404, done with part I for timelineoffactors');disp(clock);
        
        end
        
        elevera5_180=[elevera5(:,721:1440) elevera5(:,1:720)]; %centered on 180
        %elev_rep180=NaN.*ones(2920,721,1440);for hh=1:2920;elev_rep180(hh,:,:)=elevera5_180;end
        
        
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
                        %cp=1005.7.*(1+1.83.*mr);clear mr; %J K^-1 kg^-1; Stull, Practical Meteorology
                        cp=(1005.7.*(1-mr))+(mr.*(1-mr).*1850);clear mr;
                        qh=cp.*t;clear cp;
                        lv=1918.46.*((t./(t-33.91)).^2); %J/kg; Henderson-Sellers 1984
                        ql=lv.*omega;clear lv;clear omega; %J/kg
                        hourlymse=(qh+ql)./1000;
                        
                        t=t(:,:,begincol:endcol);td=td(:,:,begincol:endcol);pblhdata=pblhdata(:,:,begincol:endcol);
                        precipdata=precipdata(:,:,begincol:endcol);precipchirpsdata=precipchirpsdata(:,:,begincol:endcol);
                        if domss==1
                            t500data=t500data(:,:,begincol:endcol);q500data=q500data(:,:,begincol:endcol);
                        end
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

                    %disp('line 12211');disp(clock);
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

                                        %'Lid' calculation (stability)
                                        
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
        
        
        %Option 1: Save global data
        if saveallinone==1
            save(strcat('/Volumes/ExternalDriveZ/ERA5_HHLcalcs/fulldistnarrays',num2str(year),'.mat'),...
                'countsbygridpt','cbygridpttimeline','datestimeline','msetimeline','qhtimeline',...
                'qltimeline','pblhtimeline','preciptimeline','precipchirpstimeline','sfcsensibletimeline','sfclatenttimeline',...
                'lwtimeline','swtimeline','utimeline','vtimeline','wtimeline','-v7.3');
        else
        %Option 2: Save data in separate files (necessary because frequent crashing when attempting to save everything)
            save(strcat('/Volumes/ExternalDriveZ/ERA5_HHLcalcs/fulldistnarrays',num2str(year),'_countsbygridpt.mat'),'countsbygridpt');
            save(strcat('/Volumes/ExternalDriveZ/ERA5_HHLcalcs/fulldistnarrays',num2str(year),'_cbygridpttimeline.mat'),'cbygridpttimeline');
            save(strcat('/Volumes/ExternalDriveZ/ERA5_HHLcalcs/fulldistnarrays',num2str(year),'_datestimeline.mat'),'datestimeline');
            save(strcat('/Volumes/ExternalDriveZ/ERA5_HHLcalcs/fulldistnarrays',num2str(year),'_msetimeline.mat'),'msetimeline');
            save(strcat('/Volumes/ExternalDriveZ/ERA5_HHLcalcs/fulldistnarrays',num2str(year),'_qhtimeline.mat'),'qhtimeline');
            save(strcat('/Volumes/ExternalDriveZ/ERA5_HHLcalcs/fulldistnarrays',num2str(year),'_qltimeline.mat'),'qltimeline');
            save(strcat('/Volumes/ExternalDriveZ/ERA5_HHLcalcs/fulldistnarrays',num2str(year),'_pblhtimeline.mat'),'pblhtimeline');
            save(strcat('/Volumes/ExternalDriveZ/ERA5_HHLcalcs/fulldistnarrays',num2str(year),'_preciptimeline.mat'),'preciptimeline');
            save(strcat('/Volumes/ExternalDriveZ/ERA5_HHLcalcs/fulldistnarrays',num2str(year),'_precipchirpstimeline.mat'),'precipchirpstimeline');
            save(strcat('/Volumes/ExternalDriveZ/ERA5_HHLcalcs/fulldistnarrays',num2str(year),'_sfcsensibletimeline.mat'),'sfcsensibletimeline');
            save(strcat('/Volumes/ExternalDriveZ/ERA5_HHLcalcs/fulldistnarrays',num2str(year),'_sfclatenttimeline.mat'),'sfclatenttimeline');
            if year==2017 %more extremes in this year than any other, resulting in a larger file size 
                save(strcat('/Volumes/ExternalDriveZ/ERA5_HHLcalcs/fulldistnarrays',num2str(year),'_lwtimeline.mat'),'lwtimeline','-v7.3');
                save(strcat('/Volumes/ExternalDriveZ/ERA5_HHLcalcs/fulldistnarrays',num2str(year),'_swtimeline.mat'),'swtimeline','-v7.3');
                save(strcat('/Volumes/ExternalDriveZ/ERA5_HHLcalcs/fulldistnarrays',num2str(year),'_utimeline.mat'),'utimeline','-v7.3');
                save(strcat('/Volumes/ExternalDriveZ/ERA5_HHLcalcs/fulldistnarrays',num2str(year),'_vtimeline.mat'),'vtimeline','-v7.3');
                save(strcat('/Volumes/ExternalDriveZ/ERA5_HHLcalcs/fulldistnarrays',num2str(year),'_wtimeline.mat'),'wtimeline','-v7.3');
            else
                save(strcat('/Volumes/ExternalDriveZ/ERA5_HHLcalcs/fulldistnarrays',num2str(year),'_lwtimeline.mat'),'lwtimeline');
                save(strcat('/Volumes/ExternalDriveZ/ERA5_HHLcalcs/fulldistnarrays',num2str(year),'_swtimeline.mat'),'swtimeline');
                save(strcat('/Volumes/ExternalDriveZ/ERA5_HHLcalcs/fulldistnarrays',num2str(year),'_utimeline.mat'),'utimeline');
                save(strcat('/Volumes/ExternalDriveZ/ERA5_HHLcalcs/fulldistnarrays',num2str(year),'_vtimeline.mat'),'vtimeline');
                save(strcat('/Volumes/ExternalDriveZ/ERA5_HHLcalcs/fulldistnarrays',num2str(year),'_wtimeline.mat'),'wtimeline');
            end
        end
        fprintf('At line 6920, done with part III for fulldistns and year %d\n',year);disp(clock);
        end
    end
end


if suppfigamazonterrain==1
    file=ncgeodataset(strcat('/Volumes/ExternalDriveD/ERA5_modelleveldata/tq_201601.grib'));
    qtemp=file{'q'};ttemp=file{'t'};echo off;clear file;
    file=ncgeodataset(strcat('/Volumes/ExternalDriveD/ERA5_modelleveldata/uvw_201601.grib'));
    utemp=file{'u'};vtemp=file{'v'};wtemp=file{'w'};echo off;clear file;
    
    qdata=squeeze(double(qtemp.data(181,5,:,:)));qdata=cat(2,NaN.*ones(281,199),qdata,NaN.*ones(281,80)); %centered on 0
    tdata=squeeze(double(ttemp.data(181,5,:,:)));tdata=cat(2,NaN.*ones(281,199),tdata,NaN.*ones(281,80));
    udata=squeeze(double(utemp.data(181,4,:,:)));udata=cat(2,NaN.*ones(281,199),udata,NaN.*ones(281,80));
    vdata=squeeze(double(vtemp.data(181,4,:,:)));vdata=cat(2,NaN.*ones(281,199),vdata,NaN.*ones(281,80));
    wdata=squeeze(double(wtemp.data(181,4,:,:)));wdata=cat(2,NaN.*ones(281,199),wdata,NaN.*ones(281,80));
    
    above850=elevera5(201:481,:)>1450;tdata(above850)=NaN;qdata(above850)=NaN;
    above700=elevera5(201:481,:)>2950;udata(above700)=NaN;vdata(above700)=NaN;
    
    figure(99);clf;curpart=1;highqualityfiguresetup;
    regname='northern-south-america';
    
    data={era5latarray(201:481,:);era5lonarray(201:481,:);tdata-273.15};
    vararginnew={'datatounderlay';data;'underlaycaxismin';7;'underlaycaxismax';24;'mystepunderlay';0.5;...
        'underlaycolormap';colormaps('t','more','not');'overlaynow';0;'nonewfig';1;'variable';'temperature';'nansgray';1};
    plotModelData(data,regname,vararginnew,'custom');
    title('T at 850mb','fontsize',14,'fontweight','bold','fontname','arial');
    set(gca,'Position',[0.02 0.25 0.26 0.5]);   
    
    subplot(1,3,2);
    data={era5latarray(201:481,:);era5lonarray(201:481,:);qdata.*1000};
    vararginnew={'datatounderlay';data;'underlaycaxismin';0;'underlaycaxismax';16;'mystepunderlay';0.5;...
        'underlaycolormap';colormaps('q','more','not');'overlaynow';0;'nonewfig';1;'variable';'specific humidity';'nansgray';1};
    plotModelData(data,regname,vararginnew,'custom');
    title('q at 850mb','fontsize',14,'fontweight','bold','fontname','arial');
    set(gca,'Position',[0.35 0.25 0.26 0.5]);
    
    subplot(1,3,3);
    data={era5latarray(201:481,:);era5lonarray(201:481,:);NaN.*ones(281,1440)};
    winddata={era5latarray(201:481,:);era5lonarray(201:481,:);udata;vdata};
    vararginnew={'overlayvariable';'generic scalar';'datatooverlay';data;'caxismin';0;'caxismax';0;'mystep';1;...
        'variable';'wind';'vectorData';winddata;'overlaynow';1;'nonewfig';1;'anomavg';'avg';'nansgray';1;'omitfirstsubplotcolorbar';1};
    plotModelData(data,regname,vararginnew,'custom');
    title('Wind at 700mb','fontsize',14,'fontweight','bold','fontname','arial');
    set(gca,'Position',[0.67 0.25 0.26 0.5]);
    arr=annotation('arrow',[0.78 0.805],[0.28 0.28]);
    txt=text(0.4,-0.08,'10 m/s','units','normalized');set(txt,'fontsize',11,'fontweight','bold','fontname','arial');
    
    figname='amazon18zjan232016';curpart=2;highqualityfiguresetup;
end


if getfulldistnsofspecificvars==1
    exist topdays;
    if ans==0
        temp=load('/Volumes/ExternalDriveZ/ERA5_Hourly_Data/climtopmsedays');topdays=temp.topdays;
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
        %for i=1:721
        %    for j=1:1440
        %        curyear=2014;
        %        for k=2:size(datestimeline{i,j},1)
        %            if datestimeline{i,j}(k,1)<datestimeline{i,j}(k-1,1) %new year
        %                curyear=curyear+1;
        %            end
        %            yeartimelinelwsw{i,j}(k,1:40)=curyear;
        %        end
        %    end
        %end

        save(strcat('/Volumes/ExternalDriveZ/ERA5_HHLcalcs/fulldistnarraysLWSWONLY2017.mat'),'lwtimeline','swtimeline','datestimelinelwsw','yeartimelinelwsw','-v7.3');
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
                                                utimeline{j,k}(cbypt(j,k),:,:)=udata(:,:,j-(beginrow-1),k-(begincol-1));
                                                vtimeline{j,k}(cbypt(j,k),:,:)=vdata(:,:,j-(beginrow-1),k-(begincol-1));
                                                wtimeline{j,k}(cbypt(j,k),:,:)=wdata(:,:,j-(beginrow-1),k-(begincol-1));
                                            end

                                            datestimelineuvw{j,k}(cbypt(j,k),:)=datestimelineTEMP(:,j-(beginrow-1),k-(begincol-1));
                                            yeartimelineuvw{j,k}(cbypt(j,k),:)=yeartimelineTEMP(:,j-(beginrow-1),k-(begincol-1));
                                        end
                                    %end
                                end
                            end
                        end
                        clear datestimelineTEMP;
                    end
                end
                if rem(doy,20)==0;fprintf('Year is %d and doy is %d for uvw recalculation\n',year,doy);end
            end
        end
        %for i=1:721
        %    for j=1:1440
        %        curyear=2014;
        %        for k=2:size(datestimeline{i,j},1)
        %            if datestimeline{i,j}(k,1)<datestimeline{i,j}(k-1,1) %new year
        %                curyear=curyear+1;
        %            end
        %            yeartimelinelwsw{i,j}(k,1:40)=curyear;
        %        end
        %    end
        %end

        save(strcat('/Volumes/ExternalDriveZ/ERA5_HHLcalcs/fulldistnarraysUVWONLY2017.mat'),'utimeline','vtimeline','wtimeline','datestimelineuvw','yeartimelineuvw','-v7.3');
    end
end


if spedupcorestats_mse==1
    rowstems={'rows1to100';'rows101to200';'rows201to300';'rows301to400';'rows401to500';'rows501to600';'rows601to700';'rows701to721'};
    numrows=[100;100;100;100;100;100;100;21];
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
            file=load(strcat('/Volumes/ExternalDriveZ/ERA5_Hourly_Data/msedailymaxarray',num2str(year)));
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
                %p95msebypoint(actualrow,col)=quantile(reshape(allvalsthiscol,[numyearscalc*90 1]),0.95);
                %p90msebypoint(actualrow,col)=quantile(reshape(allvalsthiscol,[numyearscalc*90 1]),0.90);
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
            file=load(strcat('/Volumes/ExternalDriveZ/ERA5_Hourly_Data/msedailymaxarray',num2str(year)));
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
        %for row=1:numrows(setofrows)
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
                %p95msebypoint(actualrow,col)=quantile(reshape(allvalsthiscol,[numyearscalc*90 1]),0.95);
                %p90msebypoint(actualrow,col)=quantile(reshape(allvalsthiscol,[numyearscalc*90 1]),0.90);
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
            file=load(strcat('/Volumes/ExternalDriveZ/ERA5_Hourly_Data/msedailymaxarray',num2str(year)));
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
                %p95msebypoint(actualrow,col)=quantile(reshape(allvalsthiscol,[numyearscalc*90 1]),0.95);
                %p90msebypoint(actualrow,col)=quantile(reshape(allvalsthiscol,[numyearscalc*90 1]),0.90);
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
            file=load(strcat('/Volumes/ExternalDriveZ/ERA5_Hourly_Data/msedailymaxarray',num2str(year)));
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
        %for row=1:numrows(setofrows)
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
                %p95msebypoint(actualrow,col)=quantile(reshape(allvalsthiscol,[numyearscalc*90 1]),0.95);
                %p90msebypoint(actualrow,col)=quantile(reshape(allvalsthiscol,[numyearscalc*90 1]),0.90);
                p50msebypoint(actualrow,col)=quantile(reshape(allvalsthiscol,[numyearscalc*90 1]),0.50);
            end
        end
        clear mse_climwarmdaysonly;clear dailymaxmsetheserows_allyears;
        disp('finished loop 4');
        fprintf('Row set is %d for MSE\n',setofrows);disp(clock);
        save('/Volumes/ExternalDriveZ/ERA5_Hourly_Data/mseqhqlstatsMAY2021','maxmsebypoint','p999msebypoint','p99msebypoint','p50msebypoint','-append');
    end
    clear temp;
    disp(clock);
end


if spedupcorestats_qh==1
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
            file=load(strcat('/Volumes/ExternalDriveZ/ERA5_Hourly_Data/qharray',num2str(year)));
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
                %p95qhbypoint(actualrow,col)=quantile(reshape(allvalsthiscol,[numyearscalc*90 1]),0.95);
                %p90qhbypoint(actualrow,col)=quantile(reshape(allvalsthiscol,[numyearscalc*90 1]),0.90);
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
            file=load(strcat('/Volumes/ExternalDriveZ/ERA5_Hourly_Data/qharray',num2str(year)));
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
        %for row=1:numrows(setofrows)
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
                %p95qhbypoint(actualrow,col)=quantile(reshape(allvalsthiscol,[numyearscalc*90 1]),0.95);
                %p90qhbypoint(actualrow,col)=quantile(reshape(allvalsthiscol,[numyearscalc*90 1]),0.90);
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
            file=load(strcat('/Volumes/ExternalDriveZ/ERA5_Hourly_Data/qharray',num2str(year)));
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
                %p95qhbypoint(actualrow,col)=quantile(reshape(allvalsthiscol,[numyearscalc*90 1]),0.95);
                %p90qhbypoint(actualrow,col)=quantile(reshape(allvalsthiscol,[numyearscalc*90 1]),0.90);
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
            file=load(strcat('/Volumes/ExternalDriveZ/ERA5_Hourly_Data/qharray',num2str(year)));
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
        %for row=1:numrows(setofrows)
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
                %p95qhbypoint(actualrow,col)=quantile(reshape(allvalsthiscol,[numyearscalc*90 1]),0.95);
                %p90qhbypoint(actualrow,col)=quantile(reshape(allvalsthiscol,[numyearscalc*90 1]),0.90);
                p50qhbypoint(actualrow,col)=quantile(reshape(allvalsthiscol,[numyearscalc*90 1]),0.50);
            end
        end
        clear qh_climwarmdaysonly;clear qhtheserows_allyears;
        disp('finished loop 4');
        fprintf('Row set is %d for qh\n',setofrows);disp(clock);
        save('/Volumes/ExternalDriveZ/ERA5_Hourly_Data/mseqhqlstatsMAY2021','maxqhbypoint','p999qhbypoint','p99qhbypoint','p50qhbypoint','-append');
    end
    clear temp;
    disp(clock);
end



if spedupcorestats_ql==1
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
            file=load(strcat('/Volumes/ExternalDriveZ/ERA5_Hourly_Data/qlarray',num2str(year)));
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
                %p95qlbypoint(actualrow,col)=quantile(reshape(allvalsthiscol,[numyearscalc*90 1]),0.95);
                %p90qlbypoint(actualrow,col)=quantile(reshape(allvalsthiscol,[numyearscalc*90 1]),0.90);
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
            file=load(strcat('/Volumes/ExternalDriveZ/ERA5_Hourly_Data/qlarray',num2str(year)));
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
        %for row=1:numrows(setofrows)
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
                %p95qlbypoint(actualrow,col)=quantile(reshape(allvalsthiscol,[numyearscalc*90 1]),0.95);
                %p90qlbypoint(actualrow,col)=quantile(reshape(allvalsthiscol,[numyearscalc*90 1]),0.90);
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
            file=load(strcat('/Volumes/ExternalDriveZ/ERA5_Hourly_Data/qlarray',num2str(year)));
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
                %p95qlbypoint(actualrow,col)=quantile(reshape(allvalsthiscol,[numyearscalc*90 1]),0.95);
                %p90qlbypoint(actualrow,col)=quantile(reshape(allvalsthiscol,[numyearscalc*90 1]),0.90);
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
            file=load(strcat('/Volumes/ExternalDriveZ/ERA5_Hourly_Data/qlarray',num2str(year)));
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
        %for row=1:numrows(setofrows)
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
                %p95qlbypoint(actualrow,col)=quantile(reshape(allvalsthiscol,[numyearscalc*90 1]),0.95);
                %p90qlbypoint(actualrow,col)=quantile(reshape(allvalsthiscol,[numyearscalc*90 1]),0.90);
                p50qlbypoint(actualrow,col)=quantile(reshape(allvalsthiscol,[numyearscalc*90 1]),0.50);
            end
        end
        clear ql_climwarmdaysonly;clear qltheserows_allyears;
        disp('finished loop 4');
        fprintf('Row set is %d for ql\n',setofrows);disp(clock);
        save('/Volumes/ExternalDriveZ/ERA5_Hourly_Data/mseqhqlstatsMAY2021','maxqlbypoint','p999qlbypoint','p99qlbypoint','p50qlbypoint','-append');
    end
    clear temp;
    disp(clock);
end


%Despite name, plots moist enthalpy vs Tw
if suppfigmsetw==1
    clear samplemse;clear sampletw;
    samplets=0:2:50;sampletds=-20:2:40;samplepsfcs=900:20:1000;
    for psfcord=1:size(samplepsfcs,2)
        samplepsfc=samplepsfcs(psfcord);
        for tord=1:size(samplets,2)
            samplet=samplets(tord)+273.15;
            for tdord=1:size(sampletds,2)
                sampletd=sampletds(tdord)+273.15;
                
                if samplet>=sampletd
                    %MSE
                    vp=calcvpfromTd(sampletd-273.15);
                    mr=622.197.*(vp./(samplepsfc*100-vp))./1000;
                    omega=calcqfromTd_dynamicP(sampletd-273.15,samplepsfc*100);
                    cp=(1005.7.*(1-mr))+(mr.*(1-mr).*1850);
                    sampleqh=cp.*samplet;
                    lv=1918.46.*((samplet./(samplet-33.91)).^2);
                    sampleql=lv.*omega;
                    samplemse(psfcord,tord,tdord)=(sampleqh+sampleql)./1000;

                    %Tw
                    sampletw(psfcord,tord,tdord)=calcwbt_daviesjones(samplet-273.15,samplepsfc*100,omega./1000);
                end
            end
        end
    end
    
    samplemse1d=reshape(samplemse,[size(samplemse,1)*size(samplemse,2)*size(samplemse,3) 1]);
    sampletw1d=reshape(sampletw,[size(sampletw,1)*size(sampletw,2)*size(sampletw,3) 1]);
    
    figure(22);clf;curpart=1;highqualityfiguresetup;
    scatter(samplemse1d,sampletw1d,'filled','k');xlim([270 450]);
    set(gca,'fontweight','bold','fontname','arial','fontsize',12);
    xlabel('Moist Enthalpy (kJ/kg)','fontweight','bold','fontname','arial','fontsize',14);
    ylabel(strcat('Wet-Bulb Temperature (',char(176),'C)'),'fontweight','bold','fontname','arial','fontsize',14);
    figname='msevstwscatter';curpart=2;highqualityfiguresetup;
    
    msetofind=373.7556;twtofind=23.2582;
    for aa=1:size(samplemse,1);for bb=1:size(samplemse,2);for cc=1:size(samplemse,3);if abs(samplemse(aa,bb,cc)-msetofind)<0.001 && ...
    abs(sampletw(aa,bb,cc)-twtofind)<0.001;fprintf('Found at aa=%d,bb=%d,cc=%d\n',aa,bb,cc);end;end;end;end
end


%Eject drives automatically, to be able to get into the computer nicely with a smartcard when returning to work
if trytoejectdrives==1
    if try_d==1;system('diskutil eject ExternalDriveD');end
    if try_c==1;system('diskutil eject ExternalDriveC');end
    if try_z==1;system('diskutil eject ExternalDriveZ');end
end

