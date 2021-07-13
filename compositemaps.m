getclimoforuvwandmse=0; %3 hours per year; REDONE #6 MAY 2021
compositedatareadin=0; %with current intervals, 3.5 hours for region 1; 4 hours for region 2; 4 hours for region 3; 10 hours for region 5 when inclnonextr=1
    regionforcompositestart=2;regionforcompositestop=2; %REDONE #7 MAY 2021; made plots for regs 1-2; have saved reg 3 and 5 (regs 1 and 2 were accidentally erased)
    inclnonextr=1; %default is 1 [when 0, above times are about halved]
producefigs=0; %after reloading, 3 min per region
    needtoreloadformakingmap=1; %about 7 min; necessary if switching the region plotted
    regionnumtoplot=2;
    makemap=1;
    makexsection=1;
        typeofxsection='bigxsection-se'; %'normalxsection' or 'bigxsection' or (for Pakistan only) 'bigxsection-se'
    actualoranom='actual'; %'actual' or 'anom'
         
        
%Previous version of this script (which combined pl and ml data) can be found stored in oldcode.m     


icloud='~/Library/Mobile Documents/com~apple~CloudDocs/';
figloc=strcat(icloud,'General_Academics/Research/Heat_Humidity_Limits/');

regnamesforfigs={'persiangulf';'pakistan';'esasia';'gulfofcalif';'wamazon';'redsea';'naustralia';'midwestus';'caspiansea'};

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
gothru=[9;8;9;7;8;9;9;8;9];
windlev=12;

exist elevera5;
if ans==0
    setup_nctoolbox;
    temp=ncread('elevera5.nc','z');elevera5=(squeeze(temp(:,:,1))./9.81)';elevera5=[elevera5(:,721:1440) elevera5(:,1:720)];
end

exist era5latarray;
if ans==0
    temp=load(strcat(icloud,'General_Academics/Research/Basics/Basics_ERA5/latlonarray'));era5latarray=temp.latarray;era5lonarray=temp.lonarray;
        era5lonarray=[era5lonarray(:,721:1440) era5lonarray(:,1:720)];
end

exist arrwithallp999;
if ans==0
    temp=load('/Volumes/ExternalDriveZ/ERA5_Hourly_Data/toppctilestats');arrwithallp999=temp.arrwithallp999;arrwithallp99=temp.arrwithallp99;
end

exist actualrowstarts;
if ans==0
    %Latitude/longitude bounds for each region
    regsouthbounds=[18.5;21.5;15;23.25;-18.75;13;-21;28;33];regnorthbounds=[35;38;27.5;28.75;-2.5;26;-11;50;49];
    regwestbounds=[43.5;62.5;78.75;-110;-75;34;133;-103;44];regeastbounds=[62.25;77.25;98.75;-104.5;-61.25;44;143;-82;60];
    actualrowstarts=[221;209;251;246;371;257;405;161;165];actualrowstops=[287;275;301;268;436;309;445;249;229];
    actualcolstarts=[894.5;970.5;1035.5;280.5;420.5;856.5;1252.5;308.5;897.5];actualcolstops=[969.5;1029.5;1115.5;302.5;475.5;896.5;1292.5;392.5;960.5];
    actualcolstartsalt=[174.5;250.5;315.5;1000.5;1140.5;136.5;532.5;1028.5;177.5];actualcolstopsalt=[249.5;309.5;395.5;1022.5;1195.5;176.5;572.5;1112.5;240.5];
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
end


%Reminder of region boundaries:
%Persian Gulf -- 23.5-30 N, 48.5-57.25 E
%Pakistan -- 26.5-33 N, 67.5-72.25 E
%E India/Bangladesh -- 15-27.5 N, 78.75-98.75 E
%Gulf of California -- 23.25-28.75 N, 110-104.5 W
%W Amazon -- 18.75-2.5 S, 75-61.25 W
%Red Sea -- 13-26 N, 34-44 E
%N Australia -- 21-11 S, 133-143 E
%Midwest US -- 28-50 N, 103-82 W
%Caspian Sea -- 33-49 N, 44-60 E
    %"Not ML" versions are expanded by 5 deg in every direction, i.e.
    %Persian Gulf -- 18.5-35 N, 43.5-62.25 E
    %Pakistan -- 21.5-38 N, 62.5-77.25 E
    
%Some model-level data is at 281x1161 resolution, which is offset by 200
    %rows and 200 columns from regular 720x1440 ERA5 array dimensions
  
    
    
%Preliminarily: gets diurnal, gridpoint, warm-season climo for making anomaly version of Fig 2
if getclimoforuvwandmse==1
    monstarts=[1;32;60;91;121;152;182;213;244;274;305;335];
    monstops=[31;59;90;120;151;181;212;243;273;304;334;365];
    
    bigureg1=[];bigvreg1=[];bigwreg1=[];bigmsereg1=[];bigmse2mreg1=[];bigstabilreg1=[];bigureg2=[];bigvreg2=[];bigwreg2=[];bigmsereg2=[];bigmse2mreg2=[];bigstabilreg2=[];
    bigureg3=[];bigvreg3=[];bigwreg3=[];bigmsereg3=[];bigmse2mreg3=[];bigstabilreg3=[];bigureg5=[];bigvreg5=[];bigwreg5=[];bigmsereg5=[];bigmse2mreg5=[];bigstabilreg5=[];
            
    for thisyear=2016:2017
        %For MSE using 2-m data
        ttdfile=ncgeodataset(strcat('/Volumes/ExternalDriveZ/ERA5_Hourly_Data/ttd_world_',num2str(thisyear),'.grib'));
        psfcfile=ncgeodataset(strcat('/Volumes/ExternalDriveC/ERA5_Hourly_Data_PandGHonly/psfc_world_',num2str(thisyear),'.grib'));
        pblhfile=ncgeodataset(strcat('/Volumes/ExternalDriveC/ERA5_Hourly_Data_PBLheight_only/pblh_world_',num2str(thisyear),'.grib'));
        
        for thismon=1:12
            monstart=monstarts(thismon);monstop=monstops(thismon);monlen=monstop-monstart+1;   

            if thismon~=3 && thismon~=4
            if thismon<=9;mzero='0';else;mzero='';end
            file=ncgeodataset(strcat('/Volumes/ExternalDriveD/ERA5_modelleveldata/tq_',num2str(thisyear),mzero,num2str(thismon),'.grib'));
            tmltemp=file{'t'};echo off;qmltemp=file{'q'};echo off;clear file;
            
            %Get model-level wind data
            uvwfile=ncgeodataset(strcat('/Volumes/ExternalDriveD/ERA5_modelleveldata/uvw_',num2str(thisyear),mzero,num2str(thismon),'.grib'));
            utemp=uvwfile{'u'};echo off;vtemp=uvwfile{'v'};echo off;wtemp=uvwfile{'w'};echo off;clear uvwfile;
      
                
            %Rows/cols are based on the full ERA5 721x1440 grid
            for regloop=1:5
                if regloop~=4
                continueon=0;
                if regloop<=3
                    regord=regloop;if thismon>=5 && thismon<=9;continueon=1;end
                else
                    regord=4;if thismon<=3 || thismon>=11;continueon=1;end
                end
                
                if continueon==1
                    era5rowstart=actualrowstarts(regloop);era5rowstop=actualrowstops(regloop);
                    era5colstart=actualcolstarts(regloop);era5colstop=actualcolstops(regloop);

                    %Rows/cols based on regional subsets of model-level grid (unrotated)
                    regsubsetrowstart=mlstartrows(regloop);regsubsetrowstop=mlstoprows(regloop); %model-level-data grid
                    regsubsetcolstart=mlstartcols(regloop);regsubsetcolstop=mlstopcols(regloop);
                    regsubsetminlat=regsouthbounds(regloop);regsubsetmaxlat=regnorthbounds(regloop);regsubsetminlon=regwestbounds(regloop);regsubsetmaxlon=regeastbounds(regloop);
                    
                    regionlats=regsubsetmaxlat:-0.25:regsubsetminlat;regionlons=regsubsetminlon:0.25:regsubsetmaxlon;
                    clear regularlatgrid;clear regularlongrid;clear regularlatgrid_minus1row;clear regularlongrid_minus1row;
                    for i=1:size(regionlats,2)
                        for j=1:size(regionlons,2)
                            regularlatgrid(i,j)=regionlats(i);
                            regularlongrid(i,j)=regionlons(j);
                        end
                    end
                    %Rotate regularlat/longrid to match orientation of ml grids
                    regularlatgrid=regularlatgrid';regularlongrid=regularlongrid';
                    for i=2:size(regularlatgrid,1)
                        regularlatgrid_minus1row(i-1,:)=(regularlatgrid(i-1,:)+regularlatgrid(i,:))./2;
                        regularlongrid_minus1row(i-1,:)=(regularlongrid(i-1,:)+regularlongrid(i,:))./2;
                    end


                    if era5colstart>720
                        era5colstart_forplotting=era5colstart-720;era5colstop_forplotting=era5colstop-720;
                    else
                        era5colstart_forplotting=era5colstart+720;era5colstop_forplotting=era5colstop+720;
                    end

                    %Rows/cols based on subsets of ERA5 grid
                    rowstart_281x1161grid=era5rowstart-200;rowstop_281x1161grid=era5rowstop-200;
                    colstart_281x1161grid=era5colstart-200;colstop_281x1161grid=era5colstop-200;

                    t=squeeze(double(tmltemp.data(1:monlen*8,:,rowstart_281x1161grid:rowstop_281x1161grid,colstart_281x1161grid:colstop_281x1161grid)));
                    q=squeeze(double(qmltemp.data(1:monlen*8,:,rowstart_281x1161grid:rowstop_281x1161grid,colstart_281x1161grid:colstop_281x1161grid)));
                    u=squeeze(double(utemp.data(1:monlen*8,:,rowstart_281x1161grid:rowstop_281x1161grid,colstart_281x1161grid:colstop_281x1161grid)));
                    v=squeeze(double(vtemp.data(1:monlen*8,:,rowstart_281x1161grid:rowstop_281x1161grid,colstart_281x1161grid:colstop_281x1161grid)));
                    w=squeeze(double(wtemp.data(1:monlen*8,:,rowstart_281x1161grid:rowstop_281x1161grid,colstart_281x1161grid:colstop_281x1161grid)));


                    if (regloop==5 && thismon==1) || (regloop<=3 && thismon==5) %first month of this year in this region
                        ttemp=ttdfile{'2_metre_temperature_surface'};echo off;
                        t2m=double(ttemp.data(:,era5rowstart:era5rowstop,era5colstart_forplotting-0.5:era5colstop_forplotting+0.5));clear ttemp;
                        tdtemp=ttdfile{'2_metre_dewpoint_temperature_surface'};echo off;
                            td2m=double(tdtemp.data(:,era5rowstart:era5rowstop,era5colstart_forplotting-0.5:era5colstop_forplotting+0.5))-273.15;clear tdtemp;
                        psfctemp=psfcfile{'Surface_pressure_surface'};echo off;
                            psfc=double(psfctemp.data(:,era5rowstart:era5rowstop,era5colstart-0.5:era5colstop+0.5));clear psfctemp;
                        pblhtemp=pblhfile{'Boundary_layer_height_surface'};echo off;
                            pblh=double(pblhtemp.data(:,era5rowstart:era5rowstop,era5colstart-0.5:era5colstop+0.5));clear pblhtemp;

                        newa=0;clear newt2m;
                        for a=2:size(t2m,3);newa=newa+1;newt2m(:,:,newa)=squeeze(mean(t2m(:,:,a-1:a),3));end;clear t2m;
                        t2mforyear=newt2m;clear newt2m;
                        newa=0;clear newtd2m;
                        for a=2:size(td2m,3);newa=newa+1;newtd2m(:,:,newa)=squeeze(mean(td2m(:,:,a-1:a),3));end;clear td2m;
                        td2mforyear=newtd2m;clear newtd2m;
                        newa=0;clear newpsfc;
                        for a=2:size(psfc,3);newa=newa+1;newpsfc(:,:,newa)=squeeze(mean(psfc(:,:,a-1:a),3));end
                        psfcforyear=newpsfc;clear newpsfc;
                        newa=0;clear newpblh;
                        for a=2:size(pblh,3);newa=newa+1;newpblh(:,:,newa)=squeeze(mean(pblh(:,:,a-1:a),3));end
                        pblhforyear=newpblh;clear newpblh;

                        vp=calcvpfromTd(td2mforyear);
                        mr=622.197.*(vp./(psfcforyear-vp))./1000;
                        omega=calcqfromTd_dynamicP(td2mforyear,psfcforyear);clear td2mforyear; %convert to unitless specific humidity
                        %cp=1005.7.*(1+1.83.*mr);clear mr; %J K^-1 kg^-1; Stull, Practical Meteorology
                        cp=(1005.7.*(1-mr))+(mr.*(1-mr).*1850);clear mr;
                        qh2mforyear=cp.*t2mforyear;clear cp;
                        lv=1918.46.*((t2mforyear./(t2mforyear-33.91)).^2);clear t2mforyear; %J/kg; Henderson-Sellers 1984
                        ql2mforyear=lv.*omega;clear lv;clear omega; %J/kg
                        mse2mforyear=(qh2mforyear+ql2mforyear)./1000;clear qh2mforyear;clear ql2mforyear;
                        
                        if regloop==1
                            psfcforyearreg1=psfcforyear;mse2mforyearreg1=mse2mforyear;pblhforyearreg1=pblhforyear;
                        elseif regloop==2
                            psfcforyearreg2=psfcforyear;mse2mforyearreg2=mse2mforyear;pblhforyearreg2=pblhforyear;
                        elseif regloop==3
                            psfcforyearreg3=psfcforyear;mse2mforyearreg3=mse2mforyear;pblhforyearreg3=pblhforyear;
                        elseif regloop==5
                            psfcforyearreg5=psfcforyear;mse2mforyearreg5=mse2mforyear;pblhforyearreg5=pblhforyear;
                        end
                    end


                    %Get geopotential height of model levels
                    if regloop==1
                        psfc=squeeze(psfcforyearreg1(monstart*8-7:monstop*8,:,:));pblh=squeeze(pblhforyearreg1(monstart*8-7:monstop*8,:,:));
                    elseif regloop==2
                        psfc=squeeze(psfcforyearreg2(monstart*8-7:monstop*8,:,:));pblh=squeeze(pblhforyearreg2(monstart*8-7:monstop*8,:,:));
                    elseif regloop==3
                        psfc=squeeze(psfcforyearreg3(monstart*8-7:monstop*8,:,:));pblh=squeeze(pblhforyearreg3(monstart*8-7:monstop*8,:,:));
                    elseif regloop==5
                        psfc=squeeze(psfcforyearreg5(monstart*8-7:monstop*8,:,:));pblh=squeeze(pblhforyearreg5(monstart*8-7:monstop*8,:,:));
                    end
                    elevs_here=elevera5(era5rowstart:era5rowstop,era5colstart:era5colstop);
                    elev_rep=NaN.*ones(size(psfc,1),size(psfc,2),size(psfc,3));for hh=1:size(psfc,1);elev_rep(hh,:,:)=elevs_here;end
                    clear z_ml;
                    for aa=1:size(t,1)
                        for kk=1:size(t,2)
                            clear t_here;clear q_here;clear psfc_here;clear ghsfc_here;
                            k=mls_retrieved(kk);
                            t_here=squeeze(t(aa,:,:,:));
                            q_here=squeeze(q(aa,:,:,:));
                            psfc_here=squeeze(psfc(aa,:,:))./100;
                            ghsfc_here=squeeze(elev_rep(aa,:,:));
                            era5ghofmodellevels;
                            z_ml(aa,kk,:,:)=gp_here./9.81;
                            clear t_here;clear q_here;clear psfc_here;clear ghsfc_here;
                        end
                    end

                    %Get MSE2m data for this month
                    if regloop==1
                        mse2m=squeeze(mse2mforyearreg1(monstart*8-7:monstop*8,:,:));
                    elseif regloop==2
                        mse2m=squeeze(mse2mforyearreg2(monstart*8-7:monstop*8,:,:));
                    elseif regloop==3
                        mse2m=squeeze(mse2mforyearreg3(monstart*8-7:monstop*8,:,:));
                    elseif regloop==5
                        mse2m=squeeze(mse2mforyearreg5(monstart*8-7:monstop*8,:,:));
                    end

                    %Compute MSE [profile] data for this month
                    pressures_forml_rep=repmat(pressures_forml,[1,(monstop-monstart+1)*8,size(t,3),size(t,4)]);pressures_forml_rep=permute(pressures_forml_rep,[2 1 3 4]);

                    td=calcTdfromq(q.*1000,pressures_forml_rep);
                    vp=calcvpfromTd(td)./100; %in hPa
                    mr=622.197.*(vp./(pressures_forml_rep-vp))./1000;
                    omega=calcqfromTd_dynamicP(td,pressures_forml_rep.*100); %convert to unitless specific humidity
                    omega_sat=calcqfromTd_dynamicP(t-273.15,pressures_forml_rep.*100);
                    %cp=1005.7.*(1+1.83.*mr);clear mr; %J K^-1 kg^-1; Stull, Practical Meteorology
                    cp=(1005.7.*(1-mr))+(mr.*(1-mr).*1850);clear mr;
                    qh=cp.*t;clear cp;
                    lv=1918.46.*((t./(t-33.91)).^2); %J/kg; Henderson-Sellers 1984
                    ql=lv.*omega;clear omega; %J/kg
                    ql_sat=lv.*omega_sat;clear lv;clear omega_sat;
                    mse=(qh+ql+9.81.*z_ml)./1000;
                    mse_sat=(qh+ql_sat+9.81.*z_ml)./1000;

                    %Interpolate u, v, w, z, MSE, and PBL height (if necessary) to the main model lat/lon grid 
                    mllatgrid=mllats_unrotated(regsubsetrowstart-1:regsubsetrowstop+1,regsubsetcolstart-1:regsubsetcolstop+1);
                    mllongrid=mllons_unrotated(regsubsetrowstart-1:regsubsetrowstop+1,regsubsetcolstart-1:regsubsetcolstop+1);
                    clear u_here;clear v_here;clear w_here;clear z_ml_here;clear mse_here;clear mse_sat_here;
                    for g=1:size(u,1)
                        for gg=1:size(u,2)
                            u_here(g,gg,:,:)=interp2(regularlatgrid,regularlongrid,squeeze(u(g,gg,:,:))',mllatgrid,mllongrid);
                            v_here(g,gg,:,:)=interp2(regularlatgrid,regularlongrid,squeeze(v(g,gg,:,:))',mllatgrid,mllongrid);
                            w_here(g,gg,:,:)=interp2(regularlatgrid,regularlongrid,squeeze(w(g,gg,:,:))',mllatgrid,mllongrid);
                            z_ml_here(g,gg,:,:)=interp2(regularlatgrid,regularlongrid,squeeze(z_ml(g,gg,:,:))',mllatgrid,mllongrid);
                            mse_here(g,gg,:,:)=interp2(regularlatgrid,regularlongrid,squeeze(mse(g,gg,:,:))',mllatgrid,mllongrid);
                            mse_sat_here(g,gg,:,:)=interp2(regularlatgrid,regularlongrid,squeeze(mse_sat(g,gg,:,:))',mllatgrid,mllongrid);
                        end
                    end
                    u=u_here;v=v_here;w=w_here;z_ml=z_ml_here;mse=mse_here;mse_sat=mse_sat_here;
                    clear u_here;clear v_here;clear w_here;clear z_ml_here;clear mse_here;clear mse_sat_here;
                    
                    clear mse2m_here;clear pblh_here;
                    for g=1:size(u,1)
                        if regloop<9
                            mse2m_here(g,:,:)=interp2(regularlatgrid,regularlongrid,squeeze(mse2m(g,:,:))',mllatgrid,mllongrid);
                            pblh_here(g,:,:)=interp2(regularlatgrid,regularlongrid,squeeze(pblh(g,:,:))',mllatgrid,mllongrid);
                        else
                            mse2m_here(g,:,:)=interp2(regularlatgrid_minus1row,regularlongrid_minus1row,squeeze(mse2m(g,:,:))',mllatgrid,mllongrid);
                        end
                    end
                    mse2m=mse2m_here;pblh=pblh_here;
                    clear mse2m_here;clear pblh_here;
                    
                    
                    %Compute stability ('lid strength') as the difference between the 2-m
                        %MSE and the maximum *saturated* MSE between the top of the PBL and 500 mb
                    maxsatmse=NaN.*ones(size(mse2m,1),size(mse2m,2),size(mse2m,3));
                    stabil=NaN.*ones(size(mse2m,1),size(mse2m,2),size(mse2m,3));
                    for x1=1:size(mse2m,1)
                        for x2=1:size(mse2m,2)
                            for x3=1:size(mse2m,3)
                                thesezs=z_ml(x1,:,x2,x3);
                                thispblh=pblh(x1,x2,x3);
                                if ~sum(~isnan(thesezs)==0)
                                    [~,indoflast]=find(thesezs>thispblh,1,'last');
                                    if indoflast>=3 %i.e. if PBL height is lower in the atmosphere than 500 mb
                                        maxsatmse(x1,x2,x3)=max(mse_sat(x1,3:indoflast,x2,x3));
                                        stabil(x1,x2,x3)=maxsatmse(x1,x2,x3)-mse2m(x1,x2,x3);
                                    end
                                end
                            end
                        end
                    end
                    docheck=0;
                    if docheck==1
                        figure(55);clf;
                        plot(flipud(squeeze(mean(mse_sat(:,:,22,44)))'),1:12,'r','linewidth',2);hold on;
                        plot(flipud(squeeze(mean(mse(:,:,22,44)))'),1:12,'b','linewidth',2);
                        set(gca,'fontsize',12,'fontweight','bold','fontname','arial');
                        set(gca,'yticklabel',{'';'60';'225';'500';'1500';'5500';'12000'});
                        title('Desert near 23N, 49E (May 2014 mean)','fontsize',16,'fontweight','bold','fontname','arial');
                        ylabel('Altitude Above Ground (m)','fontsize',14,'fontweight','bold','fontname','arial');
                        xlabel('MSE or Saturated MSE (kJ/kg)','fontsize',14,'fontweight','bold','fontname','arial');
                        
                        plot(320:10:410,6.8.*ones(1,10),'color','k','linestyle','--','linewidth',2);
                        %t=text(0.76,0.93,'Mean PBL height: 854 m','units','normalized');set(t,'fontsize',14,'fontweight','bold','fontname','arial');
                        %mean(pblh(:,22,44)) %854 m
                        
                        
                        figure(56);clf;
                        plot(flipud(squeeze(mean(mse_sat(:,:,35,36)))'),1:12,'r','linewidth',2);hold on;
                        plot(flipud(squeeze(mean(mse(:,:,35,36)))'),1:12,'b','linewidth',2);
                        set(gca,'fontsize',12,'fontweight','bold','fontname','arial');
                        set(gca,'yticklabel',{'';'60';'225';'500';'1500';'5500';'12000'});
                        title('Persian Gulf near 25N, 53E (May 2014 mean)','fontsize',16,'fontweight','bold','fontname','arial');
                        ylabel('Altitude Above Ground (m)','fontsize',14,'fontweight','bold','fontname','arial');
                        xlabel('MSE or Saturated MSE (kJ/kg)','fontsize',14,'fontweight','bold','fontname','arial');
                        
                        %plot(320:10:410,6.8.*ones(1,10),'color','k','linestyle','--','linewidth',2);
                    end
                    

                    if regloop==1
                        bigureg1=cat(1,bigureg1,u);bigvreg1=cat(1,bigvreg1,v);bigwreg1=cat(1,bigwreg1,w);bigmsereg1=cat(1,bigmsereg1,mse);
                        bigmse2mreg1=cat(1,bigmse2mreg1,mse2m);bigstabilreg1=cat(1,bigstabilreg1,stabil);
                    elseif regloop==2
                        bigureg2=cat(1,bigureg2,u);bigvreg2=cat(1,bigvreg2,v);bigwreg2=cat(1,bigwreg2,w);bigmsereg2=cat(1,bigmsereg2,mse);
                        bigmse2mreg2=cat(1,bigmse2mreg2,mse2m);bigstabilreg2=cat(1,bigstabilreg2,stabil);
                    elseif regloop==3
                        bigureg3=cat(1,bigureg3,u);bigvreg3=cat(1,bigvreg3,v);bigwreg3=cat(1,bigwreg3,w);bigmsereg3=cat(1,bigmsereg3,mse);
                        bigmse2mreg3=cat(1,bigmse2mreg3,mse2m);bigstabilreg3=cat(1,bigstabilreg3,stabil);
                    elseif regloop==5
                        bigureg5=cat(1,bigureg5,u);bigvreg5=cat(1,bigvreg5,v);bigwreg5=cat(1,bigwreg5,w);bigmsereg5=cat(1,bigmsereg5,mse);
                        bigmse2mreg5=cat(1,bigmse2mreg5,mse2m);bigstabilreg5=cat(1,bigstabilreg5,stabil);
                    end

                    clear u;clear v;clear w;clear mse;clear mse2m;clear stabil;
                end
                end
            end
            end
            clear qmltemp;clear tmltemp;clear utemp;clear vtemp;clear wtemp;
            fprintf('Completed month %d\n',thismon);
        end
        clear pblhfile;clear psfcfile;clear ttdfile;
        fprintf('Completed year %d\n',thisyear);
    end
    bigureg1new=reshape(bigureg1,[8,size(bigureg1,1)/8,size(bigureg1,2),size(bigureg1,3),size(bigureg1,4)]);clear bigureg1;
    bigureg2new=reshape(bigureg2,[8,size(bigureg2,1)/8,size(bigureg2,2),size(bigureg2,3),size(bigureg2,4)]);clear bigureg2;
    bigureg3new=reshape(bigureg3,[8,size(bigureg3,1)/8,size(bigureg3,2),size(bigureg3,3),size(bigureg3,4)]);clear bigureg3;
    bigureg5new=reshape(bigureg5,[8,size(bigureg5,1)/8,size(bigureg5,2),size(bigureg5,3),size(bigureg5,4)]);clear bigureg5;
    
    bigvreg1new=reshape(bigvreg1,[8,size(bigvreg1,1)/8,size(bigvreg1,2),size(bigvreg1,3),size(bigvreg1,4)]);clear bigvreg1;
    bigvreg2new=reshape(bigvreg2,[8,size(bigvreg2,1)/8,size(bigvreg2,2),size(bigvreg2,3),size(bigvreg2,4)]);clear bigvreg2;
    bigvreg3new=reshape(bigvreg3,[8,size(bigvreg3,1)/8,size(bigvreg3,2),size(bigvreg3,3),size(bigvreg3,4)]);clear bigvreg3;
    bigvreg5new=reshape(bigvreg5,[8,size(bigvreg5,1)/8,size(bigvreg5,2),size(bigvreg5,3),size(bigvreg5,4)]);clear bigvreg5;
    
    bigwreg1new=reshape(bigwreg1,[8,size(bigwreg1,1)/8,size(bigwreg1,2),size(bigwreg1,3),size(bigwreg1,4)]);clear bigwreg1;
    bigwreg2new=reshape(bigwreg2,[8,size(bigwreg2,1)/8,size(bigwreg2,2),size(bigwreg2,3),size(bigwreg2,4)]);clear bigwreg2;
    bigwreg3new=reshape(bigwreg3,[8,size(bigwreg3,1)/8,size(bigwreg3,2),size(bigwreg3,3),size(bigwreg3,4)]);clear bigwreg3;
    bigwreg5new=reshape(bigwreg5,[8,size(bigwreg5,1)/8,size(bigwreg5,2),size(bigwreg5,3),size(bigwreg5,4)]);clear bigwreg5;
    
    bigmsereg1new=reshape(bigmsereg1,[8,size(bigmsereg1,1)/8,size(bigmsereg1,2),size(bigmsereg1,3),size(bigmsereg1,4)]);clear bigmsereg1;
    bigmsereg2new=reshape(bigmsereg2,[8,size(bigmsereg2,1)/8,size(bigmsereg2,2),size(bigmsereg2,3),size(bigmsereg2,4)]);clear bigmsereg2;
    bigmsereg3new=reshape(bigmsereg3,[8,size(bigmsereg3,1)/8,size(bigmsereg3,2),size(bigmsereg3,3),size(bigmsereg3,4)]);clear bigmsereg3;
    bigmsereg5new=reshape(bigmsereg5,[8,size(bigmsereg5,1)/8,size(bigmsereg5,2),size(bigmsereg5,3),size(bigmsereg5,4)]);clear bigmsereg5;
    
    bigmse2mreg1new=reshape(bigmse2mreg1,[8,size(bigmse2mreg1,1)/8,size(bigmse2mreg1,2),size(bigmse2mreg1,3),size(bigmse2mreg1,4)]);clear bigmse2mreg1;
    bigmse2mreg2new=reshape(bigmse2mreg2,[8,size(bigmse2mreg2,1)/8,size(bigmse2mreg2,2),size(bigmse2mreg2,3),size(bigmse2mreg2,4)]);clear bigmse2mreg2;
    bigmse2mreg3new=reshape(bigmse2mreg3,[8,size(bigmse2mreg3,1)/8,size(bigmse2mreg3,2),size(bigmse2mreg3,3),size(bigmse2mreg3,4)]);clear bigmse2mreg3;
    bigmse2mreg5new=reshape(bigmse2mreg5,[8,size(bigmse2mreg5,1)/8,size(bigmse2mreg5,2),size(bigmse2mreg5,3),size(bigmse2mreg5,4)]);clear bigmse2mreg5;
    
    bigstabilreg1new=reshape(bigstabilreg1,[8,size(bigstabilreg1,1)/8,size(bigstabilreg1,2),size(bigstabilreg1,3),size(bigstabilreg1,4)]);clear bigstabilreg1;
    bigstabilreg2new=reshape(bigstabilreg2,[8,size(bigstabilreg2,1)/8,size(bigstabilreg2,2),size(bigstabilreg2,3),size(bigstabilreg2,4)]);clear bigstabilreg2;
    bigstabilreg3new=reshape(bigstabilreg3,[8,size(bigstabilreg3,1)/8,size(bigstabilreg3,2),size(bigstabilreg3,3),size(bigstabilreg3,4)]);clear bigstabilreg3;
    bigstabilreg5new=reshape(bigstabilreg5,[8,size(bigstabilreg5,1)/8,size(bigstabilreg5,2),size(bigstabilreg5,3),size(bigstabilreg5,4)]);clear bigstabilreg5;
    
    uclimoreg1=squeeze(mean(bigureg1new,2));uclimoreg2=squeeze(mean(bigureg2new,2));uclimoreg3=squeeze(mean(bigureg3new,2));uclimoreg5=squeeze(mean(bigureg5new,2));
    vclimoreg1=squeeze(mean(bigvreg1new,2));vclimoreg2=squeeze(mean(bigvreg2new,2));vclimoreg3=squeeze(mean(bigvreg3new,2));vclimoreg5=squeeze(mean(bigvreg5new,2));
    wclimoreg1=squeeze(mean(bigwreg1new,2));wclimoreg2=squeeze(mean(bigwreg2new,2));wclimoreg3=squeeze(mean(bigwreg3new,2));wclimoreg5=squeeze(mean(bigwreg5new,2));
    mseclimoreg1=squeeze(mean(bigmsereg1new,2));mseclimoreg2=squeeze(mean(bigmsereg2new,2));mseclimoreg3=squeeze(mean(bigmsereg3new,2));mseclimoreg5=squeeze(mean(bigmsereg5new,2));
    mse2mclimoreg1=squeeze(mean(bigmse2mreg1new,2));mse2mclimoreg2=squeeze(mean(bigmse2mreg2new,2));mse2mclimoreg3=squeeze(mean(bigmse2mreg3new,2));mse2mclimoreg5=squeeze(mean(bigmse2mreg5new,2));
    stabilclimoreg1=squeeze(mean(bigstabilreg1new,2));stabilclimoreg2=squeeze(mean(bigstabilreg2new,2));stabilclimoreg3=squeeze(mean(bigstabilreg3new,2));stabilclimoreg5=squeeze(mean(bigstabilreg5new,2));
    save('/Volumes/ExternalDriveZ/ERA5_HHLcalcs/climoforcompositesMAY2021.mat','uclimoreg1','uclimoreg2','uclimoreg3','uclimoreg5',...
        'vclimoreg1','vclimoreg2','vclimoreg3','vclimoreg5','wclimoreg1','wclimoreg2','wclimoreg3','wclimoreg5',...
        'mseclimoreg1','mseclimoreg2','mseclimoreg3','mseclimoreg5','mse2mclimoreg1','mse2mclimoreg2','mse2mclimoreg3','mse2mclimoreg5',...
        'stabilclimoreg1','stabilclimoreg2','stabilclimoreg3','stabilclimoreg5');
    
    
    clear tmltemp;clear qmltemp;clear ttemp;clear utemp;clear vtemp;clear wtemp;
    clear bigureg1new;clear bigureg2new;clear bigureg3new;clear bigureg5new;
    clear bigvreg1new;clear bigvreg2new;clear bigvreg3new;clear bigvreg5new;
    clear bigwreg1new;clear bigwreg2new;clear bigwreg3new;clear bigwreg5new;
    clear bigmsereg1new;clear bigmsereg2new;clear bigmsereg3new;clear bigmsereg5new;
    clear bigmse2mreg1new;clear bigmse2mreg2new;clear bigmse2mreg3new;clear bigmse2mreg5new;
    clear mse2mforyearreg1;clear mse2mforyearreg2;clear mse2mforyearreg3;clear mse2mforyearreg5;
    %clear bigstabilreg1new;clear bigstabilreg2new;clear bigstabilreg3new;clear bigstabilreg5new;
    %clear stabilforyearreg1;clear stabilforyearreg2;clear stabilforyearreg3;clear stabilforyearreg5;
    clear pblhforyearreg1;clear pblhforyearreg2;clear pblhforyearreg3;clear pblhforyearreg5;
    clear psfcforyearreg1;clear psfcforyearreg2;clear psfcforyearreg3;clear psfcforyearreg5;
end


if compositedatareadin==1
    for regloop=regionforcompositestart:regionforcompositestop
        if regloop~=4
            regname=regnamesforfigs{regloop};
            fnameadd='';
            if regloop==1
                regiontoplot=regname;firstmonth=5;lastmonth=9;
                startyear=2013;stopyear=2018;
                interval=4; %every nth day (for speed); 30 for all of PG, 4 for south shore only, 2 for Abu Dhabi box only
                fnameadd='_EXP';
            elseif regloop==2
                regiontoplot=regname;firstmonth=5;lastmonth=9;
                startyear=2013;stopyear=2018;
                interval=5; %default: 5
                fnameadd='_EXP';
            elseif regloop==3
                regiontoplot=regname;firstmonth=5;lastmonth=9;
                startyear=2013;stopyear=2018;
                interval=20;
            elseif regloop==4
                regiontoplot=regname;firstmonth=5;lastmonth=9;
                startyear=2009;stopyear=2018;
                interval=5;
            elseif regloop==5
                regiontoplot=regname;firstmonth=11;lastmonth=2;
                startyear=2013;stopyear=2018;
                interval=5;
            elseif regloop==6
                regiontoplot=regname;firstmonth=5;lastmonth=9;
                startyear=2015;stopyear=2018;
                interval=10; %every nth day
            elseif regloop==7
                regiontoplot=regname;firstmonth=11;lastmonth=2;
                startyear=2010;stopyear=2018;
                interval=1;
            elseif regloop==8
                regiontoplot=regname;firstmonth=5;lastmonth=9;
                startyear=2011;stopyear=2018;
                interval=1;
            elseif regloop==9
                regiontoplot=regname;firstmonth=5;lastmonth=9;
                startyear=2014;stopyear=2018;
                interval=1;
            end
            
            

            
            %Rows/cols based on full ERA5 721x1440 grid
            era5rowstart=actualrowstarts(regloop);era5rowstop=actualrowstops(regloop);
            era5colstart=actualcolstarts(regloop);era5colstop=actualcolstops(regloop);
            
            %Rows/cols based on regional subsets of model-level grid (unrotated)
            regsubsetrowstart=mlstartrows(regloop);regsubsetrowstop=mlstoprows(regloop); %model-level-data grid
            regsubsetcolstart=mlstartcols(regloop);regsubsetcolstop=mlstopcols(regloop);
            regsubsetminlat=regsouthbounds(regloop);regsubsetmaxlat=regnorthbounds(regloop);regsubsetminlon=regwestbounds(regloop);regsubsetmaxlon=regeastbounds(regloop);
            
            %Rows/cols based on subsets of ERA5 grid
            rowstart_281x1161grid=era5rowstart-200;rowstop_281x1161grid=era5rowstop-200;
            colstart_281x1161grid=era5colstart-200;colstop_281x1161grid=era5colstop-200;
                            

            if era5colstart>720
                era5colstart_forplotting=era5colstart-720;era5colstop_forplotting=era5colstop-720;
            else
                era5colstart_forplotting=era5colstart+720;era5colstop_forplotting=era5colstop+720;
            end
            
            
            exist elevera5;
            if ans==0
                temp=ncread('elevera5.nc','z');elevera5=(squeeze(temp(:,:,1))./9.81)';
                elevera5=[elevera5(:,721:1440) elevera5(:,1:720)];
            end

            
            %Subset to get only days in the years and region of interest
            if regloop==1 || regloop==2
                temp=find(arrwithallp999(:,1)>=startyear & arrwithallp999(:,1)<=stopyear);yearssubset=arrwithallp999(temp,:);
            elseif regloop==4 || regloop==5 || regloop==7
                temp=find(arrwithallp99(:,1)>=startyear & arrwithallp99(:,1)<=stopyear);yearssubset=arrwithallp99(temp,:);
            elseif regloop==8 || regloop==9
                temp=find(arrwithallp99formidlats(:,1)>=startyear & arrwithallp99formidlats(:,1)<=stopyear);yearssubset=arrwithallp99formidlats(temp,:);
            else
                temp=find(arrwithallp995(:,1)>=startyear & arrwithallp995(:,1)<=stopyear);yearssubset=arrwithallp995(temp,:);
            end
            newro=0;clear regsubset;
            for ro=1:size(yearssubset,1)
                if yearssubset(ro,3)>=era5rowstart && yearssubset(ro,3)<=era5rowstop && ...
                    yearssubset(ro,4)>=era5colstart+0.5 && yearssubset(ro,4)<=era5colstop-0.5
                    newro=newro+1;
                    regsubset(newro,:)=yearssubset(ro,:);
                end
            end
            regsubsetchron=sortrows(regsubset,[1 2]);

            regionlats=regsubsetmaxlat:-0.25:regsubsetminlat;regionlons=regsubsetminlon:0.25:regsubsetmaxlon;
            clear regularlatgrid;clear regularlongrid;clear regularlatgrid_minus1row;clear regularlongrid_minus1row;
            for i=1:size(regionlats,2)
                for j=1:size(regionlons,2)
                    regularlatgrid(i,j)=regionlats(i);
                    regularlongrid(i,j)=regionlons(j);
                end
            end
            %Rotate regularlat/longrid to match orientation of ml grids
            regularlatgrid=regularlatgrid';regularlongrid=regularlongrid';
            for i=2:size(regularlatgrid,1)
                regularlatgrid_minus1row(i-1,:)=(regularlatgrid(i-1,:)+regularlatgrid(i,:))./2;
                regularlongrid_minus1row(i-1,:)=(regularlongrid(i-1,:)+regularlongrid(i,:))./2;
            end

            %NCEP unrotated lat/lon grids
            nceplat_unro=90:-2.5:-90;nceplon_unro=0:2.5:357.5;westernhem=nceplon_unro>180;nceplon_unro(westernhem)=nceplon_unro(westernhem)-360;


            %Calculations with both 2-m and model-level data
            prevyear=0;prevmon=0;prevdoy=0;extremec=0;
            clear bigu;clear bigv;clear bigw;clear biggh;
                clear bigu_nonextr;clear bigv_nonextr;clear bigw_nonextr;clear biggh_nonextr;
            clear bigmse;clear bigqh;clear bigql;clear bigt;clear bigtd;
                clear bigmse_nonextr;clear bigqh_nonextr;clear bigql_nonextr;clear bigt_nonextr;clear bigtd_nonextr;
            clear bigmse2m;clear bigqh2m;clear bigql2m;clear bigt2m;clear bigtd2m;
                clear bigmse2m_nonextr;clear bigqh2m_nonextr;clear bigql2m_nonextr;clear bigt2m_nonextr;clear bigtd2m_nonextr;
            clear yeararray;clear doyarray;clear homarray;clear iarray;clear presmlarray;clear zmlarray;
                clear yeararray_nonextr;clear doyarray_nonextr;clear homarray_nonextr;clear presmlarray_nonextr;clear zmlarray_nonextr;
            for i=1:interval:size(regsubsetchron,1)
                thisyear=regsubsetchron(i,1);thismon=DOYtoMonth(regsubsetchron(i,2),thisyear);thisdom=DOYtoDOM(regsubsetchron(i,2),thisyear);
                doyhere=regsubsetchron(i,2);
                thislat=era5latarray(regsubsetchron(i,3),regsubsetchron(i,4));thislon=era5lonarray(regsubsetchron(i,3),regsubsetchron(i,4));
                if thismon==2;thismonlen=28;elseif thismon==1 || thismon==3 || thismon==5 || thismon==7 || thismon==8 || thismon==10 || thismon==12;thismonlen=31;else;thismonlen=30;end
                if thisyear<=2013;modellevdataloc='ExternalDriveF/ERA5_modelleveldata_0000to2013';else;modellevdataloc='ExternalDriveD/ERA5_modelleveldata';end
                
                %For Persian Gulf, limit to south shore around Abu Dhabi
                %For Midwest, limit to Missouri northward
                if regloop==1
                    clear borderlats;clear borderlons;
                    borderlats=[23.5;25.5;25.5;23.5];borderlons=[53.4;53.4;55.4;55.4];
                    checkifinside=inpolygon(thislat,thislon,borderlats,borderlons);
                elseif regloop==8
                    clear borderlats;clear borderlons;
                    borderlats=[40;50;50;40];borderlons=[-103;-103;-82;-82];
                    checkifinside=inpolygon(thislat,thislon,borderlats,borderlons);
                else
                    checkifinside=1;
                end
                if regloop==5 || regloop==7;maxdom=28;else;maxdom=30;end
                amazcontinue=0;if regloop==5;if doyhere<=29 || doyhere>=94;amazcontinue=1;end;else;amazcontinue=1;end

                if checkifinside==1
                    if ~(thismon==prevmon && doyhere==prevdoy) && thisdom>=3 && thisdom<=maxdom %a new day, with 2 preceding days in the same month (for simplicity)
                        if (regloop<=3 && (thismon>=firstmonth && thismon<=lastmonth) && thisyear>=startyear) || ...
                                (regloop==5 && (thismon<=lastmonth || thismon>=firstmonth) && thisyear>=startyear)
                            if amazcontinue==1
                            if (thisyear~=prevyear || extremec==0) %...and data files need to be re-read
                                if thismon<=9;mzero='0';else;mzero='';end
                                file=ncgeodataset(strcat('/Volumes/',modellevdataloc,'/tq_',num2str(thisyear),mzero,num2str(thismon),'.grib'));
                                tmltemp=file{'t'};echo off;qmltemp=file{'q'};echo off;clear file;
                                    
                                
                                if inclnonextr==1
                                if thismon<=7;thismon_fornonextr=thismon+1;else;thismon_fornonextr=thismon-1;end
                                file_fornonextr=ncgeodataset(strcat('/Volumes/',modellevdataloc,'/tq_',num2str(thisyear),mzero,num2str(thismon_fornonextr),'.grib'));
                                tmltemp_fornonextr=file_fornonextr{'t'};echo off;qmltemp_fornonextr=file_fornonextr{'q'};echo off;clear file_fornonextr;
                                end
                                   

                                %For MSE using 2-m data
                                file=ncgeodataset(strcat('/Volumes/ExternalDriveZ/ERA5_Hourly_Data/ttd_world_',num2str(thisyear),'.grib'));
                                psfcfile=ncgeodataset(strcat('/Volumes/ExternalDriveC/ERA5_Hourly_Data_PandGHonly/psfc_world_',num2str(thisyear),'.grib'));
                                ttemp=file{'2_metre_temperature_surface'};echo off;
                                    t2m=double(ttemp.data(:,era5rowstart:era5rowstop,era5colstart_forplotting-0.5:era5colstop_forplotting+0.5));clear ttemp;
                                tdtemp=file{'2_metre_dewpoint_temperature_surface'};echo off;
                                    td2m=double(tdtemp.data(:,era5rowstart:era5rowstop,era5colstart_forplotting-0.5:era5colstop_forplotting+0.5))-273.15;clear tdtemp;
                                psfctemp=psfcfile{'Surface_pressure_surface'};echo off;clear psfcfile;
                                    psfc=double(psfctemp.data(:,era5rowstart:era5rowstop,era5colstart-0.5:era5colstop+0.5));clear psfctemp;
                                %

                                

                                newa=0;clear newt2m;
                                for a=2:size(t2m,3);newa=newa+1;newt2m(:,:,newa)=squeeze(mean(t2m(:,:,a-1:a),3));end
                                t2mforyear=newt2m;clear newt2m;
                                newa=0;clear newtd2m;
                                for a=2:size(td2m,3);newa=newa+1;newtd2m(:,:,newa)=squeeze(mean(td2m(:,:,a-1:a),3));end
                                td2mforyear=newtd2m;clear newtd2m;
                                newa=0;clear newpsfc;
                                for a=2:size(psfc,3);newa=newa+1;newpsfc(:,:,newa)=squeeze(mean(psfc(:,:,a-1:a),3));end
                                psfcforyear=newpsfc;clear newpsfc;

                                vp=calcvpfromTd(td2mforyear);
                                mr=622.197.*(vp./(psfcforyear-vp))./1000;
                                omega=calcqfromTd_dynamicP(td2mforyear,psfcforyear); %convert to unitless specific humidity
                                %cp=1005.7.*(1+1.83.*mr);clear mr; %J K^-1 kg^-1; Stull, Practical Meteorology
                                cp=(1005.7.*(1-mr))+(mr.*(1-mr).*1850);clear mr;
                                qh2mforyear=cp.*t2mforyear;clear cp;
                                lv=1918.46.*((t2mforyear./(t2mforyear-33.91)).^2); %J/kg; Henderson-Sellers 1984
                                ql2mforyear=lv.*omega;clear lv;clear omega; %J/kg
                                mse2mforyear=(qh2mforyear+ql2mforyear)./1000;

                                %Get model-level wind data
                                uvwfile=ncgeodataset(strcat('/Volumes/',modellevdataloc,'/uvw_',num2str(thisyear),mzero,num2str(thismon),'.grib'));
                                utemp=uvwfile{'u'};echo off;vtemp=uvwfile{'v'};echo off;wtemp=uvwfile{'w'};echo off;clear uvwfile;
                                
                                if inclnonextr==1
                                uvwfile_fornonextr=ncgeodataset(strcat('/Volumes/',modellevdataloc,'/uvw_',num2str(thisyear),mzero,num2str(thismon_fornonextr),'.grib'));
                                utemp_fornonextr=uvwfile_fornonextr{'u'};echo off;vtemp_fornonextr=uvwfile_fornonextr{'v'};echo off;wtemp_fornonextr=uvwfile_fornonextr{'w'};
                                    echo off;clear uvwfile_fornonextr;
                                end


                                ghfile=ncgeodataset(strcat('/Volumes/ExternalDriveC/ERA5_Hourly_Data_PandGHonly/gh_world_daily_',num2str(thisyear),'.grib'));
                                ghtemp=ghfile{'Geopotential_isobaric'};echo off;
                                
                                prevyear=thisyear;prevmon=thismon;prevdoy=doyhere;fprintf('Just reloaded for i=%d\n',i);
                            end
                            

                            if thismon<=7;doyhere_nonextr=doyhere+thismonlen;elseif thismon==8;doyhere_nonextr=doyhere-thismonlen;end %same dom as doyhere, 1 month different
                            
                            
                            %Get T,q data for this day and 2 days prior
                            t=squeeze(double(tmltemp.data((thisdom-2)*8-7:thisdom*8,:,rowstart_281x1161grid:rowstop_281x1161grid,colstart_281x1161grid:colstop_281x1161grid)));
                                if inclnonextr==1
                                t_nonextr=squeeze(double(tmltemp_fornonextr.data((thisdom-2)*8-7:thisdom*8,:,rowstart_281x1161grid:rowstop_281x1161grid,colstart_281x1161grid:colstop_281x1161grid)));
                                end
                            q=squeeze(double(qmltemp.data((thisdom-2)*8-7:thisdom*8,:,rowstart_281x1161grid:rowstop_281x1161grid,colstart_281x1161grid:colstop_281x1161grid)));
                                if inclnonextr==1
                                q_nonextr=squeeze(double(qmltemp_fornonextr.data((thisdom-2)*8-7:thisdom*8,:,rowstart_281x1161grid:rowstop_281x1161grid,colstart_281x1161grid:colstop_281x1161grid)));
                                end
                                invalid=q<0;q(invalid)=NaN;if inclnonextr==1;invalid=q_nonextr<0;q_nonextr(invalid)=NaN;end

                            
                            %Get u,v,w,gh data for this day and 2 days prior 
                            u=squeeze(double(utemp.data((thisdom-2)*8-7:thisdom*8,:,rowstart_281x1161grid:rowstop_281x1161grid,colstart_281x1161grid:colstop_281x1161grid)));
                                if inclnonextr==1
                                u_nonextr=squeeze(double(utemp_fornonextr.data((thisdom-2)*8-7:thisdom*8,:,rowstart_281x1161grid:rowstop_281x1161grid,colstart_281x1161grid:colstop_281x1161grid)));
                                end
                            v=squeeze(double(vtemp.data((thisdom-2)*8-7:thisdom*8,:,rowstart_281x1161grid:rowstop_281x1161grid,colstart_281x1161grid:colstop_281x1161grid)));
                                if inclnonextr==1
                                v_nonextr=squeeze(double(vtemp.data((thisdom-2)*8-7:thisdom*8,:,rowstart_281x1161grid:rowstop_281x1161grid,colstart_281x1161grid:colstop_281x1161grid)));
                                end
                            w=squeeze(double(wtemp.data((thisdom-2)*8-7:thisdom*8,:,rowstart_281x1161grid:rowstop_281x1161grid,colstart_281x1161grid:colstop_281x1161grid)));
                                if inclnonextr==1
                                w_nonextr=squeeze(double(wtemp.data((thisdom-2)*8-7:thisdom*8,:,rowstart_281x1161grid:rowstop_281x1161grid,colstart_281x1161grid:colstop_281x1161grid)));
                                end
                            
                            gh=squeeze(double(ghtemp.data(thisdom-2:thisdom,:,era5rowstart:era5rowstop,era5colstart_forplotting:era5colstop_forplotting)));
                                if inclnonextr==1
                                gh_nonextr=squeeze(double(ghtemp.data(thisdom-2:thisdom,:,era5rowstart:era5rowstop,era5colstart_forplotting:era5colstop_forplotting)));
                                end
                                
                            %Get Psfc data for this day and 2 days prior
                            psfc=squeeze(psfcforyear((doyhere-2)*8-7:doyhere*8,:,:));
                                if inclnonextr==1
                                psfc_nonextr=squeeze(psfcforyear((doyhere_nonextr-2)*8-7:doyhere_nonextr*8,:,:));
                                end
                                
                            %Get geopotential height of model levels
                            elevs_here=elevera5(era5rowstart:era5rowstop,era5colstart:era5colstop);
                            elev_rep=NaN.*ones(size(psfc,1),size(psfc,2),size(psfc,3));for hh=1:size(psfc,1);elev_rep(hh,:,:)=elevs_here;end
                            clear z_ml;clear z_ml_nonextr;
                            for aa=1:size(u,1)
                                for kk=1:size(u,2)
                                    clear t_here;clear q_here;clear psfc_here;clear ghsfc_here;
                                    k=mls_retrieved(kk);
                                    t_here=squeeze(t(aa,:,:,:));
                                    q_here=squeeze(q(aa,:,:,:));
                                    psfc_here=squeeze(psfc(aa,:,:))./100;
                                    ghsfc_here=squeeze(elev_rep(aa,:,:));
                                    era5ghofmodellevels;
                                    z_ml(aa,kk,:,:)=gp_here./9.81;
                                    
                                    if inclnonextr==1
                                    t_here=squeeze(t_nonextr(aa,:,:,:));
                                    q_here=squeeze(q_nonextr(aa,:,:,:));
                                    psfc_here=squeeze(psfc_nonextr(aa,:,:))./100;
                                    era5ghofmodellevels;
                                    z_ml_nonextr(aa,kk,:,:)=gp_here./9.81;
                                    end
                                    clear t_here;clear q_here;clear psfc_here;clear ghsfc_here;
                                end
                            end
                                
                            %Get MSE2m, Qh2m, Ql2, t2m, td2m data for this day and 2 days prior
                            mse2m=squeeze(mse2mforyear((doyhere-2)*8-7:doyhere*8,:,:));
                                if inclnonextr==1
                                mse2m_nonextr=squeeze(mse2mforyear((doyhere_nonextr-2)*8-7:doyhere_nonextr*8,:,:));
                                end
                            qh2m=squeeze(qh2mforyear((doyhere-2)*8-7:doyhere*8,:,:));
                                if inclnonextr==1
                                qh2m_nonextr=squeeze(qh2mforyear((doyhere_nonextr-2)*8-7:doyhere_nonextr*8,:,:));
                                end
                            ql2m=squeeze(ql2mforyear((doyhere-2)*8-7:doyhere*8,:,:));
                                if inclnonextr==1
                                ql2m_nonextr=squeeze(ql2mforyear((doyhere_nonextr-2)*8-7:doyhere_nonextr*8,:,:));
                                end
                            t2m=squeeze(t2mforyear((doyhere-2)*8-7:doyhere*8,:,:));
                                if inclnonextr==1
                                t2m_nonextr=squeeze(t2mforyear((doyhere_nonextr-2)*8-7:doyhere_nonextr*8,:,:));
                                end
                            td2m=squeeze(td2mforyear((doyhere-2)*8-7:doyhere*8,:,:));
                                if inclnonextr==1
                                td2m_nonextr=squeeze(td2mforyear((doyhere_nonextr-2)*8-7:doyhere_nonextr*8,:,:));
                                end
                                
                                
                            %Compute MSE/Qh/Ql [profile] data for this day and 2 days prior
                            pressures_forml_rep=repmat(pressures_forml,[1,24,size(u,3),size(u,4)]);pressures_forml_rep=permute(pressures_forml_rep,[2 1 3 4]);
                            
                            td=calcTdfromq(q.*1000,pressures_forml_rep);
                            vp=calcvpfromTd(td)./100; %in hPa
                            mr=622.197.*(vp./(pressures_forml_rep-vp))./1000;
                            omega=calcqfromTd_dynamicP(td,pressures_forml_rep.*100); %convert to unitless specific humidity
                            %cp=1005.7.*(1+1.83.*mr);clear mr; %J K^-1 kg^-1; Stull, Practical Meteorology
                            cp=(1005.7.*(1-mr))+(mr.*(1-mr).*1850);clear mr;
                            qh=cp.*t;clear cp;
                            lv=1918.46.*((t./(t-33.91)).^2); %J/kg; Henderson-Sellers 1984
                            ql=lv.*omega;clear lv;clear omega; %J/kg
                            mse=(qh+ql+9.81.*z_ml)./1000;
                            
                            if inclnonextr==1
                            td_nonextr=calcTdfromq(q_nonextr.*1000,pressures_forml_rep);
                            vp=calcvpfromTd(td_nonextr)./100; %in hPa
                            mr=622.197.*(vp./(pressures_forml_rep-vp))./1000;clear vp;
                            omega=calcqfromTd_dynamicP(td_nonextr,pressures_forml_rep.*100); %convert to unitless specific humidity
                            %cp=1005.7.*(1+1.83.*mr);clear mr; %J K^-1 kg^-1; Stull, Practical Meteorology
                            cp=(1005.7.*(1-mr))+(mr.*(1-mr).*1850);clear mr;
                            qh_nonextr=cp.*t_nonextr;clear cp;
                            lv=1918.46.*((t_nonextr./(t_nonextr-33.91)).^2); %J/kg; Henderson-Sellers 1984
                            ql_nonextr=lv.*omega;clear lv;clear omega; %J/kg
                            mse_nonextr=(qh_nonextr+ql_nonextr+9.81.*z_ml_nonextr)./1000;
                            end
                                

                            %Column-wise averaging
                            dothis=0;
                            if dothis==1
                            if regloop~=9
                            newa=0;clear newt;clear newt_nonextr;
                            for a=2:size(t,4)
                                newa=newa+1;
                                newt(:,:,:,newa)=squeeze(mean(t(:,:,:,a-1:a),4));
                                if inclnonextr==1;newt_nonextr(:,:,:,newa)=squeeze(mean(t_nonextr(:,:,:,a-1:a),4));end
                            end
                            t=newt;clear newt;if inclnonextr==1;t_nonextr=newt_nonextr;clear newt_nonextr;end
                            
                            newa=0;clear newtd;clear newtd_nonextr;
                            for a=2:size(td,4)
                                newa=newa+1;
                                newtd(:,:,:,newa)=squeeze(mean(td(:,:,:,a-1:a),4));
                                if inclnonextr==1;newtd_nonextr(:,:,:,newa)=squeeze(mean(td_nonextr(:,:,:,a-1:a),4));end
                            end
                            td=newtd;clear newtd;if inclnonextr==1;td_nonextr=newtd_nonextr;clear newtd_nonextr;end
                            
                            newa=0;clear newq;clear newq_nonextr;
                            for a=2:size(q,4)
                                newa=newa+1;
                                newq(:,:,:,newa)=squeeze(mean(q(:,:,:,a-1:a),4));
                                if inclnonextr==1;newq_nonextr(:,:,:,newa)=squeeze(mean(q_nonextr(:,:,:,a-1:a),4));end
                            end
                            q=newq;clear newq;if inclnonextr==1;q_nonextr=newq_nonextr;clear newq_nonextr;end
                                
                            newa=0;clear newu;clear newu_nonextr;
                            for a=2:size(gh,4)
                                newa=newa+1;
                                newu(:,:,:,newa)=squeeze(mean(u(:,:,:,a-1:a),4));
                                if inclnonextr==1;newu_nonextr(:,:,:,newa)=squeeze(mean(u_nonextr(:,:,:,a-1:a),4));end
                            end
                            u=newu;clear newu;if inclnonextr==1;u_nonextr=newu_nonextr;clear newu_nonextr;end
                            
                            newa=0;clear newv;clear newv_nonextr;
                            for a=2:size(v,4)
                                newa=newa+1;
                                newv(:,:,:,newa)=squeeze(mean(v(:,:,:,a-1:a),4));
                                if inclnonextr==1;newv_nonextr(:,:,:,newa)=squeeze(mean(v_nonextr(:,:,:,a-1:a),4));end
                            end
                            v=newv;clear newv;if inclnonextr==1;v_nonextr=newv_nonextr;clear newv_nonextr;end
                            
                            newa=0;clear neww;clear neww_nonextr;
                            for a=2:size(w,4)
                                newa=newa+1;
                                neww(:,:,:,newa)=squeeze(mean(w(:,:,:,a-1:a),4));
                                if inclnonextr==1;neww_nonextr(:,:,:,newa)=squeeze(mean(w_nonextr(:,:,:,a-1:a),4));end
                            end
                            w=neww;clear neww;if inclnonextr==1;w_nonextr=neww_nonextr;clear neww_nonextr;end
                            
                            newa=0;clear newgh;clear newgh_nonextr;
                            for a=2:size(gh,4)
                                newa=newa+1;
                                newgh(:,:,:,newa)=squeeze(mean(gh(:,:,:,a-1:a),4));
                                if inclnonextr==1;newgh_nonextr(:,:,:,newa)=squeeze(mean(gh_nonextr(:,:,:,a-1:a),4));end
                            end
                            gh=newgh;clear newgh;if inclnonextr==1;gh_nonextr=newgh_nonextr;clear newgh_nonextr;end
                            
                            newa=0;clear newmse;clear newmse_nonextr;
                            for a=2:size(mse,4)
                                newa=newa+1;
                                newmse(:,:,:,newa)=squeeze(mean(mse(:,:,:,a-1:a),4));
                                if inclnonextr==1;newmse_nonextr(:,:,:,newa)=squeeze(mean(mse_nonextr(:,:,:,a-1:a),4));end
                            end
                            mse=newmse;clear newmse;if inclnonextr==1;mse_nonextr=newmse_nonextr;clear newmse_nonextr;end
                            
                            newa=0;clear newqh;clear newqh_nonextr;
                            for a=2:size(qh,4)
                                newa=newa+1;
                                newqh(:,:,:,newa)=squeeze(mean(qh(:,:,:,a-1:a),4));
                                if inclnonextr==1;newqh_nonextr(:,:,:,newa)=squeeze(mean(qh_nonextr(:,:,:,a-1:a),4));end
                            end
                            qh=newqh;clear newqh;if inclnonextr==1;qh_nonextr=newqh_nonextr;clear newqh_nonextr;end
                            
                            newa=0;clear newql;clear newql_nonextr;
                            for a=2:size(ql,4)
                                newa=newa+1;
                                newql(:,:,:,newa)=squeeze(mean(ql(:,:,:,a-1:a),4));
                                if inclnonextr==1;newql_nonextr(:,:,:,newa)=squeeze(mean(ql_nonextr(:,:,:,a-1:a),4));end
                            end
                            ql=newql;clear newql;if inclnonextr==1;ql_nonextr=newql_nonextr;clear newql_nonextr;end
                            
                            end
                            end

                            

                                                        
                            %Interpolate u, v, w, gh, Psfc, and MSE/Qh/Ql (if necessary) to the main model lat/lon grid 
                            mllatgrid=mllats_unrotated(regsubsetrowstart-1:regsubsetrowstop+1,regsubsetcolstart-1:regsubsetcolstop+1);
                            mllongrid=mllons_unrotated(regsubsetrowstart-1:regsubsetrowstop+1,regsubsetcolstart-1:regsubsetcolstop+1);
                            clear u_here;clear v_here;clear w_here;clear gh_here;clear t_here;clear td_here;clear q_here;clear mse_here;clear qh_here;clear ql_here;clear presml_here;clear zml_here;
                            clear u_here_nonextr;clear v_here_nonextr;clear w_here_nonextr;clear gh_here_nonextr;
                                clear t_here_nonextr;clear td_here_nonextr;clear q_here_nonextr;clear mse_here_nonextr;clear qh_here_nonextr;clear ql_here_nonextr;
                                clear presml_here_nonextr;clear zml_here_nonextr;
                            for g=1:size(u,1) %=24, number of 3-hourly timesteps in 3 days
                                for gg=1:size(u,2) %levels
                                    u_here(g,gg,:,:)=interp2(regularlatgrid,regularlongrid,squeeze(u(g,gg,:,:))',mllatgrid,mllongrid);
                                        if inclnonextr==1;u_here_nonextr(g,gg,:,:)=interp2(regularlatgrid,regularlongrid,squeeze(u_nonextr(g,gg,:,:))',mllatgrid,mllongrid);end
                                    v_here(g,gg,:,:)=interp2(regularlatgrid,regularlongrid,squeeze(v(g,gg,:,:))',mllatgrid,mllongrid);
                                        if inclnonextr==1;v_here_nonextr(g,gg,:,:)=interp2(regularlatgrid,regularlongrid,squeeze(v_nonextr(g,gg,:,:))',mllatgrid,mllongrid);end
                                    w_here(g,gg,:,:)=interp2(regularlatgrid,regularlongrid,squeeze(w(g,gg,:,:))',mllatgrid,mllongrid);
                                        if inclnonextr==1;w_here_nonextr(g,gg,:,:)=interp2(regularlatgrid,regularlongrid,squeeze(w_nonextr(g,gg,:,:))',mllatgrid,mllongrid);end
                                    if g==1 && gg<=4 %only need gh data for 1 day, and at 4 levels
                                        gh_here(g,gg,:,:)=interp2(regularlatgrid,regularlongrid,squeeze(gh(g,gg,:,:))',mllatgrid,mllongrid);
                                            if inclnonextr==1;gh_here_nonextr(g,gg,:,:)=interp2(regularlatgrid,regularlongrid,squeeze(gh_nonextr(g,gg,:,:))',mllatgrid,mllongrid);end
                                    end
                                    t_here(g,gg,:,:)=interp2(regularlatgrid,regularlongrid,squeeze(t(g,gg,:,:))',mllatgrid,mllongrid);
                                        if inclnonextr==1;t_here_nonextr(g,gg,:,:)=interp2(regularlatgrid,regularlongrid,squeeze(t_nonextr(g,gg,:,:))',mllatgrid,mllongrid);end
                                    td_here(g,gg,:,:)=interp2(regularlatgrid,regularlongrid,squeeze(td(g,gg,:,:))',mllatgrid,mllongrid);
                                        if inclnonextr==1;td_here_nonextr(g,gg,:,:)=interp2(regularlatgrid,regularlongrid,squeeze(td_nonextr(g,gg,:,:))',mllatgrid,mllongrid);end
                                    q_here(g,gg,:,:)=interp2(regularlatgrid,regularlongrid,squeeze(q(g,gg,:,:))',mllatgrid,mllongrid);
                                        if inclnonextr==1;q_here_nonextr(g,gg,:,:)=interp2(regularlatgrid,regularlongrid,squeeze(q_nonextr(g,gg,:,:))',mllatgrid,mllongrid);end
                                    mse_here(g,gg,:,:)=interp2(regularlatgrid,regularlongrid,squeeze(mse(g,gg,:,:))',mllatgrid,mllongrid);
                                        if inclnonextr==1;mse_here_nonextr(g,gg,:,:)=interp2(regularlatgrid,regularlongrid,squeeze(mse_nonextr(g,gg,:,:))',mllatgrid,mllongrid);end
                                    qh_here(g,gg,:,:)=interp2(regularlatgrid,regularlongrid,squeeze(qh(g,gg,:,:))',mllatgrid,mllongrid);
                                        if inclnonextr==1;qh_here_nonextr(g,gg,:,:)=interp2(regularlatgrid,regularlongrid,squeeze(qh_nonextr(g,gg,:,:))',mllatgrid,mllongrid);end
                                    ql_here(g,gg,:,:)=interp2(regularlatgrid,regularlongrid,squeeze(ql(g,gg,:,:))',mllatgrid,mllongrid);
                                        if inclnonextr==1;ql_here_nonextr(g,gg,:,:)=interp2(regularlatgrid,regularlongrid,squeeze(ql_nonextr(g,gg,:,:))',mllatgrid,mllongrid);end
                                        
                                    presml_here(g,gg,:,:)=interp2(regularlatgrid,regularlongrid,squeeze(pressures_forml_rep(g,gg,:,:))',mllatgrid,mllongrid);
                                        if inclnonextr==1;presml_here_nonextr(g,gg,:,:)=interp2(regularlatgrid,regularlongrid,squeeze(pressures_forml_rep(g,gg,:,:))',mllatgrid,mllongrid);end
                                    zml_here(g,gg,:,:)=interp2(regularlatgrid,regularlongrid,squeeze(z_ml(g,gg,:,:))',mllatgrid,mllongrid);
                                        if inclnonextr==1;zml_here_nonextr(g,gg,:,:)=interp2(regularlatgrid,regularlongrid,squeeze(z_ml_nonextr(g,gg,:,:))',mllatgrid,mllongrid);end
                                end
                            end
                            u=u_here;v=v_here;w=w_here;gh=gh_here;t=t_here;q=q_here;mse=mse_here;qh=qh_here;ql=ql_here;presml=presml_here;z_ml=zml_here;
                            if inclnonextr==1
                            u_nonextr=u_here_nonextr;v_nonextr=v_here_nonextr;w_nonextr=w_here_nonextr;gh_nonextr=gh_here_nonextr;
                                t_nonextr=t_here_nonextr;td_nonextr=td_here_nonextr;q_nonextr=q_here_nonextr;mse_nonextr=mse_here_nonextr;qh_nonextr=qh_here_nonextr;
                                    ql_nonextr=ql_here_nonextr;presml_nonextr=presml_here_nonextr;z_ml_nonextr=zml_here_nonextr;
                            end
                            clear u_here;clear v_here;clear w_here;clear gh_here;clear t_here;clear q_here;clear mse_here;clear qh_here;clear ql_here;clear presml_here;clear zml_here;
                            clear u_here_nonextr;clear v_here_nonextr;clear w_here_nonextr;clear gh_here_nonextr;
                                clear t_here_nonextr;clear q_here_nonextr;clear mse_here_nonextr;clear qh_here_nonextr;clear ql_here_nonextr;clear presml_here_nonextr;clear zml_here_nonextr;
                            
                            clear mse2m_here;clear qh2m_here;clear ql2m_here;clear psfc_here;clear t2m_here;clear td2m_here;clear elev_here;
                            clear mse2m_here_nonextr;clear qh2m_here_nonextr;clear ql2m_here_nonextr;clear psfc_here_nonextr;clear t2m_here_nonextr;clear td2m_here_nonextr;
                            for g=1:24
                                if regloop<9
                                    mse2m_here(g,:,:)=interp2(regularlatgrid,regularlongrid,squeeze(mse2m(g,:,:))',mllatgrid,mllongrid);
                                        if inclnonextr==1;mse2m_here_nonextr(g,:,:)=interp2(regularlatgrid,regularlongrid,squeeze(mse2m_nonextr(g,:,:))',mllatgrid,mllongrid);end
                                    qh2m_here(g,:,:)=interp2(regularlatgrid,regularlongrid,squeeze(qh2m(g,:,:))',mllatgrid,mllongrid);
                                        if inclnonextr==1;qh2m_here_nonextr(g,:,:)=interp2(regularlatgrid,regularlongrid,squeeze(qh2m_nonextr(g,:,:))',mllatgrid,mllongrid);end
                                    ql2m_here(g,:,:)=interp2(regularlatgrid,regularlongrid,squeeze(ql2m(g,:,:))',mllatgrid,mllongrid);
                                        if inclnonextr==1;ql2m_here_nonextr(g,:,:)=interp2(regularlatgrid,regularlongrid,squeeze(ql2m_nonextr(g,:,:))',mllatgrid,mllongrid);end
                                    psfc_here(g,:,:)=interp2(regularlatgrid,regularlongrid,squeeze(psfc(g,:,:))',mllatgrid,mllongrid);
                                        if inclnonextr==1;psfc_here_nonextr(g,:,:)=interp2(regularlatgrid,regularlongrid,squeeze(psfc_nonextr(g,:,:))',mllatgrid,mllongrid);end
                                    t2m_here(g,:,:)=interp2(regularlatgrid,regularlongrid,squeeze(t2m(g,:,:))',mllatgrid,mllongrid);
                                        if inclnonextr==1;t2m_here_nonextr(g,:,:)=interp2(regularlatgrid,regularlongrid,squeeze(t2m_nonextr(g,:,:))',mllatgrid,mllongrid);end
                                    td2m_here(g,:,:)=interp2(regularlatgrid,regularlongrid,squeeze(td2m(g,:,:))',mllatgrid,mllongrid);
                                        if inclnonextr==1;td2m_here_nonextr(g,:,:)=interp2(regularlatgrid,regularlongrid,squeeze(td2m_nonextr(g,:,:))',mllatgrid,mllongrid);end
                                else
                                    mse2m_here(g,:,:)=interp2(regularlatgrid_minus1row,regularlongrid_minus1row,squeeze(mse2m(g,:,:))',mllatgrid,mllongrid);
                                    qh2m_here(g,:,:)=interp2(regularlatgrid_minus1row,regularlongrid_minus1row,squeeze(qh2m(g,:,:))',mllatgrid,mllongrid);
                                    ql2m_here(g,:,:)=interp2(regularlatgrid_minus1row,regularlongrid_minus1row,squeeze(ql2m(g,:,:))',mllatgrid,mllongrid);
                                    psfc_here(g,:,:)=interp2(regularlatgrid_minus1row,regularlongrid_minus1row,squeeze(psfc(g,:,:))',mllatgrid,mllongrid);
                                    t2m_here(g,:,:)=interp2(regularlatgrid_minus1row,regularlongrid_minus1row,squeeze(t2m(g,:,:))',mllatgrid,mllongrid);
                                    td2m_here(g,:,:)=interp2(regularlatgrid_minus1row,regularlongrid_minus1row,squeeze(td2m(g,:,:))',mllatgrid,mllongrid);
                                end
                                if g==1
                                    elev_here=interp2(regularlatgrid,regularlongrid,elevera5(era5rowstart:era5rowstop,era5colstart:era5colstop)',mllatgrid,mllongrid);
                                end
                            end
                            mse2m=mse2m_here;qh2m=qh2m_here;ql2m=ql2m_here;psfc=psfc_here;t2m=t2m_here;td2m=td2m_here;elev=elev_here;
                                if inclnonextr==1
                                mse2m_nonextr=mse2m_here_nonextr;qh2m_nonextr=qh2m_here_nonextr;ql2m_nonextr=ql2m_here_nonextr;psfc_nonextr=psfc_here_nonextr;
                                t2m_nonextr=t2m_here_nonextr;td2m_nonextr=td2m_here_nonextr;
                                end
                                
                            elevs=interp2(regularlatgrid,regularlongrid,elevs_here',mllatgrid,mllongrid);


                            %hour of max at hottest gridpt on this day
                            for a=17:24;for b=1:size(mse2m,2);for c=1:size(mse2m,3)
                                        if abs(mse2m(a,b,c)-max(max(max(max(mse2m(17:24,:,:))))))<0.01;thea=a;end
                                        if inclnonextr==1;if abs(mse2m_nonextr(a,b,c)-max(max(max(max(mse2m_nonextr(17:24,:,:))))))<0.01;thea_nonextr=a;end;end
                            end;end;end
                            hourofmax=thea;
                            if inclnonextr==1;hourofmax_nonextr=thea_nonextr;end
                            %alternative: hour of max averaged across region on this day
                            %thisdaydata=mse2m(17:24,:,:);
                            %hourofmaxarray=NaN.*ones(size(mse2m,2),size(mse2m,3));
                            %for a=1:size(mse2m,2)
                            %    for b=1:size(mse2m,3)
                            %        if sum(isnan(thisdaydata(:,a,b)))==0
                            %            [~,hourofmaxarray(a,b)]=max(thisdaydata(:,a,b));
                            %        end
                            %    end
                            %end
                            %hourofmax=round(mean(mean(hourofmaxarray,'omitnan'),'omitnan')+16);


                            extremec=extremec+1;
                            %Save arrays of u, v, w, gh, MSE, Qh, and Ql for this region and day
                            if ~isreal(qh);disp('Found complex number, need to investigate');return;end
                            bigu(extremec,:,:,:,:)=u;if inclnonextr==1;bigu_nonextr(extremec,:,:,:,:)=u_nonextr;end
                            bigv(extremec,:,:,:,:)=v;if inclnonextr==1;bigv_nonextr(extremec,:,:,:,:)=v_nonextr;end
                            bigw(extremec,:,:,:,:)=w;if inclnonextr==1;bigw_nonextr(extremec,:,:,:,:)=w_nonextr;end
                            biggh(extremec,:,:,:,:)=gh;if inclnonextr==1;biggh_nonextr(extremec,:,:,:,:)=gh_nonextr;end
                            bigmse(extremec,:,:,:,:)=mse;if inclnonextr==1;bigmse_nonextr(extremec,:,:,:,:)=mse_nonextr;end
                            bigqh(extremec,:,:,:,:)=qh;if inclnonextr==1;bigqh_nonextr(extremec,:,:,:,:)=qh_nonextr;end
                            bigql(extremec,:,:,:,:)=ql;if inclnonextr==1;bigql_nonextr(extremec,:,:,:,:)=ql_nonextr;end
                            bigt(extremec,:,:,:,:)=t;if inclnonextr==1;bigt_nonextr(extremec,:,:,:,:)=t_nonextr;end
                            bigtd(extremec,:,:,:,:)=td;if inclnonextr==1;bigtd_nonextr(extremec,:,:,:,:)=td_nonextr;end
                            
                            bigmse2m(extremec,:,:,:)=mse2m;if inclnonextr==1;bigmse2m_nonextr(extremec,:,:,:)=mse2m_nonextr;end
                            bigqh2m(extremec,:,:,:)=qh2m;if inclnonextr==1;bigqh2m_nonextr(extremec,:,:,:)=qh2m_nonextr;end
                            bigql2m(extremec,:,:,:)=ql2m;if inclnonextr==1;bigql2m_nonextr(extremec,:,:,:)=ql2m_nonextr;end
                            bigt2m(extremec,:,:,:)=t2m;if inclnonextr==1;bigt2m_nonextr(extremec,:,:,:)=t2m_nonextr;end
                            bigtd2m(extremec,:,:,:)=td2m;if inclnonextr==1;bigtd2m_nonextr(extremec,:,:,:)=td2m_nonextr;end
                            
                            yeararray(extremec,:,:,:)=thisyear;if inclnonextr==1;yeararray_nonextr(extremec,:,:,:)=thisyear;end
                            homarray(extremec,:,:,:)=hourofmax;if inclnonextr==1;homarray_nonextr(extremec,:,:,:,:)=hourofmax_nonextr;end
                            doyarray(extremec,:,:,:)=doyhere;if inclnonextr==1;doyarray_nonextr(extremec,:,:,:)=doyhere_nonextr;end
                            presmlarray(extremec,:,:,:,:)=presml;if inclnonextr==1;presmlarray_nonextr(extremec,:,:,:,:)=presml_nonextr;end
                            zmlarray(extremec,:,:,:,:)=z_ml;if inclnonextr==1;zmlarray_nonextr(extremec,:,:,:,:)=z_ml_nonextr;end
                            if extremec==1;elevsarray=elevs;end
                            
                            
                            clear u;clear v;clear w;clear gh;clear mse;clear qh;clear ql;clear t;clear td;clear mse2m;clear qh2m;clear ql2m;clear t2m;clear td2m;
                            end
                        end
                    end
                end
                fprintf('i is %d of %d\n',i,size(regsubsetchron,1));
            end
            clear t2mforyear;clear td2mforyear;clear qh2mforyear;clear ql2mforyear;clear mse2mforyear;
            clear utemp;clear vtemp;clear wtemp;clear utemp_fornonextr;clear vtemp_fornonextr;clear wtemp_fornonextr;

            utosave{regloop}=bigu;vtosave{regloop}=bigv;wtosave{regloop}=bigw;ghtosave{regloop}=biggh;
            msetosave{regloop}=bigmse;qhtosave{regloop}=bigqh;qltosave{regloop}=bigql;ttosave{regloop}=bigt;tdtosave{regloop}=bigtd;
            mse2mtosave{regloop}=bigmse2m;qh2mtosave{regloop}=bigqh2m;ql2mtosave{regloop}=bigql2m;t2mtosave{regloop}=bigt2m;td2mtosave{regloop}=bigtd2m;
            homarraytosave{regloop}=homarray;yeartosave{regloop}=yeararray;doyheretosave{regloop}=doyarray;
            mllatgridtosave{regloop}=mllatgrid;mllongridtosave{regloop}=mllongrid;presmltosave{regloop}=presmlarray;zmltosave{regloop}=zmlarray;
            clear bigu;clear bigv;clear bigw;clear biggh;clear bigmse;clear bigqh;clear bigql;clear bigt;clear bigtd;clear bigmsem2m;clear bigqh2m;clear bigql2m;clear bigt2m;clear bigtd2m;
            
            if inclnonextr==1
            utosave_nonextr{regloop}=bigu_nonextr;vtosave_nonextr{regloop}=bigv_nonextr;wtosave_nonextr{regloop}=bigw_nonextr;ghtosave_nonextr{regloop}=biggh_nonextr;
            msetosave_nonextr{regloop}=bigmse_nonextr;qhtosave_nonextr{regloop}=bigqh_nonextr;qltosave_nonextr{regloop}=bigql_nonextr;
            ttosave_nonextr{regloop}=bigt_nonextr;tdtosave_nonextr{regloop}=bigtd_nonextr;
            mse2mtosave_nonextr{regloop}=bigmse2m_nonextr;qh2mtosave_nonextr{regloop}=bigqh2m_nonextr;ql2mtosave_nonextr{regloop}=bigql2m_nonextr;
            t2mtosave_nonextr{regloop}=bigt2m_nonextr;td2mtosave_nonextr{regloop}=bigtd2m_nonextr;
            homarraytosave_nonextr{regloop}=homarray_nonextr;
            yeartosave_nonextr{regloop}=yeararray_nonextr;doyheretosave_nonextr{regloop}=doyarray_nonextr;
            presmltosave_nonextr{regloop}=presmlarray_nonextr;zmltosave_nonextr{regloop}=zmlarray_nonextr;
            end
            clear gh_nonextr;clear bigu_nonextr;clear bigv_nonextr;clear bigw_nonextr;clear biggh_nonextr;clear bigmse_nonextr;clear bigqh_nonextr;clear bigql_nonextr;
            clear bigt_nonextr;clear bigtd_nonextr;clear bigmsem2m_nonextr;clear bigqh2m_nonextr;clear bigql2m_nonextr;clear bigt2m_nonextr;clear bigtd2m_nonextr;
                             
            disp('Beginning to save at line 1012');
            %Saving everything for extremes takes multiple hours -->
                %instead, save to local disk and then manually transfer to external drive as necessary
            %save(strcat('/Volumes/ExternalDriveZ/ERA5_HHLcalcs/ghtosave_',regname,'.mat'),'ghtosave');
            t=ghtosave{regloop};save(strcat('ghtosave_',regname,'.mat'),'t');
            t=msetosave{regloop};save(strcat('msetosave_',regname,'.mat'),'t');
            t=qhtosave{regloop};save(strcat('qhtosave_',regname,'.mat'),'t');
            t=qltosave{regloop};save(strcat('qltosave_',regname,'.mat'),'t');
            t=ttosave{regloop};save(strcat('ttosave_',regname,'.mat'),'t');
            t=tdtosave{regloop};save(strcat('tdtosave_',regname,'.mat'),'t');
            t=zmltosave{regloop};save(strcat('zmltosave_',regname,'.mat'),'t');
            t=utosave{regloop};save(strcat('utosave_',regname,'.mat'),'t');
            t=vtosave{regloop};save(strcat('vtosave_',regname,'.mat'),'t');
            t=wtosave{regloop};save(strcat('wtosave_',regname,'.mat'),'t');
            t=presmltosave{regloop};save(strcat('presmltosave_',regname,'.mat'),'t');
            t=mse2mtosave{regloop};save(strcat('mse2mtosave_',regname,'.mat'),'t');
            t=qh2mtosave{regloop};save(strcat('qh2mtosave_',regname,'.mat'),'t');
            t=ql2mtosave{regloop};save(strcat('ql2mtosave_',regname,'.mat'),'t');
            t=t2mtosave{regloop};save(strcat('t2mtosave_',regname,'.mat'),'t');
            t=td2mtosave{regloop};save(strcat('td2mtosave_',regname,'.mat'),'t');
            t=homarraytosave{regloop};save(strcat('homarraytosave_',regname,'.mat'),'t');
            t=yeartosave{regloop};save(strcat('yeartosave_',regname,'.mat'),'t');
            t=doyheretosave{regloop};save(strcat('doyheretosave_',regname,'.mat'),'t');
            t=mllatgridtosave{regloop};save(strcat('mllatgridtosave_',regname,'.mat'),'t');
            t=mllongridtosave{regloop};save(strcat('mllongridtosave_',regname,'.mat'),'t');
            t=elevsarray;save(strcat('elevsarraytosave_',regname,'.mat'),'t');
            
            
            %This saving is rather slow, about 2 hours total
            %NEW APPROACH: ONLY ~1 hour
            if inclnonextr==1
                t=ghtosave_nonextr{regloop};save(strcat('ghtosave_nonextr_',regname,'.mat'),'t');
                t=msetosave_nonextr{regloop};save(strcat('msetosave_nonextr_',regname,'.mat'),'t');
                t=qhtosave_nonextr{regloop};save(strcat('qhtosave_nonextr_',regname,'.mat'),'t');
                t=qltosave_nonextr{regloop};save(strcat('qltosave_nonextr_',regname,'.mat'),'t');
                t=ttosave_nonextr{regloop};save(strcat('ttosave_nonextr_',regname,'.mat'),'t');
                t=tdtosave_nonextr{regloop};save(strcat('tdtosave_nonextr_',regname,'.mat'),'t');
                t=zmltosave_nonextr{regloop};save(strcat('zmltosave_nonextr_',regname,'.mat'),'t');
                t=utosave_nonextr{regloop};save(strcat('utosave_nonextr_',regname,'.mat'),'t');
                t=vtosave_nonextr{regloop};save(strcat('vtosave_nonextr_',regname,'.mat'),'t');
                t=wtosave_nonextr{regloop};save(strcat('wtosave_nonextr_',regname,'.mat'),'t');
                t=presmltosave_nonextr{regloop};save(strcat('presmltosave_nonextr_',regname,'.mat'),'t');
                t=mse2mtosave_nonextr{regloop};save(strcat('mse2mtosave_nonextr_',regname,'.mat'),'t');
                t=qh2mtosave_nonextr{regloop};save(strcat('qh2mtosave_nonextr_',regname,'.mat'),'t');
                t=ql2mtosave_nonextr{regloop};save(strcat('ql2mtosave_nonextr_',regname,'.mat'),'t');
                t=t2mtosave_nonextr{regloop};save(strcat('t2mtosave_nonextr_',regname,'.mat'),'t');
                t=td2mtosave_nonextr{regloop};save(strcat('td2mtosave_nonextr_',regname,'.mat'),'t');
                t=homarraytosave_nonextr{regloop};save(strcat('homarraytosave_nonextr_',regname,'.mat'),'t');
                t=yeartosave_nonextr{regloop};save(strcat('yeartosave_nonextr_',regname,'.mat'),'t');
                t=doyheretosave_nonextr{regloop};save(strcat('doyheretosave_nonextr_',regname,'.mat'),'t');
            end 
        
            fprintf('Completed region %d\n',regloop);disp(clock);
            
            clear tprofiletemp;clear qprofiletemp;
            clear ghtemp;clear qmltemp;clear qmltemp_fornonextr;clear tmltemp;clear tmltemp_fornonextr;
            clear uvfile;clear wfile;clear ghfile;clear file;clear psfcfile;
            
            clear homarray;clear yeararray;clear doyarray;clear presmlarray;clear zmlarray;
            clear homarray_nonextr;clear yeararray_nonextr;clear doyarray_nonextr;clear presmlarray_nonextr;clear zmlarray_nonextr;
        end
    end
end


%Produce figure for this region
%Note that each cross-section is 500-1000 km long
if producefigs==1
    exist uclimoreg1;
    if ans==0      
        temp=load('/Volumes/ExternalDriveZ/ERA5_HHLcalcs/climoforcompositesMAY2021.mat');
        uclimoreg1=temp.uclimoreg1;uclimoreg2=temp.uclimoreg2;uclimoreg3=temp.uclimoreg3;uclimoreg5=temp.uclimoreg5;
        vclimoreg1=temp.vclimoreg1;vclimoreg2=temp.vclimoreg2;vclimoreg3=temp.vclimoreg3;vclimoreg5=temp.vclimoreg5;
        wclimoreg1=temp.wclimoreg1;wclimoreg2=temp.wclimoreg2;wclimoreg3=temp.wclimoreg3;wclimoreg5=temp.wclimoreg5;
        mseclimoreg1=temp.mseclimoreg1;mseclimoreg2=temp.mseclimoreg2;mseclimoreg3=temp.mseclimoreg3;mseclimoreg5=temp.mseclimoreg5;
        mse2mclimoreg1=temp.mse2mclimoreg1;mse2mclimoreg2=temp.mse2mclimoreg2;mse2mclimoreg3=temp.mse2mclimoreg3;mse2mclimoreg5=temp.mse2mclimoreg5;
    end
    
    
    for regloop=regionnumtoplot:regionnumtoplot
        
        regname=regnamesforfigs{regloop};
        
        if needtoreloadformakingmap==1
            temp=load(strcat('/Volumes/ExternalDriveZ/ERA5_HHLcalcs/ghtosave_',regname,'.mat'));ghtosave=temp.t;
            temp=load(strcat('/Volumes/ExternalDriveZ/ERA5_HHLcalcs/msetosave_',regname,'.mat'));msetosave=temp.t;
            temp=load(strcat('/Volumes/ExternalDriveZ/ERA5_HHLcalcs/qhtosave_',regname,'.mat'));qhtosave=temp.t;
            temp=load(strcat('/Volumes/ExternalDriveZ/ERA5_HHLcalcs/qltosave_',regname,'.mat'));qltosave=temp.t;
            temp=load(strcat('/Volumes/ExternalDriveZ/ERA5_HHLcalcs/ttosave_',regname,'.mat'));ttosave=temp.t;
            temp=load(strcat('/Volumes/ExternalDriveZ/ERA5_HHLcalcs/tdtosave_',regname,'.mat'));tdtosave=temp.t;
            temp=load(strcat('/Volumes/ExternalDriveZ/ERA5_HHLcalcs/mse2mtosave_',regname,'.mat'));mse2mtosave=temp.t;
            temp=load(strcat('/Volumes/ExternalDriveZ/ERA5_HHLcalcs/qh2mtosave_',regname,'.mat'));qh2mtosave=temp.t;
            temp=load(strcat('/Volumes/ExternalDriveZ/ERA5_HHLcalcs/ql2mtosave_',regname,'.mat'));ql2mtosave=temp.t;
            temp=load(strcat('/Volumes/ExternalDriveZ/ERA5_HHLcalcs/t2mtosave_',regname,'.mat'));t2mtosave=temp.t;
            temp=load(strcat('/Volumes/ExternalDriveZ/ERA5_HHLcalcs/td2mtosave_',regname,'.mat'));td2mtosave=temp.t;
            temp=load(strcat('/Volumes/ExternalDriveZ/ERA5_HHLcalcs/homarraytosave_',regname,'.mat'));homarraytosave=temp.t;
            temp=load(strcat('/Volumes/ExternalDriveZ/ERA5_HHLcalcs/yeartosave_',regname,'.mat'));yeartosave=temp.t;
            temp=load(strcat('/Volumes/ExternalDriveZ/ERA5_HHLcalcs/doyheretosave_',regname,'.mat'));doyheretosave=temp.t;
            temp=load(strcat('/Volumes/ExternalDriveZ/ERA5_HHLcalcs/mllatgridtosave_',regname,'.mat'));mllatgridtosave=temp.t;
            temp=load(strcat('/Volumes/ExternalDriveZ/ERA5_HHLcalcs/mllongridtosave_',regname,'.mat'));mllongridtosave=temp.t;
            temp=load(strcat('/Volumes/ExternalDriveZ/ERA5_HHLcalcs/presmltosave_',regname,'.mat'));presmltosave=temp.t;
            temp=load(strcat('/Volumes/ExternalDriveZ/ERA5_HHLcalcs/zmltosave_',regname,'.mat'));zmltosave=temp.t;
            temp=load(strcat('/Volumes/ExternalDriveZ/ERA5_HHLcalcs/elevsarraytosave_',regname,'.mat'));elevsarray=temp.t;
            temp=load(strcat('/Volumes/ExternalDriveZ/ERA5_HHLcalcs/utosave_',regname,'.mat'));utosave=temp.t;
            temp=load(strcat('/Volumes/ExternalDriveZ/ERA5_HHLcalcs/vtosave_',regname,'.mat'));vtosave=temp.t;
            temp=load(strcat('/Volumes/ExternalDriveZ/ERA5_HHLcalcs/wtosave_',regname,'.mat'));wtosave=temp.t;

            temp=load(strcat('/Volumes/ExternalDriveZ/ERA5_HHLcalcs/ghtosave_nonextr_',regname,'.mat'));ghtosave_nonextr=temp.t;
            temp=load(strcat('/Volumes/ExternalDriveZ/ERA5_HHLcalcs/msetosave_nonextr_',regname,'.mat'));msetosave_nonextr=temp.t;
            temp=load(strcat('/Volumes/ExternalDriveZ/ERA5_HHLcalcs/qhtosave_nonextr_',regname,'.mat'));qhtosave_nonextr=temp.t;
            temp=load(strcat('/Volumes/ExternalDriveZ/ERA5_HHLcalcs/qltosave_nonextr_',regname,'.mat'));qltosave_nonextr=temp.t;
            temp=load(strcat('/Volumes/ExternalDriveZ/ERA5_HHLcalcs/ttosave_nonextr_',regname,'.mat'));ttosave_nonextr=temp.t;
            temp=load(strcat('/Volumes/ExternalDriveZ/ERA5_HHLcalcs/tdtosave_nonextr_',regname,'.mat'));tdtosave_nonextr=temp.t;
            temp=load(strcat('/Volumes/ExternalDriveZ/ERA5_HHLcalcs/mse2mtosave_nonextr_',regname,'.mat'));mse2mtosave_nonextr=temp.t;
            temp=load(strcat('/Volumes/ExternalDriveZ/ERA5_HHLcalcs/qh2mtosave_nonextr_',regname,'.mat'));qh2mtosave_nonextr=temp.t;
            temp=load(strcat('/Volumes/ExternalDriveZ/ERA5_HHLcalcs/ql2mtosave_nonextr_',regname,'.mat'));ql2mtosave_nonextr=temp.t;
            temp=load(strcat('/Volumes/ExternalDriveZ/ERA5_HHLcalcs/t2mtosave_nonextr_',regname,'.mat'));t2mtosave_nonextr=temp.t;
            temp=load(strcat('/Volumes/ExternalDriveZ/ERA5_HHLcalcs/td2mtosave_nonextr_',regname,'.mat'));td2mtosave_nonextr=temp.t;
            temp=load(strcat('/Volumes/ExternalDriveZ/ERA5_HHLcalcs/homarraytosave_nonextr_',regname,'.mat'));homarraytosave_nonextr=temp.t;
            temp=load(strcat('/Volumes/ExternalDriveZ/ERA5_HHLcalcs/yeartosave_nonextr_',regname,'.mat'));yeartosave_nonextr=temp.t;
            temp=load(strcat('/Volumes/ExternalDriveZ/ERA5_HHLcalcs/doyheretosave_nonextr_',regname,'.mat'));doyheretosave_nonextr=temp.t;
            temp=load(strcat('/Volumes/ExternalDriveZ/ERA5_HHLcalcs/presmltosave_nonextr_',regname,'.mat'));presmltosave_nonextr=temp.t;
            temp=load(strcat('/Volumes/ExternalDriveZ/ERA5_HHLcalcs/zmltosave_nonextr_',regname,'.mat'));zmltosave_nonextr=temp.t;
            temp=load(strcat('/Volumes/ExternalDriveZ/ERA5_HHLcalcs/utosave_nonextr_',regname,'.mat'));utosave_nonextr=temp.t;
            temp=load(strcat('/Volumes/ExternalDriveZ/ERA5_HHLcalcs/vtosave_nonextr_',regname,'.mat'));vtosave_nonextr=temp.t;
            temp=load(strcat('/Volumes/ExternalDriveZ/ERA5_HHLcalcs/wtosave_nonextr_',regname,'.mat'));wtosave_nonextr=temp.t;
        end
        
        
        
        %Rows/cols based on full ERA5 721x1440 grid
        era5rowstart=actualrowstarts(regloop);era5rowstop=actualrowstops(regloop);
        era5colstart=actualcolstarts(regloop);era5colstop=actualcolstops(regloop);

        %Rows/cols based on regional subsets of model-level grid (unrotated)
        regsubsetrowstart=mlstartrows(regloop);regsubsetrowstop=mlstoprows(regloop); %model-level-data grid
        regsubsetcolstart=mlstartcols(regloop);regsubsetcolstop=mlstopcols(regloop);
        regsubsetminlat=regsouthbounds(regloop);regsubsetmaxlat=regnorthbounds(regloop);regsubsetminlon=regwestbounds(regloop);regsubsetmaxlon=regeastbounds(regloop);

        %Rows/cols based on subsets of ERA5 grid
        rowstart_281x1161grid=era5rowstart-200;rowstop_281x1161grid=era5rowstop-200;
        colstart_281x1161grid=era5colstart-200;colstop_281x1161grid=era5colstop-200;
            

        %Interpolate terrain to the desired lat/lon grid
        deslatgrid_main=mllats_unrotated(regsubsetrowstart-1:regsubsetrowstop+1,regsubsetcolstart-1:regsubsetcolstop+1);
        deslongrid_main=mllons_unrotated(regsubsetrowstart-1:regsubsetrowstop+1,regsubsetcolstart-1:regsubsetcolstop+1);
        oldmainlatgrid=era5latarray(era5rowstart:era5rowstop,era5colstart-0.5:era5colstop+0.5)';
        oldmainlongrid=era5lonarray(era5rowstart:era5rowstop,era5colstart-0.5:era5colstop+0.5)';

        elev_oldgrid=elevera5(era5rowstart:era5rowstop,era5colstart-0.5:era5colstop+0.5)';
        elev_maingrid=interp2(oldmainlatgrid,oldmainlongrid,elev_oldgrid,deslatgrid_main,deslongrid_main);

        if regloop==1
            if strcmp(actualoranom,'actual');cmin=315;cint=5;cmax=380;cstep=5;else;cmin=-4;cint=1;cmax=21;cstep=1;end
            continent='all';regiontoplot='persian-gulf-greater';windscale=4;labelevery=3;
            placelats=[24.45;25.29;29.59;24.71;30.53;23.59];placelons=[54.38;51.53;52.58;46.68;47.77;58.38];
            placenames={'Abu Dhabi';'Doha';'Shiraz';'Riyadh';'Basrah';'Muscat'};placenamelens=[3.6;2;2.3;2.5;2.5;2.5];boxaroundheight=0.6;
            placenamepos={'r';'a';'r';'r';'r';'r'}; %by trial and error
            if strcmp(typeofxsection,'normalxsection')
                x1lat=26.28;x1lon=52.79;x2lat=22.71;x2lon=55.21; %Central PG to Oman-UAE-SA tripoint (NW to SE)
            elseif strcmp(typeofxsection,'bigxsection')    
                x1lat=33;x1lon=45;x2lat=19;x2lon=61;
            end
            cblabelfontsize=9;
            terraininterval=500;terrainmax=1500;
            mapleft=0.05;mapbottom=0.1;mapwidth=0.41;mapheight=0.73;
        elseif regloop==2
            if strcmp(actualoranom,'actual');cmin=315;cint=5;cmax=380;cstep=5;else;cmin=-4;cint=1;cmax=21;cstep=1;end
            continent='Asia';regiontoplot='pakistan-greater';windscale=4;labelevery=2;
            placelats=[27.56;30.16;33.68;24.86;31.52;34.56;23.02;26.91];placelons=[68.21;71.53;73.05;67;74.36;69.21;72.57;75.79];
            placenames={'Larkana';'Multan';'Islamabad';'Karachi';'Lahore';'Kabul';'Ahmedabad';'Jaipur'};placenamelens=[2.5;2.2;3.1;2.4;2.2;1.9;3.3;2.1];boxaroundheight=0.5;
            placenamepos={'r';'r';'r';'r';'a';'r';'a';'a'};
            if strcmp(typeofxsection,'normalxsection')
                x1lat=32;x1lon=69;x2lat=30.77;x2lon=74.72; %normal
            elseif strcmp(typeofxsection,'bigxsection')
                %x1lat=22;x1lon=65.68;x2lat=34.5;x2lon=73.68; %big (older)
                x1lat=22;x1lon=63.5;x2lat=34.4;x2lon=74; %big (normal)
            elseif strcmp(typeofxsection,'bigxsection-se')
                x1lat=22;x1lon=63.5;x2lat=31.5;x2lon=77; %big (alternative)
            end
            cblabelfontsize=9;
            terraininterval=1000;terrainmax=4000;
            mapleft=0.02;mapbottom=0.05;mapwidth=0.5;mapheight=0.85;
        elseif regloop==3
            if strcmp(actualoranom,'actual');cmin=320;cint=3;cmax=375;cstep=5;else;cmin=-15;cint=1;cmax=10;cstep=1;end
            continent='Asia';regiontoplot='eindia';windscale=2;labelevery=3;
            placelats=[22.57;17.69;21.96;25.32;16.84];placelons=[88.36;83.22;96.09;82.97;96.17];
            placenames={'Kolkata';'Visakhapatnam';'Mandalay';'Varanasi';'Yangon'};placenamelens=[2.8;5.3;3.4;3.2;2.7];boxaroundheight=0.7;
            placenamepos={'r';'r';'a';'r';'a'};
            if strcmp(typeofxsection,'normalxsection')
                x1lat=21.15;x1lon=79.09;x2lat=26.15;x2lon=91.74; %normal
            elseif strcmp(typeofxsection,'bigxsection')
                x1lat=15;x1lon=86.5;x2lat=26.5;x2lon=89;
            end
            cblabelfontsize=9;
            terraininterval=500;terrainmax=4000;
            mapleft=0.05;mapbottom=0.1;mapwidth=0.42;mapheight=0.8;
        elseif regloop==5
            if strcmp(actualoranom,'actual');cmin=320;cint=3;cmax=375;cstep=5;else;cmin=-10;cint=1;cmax=10;cstep=1;end
            continent='South America';regiontoplot='wamazon';windscale=2;labelevery=3;
            placelats=[-16.49;-3.74;-8.76];placelons=[-68.12;-73.25;-63.9];
            placenames={'La Paz';'Iquitos';'Porto Velho'};placenamelens=[2;2.2;3.1];boxaroundheight=0.7;
            placenamepos={'r';'r';'a'};
            x1lat=-14.5;x1lon=-68.5;x2lat=-10;x2lon=-65; %SW to NE
            cblabelfontsize=9;
            terraininterval=500;terrainmax=6000;
            mapleft=0.04;mapbottom=0.08;mapwidth=0.42;mapheight=0.84;
        elseif regloop==6
            cmin=325;cint=5;cmax=385;cstep=5;continent='all';regiontoplot='red-sea';windscale=2;labelevery=2;
            placelats=[21.49;19.59;15.32];placelons=[39.19;37.19;38.93];
            placenames={'Jeddah';'Port Sudan';'Asmara'};placenamelens=[2;2.5;2];boxaroundheight=0.5;
            placenamepos={'a';'a';'a'};
            x1lat=19;x1lon=37;x2lat=21.4;x2lon=40.4; %SW to NE
            cblabelfontsize=9;
            terraininterval=500;terrainmax=3000;
            mapleft=0.04;mapbottom=0.08;mapwidth=0.42;mapheight=0.84;
        elseif regloop==8
            cmin=310;cint=5;cmax=380;cstep=5;continent='North America';regiontoplot='midwestus';windscale=2;labelevery=3;
            placelats=[41.88;39.1;32.78;33.75;44.98];placelons=[-87.63;-94.58;-96.8;-84.39;-93.27];
            placenames={'Chicago';'Kansas City';'Dallas';'Atlanta';'Minneapolis'};placenamelens=[3.2;4.5;3;3;4.5];boxaroundheight=0.6;
            placenamepos={'r';'r';'r';'a';'r'};
            x1lat=36;x1lon=-101.5;x2lat=36;x2lon=-84.5; %W to E
            cblabelfontsize=8;
            terraininterval=250;terrainmax=3000;
            mapleft=0.04;mapbottom=0.08;mapwidth=0.42;mapheight=0.84;
        elseif regloop==9
            cmin=310;cint=5;cmax=380;cstep=5;continent='Asia';regiontoplot='caspiansea';windscale=2;labelevery=2;
            placelats=[35.69;37.96;40.41;48.71];placelons=[51.39;58.33;49.87;44.51];
            placenames={'Tehran';'Ashgabat';'Baku';'Volgograd'};placenamelens=[2;2.5;1.3;2.6];boxaroundheight=0.5;
            placenamepos={'r';'a';'r';'r'};
            x1lat=42;x1lon=46;x2lat=42;x2lon=58.5; %W to E
            cblabelfontsize=8;
            terraininterval=250;terrainmax=2000;
            mapleft=0.04;mapbottom=0.08;mapwidth=0.42;mapheight=0.84;
        end
        bigu=utosave;bigv=vtosave;bigw=wtosave;biggh=ghtosave;
        bigmse=msetosave;bigqh=qhtosave;bigql=qltosave;bigt=ttosave;bigtd=tdtosave;
        bigmse2m=mse2mtosave;bigqh2m=qh2mtosave;bigql2m=ql2mtosave;bigt2m=t2mtosave;bigtd2m=td2mtosave;
        mllatgrid=mllatgridtosave;mllongrid=mllongridtosave;homarray=homarraytosave;
        yeararray=yeartosave;doyherearray=doyheretosave;
        presml=presmltosave;bigz_ml=zmltosave;
        
        if strcmp(actualoranom,'anom')
            clear thisuclimo_rep;for i=1:size(bigu,1);thisuclimo_rep(i,:,:,:,:)=repmat(eval(['uclimoreg' num2str(regloop) ';']),[3 1 1 1]);end
            bigu=bigu-thisuclimo_rep;
            clear thisvclimo_rep;for i=1:size(bigv,1);thisvclimo_rep(i,:,:,:,:)=repmat(eval(['vclimoreg' num2str(regloop) ';']),[3 1 1 1]);end
            bigv=bigv-thisvclimo_rep;
            clear thiswclimo_rep;for i=1:size(bigw,1);thiswclimo_rep(i,:,:,:,:)=repmat(eval(['wclimoreg' num2str(regloop) ';']),[3 1 1 1]);end
            bigw=bigw-thiswclimo_rep;
            clear thismseclimo_rep;for i=1:size(bigmse,1);thismseclimo_rep(i,:,:,:,:)=repmat(eval(['mseclimoreg' num2str(regloop) ';']),[3 1 1 1]);end
            bigmse=bigmse-thismseclimo_rep;
            clear thismse2mclimo_rep;for i=1:size(bigmse2m,1);thismse2mclimo_rep(i,:,:,:,:)=repmat(eval(['mse2mclimoreg' num2str(regloop) ';']),[3 1 1 1]);end
            bigmse2m=bigmse2m-thismse2mclimo_rep;
        end
        
        
        %Eliminate repeated days before plotting composites
        newi=1;lastdifferentrow=1;
        clear uniquebigmse;clear uniquebigmse2m;clear uniquebigqh;clear uniquebigql;clear uniquebigu;clear uniquebigv;clear uniquebigw;clear uniquebigz_ml;clear uniquebigghofsfc;
        uniquebigmse(1,:,:,:,:)=bigmse(1,:,:,:,:);
        uniquebigmse2m(1,:,:,:)=bigmse2m(1,:,:,:);
        uniquebigqh(1,:,:,:,:)=bigqh(1,:,:,:,:);
        uniquebigql(1,:,:,:,:)=bigql(1,:,:,:,:);
        uniquebigu(1,:,:,:,:)=bigu(1,:,:,:,:);
        uniquebigv(1,:,:,:,:)=bigv(1,:,:,:,:);
        uniquebigw(1,:,:,:,:)=bigw(1,:,:,:,:);
        uniquebigz_ml(1,:,:,:,:)=bigz_ml(1,:,:,:,:);
        
        
        for i=2:size(bigmse,1)
            if bigmse(i,4,5,10,10)~=bigmse(lastdifferentrow,4,5,10,10) %i.e. this is a new day that we want to have
                newi=newi+1;
                uniquebigmse(newi,:,:,:,:)=bigmse(i,:,:,:,:);
                uniquebigmse2m(newi,:,:,:)=bigmse2m(i,:,:,:);
                uniquebigqh(newi,:,:,:,:)=bigqh(i,:,:,:,:);
                uniquebigql(newi,:,:,:,:)=bigql(i,:,:,:,:);
                uniquebigu(newi,:,:,:,:)=bigu(i,:,:,:,:);
                uniquebigv(newi,:,:,:,:)=bigv(i,:,:,:,:);
                uniquebigw(newi,:,:,:,:)=bigw(i,:,:,:,:);
                uniquebigz_ml(newi,:,:,:,:)=bigz_ml(i,:,:,:,:);
                lastdifferentrow=i;
            end
        end
        clear bigmse;clear bigmse2m;clear bigqh;clear bigql;clear bigu;clear bigv;clear bigw;clear bigz_ml;
        clear bigt;clear bigtd;clear bigqh2m;clear bigql2m;clear bigt2m;clear bigtd2m;

        if makemap==1
            %Winds and MSE in boundary layer
            clear meanu;clear meanv;clear meanmse2m;
            for incident=1:size(uniquebigu,1)
                meanu(incident,:,:)=squeeze(uniquebigu(incident,homarray(incident),windlev,:,:));
                meanv(incident,:,:)=squeeze(uniquebigv(incident,homarray(incident),windlev,:,:));
                meanmse2m(incident,:,:)=squeeze(uniquebigmse2m(incident,homarray(incident),:,:));
            end
            meanu=squeeze(mean(meanu,1));meanv=squeeze(mean(meanv,1));meanmse2m=squeeze(mean(meanmse2m,1));

            figure(800+regloop);clf;curpart=1;highqualityfiguresetup;
            data={mllatgrid';mllongrid';meanmse2m'};winddata={mllatgrid';mllongrid';meanu';meanv'};terraindata={mllatgrid';mllongrid';elev_maingrid'};
            vararginnew={'datatounderlay';data;'underlaycaxismin';cmin;'underlaycaxismax';cmax;'mystepunderlay';cstep;...
                'underlaycolormap';colormaps('blueyellowred',num2str(((cmax-cmin)/cint)+1),'not');'overlaynow';1;...
                'variable';'wind';'vectorData';winddata;'customwindvectorlength';windscale;'anomavg';'avg';...
                'conttoplot';continent;'customborderwidth';2;'nonewfig';1;...
                'contour_overlay';1;'datatooverlay';terraindata;'caxismin';0;'caxismax';terrainmax;'omitzerocontour';1;'mystep';terraininterval;...
                'contourlabels';1;'manualcontourlabels';1;'cblabelfontsize';cblabelfontsize};
            datatype='custom';region=regiontoplot;
            plotModelData(data,region,vararginnew,datatype);

            %Add additional things to make the plot nice
            setm(gca,'MeridianLabel','on','ParallelLabel','on','MLineLocation',1,'PLineLocation',1,'MLabelLocation',labelevery,'PLabelLocation',labelevery,...
                'fontweight','bold','fontsize',12,'fontname','arial');

            hcb=colorbar;hcb.Label.String='MSE/Moist Enthalpy (kJ/kg)';hcb.Label.FontSize=16;hcb.Label.FontWeight='bold';hcb.Label.FontName='arial';
            curcbpos=get(hcb,'Position');


            %Any notable rivers
            if regloop==2
                indusriver=shaperead(strcat(icloud,'General_Academics/Research/KeyFiles/MajorRivers.shp'),'UseGeoCoords',true,'Selector', ...
                    {@(name) strcmp(name,{'Indus'}), 'NAME'});
                geoshow(indusriver.Lat,indusriver.Lon,'DisplayType','line','color',colors('sky blue'),'linewidth',1.5);
            elseif regloop==3
                gangesriver=shaperead(strcat(icloud,'General_Academics/Research/KeyFiles/MajorRivers.shp'),'UseGeoCoords',true,'Selector', ...
                    {@(name) strcmp(name,{'Ganges'}), 'NAME'});
                geoshow(gangesriver.Lat,gangesriver.Lon,'DisplayType','line','color',colors('sky blue'),'linewidth',1.5);
                brahmaputrariver=shaperead(strcat(icloud,'General_Academics/Research/KeyFiles/MajorRivers.shp'),'UseGeoCoords',true,'Selector', ...
                    {@(name) strcmp(name,{'Brahmaputra'}), 'NAME'});
                geoshow(brahmaputrariver.Lat,brahmaputrariver.Lon,'DisplayType','line','color',colors('sky blue'),'linewidth',1.5);
                irrawaddyriver=shaperead(strcat(icloud,'General_Academics/Research/KeyFiles/MajorRivers.shp'),'UseGeoCoords',true,'Selector', ...
                    {@(name) strcmp(name,{'Irrawaddy'}), 'NAME'});
                geoshow(irrawaddyriver.Lat,irrawaddyriver.Lon,'DisplayType','line','color',colors('sky blue'),'linewidth',1.5);
            elseif regloop==5
                amazonriver=shaperead(strcat(icloud,'General_Academics/Research/KeyFiles/MajorRivers.shp'),'UseGeoCoords',true,'Selector', ...
                    {@(name) strcmp(name,{'Amazon'}), 'NAME'});
                geoshow(amazonriver.Lat,amazonriver.Lon,'DisplayType','line','color',colors('sky blue'),'linewidth',1.5);
                rionegro=shaperead(strcat(icloud,'General_Academics/Research/KeyFiles/MajorRivers.shp'),'UseGeoCoords',true,'Selector', ...
                    {@(name) strcmp(name,{'Rio Negro'}), 'NAME'});
                geoshow(rionegro.Lat,rionegro.Lon,'DisplayType','line','color',colors('sky blue'),'linewidth',1.5);
                purusriver=shaperead(strcat(icloud,'General_Academics/Research/KeyFiles/MajorRivers.shp'),'UseGeoCoords',true,'Selector', ...
                    {@(name) strcmp(name,{'Purus'}), 'NAME'});
                geoshow(purusriver.Lat,purusriver.Lon,'DisplayType','line','color',colors('sky blue'),'linewidth',1.5);
            elseif regloop==8
                mississippiriver=shaperead(strcat(icloud,'General_Academics/Research/KeyFiles/MajorRivers.shp'),'UseGeoCoords',true,'Selector', ...
                    {@(name) strcmp(name,{'Mississippi'}), 'NAME'});
                geoshow(mississippiriver.Lat,mississippiriver.Lon,'DisplayType','line','color',colors('sky blue'),'linewidth',1.5);
                missouririver=shaperead(strcat(icloud,'General_Academics/Research/KeyFiles/MajorRivers.shp'),'UseGeoCoords',true,'Selector', ...
                    {@(name) strcmp(name,{'Missouri'}), 'NAME'});
                geoshow(missouririver.Lat,missouririver.Lon,'DisplayType','line','color',colors('sky blue'),'linewidth',1.5);
            end

            %Line indicating cross-section location, with labels A and B
            geoshow([x1lat,x2lat],[x1lon,x2lon],'DisplayType','line','color',colors('green'),'linewidth',3);
            if regloop==1
                txt=textm(x1lat+0.4,x1lon-0.5,'A');set(txt,'color',colors('green'),'fontsize',15,'fontweight','bold','fontname','arial');
                txt=textm(x2lat-0.3,x2lon+0.2,'B');set(txt,'color',colors('green'),'fontsize',15,'fontweight','bold','fontname','arial');
            elseif regloop==2
                if strcmp(typeofxsection,'normalxsection')
                    txt=textm(x1lat-0.4,x1lon-0.1,'A');set(txt,'color',colors('green'),'fontsize',15,'fontweight','bold','fontname','arial');
                    txt=textm(x2lat-0.4,x2lon-0.2,'B');set(txt,'color',colors('green'),'fontsize',15,'fontweight','bold','fontname','arial');
                elseif strcmp(typeofxsection,'bigxsection') || strcmp(typeofxsection,'bigxsection-se')
                    txt=textm(x1lat+0.4,x1lon-0.3,'A');set(txt,'color',colors('green'),'fontsize',15,'fontweight','bold','fontname','arial');
                    txt=textm(x2lat+0.4,x2lon-0.5,'B');set(txt,'color',colors('green'),'fontsize',15,'fontweight','bold','fontname','arial');
                end
            elseif regloop==3
                txt=textm(x1lat+0.5,x1lon-0.2,'A');set(txt,'color',colors('green'),'fontsize',15,'fontweight','bold','fontname','arial');
                txt=textm(x2lat+0.4,x2lon-0.1,'B');set(txt,'color',colors('green'),'fontsize',15,'fontweight','bold','fontname','arial');
            elseif regloop==5
                txt=textm(x1lat+0.5,x1lon-0.1,'A');set(txt,'color',colors('green'),'fontsize',15,'fontweight','bold','fontname','arial');
                txt=textm(x2lat+0.4,x2lon-0.3,'B');set(txt,'color',colors('green'),'fontsize',15,'fontweight','bold','fontname','arial');
            end
            
            meanwindspd=sqrt(meanu.^2+meanv.^2);

            %Cities
            hold on;citylats=placelats;citylons=placelons;citynames=placenames;
            for i=1:size(citylats,1)
                geoshow(citylats(i),citylons(i),'DisplayType','Point','Marker','o','MarkerFaceColor','k','MarkerEdgeColor','k','MarkerSize',8);
                if strcmp(placenamepos{i},'r') %label right of city
                    txt=textm(citylats(i),citylons(i)+0.3,citynames{i});set(txt,'fontsize',12,'fontweight','bold','fontname','arial');
                    boxaround=geoshow([citylats(i)-boxaroundheight/2,citylats(i)+boxaroundheight/2,citylats(i)+boxaroundheight/2,citylats(i)-boxaroundheight/2],...
                        [citylons(i)+0.2,citylons(i)+0.2,citylons(i)+placenamelens(i)+0.1,citylons(i)+placenamelens(i)+0.1],...
                        'DisplayType','Polygon','FaceColor','w'); %starts from lower left corner and proceeds clockwise
                elseif strcmp(placenamepos{i},'a') %label above city
                    txt=textm(citylats(i)+0.5,citylons(i)-1,citynames{i});set(txt,'fontsize',12,'fontweight','bold','fontname','arial');
                    boxaround=geoshow([citylats(i)+0.5-boxaroundheight/2,citylats(i)+0.5+boxaroundheight/2,...
                        citylats(i)+0.5+boxaroundheight/2,citylats(i)+0.5-boxaroundheight/2],...
                        [citylons(i)+0.14-1.2,citylons(i)+0.14-1.2,citylons(i)+placenamelens(i)-1.2,citylons(i)+placenamelens(i)-1.2],...
                        'DisplayType','Polygon','FaceColor','w'); %starts from lower left corner and proceeds clockwise
                end
            end
            set(gca,'fontsize',14,'fontweight','bold','fontname','arial');framem on;

            %figname=strcat('compositemap1_',regiontoplot);curpart=2;highqualityfiguresetup;
            set(gca,'Position',[mapleft mapbottom mapwidth mapheight]);
            if regloop==1 || regloop>=3;newcbpos=mapleft+mapwidth+0.01;elseif regloop==2;newcbpos=mapleft+mapwidth-0.04;end
            set(hcb,'fontweight','bold','fontsize',14,'fontname','arial','Position',[newcbpos curcbpos(2) curcbpos(3) curcbpos(4)]);
            set(gca,'ycolor','none','box','off');
        end



        %Cross-section
        if makexsection==1
            if makemap==0;figure(900+regloop);clf;hold on;end
            %subplot(1,2,2);set(gca,'Position',[0.63 0.1 0.35 0.8]);

            xsectioncity1lat=x1lat;xsectioncity1lon=x1lon;
            xsectioncity2lat=x2lat;xsectioncity2lon=x2lon;
            %Find endpoints of x-section
            smallestdist1_main=1000;smallestdist2_main=1000;
            for i=1:size(uniquebigmse,4)
                for j=1:size(uniquebigmse,5)
                    thisdist1_main=distance(mllatgrid(i,j),mllongrid(i,j),xsectioncity1lat,xsectioncity1lon);
                    thisdist2_main=distance(mllatgrid(i,j),mllongrid(i,j),xsectioncity2lat,xsectioncity2lon);
                    if thisdist1_main<smallestdist1_main
                        closesti1_main=i;closestj1_main=j;smallestdist1_main=thisdist1_main;
                    end
                    if thisdist2_main<smallestdist2_main
                        closesti2_main=i;closestj2_main=j;smallestdist2_main=thisdist2_main;
                    end
                end
            end
            smallestdist1=1000;smallestdist2=1000;
            for i=1:size(mllatgrid,1)
                for j=1:size(mllatgrid,2)
                    thisdist1=distance(mllatgrid(i,j),mllongrid(i,j),xsectioncity1lat,xsectioncity1lon);
                    thisdist2=distance(mllatgrid(i,j),mllongrid(i,j),xsectioncity2lat,xsectioncity2lon);
                    if thisdist1<smallestdist1
                        closesti1=i;closestj1=j;smallestdist1=thisdist1;
                    end
                    if thisdist2<smallestdist2
                        closesti2=i;closestj2=j;smallestdist2=thisdist2;
                    end
                end
            end
            %Get indices of 21 points equally spaced along this x-section
            totalidist_main=closesti2_main-closesti1_main;totaljdist_main=closestj2_main-closestj1_main;
            totalidist=closesti2-closesti1;totaljdist=closestj2-closestj1;
            clear ql_thisxsection;clear mse_thisxsection;clear w_thisxsection;clear zml_thisxsection;
            clear partial_lats_main;clear partial_lons_main;clear partial_lats;clear partial_lons;
            for loop=1:21
                partiali_main=round(closesti1_main+totalidist_main*(loop-1)/20);partialj_main=round(closestj1_main+totaljdist_main*(loop-1)/20);
                partial_lats_main(loop)=round2(mllatgrid(round(closesti1_main+totalidist_main*(loop-1)/20),round(closestj1_main+totaljdist_main*(loop-1)/20)),0.1);
                partial_lons_main(loop)=round2(mllongrid(round(closesti1_main+totalidist_main*(loop-1)/20),round(closestj1_main+totaljdist_main*(loop-1)/20)),0.1);
                partiali=round(closesti1+totalidist*(loop-1)/20);partialj=round(closestj1+totaljdist*(loop-1)/20);

                clear ql_thisxsection_alldays;clear mse_thisxsection_alldays;clear w_thisxsection_alldays;clear zml_thisxsection_alldays;
                for day=1:size(uniquebigql,1)
                    ql_thisxsection_alldays(day,:)=squeeze(uniquebigql(day,homarray(day),:,partiali_main,partialj_main));
                    mse_thisxsection_alldays(day,:)=squeeze(uniquebigmse(day,homarray(day),:,partiali_main,partialj_main));
                    w_thisxsection_alldays(day,:)=squeeze(uniquebigw(day,homarray(day),:,partiali_main,partialj_main));
                    zml_thisxsection_alldays(day,:)=squeeze(uniquebigz_ml(day,homarray(day),:,partiali_main,partialj_main));
                end
                ql_thisxsection(loop,:)=squeeze(mean(ql_thisxsection_alldays,'omitnan'));
                mse_thisxsection(loop,:)=squeeze(mean(mse_thisxsection_alldays,'omitnan'));
                w_thisxsection(loop,:)=squeeze(mean(w_thisxsection_alldays,'omitnan'));
                zml_thisxsection(loop,:)=squeeze(mean(zml_thisxsection_alldays,'omitnan'));
                totalheight_thisxsection(loop,:)=zml_thisxsection(loop,:)+elev_maingrid(partiali_main,partialj_main).*ones(1,12);
            end
            clear uniquebigmse;clear uniquebigmse2m;clear uniquebigqh;clear uniquebigql;
            clear uniquebigu;clear uniquebigv;clear uniquebigw;clear uniquebigz_ml;clear uniquebigghofsfc;
            
            %Plot for the cross-section
            %invalid=w_thisxsection==0;w_thisxsection(invalid)=NaN;
            w_thisxsection=w_thisxsection';w_thisxsection=-1.*w_thisxsection;
            ql_thisxsection=ql_thisxsection';
            mse_thisxsection=mse_thisxsection';
            zml_thisxsection=zml_thisxsection';
            for row=1:gothru(regloop)
                if isnan(ql_thisxsection(row,loop)) %no vv at lowest level (or underground)
                    if row~=1
                        w_thisxsection(row-1:end,loop)=NaN; 
                    elseif row==1
                        w_thisxsection(row:end,loop)=NaN; 
                    end
                end
            end
            
            
            axesleftpos=0.605;axeswidth=0.34;axesheight=0.21;
            
            txt=text(axesleftpos-0.005,0.02,'A');set(txt,'color',colors('medium green'),'fontsize',15,'fontweight','bold','fontname','arial');
            txt=text(axesleftpos+axeswidth-0.005,0.02,'B');set(txt,'color',colors('medium green'),'fontsize',15,'fontweight','bold','fontname','arial');
                        

            %Plot the cross-section
            %Shading for MSE, arrows for w
            levels=cmin:cint:cmax;
            Z=flipud(real(mse_thisxsection));
            clear X;for xx=1:12;X(xx,:)=1:21;end;Y=flipud(totalheight_thisxsection');invalid=Y<3;Y(invalid)=0; %make sea level actually at sea level...

            

            %Plot MSE
            ax(1)=axes('position',[axesleftpos 0.74 axeswidth axesheight]);
            contourf(X,Y,Z,levels);hold on;

            %Copy axes to cleverly have a varied y-scale
            ax(2)=copyobj(ax(1),gcf);set(ax(2),'position',[axesleftpos 0.53 axeswidth axesheight]);
            ax(3)=copyobj(ax(1),gcf);set(ax(3),'position',[axesleftpos 0.32 axeswidth axesheight]);
            ax(4)=copyobj(ax(1),gcf);set(ax(4),'position',[axesleftpos 0.11 axeswidth axesheight]);

            set(ax(1),'box','off','xcolor','none'); set(ax(2),'box','off','xcolor','none');set(ax(3),'box','off','xcolor','none');set(ax(4),'box','off');

            
            if regloop==1
                ax1lower=2500;ax1upper=12500;ax2lower=500;ax2upper=2500;ax3lower=100;ax3upper=500;ax4lower=0;ax4upper=100;
                ax1tickint=5000;ax2tickint=1000;ax3tickint=200;ax4tickint=50;
                scalefactor=0.7; %<1 shrinks vectors, >1 expands them
            elseif regloop==2 && strcmp(typeofxsection,'normalxsection')
                ax1lower=2500;ax1upper=13000;ax2lower=1000;ax2upper=2500;ax3lower=400;ax3upper=1000;ax4lower=150;ax4upper=400;
                ax1tickint=5000;ax2tickint=500;ax3tickint=300;ax4tickint=100;
                scalefactor=0.7; %<1 shrinks vectors, >1 expands them
            elseif regloop==2 && (strcmp(typeofxsection,'bigxsection') || strcmp(typeofxsection,'bigxsection-se'))
                ax1lower=2500;ax1upper=13000;ax2lower=1000;ax2upper=2500;ax3lower=250;ax3upper=1000;ax4lower=0;ax4upper=250;
                ax1tickint=5000;ax2tickint=500;ax3tickint=250;ax4tickint=50;
                scalefactor=0.4; %<1 shrinks vectors, >1 expands them
            elseif regloop==3
                ax1lower=2500;ax1upper=12500;ax2lower=500;ax2upper=2500;ax3lower=100;ax3upper=500;ax4lower=0;ax4upper=100;
                ax1tickint=5000;ax2tickint=1000;ax3tickint=200;ax4tickint=50;
                scalefactor=0.5; %<1 shrinks vectors, >1 expands them
            elseif regloop==5
                ax1lower=2500;ax1upper=13000;ax2lower=1000;ax2upper=2500;ax3lower=400;ax3upper=1000;ax4lower=150;ax4upper=400;
                ax1tickint=5000;ax2tickint=500;ax3tickint=300;ax4tickint=100;
                scalefactor=0.5; %<1 shrinks vectors, >1 expands them
            end
            
            set(ax(1),'ylim',[ax1lower ax1upper]);set(ax(2),'ylim',[ax2lower ax2upper]);set(ax(3),'ylim',[ax3lower ax3upper]);set(ax(4),'ylim',[ax4lower ax4upper]);
            linkaxes(ax,'x');
            ax(5)=axes('position',[0 0 1 1]);set(ax(5),'color','none','xcolor','none','ycolor','none','box','off');

            %Label left side with geopotential heights and right side with (approx) pressure levels
            prestolabel={'200';'300';'500';'700';'850';'900';'950';'975';'990';'1000';'1007';'1012'};
            set(ax(1),'ytick',ax1lower:ax1tickint:ax1upper);axbottomval=ax1lower;axtopval=ax1upper;
            cc1first=1;cc1last=4;cc2first=5;cc2last=6;cc3first=7;cc3last=9;cc4first=10;cc4last=12;
            for cc=cc1first:cc1last
                labeltextypos=ax(1).Position(2)+(avgelevs_mllevs(cc)-axbottomval)/(axtopval-axbottomval)*axesheight;
                labeltext=text(0.95,labeltextypos,prestolabel{cc},'units','normalized');set(labeltext,'fontweight','bold','fontname','arial','fontsize',12,'parent',ax(5));
            end
            set(ax(2),'ytick',ax2lower:ax2tickint:ax2upper);axbottomval=ax2lower;axtopval=ax2upper;
            for cc=cc2first:cc2last
                labeltextypos=ax(2).Position(2)+(avgelevs_mllevs(cc)-axbottomval)/(axtopval-axbottomval)*axesheight;
                labeltext=text(0.95,labeltextypos,prestolabel{cc},'units','normalized');set(labeltext,'fontweight','bold','fontname','arial','fontsize',12,'parent',ax(5));
            end
            set(ax(3),'ytick',ax3lower:ax3tickint:ax3upper);axbottomval=ax3lower;axtopval=ax3upper;
            for cc=cc3first:cc3last
                if cc~=9
                labeltextypos=ax(3).Position(2)+(avgelevs_mllevs(cc)-axbottomval)/(axtopval-axbottomval)*axesheight;
                labeltext=text(0.95,labeltextypos,prestolabel{cc},'units','normalized');set(labeltext,'fontweight','bold','fontname','arial','fontsize',12,'parent',ax(5));
                end
            end
            set(ax(4),'ytick',ax4lower:ax4tickint:ax4upper);axbottomval=ax4lower;axtopval=ax4upper;
            for cc=cc4first:cc4last
                if cc~=11
                labeltextypos=ax(4).Position(2)+(avgelevs_mllevs(cc)-axbottomval)/(axtopval-axbottomval)*axesheight;
                labeltext=text(0.95,labeltextypos,prestolabel{cc},'units','normalized');set(labeltext,'fontweight','bold','fontname','arial','fontsize',12,'parent',ax(5));
                end
            end


            %Plot wind
            wflipped=flipud(w_thisxsection);
            
            for minilev=2:12 %minilev 1 is sfc, 12 is ~200mb
                xtoplot=1:20;ytoplot=Y(minilev,1:20);utoplot=zeros(1,20);vtoplot=wflipped(minilev,1:20);
                for jjj=1:length(xtoplot)
                    %Determine which axis to plot on
                    if ytoplot(jjj)<ax4upper %axis 4
                        thisax=ax(4);axbottomval=ax4lower;axtopval=ax4upper;
                    elseif ytoplot(jjj)<ax3upper %axis 3
                        thisax=ax(3);axbottomval=ax3lower;axtopval=ax3upper;
                    elseif ytoplot(jjj)<ax2upper %axis 2
                        thisax=ax(2);axbottomval=ax2lower;axtopval=ax2upper;
                    elseif ytoplot(jjj)<ax1upper %axis 1
                        thisax=ax(1);axbottomval=ax1lower;axtopval=ax1upper;
                    end
                    
                    %Do plotting
                    ystart=thisax.Position(2)+((ytoplot(jjj)-axbottomval)/(axtopval-axbottomval))*axesheight;
                    ystop=ystart+vtoplot(jjj)*scalefactor;
                    xstart=thisax.Position(1)+(xtoplot(jjj)/21)*axeswidth;xstop=xstart;
                    ah=annotation('arrow',[xstart xstop],[ystart ystop],'headStyle','vback2','HeadLength',8,'HeadWidth',8,'LineWidth',1.5);
                    set(ah,'parent',ax(5));
                end
            end
            caxis(ax(1),[cmin cmax]);caxis(ax(2),[cmin cmax]);caxis(ax(3),[cmin cmax]);caxis(ax(4),[cmin cmax]);
            set(ax(1),'color',colors('gray'));set(ax(2),'color',colors('gray'));set(ax(3),'color',colors('gray'));set(ax(4),'color',colors('gray'));
            
            set(ax(4),'XTick',1:4:21,'XTickLabel',partial_lons_main(1:4:21));
            set(ax(1),'fontweight','bold','fontname','arial','fontsize',12);set(ax(2),'fontweight','bold','fontname','arial','fontsize',12);
            set(ax(3),'fontweight','bold','fontname','arial','fontsize',12);set(ax(4),'fontweight','bold','fontname','arial','fontsize',12);
            ytext=text(axesleftpos-0.045,0.35,'Geopotential Height (m)','units','normalized');set(ytext,'fontweight','bold','fontname','arial','fontsize',14,'parent',ax(5),'rotation',90);
            xtext=text(axesleftpos+0.13,0.05,'Longitude E','units','normalized');set(xtext,'fontweight','bold','fontname','arial','fontsize',14,'parent',ax(5));
            y2text=text(axesleftpos+axeswidth+0.04,0.38,'Approx. Pressure (mb)','units','normalized');set(y2text,'fontweight','bold','fontname','arial','fontsize',14,'parent',ax(5),'rotation',90);
            set(ax(1),'colormap',colormaps('blueyellowred','more','not'));set(ax(2),'colormap',colormaps('blueyellowred','more','not'));
            set(ax(3),'colormap',colormaps('blueyellowred','more','not'));set(ax(4),'colormap',colormaps('blueyellowred','more','not'));
            
            
            %Add unit arrows and associated labels
            if regloop==1
                if strcmp(actualoranom,'actual')
                    arr=annotation('arrow',[0.43 0.45],[0.07 0.07]);
                    txt=text(0.42,0.05,'10 m/s');set(txt,'fontsize',10,'fontweight','bold','fontname','arial','units','normalized');
                else
                    arr=annotation('arrow',[0.43 0.45],[0.07 0.07]);
                    txt=text(0.43,0.05,'5 m/s');set(txt,'fontsize',10,'fontweight','bold','fontname','arial','units','normalized');
                end
            elseif regloop==2
                if strcmp(actualoranom,'actual')
                    arr=annotation('arrow',[0.475 0.495],[0.07 0.07]);
                    txt=text(0.465,0.05,'10 m/s');set(txt,'fontsize',10,'fontweight','bold','fontname','arial','units','normalized');
                else
                    arr=annotation('arrow',[0.485 0.495],[0.07 0.07]);set(arr,'HeadLength',5);
                    txt=text(0.47,0.05,'5 m/s');set(txt,'fontsize',10,'fontweight','bold','fontname','arial','units','normalized');
                end
            end
            
            if regloop==1
                arr=annotation('arrow',[0.9 0.9],[0.035 0.065]);
                if strcmp(actualoranom,'actual')
                    txt=text(0.91,0.05,'100 mb/day');set(txt,'fontsize',10,'fontweight','bold','fontname','arial','units','normalized');
                else
                    txt=text(0.91,0.05,'25 mb/day');set(txt,'fontsize',10,'fontweight','bold','fontname','arial','units','normalized');
                end
            elseif regloop==2
                arr=annotation('arrow',[0.87 0.87],[0.035 0.065]);
                if strcmp(actualoranom,'actual')
                    txt=text(0.88,0.05,'50 mb/day');set(txt,'fontsize',10,'fontweight','bold','fontname','arial','units','normalized');
                else
                    txt=text(0.88,0.05,'50 mb/day');set(txt,'fontsize',10,'fontweight','bold','fontname','arial','units','normalized');
                end
            end
            txt=text(axesleftpos-0.005,0.02,'A');set(txt,'color',colors('medium green'),'fontsize',15,'fontweight','bold','fontname','arial');
            txt=text(axesleftpos+axeswidth-0.005,0.02,'B');set(txt,'color',colors('medium green'),'fontsize',15,'fontweight','bold','fontname','arial');
            
          
            set(gcf,'color','w');
            figname=strcat('compositemap2_',regiontoplot,typeofxsection,actualoranom);curpart=2;highqualityfiguresetup;
        end
    end
    clear bigu;clear bigv;clear bigw;clear biggh;clear bigmse;clear bigqh;clear bigql;clear bigt;clear bigtd;clear bigmsem2m;clear bigqh2m;clear bigql2m;clear bigt2m;clear bigtd2m;
end
