 

exist era5latarray;
if ans==0
    temp=load(strcat(icloud,'General_Academics/Research/Basics/Basics_ERA5/latlonarray'));era5latarray=temp.latarray;era5lonarray=temp.lonarray;
        era5lonarray=[era5lonarray(:,721:1440) era5lonarray(:,1:720)];
end

exist elevera5;
if ans==0
    temp=ncread('elevera5.nc','z');elevera5=(squeeze(temp(:,:,1))./9.81)';
    elevera5=[elevera5(:,721:1440) elevera5(:,1:720)];
end


if mapandlatprofilefigure==1
    exist maxmsebypoint;
    if ans==0
        thisfile=load('/Volumes/ExternalDriveZ/ERA5_Hourly_Data/mseqhqlstats');
        maxmsebypoint=thisfile.maxmsebypoint;maxmse_latbandavg=thisfile.maxmse_latbandavg;
        p99mse_latbandavg=thisfile.p99mse_latbandavg;p50mse_latbandavg=thisfile.p50mse_latbandavg;
        maxqh_latbandavg=thisfile.maxqh_latbandavg;maxql_latbandavg=thisfile.maxql_latbandavg;
        p99qh_latbandavg=thisfile.p99qh_latbandavg;p99ql_latbandavg=thisfile.p99ql_latbandavg;
    end
    
    figure(1);clf;curpart=1;highqualityfiguresetup;
    maxmsebypointcorr=[maxmsebypoint(:,721:1440) maxmsebypoint(:,1:720)];
    data={era5latarray;era5lonarray;maxmsebypointcorr};
    datatype='custom';region='world60s60n_mainlandareasonly';
    vararginnew={'underlayvariable';'wet-bulb temp';'contour';0;...
        'underlaycaxismin';290;'underlaycaxismax';410;'overlaynow';0;...
        'datatounderlay';data;'centeredon';0;'conttoplot';'all';'nonewfig';1;'stateboundaries';0;'plabelon';1};
    plotModelData(data,region,vararginnew,datatype);
    for reg=1:7
        if reg==1 || reg==2 || reg==3 || reg==5
            hold on;geoshow([regsouthbounds(reg) regnorthbounds(reg) regnorthbounds(reg) regsouthbounds(reg) regsouthbounds(reg)],...
                [regwestbounds(reg) regwestbounds(reg) regeastbounds(reg) regeastbounds(reg) regwestbounds(reg)],...
                'DisplayType','line','color','w','linewidth',2,'linestyle','-.');
            geoshow([subregsouthbounds(reg) subregnorthbounds(reg) subregnorthbounds(reg) subregsouthbounds(reg) subregsouthbounds(reg)],...
                [subregwestbounds(reg) subregwestbounds(reg) subregeastbounds(reg) subregeastbounds(reg) subregwestbounds(reg)],...
                'DisplayType','line','color',colors('white'),'linewidth',1.5);
            %previously subregions were in gold
        end
    end
    colormap(colormaps('rainbowhighlightinguppervalues','more','not'));
    title('All-Time-Maximum Moist Enthalpy','fontsize',16,'fontweight','bold','fontname','arial');
    hcb=colorbar;hcb.Label.String='kJ/kg';hcb.Label.FontSize=14;hcb.Label.FontWeight='bold';hcb.Label.FontName='arial';
    set(hcb,'fontweight','bold','fontsize',12,'fontname','arial');set(hcb,'Location','southoutside');
    curcbpos=get(hcb,'Position');set(hcb,'Position',[0.35 0.17 0.56 0.03]);
    %curpos=get(hcb,'Position');set(hcb,'Position',[curpos(1) curpos(2) 0.8*curpos(3) curpos(4)]);
    %Add latitude tick marks
    %If off by 1 pixel, adjust by 0.001
    t=text(0.095,1.004,'-','units','normalized');set(t,'fontsize',14,'fontname','arial'); %60N
    t=text(0.033,0.837,'-','units','normalized');set(t,'fontsize',14,'fontname','arial'); %40N
    t=text(0.004,0.671,'-','units','normalized');set(t,'fontsize',14,'fontname','arial'); %20N
    t=text(-0.005,0.505,'-','units','normalized');set(t,'fontsize',14,'fontname','arial'); %0
    t=text(0.003,0.338,'-','units','normalized');set(t,'fontsize',14,'fontname','arial'); %20S
    t=text(0.031,0.173,'-','units','normalized');set(t,'fontsize',14,'fontname','arial'); %40S
    t=text(0.095,0.005,'-','units','normalized');set(t,'fontsize',14,'fontname','arial'); %60S
    
    addlatbandavgs=1;
    if addlatbandavgs==1
        set(gca,'Position',[0.27 0.15 0.72 0.72]);
        fig1cpos=get(gca,'Position');
        ax1=axes('Position',[0.1 0.224 0.13 0.571]);

        latstoplot=59.5:-1:-59.5;hold on;
        h=plot(ax1,latstoplot,maxmse_latbandavg(31:150),'color',colors('dark red'),'linewidth',1.5);rotate(h,[0 0 1],90,[0 360 0]);
        h=plot(ax1,latstoplot,p99mse_latbandavg(31:150),'color',colors('red'),'linewidth',1.5);rotate(h,[0 0 1],90,[0 360 0]);
        h=plot(ax1,latstoplot,p50mse_latbandavg(31:150),'color',colors('orange'),'linewidth',1.5);rotate(h,[0 0 1],90,[0 360 0]);
        xlabel('kJ/kg','fontsize',12,'fontweight','bold','fontname','arial','color','k');
        title({'ME:';'Max, p99, p50'},'fontsize',13,'fontweight','bold','fontname','arial','color','k');
        set(gca,'xcolor','k','ycolor','k','YAxisLocation','right');
        set(gca,'YTick',300:120/6:420,'YTickLabel',{'60S','40S','20S','0','20N','40N','60N'},'fontsize',12,'fontweight','bold','fontname','arial');
        %x-axis runs from -50 to 71.875 (not sure why, but roll with it)
        %this means each 10 kJ/kg is 10.156 units
        apart10=121.875/(120/10);apart25=121.875/(120/25);
        set(gca,'XTick',-50+apart10:apart25:-50+apart10+apart25*4,'XTickLabel',{'400','375','350','325','300'},...
            'fontsize',12,'fontweight','bold','fontname','arial');
        %ylabel('Latitude','fontsize',14,'fontweight','bold','fontname','arial');

        h=text(0.02,0.13,'Max','units','normalized');set(h,'fontsize',11,'fontweight','bold','fontname','arial','color',colors('dark red'));
        h=text(0.02,0.08,'p99','units','normalized');set(h,'fontsize',11,'fontweight','bold','fontname','arial','color',colors('red'));
        h=text(0.02,0.03,'p50','units','normalized');set(h,'fontsize',11,'fontweight','bold','fontname','arial','color',colors('orange'));
        
        ax3=axes('Position',ax1.Position,'XAxisLocation','top','Color','none');
        set(ax3,'YTick',[]);set(ax3,'XTick',[]);


        ax2=axes('Position',[0.01 0.224 0.07 0.571]);
        thingtoplot1=maxqh_latbandavg(31:150)-p99qh_latbandavg(31:150);thingtoplot2=maxql_latbandavg(31:150)-p99ql_latbandavg(31:150);
        thingtoplot1=thingtoplot1./1000;thingtoplot2=thingtoplot2./1000;
        h=barh([flipud(thingtoplot1') flipud(thingtoplot2')],'Stacked');%rotate(h,[0 0 1],90,[0 90 0]);
        set(h(1),'FaceColor','g');set(h(2),'FaceColor','b');
        set(gca,'YTick',[],'XDir','reverse');
        xlim([0 60]);
        xlabel('kJ/kg','fontsize',12,'fontweight','bold','fontname','arial');
        title({'Qh, Ql:';'Max-p99'},'fontsize',13,'fontweight','bold','fontname','arial');
        h=text(0.02,0.08,'Qh','units','normalized');set(h,'fontsize',11,'fontweight','bold','fontname','arial','color',colors('green'));
        h=text(0.02,0.03,'Ql','units','normalized');set(h,'fontsize',11,'fontweight','bold','fontname','arial','color',colors('blue'));
        set(gca,'fontsize',12,'fontweight','bold','fontname','arial');
    end
    set(gcf,'color','w');
    figname='maxmsemapelab';curpart=2;highqualityfiguresetup;
end


%multiple timeseries
%combines time_evolution and PBL-height subplots, among other things
%'alt' wind arrays are at 700 mb, regular are at 100 m
if bigtimelinefigure==1
    beginrow=200;endrow=480; %to speed up
    begincol=200;endcol=1360; %again, only when necessary to speed up, and at the cost of comprehensiveness
    
    traceapproach=2; %1 is original (w/ units varying by variable); in 2, everything is converted to std anoms
    
    subregnames={'pg';'pak';'esasia';'';'wamaz'};
    subregnames_2={'pgland';'pgocean';'pak';'esasia';'wamaz'};
    variabnames={'mse';'qh';'ql';'pblh';'precip';'mss';'sfcsensible';'sfclatent';'lw';'sw';'u';'v';'w'};
            
    
    if btfprelimcalc==1
        if traceapproach==1
            exist msemean;
            if ans==0
                temp=load('/Volumes/ExternalDriveZ/ERA5_HHLcalcs/timetraces.mat');
                msemean=temp.msemean;mssmean=temp.mssmean;pblhmean=temp.pblhmean;precipmean=temp.precipmean;qhmean=temp.qhmean;qlmean=temp.qlmean;
                msemeannonextr=temp.msemeannonextr;mssmeannonextr=temp.mssmeannonextr;pblhmeannonextr=temp.pblhmeannonextr;
                precipmeannonextr=temp.precipmeannonextr;qhmeannonextr=temp.qhmeannonextr;qlmeannonextr=temp.qlmeannonextr;
            end
            sfcsensiblemean=NaN.*ones(721,1440,40);sfclatentmean=NaN.*ones(721,1440,40);
            lwmean=NaN.*ones(721,1440,40,3);swmean=NaN.*ones(721,1440,40,3);
            sfcsensiblemeannonextr=NaN.*ones(721,1440,40);sfclatentmeannonextr=NaN.*ones(721,1440,40);
            lwmeannonextr=NaN.*ones(721,1440,40,3);swmeannonextr=NaN.*ones(721,1440,40,3);
            umeannonextr=NaN.*ones(721,1440,40,3);vmeannonextr=NaN.*ones(721,1440,40,3);wmeannonextr=NaN.*ones(721,1440,40,3);
            for k=begincol:endcol
                for j=beginrow:endrow
                    if size(sfcsensiblemerged{j,k},2)>=1
                        invalid=sfcsensiblemerged{j,k}==0;sfcsensiblemerged{j,k}(invalid)=NaN;
                        sfcsensiblemean(j,k,:)=mean(sfcsensiblemerged{j,k},1,'omitnan');
                        invalid=sfclatentmerged{j,k}==0;sfclatentmerged{j,k}(invalid)=NaN;
                        sfclatentmean(j,k,:)=mean(sfclatentmerged{j,k},1,'omitnan');
                    end
                    if size(lwmerged{j,k},1)>=1
                        invalid=lwmerged{j,k}==0;lwmerged{j,k}(invalid)=NaN;
                        lwmean(j,k,:,:)=mean(lwmerged{j,k},1,'omitnan');
                        invalid=swmerged{j,k}==0;swmerged{j,k}(invalid)=NaN;
                        swmean(j,k,:,:)=mean(swmerged{j,k},1,'omitnan');
                        invalid=umerged{j,k}==0;umerged{j,k}(invalid)=NaN;
                        umean(j,k,:,:)=mean(umerged{j,k},1,'omitnan');
                        invalid=vmerged{j,k}==0;vmerged{j,k}(invalid)=NaN;
                        vmean(j,k,:,:)=mean(vmerged{j,k},1,'omitnan');
                        invalid=wmerged{j,k}==0;wmerged{j,k}(invalid)=NaN;
                        wmean(j,k,:,:)=mean(wmerged{j,k},1,'omitnan');
                    end
                    if size(sfcsensiblemergednonextr{j,k},2)>=1
                        invalid=sfcsensiblemergednonextr{j,k}==0;sfcsensiblemergednonextr{j,k}(invalid)=NaN;
                        sfcsensiblemeannonextr(j,k,:)=mean(sfcsensiblemergednonextr{j,k},1,'omitnan');
                        invalid=sfclatentmergednonextr{j,k}==0;sfclatentmergednonextr{j,k}(invalid)=NaN;
                        sfclatentmeannonextr(j,k,:)=mean(sfclatentmergednonextr{j,k},1,'omitnan');
                    end
                    if size(lwmergednonextr{j,k},1)>=1
                        invalid=lwmergednonextr{j,k}==0;lwmergednonextr{j,k}(invalid)=NaN;
                        lwmeannonextr(j,k,:,:)=mean(lwmergednonextr{j,k},1,'omitnan');
                        invalid=swmergednonextr{j,k}==0;swmergednonextr{j,k}(invalid)=NaN;
                        swmeannonextr(j,k,:,:)=mean(swmergednonextr{j,k},1,'omitnan');
                        invalid=umergednonextr{j,k}==0;umergednonextr{j,k}(invalid)=NaN;
                        umeannonextr(j,k,:,:)=mean(umergednonextr{j,k},1,'omitnan');
                        invalid=vmergednonextr{j,k}==0;vmergednonextr{j,k}(invalid)=NaN;
                        vmeannonextr(j,k,:,:)=mean(vmergednonextr{j,k},1,'omitnan');
                        invalid=wmergednonextr{j,k}==0;wmergednonextr{j,k}(invalid)=NaN;
                        wmeannonextr(j,k,:,:)=mean(wmergednonextr{j,k},1,'omitnan');
                    end
                end
            end
        elseif traceapproach==2
            %Compare trace at each point to overall warm-season distribution, and get standardized anomalies
            %To ensure absolute consistency, use this full distribution to recalculate the extreme and non-extreme traces for each variable also
            
            %reloading time here: 3 min per year
            exist lwtimeline;
            if ans==0
                msetimeline=cell(721,1440);lwtimeline=cell(721,1440);swtimeline=cell(721,1440);
                utimeline=cell(721,1440);vtimeline=cell(721,1440);wtimeline=cell(721,1440);
                countsbygridpt=zeros(721,1440);
                datestimeline=cell(721,1440);pblhtimeline=cell(721,1440);preciptimeline=cell(721,1440);precipchirpstimeline=cell(721,1440);
                qhtimeline=cell(721,1440);qltimeline=cell(721,1440);sfclatenttimeline=cell(721,1440);sfcsensibletimeline=cell(721,1440);
                yeartimeline=cell(721,1440);
                for year=firsttimelineyeartodo:lasttimelineyeartodo
                    if needsadjusting2017==1 && year==2017
                        p=2;dividecountsby=2;
                    else
                        p=1;dividecountsby=1;
                    end
                    f=load(strcat('/Volumes/ExternalDriveZ/ERA5_HHLcalcs/fulldistnarrays',num2str(year),'_msetimeline.mat'));
                    for i=1:721;for j=1:1440;sz=size(f.msetimeline{i,j},1);if p==1;toadd=f.msetimeline{i,j};else;toadd=f.msetimeline{i,j}(sz/2+1:end,:);end;msetimeline{i,j}=cat(1,msetimeline{i,j},toadd);end;end
                    f=load(strcat('/Volumes/ExternalDriveZ/ERA5_HHLcalcs/fulldistnarrays',num2str(year),'_lwtimeline.mat'));
                    %for i=1:721;for j=1:1440;lwtimeline{i,j}=cat(1,lwtimeline{i,j},f.lwtimeline{i,j}(ind1:ind2,:));end;end
                    for i=1:721;for j=1:1440;sz=size(f.lwtimeline{i,j},1);if p==1;toadd=f.lwtimeline{i,j};else;toadd=f.lwtimeline{i,j}(sz/2+1:end,:,:);end;lwtimeline{i,j}=cat(1,lwtimeline{i,j},toadd);end;end
                    f=load(strcat('/Volumes/ExternalDriveZ/ERA5_HHLcalcs/fulldistnarrays',num2str(year),'_swtimeline.mat'));
                    for i=1:721;for j=1:1440;sz=size(f.swtimeline{i,j},1);if p==1;toadd=f.swtimeline{i,j};else;toadd=f.swtimeline{i,j}(sz/2+1:end,:,:);end;swtimeline{i,j}=cat(1,swtimeline{i,j},toadd);end;end
                    f=load(strcat('/Volumes/ExternalDriveZ/ERA5_HHLcalcs/fulldistnarrays',num2str(year),'_utimeline.mat'));
                    for i=1:721;for j=1:1440;sz=size(f.utimeline{i,j},1);if p==1;toadd=f.utimeline{i,j};else;toadd=f.utimeline{i,j}(sz/2+1:end,:,:);end;utimeline{i,j}=cat(1,utimeline{i,j},toadd);end;end
                    f=load(strcat('/Volumes/ExternalDriveZ/ERA5_HHLcalcs/fulldistnarrays',num2str(year),'_vtimeline.mat'));
                    for i=1:721;for j=1:1440;sz=size(f.vtimeline{i,j},1);if p==1;toadd=f.vtimeline{i,j};else;toadd=f.vtimeline{i,j}(sz/2+1:end,:,:);end;vtimeline{i,j}=cat(1,vtimeline{i,j},toadd);end;end
                    f=load(strcat('/Volumes/ExternalDriveZ/ERA5_HHLcalcs/fulldistnarrays',num2str(year),'_wtimeline.mat'));
                    for i=1:721;for j=1:1440;sz=size(f.wtimeline{i,j},1);if p==1;toadd=f.wtimeline{i,j};else;toadd=f.wtimeline{i,j}(sz/2+1:end,:,:);end;wtimeline{i,j}=cat(1,wtimeline{i,j},toadd);end;end
                    f=load(strcat('/Volumes/ExternalDriveZ/ERA5_HHLcalcs/fulldistnarrays',num2str(year),'_datestimeline.mat'));
                    for i=1:721;for j=1:1440;sz=size(f.datestimeline{i,j},1);if p==1;toadd=f.datestimeline{i,j};else;toadd=f.datestimeline{i,j}(sz/2+1:end,:);end;datestimeline{i,j}=cat(1,datestimeline{i,j},toadd);end;end
                    f=load(strcat('/Volumes/ExternalDriveZ/ERA5_HHLcalcs/fulldistnarrays',num2str(year),'_pblhtimeline.mat'));
                    for i=1:721;for j=1:1440;sz=size(f.pblhtimeline{i,j},1);if p==1;toadd=f.pblhtimeline{i,j};else;toadd=f.pblhtimeline{i,j}(sz/2+1:end,:);end;pblhtimeline{i,j}=cat(1,pblhtimeline{i,j},toadd);end;end
                    f=load(strcat('/Volumes/ExternalDriveZ/ERA5_HHLcalcs/fulldistnarrays',num2str(year),'_preciptimeline.mat'));
                    for i=1:721;for j=1:1440;sz=size(f.preciptimeline{i,j},1);if p==1;toadd=f.preciptimeline{i,j};else;toadd=f.preciptimeline{i,j}(sz/2+1:end,:);end;preciptimeline{i,j}=cat(1,preciptimeline{i,j},toadd);end;end
                    if year==2013 || year==2017
                        f=load(strcat('/Volumes/ExternalDriveZ/ERA5_HHLcalcs/fulldistnarrays',num2str(year),'_precipchirpstimeline.mat'));
                        for i=1:721;for j=1:1440;sz=size(f.precipchirpstimeline{i,j},1);if p==1;toadd=f.precipchirpstimeline{i,j};else;toadd=f.precipchirpstimeline{i,j}(sz/2+1:end,:);end;precipchirpstimeline{i,j}=cat(1,precipchirpstimeline{i,j},toadd);end;end
                    end
                    f=load(strcat('/Volumes/ExternalDriveZ/ERA5_HHLcalcs/fulldistnarrays',num2str(year),'_qhtimeline.mat'));
                    for i=1:721;for j=1:1440;sz=size(f.qhtimeline{i,j},1);if p==1;toadd=f.qhtimeline{i,j};else;toadd=f.qhtimeline{i,j}(sz/2+1:end,:);end;qhtimeline{i,j}=cat(1,qhtimeline{i,j},toadd);end;end
                    f=load(strcat('/Volumes/ExternalDriveZ/ERA5_HHLcalcs/fulldistnarrays',num2str(year),'_qltimeline.mat'));
                    for i=1:721;for j=1:1440;sz=size(f.qltimeline{i,j},1);if p==1;toadd=f.qltimeline{i,j};else;toadd=f.qltimeline{i,j}(sz/2+1:end,:);end;qltimeline{i,j}=cat(1,qltimeline{i,j},toadd);end;end
                    f=load(strcat('/Volumes/ExternalDriveZ/ERA5_HHLcalcs/fulldistnarrays',num2str(year),'_sfclatenttimeline.mat'));
                    for i=1:721;for j=1:1440;sz=size(f.sfclatenttimeline{i,j},1);if p==1;toadd=f.sfclatenttimeline{i,j};else;toadd=f.sfclatenttimeline{i,j}(sz/2+1:end,:);end;sfclatenttimeline{i,j}=cat(1,sfclatenttimeline{i,j},toadd);end;end
                    f=load(strcat('/Volumes/ExternalDriveZ/ERA5_HHLcalcs/fulldistnarrays',num2str(year),'_sfcsensibletimeline.mat'));
                    for i=1:721;for j=1:1440;sz=size(f.sfcsensibletimeline{i,j},1);if p==1;toadd=f.sfcsensibletimeline{i,j};else;toadd=f.sfcsensibletimeline{i,j}(sz/2+1:end,:);end;sfcsensibletimeline{i,j}=cat(1,sfcsensibletimeline{i,j},toadd);end;end
                    f=load(strcat('/Volumes/ExternalDriveZ/ERA5_HHLcalcs/fulldistnarrays',num2str(year),'_countsbygridpt.mat'));
                    for i=1:721;for j=1:1440;countsbygridpt(i,j)=countsbygridpt(i,j)+f.countsbygridpt(i,j)/dividecountsby;end;end
                    
                    for i=1:721;for j=1:1440;yeartimeline{i,j}=cat(1,yeartimeline{i,j},year.*ones(f.countsbygridpt(i,j)/dividecountsby,1));end;end
                    disp(year);disp(clock);
                end
            end

            exist p99msebypoint;
            if ans==0
                thisfile=load('/Volumes/ExternalDriveZ/ERA5_Hourly_Data/mseqhqlstats');p99msebypoint=thisfile.p99msebypoint;
            end
            exist p99mseglobal;
            if ans==0
                thisfile=load('/Volumes/ExternalDriveZ/ERA5_Hourly_Data/mseqhqlstats');p99mseglobal=thisfile.p99mseglobal;
            end
            exist lsmask;
            if ans==0
                lsmask=ncread('lsmaskquarterdegree.nc','lsm');lsmask=lsmask';lsmask=[lsmask(:,721:1440) lsmask(:,1:720)];
            end
                        
            
            allextrarr=cell(5,15);alltimeline=cell(5,15); %5 regions, 15 variables
            cforextrarr_regions=zeros(5,15);cfortimeline_regions=zeros(5,15);
            
            lowerlimitgridptcount=[3;12;5;0;2];
            
            subregrowstarts=[259;221;253;NaN;413];subregrowstops=[269;241;281;NaN;435];subregcolstarts=[929;999;1060;NaN;445];subregcolstops=[945;1013;1080;NaN;473];
            
            
            p99msebypoint_on0=[p99msebypoint(:,721:1440) p99msebypoint(:,1:720)];
            msestdanomextr=NaN.*ones(721,1440,40);qhstdanomextr=NaN.*ones(721,1440,40);qlstdanomextr=NaN.*ones(721,1440,40);
            pblhstdanomextr=NaN.*ones(721,1440,40);precipstdanomextr=NaN.*ones(721,1440,40);mssstdanomextr=NaN.*ones(721,1440,40);
            sfcsensiblestdanomextr=NaN.*ones(721,1440,40);sfclatentstdanomextr=NaN.*ones(721,1440,40);
            lwstdanomextr=NaN.*ones(721,1440,40,3);swstdanomextr=NaN.*ones(721,1440,40,3);
            ustdanomextr=NaN.*ones(721,1440,40,3);vstdanomextr=NaN.*ones(721,1440,40,3);wstdanomextr=NaN.*ones(721,1440,40,3);
            smstdanomextr=NaN.*ones(721,1440,40);precipchirpsstdanomextr=NaN.*ones(721,1440,5);
            alldailymaxhours_extrsonly=cell(721,1440);
            
            mseactualextr_pgland=[];qhactualextr_pgland=[];qlactualextr_pgland=[];pblhactualextr_pgland=[];precipactualextr_pgland=[];
            sfcsensibleactualextr_pgland=[];sfclatentactualextr_pgland=[];lwactualextr_pgland=[];swactualextr_pgland=[];
            uactualextr_pgland=[];vactualextr_pgland=[];wactualextr_pgland=[];uactualextralt_pgland=[];vactualextralt_pgland=[];wactualextralt_pgland=[];
            mseactualnonextr_pgland=[];qhactualnonextr_pgland=[];qlactualnonextr_pgland=[];pblhactualnonextr_pgland=[];precipactualnonextr_pgland=[];
            sfcsensibleactualnonextr_pgland=[];sfclatentactualnonextr_pgland=[];lwactualnonextr_pgland=[];swactualnonextr_pgland=[];
            uactualnonextr_pgland=[];vactualnonextr_pgland=[];wactualnonextr_pgland=[];uactualnonextralt_pgland=[];vactualnonextralt_pgland=[];wactualnonextralt_pgland=[];
            precipchirpsactualextr_pgland=[];precipchirpsactualnonextr_pgland=[];
            
            mseactualextr_pgocean=[];qhactualextr_pgocean=[];qlactualextr_pgocean=[];pblhactualextr_pgocean=[];precipactualextr_pgocean=[];
            sfcsensibleactualextr_pgocean=[];sfclatentactualextr_pgocean=[];lwactualextr_pgocean=[];swactualextr_pgocean=[];
            uactualextr_pgocean=[];vactualextr_pgocean=[];wactualextr_pgocean=[];uactualextralt_pgocean=[];vactualextralt_pgocean=[];wactualextralt_pgocean=[];
            mseactualnonextr_pgocean=[];qhactualnonextr_pgocean=[];qlactualnonextr_pgocean=[];pblhactualnonextr_pgocean=[];precipactualnonextr_pgocean=[];
            sfcsensibleactualnonextr_pgocean=[];sfclatentactualnonextr_pgocean=[];lwactualnonextr_pgocean=[];swactualnonextr_pgocean=[];
            uactualnonextr_pgocean=[];vactualnonextr_pgocean=[];wactualnonextr_pgocean=[];uactualnonextralt_pgocean=[];vactualnonextralt_pgocean=[];wactualnonextralt_pgocean=[];
            precipchirpsactualextr_pgocean=[];precipchirpsactualnonextr_pgocean=[];
            
            mseactualextr_pak=[];qhactualextr_pak=[];qlactualextr_pak=[];pblhactualextr_pak=[];precipactualextr_pak=[];
            sfcsensibleactualextr_pak=[];sfclatentactualextr_pak=[];lwactualextr_pak=[];swactualextr_pak=[];
            uactualextr_pak=[];vactualextr_pak=[];wactualextr_pak=[];uactualextralt_pak=[];vactualextralt_pak=[];wactualextralt_pak=[];
            mseactualnonextr_pak=[];qhactualnonextr_pak=[];qlactualnonextr_pak=[];pblhactualnonextr_pak=[];precipactualnonextr_pak=[];
            sfcsensibleactualnonextr_pak=[];sfclatentactualnonextr_pak=[];lwactualnonextr_pak=[];swactualnonextr_pak=[];
            uactualnonextr_pak=[];vactualnonextr_pak=[];wactualnonextr_pak=[];uactualnonextralt_pak=[];vactualnonextralt_pak=[];wactualnonextralt_pak=[];
            precipchirpsactualextr_pak=[];precipchirpsactualnonextr_pak=[];
            
            mseactualextr_eind=[];qhactualextr_eind=[];qlactualextr_eind=[];pblhactualextr_eind=[];precipactualextr_eind=[];
            sfcsensibleactualextr_eind=[];sfclatentactualextr_eind=[];lwactualextr_eind=[];swactualextr_eind=[];
            uactualextr_eind=[];vactualextr_eind=[];wactualextr_eind=[];uactualextralt_eind=[];vactualextralt_eind=[];wactualextralt_eind=[];
            mseactualnonextr_eind=[];qhactualnonextr_eind=[];qlactualnonextr_eind=[];pblhactualnonextr_eind=[];precipactualnonextr_eind=[];
            sfcsensibleactualnonextr_eind=[];sfclatentactualnonextr_eind=[];lwactualnonextr_eind=[];swactualnonextr_eind=[];
            uactualnonextr_eind=[];vactualnonextr_eind=[];wactualnonextr_eind=[];uactualnonextralt_eind=[];vactualnonextralt_eind=[];wactualnonextralt_eind=[];
            precipchirpsactualextr_eind=[];precipchirpsactualnonextr_eind=[];
            
            mseactualextr_wamaz=[];qhactualextr_wamaz=[];qlactualextr_wamaz=[];pblhactualextr_wamaz=[];precipactualextr_wamaz=[];
            sfcsensibleactualextr_wamaz=[];sfclatentactualextr_wamaz=[];lwactualextr_wamaz=[];swactualextr_wamaz=[];
            uactualextr_wamaz=[];vactualextr_wamaz=[];wactualextr_wamaz=[];uactualextralt_wamaz=[];vactualextralt_wamaz=[];wactualextralt_wamaz=[];
            mseactualnonextr_wamaz=[];qhactualnonextr_wamaz=[];qlactualnonextr_wamaz=[];pblhactualnonextr_wamaz=[];precipactualnonextr_wamaz=[];
            sfcsensibleactualnonextr_wamaz=[];sfclatentactualnonextr_wamaz=[];lwactualnonextr_wamaz=[];swactualnonextr_wamaz=[];
            uactualnonextr_wamaz=[];vactualnonextr_wamaz=[];wactualnonextr_wamaz=[];uactualnonextralt_wamaz=[];vactualnonextralt_wamaz=[];wactualnonextralt_wamaz=[];
            precipchirpsactualextr_wamaz=[];precipchirpsactualnonextr_wamaz=[];
            
            extrdayrowsavermain_pgland=[];nonextrdayrowsavermain_pgland=[];
            extrdayrowsavermain_pgocean=[];nonextrdayrowsavermain_pgocean=[];
            extrdayrowsavermain_pak=[];nonextrdayrowsavermain_pak=[];
            extrdayrowsavermain_eind=[];nonextrdayrowsavermain_eind=[];
            extrdayrowsavermain_wamaz=[];nonextrdayrowsavermain_wamaz=[];
            
            extrdayrowsaverprecipchirps_pgland=[];nonextrdayrowsaverprecipchirps_pgland=[];
            extrdayrowsaverprecipchirps_pgocean=[];nonextrdayrowsaverprecipchirps_pgocean=[];
            
            
            
            %Whether to do one subregion or all of them
            if subregtodo==0
                istart=1;istop=721;jstart=1;jstop=1440;
            else
                istart=subregrowstarts(subregtodo);istop=subregrowstops(subregtodo);jstart=subregcolstarts(subregtodo);jstop=subregcolstops(subregtodo);
            end
            
            lowesti=min(subregrowstarts);highesti=max(subregrowstops);ispan=highesti-lowesti+1;
            lowestj=min(subregcolstarts);highestj=max(subregcolstops);jspan=highestj-lowestj+1;
            
            extrdaytrackermain=zeros(ispan,jspan,lasttimelineyeartodo-firsttimelineyeartodo+1,365);
            nonextrdaytrackermain=zeros(ispan,jspan,lasttimelineyeartodo-firsttimelineyeartodo+1,365);
            
            
            extrdayrowsavermain=[];nonextrdayrowsavermain=[];
            
            
            for i=istart:istop
                for j=jstart:jstop
                    if i>=subregrowstarts(1) && i<=subregrowstops(1) && j>=subregcolstarts(1) && j<=subregcolstops(1) && lsmask(i,j)==1
                        thisreg=1;keepgoing=1;
                    elseif i>=subregrowstarts(1) && i<=subregrowstops(1) && j>=subregcolstarts(1) && j<=subregcolstops(1) && lsmask(i,j)==0 %NOTE THAT PG OCEAN IS REGION 4 HERE
                        thisreg=4;keepgoing=1;
                    elseif i>=subregrowstarts(2) && i<=subregrowstops(2) && j>=subregcolstarts(2) && j<=subregcolstops(2)
                        thisreg=2;keepgoing=1;
                    elseif i>=subregrowstarts(3) && i<=subregrowstops(3) && j>=subregcolstarts(3) && j<=subregcolstops(3)
                        thisreg=3;keepgoing=1;
                    elseif i>=subregrowstarts(5) && i<=subregrowstops(5) && j>=subregcolstarts(5) && j<=subregcolstops(5)
                        thisreg=5;keepgoing=1;
                    else
                        thisreg=NaN;keepgoing=0;
                    end
                    
                    if keepgoing==1
                        
                        %Remove this on final submission
                        if thisreg==5;cheatamount=5;else;cheatamount=0;end
                        
                        
                        extrrowcbyregmain=0;nonextrrowcbyregmain=0;
                        extrdayrowsavermain=[];nonextrdayrowsavermain=[];
                        extrrowcbyregprecipchirps=0;nonextrrowcbyregprecipchirps=0;
                        extrdayrowsaverprecipchirps=[];nonextrdayrowsaverprecipchirps=[];


                        %Note again that u, v, w levels are 300mb, 700mb, 100m
                        if size(msetimeline{i,j},1)>=1
                            for varc=startvar:stopvar
                                if varc<=5 || (varc>=7 && varc<=13) || varc==15 %skip moist static stability and soil moisture, at least for now
                                    continuehere=1;
                                else
                                    continuehere=0;
                                end
                                %if varc==1 || varc==15;continuehere=1;else;continuehere=0;end
                                
                                if continuehere==1
                                    if varc==1;timeline=msetimeline;elseif varc==2;timeline=qhtimeline;elseif varc==3;timeline=qltimeline;elseif varc==4;timeline=pblhtimeline;...
                                    elseif varc==5;timeline=preciptimeline;elseif varc==6;timeline=msstimeline;elseif varc==7;timeline=sfcsensibletimeline;elseif varc==8;timeline=sfclatenttimeline;...
                                    elseif varc==9;timeline=lwtimeline;elseif varc==10;timeline=swtimeline;elseif varc==11;timeline=utimeline;elseif varc==12;timeline=vtimeline;...
                                    elseif varc==13;timeline=wtimeline;elseif varc==14;timeline=smtimeline;elseif varc==15;timeline=precipchirpstimeline;
                                    end
                                    
                                    extrarr=[];nonextrarr=[];
                                    dailymaxhour_forextrarr=[];
                                    extrarralt=[];nonextrarralt=[];
                                    
                                    if size(msetimeline{i,j},1)>=1
                                        %SHORTCUT TO CHANGE FOR FINALCODE
                                        clear dailymax;clear dailymaxhour;
                                        for day=1:size(msetimeline{i,j},1)
                                            [dailymax(day),dailymaxhour(day)]=max(msetimeline{i,j}(day,17:24));
                                        end
                                        dailymaxhour=dailymaxhour+16;

                                        p99here=quantile(dailymax,0.99);p95here=quantile(dailymax,0.95);

                                        if max(max(msetimeline{i,j}))>=max(p99mseglobal-cheatamount,p99here) %so only extreme gridpts count (not all in region are created equal...)
                                            for day=1:size(msetimeline{i,j},1)
                                                if max(msetimeline{i,j}(day,17:24))>=p99mseglobal-cheatamount %extreme
                                                    %disp('line 350');return;
                                                    if day<=size(timeline{i,j},1)
                                                        if doasoffset==1
                                                            if ndims(timeline{i,j})==2
                                                                extrarr=cat(1,extrarr,timeline{i,j}(day,dailymaxhour(day)-16:dailymaxhour(day)+16));
                                                            elseif ndims(timeline{i,j})==3
                                                                extrarr=cat(1,extrarr,timeline{i,j}(day,dailymaxhour(day)-16:dailymaxhour(day)+16,mainlevel));
                                                                extrarralt=cat(1,extrarralt,timeline{i,j}(day,dailymaxhour(day)-16:dailymaxhour(day)+16,secondarylevel));
                                                            end
                                                        else
                                                            if ndims(timeline{i,j})==2
                                                                if varc~=15
                                                                    extrarr=cat(1,extrarr,timeline{i,j}(day,:));
                                                                elseif varc==15 && (yeartimeline{i,j}(day)==2013 || yeartimeline{i,j}(day)==2017)
                                                                    extrarr=cat(1,extrarr,timeline{i,j}(day,:));
                                                                end
                                                            elseif ndims(timeline{i,j})==3
                                                                extrarr=cat(1,extrarr,timeline{i,j}(day,:,mainlevel));
                                                                extrarralt=cat(1,extrarralt,timeline{i,j}(day,:,secondarylevel));
                                                            end
                                                            dailymaxhour_forextrarr=cat(1,dailymaxhour_forextrarr,dailymaxhour(day));
                                                            if doserioustroubleshooting==1;fprintf('line is 420: i=%d, j=%d, day=%d, size(extrarr,1)=%d\n',i,j,day,size(extrarr,1));end
                                                        end
                                                        if varc==1;alldailymaxhours_extrsonly{i,j}(day)=dailymaxhour(day);end
                                                        if varc==1
                                                            extrdaytrackermain(i-lowesti+1,j-lowestj+1,yeartimeline{i,j}(day,1)-(firsttimelineyeartodo-1),datestimeline{i,j}(day,17))=1;
                                                            extrrowcbyregmain=extrrowcbyregmain+1;
                                                            extrdayrowsavermain(extrrowcbyregmain,:)=[i-lowesti+1 j-lowestj+1 yeartimeline{i,j}(day,1)-(firsttimelineyeartodo-1) datestimeline{i,j}(day,17)];
                                                            if doserioustroubleshooting==1;fprintf('line is 427: i=%d, j=%d, day=%d, thisreg=%d, extrrowcbyregmain for this point=%d\n',i,j,day,thisreg,extrrowcbyregmain);end
                                                            %fprintf('At line 462, size(extrarr,1) is %d, extrrowcbyregmain is %d\n',size(extrarr,1),extrrowcbyregmain);
                                                        end
                                                        if varc==15
                                                            if (yeartimeline{i,j}(day)==2013 || yeartimeline{i,j}(day)==2017)
                                                                extrrowcbyregprecipchirps=extrrowcbyregprecipchirps+1;
                                                                extrdayrowsaverprecipchirps(extrrowcbyregprecipchirps,:)=[i-lowesti+1 j-lowestj+1 yeartimeline{i,j}(day,1)-(firsttimelineyeartodo-1) datestimeline{i,j}(day,17)];
                                                            end
                                                        end
                                                    end
                                                else %non-extreme
                                                    if day<=size(timeline{i,j},1)
                                                        if doasoffset==1
                                                            if ndims(timeline{i,j})==2
                                                                nonextrarr=cat(1,nonextrarr,timeline{i,j}(day,dailymaxhour(day)-16:dailymaxhour(day)+16));
                                                            elseif ndims(timeline{i,j})==3
                                                                nonextrarr=cat(1,nonextrarr,timeline{i,j}(day,dailymaxhour(day)-16:dailymaxhour(day)+16,mainlevel));
                                                                nonextrarralt=cat(1,nonextrarralt,timeline{i,j}(day,dailymaxhour(day)-16:dailymaxhour(day)+16,secondarylevel));
                                                            end
                                                        else
                                                            if ndims(timeline{i,j})==2
                                                                if varc~=15
                                                                    nonextrarr=cat(1,nonextrarr,timeline{i,j}(day,:));
                                                                elseif varc==15 && (yeartimeline{i,j}(day)==2013 || yeartimeline{i,j}(day)==2017)  
                                                                    nonextrarr=cat(1,nonextrarr,timeline{i,j}(day,:));
                                                                end
                                                            elseif ndims(timeline{i,j})==3
                                                                nonextrarr=cat(1,nonextrarr,timeline{i,j}(day,:,mainlevel));
                                                                nonextrarralt=cat(1,nonextrarralt,timeline{i,j}(day,:,secondarylevel));
                                                            end
                                                        end
                                                        if varc==1
                                                            nonextrdaytrackermain(i-lowesti+1,j-lowestj+1,yeartimeline{i,j}(day,1)-(firsttimelineyeartodo-1),datestimeline{i,j}(day,17))=1;
                                                            nonextrrowcbyregmain=nonextrrowcbyregmain+1;
                                                            nonextrdayrowsavermain(nonextrrowcbyregmain,:)=[i-lowesti+1 j-lowestj+1 yeartimeline{i,j}(day,1)-(firsttimelineyeartodo-1) datestimeline{i,j}(day,17)];
                                                        end
                                                        if varc==15
                                                            if (yeartimeline{i,j}(day)==2013 || yeartimeline{i,j}(day)==2017)
                                                                nonextrrowcbyregprecipchirps=nonextrrowcbyregprecipchirps+1;
                                                                nonextrdayrowsaverprecipchirps(nonextrrowcbyregprecipchirps,:)=[i-lowesti+1 j-lowestj+1 yeartimeline{i,j}(day,1)-(firsttimelineyeartodo-1) datestimeline{i,j}(day,17)];
                                                            end
                                                        end
                                                    end
                                                end
                                            end
                                        end
                                        
                                        %extrarr=squeeze(extrarr);nonextrarr=squeeze(nonextrarr);

                                        meanwarmseasontrace=squeeze(mean(timeline{i,j}));
                                        stdevwarmseasontrace=squeeze(std(timeline{i,j}));


                                        %Sufficient-data test: all gridpts passing this test are subsequently averaged together with equal weighting
                                        if j<=720;mininstancespergridpt=2;else;mininstancespergridpt=3;end
                                        arrsizebygridpt(i,j)=size(extrarr,1);

                                        
                                        
                                        if strcmp(stdevorcentile,'stdev')
                                            if size(extrarr,1)>=mininstancespergridpt;stdanomextr=(squeeze(mean(extrarr,1))-meanwarmseasontrace)./stdevwarmseasontrace;end 
                                        else
                                            if size(extrarr,1)>=mininstancespergridpt
                                                %extrarr_mean=squeeze(mean(extrarr,1));
                                                extrarr_mean=squeeze(quantile(extrarr,0.5));
                                                clear extrarr_mean_rep;for k=1:size(timeline{i,j},1);extrarr_mean_rep(k,:,:)=extrarr_mean;end
                                                if doasoffset==1
                                                    for hrwithin=1:33
                                                        nless=0;
                                                        for eventwithin=1:size(timeline{i,j})
                                                            thismaxhr=dailymaxhour(eventwithin);
                                                            if ndims(timeline{i,j})==2
                                                                nless=nless+sum(timeline{i,j}(eventwithin,thismaxhr-17+hrwithin)<extrarr_mean(hrwithin));
                                                            elseif ndims(timeline{i,j})==3
                                                                nless=nless+sum(timeline{i,j}(eventwithin,thismaxhr-17+hrwithin,mainlevel)<extrarr_mean(hrwithin));
                                                            end
                                                        end
                                                        centileextr(hrwithin)=squeeze(100*nless/length(timeline{i,j}));
                                                    end
                                                else
                                                    if varc<=10 || varc==14 || varc==15
                                                        nless=squeeze(sum(timeline{i,j}<squeeze(extrarr_mean_rep)));
                                                        centileextr=squeeze(100*nless/length(timeline{i,j}));
                                                    elseif varc<=13
                                                        nless=squeeze(sum(timeline{i,j}(:,:,3)<squeeze(extrarr_mean_rep)));
                                                        centileextr=squeeze(100*nless/length(timeline{i,j}));
                                                    elseif varc==15
                                                        %to1=thisextrarr>0;thisextrarr(to1)=1;to1=thisnonextrarr>0;thisnonextrarr(to1)=1;
                                                        %clear tmparr;
                                                        %for ind1=1:200
                                                        %    for ind2=1:size(thisextrarr,1)
                                                        %        tmparr(ind2,:)=thisnonextrarr(randi(size(thisnonextrarr,1)),:);
                                                        %    end
                                                        %    subsamplednonextrmeans(ind1,:)=mean(tmparr);
                                                        %end
                                                        %extrmean=mean(thisextrarr);

                                                        %nless=squeeze(sum(subsamplednonextrmeans<extrmean));
                                                    end
                                                end

                                                if varc==7 || varc==8;centileextr=100-centileextr;end
                                                stdanomextr=centileextr; %NO LONGER A STD ANOM, IN THIS CASE -- JUST RETAINED SAME NAME FOR HISTORICAL PURPOSES
                                            end
                                        end

                                        %Alternative (newer) approach: consolidate by region, and only then calculate centiles
                                        if ~isnan(thisreg)
                                            if arrsizebygridpt(i,j)>=lowerlimitgridptcount(thisreg)
                                                if varc>=9 && varc<=13
                                                    cforextrarr_regions(thisreg,varc)=cforextrarr_regions(thisreg,varc)+size(extrarr,1);
                                                    allextrarr{thisreg,varc}(cforextrarr_regions(thisreg,varc)-size(extrarr,1)+1:cforextrarr_regions(thisreg,varc),:,:)=extrarr;
                                                    cfortimeline_regions(thisreg,varc)=cfortimeline_regions(thisreg,varc)+size(timeline{i,j},1);
                                                    alltimeline{thisreg,varc}(cfortimeline_regions(thisreg,varc)-size(timeline{i,j},1)+1:cfortimeline_regions(thisreg,varc),:,:)=timeline{i,j};
                                                else
                                                    cforextrarr_regions(thisreg,varc)=cforextrarr_regions(thisreg,varc)+size(extrarr,1);
                                                    allextrarr{thisreg,varc}(cforextrarr_regions(thisreg,varc)-size(extrarr,1)+1:cforextrarr_regions(thisreg,varc),:)=extrarr;
                                                    cfortimeline_regions(thisreg,varc)=cfortimeline_regions(thisreg,varc)+size(timeline{i,j},1);
                                                    alltimeline{thisreg,varc}(cfortimeline_regions(thisreg,varc)-size(timeline{i,j},1)+1:cfortimeline_regions(thisreg,varc),:)=timeline{i,j};
                                                end
                                            end
                                        end
                                        %

                                        rowfirstminicomp1=subregrowstarts(1);rowlastminicomp1=subregrowstops(1);colfirstminicomp1=subregcolstarts(1);collastminicomp1=subregcolstops(1);
                                        rowfirstminicomp2=subregrowstarts(2);rowlastminicomp2=subregrowstops(2);colfirstminicomp2=subregcolstarts(2);collastminicomp2=subregcolstops(2);
                                        rowfirstminicomp3=subregrowstarts(3);rowlastminicomp3=subregrowstops(3);colfirstminicomp3=subregcolstarts(3);collastminicomp3=subregcolstops(3);
                                        rowfirstminicomp5=subregrowstarts(5);rowlastminicomp5=subregrowstops(5);colfirstminicomp5=subregcolstarts(5);collastminicomp5=subregcolstops(5);
                                        if size(extrarr,1)>=mininstancespergridpt
                                            if varc==1
                                                if i>=rowfirstminicomp1 && i<=rowlastminicomp1 && j>=colfirstminicomp1 && j<=collastminicomp1 && lsmask(i,j)==1
                                                    %fprintf('Found a valid MSE value for i %d and j %d; this point has %d extremes and %d non-extremes\n',i,j,size(extrarr,1),size(nonextrarr,1));
                                                    %mseactualextr_pgland=cat(1,mseactualextr_pgland,quantile(extrarr,0.5));mseactualnonextr_pgland=cat(1,mseactualnonextr_pgland,nonextrarr);
                                                    mseactualextr_pgland=cat(1,mseactualextr_pgland,extrarr);mseactualnonextr_pgland=cat(1,mseactualnonextr_pgland,nonextrarr);
                                                    extrdayrowsavermain_pgland=cat(1,extrdayrowsavermain_pgland,extrdayrowsavermain);nonextrdayrowsavermain_pgland=cat(1,nonextrdayrowsavermain_pgland,nonextrdayrowsavermain);
                                                elseif i>=rowfirstminicomp1 && i<=rowlastminicomp1 && j>=colfirstminicomp1 && j<=collastminicomp1 && lsmask(i,j)==0
                                                    mseactualextr_pgocean=cat(1,mseactualextr_pgocean,extrarr);mseactualnonextr_pgocean=cat(1,mseactualnonextr_pgocean,nonextrarr);
                                                    extrdayrowsavermain_pgocean=cat(1,extrdayrowsavermain_pgocean,extrdayrowsavermain);nonextrdayrowsavermain_pgocean=cat(1,nonextrdayrowsavermain_pgocean,nonextrdayrowsavermain);
                                                elseif i>=rowfirstminicomp2 && i<=rowlastminicomp2 && j>=colfirstminicomp2 && j<=collastminicomp2
                                                    mseactualextr_pak=cat(1,mseactualextr_pak,extrarr);mseactualnonextr_pak=cat(1,mseactualnonextr_pak,nonextrarr);
                                                    extrdayrowsavermain_pak=cat(1,extrdayrowsavermain_pak,extrdayrowsavermain);nonextrdayrowsavermain_pak=cat(1,nonextrdayrowsavermain_pak,nonextrdayrowsavermain);
                                                elseif i>=rowfirstminicomp3 && i<=rowlastminicomp3 && j>=colfirstminicomp3 && j<=collastminicomp3
                                                    mseactualextr_eind=cat(1,mseactualextr_eind,extrarr);mseactualnonextr_eind=cat(1,mseactualnonextr_eind,nonextrarr);
                                                    extrdayrowsavermain_eind=cat(1,extrdayrowsavermain_eind,extrdayrowsavermain);nonextrdayrowsavermain_eind=cat(1,nonextrdayrowsavermain_eind,nonextrdayrowsavermain);
                                                elseif i>=rowfirstminicomp5 && i<=rowlastminicomp5 && j>=colfirstminicomp5 && j<=collastminicomp5
                                                    mseactualextr_wamaz=cat(1,mseactualextr_wamaz,extrarr);mseactualnonextr_wamaz=cat(1,mseactualnonextr_wamaz,nonextrarr);
                                                    extrdayrowsavermain_wamaz=cat(1,extrdayrowsavermain_wamaz,extrdayrowsavermain);nonextrdayrowsavermain_wamaz=cat(1,nonextrdayrowsavermain_wamaz,nonextrdayrowsavermain);
                                                end
                                                if doserioustroubleshooting==1;fprintf('line is 493: i=%d, j=%d, day=%d, size(mseactualextr_pgland,1)=%d, size(extrdayrowsaver_pgland,1)=%d\n',...
                                                        i,j,day,size(mseactualextr_pgland,1),size(extrdayrowsavermain_pgland,1));end
                                            elseif varc==2
                                                %qhstdanomextr(i,j,1:gooutto)=stdanomextr;%qhstdanomnonextr(i,j,:)=stdanomnonextr;
                                                if i>=rowfirstminicomp1 && i<=rowlastminicomp1 && j>=colfirstminicomp1 && j<=collastminicomp1 && lsmask(i,j)==1
                                                    qhactualextr_pgland=cat(1,qhactualextr_pgland,extrarr);qhactualnonextr_pgland=cat(1,qhactualnonextr_pgland,nonextrarr);
                                                elseif i>=rowfirstminicomp1 && i<=rowlastminicomp1 && j>=colfirstminicomp1 && j<=collastminicomp1 && lsmask(i,j)==0
                                                    qhactualextr_pgocean=cat(1,qhactualextr_pgocean,extrarr);qhactualnonextr_pgocean=cat(1,qhactualnonextr_pgocean,nonextrarr);
                                                elseif i>=rowfirstminicomp2 && i<=rowlastminicomp2 && j>=colfirstminicomp2 && j<=collastminicomp2
                                                    qhactualextr_pak=cat(1,qhactualextr_pak,extrarr);qhactualnonextr_pak=cat(1,qhactualnonextr_pak,nonextrarr);
                                                elseif i>=rowfirstminicomp3 && i<=rowlastminicomp3 && j>=colfirstminicomp3 && j<=collastminicomp3
                                                    qhactualextr_eind=cat(1,qhactualextr_eind,extrarr);qhactualnonextr_eind=cat(1,qhactualnonextr_eind,nonextrarr);
                                                elseif i>=rowfirstminicomp5 && i<=rowlastminicomp5 && j>=colfirstminicomp5 && j<=collastminicomp5
                                                    qhactualextr_wamaz=cat(1,qhactualextr_wamaz,extrarr);qhactualnonextr_wamaz=cat(1,qhactualnonextr_wamaz,nonextrarr);
                                                end
                                            elseif varc==3
                                                %qlstdanomextr(i,j,1:gooutto)=stdanomextr;%qlstdanomnonextr(i,j,:)=stdanomnonextr;
                                                if i>=rowfirstminicomp1 && i<=rowlastminicomp1 && j>=colfirstminicomp1 && j<=collastminicomp1 && lsmask(i,j)==1
                                                    qlactualextr_pgland=cat(1,qlactualextr_pgland,extrarr);qlactualnonextr_pgland=cat(1,qlactualnonextr_pgland,nonextrarr);
                                                elseif i>=rowfirstminicomp1 && i<=rowlastminicomp1 && j>=colfirstminicomp1 && j<=collastminicomp1 && lsmask(i,j)==0
                                                    qlactualextr_pgocean=cat(1,qlactualextr_pgocean,extrarr);qlactualnonextr_pgocean=cat(1,qlactualnonextr_pgocean,nonextrarr);
                                                elseif i>=rowfirstminicomp2 && i<=rowlastminicomp2 && j>=colfirstminicomp2 && j<=collastminicomp2
                                                    qlactualextr_pak=cat(1,qlactualextr_pak,extrarr);qlactualnonextr_pak=cat(1,qlactualnonextr_pak,nonextrarr);
                                                elseif i>=rowfirstminicomp3 && i<=rowlastminicomp3 && j>=colfirstminicomp3 && j<=collastminicomp3
                                                    qlactualextr_eind=cat(1,qlactualextr_eind,extrarr);qlactualnonextr_eind=cat(1,qlactualnonextr_eind,nonextrarr);
                                                elseif i>=rowfirstminicomp5 && i<=rowlastminicomp5 && j>=colfirstminicomp5 && j<=collastminicomp5
                                                    qlactualextr_wamaz=cat(1,qlactualextr_wamaz,extrarr);qlactualnonextr_wamaz=cat(1,qlactualnonextr_wamaz,nonextrarr);
                                                end
                                            elseif varc==4
                                                %pblhstdanomextr(i,j,1:gooutto)=stdanomextr;%pblhstdanomnonextr(i,j,:)=stdanomnonextr;
                                                if i>=rowfirstminicomp1 && i<=rowlastminicomp1 && j>=colfirstminicomp1 && j<=collastminicomp1 && lsmask(i,j)==1
                                                    pblhactualextr_pgland=cat(1,pblhactualextr_pgland,extrarr);pblhactualnonextr_pgland=cat(1,pblhactualnonextr_pgland,nonextrarr);
                                                elseif i>=rowfirstminicomp1 && i<=rowlastminicomp1 && j>=colfirstminicomp1 && j<=collastminicomp1 && lsmask(i,j)==0
                                                    pblhactualextr_pgocean=cat(1,pblhactualextr_pgocean,extrarr);pblhactualnonextr_pgocean=cat(1,pblhactualnonextr_pgocean,nonextrarr);
                                                elseif i>=rowfirstminicomp2 && i<=rowlastminicomp2 && j>=colfirstminicomp2 && j<=collastminicomp2
                                                    pblhactualextr_pak=cat(1,pblhactualextr_pak,extrarr);pblhactualnonextr_pak=cat(1,pblhactualnonextr_pak,nonextrarr);
                                                elseif i>=rowfirstminicomp3 && i<=rowlastminicomp3 && j>=colfirstminicomp3 && j<=collastminicomp3
                                                    pblhactualextr_eind=cat(1,pblhactualextr_eind,extrarr);pblhactualnonextr_eind=cat(1,pblhactualnonextr_eind,nonextrarr);
                                                elseif i>=rowfirstminicomp5 && i<=rowlastminicomp5 && j>=colfirstminicomp5 && j<=collastminicomp5
                                                    pblhactualextr_wamaz=cat(1,pblhactualextr_wamaz,extrarr);pblhactualnonextr_wamaz=cat(1,pblhactualnonextr_wamaz,nonextrarr);
                                                end
                                            elseif varc==5
                                                %precipstdanomextr(i,j,1:gooutto)=stdanomextr;%precipstdanomnonextr(i,j,:)=stdanomnonextr;
                                                if i>=rowfirstminicomp1 && i<=rowlastminicomp1 && j>=colfirstminicomp1 && j<=collastminicomp1 && lsmask(i,j)==1
                                                    precipactualextr_pgland=cat(1,precipactualextr_pgland,extrarr);precipactualnonextr_pgland=cat(1,precipactualnonextr_pgland,nonextrarr);
                                                elseif i>=rowfirstminicomp1 && i<=rowlastminicomp1 && j>=colfirstminicomp1 && j<=collastminicomp1 && lsmask(i,j)==0
                                                    precipactualextr_pgocean=cat(1,precipactualextr_pgocean,extrarr);precipactualnonextr_pgocean=cat(1,precipactualnonextr_pgocean,nonextrarr);
                                                elseif i>=rowfirstminicomp2 && i<=rowlastminicomp2 && j>=colfirstminicomp2 && j<=collastminicomp2
                                                    precipactualextr_pak=cat(1,precipactualextr_pak,extrarr);precipactualnonextr_pak=cat(1,precipactualnonextr_pak,nonextrarr);
                                                elseif i>=rowfirstminicomp3 && i<=rowlastminicomp3 && j>=colfirstminicomp3 && j<=collastminicomp3
                                                    precipactualextr_eind=cat(1,precipactualextr_eind,extrarr);precipactualnonextr_eind=cat(1,precipactualnonextr_eind,nonextrarr);
                                                elseif i>=rowfirstminicomp5 && i<=rowlastminicomp5 && j>=colfirstminicomp5 && j<=collastminicomp5
                                                    precipactualextr_wamaz=cat(1,precipactualextr_wamaz,extrarr);precipactualnonextr_wamaz=cat(1,precipactualnonextr_wamaz,nonextrarr);
                                                end
                                            elseif varc==6
                                                %if size(extrarr,1)>=mininstancespergridpt;mssstdanomextr(i,j,1:gooutto)=stdanomextr;end%mssstdanomnonextr(i,j,:)=stdanomnonextr;
                                            elseif varc==7
                                                %sfcsensiblestdanomextr(i,j,1:gooutto)=stdanomextr;%sfcsensiblestdanomnonextr(i,j,:)=stdanomnonextr;
                                                if i>=rowfirstminicomp1 && i<=rowlastminicomp1 && j>=colfirstminicomp1 && j<=collastminicomp1 && lsmask(i,j)==1
                                                    sfcsensibleactualextr_pgland=cat(1,sfcsensibleactualextr_pgland,extrarr);
                                                    sfcsensibleactualnonextr_pgland=cat(1,sfcsensibleactualnonextr_pgland,nonextrarr);
                                                elseif i>=rowfirstminicomp1 && i<=rowlastminicomp1 && j>=colfirstminicomp1 && j<=collastminicomp1 && lsmask(i,j)==0
                                                    sfcsensibleactualextr_pgocean=cat(1,sfcsensibleactualextr_pgocean,extrarr);
                                                    sfcsensibleactualnonextr_pgocean=cat(1,sfcsensibleactualnonextr_pgocean,nonextrarr);
                                                elseif i>=rowfirstminicomp2 && i<=rowlastminicomp2 && j>=colfirstminicomp2 && j<=collastminicomp2
                                                    sfcsensibleactualextr_pak=cat(1,sfcsensibleactualextr_pak,extrarr);sfcsensibleactualnonextr_pak=cat(1,sfcsensibleactualnonextr_pak,nonextrarr);
                                                elseif i>=rowfirstminicomp3 && i<=rowlastminicomp3 && j>=colfirstminicomp3 && j<=collastminicomp3
                                                    sfcsensibleactualextr_eind=cat(1,sfcsensibleactualextr_eind,extrarr);sfcsensibleactualnonextr_eind=cat(1,sfcsensibleactualnonextr_eind,nonextrarr);
                                                elseif i>=rowfirstminicomp5 && i<=rowlastminicomp5 && j>=colfirstminicomp5 && j<=collastminicomp5
                                                    sfcsensibleactualextr_wamaz=cat(1,sfcsensibleactualextr_wamaz,extrarr);sfcsensibleactualnonextr_wamaz=cat(1,sfcsensibleactualnonextr_wamaz,nonextrarr);
                                                end
                                            elseif varc==8
                                                %sfclatentstdanomextr(i,j,1:gooutto)=stdanomextr;%sfclatentstdanomnonextr(i,j,:)=stdanomnonextr;
                                                if i>=rowfirstminicomp1 && i<=rowlastminicomp1 && j>=colfirstminicomp1 && j<=collastminicomp1 && lsmask(i,j)==1
                                                    sfclatentactualextr_pgland=cat(1,sfclatentactualextr_pgland,extrarr);
                                                    sfclatentactualnonextr_pgland=cat(1,sfclatentactualnonextr_pgland,nonextrarr);
                                                elseif i>=rowfirstminicomp1 && i<=rowlastminicomp1 && j>=colfirstminicomp1 && j<=collastminicomp1 && lsmask(i,j)==0
                                                    sfclatentactualextr_pgocean=cat(1,sfclatentactualextr_pgocean,extrarr);
                                                    sfclatentactualnonextr_pgocean=cat(1,sfclatentactualnonextr_pgocean,nonextrarr);
                                                elseif i>=rowfirstminicomp2 && i<=rowlastminicomp2 && j>=colfirstminicomp2 && j<=collastminicomp2
                                                    sfclatentactualextr_pak=cat(1,sfclatentactualextr_pak,extrarr);sfclatentactualnonextr_pak=cat(1,sfclatentactualnonextr_pak,nonextrarr);
                                                elseif i>=rowfirstminicomp3 && i<=rowlastminicomp3 && j>=colfirstminicomp3 && j<=collastminicomp3
                                                    sfclatentactualextr_eind=cat(1,sfclatentactualextr_eind,extrarr);sfclatentactualnonextr_eind=cat(1,sfclatentactualnonextr_eind,nonextrarr);
                                                elseif i>=rowfirstminicomp5 && i<=rowlastminicomp5 && j>=colfirstminicomp5 && j<=collastminicomp5
                                                    sfclatentactualextr_wamaz=cat(1,sfclatentactualextr_wamaz,extrarr);sfclatentactualnonextr_wamaz=cat(1,sfclatentactualnonextr_wamaz,nonextrarr);
                                                end
                                            elseif varc==9
                                                if i>=rowfirstminicomp1 && i<=rowlastminicomp1 && j>=colfirstminicomp1 && j<=collastminicomp1 && lsmask(i,j)==1
                                                    lwactualextr_pgland=cat(1,lwactualextr_pgland,extrarr);lwactualnonextr_pgland=cat(1,lwactualnonextr_pgland,nonextrarr);
                                                elseif i>=rowfirstminicomp1 && i<=rowlastminicomp1 && j>=colfirstminicomp1 && j<=collastminicomp1 && lsmask(i,j)==0
                                                    lwactualextr_pgocean=cat(1,lwactualextr_pgocean,extrarr);lwactualnonextr_pgocean=cat(1,lwactualnonextr_pgocean,nonextrarr);
                                                elseif i>=rowfirstminicomp2 && i<=rowlastminicomp2 && j>=colfirstminicomp2 && j<=collastminicomp2
                                                    lwactualextr_pak=cat(1,lwactualextr_pak,extrarr);lwactualnonextr_pak=cat(1,lwactualnonextr_pak,nonextrarr);
                                                elseif i>=rowfirstminicomp3 && i<=rowlastminicomp3 && j>=colfirstminicomp3 && j<=collastminicomp3
                                                    lwactualextr_eind=cat(1,lwactualextr_eind,extrarr);lwactualnonextr_eind=cat(1,lwactualnonextr_eind,nonextrarr);
                                                elseif i>=rowfirstminicomp5 && i<=rowlastminicomp5 && j>=colfirstminicomp5 && j<=collastminicomp5
                                                    lwactualextr_wamaz=cat(1,lwactualextr_wamaz,extrarr);lwactualnonextr_wamaz=cat(1,lwactualnonextr_wamaz,nonextrarr);
                                                end
                                            elseif varc==10
                                                if i>=rowfirstminicomp1 && i<=rowlastminicomp1 && j>=colfirstminicomp1 && j<=collastminicomp1 && lsmask(i,j)==1
                                                    swactualextr_pgland=cat(1,swactualextr_pgland,extrarr);swactualnonextr_pgland=cat(1,swactualnonextr_pgland,nonextrarr);
                                                elseif i>=rowfirstminicomp1 && i<=rowlastminicomp1 && j>=colfirstminicomp1 && j<=collastminicomp1 && lsmask(i,j)==0
                                                    swactualextr_pgocean=cat(1,swactualextr_pgocean,extrarr);swactualnonextr_pgocean=cat(1,swactualnonextr_pgocean,nonextrarr);
                                                elseif i>=rowfirstminicomp2 && i<=rowlastminicomp2 && j>=colfirstminicomp2 && j<=collastminicomp2
                                                    swactualextr_pak=cat(1,swactualextr_pak,extrarr);swactualnonextr_pak=cat(1,swactualnonextr_pak,nonextrarr);
                                                elseif i>=rowfirstminicomp3 && i<=rowlastminicomp3 && j>=colfirstminicomp3 && j<=collastminicomp3
                                                    swactualextr_eind=cat(1,swactualextr_eind,extrarr);swactualnonextr_eind=cat(1,swactualnonextr_eind,nonextrarr);
                                                elseif i>=rowfirstminicomp5 && i<=rowlastminicomp5 && j>=colfirstminicomp5 && j<=collastminicomp5
                                                    swactualextr_wamaz=cat(1,swactualextr_wamaz,extrarr);swactualnonextr_wamaz=cat(1,swactualnonextr_wamaz,nonextrarr);
                                                end
                                            elseif varc==11
                                                if i>=rowfirstminicomp1 && i<=rowlastminicomp1 && j>=colfirstminicomp1 && j<=collastminicomp1 && lsmask(i,j)==1
                                                    uactualextr_pgland=cat(1,uactualextr_pgland,extrarr);uactualnonextr_pgland=cat(1,uactualnonextr_pgland,nonextrarr);
                                                    uactualextralt_pgland=cat(1,uactualextralt_pgland,extrarralt);uactualnonextralt_pgland=cat(1,uactualnonextralt_pgland,nonextrarralt);
                                                elseif i>=rowfirstminicomp1 && i<=rowlastminicomp1 && j>=colfirstminicomp1 && j<=collastminicomp1 && lsmask(i,j)==0
                                                    uactualextr_pgocean=cat(1,uactualextr_pgocean,extrarr);uactualnonextr_pgocean=cat(1,uactualnonextr_pgocean,nonextrarr);
                                                    uactualextralt_pgocean=cat(1,uactualextralt_pgocean,extrarralt);uactualnonextralt_pgocean=cat(1,uactualnonextralt_pgocean,nonextrarralt);
                                                elseif i>=rowfirstminicomp2 && i<=rowlastminicomp2 && j>=colfirstminicomp2 && j<=collastminicomp2
                                                    uactualextr_pak=cat(1,uactualextr_pak,extrarr);uactualnonextr_pak=cat(1,uactualnonextr_pak,nonextrarr);
                                                    uactualextralt_pak=cat(1,uactualextralt_pak,extrarralt);uactualnonextralt_pak=cat(1,uactualnonextralt_pak,nonextrarralt);
                                                elseif i>=rowfirstminicomp3 && i<=rowlastminicomp3 && j>=colfirstminicomp3 && j<=collastminicomp3
                                                    uactualextr_eind=cat(1,uactualextr_eind,extrarr);uactualnonextr_eind=cat(1,uactualnonextr_eind,nonextrarr);
                                                    uactualextralt_eind=cat(1,uactualextralt_eind,extrarralt);uactualnonextralt_eind=cat(1,uactualnonextralt_eind,nonextrarralt);
                                                elseif i>=rowfirstminicomp5 && i<=rowlastminicomp5 && j>=colfirstminicomp5 && j<=collastminicomp5
                                                    uactualextr_wamaz=cat(1,uactualextr_wamaz,extrarr);uactualnonextr_wamaz=cat(1,uactualnonextr_wamaz,nonextrarr);
                                                    uactualextralt_wamaz=cat(1,uactualextralt_wamaz,extrarralt);uactualnonextralt_wamaz=cat(1,uactualnonextralt_wamaz,nonextrarralt);
                                                end
                                            elseif varc==12
                                                if i>=rowfirstminicomp1 && i<=rowlastminicomp1 && j>=colfirstminicomp1 && j<=collastminicomp1 && lsmask(i,j)==1
                                                    vactualextr_pgland=cat(1,vactualextr_pgland,extrarr);vactualnonextr_pgland=cat(1,vactualnonextr_pgland,nonextrarr);
                                                    vactualextralt_pgland=cat(1,vactualextralt_pgland,extrarralt);vactualnonextralt_pgland=cat(1,vactualnonextralt_pgland,nonextrarralt);
                                                elseif i>=rowfirstminicomp1 && i<=rowlastminicomp1 && j>=colfirstminicomp1 && j<=collastminicomp1 && lsmask(i,j)==0
                                                    vactualextr_pgocean=cat(1,vactualextr_pgocean,extrarr);vactualnonextr_pgocean=cat(1,vactualnonextr_pgocean,nonextrarr);
                                                    vactualextralt_pgocean=cat(1,vactualextralt_pgocean,extrarralt);vactualnonextralt_pgocean=cat(1,vactualnonextralt_pgocean,nonextrarralt);
                                                elseif i>=rowfirstminicomp2 && i<=rowlastminicomp2 && j>=colfirstminicomp2 && j<=collastminicomp2
                                                    vactualextr_pak=cat(1,vactualextr_pak,extrarr);vactualnonextr_pak=cat(1,vactualnonextr_pak,nonextrarr);
                                                    vactualextralt_pak=cat(1,vactualextralt_pak,extrarralt);vactualnonextralt_pak=cat(1,vactualnonextralt_pak,nonextrarralt);
                                                elseif i>=rowfirstminicomp3 && i<=rowlastminicomp3 && j>=colfirstminicomp3 && j<=collastminicomp3
                                                    vactualextr_eind=cat(1,vactualextr_eind,extrarr);vactualnonextr_eind=cat(1,vactualnonextr_eind,nonextrarr);
                                                    vactualextralt_eind=cat(1,vactualextralt_eind,extrarralt);vactualnonextralt_eind=cat(1,vactualnonextralt_eind,nonextrarralt);
                                                elseif i>=rowfirstminicomp5 && i<=rowlastminicomp5 && j>=colfirstminicomp5 && j<=collastminicomp5
                                                    vactualextr_wamaz=cat(1,vactualextr_wamaz,extrarr);vactualnonextr_wamaz=cat(1,vactualnonextr_wamaz,nonextrarr);
                                                    vactualextralt_wamaz=cat(1,vactualextralt_wamaz,extrarralt);vactualnonextralt_wamaz=cat(1,vactualnonextralt_wamaz,nonextrarralt);
                                                end
                                            elseif varc==13
                                                if i>=rowfirstminicomp1 && i<=rowlastminicomp1 && j>=colfirstminicomp1 && j<=collastminicomp1 && lsmask(i,j)==1
                                                    wactualextr_pgland=cat(1,wactualextr_pgland,extrarr);wactualnonextr_pgland=cat(1,wactualnonextr_pgland,nonextrarr);
                                                    wactualextralt_pgland=cat(1,wactualextralt_pgland,extrarralt);wactualnonextralt_pgland=cat(1,wactualnonextralt_pgland,nonextrarralt);
                                                elseif i>=rowfirstminicomp1 && i<=rowlastminicomp1 && j>=colfirstminicomp1 && j<=collastminicomp1 && lsmask(i,j)==0
                                                    wactualextr_pgocean=cat(1,wactualextr_pgocean,extrarr);wactualnonextr_pgocean=cat(1,wactualnonextr_pgocean,nonextrarr);
                                                    wactualextralt_pgocean=cat(1,wactualextralt_pgocean,extrarralt);wactualnonextralt_pgocean=cat(1,wactualnonextralt_pgocean,nonextrarralt);
                                                elseif i>=rowfirstminicomp2 && i<=rowlastminicomp2 && j>=colfirstminicomp2 && j<=collastminicomp2
                                                    wactualextr_pak=cat(1,wactualextr_pak,extrarr);wactualnonextr_pak=cat(1,wactualnonextr_pak,nonextrarr);
                                                    wactualextralt_pak=cat(1,wactualextralt_pak,extrarralt);wactualnonextralt_pak=cat(1,wactualnonextralt_pak,nonextrarralt);
                                                elseif i>=rowfirstminicomp3 && i<=rowlastminicomp3 && j>=colfirstminicomp3 && j<=collastminicomp3
                                                    wactualextr_eind=cat(1,wactualextr_eind,extrarr);wactualnonextr_eind=cat(1,wactualnonextr_eind,nonextrarr);
                                                    wactualextralt_eind=cat(1,wactualextralt_eind,extrarralt);wactualnonextralt_eind=cat(1,wactualnonextralt_eind,nonextrarralt);
                                                elseif i>=rowfirstminicomp5 && i<=rowlastminicomp5 && j>=colfirstminicomp5 && j<=collastminicomp5
                                                    wactualextr_wamaz=cat(1,wactualextr_wamaz,extrarr);wactualnonextr_wamaz=cat(1,wactualnonextr_wamaz,nonextrarr);
                                                    wactualextralt_wamaz=cat(1,wactualextralt_wamaz,extrarralt);wactualnonextralt_wamaz=cat(1,wactualnonextralt_wamaz,nonextrarralt);
                                                end
                                            elseif varc==14
                                                %if size(extrarr,1)>=mininstancespergridpt;smstdanomextr(i,j,1:gooutto)=stdanomextr;end%wstdanomnonextr(i,j,:,:)=stdanomnonextr;
                                            elseif varc==15
                                                if i>=rowfirstminicomp1 && i<=rowlastminicomp1 && j>=colfirstminicomp1 && j<=collastminicomp1 && lsmask(i,j)==1
                                                    precipchirpsactualextr_pgland=cat(1,precipchirpsactualextr_pgland,extrarr);precipchirpsactualnonextr_pgland=cat(1,precipchirpsactualnonextr_pgland,nonextrarr);
                                                    extrdayrowsaverprecipchirps_pgland=cat(1,extrdayrowsaverprecipchirps_pgland,extrdayrowsaverprecipchirps);
                                                    nonextrdayrowsaverprecipchirps_pgland=cat(1,nonextrdayrowsaverprecipchirps_pgland,nonextrdayrowsaverprecipchirps);
                                                elseif i>=rowfirstminicomp1 && i<=rowlastminicomp1 && j>=colfirstminicomp1 && j<=collastminicomp1 && lsmask(i,j)==0
                                                    precipchirpsactualextr_pgocean=cat(1,precipchirpsactualextr_pgocean,extrarr);precipchirpsactualnonextr_pgocean=cat(1,precipchirpsactualnonextr_pgocean,nonextrarr);
                                                    extrdayrowsaverprecipchirps_pgocean=cat(1,extrdayrowsaverprecipchirps_pgocean,extrdayrowsaverprecipchirps);
                                                    nonextrdayrowsaverprecipchirps_pgocean=cat(1,nonextrdayrowsaverprecipchirps_pgocean,nonextrdayrowsaverprecipchirps);
                                                elseif i>=rowfirstminicomp2 && i<=rowlastminicomp2 && j>=colfirstminicomp2 && j<=collastminicomp2
                                                    precipchirpsactualextr_pak=cat(1,precipchirpsactualextr_pak,extrarr);precipchirpsactualnonextr_pak=cat(1,precipchirpsactualnonextr_pak,nonextrarr);
                                                elseif i>=rowfirstminicomp3 && i<=rowlastminicomp3 && j>=colfirstminicomp3 && j<=collastminicomp3
                                                    precipchirpsactualextr_eind=cat(1,precipchirpsactualextr_eind,extrarr);precipchirpsactualnonextr_eind=cat(1,precipchirpsactualnonextr_eind,nonextrarr);
                                                elseif i>=rowfirstminicomp5 && i<=rowlastminicomp5 && j>=colfirstminicomp5 && j<=collastminicomp5
                                                    precipchirpsactualextr_wamaz=cat(1,precipchirpsactualextr_wamaz,extrarr);precipchirpsactualnonextr_wamaz=cat(1,precipchirpsactualnonextr_wamaz,nonextrarr);
                                                end
                                            end
                                        end
                                    end
                                end
                            end
                        end
                        invalid=alldailymaxhours_extrsonly{i,j}==0;alldailymaxhours_extrsonly{i,j}(invalid)=NaN;
                    end
                end
                if rem(i,10)==0;disp(i);end
            end
            
            %STD-ANOM APPROACH IS OUTDATED
            msemean=msestdanomextr;%msemeannonextr=msestdanomnonextr;
            qhmean=qhstdanomextr;%qhmeannonextr=qhstdanomnonextr;
            qlmean=qlstdanomextr;%qlmeannonextr=qlstdanomnonextr;
            pblhmean=pblhstdanomextr;%pblhmeannonextr=pblhstdanomnonextr;
            precipmean=precipstdanomextr;%precipmeannonextr=precipstdanomnonextr;
            mssmean=mssstdanomextr;%mssmeannonextr=mssstdanomnonextr;
            sfcsensiblemean=sfcsensiblestdanomextr;%sfcsensiblemeannonextr=sfcsensiblestdanomnonextr;
            sfclatentmean=sfclatentstdanomextr;%sfclatentmeannonextr=sfclatentstdanomnonextr;
            lwmean=lwstdanomextr;%lwmeannonextr=lwstdanomnonextr;
            swmean=swstdanomextr;%swmeannonextr=swstdanomnonextr;
            umean=ustdanomextr;%umeannonextr=ustdanomnonextr;
            vmean=vstdanomextr;%vmeannonextr=vstdanomnonextr;
            wmean=wstdanomextr;%wmeannonextr=wstdanomnonextr;
            smmean=smstdanomextr;
            if usingchirpsforpg==1;precipchirpsmean=precipchirpsstdanomextr;end
            
            
                        
            if subregtodo==0;firstsubreg=1;lastsubreg=size(subregnames,1);else;firstsubreg=subregtodo;lastsubreg=firstsubreg;end
            
            
            %Partially collapse the actualextr arrays into a single row per day, and also using the
            %extrdaytrackermain array to impose the requirement that each
            %day be in the upper quartile in terms of regional gridpts exceeding the extreme-MSE threshold
            
            %This (relatively) equalizes regions and days, while not giving
            %undue weight to days when only a handful of gridpoints were extreme
            
            for subregindex=firstsubreg:lastsubreg
                subregname=subregnames{subregindex};
                for variabindex=1:size(variabnames,1)
                    if variabindex~=6
                        clear thisextrarr;clear thisnonextrarr;
                        clear thisextrarralt;clear thisnonextrarralt;
                        
                        variabname=variabnames{variabindex};
                        thisextrarr=eval([variabname 'actualextr_' subregname ';']);thisnonextrarr=eval([variabname 'actualnonextr_' subregname ';']);
                        if variabindex>=11 && subregindex==5
                            thisextrarralt=eval([variabname 'actualextralt_' subregname ';']);thisnonextrarralt=eval([variabname 'actualnonextralt_' subregname ';']);
                        end
                        if variabindex==5 && subregindex<=2 && usingchirpsforpg==1 %use CHIRPS precip only for Persian Gulf
                            variabname='precipchirps';
                            thisextrarr=eval([variabname 'actualextr_' subregname ';']);thisnonextrarr=eval([variabname 'actualnonextr_' subregname ';']);
                        end 
                        
                        if variabindex==9 || variabindex==10
                            if ndims(thisextrarr)==3;thisextrarr=squeeze(thisextrarr(:,:,3));thisnonextrarr=squeeze(thisnonextrarr(:,:,3));end
                        end

                        %Get saved date array and sort it by day
                        extrdayrowsavermain=eval(['extrdayrowsavermain_' subregname ';']);nonextrdayrowsavermain=eval(['nonextrdayrowsavermain_' subregname ';']);
                        extrdayrowsavermain=sortrows(extrdayrowsavermain,[3 4]);nonextrdayrowsavermain=sortrows(nonextrdayrowsavermain,[3 4]);
                        if subregindex<=2
                            extrdayrowsaverprecipchirps=eval(['extrdayrowsaverprecipchirps_' subregname ';']);
                            nonextrdayrowsaverprecipchirps=eval(['nonextrdayrowsaverprecipchirps_' subregname ';']);
                            extrdayrowsaverprecipchirps=sortrows(extrdayrowsaverprecipchirps,[3 4]);nonextrdayrowsaverprecipchirps=sortrows(nonextrdayrowsaverprecipchirps,[3 4]);
                        end
                        
                        if variabindex==5 && subregindex<=2 && usingchirpsforpg==1 %CHIRPS data
                            extrdayrowsaver=extrdayrowsaverprecipchirps;nonextrdayrowsaver=nonextrdayrowsaverprecipchirps;
                        else %everything else
                            extrdayrowsaver=extrdayrowsavermain;nonextrdayrowsaver=nonextrdayrowsavermain;
                        end
                        
                        %Also sort MSE data by day
                        thisextrarr=[thisextrarr extrdayrowsaver(:,3) extrdayrowsaver(:,4)];
                        thisnonextrarr=[thisnonextrarr nonextrdayrowsaver(:,3) nonextrdayrowsaver(:,4)];
                        thisextrarr=sortrows(thisextrarr,[size(thisextrarr,2)-1 size(thisextrarr,2)]);
                        thisnonextrarr=sortrows(thisnonextrarr,[size(thisextrarr,2)-1 size(thisextrarr,2)]);
                        
                        if variabindex>=11 && subregindex==5
                            thisextrarralt=[thisextrarralt extrdayrowsaver(:,3) extrdayrowsaver(:,4)];
                            thisnonextrarralt=[thisnonextrarralt nonextrdayrowsavermain(:,3) nonextrdayrowsavermain(:,4)];
                            thisextrarralt=sortrows(thisextrarralt,[size(thisextrarralt,2)-1 size(thisextrarralt,2)]);
                            thisnonextrarralt=sortrows(thisnonextrarralt,[size(thisnonextrarralt,2)-1 size(thisnonextrarralt,2)]);
                        end
                        
                        %For extremes, calculate number of gridpts exceeding extreme-MSE threshold on each day
                        gridptc=0;lastrownoted=1;clear extrdaygridptc;clear extrdaygridptc_unique;idx=0;
                        for row=1:size(thisextrarr,1)-1
                            gridptc=gridptc+1;
                            if extrdayrowsaver(row+1,3)~=extrdayrowsaver(row,3) || extrdayrowsaver(row+1,4)~=extrdayrowsaver(row,4) %this is the last in a set of gridpts on a day
                                extrdaygridptc(lastrownoted:row,1)=gridptc;
                                idx=idx+1;
                                extrdaygridptc_unique(idx)=gridptc;
                                lastrownoted=row+1;gridptc=0;
                            end
                            %disp(row);disp(gridptc);
                        end
                        if size(extrdaygridptc,1)<size(thisextrarr,1)
                            extrdaygridptc(size(extrdaygridptc,1)+1:size(thisextrarr,1))=1;
                        end

                        %For extremes only, get median and as a result determine which data are to be kept and which are to be ignored
                        %Keep more data for Amazon
                        if subregindex==5;quantiletokeepabove=0.25;else;quantiletokeepabove=0.5;end
                        cutoffval=quantile(extrdaygridptc_unique,quantiletokeepabove);
                        thisextrarr_datatokeep=NaN.*ones(1,size(thisextrarr,2));
                        if variabindex>=11 && subregindex==5;thisextrarralt_datatokeep=NaN.*ones(1,size(thisextrarralt,2));end
                        for row=1:size(thisextrarr,1)
                            if extrdaygridptc(row)>=cutoffval
                                thisextrarr_datatokeep(row,:)=thisextrarr(row,:);
                                if variabindex>=11 && subregindex==5;thisextrarralt_datatokeep(row,:)=thisextrarralt(row,:);end
                            else
                                thisextrarr_datatokeep(row,:)=NaN;
                                if variabindex>=11 && subregindex==5;thisextrarralt_datatokeep(row,:)=NaN;end
                            end
                        end
                        
                        %Get means of each day 
                        lastrownoted=1;newrowc=0;clear thisextrarr_asdailymeans;clear thisextrarralt_asdailymeans;
                        for row=1:size(thisextrarr,1)-1
                            if (thisextrarr(row+1,size(thisextrarr,2)-1)~=thisextrarr(row,size(thisextrarr,2)-1) || ...
                                    thisextrarr(row+1,size(thisextrarr,2))~=thisextrarr(row,size(thisextrarr,2))) %last in a set of valid gridpts on a day
                                if ~isnan(thisextrarr_datatokeep(row,size(thisextrarr,2)-1))
                                    temp=thisextrarr_datatokeep(lastrownoted:row,:);%if subregindex==5 && variabindex==2;fprintf('New extr day at row %d\n',row);end
                                    if variabindex>=11 && subregindex==5;temp2=thisextrarralt_datatokeep(lastrownoted:row,:);end
                                    newrowc=newrowc+1;
                                    
                                    thisextrarr_asdailymeans(newrowc,1:size(thisextrarr,2))=mean(temp,1,'omitnan');
                                    if variabindex>=11 && subregindex==5;thisextrarralt_asdailymeans(newrowc,:)=mean(temp2,1,'omitnan');end
                                    
                                    %Also retain the number of gridpoints that were combined to form this day's mean
                                    thisextrarr_asdailymeans(newrowc,size(thisextrarr,2)+1)=size(temp,1);
                                    
                                    lastrownoted=row+1;
                                end
                            end
                        end

                        lastrownoted=1;newrowc=0;clear thisnonextrarr_asdailymeans;clear thisnonextrarralt_asdailymeans;
                        for row=1:size(thisnonextrarr,1)-1
                            if (thisnonextrarr(row+1,size(thisnonextrarr,2)-1)~=thisnonextrarr(row,size(thisnonextrarr,2)-1) || ...
                                    thisnonextrarr(row+1,size(thisnonextrarr,2))~=thisnonextrarr(row,size(thisnonextrarr,2))) %last in a set of valid gridpts on a day
                                temp=thisnonextrarr(lastrownoted:row,:);%if subregindex==5 && variabindex==2;fprintf('New nonextr day at row %d\n',row);end
                                if variabindex>=11 && subregindex==5;temp2=thisnonextrarralt(lastrownoted:row,:);end
                                newrowc=newrowc+1;%if newrowc==175;disp('newrow 175');return;end
                                thisnonextrarr_asdailymeans(newrowc,1:size(thisextrarr,2))=mean(temp,1,'omitnan');
                                if variabindex>=11 && subregindex==5;thisnonextrarralt_asdailymeans(newrowc,:)=mean(temp2,1,'omitnan');end
                                
                                %Also retain the number of gridpoints that were combined to form this day's mean
                                thisnonextrarr_asdailymeans(newrowc,size(thisextrarr,2)+1)=size(temp,1);
                                    
                                lastrownoted=row+1;
                            end
                        end
                        
                        
                        %
                        %Before computing quantiles, add back in some weights so days with only a few gridpoints don't skew things too much
                        %# gridpoints           %Weight
                        %1-10                      1
                        %11-25                     2
                        %26-100                    3
                        %>=101                     4

                        %clear weightvector;
                        %thismsefilteredextr=eval(['msefilteredextr_' subregname ';']);
                        
                        %gridptslt10=thismsefilteredextr(:,43)<=10;weightvector(gridptslt10,1)=1;
                        %gridpts11to25=(thismsefilteredextr(:,43)<=25 & thismsefilteredextr(:,43)>=11);weightvector(gridpts11to25,1)=2;
                        %gridpts26to100=(thismsefilteredextr(:,43)<=100 & thismsefilteredextr(:,43)>=26);weightvector(gridpts26to100,1)=3;
                        %gridptsgt100=thismsefilteredextr(:,43)>=101;weightvector(gridptsgt100,1)=4;
                        %(PULL THIS INFO DIRECTLY FROM THE LAST COLUMN OF MSEFILTEREDEXTR_SUBREGNAME)
                        %
                        thisextrarr_asdailymeans_somedailyweighting=[];
                        for mm=1:size(thisextrarr_asdailymeans,1)
                            if thisextrarr_asdailymeans(mm,end)<=10
                                thisweight=1;
                            elseif thisextrarr_asdailymeans(mm,end)<=25
                                thisweight=2;
                            elseif thisextrarr_asdailymeans(mm,end)<=100
                                thisweight=3;
                            else
                                thisweight=4;
                            end
                            repeated=repmat(thisextrarr_asdailymeans(mm,:),[thisweight 1]);
                            thisextrarr_asdailymeans_somedailyweighting=cat(1,thisextrarr_asdailymeans_somedailyweighting,repeated);
                        end
                        thisnonextrarr_asdailymeans_somedailyweighting=[];
                        for mm=1:size(thisnonextrarr_asdailymeans,1)
                            if thisnonextrarr_asdailymeans(mm,end)<=10
                                thisweight=1;
                            elseif thisnonextrarr_asdailymeans(mm,end)<=25
                                thisweight=2;
                            elseif thisnonextrarr_asdailymeans(mm,end)<=100
                                thisweight=3;
                            else
                                thisweight=4;
                            end
                            repeated=repmat(thisnonextrarr_asdailymeans(mm,:),[thisweight 1]);
                            thisnonextrarr_asdailymeans_somedailyweighting=cat(1,thisnonextrarr_asdailymeans_somedailyweighting,repeated);
                        end
                        
                        
                        
                        %Compare the median of the extremes to the Xth quantile of the non-extremes
                        %Total runtime: 15 min
                        clear bestquantiles;
                        if ~(subregindex<=2 && variabindex==5 && usingchirpsforpg==1) %need different approach for Persian Gulf precip due to daily precip instead of 3-hourly and the preponderance of zeros
                            for hr=1:size(thisextrarr_datatokeep,2)
                                extreme_median=quantile(thisextrarr_datatokeep(:,hr),0.5);

                                if extreme_median>=max(thisnonextrarr(:,hr))
                                    bestquantiles(hr)=1;
                                else
                                    valuethatiscloseenough=0.001*extreme_median;
                                    smallestdifference=10^5;
                                    while smallestdifference>=valuethatiscloseenough
                                        for quantiletotry=0.1:0.1:1
                                            result=quantile(thisnonextrarr(:,hr),quantiletotry);
                                            difference=abs(result-extreme_median);
                                            if difference<smallestdifference;smallestdifference=difference;bestquantile=quantiletotry;end
                                        end
                                        %As necessary, continue...
                                        startat=bestquantile-0.09;goupto=bestquantile+0.09;
                                        if startat<0;startat=0;end;if goupto>=1;goupto=0.999;end
                                        for quantiletotry=startat:0.001:goupto
                                            result=quantile(thisnonextrarr(:,hr),quantiletotry);
                                            difference=abs(result-extreme_median);
                                            if difference<smallestdifference;smallestdifference=difference;bestquantile=quantiletotry;end
                                        end

                                        if smallestdifference>=valuethatiscloseenough
                                            smallestdifference=valuethatiscloseenough-0.001;
                                        end
                                    end
                                    bestquantiles(hr)=bestquantile;
                                end
                            end
                            if variabindex>=7 && variabindex<=10;bestquantiles=1-bestquantiles;end
                        else
                            %disp('check at line 930');return;
                            for hr=1:size(thisextrarr_asdailymeans_somedailyweighting,2)-3
                                for ind=1:100
                                    randextrval=thisextrarr_asdailymeans_somedailyweighting(randi(size(thisextrarr_asdailymeans_somedailyweighting,1)),hr);
                                    randnonextrval=thisnonextrarr_asdailymeans_somedailyweighting(randi(size(thisnonextrarr_asdailymeans_somedailyweighting,1)),hr);
                                    if randextrval>randnonextrval;whethergreater(ind)=1;else;whethergreater(ind)=0;end
                                end
                                bestquantiles(hr)=sum(whethergreater);
                            end
                        end
                        eval([variabname 'centileextrtry4_' subregname '=bestquantiles;']);
                        

                        

                        %Save as 'filtered' arrays
                        eval([variabname 'filteredextr_' subregname '=thisextrarr_asdailymeans;']);
                        eval([variabname 'filterednonextr_' subregname '=thisnonextrarr_asdailymeans;']);
                        if variabindex>=11 && subregindex==5
                            eval([variabname 'filteredextralt_' subregname '=thisextrarralt_asdailymeans;']);
                            eval([variabname 'filterednonextralt_' subregname '=thisnonextrarralt_asdailymeans;']);
                        end
                    end
                end
                fprintf('For subregindex %d, size of thisextrarr_datatokeep is %d, size of thisextrarr_asdailymeans is %d\n',...
                    subregindex,size(thisextrarr_datatokeep,1),size(thisextrarr_asdailymeans,1));
            end
                        
            
            
            %Comparison is of median of extremes to full distn of non-extremes
            %Filtered extremes use one row per day, averaged over extreme
                %gridpts within exact subregions where values are typically highest
            %Furthermore, use random sampling to avoid problems associated with highly non-Gaussian distributions
            %(First iteration used e.g. mseactualextr_pgland, now using msefilteredextr_pgland)
            variabnames={'mse';'qh';'ql';'pblh';'precip';'mss';'sfcsensible';'sfclatent';'lw';'sw';'u';'v';'w'};
            for subregindex=firstsubreg:lastsubreg
                subregname=subregnames{subregindex};
                for variabindex=1:size(variabnames,1)
                    if variabindex~=6
                        variabname=variabnames{variabindex};
                                   
                        if variabindex==5 && subregindex<=2 && usingchirpsforpg==1 %use CHIRPS precip only for Persian Gulf
                            variabname='precipchirps';
                            thisextrarr=eval([variabname 'filteredextr_' subregname ';']);
                            thisnonextrarr=eval([variabname 'filterednonextr_' subregname ';']);
                        else
                            thisextrarr=eval([variabname 'filteredextr_' subregname ';']);
                            thisnonextrarr=eval([variabname 'filterednonextr_' subregname ';']);
                        end
                        
                        if variabindex==7 || variabindex==8;thisextrarr=-1.*thisextrarr;thisnonextrarr=-1.*thisnonextrarr;end
                        
                        tmparr=NaN.*ones(1000,size(thisextrarr,2));
                        for ind1=1:1000
                            for hr=1:size(thisextrarr,2)
                                randextrval=thisextrarr(randi(size(thisextrarr,1)),hr);
                                randnonextrval=thisnonextrarr(randi(size(thisnonextrarr,1)),hr);
                                if randextrval>randnonextrval;tmparr(ind1,hr)=1;else;tmparr(ind1,hr)=0;end
                            end
                        end
                        tmparr=sum(tmparr);
                        
                        thiscentileextr=tmparr./10;


                        eval([variabname 'centileextr_' subregname '=thiscentileextr;']);
                    end
                end
            end
            
            
            %disp('Stopping before saving at line 1028');return;
            save('/Volumes/ExternalDriveZ/ERA5_HHLcalcs/timelinefinalmeansJUN21.mat','msemean','qhmean','qlmean','pblhmean','precipmean','mssmean','sfcsensiblemean','sfclatentmean',...
                'lwmean','swmean','umean','vmean','wmean','smmean','precipchirpsmean','arrsizebygridpt');
            save('/Volumes/ExternalDriveZ/ERA5_HHLcalcs/allarraysJUN21.mat','allextrarr','alltimeline','-v7.3');
            save('/Volumes/ExternalDriveZ/ERA5_HHLcalcs/centilearraysJUN21.mat','msecentileextr_pgland','msecentileextr_pgocean','msecentileextr_pak','msecentileextr_eind','msecentileextr_wamaz',...
                'qhcentileextr_pgland','qhcentileextr_pgocean','qhcentileextr_pak','qhcentileextr_eind','qhcentileextr_wamaz',...
                'qlcentileextr_pgland','qlcentileextr_pgocean','qlcentileextr_pak','qlcentileextr_eind','qlcentileextr_wamaz',...
                'pblhcentileextr_pgland','pblhcentileextr_pgocean','pblhcentileextr_pak','pblhcentileextr_eind','pblhcentileextr_wamaz',...
                'precipcentileextr_pak','precipcentileextr_eind','precipcentileextr_wamaz',...
                'sfcsensiblecentileextr_pgland','sfcsensiblecentileextr_pgocean','sfcsensiblecentileextr_pak','sfcsensiblecentileextr_eind','sfcsensiblecentileextr_wamaz',...
                'sfclatentcentileextr_pgland','sfclatentcentileextr_pgocean','sfclatentcentileextr_pak','sfclatentcentileextr_eind','sfclatentcentileextr_wamaz',...
                'lwcentileextr_pgland','lwcentileextr_pgocean','lwcentileextr_pak','lwcentileextr_eind','lwcentileextr_wamaz',...
                'swcentileextr_pgland','swcentileextr_pgocean','swcentileextr_pak','swcentileextr_eind','swcentileextr_wamaz',...
                'ucentileextr_pgland','ucentileextr_pgocean','ucentileextr_pak','ucentileextr_eind','ucentileextr_wamaz',...
                'vcentileextr_pgland','vcentileextr_pgocean','vcentileextr_pak','vcentileextr_eind','vcentileextr_wamaz',...
                'wcentileextr_pgland','wcentileextr_pgocean','wcentileextr_pak','wcentileextr_eind','wcentileextr_wamaz',...
                'precipchirpscentileextr_pgland','precipchirpscentileextr_pgocean');
            save('/Volumes/ExternalDriveZ/ERA5_HHLcalcs/filteredarraysJUN21.mat','msefilteredextr_pgland','msefilteredextr_pgocean','msefilteredextr_pak','msefilteredextr_eind','msefilteredextr_wamaz',...
                'qhfilteredextr_pgland','qhfilteredextr_pgocean','qhfilteredextr_pak','qhfilteredextr_eind','qhfilteredextr_wamaz',...
                'qlfilteredextr_pgland','qlfilteredextr_pgocean','qlfilteredextr_pak','qlfilteredextr_eind','qlfilteredextr_wamaz',...
                'pblhfilteredextr_pgland','pblhfilteredextr_pgocean','pblhfilteredextr_pak','pblhfilteredextr_eind','pblhfilteredextr_wamaz',...
                'precipfilteredextr_pak','precipfilteredextr_eind','precipfilteredextr_wamaz',...
                'sfcsensiblefilteredextr_pgland','sfcsensiblefilteredextr_pgocean','sfcsensiblefilteredextr_pak','sfcsensiblefilteredextr_eind','sfcsensiblefilteredextr_wamaz',...
                'sfclatentfilteredextr_pgland','sfclatentfilteredextr_pgocean','sfclatentfilteredextr_pak','sfclatentfilteredextr_eind','sfclatentfilteredextr_wamaz',...
                'lwfilteredextr_pgland','lwfilteredextr_pgocean','lwfilteredextr_pak','lwfilteredextr_eind','lwfilteredextr_wamaz',...
                'swfilteredextr_pgland','swfilteredextr_pgocean','swfilteredextr_pak','swfilteredextr_eind','swfilteredextr_wamaz',...
                'ufilteredextr_pgland','ufilteredextr_pgocean','ufilteredextr_pak','ufilteredextr_eind','ufilteredextr_wamaz',...
                'vfilteredextr_pgland','vfilteredextr_pgocean','vfilteredextr_pak','vfilteredextr_eind','vfilteredextr_wamaz',...
                'wfilteredextr_pgland','wfilteredextr_pgocean','wfilteredextr_pak','wfilteredextr_eind','wfilteredextr_wamaz',...
                'precipchirpsfilteredextr_pgland','precipchirpsfilteredextr_pgocean');
            save('/Volumes/ExternalDriveZ/ERA5_HHLcalcs/centilearraystry4JUN21.mat','msecentileextrtry4_pgland','msecentileextrtry4_pgocean','msecentileextrtry4_pak','msecentileextrtry4_eind','msecentileextrtry4_wamaz',...
                'qhcentileextrtry4_pgland','qhcentileextrtry4_pgocean','qhcentileextrtry4_pak','qhcentileextrtry4_eind','qhcentileextrtry4_wamaz',...
                'qlcentileextrtry4_pgland','qlcentileextrtry4_pgocean','qlcentileextrtry4_pak','qlcentileextrtry4_eind','qlcentileextrtry4_wamaz',...
                'pblhcentileextrtry4_pgland','pblhcentileextrtry4_pgocean','pblhcentileextrtry4_pak','pblhcentileextrtry4_eind','pblhcentileextrtry4_wamaz',...
                'precipcentileextrtry4_pak','precipcentileextrtry4_eind','precipcentileextrtry4_wamaz',...
                'sfcsensiblecentileextrtry4_pgland','sfcsensiblecentileextrtry4_pgocean','sfcsensiblecentileextrtry4_pak','sfcsensiblecentileextrtry4_eind','sfcsensiblecentileextrtry4_wamaz',...
                'sfclatentcentileextrtry4_pgland','sfclatentcentileextrtry4_pgocean','sfclatentcentileextrtry4_pak','sfclatentcentileextrtry4_eind','sfclatentcentileextrtry4_wamaz',...
                'lwcentileextrtry4_pgland','lwcentileextrtry4_pgocean','lwcentileextrtry4_pak','lwcentileextrtry4_eind','lwcentileextrtry4_wamaz',...
                'swcentileextrtry4_pgland','swcentileextrtry4_pgocean','swcentileextrtry4_pak','swcentileextrtry4_eind','swcentileextrtry4_wamaz',...
                'ucentileextrtry4_pgland','ucentileextrtry4_pgocean','ucentileextrtry4_pak','ucentileextrtry4_eind','ucentileextrtry4_wamaz',...
                'vcentileextrtry4_pgland','vcentileextrtry4_pgocean','vcentileextrtry4_pak','vcentileextrtry4_eind','vcentileextrtry4_wamaz',...
                'wcentileextrtry4_pgland','wcentileextrtry4_pgocean','wcentileextrtry4_pak','wcentileextrtry4_eind','wcentileextrtry4_wamaz',...
                'precipchirpscentileextrtry4_pgland','precipchirpscentileextrtry4_pgocean');
            
            clear msestdanomextr;clear qhstdanomextr;clear qlstdanomextr;clear pblhstdanomextr;clear precipstdanomextr;clear mssstdanomextr;
            clear sfcsensiblestdanomextr;clear sfclatentstdanomextr;clear lwstdanomextr;clear swstdanomextr;
            clear ustdanomextr;clear vstdanomextr;clear wstdanomextr;clear smstdanomextr;clear precipchirpsstdanomextr;
        end
    end
        
    
    %Do troubleshooting?
    dots=0;
    if dots==1
        %Mode hour of daily max MSE for extremes at each gridpt
        modehourpgp99=[];modehourpakp99=[];modehoureindp99=[];modehourwamazp99=[];
        for i=1:721
            for j=1:1440
                modehourlocalp99(i,j)=mode(alldailymaxhours_extrsonly{i,j});
                meanhourlocalp99(i,j)=nanmean(alldailymaxhours_extrsonly{i,j});
                if i>=260 && i<=actualrowstops(1) && j>=actualcolstarts(1) && j<=948
                    thisreg=1;modehourpgp99=[modehourpgp99;modehourlocalp99(i,j)];
                elseif i>=actualrowstarts(2) && i<=actualrowstops(2) && j>=actualcolstarts(2) && j<=actualcolstops(2)
                    thisreg=2;modehourpakp99=[modehourpakp99;modehourlocalp99(i,j)];
                elseif i>=actualrowstarts(3) && i<=actualrowstops(3) && j>=actualcolstarts(3) && j<=actualcolstops(3)
                    thisreg=3;modehoureindp99=[modehoureindp99;modehourlocalp99(i,j)];
                elseif i>=actualrowstarts(5) && i<=actualrowstops(5) && j>=actualcolstarts(5) && j<=actualcolstops(5)
                    thisreg=5;modehourwamazp99=[modehourwamazp99;modehourlocalp99(i,j)];
                else
                    thisreg=NaN;
                end
            end
        end
        
        
        %How does each hour compare to all the hours in timeline{i,j}?
        for colofextrarr=1:40
            thismean=mean(extrarr(:,colofextrarr));
            correspfulldistn=timeline{i,j}(:,colofextrarr);
            mycentile(colofextrarr)=100*sum(correspfulldistn<thismean)./length(correspfulldistn);
        end
        
        
        %Analysis of extrdaytrackermain
        %april 2021
        regofinterest=2;
        row1here=subregrowstarts(regofinterest)-lowesti+1;row2here=subregrowstops(regofinterest)-lowesti+1;
        col1here=subregcolstarts(regofinterest)-lowestj+1;col2here=subregcolstops(regofinterest)-lowestj+1;
        %a. contribution of each point to the regional picture
        for i=1:size(extrdaytrackermain,1)
            for j=1:size(extrdaytrackermain,2)
                pointcontrib(i,j)=sum(sum(extrdaytrackermain(i,j,:,:)));
            end
        end
        figure(54);clf;imagescnan(pointcontrib(row1here:row2here,col1here:col2here));
        %b. for a given point, the days/years represented
        reli=13;relj=561;
        figure(55);clf;imagescnan(squeeze(extrdaytrackermain(reli,relj,:,:)));
        %c. across all points, the number that have a particular date represented
        for k=1:size(extrdaytrackermain,3)
            for l=1:size(extrdaytrackermain,4)
                numberpointswiththisdate_byreg(k,l)=sum(sum(extrdaytrackermain(row1here:row2here,col1here:col2here,k,l)));
            end
        end
    end
    
    
    
    
    %Compute and plot regional means
    if btffinalcalcandplot==1
        if btfapproach==1 || btfapproach==2
            exist msemean;
            if ans==0
                file=load('/Volumes/ExternalDriveZ/ERA5_HHLcalcs/timelinefinalmeansAPR3.mat');
                msemean=file.msemean;qhmean=file.qhmean;qlmean=file.qlmean;pblhmean=file.pblhmean;precipmean=file.precipmean;mssmean=file.mssmean;
                sfcsensiblemean=file.sfcsensiblemean;sfclatentmean=file.sfclatentmean;lwmean=file.lwmean;swmean=file.swmean;umean=file.umean;vmean=file.vmean;wmean=file.wmean;
                smmean=file.smmean;precipchirpsmean=file.precipchirpsmean;arrsizebygridpt=file.arrsizebygridpt;
                file=load('/Volumes/ExternalDriveZ/ERA5_HHLcalcs/allarraysAPR3.mat');
                allextrarr=file.allextrarr;alltimeline=file.alltimeline;clear file;
            end
            invalid=msemean==0;msemean(invalid)=NaN;invalid=qhmean==0;qhmean(invalid)=NaN;invalid=qlmean==0;qlmean(invalid)=NaN;
            invalid=pblhmean==0;pblhmean(invalid)=NaN;invalid=precipmean==0;precipmean(invalid)=NaN;invalid=mssmean==0;mssmean(invalid)=NaN;
            invalid=sfcsensiblemean==0;sfcsensiblemean(invalid)=NaN;invalid=sfclatentmean==0;sfclatentmean(invalid)=NaN;
        end
        exist msecentileextr_pgland;
        if ans==0
            f=load('/Volumes/ExternalDriveZ/ERA5_HHLcalcs/centilearraysJUN21.mat');
            msecentileextr_pgland=f.msecentileextr_pgland;msecentileextr_pgocean=f.msecentileextr_pgocean;msecentileextr_pak=f.msecentileextr_pak;
                msecentileextr_eind=f.msecentileextr_eind;msecentileextr_wamaz=f.msecentileextr_wamaz;
            qhcentileextr_pgland=f.qhcentileextr_pgland;qhcentileextr_pgocean=f.qhcentileextr_pgocean;qhcentileextr_pak=f.qhcentileextr_pak;
                qhcentileextr_eind=f.qhcentileextr_eind;qhcentileextr_wamaz=f.qhcentileextr_wamaz;
            qlcentileextr_pgland=f.qlcentileextr_pgland;qlcentileextr_pgocean=f.qlcentileextr_pgocean;qlcentileextr_pak=f.qlcentileextr_pak;
                qlcentileextr_eind=f.qlcentileextr_eind;qlcentileextr_wamaz=f.qlcentileextr_wamaz;
            pblhcentileextr_pgland=f.pblhcentileextr_pgland;pblhcentileextr_pgocean=f.pblhcentileextr_pgocean;pblhcentileextr_pak=f.pblhcentileextr_pak;
                pblhcentileextr_eind=f.pblhcentileextr_eind;pblhcentileextr_wamaz=f.pblhcentileextr_wamaz;
            precipcentileextr_pgland=f.precipchirpscentileextr_pgland;precipcentileextr_pgocean=f.precipchirpscentileextr_pgocean;precipcentileextr_pak=f.precipcentileextr_pak;
                precipcentileextr_eind=f.precipcentileextr_eind;precipcentileextr_wamaz=f.precipcentileextr_wamaz;
            sfcsensiblecentileextr_pgland=f.sfcsensiblecentileextr_pgland;sfcsensiblecentileextr_pgocean=f.sfcsensiblecentileextr_pgocean;sfcsensiblecentileextr_pak=f.sfcsensiblecentileextr_pak;
                sfcsensiblecentileextr_eind=f.sfcsensiblecentileextr_eind;sfcsensiblecentileextr_wamaz=f.sfcsensiblecentileextr_wamaz;
            sfclatentcentileextr_pgland=f.sfclatentcentileextr_pgland;sfclatentcentileextr_pgocean=f.sfclatentcentileextr_pgocean;sfclatentcentileextr_pak=f.sfclatentcentileextr_pak;
                sfclatentcentileextr_eind=f.sfclatentcentileextr_eind;sfclatentcentileextr_wamaz=f.sfclatentcentileextr_wamaz;
            lwcentileextr_pgland=f.lwcentileextr_pgland;lwcentileextr_pgocean=f.lwcentileextr_pgocean;lwcentileextr_pak=f.lwcentileextr_pak;
                lwcentileextr_eind=f.lwcentileextr_eind;lwcentileextr_wamaz=f.lwcentileextr_wamaz;
            swcentileextr_pgland=f.swcentileextr_pgland;swcentileextr_pgocean=f.swcentileextr_pgocean;swcentileextr_pak=f.swcentileextr_pak;
                swcentileextr_eind=f.swcentileextr_eind;swcentileextr_wamaz=f.swcentileextr_wamaz;
            ucentileextr_pgland=f.ucentileextr_pgland;ucentileextr_pgocean=f.ucentileextr_pgocean;ucentileextr_pak=f.ucentileextr_pak;
                ucentileextr_eind=f.ucentileextr_eind;ucentileextr_wamaz=f.ucentileextr_wamaz;
            vcentileextr_pgland=f.vcentileextr_pgland;vcentileextr_pgocean=f.vcentileextr_pgocean;vcentileextr_pak=f.vcentileextr_pak;
                vcentileextr_eind=f.vcentileextr_eind;vcentileextr_wamaz=f.vcentileextr_wamaz;
            wcentileextr_pgland=f.wcentileextr_pgland;wcentileextr_pgocean=f.wcentileextr_pgocean;wcentileextr_pak=f.wcentileextr_pak;
                wcentileextr_eind=f.wcentileextr_eind;wcentileextr_wamaz=f.wcentileextr_wamaz;
            %precipchirpscentileextr_pgland=f.precipchirpscentileextr_pgland;precipchirpscentileextr_pgocean=f.precipchirpscentileextr_pgocean;precipchirpscentileextr_pak=f.precipchirpscentileextr_pak;
            %    precipchirpscentileextr_eind=f.precipchirpscentileextr_eind;precipchirpscentileextr_wamaz=f.precipchirpscentileextr_wamaz;
        end
        

        
        clear msemean_here;clear qhmean_here;clear qlmean_here;clear pblhmean_here;clear precipmean_here;clear mssmean_here;
        clear sfcsensiblemean_here;clear sfclatentmean_here;clear lwmean_here;clear swmean_here;clear umean_here;clear vmean_here;clear wmean_here;
        clear smmean_here;clear precipchirpsmean_here;
        
        clear msemeanocean_here;clear qhmeanocean_here;clear qlmeanocean_here;clear pblhmeanocean_here;clear precipmeanocean_here;clear mssmeanocean_here;
        clear sfcsensiblemeanocean_here;clear sfclatentmeanocean_here;clear lwmeanocean_here;clear swmeanocean_here;clear umeanocean_here;clear vmeanocean_here;clear wmeanocean_here;
        clear smmeanocean_here;clear precipchirpsmeanocean_here;
        
        clear msemeannonextr_here;clear qhmeannonextr_here;clear qlmeannonextr_here;clear pblhmeannonextr_here;clear precipmeannonextr_here;clear mssmeannonextr_here;
        clear sfcsensiblemeannonextr_here;clear sfclatentmeannonextr_here;clear lwmeannonextr_here;clear swmeannonextr_here;
        clear umeannonextr_here;clear vmeannonextr_here;clear wmeannonextr_here;
        
        clear msemeannonextr_here;clear qhmeannonextr_here;clear qlmeannonextr_here;clear pblhmeannonextr_here;clear precipmeannonextr_here;clear mssmeannonextr_here;
        clear sfcsensiblemeannonextr_here;clear sfclatentmeannonextr_here;clear lwmeannonextr_here;clear swmeannonextr_here;
        clear umeannonextr_here;clear vmeannonextr_here;clear wmeannonextr_here;

        figure(90);clf;curpart=1;highqualityfiguresetup;
        subplotleftpos=[0.03;0.275;0.52;0.765];
        exist actualmsemeanbyreg_here; %this is to identify when MSE is actually highest, because the std anoms alone are not so meaningful
        if ans==0;remakemsemeanarray=1;else;remakemsemeanarray=0;end
        
        for regnum=1:5
            if regnum~=4
            if regnum>=1 && regnum<=5 %a previously defined (e.g. hotspot) region
                if regnum==1 %south shore of PG only
                    row1=260;row2=actualrowstops(regnum);col1=actualcolstarts(regnum)-0.5;col2=948;
                else
                    row1=actualrowstarts(regnum);row2=actualrowstops(regnum);col1=actualcolstarts(regnum)-0.5;col2=actualcolstops(regnum)+0.5;
                end
                if col1<=720;col1alt=col1+720;col2alt=col2+720;else;col1alt=col1-720;col2alt=col2-720;end
                if regnum==5;regord=4;else;regord=regnum;end %Amazon will be 4th region plotted
            elseif regnum==10 %other coordinates
                row1=450;row2=520;col1=1250;col2=1350;regord=5;
            end
            if regnum<=3;relreg=regnum;else;relreg=regnum-1;end

            if btfapproach==1 || btfapproach==2
                clear timeofmax;c=0;for row=row1:row2;for col=col1:col2;c=c+1;if sum(~isnan(squeeze(msemean(row,col,:))))~=0;...
                                [~,timeofmax(c)]=max(squeeze(msemean(row,col,:)));rowtracker(c)=row;coltracker(c)=col;end;end;end
                invalid=timeofmax==0;timeofmax(invalid)=NaN;

                if remakemsemeanarray==1
                    %for timestep=1:40
                    %    msemeanresh=reshape(msemeanold(row1:row2,col1alt:col2alt,timestep),[size(msemeanold(row1:row2,col1alt:col2alt,timestep),1)*size(msemeanold(row1:row2,col1alt:col2alt,timestep),2),1]);
                    %    msemeanold_here(regord,timestep)=quantile(msemeanresh,0.5);msep2pt5old_here(regord,timestep)=quantile(msemeanresh,0.025);msep97pt5old_here(regord,timestep)=quantile(msemeanresh,0.975);
                    %end
                    chere=1;clear msemeanallthisreg;
                    file=load(strcat('/Volumes/ExternalDriveZ/ERA5_HHLcalcs/fulldistnarrays2017.mat'));msetimeline=file.msetimeline;
                    for i=1:721
                        for j=1:1440
                            if i>=row1 && i<=row2 && j>=col1 && j<=col2 %gridpt in current region
                                if max(max(msetimeline{i,j}))>=p99mseglobal %worth checking further?
                                    for day=1:size(msetimeline{i,j},1)
                                        if max(msetimeline{i,j}(day,17:24))>=p99mseglobal %extreme day at this gridpt
                                            %msemeanallthisreg(chere:chere+size(msetimeline{i,j},1)-1,:)=msetimeline{i,j};
                                            %chere=chere+size(msetimeline{i,j},1);
                                            msemeanallthisreg(chere,:)=msetimeline{i,j}(day,:);
                                            chere=chere+1;
                                        end
                                    end
                                end
                            end
                        end
                    end
                    actualmsemeanbyreg_here(regord,:)=mean(msemeanallthisreg,1);
                    save('/Volumes/ExternalDriveZ/ERA5_HHLcalcs/finalfinalarrays.mat','actualmsemeanbyreg_here');
                end


                %Remove data over water
                exist lsmask;
                if ans==0
                    lsmask=ncread('/Volumes/ExternalDriveD/ERA5_variousvariables/lsmask_era5.nc','lsm');lsmask=lsmask';
                    lsmask=[lsmask(:,721:1440) lsmask(:,1:720)];
                end
                watergridpts=lsmask<0.3;watergridpts_rep=repmat(watergridpts,[1 1 40]);watergridpts_rep2=repmat(watergridpts,[1 1 40 3]);watergridpts_rep3=repmat(watergridpts,[1 1 5]);
            
                %Decided later to keep water gridpts, otherwise PG in particular is not accurately represented
                %msemean(watergridpts_rep)=NaN;qhmean(watergridpts_rep)=NaN;qlmean(watergridpts_rep)=NaN;
                %pblhmean(watergridpts_rep)=NaN;precipmean(watergridpts_rep)=NaN;mssmean(watergridpts_rep)=NaN;
                %sfcsensiblemean(watergridpts_rep)=NaN;sfclatentmean(watergridpts_rep)=NaN;
                %lwmean(watergridpts_rep2)=NaN;swmean(watergridpts_rep2)=NaN;
                %smmean(watergridpts_rep)=NaN;precipchirpsmean(watergridpts_rep3)=NaN;


                %Rather than take a straight average, weight by the number of extreme days at each gridpoint!
                %qhmean_here(regord,:)=squeeze(quantile(quantile(qhmean(row1:row2,col1:col2,:),0.5),0.5)); %old way

                %New way:
                arrsizethisreg=repmat(arrsizebygridpt(row1:row2,col1:col2),[1 1 40]);arrsizethisregdaily=repmat(arrsizebygridpt(row1:row2,col1:col2),[1 1 5]);

                %Adjust arrsizethisreg to exclude places where MSEmean is NaN (could be for any of various reasons)
                %Also impose stricter lower limits by including only gridpts with at least X occurrences (exact number varies by region)

                msemeanthisreg=msemean(row1:row2,col1:col2,:);
                for c1=1:size(arrsizethisreg,1)
                    for c2=1:size(arrsizethisreg,2)
                        for c3=1:size(arrsizethisreg,3)
                            if isnan(msemeanthisreg(c1,c2,c3)) || arrsizethisreg(c1,c2,c3)<lowerlimitgridptcount(regnum)
                                arrsizethisreg(c1,c2,c3)=NaN;
                            end
                        end
                    end
                end
                sumarrsizes=nansum(nansum(arrsizethisreg));sumarrsizesdaily=nansum(nansum(arrsizethisregdaily)); %new way
            end
            
            
            if btfapproach==1
                msemean_here(regord,:)=squeeze(nansum(nansum(msemean(row1:row2,col1:col2,:).*arrsizethisreg))./sumarrsizes);
                qhmean_here(regord,:)=squeeze(nansum(nansum(qhmean(row1:row2,col1:col2,:).*arrsizethisreg))./sumarrsizes);
                qlmean_here(regord,:)=squeeze(nansum(nansum(qlmean(row1:row2,col1:col2,:).*arrsizethisreg))./sumarrsizes);
                pblhmean_here(regord,:)=squeeze(nansum(nansum(pblhmean(row1:row2,col1:col2,:).*arrsizethisreg))./sumarrsizes);
                smmean_here(regord,:)=squeeze(nansum(nansum(smmean(row1:row2,col1:col2,:).*arrsizethisreg))./sumarrsizes);
                precipchirpsmean_here(regord,:)=squeeze(nansum(nansum(precipchirpsmean(row1:row2,col1:col2,:).*arrsizethisregdaily))./sumarrsizesdaily);
                if traceapproach==1
                    precipmean_here(regord,:)=squeeze(mean(mean(precipmean(row1:row2,col1:col2,:),'omitnan'),'omitnan')).*1000; %mm/hr
                else
                    precipmean_here(regord,:)=squeeze(nansum(nansum(precipmean(row1:row2,col1:col2,:).*arrsizethisreg))./sumarrsizes);
                end
                mssmean_here(regord,:)=squeeze(nansum(nansum(mssmean(row1:row2,col1:col2,:).*arrsizethisreg))./sumarrsizes);
                sfcsensiblemean_here(regord,:)=squeeze(nansum(nansum(sfcsensiblemean(row1:row2,col1:col2,:).*arrsizethisreg))./sumarrsizes);
                sfclatentmean_here(regord,:)=squeeze(nansum(nansum(sfclatentmean(row1:row2,col1:col2,:).*arrsizethisreg))./sumarrsizes);
                lwmean_here(regord,:)=squeeze(nansum(nansum(lwmean(row1:row2,col1:col2,:,3).*arrsizethisreg))./sumarrsizes);
                swmean_here(regord,:)=squeeze(nansum(nansum(swmean(row1:row2,col1:col2,:,3).*arrsizethisreg))./sumarrsizes);
            elseif btfapproach==2
                nless=squeeze(sum(alltimeline{regnum,1}<=squeeze(nanmean(allextrarr{regnum,1},1))));msemean_here(regord,:)=squeeze(100*nless/length(alltimeline{regnum,1}));
                nless=squeeze(sum(alltimeline{regnum,2}<=squeeze(nanmean(allextrarr{regnum,2},1))));qhmean_here(regord,:)=squeeze(100*nless/length(alltimeline{regnum,2}));
                nless=squeeze(sum(alltimeline{regnum,3}<=squeeze(nanmean(allextrarr{regnum,3},1))));qlmean_here(regord,:)=squeeze(100*nless/length(alltimeline{regnum,3}));
                nless=squeeze(sum(alltimeline{regnum,4}<=squeeze(nanmean(allextrarr{regnum,4},1))));pblhmean_here(regord,:)=squeeze(100*nless/length(alltimeline{regnum,4}));
                nless=squeeze(sum(alltimeline{regnum,5}<=squeeze(nanmean(allextrarr{regnum,5},1))));precipmean_here(regord,:)=squeeze(100*nless/length(alltimeline{regnum,5}));
                nless=squeeze(sum(alltimeline{regnum,6}<=squeeze(nanmean(allextrarr{regnum,6},1))));mssmean_here(regord,:)=squeeze(100*nless/length(alltimeline{regnum,6}));
                nless=squeeze(sum(alltimeline{regnum,7}<=squeeze(nanmean(allextrarr{regnum,7},1))));sfcsensiblemean_here(regord,:)=100-squeeze(100*nless/length(alltimeline{regnum,7}));
                nless=squeeze(sum(alltimeline{regnum,8}<=squeeze(nanmean(allextrarr{regnum,8},1))));sfclatentmean_here(regord,:)=100-squeeze(100*nless/length(alltimeline{regnum,8}));
                %nless=squeeze(sum(alltimeline{regnum,9}(:,:,3)<=squeeze(nanmean(allextrarr{regnum,9}(:,:,3),1))));lwmean_here(regord,:)=squeeze(100*nless/length(alltimeline{regnum,9}));
                %nless=squeeze(sum(alltimeline{regnum,10}(:,:,3)<=squeeze(nanmean(allextrarr{regnum,10}(:,:,3),1))));swmean_here(regord,:)=squeeze(100*nless/length(alltimeline{regnum,10}));
                nless=squeeze(sum(alltimeline{regnum,9}(:,:,3)<=squeeze(nanmean(allextrarr{regnum,9}(:,3),1))));lwmean_here(regord,:)=squeeze(100*nless/length(alltimeline{regnum,9}));
                nless=squeeze(sum(alltimeline{regnum,10}(:,:,3)<=squeeze(nanmean(allextrarr{regnum,10}(:,3),1))));swmean_here(regord,:)=squeeze(100*nless/length(alltimeline{regnum,10}));
                nless=squeeze(sum(alltimeline{regnum,11}(:,:,3)<=squeeze(nanmean(allextrarr{regnum,11},1))));umean_here(regord,:)=squeeze(100*nless/length(alltimeline{regnum,11}));
                nless=squeeze(sum(alltimeline{regnum,12}(:,:,3)<=squeeze(nanmean(allextrarr{regnum,12},1))));vmean_here(regord,:)=squeeze(100*nless/length(alltimeline{regnum,12}));
                nless=squeeze(sum(alltimeline{regnum,13}(:,:,3)<=squeeze(nanmean(allextrarr{regnum,13},1))));wmean_here(regord,:)=squeeze(100*nless/length(alltimeline{regnum,13}));
                nless=squeeze(sum(alltimeline{regnum,14}<=squeeze(nanmean(allextrarr{regnum,14},1))));smmean_here(regord,:)=squeeze(100*nless/length(alltimeline{regnum,14}));
                nless=squeeze(sum(alltimeline{regnum,15}<=squeeze(nanmean(allextrarr{regnum,15},1))));precipchirpsmean_here(regord,:)=squeeze(100*nless/length(alltimeline{regnum,15}));
            elseif btfapproach==3
                for variab=1:size(variabnames,1)
                    if variab~=6 && variab~=14
                        tv=variabnames{variab};
                        if variab==5 && regord==1 && usingchirpsforpg==1;tv='precipchirps';elseif variab==5;tv='precip';end
                        if regord==1
                            %eval([tv 'mean_here(regord,:)=(' tv 'centileextr_pgland+' tv 'centileextr_pgocean)./2;']);
                            %eval([tv 'mean_here(regord,:)=' tv 'centileextr_pgland;']);
                            eval([tv 'mean_here(regord,:)=' tv 'centileextrtry4_pgland.*100;']);
                            eval([tv 'meanocean_here(regord,:)=' tv 'centileextrtry4_pgocean.*100;']);
                        elseif regord==2
                            eval([tv 'mean_here(regord,:)=' tv 'centileextrtry4_pak.*100;']);
                        elseif regord==3
                            eval([tv 'mean_here(regord,:)=' tv 'centileextrtry4_eind.*100;']);
                        elseif regord==4
                            eval([tv 'mean_here(regord,:)=' tv 'centileextrtry4_wamaz.*100;']);
                        end
                    end
                end
            end

            %u700mbmean_here(regord,:)=squeeze(quantile(quantile(umean(row1:row2,col1:col2,:,2),0.5),0.5));
            %v700mbmean_here(regord,:)=squeeze(quantile(quantile(vmean(row1:row2,col1:col2,:,2),0.5),0.5));
            %u250mmean_here(regord,:)=squeeze(quantile(quantile(umean(row1:row2,col1:col2,:,3),0.5),0.5));
            %v250mmean_here(regord,:)=squeeze(quantile(quantile(vmean(row1:row2,col1:col2,:,3),0.5),0.5));
            %winddir700mbmean_here(regord,:)=winddirfromuandv(u700mbmean_here(regord,:),v700mbmean_here(regord,:));
            %winddir250mmean_here(regord,:)=winddirfromuandv(u250mmean_here(regord,:),v250mmean_here(regord,:));

            %w700mbmean_here(regord,:)=squeeze(quantile(quantile(wmean(row1:row2,col1:col2,:,2),0.5),0.5));
            %w250mmean_here(regord,:)=squeeze(quantile(quantile(wmean(row1:row2,col1:col2,:,3),0.5),0.5));        



            
            %Various troubleshooting
            ts=0;
            if ts==1
                regnum=1;
                row1=actualrowstarts(regnum);row2=actualrowstops(regnum);col1=actualcolstarts(regnum)-0.5;col2=actualcolstops(regnum)+0.5;
                figure(200);clf;hold on;c=0;c17max=0;cnon17max=0;
                indices17maxmap=NaN.*ones(721,1440);
                for i=1:721
                    for j=1:1440
                        if i>=row1 && i<=row2 && j>=col1 && j<=col2 && sum(~isnan(swmean(i,j,:,1)))>=10
                            c=c+1;

                            %plot(squeeze(mean(swtimeline{i,j}(:,:,1))));
                            plot(squeeze(msemean(i,j,:)));hold on;
                            savedindices(c,1:2)=[i j];
                            
                            [~,b]=max(msemean(i,j,:));
                            %if qhmean(i,j,17)>qhmean(i,j,16) && qhmean(i,j,17)>qhmean(i,j,18)
                            %    c17max=c17max+1;indices17max(c17max,1:2)=[i j];
                            %    indices17maxmap(i,j)=1;
                            %else
                            %    cnon17max=cnon17max+1;indicesnon17max(cnon17max,1:2)=[i j];
                            %    indices17maxmap(i,j)=0;
                            %end
                            %if c==10;return;end
                        end
                    end
                end

                
                i=274;j=1069; %use 255,925 for regnum 1; 244,994 for regnum 2; 274,1069 for regnum 3; 380,470 for regnum 5
                timeline=swtimeline;varc=10;
                
                extrarr=[];nonextrarr=[];
                meanwarmseasontrace=squeeze(mean(timeline{i,j}));
                stdevwarmseasontrace=squeeze(std(timeline{i,j}));
                %SHORTCUT TO CHANGE FOR FINALCODE
                clear dailymax;
                for day=1:size(msetimeline{i,j},1)
                    dailymax(day)=max(msetimeline{i,j}(day,17:25));
                end
                p95here=quantile(dailymax,0.95);
                for day=1:size(msetimeline{i,j},1)
                    %if max(msetimeline{i,j}(day,17:25))>=p99msebypoint_on0(i,j-1)
                    if max(msetimeline{i,j}(day,17:24))>=p99mseglobal
                        if varc<=8
                            extrarr=cat(1,extrarr,timeline{i,j}(day,:));
                        elseif day<=size(timeline{i,j},1)
                            extrarr=cat(1,extrarr,timeline{i,j}(day,:,:));
                        end
                    else
                        if varc<=8
                            nonextrarr=cat(1,nonextrarr,timeline{i,j}(day,:));
                        elseif day<=size(timeline{i,j},1)
                            nonextrarr=cat(1,nonextrarr,timeline{i,j}(day,:,:));
                        end
                    end
                end
                figure(89);clf;
                if varc<=8
                    subplot(4,2,1);imagescnan(extrarr);title('extrarr');subplot(4,2,3);plot(mean(extrarr,1));title('mean of extrarr');
                    subplot(4,2,2);imagescnan(nonextrarr);title('nonextrarr');subplot(4,2,4);plot(mean(nonextrarr,1));title('mean of nonextrarr');
                    subplot(4,2,5);plot(meanwarmseasontrace);title('meanwarmseasontrace');subplot(4,2,6);plot(stdevwarmseasontrace);title('stdevwarmseasontrace');
                    subplot(4,2,7);plot(mean(extrarr,1)-mean(nonextrarr,1));title('difference (nominal)');
                    subplot(4,2,8);plot((mean(extrarr,1)-mean(nonextrarr,1))./stdevwarmseasontrace);title('difference (as std anom)');
                else
                    subplot(4,2,1);imagescnan(squeeze(extrarr(:,:,1)));title('extrarr');subplot(4,2,3);plot(mean(squeeze(extrarr(:,:,1)),1));title('mean of extrarr');
                    subplot(4,2,2);imagescnan(squeeze(nonextrarr(:,:,1)));title('nonextrarr');subplot(4,2,4);plot(mean(squeeze(nonextrarr(:,:,1)),1));title('mean of nonextrarr');
                    subplot(4,2,5);plot(meanwarmseasontrace(:,1));title('meanwarmseasontrace');subplot(4,2,6);plot(stdevwarmseasontrace(:,1));title('stdevwarmseasontrace');
                    subplot(4,2,7);plot(mean(squeeze(extrarr(:,:,1)),1)-mean(squeeze(nonextrarr(:,:,1)),1));title('difference (nominal)');
                    subplot(4,2,8);plot((mean(squeeze(extrarr(:,:,1)),1)-mean(squeeze(nonextrarr(:,:,1)),1))./stdevwarmseasontrace(:,1)');title('difference (as std anom)');
                end
            end
            
            %In older approaches: smooth Amazon a bit since it doesn't have enough years to look nice otherwise
            if btfapproach==1 || btfapproach==2
                if regord==4
                    msemean_here(regord,:)=smooth(msemean_here(regord,:),3);qhmean_here(regord,:)=smooth(qhmean_here(regord,:),3);qlmean_here(regord,:)=smooth(qlmean_here(regord,:),3);
                    pblhmean_here(regord,:)=smooth(pblhmean_here(regord,:),3);precipmean_here(regord,:)=smooth(precipmean_here(regord,:),3);mssmean_here(regord,:)=smooth(mssmean_here(regord,:),3);
                    smmean_here(regord,:)=smooth(smmean_here(regord,:),3);
                end
            end


            %Make plot
            %Logistical set-up
            %As a reminder, the underlying data for e.g. Amazon Ql is contained in qlactualextr_wamaz
            legendlocssp1={'northeast';'northeast';'northeast';'northeast'};legendlocssp2={'northeast';'northeast';'northeast';'northeast'};
            legendlocssp3={'northeast';'southwest';'northeast';'northeast'};legendlocssp4={'southwest';'southwest';'southwest';'southwest'};
            ylowersp1=[0;0;0;0];ylowersp2=[-12;-12;-12;-12];ylowersp3=[-150;-150;-150;-150];ylowersp4=[-90;-90;-90;-90];
            yuppersp1=[25;25;25;25];yuppersp2=[12;12;12;12];yuppersp3=[150;150;150;150];yuppersp4=[90;90;90;90];
            yylowersp3=[-0.04;-0.04;-0.04;-0.04];yylowersp4=[-4;-4;-4;-4];
            yyuppersp3=[0.04;0.04;0.04;0.04];yyuppersp4=[4;4;4;4];
            
            exist actualmsemeanbyreg_here;if ans==0;f=load('/Volumes/ExternalDriveZ/ERA5_HHLcalcs/finalfinalarrays.mat');actualmsemeanbyreg_here=f.actualmsemeanbyreg_here;end
            [~,hrofmax_thisreg]=max(actualmsemeanbyreg_here(regord,17:24));hrofmax_thisreg=hrofmax_thisreg+16;

            
            palefactor=0.65;
            
            %Pale versions of colors are for plotting PG ocean
            temp=max(max(colors('red')))-colors('red');palered=colors('red')+palefactor*temp;
            temp=max(max(colors('green')))-colors('green');palegreen=colors('green')+palefactor*temp;
            temp=max(max(colors('meteoswiss_light green')))-colors('meteoswiss_light green');palelightgreen=colors('meteoswiss_light green')+palefactor*temp;
            temp=max(max(colors('orange')))-colors('orange');paleorange=colors('orange')+palefactor*temp;
            temp=max(max(colors('blue')))-colors('blue');paleblue=colors('blue')+palefactor*temp;
            temp=max(max(colors('dark yellow')))-colors('dark yellow');paledarkyellow=colors('dark yellow')+palefactor*temp;
            temp=max(max(colors('purple')))-colors('purple');palepurple=colors('purple')+palefactor*temp;
            temp=max(max(colors('sky blue')))-colors('sky blue');paleskyblue=colors('sky blue')+palefactor*temp;
            temp=max(max(colors('light red')))-colors('light red');palelightred=colors('light red')+palefactor*temp;
            temp=max(max(colors('pink')))-colors('pink');palepink=colors('pink')+palefactor*temp;
            temp=max(max(colors('turquoise')))-colors('turquoise');paleturquoise=colors('turquoise')+palefactor*temp;
            
            
            
            
            %Subplot 1
            thisleftpos=subplotleftpos(relreg);
            axes('Position',[thisleftpos 0.77 0.225 0.17]);hold on;
            %plot(msemean_here(regord,:)-msemeannonextr_here(regord,:),'k','linewidth',1.5);
            if regord==1
                plot(smooth(msemeanocean_here(regord,1:40),smoothamts(regord)),'color',palered,'linewidth',1.5);
                plot(smooth(qhmeanocean_here(regord,1:40),smoothamts(regord)),'color',palegreen,'linewidth',1.5);
                plot(smooth(qlmeanocean_here(regord,1:40),smoothamts(regord)),'color',paleblue,'linewidth',1.5);
            end
            plot(smooth(msemean_here(regord,1:40),smoothamts(regord)),'color',colors('red'),'linewidth',1.5);
            plot(smooth(qhmean_here(regord,1:40),smoothamts(regord)),'color',colors('green'),'linewidth',1.5);
            plot(smooth(qlmean_here(regord,1:40),smoothamts(regord)),'color',colors('blue'),'linewidth',1.5);
            
            plot(50.*ones(size(msemean_here,2),1),'color',colors('black'),'linestyle','--'); %p50 as reference line
            set(gca,'fontsize',9,'fontweight','bold','fontname','arial');
            %l=legend('MSE','Qh','Ql');set(l,'fontsize',9,'fontweight','bold','fontname','arial','location','northwest');
            t=text(0.9,0.26,'ME','color',colors('red'),'units','normalized');set(t,'fontsize',9,'fontweight','bold','fontname','arial');
            t=text(0.9,0.16,'Qh','color',colors('green'),'units','normalized');set(t,'fontsize',9,'fontweight','bold','fontname','arial');
            t=text(0.9,0.06,'Ql','color',colors('blue'),'units','normalized');set(t,'fontsize',9,'fontweight','bold','fontname','arial');
            if regord==1;splabel='a)';elseif regord==2;splabel='b)';elseif regord==3;splabel='c)';else;splabel='d)';end
            t=text(0,1.07,splabel,'color','k','units','normalized');set(t,'fontsize',12,'fontweight','bold','fontname','arial');
            if strcmp(stdevorcentile,'stdev')
                if regnum==5;lowerylim=-0.5;upperylim=2.5;else;lowerylim=-0.5;upperylim=1.5;set(gca,'ytick',[0:1]);end
            else
                lowerylim=0;upperylim=100;
            end
            if strcmp(stdevorcentile,'stdev');ylim([lowerylim upperylim]);end
            patchx=[hrofmax_thisreg-0.5 hrofmax_thisreg-0.5 hrofmax_thisreg+0.5 hrofmax_thisreg+0.5];
            patchy=[lowerylim upperylim upperylim lowerylim];
            p=patch(patchx,patchy,colors('gray'));alpha(p,0.2);set(p,'EdgeColor',colors('gray'));
            %ylim([ylowersp1(regord) yuppersp1(regord)]);
            xlim([1 40]);
            if regnum==1
                set(gca,'xtick',3.67:4:39);xticklabels({'12','00','12','00','12','00','12','00','12','00'});xtickangle(45);
            elseif regnum==2
                set(gca,'xtick',3.33:4:39);xticklabels({'12','00','12','00','12','00','12','00','12','00'});xtickangle(45);
            elseif regnum==3
                set(gca,'xtick',3:4:39);xticklabels({'12','00','12','00','12','00','12','00','12','00'});xtickangle(45);
            elseif regnum==5
                set(gca,'xtick',2.33:4:39);xticklabels({'00','12','00','12','00','12','00','12','00','12','00'});xtickangle(45);
            end
            %xticklabels({'-2, 00:00','-2, 12:00','-1, 00:00','-1, 12:00','0, 00:00','0, 12:00','1, 00:00','1, 12:00','2, 00:00','2, 12:00'});xtickangle(45);
            if traceapproach==1;ylabel('Anomaly (J/kg)','fontsize',11,'fontweight','bold','fontname','arial');end
            if regord==1;subregname=subregnames{regord};else;subregname=subregnames{regord+1};end
            samplesize_indays=[163;109;56;49];
            t=text(0.81,1.03,strcat('n=',num2str(samplesize_indays(regord))),'units','normalized');set(t,'fontsize',9,'fontweight','bold','fontname','arial');
            title(regnames{regnum},'fontsize',12,'fontweight','bold','fontname','arial');

            
            
            %Subplot 2
            axes('Position',[thisleftpos 0.54 0.225 0.17]);hold on;
            if traceapproach==1
                if regord==1;plot(smooth(pblhmeanocean_here(regord,1:40))./100,'color',paleorange,'linewidth',1.5);end
                plot(smooth(pblhmean_here(regord,1:40))./100,'color',colors('orange'),'linewidth',1.5);
            else
                if regord==1;plot(smooth(pblhmeanocean_here(regord,1:40),smoothamts(regord)),'color',paleorange,'linewidth',1.5);end
                plot(smooth(pblhmean_here(regord,1:40),smoothamts(regord)),'color',colors('orange'),'linewidth',1.5);
            end
            if regord<=1 && usingchirpsforpg==1
                for kk=1:40;precipchirpsmeanocean_here40(regord,kk)=precipchirpsmeanocean_here(regord,round2(kk/8,1,'ceil'))./100;end
                plot(precipchirpsmeanocean_here40(regord,1:40),'color',paleskyblue,'linewidth',1.5);
                for kk=1:40;precipchirpsmean_here40(regord,kk)=precipchirpsmean_here(regord,round2(kk/8,1,'ceil'))./100;end
                plot(precipchirpsmean_here40(regord,1:40),'color',colors('sky blue'),'linewidth',1.5);
            else
                plot(smooth(precipmean_here(regord,1:40),smoothamts(regord)),'color',colors('sky blue'),'linewidth',1.5);
            end
            if inclmss==1;plot(smooth(mssmean_here(regord,1:40),smoothamts(regord)),'m','linewidth',1.5);end
            plot(50.*ones(size(msemean_here,2),1),'color',colors('black'),'linestyle','--'); %p50 as reference line
            set(gca,'fontsize',9,'fontweight','bold','fontname','arial');
            %l=legend('PBLh','Precip.','MSS');set(l,'fontsize',9,'fontweight','bold','fontname','arial','location','northwest');
            t=text(0.12,1.06,'PBL','color',colors('orange'),'units','normalized');set(t,'fontsize',9,'fontweight','bold','fontname','arial');
            t=text(0.12,0.96,'Precip','color',colors('sky blue'),'units','normalized');set(t,'fontsize',9,'fontweight','bold','fontname','arial');
            if inclmss==1;t=text(0.87,0.76,'MSS','color','m','units','normalized');set(t,'fontsize',10,'fontweight','bold','fontname','arial');end
            if regord==1;splabel='e)';elseif regord==2;splabel='f)';elseif regord==3;splabel='g)';else;splabel='h)';end
            t=text(0,1.07,splabel,'color','k','units','normalized');set(t,'fontsize',12,'fontweight','bold','fontname','arial');
            if strcmp(stdevorcentile,'stdev')
                if regnum==5;lowerylim=-1;upperylim=3;else;lowerylim=-1;upperylim=2;end
            else
                lowerylim=0;upperylim=100;
            end
            if strcmp(stdevorcentile,'stdev');ylim([lowerylim upperylim]);end
            patchx=[hrofmax_thisreg-0.5 hrofmax_thisreg-0.5 hrofmax_thisreg+0.5 hrofmax_thisreg+0.5];
            patchy=[lowerylim upperylim upperylim lowerylim];
            p=patch(patchx,patchy,colors('gray'));alpha(p,0.2);set(p,'EdgeColor',colors('gray'));
            %ylim([ylowersp2(regord) yuppersp2(regord)]);
            xlim([1 40]);
            if regnum==1
                set(gca,'xtick',3.67:4:39);xticklabels({'12','00','12','00','12','00','12','00','12','00'});xtickangle(45);
            elseif regnum==2
                set(gca,'xtick',3.33:4:39);xticklabels({'12','00','12','00','12','00','12','00','12','00'});xtickangle(45);
            elseif regnum==3
                set(gca,'xtick',3:4:39);xticklabels({'12','00','12','00','12','00','12','00','12','00'});xtickangle(45);
            elseif regnum==5
                set(gca,'xtick',2.33:4:39);xticklabels({'00','12','00','12','00','12','00','12','00','12','00'});xtickangle(45);
            end
            %xticklabels({'-2, 00:00','-2, 12:00','-1, 00:00','-1, 12:00','0, 00:00','0, 12:00','1, 00:00','1, 12:00','2, 00:00','2, 12:00'});xtickangle(45);
            if traceapproach==1;ylabel('Anomaly (mm/hr; K)','fontsize',11,'fontweight','bold','fontname','arial');end

            
            
            %Subplot 3
            axes('Position',[thisleftpos 0.31 0.225 0.17]);hold on;
            %plot(-sfcsensiblemean_here(regord,:)./3600,'g','linewidth',1.5); %W/m^2
            if strcmp(stdevorcentile,'stdev');multiplyby=-1;else;multiplyby=1;end
            if regord==1;plot(smooth(multiplyby*sfcsensiblemeanocean_here(regord,1:40),smoothamts(regord)),'color',paledarkyellow,'linewidth',1.5);end
            plot(smooth(multiplyby*sfcsensiblemean_here(regord,1:40),smoothamts(regord)),'color',colors('dark yellow'),'linewidth',1.5);
            if regord==1;plot(smooth(multiplyby*sfclatentmeanocean_here(regord,1:40),smoothamts(regord)),'color',palepurple,'linewidth',1.5);end
            plot(smooth(multiplyby*sfclatentmean_here(regord,1:40),smoothamts(regord)),'color',colors('purple'),'linewidth',1.5);
            
            if traceapproach==1;ylabel('Anomaly (W/m^2)','fontsize',11,'fontweight','bold','fontname','arial');yyaxis right;end
           
            t=text(0.12,1.06,'Sfc Sensible','color',colors('dark yellow'),'units','normalized');set(t,'fontsize',9,'fontweight','bold','fontname','arial');
            t=text(0.12,0.96,'Sfc Latent','color',colors('purple'),'units','normalized');set(t,'fontsize',9,'fontweight','bold','fontname','arial');

            if regord==1;splabel='i)';elseif regord==2;splabel='j)';elseif regord==3;splabel='k)';else;splabel='l)';end
            t=text(0,1.07,splabel,'color','k','units','normalized');set(t,'fontsize',12,'fontweight','bold','fontname','arial');
            plot(50.*ones(size(msemean_here,2),1),'color',colors('black'),'linestyle','--'); %p50 as reference line
            set(gca,'fontsize',9,'fontweight','bold','fontname','arial');
            if strcmp(stdevorcentile,'stdev');ylim([-2 2]);end
            patchx=[hrofmax_thisreg-0.5 hrofmax_thisreg-0.5 hrofmax_thisreg+0.5 hrofmax_thisreg+0.5];
            if strcmp(stdevorcentile,'stdev')
                lowerylim=-2;upperylim=2;
            else
                lowerylim=0;upperylim=100;
            end
            patchy=[lowerylim upperylim upperylim lowerylim];
            p=patch(patchx,patchy,colors('gray'));alpha(p,0.2);set(p,'EdgeColor',colors('gray'));
            %ylim([yylowersp3(regord) yyuppersp3(regord)]);
            xlim([1 40]);
            if regnum==1
                set(gca,'xtick',3.67:4:39);xticklabels({'12','00','12','00','12','00','12','00','12','00'});xtickangle(45);
            elseif regnum==2
                set(gca,'xtick',3.33:4:39);xticklabels({'12','00','12','00','12','00','12','00','12','00'});xtickangle(45);
            elseif regnum==3
                set(gca,'xtick',3:4:39);xticklabels({'12','00','12','00','12','00','12','00','12','00'});xtickangle(45);
            elseif regnum==5
                set(gca,'xtick',2.33:4:39);xticklabels({'00','12','00','12','00','12','00','12','00','12','00'});xtickangle(45);
            end
            
            
            
            %Subplot 4
            axes('Position',[thisleftpos 0.08 0.225 0.17]);hold on;
            if strcmp(stdevorcentile,'stdev');multiplyby=-1;else;multiplyby=1;end
            if traceapproach==1;yyaxis right;end
            
            if regord==1;lwoceantoplot=smooth(lwmeanocean_here(regord,1:40)',smoothamts(regord));end
            lwtoplot=smooth(lwmean_here(regord,1:40)',smoothamts(regord));
            if regord==1;swoceantoplot=smooth(swmeanocean_here(regord,1:40)',smoothamts(regord));end
            swtoplot=smooth(swmean_here(regord,1:40)',smoothamts(regord));
            
            %Remove data for shortwave radiation at night, when it is smaller than during the day and thus the anomalies are much less meaningful
            if regnum==1 %PG
                swtoplot(1)=NaN;swtoplot(7:9)=NaN;swtoplot(15:17)=NaN;swtoplot(23:25)=NaN;swtoplot(31:33)=NaN;swtoplot(39:40)=NaN;
                swoceantoplot(1)=NaN;swoceantoplot(7:9)=NaN;swoceantoplot(15:17)=NaN;swoceantoplot(23:25)=NaN;
                    swoceantoplot(31:33)=NaN;swoceantoplot(39:40)=NaN;
            elseif regnum==2 %Pakistan
                swtoplot(1)=NaN;swtoplot(6:9)=NaN;swtoplot(14:17)=NaN;swtoplot(22:25)=NaN;swtoplot(30:33)=NaN;swtoplot(38:40)=NaN;
            elseif regnum==3 %E India
                swtoplot(1)=NaN;swtoplot(6:9)=NaN;swtoplot(14:17)=NaN;swtoplot(22:25)=NaN;swtoplot(30:33)=NaN;swtoplot(38:40)=NaN;
            elseif regnum==5 %Amazon
                swtoplot(1:4)=NaN;swtoplot(9:12)=NaN;swtoplot(17:20)=NaN;swtoplot(25:28)=NaN;swtoplot(33:36)=NaN;
            end
            
            if regnum==1;plot(lwoceantoplot,'color',paleturquoise,'linewidth',1.5);end
            plot(lwtoplot,'color',colors('turquoise'),'linewidth',1.5); %K/hr
            if regnum==1;plot(swoceantoplot,'color',palepink,'linewidth',1.5);end
            plot(swtoplot,'color',colors('pink'),'linewidth',1.5);
            
            
            if mainlevel==1
                t=text(0.12,1.06,'300mb LW','color',colors('turquoise'),'units','normalized');set(t,'fontsize',9,'fontweight','bold','fontname','arial');
                t=text(0.12,0.96,'300mb SW','color',colors('pink'),'units','normalized');set(t,'fontsize',9,'fontweight','bold','fontname','arial');
            elseif mainlevel==3
                t=text(0.12,1.06,'Near-Sfc LW','color',colors('turquoise'),'units','normalized');set(t,'fontsize',9,'fontweight','bold','fontname','arial');
                t=text(0.12,0.96,'Near-Sfc SW','color',colors('pink'),'units','normalized');set(t,'fontsize',9,'fontweight','bold','fontname','arial');
            end
            if regord==1;splabel='m)';elseif regord==2;splabel='n)';elseif regord==3;splabel='o)';else;splabel='p)';end
            t=text(0,1.07,splabel,'color','k','units','normalized');set(t,'fontsize',12,'fontweight','bold','fontname','arial');
            plot(50.*ones(size(msemean_here,2),1),'color',colors('black'),'linestyle','--'); %p50 as reference line
            set(gca,'fontsize',9,'fontweight','bold','fontname','arial');
            if strcmp(stdevorcentile,'stdev');ylim([-2 2]);end
            patchx=[hrofmax_thisreg-0.5 hrofmax_thisreg-0.5 hrofmax_thisreg+0.5 hrofmax_thisreg+0.5];
            if strcmp(stdevorcentile,'stdev')
                lowerylim=-2;upperylim=2;
            else
                lowerylim=0;upperylim=100;
            end
            patchy=[lowerylim upperylim upperylim lowerylim];
            p=patch(patchx,patchy,colors('gray'));alpha(p,0.2);set(p,'EdgeColor',colors('gray'));
            xlim([1 40]);
            
            if regnum==1
                set(gca,'xtick',3.67:4:39);xticklabels({'-2, 12h','-1, 00h','-1, 12h','0, 00h','0, 12h','1, 00h','1, 12h','2, 00h','2, 12h','3, 00h'});xtickangle(45);
            elseif regnum==2
                set(gca,'xtick',3.33:4:39);xticklabels({'-2, 12h','-1, 00h','-1, 12h','0, 00h','0, 12h','1, 00h','1, 12h','2, 00h','2, 12h','3, 00h'});xtickangle(45);
            elseif regnum==3
                set(gca,'xtick',3:4:39);xticklabels({'-2, 12h','-1, 00h','-1, 12h','0, 00h','0, 12h','1, 00h','1, 12h','2, 00h','2, 12h','3, 00h'});xtickangle(45);
            elseif regnum==5
                set(gca,'xtick',2.33:4:39);xticklabels({'-2, 00h','-2, 12h','-1, 00h','-1, 12h','0, 00h','0, 12h','1, 00h','1, 12h','2, 00h','2, 12h'});xtickangle(45);
            end
            if traceapproach==1;ylabel('Anomaly (K/hr)','fontsize',11,'fontweight','bold','fontname','arial');end

            end
        end
        set(gcf,'color','w');
        figname='TimeEvolutionFinal';curpart=2;highqualityfiguresetup;
    end
end


if dotimeseriesactualvalues==1
    %Limits
    msey1=[340;345;350;NaN;340];
    msey2=[380;375;375;NaN;375];
    qhy1=[300;300;300;NaN;295];
    qhy2=[320;320;320;NaN;315];
    qly1=[20;25;25;NaN;25];
    qly2=[63;63;63;NaN;63];
    pblhy1=[85;85;150;NaN;50];
    pblhy2=[2200;1700;1200;NaN;2000];
    windspdy2=[6;4;6;NaN;8];
    
    for subreg=subreg1:subreg2
        if subreg~=4
        if subreg==1
            thesexticklabels_short={'12','00','12','00','12','00','12','00','12','00'};
            thesexticklabels_full={'-2, 12h','-1, 00h','-1, 12h','0, 00h','0, 12h','1, 00h','1, 12h','2, 00h','2, 12h','3, 00h'};
            xtickrange=3.67:4:39;
        elseif subreg==2
            thesexticklabels_short={'12','00','12','00','12','00','12','00','12','00'};
            thesexticklabels_full={'-2, 12h','-1, 00h','-1, 12h','0, 00h','0, 12h','1, 00h','1, 12h','2, 00h','2, 12h','3, 00h'};
            xtickrange=3.33:4:39;
        elseif subreg==3
            thesexticklabels_short={'12','00','12','00','12','00','12','00','12','00'};
            thesexticklabels_full={'-2, 12h','-1, 00h','-1, 12h','0, 00h','0, 12h','1, 00h','1, 12h','2, 00h','2, 12h','3, 00h'};
            xtickrange=3:4:39;
        elseif subreg==5
            thesexticklabels_short={'00','12','00','12','00','12','00','12','00','12','00'};
            thesexticklabels_full={'-2, 00h','-2, 12h','-1, 00h','-1, 12h','0, 00h','0, 12h','1, 00h','1, 12h','2, 00h'};
            xtickrange=2.33:4:39;
        end
        if subreg<=3;regord=subreg;else;regord=subreg-1;end

        
        fignum=subreg*1+subreg*10+subreg*100;
        subregname=subregnames{subreg};
        
        
        

        if subreg==1              
            msefilteredextr=msefilteredextr_pgland;msefilterednonextr=msefilterednonextr_pgland;
            qhfilteredextr=qhfilteredextr_pgland;qhfilterednonextr=qhfilterednonextr_pgland;
            qlfilteredextr=qlfilteredextr_pgland;qlfilterednonextr=qlfilterednonextr_pgland;
            pblhfilteredextr=pblhfilteredextr_pgland;pblhfilterednonextr=pblhfilterednonextr_pgland;
            ufilteredextr=ufilteredextr_pgland;ufilterednonextr=ufilterednonextr_pgland;
            vfilteredextr=vfilteredextr_pgland;vfilterednonextr=vfilterednonextr_pgland;
            multiplyfirst=2;multiplythird=2;addthird=-1;
            titleappend=' (land)';
        elseif subreg==2
            msefilteredextr=msefilteredextr_pak;msefilterednonextr=msefilterednonextr_pak;
            qhfilteredextr=qhfilteredextr_pak;qhfilterednonextr=qhfilterednonextr_pak;
            qlfilteredextr=qlfilteredextr_pak;qlfilterednonextr=qlfilterednonextr_pak;
            pblhfilteredextr=pblhfilteredextr_pak;pblhfilterednonextr=pblhfilterednonextr_pak;
            ufilteredextr=ufilteredextr_pak;ufilterednonextr=ufilterednonextr_pak;
            vfilteredextr=vfilteredextr_pak;vfilterednonextr=vfilterednonextr_pak;
            multiplyfirst=1;multiplythird=1;addthird=0;
            titleappend='';
        elseif subreg==3
            msefilteredextr=msefilteredextr_eind;msefilterednonextr=msefilterednonextr_eind;
            qhfilteredextr=qhfilteredextr_eind;qhfilterednonextr=qhfilterednonextr_eind;
            qlfilteredextr=qlfilteredextr_eind;qlfilterednonextr=qlfilterednonextr_eind;
            pblhfilteredextr=pblhfilteredextr_eind;pblhfilterednonextr=pblhfilterednonextr_eind;
            ufilteredextr=ufilteredextr_eind;ufilterednonextr=ufilterednonextr_eind;
            vfilteredextr=vfilteredextr_eind;vfilterednonextr=vfilterednonextr_eind;
            multiplyfirst=1;multiplythird=1;addthird=0;
            titleappend='';
        elseif subreg==5
            msefilteredextr=msefilteredextr_wamaz;msefilterednonextr=msefilterednonextr_wamaz;
            qhfilteredextr=qhfilteredextr_wamaz;qhfilterednonextr=qhfilterednonextr_wamaz;
            qlfilteredextr=qlfilteredextr_wamaz;qlfilterednonextr=qlfilterednonextr_wamaz;
            pblhfilteredextr=pblhfilteredextr_wamaz;pblhfilterednonextr=pblhfilterednonextr_wamaz;
            ufilteredextr=ufilteredextr_wamaz;ufilterednonextr=ufilterednonextr_wamaz;
            vfilteredextr=vfilteredextr_wamaz;vfilterednonextr=vfilterednonextr_wamaz;
            multiplyfirst=1;multiplythird=1;addthird=0;
            titleappend='';
        end
        
        
        figure(fignum);clf;curpart=1;highqualityfiguresetup;
        
        subplot(3*multiplyfirst,2,1*multiplythird+addthird);hold on;
        plot(smooth(mean(msefilteredextr(:,1:40)),smoothamts(regord)),'r','linewidth',1.5);plot(smooth(mean(msefilterednonextr(:,1:40),smoothamts(regord))),'linewidth',1.5);
        title(strcat(['ME',titleappend]),'fontsize',12,'fontweight','bold','fontname','arial');set(gca,'fontsize',10,'fontweight','bold','fontname','arial');
        ylim([msey1(subreg) msey2(subreg)]);xlim([1 40]);set(gca,'xtick',xtickrange);xticklabels(thesexticklabels_short);xtickangle(45);
        
        subplot(3*multiplyfirst,2,2*multiplythird+addthird);hold on;
        plot(smooth(mean(qhfilteredextr(:,1:40))./1000,smoothamts(regord)),'r','linewidth',1.5);plot(smooth(mean(qhfilterednonextr(:,1:40))./1000,smoothamts(regord)),'linewidth',1.5);
        title(strcat(['Qh',titleappend]),'fontsize',12,'fontweight','bold','fontname','arial');set(gca,'fontsize',10,'fontweight','bold','fontname','arial');
        ylim([qhy1(subreg) qhy2(subreg)]);xlim([1 40]);set(gca,'xtick',xtickrange);xticklabels(thesexticklabels_short);xtickangle(45);
        
        subplot(3*multiplyfirst,2,3*multiplythird+addthird);hold on;
        plot(smooth(mean(qlfilteredextr(:,1:40))./1000,smoothamts(regord)),'r','linewidth',1.5);plot(smooth(mean(qlfilterednonextr(:,1:40))./1000,smoothamts(regord)),'linewidth',1.5);
        title(strcat(['Ql',titleappend]),'fontsize',12,'fontweight','bold','fontname','arial');set(gca,'fontsize',10,'fontweight','bold','fontname','arial');
        ylim([qly1(subreg) qly2(subreg)]);xlim([1 40]);set(gca,'xtick',xtickrange);xticklabels(thesexticklabels_short);xtickangle(45);
        
        subplot(3*multiplyfirst,2,4*multiplythird+addthird);hold on;
        plot(smooth(mean(pblhfilteredextr(:,1:40)),smoothamts(regord)),'r','linewidth',1.5);plot(smooth(mean(pblhfilterednonextr(:,1:40)),smoothamts(regord)),'linewidth',1.5);
        set(gca,'yscale','log');title(strcat(['PBL Height',titleappend]),'fontsize',12,'fontweight','bold','fontname','arial');
        set(gca,'fontsize',10,'fontweight','bold','fontname','arial');ylim([pblhy1(subreg) pblhy2(subreg)]);xlim([1 40]);
        set(gca,'ytick',[100;250;500;1000;2000],'yticklabels',{'100';'250';'500';'1000';'2000'});set(gca,'xtick',xtickrange);xticklabels(thesexticklabels_short);xtickangle(45);
        
        subplot(3*multiplyfirst,2,5*multiplythird+addthird);hold on;
        plot(smooth(winddirfromuandv(mean(ufilteredextr(:,1:40)),mean(vfilteredextr(:,1:40))),smoothamts(regord)),'r','linewidth',1.5);
        plot(smooth(mean(winddirfromuandv(ufilterednonextr(:,1:40),vfilterednonextr(:,1:40))),smoothamts(regord)),'linewidth',1.5);
        if subreg==5
            plot(smooth(winddirfromuandv(median(ufilteredextralt_wamaz(:,1:40)),median(vfilteredextralt_wamaz(:,1:40))),smoothamts(regord)),'color',colors('orange'),'linewidth',1.5);
            plot(smooth(winddirfromuandv(median(ufilterednonextralt_wamaz(:,1:40)),median(vfilterednonextralt_wamaz(:,1:40))),smoothamts(regord)),'color',colors('purple'),'linewidth',1.5);
        end
        title(strcat(['Wind Direction',titleappend]),'fontsize',12,'fontweight','bold','fontname','arial');ylim([0 360]);
        set(gca,'fontsize',10,'fontweight','bold','fontname','arial');set(gca,'xtick',xtickrange);xlim([1 40]);set(gca,'ytick',[90:90:360],'yticklabel',{'90';'180';'270';'360'});
        if subreg==1;xticklabels(thesexticklabels_short);else;xticklabels(thesexticklabels_full);end;xtickangle(45);
        
        subplot(3*multiplyfirst,2,6*multiplythird+addthird);hold on;
        plot(smooth(sqrt(mean(ufilteredextr(:,1:40)).^2+mean(vfilteredextr(:,1:40).^2)),smoothamts(regord)),'r','linewidth',1.5);
        plot(smooth(sqrt(mean(ufilterednonextr(:,1:40)).^2+mean(vfilterednonextr(:,1:40)).^2),smoothamts(regord)),'linewidth',1.5);
        if subreg==5
            plot(smooth(sqrt(mean(ufilteredextralt_wamaz(:,1:40)).^2+mean(vfilteredextralt_wamaz(:,1:40).^2)),smoothamts(regord)),'color',colors('orange'),'linewidth',1.5);
            plot(smooth(sqrt(mean(ufilterednonextralt_wamaz(:,1:40)).^2+mean(vfilterednonextralt_wamaz(:,1:40)).^2),smoothamts(regord)),'color',colors('purple'),'linewidth',1.5);
        end
        title(strcat(['Wind Speed',titleappend]),'fontsize',12,'fontweight','bold','fontname','arial');set(gca,'fontsize',10,'fontweight','bold','fontname','arial');xlim([1 40]);ylim([0 windspdy2(subreg)]);set(gca,'xtick',xtickrange);
        xticklabels(thesexticklabels_full);xtickangle(45);
        
        
        if subreg==1 %add ocean for PG
            msefilteredextr=msefilteredextr_pgocean;msefilterednonextr=msefilterednonextr_pgocean;
            qhfilteredextr=qhfilteredextr_pgocean;qhfilterednonextr=qhfilterednonextr_pgocean;
            qlfilteredextr=qlfilteredextr_pgocean;qlfilterednonextr=qlfilterednonextr_pgocean;
            pblhfilteredextr=pblhfilteredextr_pgocean;pblhfilterednonextr=pblhfilterednonextr_pgocean;
            ufilteredextr=ufilteredextr_pgocean;ufilterednonextr=ufilterednonextr_pgocean;
            vfilteredextr=vfilteredextr_pgocean;vfilterednonextr=vfilterednonextr_pgocean;
            addthird=0;
            
            subplot(3*multiplyfirst,2,1*multiplythird+addthird);hold on;
            plot(smooth(mean(msefilteredextr(:,1:40),smoothamts(regord))),'r','linewidth',1.5);plot(smooth(mean(msefilterednonextr(:,1:40),smoothamts(regord))),'linewidth',1.5);
            title('ME (ocean)','fontsize',12,'fontweight','bold','fontname','arial');set(gca,'fontsize',10,'fontweight','bold','fontname','arial');
            ylim([msey1(subreg) msey2(subreg)]);xlim([1 40]);set(gca,'xtick',xtickrange);xticklabels(thesexticklabels_short);xtickangle(45);

            subplot(3*multiplyfirst,2,2*multiplythird+addthird);hold on;
            plot(smooth(mean(qhfilteredextr(:,1:40))./1000,smoothamts(regord)),'r','linewidth',1.5);plot(smooth(mean(qhfilterednonextr(:,1:40))./1000,smoothamts(regord)),'linewidth',1.5);
            title('Qh (ocean)','fontsize',12,'fontweight','bold','fontname','arial');set(gca,'fontsize',10,'fontweight','bold','fontname','arial');
            ylim([qhy1(subreg) qhy2(subreg)]);xlim([1 40]);set(gca,'xtick',xtickrange);xticklabels(thesexticklabels_short);xtickangle(45);

            subplot(3*multiplyfirst,2,3*multiplythird+addthird);hold on;
            plot(smooth(mean(qlfilteredextr(:,1:40))./1000,smoothamts(regord)),'r','linewidth',1.5);plot(smooth(mean(qlfilterednonextr(:,1:40))./1000,smoothamts(regord)),'linewidth',1.5);
            title('Ql (ocean)','fontsize',12,'fontweight','bold','fontname','arial');set(gca,'fontsize',10,'fontweight','bold','fontname','arial');
            ylim([qly1(subreg) qly2(subreg)]);xlim([1 40]);set(gca,'xtick',xtickrange);xticklabels(thesexticklabels_short);xtickangle(45);

            subplot(3*multiplyfirst,2,4*multiplythird+addthird);hold on;
            plot(smooth(mean(pblhfilteredextr(:,1:40)),smoothamts(regord)),'r','linewidth',1.5);plot(smooth(mean(pblhfilterednonextr(:,1:40)),smoothamts(regord)),'linewidth',1.5);
            set(gca,'yscale','log');title('PBL Height (ocean)','fontsize',12,'fontweight','bold','fontname','arial');
            set(gca,'fontsize',10,'fontweight','bold','fontname','arial');ylim([pblhy1(subreg) pblhy2(subreg)]);xlim([1 40]);
            set(gca,'ytick',[100;250;500;1000;2000],'yticklabels',{'100';'250';'500';'1000';'2000'});set(gca,'xtick',xtickrange);xticklabels(thesexticklabels_short);xtickangle(45);

            subplot(3*multiplyfirst,2,5*multiplythird+addthird);hold on;
            plot(smooth(winddirfromuandv(mean(ufilteredextr(:,1:40)),mean(vfilteredextr(:,1:40))),smoothamts(regord)),'r','linewidth',1.5);
            plot(smooth(mean(winddirfromuandv(ufilterednonextr(:,1:40),vfilterednonextr(:,1:40))),smoothamts(regord)),'linewidth',1.5);
            title('Wind Direction (ocean)','fontsize',12,'fontweight','bold','fontname','arial');ylim([0 360]);
            set(gca,'fontsize',10,'fontweight','bold','fontname','arial');set(gca,'xtick',xtickrange);xlim([1 40]);set(gca,'ytick',[90:90:360],'yticklabel',{'90';'180';'270';'360'});
            xticklabels(thesexticklabels_short);xtickangle(45);

            subplot(3*multiplyfirst,2,6*multiplythird+addthird);hold on;
            plot(smooth(sqrt(mean(ufilteredextr(:,1:40)).^2+mean(vfilteredextr(:,1:40).^2)),smoothamts(regord)),'r','linewidth',1.5);
            plot(smooth(sqrt(mean(ufilterednonextr(:,1:40)).^2+mean(vfilterednonextr(:,1:40)).^2),smoothamts(regord)),'linewidth',1.5);
            title('Wind Speed (ocean)','fontsize',12,'fontweight','bold','fontname','arial');set(gca,'fontsize',10,'fontweight','bold','fontname','arial');xlim([1 40]);ylim([0 windspdy2(1)]);set(gca,'xtick',xtickrange);
            xticklabels(thesexticklabels_full);xtickangle(45);
        end
        
        figname=strcat('actualtimeseries_',subregname);curpart=2;highqualityfiguresetup;
        
        
        
        
        %If doing T/Td conversion for ease of interpretation
        if subreg==1
            if inclttdextension==1
                figure(1111);clf;curpart=1;highqualityfiguresetup;
                subplot(2,2,1);hold on;
                plot(mean(qhfilteredextr_pgland./1048.*1000)-273.15,'r','linewidth',1.5);hold on;plot(mean(qhfilterednonextr_pgland./1048.*1000)-273.15,'linewidth',1.5);title('T (land)','fontsize',12,'fontweight','bold','fontname','arial');
                    set(gca,'fontsize',10,'fontweight','bold','fontname','arial');set(gca,'xtick',xtickrange);xticklabels(thesexticklabels_short);xtickangle(45);
                subplot(2,2,3);hold on;
                for ii=1:size(qlfilteredextr_pgland,1)
                    for jj=1:size(qlfilteredextr_pgland,2)
                        omega=qlfilteredextr_pgland(ii,jj)./2424.*1000;mindiff=1000;psfc=10^5;
                        for testtd=-10:40;resultomega=calcqfromTd_dynamicP(testtd,psfc);thisdiff=abs(omega-resultomega);if thisdiff<mindiff;besttd=testtd;mindiff=thisdiff;end;end
                        tdfilteredextr_pgland(ii,jj)=besttd;
                    end
                end
                for ii=1:size(qlfilterednonextr_pgland,1)
                    for jj=1:size(qlfilterednonextr_pgland,2)
                        omega=qlfilterednonextr_pgland(ii,jj)./2424.*1000;mindiff=1000;psfc=10^5;
                        for testtd=-10:40;resultomega=calcqfromTd_dynamicP(testtd,psfc);thisdiff=abs(omega-resultomega);if thisdiff<mindiff;besttd=testtd;mindiff=thisdiff;end;end
                        tdfilterednonextr_pgland(ii,jj)=besttd;
                    end
                end       
                plot(mean(tdfilteredextr_pgland),'r','linewidth',1.5);hold on;plot(mean(tdfilterednonextr_pgland),'linewidth',1.5);title('Td (land)','fontsize',12,'fontweight','bold','fontname','arial');
                set(gca,'fontsize',10,'fontweight','bold','fontname','arial');set(gca,'xtick',xtickrange);
                xticklabels(thesexticklabels);xtickangle(45);


                subplot(2,2,2);hold on;
                plot(mean(qhfilteredextr_pgocean./1048.*1000)-273.15,'r','linewidth',1.5);hold on;plot(mean(qhfilterednonextr_pgocean./1048.*1000)-273.15,'linewidth',1.5);title('T (water)','fontsize',12,'fontweight','bold','fontname','arial');
                    set(gca,'fontsize',10,'fontweight','bold','fontname','arial');set(gca,'xtick',xtickrange);xticklabels(thesexticklabels_short);xtickangle(45);
                subplot(2,2,4);hold on;
                for ii=1:size(qlfilteredextr_pgocean,1)
                    for jj=1:size(qlfilteredextr_pgocean,2)
                        omega=qlfilteredextr_pgocean(ii,jj)./2424.*1000;mindiff=1000;psfc=10^5;
                        for testtd=-10:40;resultomega=calcqfromTd_dynamicP(testtd,psfc);thisdiff=abs(omega-resultomega);if thisdiff<mindiff;besttd=testtd;mindiff=thisdiff;end;end
                        tdfilteredextr_pgocean(ii,jj)=besttd;
                    end
                end
                for ii=1:size(qlfilterednonextr_pgocean,1)
                    for jj=1:size(qlfilterednonextr_pgocean,2)
                        omega=qlfilterednonextr_pgocean(ii,jj)./2424.*1000;mindiff=1000;psfc=10^5;
                        for testtd=-10:40;resultomega=calcqfromTd_dynamicP(testtd,psfc);thisdiff=abs(omega-resultomega);if thisdiff<mindiff;besttd=testtd;mindiff=thisdiff;end;end
                        tdfilterednonextr_pgocean(ii,jj)=besttd;
                    end
                end       
                plot(mean(tdfilteredextr_pgocean),'r','linewidth',1.5);hold on;plot(mean(tdfilterednonextr_pgocean),'linewidth',1.5);title('Td (water)','fontsize',12,'fontweight','bold','fontname','arial');
                set(gca,'fontsize',10,'fontweight','bold','fontname','arial');
                xticklabels(thesexticklabels);xtickangle(45);

                figname='actualtimeseriessupplement_pg';curpart=2;highqualityfiguresetup;
            end
        elseif subreg==2                    
            if inclttdextension==1
                figure(2222);clf;curpart=1;highqualityfiguresetup;
                subplot(2,1,1);hold on;
                plot(mean(qhfilteredextr_pak./1048.*1000)-273.15,'r','linewidth',1.5);hold on;plot(mean(qhfilterednonextr_pak./1048.*1000)-273.15,'linewidth',1.5);title('T','fontsize',12,'fontweight','bold','fontname','arial');
                    set(gca,'fontsize',10,'fontweight','bold','fontname','arial');set(gca,'xtick',xtickrange);xticklabels(thesexticklabels_short);xtickangle(45);
                subplot(2,1,2);hold on;
                for ii=1:size(qlfilteredextr_pak,1)
                    for jj=1:size(qlfilteredextr_pak,2)
                        omega=qlfilteredextr_pak(ii,jj)./2424.*1000;mindiff=1000;psfc=10^5;
                        for testtd=-10:40;resultomega=calcqfromTd_dynamicP(testtd,psfc);thisdiff=abs(omega-resultomega);if thisdiff<mindiff;besttd=testtd;mindiff=thisdiff;end;end
                        tdfilteredextr_pak(ii,jj)=besttd;
                    end
                end
                for ii=1:size(qlfilterednonextr_pak,1)
                    for jj=1:size(qlfilterednonextr_pak,2)
                        omega=qlfilterednonextr_pak(ii,jj)./2424.*1000;mindiff=1000;psfc=10^5;
                        for testtd=-10:40;resultomega=calcqfromTd_dynamicP(testtd,psfc);thisdiff=abs(omega-resultomega);if thisdiff<mindiff;besttd=testtd;mindiff=thisdiff;end;end
                        tdfilterednonextr_pak(ii,jj)=besttd;
                    end
                end       
                plot(mean(tdfilteredextr_pak),'r','linewidth',1.5);hold on;plot(mean(tdfilterednonextr_pak),'linewidth',1.5);title('Td','fontsize',12,'fontweight','bold','fontname','arial');
                set(gca,'fontsize',10,'fontweight','bold','fontname','arial');set(gca,'xtick',xtickrange);
                xticklabels(thesexticklabels);xtickangle(45);

                figname='actualtimeseriessupplement_pak';curpart=2;highqualityfiguresetup;
            end
        elseif subreg==3
            if inclttdextension==1
                figure(3333);clf;curpart=1;highqualityfiguresetup;
                subplot(2,1,1);hold on;
                plot(mean(qhfilteredextr_eind./1048.*1000)-273.15,'r','linewidth',1.5);hold on;plot(mean(qhfilterednonextr_eind./1048.*1000)-273.15,'linewidth',1.5);title('T','fontsize',12,'fontweight','bold','fontname','arial');
                    set(gca,'fontsize',10,'fontweight','bold','fontname','arial');set(gca,'xtick',xtickrange);xticklabels(thesexticklabels_short);xtickangle(45);
                subplot(2,1,2);hold on;
                for ii=1:size(qlfilteredextr_eind,1)
                    for jj=1:size(qlfilteredextr_eind,2)
                        omega=qlfilteredextr_eind(ii,jj)./2424.*1000;mindiff=1000;psfc=10^5;
                        for testtd=-10:40;resultomega=calcqfromTd_dynamicP(testtd,psfc);thisdiff=abs(omega-resultomega);if thisdiff<mindiff;besttd=testtd;mindiff=thisdiff;end;end
                        tdfilteredextr_eind(ii,jj)=besttd;
                    end
                end
                for ii=1:size(qlfilterednonextr_eind,1)
                    for jj=1:size(qlfilterednonextr_eind,2)
                        omega=qlfilterednonextr_eind(ii,jj)./2424.*1000;mindiff=1000;psfc=10^5;
                        for testtd=-10:40;resultomega=calcqfromTd_dynamicP(testtd,psfc);thisdiff=abs(omega-resultomega);if thisdiff<mindiff;besttd=testtd;mindiff=thisdiff;end;end
                        tdfilterednonextr_eind(ii,jj)=besttd;
                    end
                end       
                plot(mean(tdfilteredextr_eind),'r','linewidth',1.5);hold on;plot(mean(tdfilterednonextr_eind),'linewidth',1.5);title('Td','fontsize',12,'fontweight','bold','fontname','arial');
                set(gca,'fontsize',10,'fontweight','bold','fontname','arial');set(gca,'xtick',xtickrange);
                xticklabels(thesexticklabels);xtickangle(45);

                figname='actualtimeseriessupplement_eind';curpart=2;highqualityfiguresetup;
            end
        elseif subreg==5 
            if inclttdextension==1
                figure(5555);clf;curpart=1;highqualityfiguresetup;
                subplot(2,1,1);hold on;
                plot(mean(qhfilteredextr_wamaz./1048.*1000)-273.15,'r','linewidth',1.5);hold on;plot(mean(qhfilterednonextr_wamaz./1048.*1000)-273.15,'linewidth',1.5);title('T','fontsize',12,'fontweight','bold','fontname','arial');
                    set(gca,'fontsize',10,'fontweight','bold','fontname','arial');set(gca,'xtick',xtickrange);xticklabels(thesexticklabels_short);xtickangle(45);xlim([1 39]);
                subplot(2,1,2);hold on;
                for ii=1:size(qlfilteredextr_wamaz,1)
                    for jj=1:size(qlfilteredextr_wamaz,2)
                        omega=qlfilteredextr_wamaz(ii,jj)./2424.*1000;mindiff=1000;psfc=10^5;
                        for testtd=-10:40;resultomega=calcqfromTd_dynamicP(testtd,psfc);thisdiff=abs(omega-resultomega);if thisdiff<mindiff;besttd=testtd;mindiff=thisdiff;end;end
                        tdfilteredextr_wamaz(ii,jj)=besttd;
                    end
                end
                for ii=1:size(qlfilterednonextr_wamaz,1)
                    for jj=1:size(qlfilterednonextr_wamaz,2)
                        omega=qlfilterednonextr_wamaz(ii,jj)./2424.*1000;mindiff=1000;psfc=10^5;
                        for testtd=-10:40;resultomega=calcqfromTd_dynamicP(testtd,psfc);thisdiff=abs(omega-resultomega);if thisdiff<mindiff;besttd=testtd;mindiff=thisdiff;end;end
                        tdfilterednonextr_wamaz(ii,jj)=besttd;
                    end
                end       
                plot(mean(tdfilteredextr_wamaz),'r','linewidth',1.5);hold on;plot(mean(tdfilterednonextr_wamaz),'linewidth',1.5);title('Td','fontsize',12,'fontweight','bold','fontname','arial');
                set(gca,'fontsize',10,'fontweight','bold','fontname','arial');set(gca,'xtick',xtickrange);xlim([1 39]);
                xticklabels(thesexticklabels_full);xtickangle(45);

                figname='actualtimeseriessupplement_wamaz';curpart=2;highqualityfiguresetup;
            end
        end
        end
    end
end


if venndiagram==1
    exist maxmsebypoint;
    if ans==0
        thisfile=load('/Volumes/ExternalDriveZ/ERA5_Hourly_Data/mseqhqlstats');
        maxmsebypoint=thisfile.maxmsebypoint;p999msebypoint=thisfile.p999msebypoint;p99msebypoint=thisfile.p99msebypoint;p50msebypoint=thisfile.p50msebypoint;
    end
    if dosw==1
        dailysw=NaN.*ones(10,365,321,1440);dailylw=NaN.*ones(10,365,321,1440);
        for year=2009:2018
            %A. Net surface shortwave and longwave radiation, in J/m^2
            file=ncgeodataset(strcat('/Volumes/ExternalDriveF/ERA5_variousvariables/sfcnetrad_world_',num2str(year),'.grib'));
            sfcswtemp=file{'Surface_solar_radiation_surface_1_Hour_Accumulation'};echo off;
            sfclwtemp=file{'Surface_thermal_radiation_surface_1_Hour_Accumulation'};echo off;
            clear file;

            for doy=1:365
                dailysw(year-2008,doy,:,:)=squeeze(mean(double(sfcswtemp.data(doy*8-7:doy*8,181:501,:)))); %centered on 180
                dailylw(year-2008,doy,:,:)=squeeze(mean(double(sfclwtemp.data(doy*8-7:doy*8,181:501,:)))); %centered on 180
            end
            clear sfcswtemp;clear sfclwtemp;
            disp(year);
        end
        dailysw3d=reshape(dailysw,[size(dailysw,1)*size(dailysw,2) size(dailysw,3) size(dailysw,4)]);
        p99swbypoint=squeeze(quantile(dailysw3d,0.99));p90swbypoint=squeeze(quantile(dailysw3d,0.9));p50swbypoint=squeeze(quantile(dailysw3d,0.5));
            p10swbypoint=squeeze(quantile(dailysw3d,0.1));p1swbypoint=squeeze(quantile(dailysw3d,0.01));clear dailysw;
        dailylw3d=reshape(dailylw,[size(dailylw,1)*size(dailylw,2) size(dailylw,3) size(dailylw,4)]);
        p99lwbypoint=squeeze(quantile(dailylw3d,0.99));p90lwbypoint=squeeze(quantile(dailylw3d,0.9));p50lwbypoint=squeeze(quantile(dailylw3d,0.5));
            p10lwbypoint=squeeze(quantile(dailylw3d,0.1));p1lwbypoint=squeeze(quantile(dailylw3d,0.01));clear dailylw;
        save('/Volumes/ExternalDriveZ/ERA5_HHLcalcs/venndiagramarrays.mat',...
            'p99swbypoint','p90swbypoint','p50swbypoint','p10swbypoint','p1swbypoint','p99lwbypoint','p90lwbypoint','p50lwbypoint','p10lwbypoint','p1lwbypoint','-append');disp(clock);
        
        dothis=0;
        if dothis==1
            p90lwbypoint=cat(1,NaN.*ones(200,1440),p90lwbypoint,NaN.*ones(200,1440));
            p50lwbypoint=cat(1,NaN.*ones(200,1440),p50lwbypoint,NaN.*ones(200,1440));
            p10lwbypoint=cat(1,NaN.*ones(200,1440),p10lwbypoint,NaN.*ones(200,1440));
            
            figure(201);clf;curpart=1;highqualityfiguresetup;
            thisarr=[p90swbypoint(:,721:1440) p90swbypoint(:,1:720)];
            data={era5latarray;era5lonarray;thisarr};
            vararginnew={'datatounderlay';data;'underlaycaxismin';2.5*10^5;'underlaycaxismax';12.5*10^5;'mystepunderlay';0.5*10^5;...
                    'underlaycolormap';colormaps('blueyellowred','more','not');'variable';'temperature';'overlaynow';0;'nonewfig';1};
            datatype='custom';region='world';
            plotModelData(data,region,vararginnew,datatype);
            set(gca,'Position',[0.01 0.53 0.45 0.35]);
            
            subplot(2,2,2);
            thisarr=[p50swbypoint(:,721:1440) p50swbypoint(:,1:720)];
            data={era5latarray;era5lonarray;thisarr};
            vararginnew={'datatounderlay';data;'underlaycaxismin';2*10^5;'underlaycaxismax';10*10^5;'mystepunderlay';0.5*10^5;...
                    'underlaycolormap';colormaps('blueyellowred','more','not');'variable';'temperature';'overlaynow';0;'nonewfig';1};
            datatype='custom';region='world';
            plotModelData(data,region,vararginnew,datatype);
            set(gca,'Position',[0.5 0.53 0.45 0.35]);
            
            subplot(2,2,3);
            thisarr=[p10lwbypoint(:,721:1440) p10lwbypoint(:,1:720)];
            data={era5latarray;era5lonarray;-thisarr};
            vararginnew={'datatounderlay';data;'underlaycaxismin';1*10^5;'underlaycaxismax';7.5*10^5;'mystepunderlay';0.5*10^5;...
                    'underlaycolormap';colormaps('blueyellowred','more','not');'variable';'wet-bulb temperature';'overlaynow';0;'nonewfig';1};
            datatype='custom';region='world';
            plotModelData(data,region,vararginnew,datatype);
            set(gca,'Position',[0.01 0.02 0.45 0.35]);
            
            subplot(2,2,4);
            thisarr=[p50lwbypoint(:,721:1440) p50lwbypoint(:,1:720)];
            data={era5latarray;era5lonarray;-thisarr};
            vararginnew={'datatounderlay';data;'underlaycaxismin';0*10^5;'underlaycaxismax';6*10^5;'mystepunderlay';0.5*10^5;...
                    'underlaycolormap';colormaps('blueyellowred','more','not');'variable';'wet-bulb temperature';'overlaynow';0;'nonewfig';1};
            datatype='custom';region='world';
            plotModelData(data,region,vararginnew,datatype);
            set(gca,'Position',[0.5 0.02 0.45 0.35]);
            
            figname='swlwmaps';curpart=2;highqualityfiguresetup;
        end
    end
    
    if dolhf==1
        setup_nctoolbox;
        dailylhf=NaN.*ones(10,365,321,1440);
        for year=2013:2018
            %B. Surface latent-heat flux
            file=ncgeodataset(strcat('/Volumes/ExternalDriveD/ERA5_variousvariables/sfcsensiblelatentflux_world_',num2str(year),'.grib'));
            sfclhftemp=file{'Surface_latent_heat_flux_surface_1_Hour_Accumulation'};echo off;clear file;

            for doy=1:365
                dailylhf(year-2008,doy,:,:)=squeeze(mean(double(sfclhftemp.data(doy*8-7:doy*8,181:501,:)))); %centered on 180
            end
            clear sfclhftemp;
        end
        dailylhf3d=reshape(dailylhf,[size(dailylhf,1)*size(dailylhf,2) size(dailylhf,3) size(dailylhf,4)]);clear dailylhf;
        p90lhfbypoint=squeeze(quantile(dailylhf3d,0.9));p50lhfbypoint=squeeze(quantile(dailylhf3d,0.5));p10lhfbypoint=squeeze(quantile(dailylhf3d,0.1));clear dailylhf3d;
        save('/Volumes/ExternalDriveZ/ERA5_HHLcalcs/venndiagramarrays.mat','p90lhfbypoint','p50lhfbypoint','p10lhfbypoint','-append');disp(clock);
    end
    
    if doshf==1
        setup_nctoolbox;
        dailyshf=NaN.*ones(10,365,321,1440);
        for year=2009:2018
            %B. Surface sensible-heat flux
            file=ncgeodataset(strcat('/Volumes/ExternalDriveD/ERA5_variousvariables/sfcsensiblelatentflux_world_',num2str(year),'.grib'));
            sfcshftemp=file{'Surface_sensible_heat_flux_surface_1_Hour_Accumulation'};echo off;clear file;

            for doy=1:365
                dailyshf(year-2008,doy,:,:)=squeeze(mean(double(sfcshftemp.data(doy*8-7:doy*8,181:501,:)))); %centered on 180
            end
            clear sfcshftemp;disp(year);
        end
        dailyshf3d=reshape(dailyshf,[size(dailyshf,1)*size(dailyshf,2) size(dailyshf,3) size(dailyshf,4)]);clear dailyshf;
        p90shfbypoint=squeeze(quantile(dailyshf3d,0.9));p50shfbypoint=squeeze(quantile(dailyshf3d,0.5));clear dailyshf3d;
        save('/Volumes/ExternalDriveZ/ERA5_HHLcalcs/venndiagramarrays.mat','p90shfbypoint','p50shfbypoint','-append');disp(clock);
    end
    
    dothis=0;
    if dothis==1
    dailyomega850=NaN.*ones(10,365,321,1440);
    for year=2009:2018
        %C. Surface latent-heat flux
        file=ncgeodataset(strcat('/Volumes/ExternalDriveZ/ERA5_Hourly_Data/vv_world_levels_',num2str(year),'.grib'));
        omegatemp=file{'Vertical_velocity_isobaric'};echo off;clear file;
        dailyomega850(year-2008,:,:,:)=squeeze(double(omegatemp.data(1:365,5,:,:))); %centered on 0
        clear omegatemp;
    end
    dailyomega8503d=reshape(dailyomega850,[size(dailyomega850,1)*size(dailyomega850,2) size(dailyomega850,3) size(dailyomega850,4)]);clear dailyomega850;
    p90omega850bypoint=squeeze(quantile(dailyomega8503d,0.9));p90omega850bypoint=[p90omega850bypoint(:,721:1440) p90omega850bypoint(:,1:720)];
    p50omega850bypoint=squeeze(quantile(dailyomega8503d,0.5));p50omega850bypoint=[p50omega850bypoint(:,721:1440) p50omega850bypoint(:,1:720)];
    save('/Volumes/ExternalDriveZ/ERA5_HHLcalcs/venndiagramarrays.mat','p90omega850bypoint','p50omega850bypoint','-append');disp(clock);
    end
    
    if douvandw==1
        dailyu950=NaN.*ones(7,365,281,1440);dailyv950=NaN.*ones(7,365,281,1440);dailyw850=NaN.*ones(7,365,281,1440);dailyw300=NaN.*ones(7,365,281,1440);
        for year=2012:2018
            %D. Mean ~950-mb winds (to be combined with SSTs)
            %Also, mean 850mb omega
            %Model levels saved are 200, 300, 500, 700, 850, 900, 950, 975, 990, 1000, 1006, 1012
            if year==2012
                startmonth=5;stopmonth=9;
            elseif year==2013
                startmonth=5;stopmonth=12;
            elseif year<=2017
                startmonth=1;stopmonth=12;
            elseif year==2018
                startmonth=1;stopmonth=10;
            end
            for month=startmonth:stopmonth
                if month~=3 && month~=4
                    if month<=9;mzero='0';else;mzero='';end
                    if year>=2014
                        file=ncgeodataset(strcat('/Volumes/ExternalDriveD/ERA5_modelleveldata/uvw_',num2str(year),mzero,num2str(month),'.grib'));
                    else
                        file=ncgeodataset(strcat('/Volumes/ExternalDriveF/ERA5_modelleveldata_0000to2013/uvw_',num2str(year),mzero,num2str(month),'.grib'));
                    end
                    utemp=file{'u'};vtemp=file{'v'};wtemp=file{'w'};echo off;clear file;

                    for doy=monstarts(month):monstops(month)
                        dom=doy-monstarts(month)+1;
                        dailyu950(year-2011,doy,:,201:1361)=squeeze(mean(double(utemp.data(dom*8-7:dom*8,7,:,:)))); %centered on 0
                        dailyv950(year-2011,doy,:,201:1361)=squeeze(mean(double(vtemp.data(dom*8-7:dom*8,7,:,:))));
                        dailyw850(year-2011,doy,:,201:1361)=squeeze(mean(double(wtemp.data(dom*8-7:dom*8,5,:,:))));
                        dailyw300(year-2011,doy,:,201:1361)=squeeze(mean(double(wtemp.data(dom*8-7:dom*8,2,:,:))));
                    end
                    clear omegatemp;
                end
            end
            disp(year);
        end
        exist topmonths;
        if ans==0
            file=load('/Volumes/ExternalDriveZ/ERA5_Hourly_Data/climtopmsedays');
            topmonths=file.topmonths;secondtopmonths=file.secondtopmonths;thirdtopmonths=file.thirdtopmonths;
        end
        topmonths_321x1440=topmonths(201:521,:);secondtopmonths_321x1440=secondtopmonths(201:521,:);thirdtopmonths_321x1440=thirdtopmonths(201:521,:);
        topmonths_321x1440=[topmonths_321x1440(:,721:1440) topmonths_321x1440(:,1:720)];
        secondtopmonths_321x1440=[secondtopmonths_321x1440(:,721:1440) secondtopmonths_321x1440(:,1:720)];
        thirdtopmonths_321x1440=[thirdtopmonths_321x1440(:,721:1440) thirdtopmonths_321x1440(:,1:720)]; %centered on 0
        
        exist dates_local;
        if ans==0
            temp=load('/Volumes/ExternalDriveZ/ERA5_Hourly_Data/variabilitystats_local');dates_local=temp.dates_local;
        end
        for row=1:721
            for col=1:1440
                if col>720;colalt=col-720;else;colalt=col+720;end
                dates_local_centeredon0{row,col}=dates_local{row,colalt};
            end
        end
        
        for row=1:281
            for col=1:1440
                %for mon=1:12
                    %if topmonths_321x1440(row,col)==mon || secondtopmonths_321x1440(row,col)==mon || thirdtopmonths_321x1440(row,col)==mon
                    %else
                    %    dailyu950(:,monstarts(mon):monstops(mon),row,col)=NaN;
                    %    dailyv950(:,monstarts(mon):monstops(mon),row,col)=NaN;
                    %    dailyw850(:,monstarts(mon):monstops(mon),row,col)=NaN;
                    %end
                %end
                thesedates=dates_local_centeredon0{row+200,col};
                for year=2012:2018
                    for doy=1:365
                        datefound=0;
                        for rowinthesedates=1:size(thesedates,1)
                            if thesedates(rowinthesedates,1)==year && thesedates(rowinthesedates,2)==doy
                                datefound=1; %this is a high-MSE day
                            end
                        end
                        if datefound==0
                            dailyu950(year-2011,doy,row,col)=NaN;
                            dailyv950(year-2011,doy,row,col)=NaN;
                            dailyw850(year-2011,doy,row,col)=NaN;
                            dailyw300(year-2011,doy,row,col)=NaN;
                        end
                    end
                end
            end
        end
        dailyu9503d=reshape(dailyu950,[size(dailyu950,1)*size(dailyu950,2) size(dailyu950,3) size(dailyu950,4)]);clear dailyu950;
        p50u950bypoint=squeeze(quantile(dailyu9503d,0.5));
        p50u950bypoint=cat(1,NaN.*ones(200,1440),p50u950bypoint,NaN.*ones(240,1440));
        p50u950bypoint=[p50u950bypoint(:,721:1440) p50u950bypoint(:,1:720)]; %now, centered on 180
        dailyv9503d=reshape(dailyv950,[size(dailyv950,1)*size(dailyv950,2) size(dailyv950,3) size(dailyv950,4)]);clear dailyv950;
        p50v950bypoint=squeeze(quantile(dailyv9503d,0.5));
        p50v950bypoint=cat(1,NaN.*ones(200,1440),p50v950bypoint,NaN.*ones(240,1440));
        p50v950bypoint=[p50v950bypoint(:,721:1440) p50v950bypoint(:,1:720)]; %now, centered on 180
        dailyw8503d=reshape(dailyw850,[size(dailyw850,1)*size(dailyw850,2) size(dailyw850,3) size(dailyw850,4)]);clear dailyw850;
        p50w850bypoint=squeeze(quantile(dailyw8503d,0.5));
        p50w850bypoint=cat(1,NaN.*ones(200,1440),p50w850bypoint,NaN.*ones(240,1440));
        p50w850bypoint=[p50w850bypoint(:,721:1440) p50w850bypoint(:,1:720)]; %now, centered on 180
        dailyw3003d=reshape(dailyw300,[size(dailyw300,1)*size(dailyw300,2) size(dailyw300,3) size(dailyw300,4)]);clear dailyw300;
        p50w300bypoint=squeeze(quantile(dailyw3003d,0.5));
        p50w300bypoint=cat(1,NaN.*ones(200,1440),p50w300bypoint,NaN.*ones(240,1440));
        p50w300bypoint=[p50w300bypoint(:,721:1440) p50w300bypoint(:,1:720)]; %now, centered on 180
        %p50u950bypoint_localp99mseonly=p50u950bypoint;%p50v950bypoint_localp99mseonly=p50v950bypoint;%p50w850bypoint_localp99mseonly=p50w850bypoint;
        save('/Volumes/ExternalDriveZ/ERA5_HHLcalcs/venndiagramarrays.mat','p50u950bypoint','p50v950bypoint','p50w850bypoint','p50w300bypoint','-append');disp(clock);
    end
    
    if domss1000500==1
        %dailyt=NaN.*ones(10,365,321,1440);dailytd=NaN.*ones(10,365,321,1440);
        dailyq500=NaN.*ones(10,365,321,1440);dailyt500=NaN.*ones(10,365,321,1440);
        for year=2014:2018   
            %E. Moist static stability 1000-500
            %file=ncgeodataset(strcat('/Volumes/ExternalDriveZ/ERA5_Hourly_Data/ttd_world_',num2str(year),'.grib'));
            %ttemp=file{'2_metre_temperature_surface'};echo off;
            %tdtemp=file{'2_metre_dewpoint_temperature_surface'};echo off;clear file;
            %for doy=1:365
            %    dailyt(year-2008,doy,:,:)=squeeze(mean(double(ttemp.data(doy*8-7:doy*8,201:521,:)))); %centered on 180
            %    dailytd(year-2008,doy,:,:)=squeeze(mean(double(tdtemp.data(doy*8-7:doy*8,201:521,:))));
            %end
            %clear ttemp;clear tdtemp;

            file=ncgeodataset(strcat('/Volumes/ExternalDriveD/ERA5_Tq_vertprofiles_only/tq_500_world_',num2str(year),'.grib'));
            q500temp=file{'Specific_humidity_isobaric'};t500temp=file{'Temperature_isobaric'};echo off;clear file;
            for doy=1:365
                dailyq500(year-2008,doy,:,:)=squeeze(mean(double(q500temp.data(doy*8-7:doy*8,1,180:500,:))));
                dailyt500(year-2008,doy,:,:)=squeeze(mean(double(t500temp.data(doy*8-7:doy*8,1,201:521,:))));
            end
            clear q500temp;clear t500temp;
            disp(year);
        end
        %thetae_1000=calcthetaefromTandTd(dailyt-273.15,dailytd-273.15,1000.*ones(size(dailyt,1),size(dailyt,2),size(dailyt,3),size(dailyt,4)));clear dailyt;clear dailytd;
        thetae_500=calcthetaefromTandTd(dailyt500-273.15,calcTdfromq(dailyq500.*1000,500),500.*ones(size(dailyt500,1),size(dailyt500,2),size(dailyt500,3),size(dailyt500,4)));clear dailyt500;clear dailyq500;
        %mss=thetae_1000-thetae_500;clear thetae_1000;
        %mss3d=reshape(mss,[size(mss,1)*size(mss,2) size(mss,3) size(mss,4)]);
        %p90mssbypoint=quantile(mss3d,0.9);
        thetae_5003d=reshape(thetae_500,[size(thetae_500,1)*size(thetae_500,2) size(thetae_500,3) size(thetae_500,4)]);
        p90thetae500bypoint=squeeze(quantile(thetae_5003d,0.9));
        save('/Volumes/ExternalDriveZ/ERA5_HHLcalcs/venndiagramarrays.mat','p90mssbypoint','p90thetae500bypoint','-append');disp(clock);
    end

    if domss850300==1
        dailyt850=NaN.*ones(5,365,321,1440);dailyq850=NaN.*ones(5,365,321,1440);
        dailyq300=NaN.*ones(5,365,321,1440);dailyt300=NaN.*ones(5,365,321,1440);
        for year=2014:2018   
            %F. Moist static stability 850-300
            file=ncgeodataset(strcat('/Volumes/ExternalDriveD/ERA5_Tq_vertprofiles_only/tq_850_world_',num2str(year),'.grib')); %40N-40S, i.e. 201-521
            q850temp=file{'Specific_humidity_isobaric'};t850temp=file{'Temperature_isobaric'};echo off;clear file;
            for doy=1:365
                dailyq850(year-2013,doy,:,:)=squeeze(mean(double(q850temp.data(doy*8-7:doy*8,1,:,:))));
                dailyt850(year-2013,doy,:,:)=squeeze(mean(double(t850temp.data(doy*8-7:doy*8,1,:,:))));
            end
            clear t850temp;clear q850temp;

            file=ncgeodataset(strcat('/Volumes/ExternalDriveD/ERA5_Tq_vertprofiles_only/tq_300_world_',num2str(year),'.grib'));
            q300temp=file{'Specific_humidity_isobaric'};t300temp=file{'Temperature_isobaric'};echo off;clear file;
            for doy=1:365
                dailyq300(year-2013,doy,:,:)=squeeze(mean(double(q300temp.data(doy*8-7:doy*8,1,:,:))));
                dailyt300(year-2013,doy,:,:)=squeeze(mean(double(t300temp.data(doy*8-7:doy*8,1,:,:))));
            end
            clear q300temp;clear t300temp;
            disp(year);
        end
        topmonths_321x1440=topmonths(201:521,:);secondtopmonths_321x1440=secondtopmonths(201:521,:);thirdtopmonths_321x1440=thirdtopmonths(201:521,:); %centered on 180
        topmonths_321x1440=[topmonths_321x1440(:,721:1440) topmonths_321x1440(:,1:720)];
        secondtopmonths_321x1440=[secondtopmonths_321x1440(:,721:1440) secondtopmonths_321x1440(:,1:720)];
        thirdtopmonths_321x1440=[thirdtopmonths_321x1440(:,721:1440) thirdtopmonths_321x1440(:,1:720)];
        for row=1:321
            for col=1:1440
                for mon=1:12
                    if topmonths_321x1440(row,col)==mon || secondtopmonths_321x1440(row,col)==mon || thirdtopmonths_321x1440(row,col)==mon
                    else
                        dailyq850(:,monstarts(mon):monstops(mon),row,col)=NaN;dailyt850(:,monstarts(mon):monstops(mon),row,col)=NaN;
                        dailyq300(:,monstarts(mon):monstops(mon),row,col)=NaN;dailyt300(:,monstarts(mon):monstops(mon),row,col)=NaN;
                    end
                end
            end
        end
        thetae_850=calcthetaefromTandTd(dailyt850-273.15,calcTdfromq(dailyq850.*1000,850),850.*ones(size(dailyt850,1),size(dailyt850,2),size(dailyt850,3),size(dailyt850,4)));clear dailyt850;clear dailyq850;
        thetae_300=calcthetaefromTandTd(dailyt300-273.15,calcTdfromq(dailyq300.*1000,300),300.*ones(size(dailyt300,1),size(dailyt300,2),size(dailyt300,3),size(dailyt300,4)));clear dailyt300;clear dailyq300;
        mss=thetae_850-thetae_300;clear thetae_850;clear thetae_300;
        mss3d=reshape(mss,[size(mss,1)*size(mss,2) size(mss,3) size(mss,4)]);clear mss;
        p90mssbypoint_850300=squeeze(quantile(mss3d,0.9));p50mssbypoint_850300=squeeze(quantile(mss3d,0.5));
        save('/Volumes/ExternalDriveZ/ERA5_HHLcalcs/venndiagramarrays.mat','p90mssbypoint_850300','p50mssbypoint_850300','-append');disp(clock);
    end
    
    
    if domss700300==1
        exist topmonths;
        if ans==0
            file=load('/Volumes/ExternalDriveZ/ERA5_Hourly_Data/climtopmsedays');
            topmonths=file.topmonths;secondtopmonths=file.secondtopmonths;thirdtopmonths=file.thirdtopmonths;
        end
        dailyt700=NaN.*ones(5,365,321,1440);dailyq700=NaN.*ones(5,365,321,1440);
        dailyq300=NaN.*ones(5,365,321,1440);dailyt300=NaN.*ones(5,365,321,1440);
        for year=2014:2018   
            %F. Moist static stability 700-300
            file=ncgeodataset(strcat('/Volumes/ExternalDriveD/ERA5_Tq_vertprofiles_only/tq_700_world_',num2str(year),'.grib')); %40N-40S, i.e. 201-521
            q700temp=file{'Specific_humidity_isobaric'};t700temp=file{'Temperature_isobaric'};echo off;clear file;
            for doy=1:365
                dailyq700(year-2013,doy,:,:)=squeeze(mean(double(q700temp.data(doy*8-7:doy*8,1,:,:))));
                dailyt700(year-2013,doy,:,:)=squeeze(mean(double(t700temp.data(doy*8-7:doy*8,1,:,:))));
            end
            clear t700temp;clear q700temp;

            file=ncgeodataset(strcat('/Volumes/ExternalDriveD/ERA5_Tq_vertprofiles_only/tq_300_world_',num2str(year),'.grib'));
            q300temp=file{'Specific_humidity_isobaric'};t300temp=file{'Temperature_isobaric'};echo off;clear file;
            for doy=1:365
                dailyq300(year-2013,doy,:,:)=squeeze(mean(double(q300temp.data(doy*8-7:doy*8,1,:,:))));
                dailyt300(year-2013,doy,:,:)=squeeze(mean(double(t300temp.data(doy*8-7:doy*8,1,:,:))));
            end
            clear q300temp;clear t300temp;
            disp(year);
        end
        topmonths_321x1440=topmonths(201:521,:);secondtopmonths_321x1440=secondtopmonths(201:521,:);thirdtopmonths_321x1440=thirdtopmonths(201:521,:); %centered on 180
        topmonths_321x1440=[topmonths_321x1440(:,721:1440) topmonths_321x1440(:,1:720)];
        secondtopmonths_321x1440=[secondtopmonths_321x1440(:,721:1440) secondtopmonths_321x1440(:,1:720)];
        thirdtopmonths_321x1440=[thirdtopmonths_321x1440(:,721:1440) thirdtopmonths_321x1440(:,1:720)];
        for row=1:321
            for col=1:1440
                for mon=1:12
                    if topmonths_321x1440(row,col)==mon || secondtopmonths_321x1440(row,col)==mon || thirdtopmonths_321x1440(row,col)==mon
                    else
                        dailyq700(:,monstarts(mon):monstops(mon),row,col)=NaN;dailyt700(:,monstarts(mon):monstops(mon),row,col)=NaN;
                        dailyq300(:,monstarts(mon):monstops(mon),row,col)=NaN;dailyt300(:,monstarts(mon):monstops(mon),row,col)=NaN;
                    end
                end
            end
        end
        thetae_700=calcthetaefromTandTd(dailyt700-273.15,calcTdfromq(dailyq700.*1000,700),700.*ones(size(dailyt700,1),size(dailyt700,2),size(dailyt700,3),size(dailyt700,4)));clear dailyt700;clear dailyq700;
        thetae_300=calcthetaefromTandTd(dailyt300-273.15,calcTdfromq(dailyq300.*1000,300),300.*ones(size(dailyt300,1),size(dailyt300,2),size(dailyt300,3),size(dailyt300,4)));clear dailyt300;clear dailyq300;
        mss=thetae_700-thetae_300;clear thetae_700;clear thetae_300;
        mss3d=reshape(mss,[size(mss,1)*size(mss,2) size(mss,3) size(mss,4)]);clear mss;
        p90mssbypoint_700300=squeeze(quantile(mss3d,0.9));p50mssbypoint_700300=squeeze(quantile(mss3d,0.5));
        save('/Volumes/ExternalDriveZ/ERA5_HHLcalcs/venndiagramarrays.mat','p90mssbypoint_700300','p50mssbypoint_700300','-append');disp(clock);
    end
    
    if dossts==1
        recalc=0;
        if recalc==1
            meandailysst=NaN.*ones(1440,720,365);
            for loop=1:4
                if loop==1;col1=1;col2=360;elseif loop==2;col1=361;col2=720;elseif loop==3;col1=721;col2=1080;elseif loop==4;col1=1081;col2=1440;end
                alldata=NaN.*ones(10,360,720,365);
                for year=2010:2019
                    for doy=1:365
                        thismon=DOYtoMonth(doy,2019);thisdom=DOYtoDOM(doy,2019);
                        if thisdom<=9;dzero='0';else;dzero='';end
                        if thismon<=9;mzero='0';else;mzero='';end
                        sstdata=ncread(strcat('/Volumes/ExternalDriveC/NOAA_OISST_Daily_Data/oisst-avhrr-v02r01.',num2str(year),mzero,num2str(thismon),dzero,num2str(thisdom),'.nc'),'sst');
                        alldata(year-2009,:,:,doy)=sstdata(col1:col2,:);
                    end
                    disp(year);
                end
                meandailysst(col1:col2,1:720,1:365)=squeeze(mean(alldata));clear alldata;disp(loop);
            end
            invalid=abs(meandailysst)>100;meandailysst(invalid)=NaN;
            save('/Volumes/ExternalDriveC/NOAA_OISST_Daily_Data/dailymeansst.mat','meandailysst','-v7.3');
        else
            temp=load('/Volumes/ExternalDriveC/NOAA_OISST_Daily_Data/dailymeansst.mat');meandailysst=temp.meandailysst;
            exist p50u950bypoint;
            if ans==0
                file=load('/Volumes/ExternalDriveZ/ERA5_HHLcalcs/venndiagramarrays.mat');
                p50u950bypoint=file.p50u950bypoint;p50v950bypoint=file.p50v950bypoint;p50w850bypoint=file.p50w850bypoint;
            end
        end
        
        clear newmeandailysst;
        for doy=1:365
            thisdoysst=squeeze(meandailysst(:,:,doy));
            thissstrot=flipud(thisdoysst'); %centered on 180
            newmeandailysst(:,:,doy)=thissstrot;
        end
        clear meandailysst;
        newmeandailysst=newmeandailysst(180:500,:,:);
        
        %SST for top 3 months of MSE
        exist topmonths;
        if ans==0
            t=load('/Volumes/ExternalDriveZ/ERA5_Hourly_Data/climtopmsedays');
            topmonths=t.topmonths;secondtopmonths=t.secondtopmonths;thirdtopmonths=t.thirdtopmonths;
        end
        topmonths_281x1440=topmonths(201:481,:);secondtopmonths_281x1440=secondtopmonths(201:481,:);thirdtopmonths_281x1440=thirdtopmonths(201:481,:); %centered on 180
        for row=21:301
            for col=1:1440
                for mon=1:12
                    if topmonths_281x1440(row-20,col)==mon || secondtopmonths_281x1440(row-20,col)==mon || thirdtopmonths_281x1440(row-20,col)==mon
                    else
                        newmeandailysst(row,col,monstarts(mon):monstops(mon))=NaN;
                    end
                end
            end
        end
        sst_3warmestmonths=squeeze(nanmean(newmeandailysst,3));
        sst_3warmestmonths=cat(1,NaN.*ones(180,1440),sst_3warmestmonths,NaN.*ones(220,1440));
        
        %Bring in winds
        p50winddir=winddirfromuandv(p50u950bypoint,p50v950bypoint);
        invalid=p50winddir==0;p50winddir(invalid)=NaN;
        p50windmag=sqrt(p50u950bypoint.^2+p50v950bypoint.^2);
        
        %Determine areas downwind of SST >=29C
        %Arrays are all centered on (or adjusted to center on) 180
        areasdownwindof29c=NaN.*ones(721,1440);areasdownwindof29pt5c=NaN.*ones(721,1440);areasdownwindof30c=NaN.*ones(721,1440);
        sstthreshs=[29;29.5;30];
        for sstindex=1:size(sstthreshs,1)
            sstthresh=sstthreshs(sstindex);
            for row=2:720
                for col=2:1439
                    if col<=720;colalt=col+720;else;colalt=col-720;end
                    %if sst_3warmestmonths(row,col)>=29
                    if (nanmean(nanmean(sst_3warmestmonths(row-1:row+1,col-1:col+1)))>=sstthresh && sum(sum(~isnan(sst_3warmestmonths(row-1:row+1,col-1:col+1))))>=5)
                        startinglat=era5latarray(row,col);startinglon=era5lonarray(row,colalt);
                        currentuwindspd=p50u950bypoint(row,col).*86400./(111000.*cos(startinglat*pi/180)); %in deg/day
                        currentvwindspd=p50v950bypoint(row,col).*86400./111000; %in deg/day
                        currenttotalwindspd=sqrt(currentuwindspd^2+currentvwindspd^2);
                        windangle=atan(currentvwindspd/currentuwindspd);
                        %Trace back along wind vector, stepping with intervals of 0.1 deg
                        %As soon as we encounter another gridcell, use that gridcell's wind vector instead
                        %That also means that gridcell is affected by the high-SST air
                        %Continue doing this until the total time has reached 48 hr
                        if currenttotalwindspd~=0
                            elapsedtime=0;distalongvector=0;distinterval=0.1;rowprev=row;colprev=col;
                            while elapsedtime<2 && distalongvector<=currenttotalwindspd
                                elapsedtime=elapsedtime+distinterval/currenttotalwindspd;
                                distalongvector=distalongvector+distinterval;

                                latpartway=startinglat+distalongvector*sin(windangle);lonpartway=startinglon+distalongvector*cos(windangle);if lonpartway<0;lonpartway=lonpartway+360;end
                                rowpartway=4*(90.25-round2(latpartway,0.25));
                                if rem(lonpartway,1)<0.25;lonpartwayrd=round2(lonpartway,1,'floor')+.125;
                                elseif rem(lonpartway,1)<0.5;lonpartwayrd=round2(lonpartway,1,'floor')+.375;
                                elseif rem(lonpartway,1)<0.75;lonpartwayrd=round2(lonpartway,1,'floor')+.625;
                                else;lonpartwayrd=round2(lonpartway,1,'floor')+.875;
                                end
                                colpartway=4*(lonpartwayrd)+0.5;

                                if rowpartway~=rowprev || colpartway~=colprev %new gridcell reached --> use its wind info instead
                                    %fprintf('Elapsed time is %d, distance along vector is %d, u is %d, v is %d, row is %d, col is %d\n',...
                                    %elapsedtime,distalongvector,currentuwindspd,currentvwindspd,rowpartway,colpartway);

                                    if colpartway>1440;colpartway=colpartway-1440;end %wrap around longitude

                                    if sstthresh==29
                                        if isnan(areasdownwindof29c(rowpartway,colpartway));areasdownwindof29c(rowpartway,colpartway)=1;end
                                    elseif sstthresh==29.5
                                        if isnan(areasdownwindof29pt5c(rowpartway,colpartway));areasdownwindof29pt5c(rowpartway,colpartway)=1;end
                                    elseif sstthresh==30
                                        if isnan(areasdownwindof30c(rowpartway,colpartway));areasdownwindof30c(rowpartway,colpartway)=1;end
                                    end
                                    rowprev=rowpartway;colprev=colpartway;

                                    %if colpartway<=720;colpartwayalt=colpartway+720;else;colpartwayalt=colpartway-720;end
                                    %startinglat=era5latarray(rowpartway,colpartway);startinglon=era5lonarray(rowpartway,colpartwayalt);
                                    startinglat=latpartway;startinglon=lonpartway;
                                    currentuwindspd=p50u950bypoint(rowpartway,colpartway).*86400./(111000.*cos(startinglat*pi/180)); %in deg/day
                                    currentvwindspd=p50v950bypoint(rowpartway,colpartway).*86400./111000; %in deg/day
                                    currenttotalwindspd=sqrt(currentuwindspd^2+currentvwindspd^2);
                                    windangle=atan(currentvwindspd/currentuwindspd);
                                    distalongvector=0;

                                    if currenttotalwindspd==0;elapsedtime=2;end %game over, won't go anywhere else
                                end
                            end
                        end
                    end
                end
            end
            
            if sstthresh==29;areasdownwind=areasdownwindof29c;elseif sstthresh==29.5;areasdownwind=areasdownwindof29pt5c;elseif sstthresh==30;areasdownwind=areasdownwindof30c;end
        
            %Plot
            areasaffected=zeros(721,1440);
            for i=2:720
                for j=2:1439
                    if (nanmean(nanmean(sst_3warmestmonths(i-1:i+1,j-1:j+1)))>=sstthresh && sum(sum(~isnan(sst_3warmestmonths(i-1:i+1,j-1:j+1))))>=5) || areasdownwind(i,j)==1
                        areasaffected(i,j)=1;
                    end
                end
            end
            areasaffected=[areasaffected(:,721:1440) areasaffected(:,1:720)];
            data={era5latarray;era5lonarray;areasaffected};
            vararginnew={'datatounderlay';data;'underlaycaxismin';-0.5;'underlaycaxismax';1.5;'mystepunderlay';1;...
                    'underlaycolormap';colormaps('blueyellowred','more','not');'variable';'temperature';'overlaynow';0;'nonewfig';1};
            datatype='custom';region='world';
            figure(9+sstthresh*4);clf;
            plotModelData(data,region,vararginnew,datatype);
            
            if sstthresh==29;areasaffected_29c=areasaffected;elseif sstthresh==29.5;areasaffected_29pt5c=areasaffected;elseif sstthresh==30;areasaffected_30c=areasaffected;end
        end
        
        save('/Volumes/ExternalDriveZ/ERA5_HHLcalcs/venndiagramarrays.mat','areasaffected_29c','areasaffected_29pt5c','areasaffected_30c',...
            'sst_3warmestmonths','areasdownwindof29c','areasdownwindof29pt5c','areasdownwindof30c','-append');
    end
    
    
    if doqbelowmtns==1 %find places with a large percentage of q (in the 3 warmest-MSE months) that is below the height of mtns that block the local prevailing wind 
        %Recall that levels 1-7 are 200, 300, 500, 700, 850, 925, 1000
        topmonths_321x1440=topmonths(201:521,:);secondtopmonths_321x1440=secondtopmonths(201:521,:);thirdtopmonths_321x1440=thirdtopmonths(201:521,:); %centered on 180
        fracqbeloweachlevel=NaN.*ones(10,6,321,1440);
        
        for year=2009:2018
            file=ncgeodataset(strcat('/Volumes/ExternalDriveZ/ERA5_Hourly_Data/q_world_levels_',num2str(year),'.grib'));
            qprofiletemp=file{'Specific_humidity_isobaric'};echo off;clear file;
            for lloop=1:4
                if lloop==1;col1=1;col2=360;elseif lloop==2;col1=361;col2=720;elseif lloop==3;col1=721;col2=1080;else;col1=1081;col2=1440;end
                qprofiles=squeeze(double(qprofiletemp.data(1:365,:,:,col1:col2))); %centered on 0
                
                %Restrict to warmest-MSE months and get seasonal-mean q profile
                for row=1:321
                    for col=col1:col2
                        for mon=1:12
                            if topmonths_321x1440(row,col)==mon || secondtopmonths_321x1440(row,col)==mon || thirdtopmonths_321x1440(row,col)==mon
                            else
                                qprofiles(monstarts(mon):monstops(mon),:,row,col-col1+1)=NaN;
                            end
                        end
                    end
                end
                qprofilemean=squeeze(nanmean(qprofiles));
                vertsumq=squeeze(sum(qprofilemean));
                
                %Fraction of q below each level -- recall that level 5 represents 850
                for lev=1:size(qprofiles,2)-1
                    fracqbeloweachlevel(year-2008,lev,:,col1:col2)=squeeze(sum(qprofilemean(lev:size(qprofiles,2),:,:)))./vertsumq;
                end
                clear qprofiles;clear qprofilemean;
            end
            disp(year);disp(clock);
            clear qprofiletemp;
        end
        %Get fraction of q below each level
        fracqbeloweachlevel_mean=squeeze(mean(fracqbeloweachlevel));clear fracqbeloweachlevel;
        %Get height for which 90% is blocked (by quadratic interpolation)
        x=1:6;meanheights=[11700;9050;5470;2900;1350;640]';p=polyfit(x,meanheights,4);
        testindices=1:0.05:6;
        interpheights=polyval(p,testindices);
        
        for i=1:size(fracqbeloweachlevel_mean,2)
            for j=1:size(fracqbeloweachlevel_mean,3)
                y=squeeze(fracqbeloweachlevel_mean(:,i,j))';p=polyfit(x,y,3);
                fracbelow=polyval(p,testindices);
                [~,indextousep95]=min(abs(fracbelow-0.95));height95pctbelow(i,j)=interpheights(indextousep95);
                [~,indextousep90]=min(abs(fracbelow-0.9));height90pctbelow(i,j)=interpheights(indextousep90);
                [~,indextousep75]=min(abs(fracbelow-0.75));height75pctbelow(i,j)=interpheights(indextousep75);
            end
        end
        height95pctbelow=cat(1,NaN.*ones(200,1440),height95pctbelow,NaN.*ones(200,1440));
        height90pctbelow=cat(1,NaN.*ones(200,1440),height90pctbelow,NaN.*ones(200,1440));
        height75pctbelow=cat(1,NaN.*ones(200,1440),height75pctbelow,NaN.*ones(200,1440));
        
        maxelevdownwind=zeros(721,1440);
        elevera5_centeredon180=[elevera5(:,721:1440) elevera5(:,1:720)];
        era5lonarray_centeredon180=[era5lonarray(:,721:1440) era5lonarray(:,1:720)];
        for row=1:721
            for col=1:1440
                if col<=720;colalt=col+720;else;colalt=col-720;end
                    startinglat=era5latarray(row,col);startinglon=era5lonarray(row,colalt);
                    currentuwindspd=p50u950bypoint(row,col).*86400./(111000.*cos(startinglat*pi/180)); %in deg/day
                    currentvwindspd=p50v950bypoint(row,col).*86400./111000; %in deg/day
                    currenttotalwindspd=sqrt(currentuwindspd^2+currentvwindspd^2);
                    windangle=atan(currentvwindspd/currentuwindspd);
                    %Trace back along wind vector, stepping with intervals of 0.1 deg
                    %As soon as we encounter another gridcell, use that gridcell's wind vector instead
                    %Continue doing this until the total time has reached 48 hr
                    if currenttotalwindspd~=0
                        elapsedtime=0;distalongvector=0;distinterval=0.1;rowprev=row;colprev=col;
                        while elapsedtime<2 && distalongvector<=currenttotalwindspd
                            elapsedtime=elapsedtime+distinterval/currenttotalwindspd;
                            distalongvector=distalongvector+distinterval;

                            if currentuwindspd<0;adjfactor=-1;else;adjfactor=1;end
                            latpartway=startinglat+distalongvector*adjfactor*sin(windangle);lonpartway=startinglon+distalongvector*adjfactor*cos(windangle);if lonpartway<0;lonpartway=lonpartway+360;end
                            rowpartway=4*(90.25-round2(latpartway,0.25));
                            if rem(lonpartway,1)<0.25;lonpartwayrd=round2(lonpartway,1,'floor')+.125;
                            elseif rem(lonpartway,1)<0.5;lonpartwayrd=round2(lonpartway,1,'floor')+.375;
                            elseif rem(lonpartway,1)<0.75;lonpartwayrd=round2(lonpartway,1,'floor')+.625;
                            else;lonpartwayrd=round2(lonpartway,1,'floor')+.875;
                            end
                            colpartway=4*(lonpartwayrd)+0.5;

                            if rowpartway~=rowprev || colpartway~=colprev %new gridcell reached --> use its wind info instead
                                %fprintf('Elapsed time is %0.2f, distance along vector is %0.1f, u is %0.1f, v is %0.1f, lat is %0.1f, lon is %0.1f\n',...
                                %elapsedtime,distalongvector,currentuwindspd,currentvwindspd,era5latarray(rowpartway,colpartway),era5lonarray_centeredon180(rowpartway,colpartway));
                                
                                if colpartway>1440;colpartway=colpartway-1440;end %wrap around longitude
                                if elevera5_centeredon180(rowpartway,colpartway)>maxelevdownwind(row,col)
                                    maxelevdownwind(row,col)=elevera5_centeredon180(rowpartway,colpartway);
                                end
                                
                                rowprev=rowpartway;colprev=colpartway;

                                startinglat=latpartway;startinglon=lonpartway;
                                currentuwindspd=p50u950bypoint(rowpartway,colpartway).*86400./(111000.*cos(startinglat*pi/180)); %in deg/day
                                currentvwindspd=p50v950bypoint(rowpartway,colpartway).*86400./111000; %in deg/day
                                currenttotalwindspd=sqrt(currentuwindspd^2+currentvwindspd^2);
                                windangle=atan(currentvwindspd/currentuwindspd);
                                distalongvector=0;
                                
                                if currenttotalwindspd==0;elapsedtime=2;end %game over, won't go anywhere else
                            end
                        end
                    end
                %end
            end
        end
        
        blockedlocs95=NaN.*ones(721,1440);blockedlocs90=NaN.*ones(721,1440);blockedlocs75=NaN.*ones(721,1440);
        for row=1:721
            for col=1:1440
                if col<=720;colalt=col+720;else;colalt=col-720;end
                if maxelevdownwind(row,col)>height95pctbelow(row,colalt) && elevera5(row,colalt)<height95pctbelow(row,colalt);blockedlocs95(row,col)=1;end
                if maxelevdownwind(row,col)>height90pctbelow(row,colalt) && elevera5(row,colalt)<height90pctbelow(row,colalt);blockedlocs90(row,col)=1;end
                if maxelevdownwind(row,col)>height75pctbelow(row,colalt) && elevera5(row,colalt)<height75pctbelow(row,colalt);blockedlocs75(row,col)=1;end
            end
        end
        save('/Volumes/ExternalDriveZ/ERA5_HHLcalcs/venndiagramarrays.mat','blockedlocs95','blockedlocs90','blockedlocs75','-append');
    end
    
    
    if dostabil==1
        f=load('/Volumes/ExternalDriveZ/ERA5_HHLcalcs/climoforcompositesMAY2021.mat');
        stabilclimoreg1=f.stabilclimoreg1;stabilclimoreg2=f.stabilclimoreg2;stabilclimoreg3=f.stabilclimoreg3;stabilclimoreg5=f.stabilclimoreg5;
        
    end
    
    
    if dopsfc==1
        year=2020;
        psfcfile=ncgeodataset(strcat('/Volumes/ExternalDriveC/ERA5_Hourly_Data_PandGHonly/psfc_world_',num2str(year),'.grib'));
        loopstartdays=[1;38;74;111;147;184;220;257;293;330];loopnumdays=36;

        numloops=10; %number of loops is large enough to not cause a Java-heap-memory error
        sz=2920/numloops;
        for loop=1:numloops
            psfctemp=psfcfile{'Surface_pressure_surface'};echo off; %in Pa
            psfc=double(psfctemp.data(sz*loop-(sz-1):sz*loop,:,:));clear psfctemp;
            psfc=cat(3,psfc(:,:,721:1440),psfc(:,:,1:720)); 
            psfc_all(sz*loop-(sz-1):sz*loop,:,:)=psfc(:,181:500,:);
        end
        p99psfc=squeeze(quantile(psfc_all,0.99));
    end
    
    
    %runtime: 12 min
    if dorh==1
        for year=2018:2018
            if year<=1999;extdriveloc='F/ERA5_Hourly_Data_1979to1999';else;extdriveloc='Z/ERA5_Hourly_Data';end
            file=ncgeodataset(strcat('/Volumes/ExternalDrive',extdriveloc,'/ttd_world_',num2str(year),'.grib'));
            loopstartdays=[1;38;74;111;147;184;220;257;293;330];loopnumdays=36;

            numloops=10; %number of loops is large enough to not cause a Java-heap-memory error
            sz=2920/numloops;
            for loop=1:numloops
                ttemp=file{'2_metre_temperature_surface'};echo off; %T in K
                t=double(ttemp.data(sz*loop-(sz-1):sz*loop,:,:));clear ttemp;
                tdtemp=file{'2_metre_dewpoint_temperature_surface'};echo off; %Td in K
                td=double(tdtemp.data(sz*loop-(sz-1):sz*loop,:,:));clear tdtemp;
                
                rh=calcrhfromTanddewpt(t-273.15,td-273.15);
                
                if rem(loop/2,1)==0 %even loop
                    istart=12;iend=loopnumdays*8+4;
                else %odd loop
                    istart=8;iend=loopnumdays*8;
                end
                
                for i=istart:8:iend %each run of this loop represents a single day
                    if rem(loop/2,1)==0
                        day=loopstartdays(loop)+(i-4)/8-1;
                    else
                        day=loopstartdays(loop)+i/8-1;
                    end
                    %[a,b]=min(rh(i-7:i,:,:));a=squeeze(a);b=squeeze(b);
                    c=mean(rh(i-7:i,:,:));c=squeeze(c);
                    
                    allmeanrh(day,:,:)=c;
                end
            end
            disp(year);
        end
        meanmeanrh=squeeze(mean(allmeanrh));
        save('/Volumes/ExternalDriveZ/ERA5_Hourly_Data/rhsave.mat','meanmeanrh');
        
    end
    
    
    
    if reloadandplotall==1
        exist p99swbypoint;
        if ans==0
            file=load('/Volumes/ExternalDriveZ/ERA5_HHLcalcs/venndiagramarrays.mat');
            p99swbypoint=file.p99swbypoint;p90swbypoint=file.p90swbypoint;p50swbypoint=file.p50swbypoint;p10swbypoint=file.p10swbypoint;p1swbypoint=file.p1swbypoint;
            p99lwbypoint=file.p99lwbypoint;p90lwbypoint=file.p90lwbypoint;p50lwbypoint=file.p50lwbypoint;p10lwbypoint=file.p10lwbypoint;p1lwbypoint=file.p1lwbypoint;
            p90lhfbypoint=file.p90lhfbypoint;p50lhfbypoint=file.p50lhfbypoint;p10lhfbypoint=file.p10lhfbypoint;p90shfbypoint=file.p90shfbypoint;p50shfbypoint=file.p50shfbypoint;
            areasaffected_29c=file.areasaffected_29c;areasaffected_29pt5c=file.areasaffected_29pt5c;areasaffected_30c=file.areasaffected_30c;
            sst_3warmestmonths=file.sst_3warmestmonths;
            areasdownwindof29c=file.areasdownwindof29c;areasdownwindof29pt5c=file.areasdownwindof29pt5c;areasdownwindof30c=file.areasdownwindof30c;
            p50u950bypoint=file.p50u950bypoint;p50v950bypoint=file.p50v950bypoint;p50w850bypoint=file.p50w850bypoint;p50w300bypoint=file.p50w300bypoint;
            p90mssbypoint_850300=file.p90mssbypoint_850300;p50mssbypoint_850300=file.p50mssbypoint_850300;
            p90mssbypoint_700300=file.p90mssbypoint_700300;p50mssbypoint_700300=file.p50mssbypoint_700300;
            p90thetae500bypoint=file.p90thetae500bypoint;
            blockedlocs95=file.blockedlocs95;blockedlocs90=file.blockedlocs90;blockedlocs75=file.blockedlocs75;
            file=load('/Volumes/ExternalDriveZ/ERA5_Hourly_Data/mseqhqlstats');p99qhbypoint=file.p99qhbypoint; %centered on 180
            file=load('/Volumes/ExternalDriveZ/ERA5_Hourly_Data/rhsave.mat');p50rhbypoint=file.meanmeanrh;

            p99swbypoint=cat(1,NaN.*ones(180,1440),p99swbypoint,NaN.*ones(220,1440));p90swbypoint=cat(1,NaN.*ones(180,1440),p90swbypoint,NaN.*ones(220,1440));
            p50swbypoint=cat(1,NaN.*ones(180,1440),p50swbypoint,NaN.*ones(220,1440));p10swbypoint=cat(1,NaN.*ones(180,1440),p10swbypoint,NaN.*ones(220,1440));
            p1swbypoint=cat(1,NaN.*ones(180,1440),p1swbypoint,NaN.*ones(220,1440));
            p99lwbypoint=cat(1,NaN.*ones(180,1440),p99lwbypoint,NaN.*ones(220,1440));p90lwbypoint=cat(1,NaN.*ones(180,1440),p90lwbypoint,NaN.*ones(220,1440));
            p50lwbypoint=cat(1,NaN.*ones(180,1440),p50lwbypoint,NaN.*ones(220,1440));p10lwbypoint=cat(1,NaN.*ones(180,1440),p10lwbypoint,NaN.*ones(220,1440));
            p1lwbypoint=cat(1,NaN.*ones(180,1440),p1lwbypoint,NaN.*ones(220,1440));
            p90lhfbypoint=cat(1,NaN.*ones(180,1440),p90lhfbypoint,NaN.*ones(220,1440));p50lhfbypoint=cat(1,NaN.*ones(180,1440),p50lhfbypoint,NaN.*ones(220,1440));p10lhfbypoint=cat(1,NaN.*ones(180,1440),p10lhfbypoint,NaN.*ones(220,1440));
            p90shfbypoint=cat(1,NaN.*ones(180,1440),p90shfbypoint,NaN.*ones(220,1440));p50shfbypoint=cat(1,NaN.*ones(180,1440),p50shfbypoint,NaN.*ones(220,1440));
            %p50rhbypoint=cat(1,NaN.*ones(180,1440),p50rhbypoint,NaN.*ones(220,1440));
            
            %Center arrays on 0
            p99swbypoint=[p99swbypoint(:,721:1440) p99swbypoint(:,1:720)];p90swbypoint=[p90swbypoint(:,721:1440) p90swbypoint(:,1:720)]; 
            p50swbypoint=[p50swbypoint(:,721:1440) p50swbypoint(:,1:720)];p10swbypoint=[p10swbypoint(:,721:1440) p10swbypoint(:,1:720)]; 
            p1swbypoint=[p1swbypoint(:,721:1440) p1swbypoint(:,1:720)]; 
            p99lwbypoint=[p99lwbypoint(:,721:1440) p99lwbypoint(:,1:720)];p90lwbypoint=[p90lwbypoint(:,721:1440) p90lwbypoint(:,1:720)]; 
            p50lwbypoint=[p50lwbypoint(:,721:1440) p50lwbypoint(:,1:720)];p10lwbypoint=[p10lwbypoint(:,721:1440) p10lwbypoint(:,1:720)]; 
            p1lwbypoint=[p1lwbypoint(:,721:1440) p1lwbypoint(:,1:720)]; 
            p90lhfbypoint=[p90lhfbypoint(:,721:1440) p90lhfbypoint(:,1:720)];p50lhfbypoint=[p50lhfbypoint(:,721:1440) p50lhfbypoint(:,1:720)];p10lhfbypoint=[p10lhfbypoint(:,721:1440) p10lhfbypoint(:,1:720)];
            p90shfbypoint=[p90shfbypoint(:,721:1440) p90shfbypoint(:,1:720)];p50shfbypoint=[p50shfbypoint(:,721:1440) p50shfbypoint(:,1:720)]; 
            p99qhbypoint=[p99qhbypoint(:,721:1440) p99qhbypoint(:,1:720)];
            p50u950bypoint=[p50u950bypoint(:,721:1440) p50u950bypoint(:,1:720)];p50v950bypoint=[p50v950bypoint(:,721:1440) p50v950bypoint(:,1:720)];
            p50w850bypoint=[p50w850bypoint(:,721:1440) p50w850bypoint(:,1:720)];p50w300bypoint=[p50w300bypoint(:,721:1440) p50w300bypoint(:,1:720)];
            p50rhbypoint=[p50rhbypoint(:,721:1440) p50rhbypoint(:,1:720)];
        end
        
        
        %THESE ARE THE CRITERIA
        w850cutoff=0.02; %moderate lower-tropospheric subsidence
        w300cutoff=0;
        %v950cutoff=1.5; %abs value
        sstcutoff=29;
        p99swcutoff=quantile(reshape(p99swbypoint,[721*1440 1]),0.1); %exclude lowest 10% of global points
        p99swmax=quantile(reshape(p99swbypoint,[721*1440 1]),0.9); %exclude highest 10% of global points
        %p90swcutoff=8.5*10^5;p50swcutoff=6.5*10^5;
        %p99lwcutoff=-1.1*10^5;
        %p50lwcutoff=quantile(reshape(p50lwbypoint,[721*1440 1]),0.1); %in assessing median radation, exclude the lowest 10% of global points
        p1lwcutoff=quantile(reshape(p1lwbypoint,[721*1440 1]),0.2); %in assessing extreme radiation, include only the lowest 20% of global points
        p1lwmin=quantile(reshape(p1lwbypoint,[721*1440 1]),0.1); %exclude lowest 10% of global points
        %p90lhfcutoff=-0.9*10^5;p10lhfcutoff=-3*10^5; %latent-heat flux
        p50lhfcutoff=quantile(reshape(p50lhfbypoint,[721*1440 1]),0.8); %include the highest 20% of land points
        %p50shfcutoff=-1.2*10^4; %sensible-heat flux
        %p99qhcutoff=315*1000; %sensible heat
        blockedcutoff='90';blockedlocs=eval(['blockedlocs' blockedcutoff]);blockedlocs=[blockedlocs(:,721:1440) blockedlocs(:,1:720)];  %terrain blocking
        elevmax=500; %exclude everything below this, in meters
        %%%%%%%%%%%%%%%%%%%%%%%
        
        
        allcriteria=zeros(721,1440);crit1=zeros(721,1440);crit2=zeros(721,1440);crit3=zeros(721,1440);crit4=zeros(721,1440);
            crit5=zeros(721,1440);crit6=zeros(721,1440);crit7=zeros(721,1440);
        if sstcutoff==29;areasaffected=areasaffected_29c;elseif sstcutoff==29.5;areasaffected=areasaffected_29pt5c;elseif sstcutoff==30;areasaffected=areasaffected_30c;end
        

        for i=201:481
            for j=1:1440
                %if p50w850bypoint(i,j)>w850cutoff;allcriteria(i,j)=allcriteria(i,j)+1;crit1(i,j)=crit1(i,j)+1;end
                if areasaffected(i,j)==1 || (p50lhfbypoint(i,j)<p50lhfcutoff && lsmask(i,j)>=0.5);allcriteria(i,j)=allcriteria(i,j)+1;crit1(i,j)=crit1(i,j)+1;end
                %if p50swbypoint(i,j)>p50swcutoff;allcriteria(i,j)=allcriteria(i,j)+1;end
                %if p90lhfbypoint(i,j)>p90lhfcutoff;allcriteria(i,j)=allcriteria(i,j)+1;crit3(i,j)=crit3(i,j)+1;end
                if p99swbypoint(i,j)>=p99swcutoff && p99swbypoint(i,j)<=p99swmax;allcriteria(i,j)=allcriteria(i,j)+1;crit2(i,j)=crit2(i,j)+1;end
                if p1lwbypoint(i,j)<=p1lwcutoff && p1lwbypoint(i,j)>=p1lwmin;allcriteria(i,j)=allcriteria(i,j)+1;crit3(i,j)=crit3(i,j)+1;end
                %if p50shfbypoint(i,j)>=p50shfcutoff;allcriteria(i,j)=allcriteria(i,j)+1;crit5(i,j)=crit5(i,j)+1;end
                if p50w300bypoint(i,j)>w300cutoff && p50w850bypoint(i,j)>w850cutoff;allcriteria(i,j)=allcriteria(i,j)+1;crit4(i,j)=crit4(i,j)+1;end
                %if abs(p50v950bypoint(i,j))>v950cutoff;allcriteria(i,j)=allcriteria(i,j)+1;crit6(i,j)=crit6(i,j)+1;end
                %if p99qhbypoint(i,j)>p99qhcutoff;allcriteria(i,j)=allcriteria(i,j)+1;crit4(i,j)=crit4(i,j)+1;end
                %if blockedlocs(i,j)==1;allcriteria(i,j)=allcriteria(i,j)+1;crit7(i,j)=crit7(i,j)+1;end
                %if p50w850bypoint(i,j)>w850cutoff || blockedlocs(i,j)==1;allcriteria(i,j)=allcriteria(i,j)+1;crit6(i,j)=crit6(i,j)+1;end
                if p50rhbypoint(i,j)>=25 && p50rhbypoint(i,j)<=75;allcriteria(i,j)=allcriteria(i,j)+1;crit5(i,j)=crit5(i,j)+1;end
                if elevera5(i,j)<=elevmax;allcriteria(i,j)=allcriteria(i,j)+1;crit6(i,j)=crit6(i,j)+1;end
            end
        end
        %allcriteria=[allcriteria(:,721:1440) allcriteria(:,1:720)];%allcriteria(:,1:200)=NaN;allcriteria(:,1361:1440)=NaN;allcriteria(1:200,:)=NaN;allcriteria(482:721,:)=NaN;allcriteria(:,720)=allcriteria(:,719);allcriteria(:,721)=allcriteria(:,722);
        %crit1=[crit1(:,721:1440) crit1(:,1:720)];crit1(:,1:200)=NaN;%crit1(:,1361:1440)=NaN;crit1(1:200,:)=NaN;crit1(482:721,:)=NaN;crit1(:,720)=crit1(:,719);crit1(:,721)=crit1(:,722);
        %crit2=[crit2(:,721:1440) crit2(:,1:720)];crit2(:,1:200)=NaN;crit2(:,1361:1440)=NaN;crit2(1:200,:)=NaN;crit2(482:721,:)=NaN;crit2(:,720)=crit2(:,719);crit2(:,721)=crit2(:,722);
        %crit3=[crit3(:,721:1440) crit3(:,1:720)];crit3(:,1:200)=NaN;crit3(:,1361:1440)=NaN;crit3(1:200,:)=NaN;crit3(482:721,:)=NaN;crit3(:,720)=crit3(:,719);crit3(:,721)=crit3(:,722);
        %crit4=[crit4(:,721:1440) crit4(:,1:720)];crit4(:,1:200)=NaN;crit4(:,1361:1440)=NaN;crit4(1:200,:)=NaN;crit4(482:721,:)=NaN;crit4(:,720)=crit4(:,719);crit4(:,721)=crit4(:,722);
        %crit5=[crit5(:,721:1440) crit5(:,1:720)];crit5(:,1:200)=NaN;crit5(:,1361:1440)=NaN;crit5(1:200,:)=NaN;crit5(482:721,:)=NaN;crit5(:,720)=crit5(:,719);crit5(:,721)=crit5(:,722);
        allcriteria=allcriteria(:,201:1360);crit1=crit1(:,201:1360);crit2=crit2(:,201:1360);
        crit3=crit3(:,201:1360);crit4=crit4(:,201:1360);crit5=crit5(:,201:1360);crit6=crit6(:,201:1360);crit7=crit7(:,201:1360);
        
        %Whether to include a gridpoint as a hit if a point within 25 km did
        %This is 1 neighboring gridpoint in any direction
        if inclneighbors==1
            everdonestg1=0;everdonestg2=0;everdonestg3=0;everdonestg4=0;everdonestg5=0;everdonestg6=0;everdonestg7=0;
            %newcrit1=zeros(721,1440);everdonestg1=0;
            %newcrit2=zeros(721,1440);newcrit3=zeros(721,1440);newcrit4=zeros(721,1440);newcrit5=zeros(721,1440);newcrit6=zeros(721,1440);
            newcrit4=zeros(721,1440);
            newcrit7=zeros(721,1440);everdonestg7=0;
            for i=202:480
                for j=2:1159
                    donestg1=0;donestg2=0;donestg3=0;donestg4=0;donestg5=0;donestg6=0;donestg7=0;
                    for ioffset=-1:1
                        for joffset=-1:1
                            %if crit1(i+ioffset,j+joffset)==1 && donestg1==0;newcrit1(i,j+200)=1;donestg1=1;everdonestg1=1;end
                            %if crit2(i+ioffset,j+joffset)==1 && donestg2==0;newcrit2(i,j+200)=1;donestg2=1;end
                            %if crit3(i+ioffset,j+joffset)==1 && donestg3==0;newcrit3(i,j+200)=1;donestg3=1;end
                            if crit4(i+ioffset,j+joffset)==1 && donestg4==0;newcrit4(i,j+200)=1;donestg4=1;everdonestg4=1;end
                            %if crit5(i+ioffset,j+joffset)==1 && donestg5==0;newcrit5(i,j+200)=1;donestg5=1;end
                            %if crit6(i+ioffset,j+joffset)==1 && donestg6==0;newcrit6(i,j+200)=1;donestg6=1;end
                            if crit7(i+ioffset,j+joffset)==1 && donestg7==0;newcrit7(i,j+200)=1;donestg7=1;everdonestg7=1;end
                        end
                    end
                end
            end
            %oldcrit1=crit1;crit1=newcrit1;oldcrit2=crit2;crit2=newcrit2;oldcrit3=crit3;crit3=newcrit3;
            %    oldcrit4=crit4;crit4=newcrit4;oldcrit5=crit5;crit5=newcrit5;oldcrit6=crit6;crit6=newcrit6;
            %crit1=newcrit1;
            crit4=newcrit4;
            crit7=newcrit7;
            %allcriteria=crit1+crit2+crit3+crit4+crit5;
            %allcriteria=crit2+crit3+crit4+crit6;
        end
        
        if everdonestg1==0;crit1=cat(2,NaN.*ones(721,200),crit1,NaN.*ones(721,80));end
        crit2=cat(2,NaN.*ones(721,200),crit2,NaN.*ones(721,80));
        crit3=cat(2,NaN.*ones(721,200),crit3,NaN.*ones(721,80));
        if everdonestg4==0;crit4=cat(2,NaN.*ones(721,200),crit4,NaN.*ones(721,80));end
        crit5=cat(2,NaN.*ones(721,200),crit5,NaN.*ones(721,80));crit6=cat(2,NaN.*ones(721,200),crit6,NaN.*ones(721,80));
        if everdonestg7==0;crit7=cat(2,NaN.*ones(721,200),crit7,NaN.*ones(721,80));end
        allcriteria=cat(2,NaN.*ones(721,200),allcriteria,NaN.*ones(721,80));
        
        for i=323:380
            for j=720:721
                if j==720;crit2(i,j)=crit2(i,719);elseif j==721;crit2(i,j)=crit2(i,722);end
                if j==720;allcriteria(i,j)=allcriteria(i,719);elseif j==721;allcriteria(i,j)=allcriteria(i,722);end
            end
        end
        
        
        if makefigs11==1
            data={era5latarray;era5lonarray;allcriteria};
            figure(9);clf;curpart=1;highqualityfiguresetup;
            datatype='custom';region='world30s40n130wto160e';
            vararginnew={'underlayvariable';'wet-bulb temp';'contour';0;'underlaycolormap';colormaps('wbt_trunc_exaggerated','7','not');'omitfirstsubplotcolorbar';1;...
                'underlaycaxismin';0;'underlaycaxismax';7;'overlaynow';0;'datatounderlay';data;'stateboundaries';0;'centeredon';0;'conttoplot';'all';'nonewfig';1};
            plotModelData(data,region,vararginnew,datatype);
            set(gca,'Position',[0.01 0.755 0.48 0.21]);
            maxmseflipped=[maxmsebypoint(:,721:1440) maxmsebypoint(:,1:720)];
            title('All','fontsize',14,'fontweight','bold','fontname','arial');

            subplot(4,2,2);
            data={era5latarray;era5lonarray;crit1};
            datatype='custom';region='world30s40n130wto160e';
            vararginnew={'underlayvariable';'wet-bulb temp';'contour';0;'underlaycolormap';colormaps('highlightplusgrayscale','5','not');'omitfirstsubplotcolorbar';1;...
                'underlaycaxismin';0;'underlaycaxismax';1;'overlaynow';0;'datatounderlay';data;'stateboundaries';0;'centeredon';0;'conttoplot';'all';'nonewfig';1};
            plotModelData(data,region,vararginnew,datatype);set(gca,'colormap',flipud(colormaps('orangewhite','more','not')));
            set(gca,'Position',[0.51 0.755 0.48 0.21]);
            title('SSTs/Latent-Heat Flux','fontsize',14,'fontweight','bold','fontname','arial');

            subplot(4,2,3);
            data={era5latarray;era5lonarray;crit2};
            datatype='custom';region='world30s40n130wto160e';
            vararginnew={'underlayvariable';'wet-bulb temp';'contour';0;'underlaycolormap';colormaps('highlightplusgrayscale','5','not');'omitfirstsubplotcolorbar';1;...
                'underlaycaxismin';0;'underlaycaxismax';1;'overlaynow';0;'datatounderlay';data;'stateboundaries';0;'centeredon';0;'conttoplot';'all';'nonewfig';1};
            plotModelData(data,region,vararginnew,datatype);set(gca,'colormap',flipud(colormaps('orangewhite','more','not')));
            set(gca,'Position',[0.01 0.505 0.48 0.21]);
            title('Shortwave Radiation','fontsize',14,'fontweight','bold','fontname','arial');

            subplot(4,2,4);
            data={era5latarray;era5lonarray;crit3};
            datatype='custom';region='world30s40n130wto160e';
            vararginnew={'underlayvariable';'wet-bulb temp';'contour';0;'underlaycolormap';colormaps('highlightplusgrayscale','5','not');'omitfirstsubplotcolorbar';1;...
                'underlaycaxismin';0;'underlaycaxismax';1;'overlaynow';0;'datatounderlay';data;'stateboundaries';0;'centeredon';0;'conttoplot';'all';'nonewfig';1};
            plotModelData(data,region,vararginnew,datatype);set(gca,'colormap',flipud(colormaps('orangewhite','more','not')));
            set(gca,'Position',[0.51 0.505 0.48 0.21]);
            title('Longwave Radiation','fontsize',14,'fontweight','bold','fontname','arial');

            subplot(4,2,5);
            data={era5latarray;era5lonarray;crit4};
            datatype='custom';region='world30s40n130wto160e';
            vararginnew={'underlayvariable';'wet-bulb temp';'contour';0;'underlaycolormap';colormaps('highlightplusgrayscale','5','not');'omitfirstsubplotcolorbar';1;...
                'underlaycaxismin';0;'underlaycaxismax';1;'overlaynow';0;'datatounderlay';data;'stateboundaries';0;'centeredon';0;'conttoplot';'all';'nonewfig';1};
            plotModelData(data,region,vararginnew,datatype);set(gca,'colormap',flipud(colormaps('orangewhite','more','not')));
            set(gca,'Position',[0.01 0.255 0.48 0.21]);
            title('Subsidence','fontsize',14,'fontweight','bold','fontname','arial');

            subplot(4,2,6);
            data={era5latarray;era5lonarray;crit5};
            datatype='custom';region='world30s40n130wto160e';
            vararginnew={'underlayvariable';'wet-bulb temp';'contour';0;'underlaycolormap';colormaps('highlightplusgrayscale','5','not');'omitfirstsubplotcolorbar';1;...
                'underlaycaxismin';0;'underlaycaxismax';1;'overlaynow';0;'datatounderlay';data;'stateboundaries';0;'centeredon';0;'conttoplot';'all';'nonewfig';1};
            plotModelData(data,region,vararginnew,datatype);set(gca,'colormap',flipud(colormaps('orangewhite','more','not')));
            set(gca,'Position',[0.51 0.255 0.48 0.21]);
            title('Relative Humidity','fontsize',14,'fontweight','bold','fontname','arial');
            
            subplot(4,2,7);
            data={era5latarray;era5lonarray;crit6};
            datatype='custom';region='world30s40n130wto160e';
            vararginnew={'underlayvariable';'wet-bulb temp';'contour';0;'underlaycolormap';colormaps('highlightplusgrayscale','5','not');'omitfirstsubplotcolorbar';1;...
                'underlaycaxismin';0;'underlaycaxismax';1;'overlaynow';0;'datatounderlay';data;'stateboundaries';0;'centeredon';0;'conttoplot';'all';'nonewfig';1};
            plotModelData(data,region,vararginnew,datatype);set(gca,'colormap',flipud(colormaps('orangewhite','more','not')));
            set(gca,'Position',[0.01 0.005 0.48 0.21]);
            title('Elevation','fontsize',14,'fontweight','bold','fontname','arial');

            figname='venndiagram_si';curpart=2;highqualityfiguresetup;
        end
    
    
        %Latest iteration of figure
        %6 or 7 criteria satisfied --> saturated colorbar
        %allcriteria=crit1+crit2+crit3+crit4+crit5+crit6+crit7;
        allcriteria=crit1+crit2+crit3+crit4+crit5+crit6;
        
        
        
        
        maxmseflipped=[maxmsebypoint(:,721:1440) maxmsebypoint(:,1:720)];
        
        %figure(900);clf;subplot(4,2,1);imagescnan(crit1);subplot(4,2,2);imagescnan(crit2);subplot(4,2,3);imagescnan(crit3);
        %    subplot(4,2,4);imagescnan(crit4);subplot(4,2,5);imagescnan(crit5);subplot(4,2,6);imagescnan(crit6);subplot(4,2,7);imagescnan(crit7);
        %figure(901);imagescnan(allcriteria);
        %disp('stopped at line 2822');return;
        %saturated=allcriteria>=4;allcriteria(saturated)=4;
        
        if max(max(allcriteria))~=6
            invalid=maxmseflipped<=335;maxmseflipped(invalid)=NaN;allcriteria(invalid)=NaN;
        end
        
        %Subplot 1
        figure(90);clf;hold on;curpart=1;highqualityfiguresetup;
        data={era5latarray;era5lonarray;allcriteria};
        datatype='custom';region='world30s40n130wto160e';
        vararginnew={'underlayvariable';'wet-bulb temp';'contour';0;'underlaycolormap';colormaps('wbt_trunc_exaggerated','7','not');...
            'underlaycaxismin';0;'underlaycaxismax';7;'overlaynow';0;'datatounderlay';data;'stateboundaries';0;'centeredon';0;'conttoplot';'all';'nonewfig';1};
        plotModelData(data,region,vararginnew,datatype);
        set(gca,'Position',[0.05 0.55 0.8 0.4]);
        cb=colorbar;set(cb,'XTick',0.5:6.5,'XTickLabel',{'0','1','2','3','4','5','6'});set(cb,'fontsize',11,'fontweight','bold','fontname','arial');
        title('Estimated from Factors','fontsize',16,'fontweight','bold','fontname','arial');
        t=text(1.08,0.21,'Number of Factors','units','normalized');set(t,'fontsize',12,'fontweight','bold','fontname','arial','rotation',90);
        if addregoutlinestovenndiagram==1
            for reg=1:7
                if reg==1 || reg==2 || reg==3 || reg==5
                    hold on;geoshow([regsouthbounds(reg) regnorthbounds(reg) regnorthbounds(reg) regsouthbounds(reg) regsouthbounds(reg)],...
                        [regwestbounds(reg) regwestbounds(reg) regeastbounds(reg) regeastbounds(reg) regwestbounds(reg)],...
                        'DisplayType','line','color',colors('medium-dark green'),'linewidth',2,'linestyle','-.');
                    %geoshow([subregsouthbounds(reg) subregnorthbounds(reg) subregnorthbounds(reg) subregsouthbounds(reg) subregsouthbounds(reg)],...
                    %    [subregwestbounds(reg) subregwestbounds(reg) subregeastbounds(reg) subregeastbounds(reg) subregwestbounds(reg)],...
                    %    'DisplayType','line','color','k','linewidth',1.5);
                end
            end
        end

        
        %Subplot 2
        %Determine where to set colorbar-axis maximum so total area of
            %darkest color is same as in subplot 1
        darkcolorsum=sum(sum(allcriteria==max(max(allcriteria))));clear sumhere;
        for maxtotry=380:1:400
            sumhere(maxtotry-379)=sum(sum(maxmsebypoint>=maxtotry));
        end
            
        subplot(2,1,2);
        data={era5latarray;era5lonarray;maxmseflipped};
        datatype='custom';region='world30s40n130wto160e';
        if max(max(allcriteria))==4;ucaxismin=320;ucaxismax=400;
        elseif max(max(allcriteria))==5;ucaxismin=325;ucaxismax=400;
        elseif max(max(allcriteria))==6;ucaxismin=300;ucaxismax=400;
        end
        vararginnew={'underlayvariable';'wet-bulb temp';'contour';0;'underlaycolormap';colormaps('wbt_trunc_exaggerated','7','not');...
            'underlaycaxismin';ucaxismin;'underlaycaxismax';ucaxismax;'mystepunderlay';7;'overlaynow';0;'datatounderlay';data;'stateboundaries';0;'centeredon';0;'conttoplot';'all';'nonewfig';1};
        plotModelData(data,region,vararginnew,datatype);
        set(gca,'Position',[0.05 0.05 0.8 0.4]); 
        cb=colorbar;
        if max(max(allcriteria))==4
            set(cb,'XTick',315:75/5:390,'XTickLabel',{'','340','360','380','400',''});
        elseif max(max(allcriteria))==5
            set(cb,'XTick',325:75/5:400,'XTickLabel',{'','325','350','375','400',''});
        elseif max(max(allcriteria))==6
            set(cb,'XTick',ucaxismin:100/7:ucaxismax,'XTickLabel',{'','300','320','340','360','380','400',''});
        elseif max(max(allcriteria))==7
            set(cb,'XTick',325:75/5:400,'XTickLabel',{'','325','350','375','400',''});
        end
        set(cb,'fontsize',11,'fontweight','bold','fontname','arial');
        title('Observed','fontsize',16,'fontweight','bold','fontname','arial');
        t=text(1.08,0.34,'ME (kJ/kg)','units','normalized');set(t,'fontsize',12,'fontweight','bold','fontname','arial','rotation',90);
        if addregoutlinestovenndiagram==1
            for reg=1:7
                if reg==1 || reg==2 || reg==3 || reg==5
                    hold on;geoshow([regsouthbounds(reg) regnorthbounds(reg) regnorthbounds(reg) regsouthbounds(reg) regsouthbounds(reg)],...
                        [regwestbounds(reg) regwestbounds(reg) regeastbounds(reg) regeastbounds(reg) regwestbounds(reg)],...
                        'DisplayType','line','color',colors('medium-dark green'),'linewidth',2,'linestyle','-.');
                    %geoshow([subregsouthbounds(reg) subregnorthbounds(reg) subregnorthbounds(reg) subregsouthbounds(reg) subregsouthbounds(reg)],...
                    %    [subregwestbounds(reg) subregwestbounds(reg) subregeastbounds(reg) subregeastbounds(reg) subregwestbounds(reg)],...
                    %    'DisplayType','line','color','k','linewidth',1.5);
                end
            end
        end

        figname='venndiagramNEW';curpart=2;highqualityfiguresetup;
    end
end

%Supplementary figure comparing regions in terms of number of gridcells
%whose all-time maximum ME exceeds the global p99, and in the mean ME for
%those gridcells
if compareregions==1
    
    maxmsebypoint_0=[maxmsebypoint(:,721:1440) maxmsebypoint(:,1:720)];
    maxqhbypoint_0=[maxqhbypoint(:,721:1440) maxqhbypoint(:,1:720)];
    maxqlbypoint_0=[maxqlbypoint(:,721:1440) maxqlbypoint(:,1:720)];
    
    clear pctreduced;
    for i=1:721
        for j=1:1440
            if (maxqhbypoint_0(i,j)+maxqlbypoint_0(i,j))/1000>=maxmsebypoint_0(i,j)
                %Estimate Qh and Ql contributions by reducing each proportionally until they add to MSE
                minsofar=10^6;
                for pctreduction=0:0.1:25
                    maxqh_reduced=maxqhbypoint_0(i,j)-0.01*pctreduction*maxqhbypoint_0(i,j);
                    maxql_reduced=maxqlbypoint_0(i,j)-0.01*pctreduction*maxqlbypoint_0(i,j);
                    thissum=maxqh_reduced+maxql_reduced;
                    thisdiff=abs(thissum/1000-maxmsebypoint_0(i,j));
                    if thisdiff<minsofar
                        bestqhsofar(i,j)=maxqh_reduced;
                        bestqlsofar(i,j)=maxql_reduced;
                        pctreduced(i,j)=pctreduction;
                        minsofar=thisdiff;
                    end
                end
            end
        end
    end
    bestqhsofar=bestqhsofar./1000;bestqlsofar=bestqlsofar./1000;
    
    %Subplot 1
    figure(1011);clf;hold on;curpart=1;highqualityfiguresetup;
    subplot(3,1,1);
    temp=maxmsebypoint_0>=p99mseglobal;
    data={era5latarray;era5lonarray;double(temp)};
    datatype='custom';region='worldnorthof60s';
    vararginnew={'underlayvariable';'wet-bulb temp';'contour';0;...
        'underlaycaxismin';0;'underlaycaxismax';1;'overlaynow';0;'stateboundaries';0;...
        'datatounderlay';data;'centeredon';0;'conttoplot';'all';'nonewfig';1;'omitfirstsubplotcolorbar';1};
    plotModelData(data,region,vararginnew,datatype);
    for reg=1:size(regnames,1)
        geoshow([regsouthbounds(reg) regnorthbounds(reg) regnorthbounds(reg) regsouthbounds(reg) regsouthbounds(reg)],...
            [regwestbounds(reg) regwestbounds(reg) regeastbounds(reg) regeastbounds(reg) regwestbounds(reg)],'DisplayType','line','color','k','linewidth',2);
    end
    colormap(flipud(colormaps('redwhite','more','not')));
    ax1=gca;
    set(ax1,'Position',[0.1 0.7 0.8 0.28]);
    
    
    %Subplot 2 -- number of gridcells > p99 in each region
    %Also, in preparation for subplot 3, get mean max MSE across >p99 gridcells in each region
    sumbyreg=zeros(size(regnames,1),1);maxmsebyreg=zeros(size(regnames,1),1);
    maxqhbyreg=zeros(size(regnames,1),1);maxqlbyreg=zeros(size(regnames,1),1);
    for i=1:721
        for j=1:1440
            for reg=1:size(regnames,1)
                if i>=actualrowstarts(reg) && i<=actualrowstops(reg) && j>=actualcolstarts(reg) && j<=actualcolstops(reg)
                    if maxmsebypoint_0(i,j)>=p99mseglobal
                        sumbyreg(reg)=sumbyreg(reg)+1;
                        maxmsebyreg(reg)=maxmsebyreg(reg)+maxmsebypoint_0(i,j);
                        maxqhbyreg(reg)=maxqhbyreg(reg)+bestqhsofar(i,j);
                        maxqlbyreg(reg)=maxqlbyreg(reg)+bestqlsofar(i,j);
                    end
                end
            end
        end
    end
    clear meanmaxmsebyreg;clear meanmaxqhbyreg;clear meanmaxqlbyreg;
    for reg=1:size(regnames,1)
        meanmaxmsebyreg(reg,1)=maxmsebyreg(reg)/sumbyreg(reg);
        meanmaxqhbyreg(reg,1)=maxqhbyreg(reg)/sumbyreg(reg);
        meanmaxqlbyreg(reg,1)=maxqlbyreg(reg)/sumbyreg(reg);
    end
    A=[num2cell(sumbyreg) num2cell(meanmaxmsebyreg) num2cell(meanmaxqhbyreg) num2cell(meanmaxqlbyreg) regnames_veryshort];
    B=sortrows(A,1,'descend');
    
    subplot(3,1,2);
    b=bar(cell2mat(B(:,1)));
    b.FaceColor='k';
    set(gca,'xtick',1:size(regnames,1),'xticklabel','');
    set(gca,'fontsize',12,'fontweight','bold','fontname','arial');
    ax2=gca;
    
    
    %Subplot 3 -- across >p99 gridcells in each region, get mean max MSE, apportioned into Qh and Ql components
    subplot(3,1,3);
    %bar(cell2mat(B(:,2)));
    group1=cell2mat(B(:,3));group2=cell2mat(B(:,4));
    b=bar([group1-300 group2-50],'stacked');
    b(1).FaceColor='b';
    b(2).FaceColor='g';
    set(gca,'xtick',1:size(regnames,1),'xticklabel',B(:,5));xtickangle(45);
    set(gca,'fontsize',12,'fontweight','bold','fontname','arial');
    ax3=gca;
    
    
    set(ax1,'Position',[0.04 0.42 0.92 0.57]);
    set(ax2,'Position',[0.06 0.27 0.92 0.14]);
    set(ax3,'Position',[0.06 0.11 0.92 0.14]);
    
    figname='figures16';curpart=2;highqualityfiguresetup;
end


if sstanomsifigure==1
    figure(80);clf;curpart=1;highqualityfiguresetup;
    for regloop=1:5
        if regloop~=4
            if regloop<=3;regord=regloop;else;regord=4;end
            thisarr=flipud(meansstanom{regloop}');thisarr=[thisarr(:,721:1440) thisarr(:,1:720)];
            if regloop==1;regname='middle-east';elseif regloop==2;regname='south-asia';elseif regloop==3;regname='southeast-asia';else;regname='northern-south-america';end
            data={era5latarray(201:521,:);era5lonarray(201:521,:);thisarr};
            vararginnew={'datatounderlay';data;'underlaycaxismin';-2.5;'underlaycaxismax';2.5;'mystepunderlay';0.25;...
                'underlaycolormap';colormaps('sst','more','not');'overlaynow';0;'nonewfig';1;'variable';'sst'};
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
    figname='sstanomcomposite';curpart=2;highqualityfiguresetup;
end


