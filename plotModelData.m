%A flexible plotting script that can handle multiple types of data,
%Data argument is of form {lats;lons;matrix}, or, for wind, {lats;lons;uwndmatrix;vwndmatrix}
%where each constituent array is an identically sized 2D grid

%Examples:
%Temperature field overlaid with wind barbs:
%vararginnew={'variable';'wind';'contour';1;...
                %'caxismethod';'regional10';'vectorData';data;'overlaynow';1;...
                %'overlayvariable';'temperature';'datatooverlay';overlaydata;'anomavg';'avg'};
                
%Another overlay/underlay example:
%vararginnew={'overlayvariable';'wet-bulb temp';'datatooverlay';data;'contour';0;...
%            'caxismin';310;'caxismax';375;'mystep';5;'overlaynow';1;...
%            'variable';'wind';'vectorData';winddata;'anomavg';'avg';'conttoplot';'Asia';'nonewfig';1};

%Wind barbs only:
%vararginnew={'variable';'wind';'mystep';1;'contour';0;...
                %'vectorData';data;'overlaynow';0;'anomavg';'avg'};

%Shaded map:
    %data={theselats;theselons;mydata};
    %vararginnew={'underlayvariable';'wet-bulb temp';'contour';0;...
    %'underlaycaxismin';0.1;'underlaycaxismax';0.5;'mystepiunderlay';1;'overlaynow';0;'datatounderlay';data;'centeredon';180;'conttoplot';'all'};
    %datatype='custom';
    %region='us-ne';
    %plotModelData(data,region,vararginnew,datatype);
    
%Up-to-date but complex example with three layers, from HHL project, twmaxima.m script:
%vararginnew={'datatounderlay';data;'underlaycaxismin';cmin;'underlaycaxismax';cmax;'mystepunderlay';cstep;...
%                'underlaycolormap';colormaps('blueyellowred','more','not');'overlaynow';1;...
%                'variable';'wind';'vectorData';winddata;'customwindvectorlength';windscale;'anomavg';'avg';...
%                'conttoplot';continent;'customborderwidth';2;'nonewfig';1;...
%                'contour_overlay';1;'datatooverlay';terraindata;'caxismin';0;'caxismax';3000;'omitzerocontour';1;'mystep';500;...
%                'contourlabels';1;'manualcontourlabels';1;'cblabelfontsize';cblabelfontsize};

    
%%%%In all cases, script is then summoned by simply calling %%%%plotModelData(data,region,vararginnew,datatype)%%%%


%VERY IMPORTANT
%Input latitude, longitude, and data arrays must be oriented such that north is
    %on the top and west is on the left
%ALSO, they must be centered on the Prime Meridian -- if centering on 180 is desired, the
    %array will be manipulated appropriately within this script

function [caxisRange,mystep,underlaycolormap,fullshadingdescr,fullcontoursdescr,windbarbsdescr,...
    refval,normrefveclength,caxis_min,caxis_max]=...
    plotModelData(data,region,vararginnew,datatype)


caxisRange=[];


cb=0;fg=0;
if strcmp(datatype,'NARR')
    lsmask=ncread('lsmasknarr.nc','land')';sz1=277;sz2=349;
elseif strcmp(datatype,'NCEP144')
    lsmask=ncread('lsmaskncep.nc','land')';sz1=144;sz2=73;
elseif strcmp(datatype,'NCEP192')
    lsmask=ncread('lsmaskncep192by94.nc','soilw');sz1=192;sz2=94;
elseif strcmp(datatype,'CPC')
    lsmask=ncread('lsmaskhalfdegree.nc','lsm');sz1=720;sz2=360;
elseif strcmp(datatype,'OISST')
    lsmask=ncread('lsmaskquarterdegree.nc','lsm');sz1=1440;sz2=720;
elseif strcmp(datatype,'PRISM')
    sz1=621;sz2=1405;
elseif strcmp(datatype,'ERA-Interim')
    sz1=480;sz2=241;
elseif strcmp(datatype,'10x10box')
    sz1=18;sz2=36;
elseif strcmp(datatype,'NorESM1M')
    lsmask=ncread('lsmask2point5by1point875.nc','sftlf');sz1=144;sz2=96;
elseif strcmp(datatype,'CNRMCM5')
    lsmask=ncread('lsmask256by128.nc','sftlf');sz1=256;sz2=128;
elseif strcmp(datatype,'MIROC5')
    lsmask=ncread('lsmask256by128.nc','sftlf');sz1=256;sz2=128;
elseif strcmp(datatype,'IPSLCM5AMR')
    lsmask=ncread('lsmaskipslcm5amr.nc','sftlf');sz1=144;sz2=143;
elseif strcmp(datatype,'CSIROMk360') || strcmp(datatype,'MPIESMMR')
    lsmask=ncread('lsmask1point875by1point875.nc','sftlf');sz1=192;sz2=96;
elseif strcmp(datatype,'CESM1deg')
    sz1=192;sz2=288;
elseif strcmp(datatype,'custom')
    sz1=size(data{1},1);sz2=size(data{1},2);
end
shadingdescr='';intervaldescr='';contoursdescr='';windbarbsdescr='';

fgTitle='';fgXaxis='';fgYaxis='';
noNewFig = false;
underlaycolormapVal = '';
vectorData = {};
varlistnames={'2-m Temp.';'Wet-Bulb Temp.';'Geopot. Height';'Wind';'q'};

if strcmp(datatype,'NARR') || strcmp(datatype,'NCEP144') || strcmp(datatype,'NCEP192') || ...
        strcmp(datatype,'CPC') || strcmp(datatype,'OISST') || strcmp(datatype,'PRISM') ||...
        strcmp(datatype,'10x10box') || strcmp(datatype,'NorESM1M') ||...
        strcmp(datatype,'CNRMCM5') || strcmp(datatype,'IPSLCM5AMR') || strcmp(datatype,'CSIROMk360') ||...
        strcmp(datatype,'MPIESMMR') || strcmp(datatype,'MIROC5') || strcmp(datatype,'custom') ||...
        strcmp(datatype,'ERA-Interim') || strcmp(datatype,'CESM1deg')
else
    disp('Please enter a valid data type.');
    return;
end

if ischar(region);fprintf('Region chosen is: %s\n',region);else;disp('Region is numbers only, no name given');end
disp('Variable arguments chosen are listed below:');
disp(vararginnew);
if mod(length(vararginnew),2)~=0
    disp('Error: must have an even # of arguments.');
else
    for count=1:2:length(vararginnew)-1
        key=vararginnew{count};
        val=vararginnew{count+1};
        switch key
            case 'variable'
                vartype=val; %'generic scalar', 'wind', 'temperature', 'height', 'wet-bulb temp', 'wv flux convergence', or 'specific humidity'
            case 'centeredon' %longitude to center the world map on -- default is 0, other typical option is 180
                centeredon=val; 
            case 'levelplotted' %pressure level plotted -- current options are 1000, 850, 500, 300, or 200
                levelplotted=val;
            case 'contour_underlay'
                contour_underlay=val;
            case 'mystepunderlay'
                mystepunderlay=val; 
            case 'underlaycolormap'
                underlaycolormapVal=val;
            case 'underlaycaxismin'
                underlaycaxis_min=val;
            case 'underlaycaxismax'
                underlaycaxis_max=val;
            case 'figc'
                figc=val;
            case 'title'
                fgTitle=val;
            case 'xaxis'
                fgXaxis=val;
            case 'yaxis'
                fgYaxis=val;
            case 'mlabelon'
                mlabelon=1;
            case 'nonewfig'
                noNewFig=val;
            case 'twodifferentaxes'
                twodifferentaxes=val;
            case 'contour_overlay'
                contour_overlay=val;
            case 'caxismin'
                caxis_min=val;
            case 'caxismax'
                caxis_max=val;
            case 'caxismethod'
                caxis_method=val; %'regional10', 'regional25', or 'world' (last is default)
            case 'mystep'
                mystep=val;
            case 'overlaycolormap'
                overlaycolormapVal=val;
            case 'vectorData'
                vectorData=val;
            case 'customwindvectorlength'
                customwindvectorlength=val; %ranges from 5 for relatively long vectors to 1 for relatively short ones
            case 'anomavg'
                anomavg=val;
            case 'overlaynow'
                overlaynow=val;
            case 'overlayvariable'
                overlayvartype=val; %will be plotted as contours or barbs
            case 'overlayvariable2'
                overlayvartype2=val; %wind, so will be plotted as barbs
            case 'underlayvariable'
                underlayvartype=val; %will be plotted as colors
            case 'datatooverlay'
                overlaydata=val;
            case 'datatooverlay2'
                overlaydata2=val;
            case 'datatounderlay'
                underlaydata=val;
            case 'unevencolordemarcations'
                unevencolordemarcations=val;
            case 'contourlabels' %whether to add contour labels, or omit them
                contourlabels=val;
            case 'fullresboundaries' %whether to plot time-consumingly full-resolution boundaries -- default is 0
                fullresboundaries=val;
            case 'stateboundaries' %1 or 0; whether to show US state boundaries
                stateboundaries=val;
            case 'countryboundaries' %1 or 0; whether to show country boundaries -- overrides default
                countryboundaries=val;
            case 'conttoplot'
                customcont=val;
            case 'customborderwidth' %default (if this is not set) is 1
                borderlinewidth=val;
            case 'omitzerocontour' %whether to omit the zero countour, in contour plots
                omitzerocontour=val;
            case 'omitfirstsubplotcolorbar' %whether to omit the colorbar on the first subplot 
                    %(b/c it'll either be added after or not at all)
                omitfirstsubplotcolorbar=1;
            case 'colorbarposition'
                colorbarposition=val;
            case 'colorbarfontsize'
                colorbarfontsize=val;
            case 'colorbarxticks'
                colorbarxticks=val;
            case 'nolinesbetweenfilledcontours' %whether to omit the lines between filled contours in the underlaid data
                nolinesbetweenfilledcontours=1;
            case 'manualcontourlabels' %whether to place contour labels manually or algorithmically
                manualcontourlabels=1;
            case 'cblabelfontsize' %font size of colorbar labels (same font size appears bigger when plotted region is smaller)
                cblabelfontsize=val;
            case 'transparency'
                transparency=val; %0 is fully transparent, 1 is normal
            case 'plotasrasters'
                plotasrasters=val; %1 plots as rasters (mostly to address wrap-around issues for full world maps), 0 does the original default
            case 'facealphaval'
                facealphaval=val;
            case 'stippling'
                signifpts=val;
            case 'nobordersatall'
                nobordersatall=1;
            case 'noframe'
                noframe=1;
            case 'nansblack'
                nansblack=1;
            case 'nanswhite'
                nanswhite=1;
            case 'nansgray'
                nansgray=1;
            case 'nanstransparent'
                nanstransparent=1;
        end
    end
end
exist transparency;
if ans==0;transparency=1;end %i.e. make normal (non-transparent)
exist plotasrasters;
if ans==0;plotasrasters=0;end %i.e. do the original default mode
exist figc;if ans==1;figc=figc+1;else;figc=1;end
exist facealphaval;
if ans==0;facealphaval=1;end
exist nobordersatall;
if ans==1;nobordersatall=1;else;nobordersatall=0;end

%Only make a new figure (as opposed to a new subplot) if called upon to do so
if noNewFig~=1
    fg=figure(figc);clf;
    set(fg,'Color',[1,1,1]);
    axis off;
    title(fgTitle);xlabel(fgXaxis);ylabel(fgYaxis);
end

exist contourlabels;
if ans==0;contourlabels=0;end
exist contour_underlay;
if ans==0;contour_underlay=0;end
exist contour_overlay;
if ans==0;contour_overlay=0;end
exist cblabelfontsize;
if ans==0;cblabelfontsize=15;end


if ischar(region)
    if strcmp(region, 'world')
        mapproj='robinson';
        exist centeredon;
        if ans==1
            if centeredon==0
                southlat=-90;northlat=90;westlon=-180;eastlon=180;
            elseif centeredon==180
                southlat=-90;northlat=90;westlon=-360;eastlon=0; 
            end
        else
            southlat=-90;northlat=90;westlon=-180;eastlon=180;
        end
        conttoplot='all';
    elseif strcmp(region,'worldnorthof60s')
        southlat=-60;northlat=90;mapproj='robinson';
        exist centeredon;
        if ans==1
            if centeredon==0
                westlon=-180;eastlon=180;
            elseif centeredon==180
                westlon=-360;eastlon=0;
            end
        else
            westlon=-180;eastlon=180;
        end
        conttoplot='all';
    elseif strcmp(region,'worldminuspoles')
        southlat=-55;northlat=70;mapproj='robinson';
        exist centeredon;
        if ans==1
            if centeredon==0
                westlon=-180;eastlon=180;
            elseif centeredon==180
                westlon=-360;eastlon=0;
            end
        else
            westlon=-180;eastlon=180;
        end
        conttoplot='all';
    elseif strcmp(region,'nhplustropics')
        southlat=-10;northlat=90;mapproj='robinson';
        exist centeredon;
        if ans==1
            if centeredon==0
                westlon=-180;eastlon=180;
            elseif centeredon==180
                westlon=-360;eastlon=0;
            end
        else
            westlon=-180;eastlon=180;
        end
        conttoplot='all';
    elseif strcmp(region,'world30s40n130wto160e')
        southlat=-30;northlat=40;westlon=-130;eastlon=160;mapproj='robinson';conttoplot='all';    
    elseif strcmp(region,'world60s60n')
        southlat=-60;northlat=60;westlon=-180;eastlon=180;mapproj='robinson';conttoplot='all';
    elseif strcmp(region,'world60s60n_mainlandareasonly')
        southlat=-60;northlat=60;westlon=-130;eastlon=160;mapproj='robinson';conttoplot='all';
    elseif strcmp(region,'world50s50n')
        southlat=-50;northlat=50;westlon=-180;eastlon=180;mapproj='robinson';conttoplot='all';
    elseif strcmp(region,'world45s45n')
        southlat=-45;northlat=45;westlon=-180;eastlon=180;mapproj='robinson';conttoplot='all';
    elseif strcmp(region,'world40s40n')
        southlat=-40;northlat=40;westlon=-180;eastlon=180;mapproj='robinson';conttoplot='all';
    elseif strcmp(region,'world35s35n')
        southlat=-35;northlat=35;westlon=-180;eastlon=180;mapproj='robinson';conttoplot='all';
    elseif strcmp(region,'world30s30n')
        southlat=-30;northlat=30;westlon=-180;eastlon=180;mapproj='robinson';conttoplot='all';
    elseif strcmp(region,'world30s40n')
        southlat=-30;northlat=40;westlon=-180;eastlon=180;mapproj='robinson';conttoplot='all';
    elseif strcmp(region, 'nnh')
        southlat=30;northlat=90;westlon=-180;eastlon=180;mapproj='stereo';conttoplot='all';
    elseif strcmp(region, 'nh0to60')
        southlat=0;northlat=60;westlon=-180;eastlon=180;mapproj='robinson';conttoplot='all';
    elseif strcmp(region, 'nh0to60n140wto140e')
        southlat=0;northlat=60;westlon=-140;eastlon=140;mapproj='robinson';conttoplot='all';
    elseif strcmp(region, 'northern-south-america')
        southlat=-30;northlat=15;westlon=-90;eastlon=-30;mapproj='mercator';conttoplot='all';
    elseif strcmp(region, 'northern-south-america-sm')
        southlat=-25;northlat=5;westlon=-70;eastlon=-43;mapproj='mercator';conttoplot='all';
    elseif strcmp(region, 'greater-north-america-tropical-pacific')
        southlat=-10;northlat=70;westlon=-178;eastlon=-55;mapproj='lambert';conttoplot='all';
    elseif strcmp(region, 'greater-north-america')
        southlat=10;northlat=70;westlon=-175;eastlon=-50;mapproj='lambert';conttoplot='all';
    elseif strcmp(region, 'north-america')
        southlat=20;northlat=80;westlon=-170;eastlon=-35;mapproj='lambert';conttoplot='all';
    elseif strcmp(region,'pacific-north-america')
        southlat=20;northlat=70;westlon=-180;eastlon=-60;mapproj='robinson';conttoplot='North America';
    elseif strcmp(region,'pacific-north-america-sm')
        southlat=20;northlat=70;westlon=-170;eastlon=-60;mapproj='robinson';conttoplot='North America';
    elseif strcmp(region, 'na-west')
        southlat=21;northlat=60;westlon=-170;eastlon=-100;mapproj='robinson';conttoplot='North America';
    elseif strcmp(region, 'na-west-slightlysmaller')
        southlat=22.5;northlat=60;westlon=-165.5;eastlon=-102.5;mapproj='robinson';conttoplot='North America';
    elseif strcmp(region, 'na-east')
        southlat=25;northlat=55;westlon=-100;eastlon=-50;mapproj='lambert';conttoplot='North America';
    elseif strcmp(region, 'north-america-europe')
        southlat=20;northlat=65;westlon=-135;eastlon=50;mapproj='robinson';conttoplot='all';
    elseif strcmp(region, 'north-atlantic')
        worldmap([25 75],[-75 10]);mapproj='lambert';conttoplot='all';
    elseif strcmp(region, 'north-atlantic-small')
        southlat=10;northlat=50;westlon=-80;eastlon=-25;mapproj='mercator';conttoplot='all';
    elseif strcmp(region,'alps')
        southlat=39.5;northlat=57.5;westlon=1;eastlon=21;mapproj='mercator';conttoplot='Europe';
    elseif strcmp(region,'caspiansea')
        southlat=33.5;northlat=48.5;westlon=44;eastlon=59;mapproj='mercator';conttoplot='Asia';
    elseif strcmp(region,'middle-east-india')
        southlat=5;northlat=45;westlon=30;eastlon=100;mapproj='mercator';conttoplot='all';
    elseif strcmp(region,'middle-east')
        southlat=10;northlat=45;westlon=30;eastlon=80;mapproj='mercator';conttoplot='all';
    elseif strcmp(region,'middle-east-small')
        southlat=15;northlat=36;westlon=30;eastlon=70;mapproj='mercator';conttoplot='Asia';
    elseif strcmp(region,'persian-gulf-greater')
        southlat=18.5;northlat=35;westlon=43.5;eastlon=62.25;mapproj='mercator';conttoplot='all';
    elseif strcmp(region,'persian-gulf')
        southlat=20;northlat=32;westlon=43;eastlon=60;mapproj='mercator';conttoplot='all';
    elseif strcmp(region,'persian-gulf-slightlysmaller')
        southlat=21;northlat=30;westlon=48.5;eastlon=57.25;mapproj='mercator';conttoplot='Asia';
    elseif strcmp(region,'persian-gulf-sm')
        southlat=23;northlat=30;westlon=48.5;eastlon=57.25;mapproj='mercator';conttoplot='Asia';
    elseif strcmp(region,'dubai-area')
        southlat=23.99;northlat=26.51;westlon=54.1;eastlon=56.4;mapproj='mercator';conttoplot='Asia';
    elseif strcmp(region,'red-sea')
        southlat=13;northlat=26;westlon=34;eastlon=44;mapproj='mercator';conttoplot='all';
    elseif strcmp(region,'southeast-asia')
        southlat=0;northlat=30;westlon=75;eastlon=105;mapproj='mercator';conttoplot='Asia';
    elseif strcmp(region,'south-asia')
        southlat=5;northlat=35;westlon=60;eastlon=95;mapproj='mercator';conttoplot='Asia';
    elseif strcmp(region,'eindia')
        southlat=15;northlat=27.5;westlon=78.75;eastlon=98.75;mapproj='mercator';conttoplot='Asia';
    elseif strcmp(region,'eindia-sm')
        southlat=15;northlat=27.5;westlon=78.75;eastlon=93;mapproj='mercator';conttoplot='Asia';
    elseif strcmp(region,'eindia-evensmaller')
        southlat=17;northlat=27.5;westlon=80;eastlon=92;mapproj='mercator';conttoplot='Asia';
    elseif strcmp(region,'pakistan-muchgreater')
        southlat=19;northlat=39;westlon=59;eastlon=80;mapproj='mercator';conttoplot='Asia';
    elseif strcmp(region,'pakistan-greater')
        southlat=21.5;northlat=38;westlon=62.5;eastlon=77.25;mapproj='mercator';conttoplot='Asia';
    elseif strcmp(region,'pakistan-slightlygreater')
        southlat=25.5;northlat=35;westlon=65;eastlon=75;mapproj='mercator';conttoplot='Asia';
    elseif strcmp(region,'pakistan')
        southlat=26.5;northlat=33;westlon=67.5;eastlon=72.25;mapproj='mercator';conttoplot='Asia';
    elseif strcmp(region,'schina')
        southlat=17.5;northlat=36.5;westlon=96;eastlon=115;mapproj='mercator';conttoplot='Asia';
    elseif strcmp(region,'saus')
        southlat=-38;northlat=-19;westlon=124.5;eastlon=143.5;mapproj='mercator';conttoplot='Australia';
    elseif strcmp(region,'safr')
        southlat=-37;northlat=-20;westlon=21;eastlon=41;mapproj='mercator';conttoplot='Africa';
    elseif strcmp(region,'samer')
        southlat=-37;northlat=-20;westlon=-72.5;eastlon=-52.5;mapproj='mercator';conttoplot='all';
    elseif strcmp(region,'wamazon')
        southlat=-18.75;northlat=-2.5;westlon=-75;eastlon=-61.25;mapproj='mercator';conttoplot='South America';
    elseif strcmp(region,'wamazon-south')
        southlat=-18;northlat=-8;westlon=-73;eastlon=-62;mapproj='mercator';conttoplot='South America';
    elseif strcmp(region, 'usa-canada')
        southlat=23;northlat=70;westlon=-140;eastlon=-50;mapproj='robinson';conttoplot='North America';
    elseif strcmp(region,'greater-mexico')
        southlat=10;northlat=36;westlon=-122;eastlon=-80;mapproj='mercator';conttoplot='all';
    elseif strcmp(region,'midlatband')
        southlat=10;northlat=60;westlon=-180;eastlon=-50;mapproj='lambert';conttoplot='all';
    elseif strcmp(region,'usa-full')
        southlat=15;northlat=75;westlon=-180;eastlon=-60;mapproj='lambert';conttoplot='North America';
    elseif strcmp(region,'usaminushawaii-tight')
        southlat=22;northlat=73;westlon=-175;eastlon=-65;mapproj='lambert';conttoplot='North America';
    elseif strcmp(region,'usaminushawaii-tight2')
        southlat=20;northlat=75;westlon=-175;eastlon=-60;mapproj='lambert';conttoplot='North America';
    elseif strcmp(region,'usaminushawaii-tight3') %a little more centered over the Lower 48
        southlat=20;northlat=75;westlon=-165;eastlon=-45;mapproj='robinson';conttoplot='North America';
    elseif strcmp(region, 'usa-exp')
        southlat=23;northlat=60;westlon=-135;eastlon=-55;mapproj='lambert';conttoplot='North America';
    elseif strcmp(region, 'usa-exp2')
        southlat=15;northlat=75;westlon=-165;eastlon=-50;mapproj='lambert';conttoplot='North America';
    elseif strcmp(region, 'usa')
        southlat=25;northlat=50;westlon=-126;eastlon=-64;mapproj='robinson';conttoplot='North America';
    elseif strcmp(region,'rockies')
        southlat=31;northlat=51;westlon=-111;eastlon=-93;mapproj='mercator';conttoplot='North America';
    elseif strcmp(region, 'greater-eastern-usa')
        southlat=18;northlat=50;westlon=-102;eastlon=-65;mapproj='robinson';conttoplot='North America';
    elseif strcmp(region, 'eastern-usa')
        southlat=23;northlat=50;westlon=-100;eastlon=-65;mapproj='robinson';conttoplot='North America';
    elseif strcmp(region,'central-usa')
        %southlat=30;northlat=48.5;westlon=-104;eastlon=-82;mapproj='mercator';conttoplot='North America';
        southlat=33;northlat=48.5;westlon=-104;eastlon=-82;mapproj='mercator';conttoplot='North America';
    elseif strcmp(region,'us-mw')
        southlat=33;northlat=48;westlon=-105;eastlon=-80;mapproj='mercator';conttoplot='North America';
    elseif strcmp(region,'midwestus')
        southlat=30;northlat=49;westlon=-102;eastlon=-83;mapproj='mercator';conttoplot='North America';
    elseif strcmp(region,'omaha-area')
        southlat=39.5;northlat=43;westlon=-98;eastlon=-94;mapproj='mercator';conttoplot='North America';
    elseif strcmp(region, 'us-ne')
        southlat=35;northlat=50;westlon=-85;eastlon=-60;mapproj='mercator';conttoplot='North America';
    elseif strcmp(region,'us-se')
        southlat=23;northlat=38;westlon=-100;eastlon=-74;mapproj='mercator';conttoplot='North America';
    elseif strcmp(region,'us-gulf-coast')
        southlat=24;northlat=32;westlon=-100;eastlon=-78;mapproj='mercator';conttoplot='North America';
    elseif strcmp(region, 'western-usa')
        southlat=30;northlat=54;westlon=-125;eastlon=-90;mapproj='robinson';conttoplot='North America';
    elseif strcmp(region,'us-sw')
        southlat=25;northlat=45;westlon=-130;eastlon=-105;mapproj='mercator';conttoplot='North America';
    elseif strcmp(region,'us-sw-small')
        southlat=31;northlat=39;westlon=-121;eastlon=-109;mapproj='mercator';conttoplot='North America';
    elseif strcmp(region,'la-area')
        southlat=33.2;northlat=35;westlon=-119.2;eastlon=-116.5;mapproj='mercator';conttoplot='North America';
    elseif strcmp(region,'labasin')
        southlat=33.5;northlat=34.3;westlon=-119.1;eastlon=-117.3;mapproj='mercator';conttoplot='North America';
    elseif strcmp(region, 'us-ne-small')
        southlat=38;northlat=46;westlon=-80;eastlon=-68;mapproj='mercator';conttoplot='North America';
    elseif strcmp(region, 'ny-pa-nj')
        southlat=38;northlat=45.1;westlon=-80;eastlon=-71.5;mapproj='mercator';conttoplot='North America';
    elseif strcmp(region, 'nyc-area')
        southlat=39;northlat=42;westlon=-76;eastlon=-72;mapproj='mercator';conttoplot='North America';
    elseif strcmp(region, 'nyc-area-small')
        southlat=40.4;northlat=41.1;westlon=-74.4;eastlon=-73.6;mapproj='mercator';conttoplot='North America';
    elseif strcmp(region, 'nyc-only')
        southlat=40.5;northlat=40.9;westlon=-74.1;eastlon=-73.7;mapproj='mercator';conttoplot='North America';
    elseif strcmp(region, 'justnumbers')
    else
        worldmap(region);
        underlaydata{1}(:, end+1) = underlaydata{1}(:, end) + (underlaydata{1}(:, end)-underlaydata{1}(:, end-1));
        underlaydata{2}(:, end+1) = underlaydata{2}(:, end) + (underlaydata{2}(:, end)-underlaydata{2}(:, end-1));
        conttoplot='all';
    end
else %region is a cell array containing 4 bounds, in the order w,n,e,s
    southlat=region{4};northlat=region{2};westlon=region{1};eastlon=region{3};mapproj='mercator';conttoplot=customcont;
end


numgridptsperdegree1=sz1/360;
numgridptsperdegree2=sz2/180;
%Convert lat/lon corners to gridpts
if strcmp(datatype,'NARR')
    temp1=wnarrgridpts(northlat,eastlon,1,0,1);
    temp2=wnarrgridpts(southlat,westlon,1,0,1);
elseif strcmp(datatype,'NCEP144')
    temp1=wncepgridpts(northlat,eastlon,1,0,144);
    exist centeredon;
    if ans==1
        if centeredon==0
            temp2=wncepgridpts(southlat,westlon,1,0,144);
        elseif centeredon==180
            temp2=wncepgridpts(southlat,eastlon,1,0,144);
        else
            disp('Please make centeredon 0 or 180');return;
        end
    else
        %Default is western hemisphere, equivalent to centeredon=0
        temp2=wncepgridpts(southlat,westlon,1,0,144);
    end
elseif strcmp(datatype,'NCEP192')
    temp1=wncepgridpts(northlat,eastlon,1,0,192);
    exist centeredon;
    if ans==1
        if centeredon==0
            temp2=wncepgridpts(southlat,westlon,1,0,192);
        elseif centeredon==180
            temp2=wncepgridpts(southlat,eastlon,1,0,192);
        else
            disp('Please make centeredon 0 or 180');return;
        end
    else
        %Default is western hemisphere, equivalent to centeredon=0
        temp2=wncepgridpts(southlat,westlon,1,0,192);
    end
elseif strcmp(datatype,'CPC') %north on top, centered on 180
    northindex=1+180-2*northlat;southindex=180-2*southlat;
    westindex=1;eastindex=720;
elseif strcmp(datatype,'custom') %any size array that's desired can be accommodated
    northindex=1;southindex=sz1;
    westindex=1;eastindex=sz2;
else
    if southlat>=0;southindex=sz2-((90-southlat)*numgridptsperdegree2);else southindex=(90+southlat)*numgridptsperdegree2;end
    if northlat>=0;northindex=sz2-((90-northlat)*numgridptsperdegree2);else northindex=(90+northlat)*numgridptsperdegree2;end
    if westlon>=0;westindex=sz1-((180-westlon)*numgridptsperdegree1);else westindex=(180+westlon)*numgridptsperdegree1;end
    if eastlon>=0;eastindex=sz1-((180-eastlon)*numgridptsperdegree1);else eastindex=(180+eastlon)*numgridptsperdegree1;end
    if southindex==0;southindex=1;end
    if northindex==0;northindex=1;end
    if westindex==0;westindex=1;end
    if eastindex==0;eastindex=1;end
end

%If necessary, move Eastern Hemisphere to left so array is centered on 180
exist centeredon;
if ans==1
    exist underlayvartype;
    if ans==1
        arraysz=size(underlaydata{1});
    end
    if centeredon==180 %essentially need to move one half of the array to the other side before plotting can proceed
        exist underlayvartype;
        disp('Moving Eastern Hemisphere to left to center array on 180 W');
        if ans==1
            arraysz=size(underlaydata{3});
            underlaydata{3}=[underlaydata{3}(:,arraysz(2)/2+1:arraysz(2)) underlaydata{3}(:,1:arraysz(2)/2)];
        end
    end
end
    
%Account for the fact that the inputted corners may be just outside the domain
if ~strcmp(datatype,'OISST')
    if ~strcmp(region,'world')
        exist northindex;
        if ans==0
            if temp1(1,1)<1000;northindex=temp1(1,1);else northindex=sz1;end
            if temp1(1,2)<1000;eastindex=temp1(1,2);else eastindex=sz2;end
            if temp2(1,1)<1000;southindex=temp2(1,1);else southindex=1;end
            if temp2(1,2)<1000;westindex=temp2(1,2);else westindex=1;end
        end
    else
        northindex=1;eastindex=1;southindex=sz2;westindex=sz1;
    end
end

ax1=axesm(mapproj,'MapLatLimit',[southlat northlat],'MapLonLimit',[westlon eastlon]);
%fprintf('At line 572, southlat is %d, northlat is %d, westlon is %d, eastlon is %d\n',southlat,northlat,westlon,eastlon);return;

framem on;gridm off;axis on;axis off;
exist mlabelon;
if ans==0
    mlabel off;
end
exist plabelon;
if ans==0
    plabel off;
end
exist noframe;
if ans==1;framem off;end
set(gca,'Position',[0.06 0.6 0.4 0.2]);

if ~noNewFig
    if length(underlaycolormapVal)>0;set(gca,'colormap',underlaycolormapVal);else;set(gca,'colormap',colormap('jet'));end
    underlaycolormap=colormap;
end
if length(underlaycolormapVal)>0;underlaycolormap=underlaycolormapVal;end

exist underlaydata;
if ans==0
    underlaydata=data;
end
exist vartype;
if ans==0;underlayvartype=vartype;end

exist underlayvartype;
if ans==1
    if strcmp(underlayvartype,'wet-bulb temp') || strcmp(underlayvartype,'temperature')
        dispunits='deg C';
    elseif strcmp(underlayvartype,'height')
        dispunits='m';
    elseif strcmp(underlayvartype,'wind')
        dispunits='m/s';
    elseif strcmp(underlayvartype,'specific humidity')
        dispunits='g/kg';
        %underlaydata{3}=underlaydata{3}.*1000;
    elseif strcmp(underlayvartype,'wv flux convergence')
        dispunits='kg/m^-^2';
    elseif strcmp(underlayvartype,'generic scalar')
        dispunits=''; %no units necessary
    else
        dispunits='';
    end
else
    if strcmp(vartype,'wet-bulb temp') || strcmp(vartype,'temperature')
        dispunits='deg C';
    elseif strcmp(vartype,'height')
        dispunits='m';
    elseif strcmp(vartype,'wind')
        dispunits='m/s';
    elseif strcmp(vartype,'specific humidity')
        dispunits='g/kg';
        %underlaydata{3}=underlaydata{3}.*1000;
    elseif strcmp(vartype,'wv flux convergence')
        dispunits='kg/m^-^2';
    elseif strcmp(vartype,'generic scalar')
        dispunits=''; %no units necessary
    else
        dispunits='';
    end
end


%Determine the color range, either by specification in the function call or by default here
%Account for the fact that we don't know a priori which of (eastindex,westindex) and (southindex,northindex) will be larger
exist caxis_min;
if ans==0
    exist underlaycaxis_min;
    if ans==0
        exist caxis_method;
        if ans==0 %default is to determine range globally
            exist underlaydata;
            if ans==1;caxis_min=round2(min(min(underlaydata{3})),mystep,'floor');end
        elseif strcmp(caxis_method,'regional10')
            caxis_min=round2(min(min(underlaydata{3}(min(eastindex,westindex):max(eastindex,westindex),...
                min(southindex,northindex):max(southindex,northindex)))),mystep,'floor');
            %caxis_min=round2(min(min(underlaydata{3})),mystep,'floor');
            disp('Note: Step size and color range have been overwritten to match the regional nature of the color axis.');
        elseif strcmp(caxis_method,'regional25')
            mystep=(max(max(underlaydata{3}(min(eastindex,westindex):max(eastindex,westindex),...
                min(southindex,northindex):max(southindex,northindex))))-...
                min(min(underlaydata{3}(min(eastindex,westindex):max(eastindex,westindex),...
                min(southindex,northindex):max(southindex,northindex)))))/25;
            caxis_min=round2(min(min(underlaydata{3}(min(eastindex,westindex):max(eastindex,westindex),...
                min(southindex,northindex):max(southindex,northindex)))),mystep,'floor');
            disp('Note: Step size and color range have been overwritten to match the regional nature of the color axis.');
        else
            caxis_min=round2(min(min(underlaydata{3})),mystep,'floor');
        end
    end
end
exist caxis_max;
if ans==0
    exist underlaycaxis_max;
    if ans==0
        exist caxis_method;
        if ans==0 %default is to determine range globally
            exist underlaydata;
            if ans==1;caxis_max=round2(max(max(underlaydata{3})),mystep,'ceil');end
        elseif strcmp(caxis_method,'regional10')
            caxis_max=round2(max(max(underlaydata{3}(min(eastindex,westindex):max(eastindex,westindex),...
                min(southindex,northindex):max(southindex,northindex)))),mystep,'ceil');
        elseif strcmp(caxis_method,'regional25')
            caxis_max=round2(max(max(underlaydata{3}(min(eastindex,westindex):max(eastindex,westindex),...
                min(southindex,northindex):max(southindex,northindex)))),mystep,'ceil');
        else
            caxis_max=round2(max(max(underlaydata{3})),mystep,'ceil');
        end
    end
end

%Set underlay-data color axis
exist underlaycaxis_min;
if ans==1
    caxisRangeunderlay=[underlaycaxis_min,underlaycaxis_max];caxis(caxisRangeunderlay);
end


%Display the underlaid (or only) data, contoured or not
%This loop occasionally and unpredictably behaves problematically, so keep an eye out for that
exist underlaydata;
if ans==1
    if contour_underlay
        if size(underlaydata{3},1)~=size(underlaydata{2},1);underlaydata{3}=underlaydata{3}';end
        exist unevencolordemarcations;
        if ans==0 %step is set or chosen to be a fixed value
            v=underlaycaxis_min:mystepunderlay:underlaycaxis_max;
        else %variable intervals are set to demarcate colors
            v=unevencolordemarcations;
        end
        exist nolinesbetweenfilledcontours;
        %Option a: no lines between filled contours
        if ans==1
            if plotasrasters==1
                latlim=[southlat northlat];
                disp(westlon);disp(eastlon);
                if westlon<0;eastlon=eastlon-westlon;westlon=0;end
                disp(westlon);disp(eastlon);
                %if eastlon<0;eastlon=eastlon+360;end
                if strcmp(region,'world');westlon=0;eastlon=360;end %if plotting entire globe
                lonlim=[westlon eastlon];
                Z1=underlaydata{3};
                R=georefcells(latlim,lonlim,size(Z1),'ColumnsStartFrom','north');
                contourm(Z1,R,v,'Fill','on');hold on;
            else %the original default mode
                h=contourm(underlaydata{1},underlaydata{2},underlaydata{3},v,'Fill','on','edgecolor','none');hold on;
                if transparency~=1;alpha(transparency);end
            end
        else %Option b: black lines between filled contours
            if plotasrasters==1
                latlim=[southlat northlat];
                if westlon<0;eastlon=eastlon-westlon;westlon=0;end
                if strcmp(region,'world');westlon=0;eastlon=360;end %if plotting entire globe
                lonlim=[westlon eastlon];
                Z1=underlaydata{3};
                R=georefcells(latlim,lonlim,size(Z1),'ColumnsStartFrom','north');
                contourm(Z1,R,v,'Fill','on');hold on;
            else %the original default mode
                %disp(transparency);disp(v);
                h=contourm(underlaydata{1},underlaydata{2},underlaydata{3},v,'Fill','on');
                hold on;
                if transparency~=1;alpha(transparency);end
            end
        end
        exist nansblack;
        if ans==1
            thesenans=isnan(underlaydata{3});
            underlaydata{3}(thesenans)=999;
            underlaycolormap(1,:)=[0 0 0];
        end
        colormap(ax1,underlaycolormap);
        
    else
        t=pcolorm(underlaydata{1},underlaydata{2},underlaydata{3},'FaceAlpha',facealphaval);hold on;
        
        exist nanstransparent;
        if ans==1
            set(t,'alphadata',~isnan(underlaydata{3}));
        end
        
        exist nanswhite;
        if ans==1
            thesenans=isnan(underlaydata{3});
            underlaydata{3}(thesenans)=999;
            underlaycolormap(1,:)=[1 1 1];
        end
        exist nansgray;
        if ans==1
            thesenans=isnan(underlaydata{3});
            underlaydata{3}(thesenans)=999;
            underlaycolormap(1,:)=[0.6 0.6 0.6];
        end
        exist nansblack;
        if ans==1
            thesenans=isnan(underlaydata{3});
            underlaydata{3}(thesenans)=999;
            underlaycolormap(1,:)=[0 0 0];
        end
        exist underlaycolormap;if ans==1;colormap(ax1,underlaycolormap);end
            
        %Applying stippling, if desired (adds about 5 min)
        %This code needs to be adjusted manually for each dataset
        exist signifpts;
        if ans==1
            numsigniffound=0;
            for i=1:size(underlaydata{1},1)
                for j=1:size(underlaydata{1},2)
                    if i<=35 || i>=55 %extratropics
                        if signifpts(i,j)==1
                            plotm(underlaydata{1}(i,j),underlaydata{2}(i,j),signifpts(i,j),'k.');
                            numsigniffound=numsigniffound+1;
                        end
                    end
                end
                if rem(i,20)==0;fprintf('At %d for stippling section of plotModelData\n',i);end
            end
        end
    end
end


%%%Prepare settings for displaying wind vectors%%%

%Calculate factors based on map size by which to multiply wind-vector sizes so that
    %they are visually accurate no matter what the map size is
%Tweaking should no longer be necessary (see recent changes in scaleval and reference-vector length within quivermc),
    %but if it is deemed to be so, proceed with caution so that any results are generalizable 
    %and excessive work need not be repeated with each minor change in the mapping options
    %Also, refvectorshrinkfactor is an outdated after-market attempt at fudging it and should NOT be changed from 1
%Tweak maparea as needed (for each region separately) to empirically make the vectors look right
    %to make arrows smaller (larger), divide maparea by a number > (<) 1 or make refval larger (smaller)
    %changing the size of the arrows must be accompanied by a corresponding change in refvectorshrinkfactor
        %e.g. if all other arrows are halved, set refvectorshrinkfactor=2 to halve it as well (default=1)
    %to make arrows more (less) dense, reduce (increase) extraskipstepfactor
    %don't change q as it affects both the length and the density
    %only refvectorshrinkfactor changes ref-vector length independent of the plotted arrows
    %(and since it's now been pretty well calibrated, it shouldn't need to be changed at all)
    
%Defaults for all regions: refvectorshrinkfactor=1, maparea=maparea/4
if length(vectorData)~=0
    maparea=(northlat-southlat)*(eastlon-westlon);
    if strcmp(region,'nhplustropics') || strcmp(region, 'north-america') || strcmp(region,'midlatband') || strcmp(region,'usa-canada')
        q=4;extraskipstepfactor=2; %only plot every qth vector, further skipping selon skipstep
        exist levelplotted;
        if ans==1
            if length(levelplotted)~=0
                if levelplotted<=300 %high-level winds so reference vector must be longer
                    if strcmp(anomavg,'anom');refval=25;else;refval=50;end
                else
                    if strcmp(anomavg,'anom');refval=15;else;refval=30;end
                end
            end
        else
            if strcmp(anomavg,'anom');refval=15;else;refval=30;end %default
        end
        refvectorshrinkfactor=1;
        maparea=maparea/4; %dividing by a larger number fools quivermc into making the arrows smaller
    elseif strcmp(region, 'usa-exp') || strcmp(region,'usaminushawaii-tight') || ...
            strcmp(region,'usaminushawaii-tight2') || strcmp(region, 'usa-exp2')
        q=4;extraskipstepfactor=2;
        exist levelplotted;
        if ans==1
            if length(levelplotted)~=0
                if levelplotted<=300 %high-level winds so reference vector must be longer
                    if strcmp(anomavg,'anom');refval=25;else;refval=50;end
                else
                    if strcmp(anomavg,'anom');refval=15;else;refval=30;end
                end
            end
        else
            if strcmp(anomavg,'anom');refval=7.5;else;refval=15;end %default
        end
        refvectorshrinkfactor=1;
        maparea=maparea/4;
    elseif strcmp(region,'usaminushawaii-tight3') || strcmp(region,'usa') || strcmp(region,'greater-eastern-usa') || strcmp(region,'northern-south-america')
        q=4;extraskipstepfactor=2;
        exist levelplotted;
        if ans==1
            if length(levelplotted)~=0
                if levelplotted<=300 %high-level winds so reference vector must be longer
                    if strcmp(anomavg,'anom');refval=25;else;refval=50;end
                else
                    if strcmp(anomavg,'anom');refval=7.5;else;refval=15;end
                end
            end
        else
            if strcmp(anomavg,'anom');refval=4;else refval=8;end
        end
        refvectorshrinkfactor=0.5;
        maparea=maparea/2;
    elseif strcmp(region,'middle-east') || strcmp(region,'middle-east-small')
        q=4;extraskipstepfactor=1;
        exist levelplotted;
        if ans==1
            if length(levelplotted)~=0
                if levelplotted<=300 %high-level winds so reference vector must be longer
                    if strcmp(anomavg,'anom');refval=25;else;refval=50;end
                else
                    if strcmp(anomavg,'anom');refval=7.5;else;refval=15;end
                end
            end
        else
            if strcmp(anomavg,'anom');refval=4;else refval=8;end
        end
        refvectorshrinkfactor=1;
        maparea=maparea/2;
    elseif strcmp(region, 'us-ne') || strcmp(region, 'us-ne-small') || strcmp(region,'us-sw-small') || strcmp(region,'us-mw') ||...
            strcmp(region,'us-se') || strcmp(region,'us-gulf-coast') || strcmp(region,'labasin') || strcmp(region,'wamazon')
        q=2;extraskipstepfactor=2;
        exist levelplotted;
        if ans==1
            if length(levelplotted)~=0
                if levelplotted<=300 %high-level winds so reference vector must be longer
                    if strcmp(anomavg,'anom');refval=12.5;else refval=25;end
                else
                    if strcmp(anomavg,'anom');refval=2.5;else refval=5;end
                end
            end
        else
            if strcmp(anomavg,'anom');refval=2.5;else refval=5;end %default
        end
        refvectorshrinkfactor=1;
        maparea=maparea/2;
    elseif strcmp(region,'persian-gulf') 
        q=2;extraskipstepfactor=0.5;
        exist levelplotted;
        if ans==1
            if length(levelplotted)~=0
                if levelplotted<=300 %high-level winds so reference vector must be longer
                    if strcmp(anomavg,'anom');refval=12.5;else refval=25;end
                else
                    if strcmp(anomavg,'anom');refval=2.5;else refval=5;end
                end
            end
        else
            if strcmp(anomavg,'anom');refval=2.5;else refval=5;end %default
        end
        refvectorshrinkfactor=1;
        maparea=maparea/2;
    elseif strcmp(region, 'nyc-area') || strcmp(region, 'nyc-area-small') || strcmp(region,'omaha-area') ||...
            strcmp(region,'nyc-only')
        q=1;extraskipstepfactor=1;
        exist levelplotted;
        if ans==1
            if length(levelplotted)~=0
                if levelplotted<=300 %high-level winds so reference vector must be longer
                    if strcmp(anomavg,'anom');refval=12.5;else;refval=25;end
                else
                    if strcmp(anomavg,'anom');refval=2.5;else;refval=5;end
                end
            end
        else
            if strcmp(anomavg,'anom');refval=2.5;else;refval=5;end %default
        end
        refvectorshrinkfactor=1;
        maparea=maparea/2;
    else
        disp('Please add region in the "Prepare settings for displaying wind vectors" section of plotModelData');
        disp('But let us go ahead and check if there are any custom settings to use');
        %return;
    end
    exist customwindvectorlength;
    if ans==1
        if customwindvectorlength==5
            q=1;extraskipstepfactor=1;
            refvectorshrinkfactor=1;refval=1;
            maparea=maparea/2;
        elseif customwindvectorlength==4
            q=1;extraskipstepfactor=2;
            refvectorshrinkfactor=1;refval=2;
            maparea=maparea/2;
        elseif customwindvectorlength==3
            q=1;extraskipstepfactor=1;
            refvectorshrinkfactor=1;refval=3;
            maparea=maparea/2;
        elseif customwindvectorlength==2
            q=1;extraskipstepfactor=1;
            refvectorshrinkfactor=1;refval=5;
            maparea=maparea/2;
        elseif customwindvectorlength==1
            q=1;extraskipstepfactor=1;
            refvectorshrinkfactor=1;refval=10;
            maparea=maparea/2;
        end
    end
end

%Plot overlaid data (scalar only)
if overlaynow==1
    %Add second axes, so this data can have its own colormap
    exist twodifferentaxes;
    if ans==1
        twoaxes=1;
        ax2=axesm(mapproj,'MapLatLimit',[southlat northlat],'MapLonLimit',[westlon eastlon]);
    else
        twoaxes=0;
        ax2=gca;
    end

    if contour_overlay==1
        if size(overlaydata,1)==3 %if it's wind, we don't want it to have labeled contours
            v=caxis_min:mystep:caxis_max;%disp('line 781');disp(v);
            exist omitzerocontour;
            if ans==1
                if omitzerocontour==1
                    %Plots positive solid and negative dashed, and omits the zero contour
                    if caxis_min<0
                        contourm(overlaydata{1},overlaydata{2},overlaydata{3},[caxis_min:mystep:0-mystep],...
                            '--','linewidth',1,'linecolor','k');hold on;
                        [C,h]=contourm(overlaydata{1},overlaydata{2},overlaydata{3},[mystep:mystep:caxis_max],...
                            'linewidth',1,'linecolor','k');
                    else
                        [C,h]=contourm(overlaydata{1},overlaydata{2},overlaydata{3},[mystep:mystep:caxis_max],...
                            'linewidth',1,'linecolor','k');
                    end
                else
                    %Plots all contours solid
                    [C,h]=contourm(overlaydata{1},overlaydata{2},overlaydata{3},v,'LineWidth',1,'LineColor','k');
                end
            else
                [C,h]=contourm(overlaydata{1},overlaydata{2},overlaydata{3},v,'LineWidth',1.5,'LineColor','k');
            end

            %Space out the labels so there's not too many but every line is still labeled
            %Bigger numbers = more space between labels
            if strcmp(region, 'us-ne') || strcmp(region, 'us-ne-small') || strcmp(region, 'nyc-area') || ...
                    strcmp(region, 'nyc-area-small') || strcmp(region,'nyc-only') || ...
                    strcmp(region,'us-sw-small') || strcmp(region,'omaha-area') || strcmp(region,'us-mw') ||...
                    strcmp(region,'us-se') || strcmp(region,'us-gulf-coast') || strcmp(region,'labasin')
                labelspacing=1000; 
            elseif strcmp(region, 'north-america') || strcmp(region,'midlatband') || strcmp(region,'usa') || strcmp(region,'usa-canada')
                labelspacing=500;
            else
                labelspacing=10000;
            end


            %Labels are made toward the end of the script, so that they are not
                %overwritten by state borders (search for "actually make labels")
        end
        hold on;
    
        exist overlayvartype2;
        if ans~=0
            contourm(overlaydata2{1},overlaydata2{2},overlaydata2{3},'LineWidth',2,'LineColor','k');
        end

        overlaymax=roundsd(max(max(overlaydata{3})),1);overlaymin=roundsd(min(min(overlaydata{3})),1);
        overlayrange=overlaymax-overlaymin;overlayrangetenths=overlayrange/10;
        exist mystep;
        if ans==0
            overlaysteps=overlaymin:overlayrangetenths:overlaymax;
        else
            overlaysteps=overlaymin:mystep:overlaymax;
        end
        %Round steps to nearest 'number that ends in a zero' so they aren't odd values
        for i=1:size(overlaysteps,2)
            if abs(overlaysteps(i))<10
                overlaysteps(i)=round2(overlaysteps(i),20);
            elseif abs(overlaysteps(i))<100
                overlaysteps(i)=round2(overlaysteps(i),40);
            elseif abs(overlaysteps(i))>=100
                overlaysteps(i)=round2(overlaysteps(i),200);
            end
        end
        overlaysteps=unique(overlaysteps); %remove duplicate values
    else
        ax=ax2;
        t=pcolorm(overlaydata{1},overlaydata{2},overlaydata{3},'FaceAlpha',facealphaval);hold on;

        exist nanswhite;
        if ans==1
            thesenans=isnan(overlaydata{3});
            overlaydata{3}(thesenans)=999;
            overlaycolormapVal(1,:)=[1 1 1];
        end
        exist nansgray;
        if ans==1
            thesenans=isnan(overlaydata{3});
            overlaydata{3}(thesenans)=999;
            overlaycolormapVal(1,:)=[0.6 0.6 0.6];
        end
        exist nansblack;
        if ans==1
            thesenans=isnan(overlaydata{3});
            overlaydata{3}(thesenans)=999;
            overlaycolormapVal(1,:)=[0 0 0];
        end
        
        linkaxes([ax1,ax2]);alpha(ax1,0.5)
        ax2.Visible='off';ax2.XTick=[];ax2.YTick=[];
        colormap(ax2,overlaycolormapVal);
    end
end

%Second overlaid variable could show up under either of these names
exist overlayvartype2;phrfound=0;
if ans==1
    if strcmp(overlayvartype2,'wind');phr='Arrows: Wind in m/s';else phr='';end
    phrfound=1;
end
exist overlaydata;
if ans==1 && phrfound==0
    if size(overlaydata,1)==4;phr='Arrows: Wind in m/s';else phr='';end
else
    phr='';
end
windbarbsdescr=phr;

%Plot geography in background
if ~nobordersatall
    load coast;framem on;
end


%Set color to shade the land areas (each US state and all countries in the domain)
co=colors('ghost white'); %defaults are ghost white or light gray, but this can be any color in 'colors' script
if ~nobordersatall
    cbc='k'; %countryboundarycolor
else
    cbc=colors('ghost white');
end

exist stateboundaries;
if ans==1
    exist fullresboundaries;
    if ans==1
        filename=unzip('gshhg-bin-2.3.7.zip');
        delete COPYING.LESSERv3;delete LICENSE.TXT;delete README.TXT;
        delete gshhs_c.b;delete gshhs_h.b;delete gshhs_i.b;delete gshhs_l.b;
        delete wdb_borders_c.b;delete wdb_borders_h.b;delete wdb_borders_i.b;delete wdb_borders_l.b;
        delete wdb_rivers_c.b;delete wdb_rivers_h.b;delete wdb_rivers_i.b;delete wdb_rivers_l.b;
        borderstoplot=gshhs(filename{4},[40 41.5],[-75.5 -73]);
        coaststoplot=gshhs(filename{17},[40 41.5],[-75.5 -73]);
        geoshow([borderstoplot.Lat],[borderstoplot.Lon],'Color','k','LineWidth',2);hold on;
        geoshow([coaststoplot.Lat],[coaststoplot.Lon],'Color','k');
        
        %Show counties
        %colin=shaperead('cb_2016_us_county_500k.shp','UseGeoCoords',true);
        %geoshow(colin,'DisplayType','polygon','DefaultFaceColor',co,'FaceAlpha',0);
    else
        if stateboundaries==1
            states=shaperead('usastatelo','UseGeoCoords',true);
            geoshow(states,'DisplayType','polygon','DefaultFaceColor',co,'FaceAlpha',0);
        end
    end
else %default is to show states only
    if ~nobordersatall
        states=shaperead('usastatelo','UseGeoCoords',true);
        geoshow(states,'DisplayType','polygon','DefaultFaceColor',co,'FaceAlpha',0);
    end
end


exist countryboundaries;
if ans==1
    if countryboundaries==0;cbc=colors('ghost white');co=cbc;end
end
exist borderlinewidth;if ans==0;borderlinewidth=1;end

if ~nobordersatall
lw=borderlinewidth;
addborders;
end


exist colorbarfontsize;
if ans==0
    colorbarfontsize=15;
end

exist colorbarxticks;
if ans==1
    specifyxticks=1;
else
    specifyxticks=0;
end


if ~noNewFig
    exist underlaydata; %i.e. if plotting anything that needs a colorbar
    if ans==1
        exist omitfirstsubplotcolorbar;
        if ans==1
            if omitfirstsubplotcolorbar~=1
                exist colorbarposition;
                if ans==0
                    cb=colorbar('Location','eastoutside');set(cb,'fontweight','bold','fontsize',colorbarfontsize);
                else
                    cb=colorbar;set(cb,'fontweight','bold','fontsize',colorbarfontsize,'Position',colorbarposition);
                end
                if specifyxticks==1;set(cb,'xtick',colorbarxticks);end
            end
        else
            exist colorbarposition;
            if ans==0
                cb=colorbar('Location','eastoutside');set(cb,'fontweight','bold','fontsize',colorbarfontsize);
            else
                cb=colorbar;set(cb,'fontweight','bold','fontsize',colorbarfontsize,'Position',colorbarposition);
            end
            if specifyxticks==1;set(cb,'xtick',colorbarxticks);end
        end
    end
else
    exist omitfirstsubplotcolorbar;
    if ans==1
        if omitfirstsubplotcolorbar~=1
            exist colorbarposition;
            if ans==0
                cb=colorbar('Location','eastoutside');set(cb,'fontweight','bold','fontsize',colorbarfontsize);
            else
                cb=colorbar;set(cb,'fontweight','bold','fontsize',colorbarfontsize,'Position',colorbarposition);
            end
            if specifyxticks==1;set(cb,'xtick',colorbarxticks);end
        end
    else
        exist colorbarposition;
        if ans==0
            cb=colorbar('Location','eastoutside');set(cb,'fontweight','bold','fontsize',colorbarfontsize);
        else
            cb=colorbar;set(cb,'fontweight','bold','fontsize',colorbarfontsize,'Position',colorbarposition);
        end
        if specifyxticks==1;set(cb,'xtick',colorbarxticks);end
    end
end

if strcmp(region,'us-ne') || strcmp(region,'us-ne-small') || strcmp(region,'us-sw-small') || strcmp(region,'us-mw') ||...
        strcmp(region,'us-se') || strcmp(region,'us-gulf-coast') || strcmp(region,'labasin')
    zoom(2.5);ylim([0.6 1.0]);
end

   

%Add text labels in various places
if overlaynow==1
    exist underlayvartype;
    if ans==1
        if strcmp(underlayvartype,'height')
            underlaydatanum=3;phr=sprintf('Shading: %s',varlistnames{underlaydatanum});
        elseif strcmp(underlayvartype,'temperature')
            underlaydatanum=1;phr=sprintf('Shading: %s in deg C',varlistnames{underlaydatanum});
        elseif strcmp(underlayvartype,'wet-bulb temp')
            underlaydatanum=2;phr=sprintf('Shading: %s in deg C',varlistnames{underlaydatanum});
        elseif strcmp(underlayvartype,'specific humidity')
            underlaydatanum=5;phr=sprintf('Shading: %s in g/kg',varlistnames{underlaydatanum});
        elseif strcmp(underlayvartype,'wv flux convergence')
            underlaydatanum=6;phr=sprintf('Shading: %s in kg/m^-2',varlistnames{underlaydatanum});
        else
            phr='';
        end
    else
        if strcmp(vartype,'height')
            datanum=3;phr=sprintf('Shading: %s',varlistnames{datanum});
        elseif strcmp(vartype,'temperature')
            datanum=1;phr=sprintf('Shading: %s in deg C',varlistnames{datanum});
        elseif strcmp(vartype,'wet-bulb temp')
            datanum=2;phr=sprintf('Shading: %s in deg C',varlistnames{datanum});
        elseif strcmp(vartype,'specific humidity')
            datanum=5;phr=sprintf('Shading: %s in g/kg',varlistnames{datanum});
        elseif strcmp(vartype,'wv flux convergence')
            datanum=6;phr=sprintf('Shading: %s in kg/m^-2',varlistnames{datanum});
        else
            phr='';
        end
        shadingdescr=phr;
    end
    
    
    exist overlayvartype;
    if ans==1
        if strcmp(overlayvartype,'height')
            overlaydatanum=3;phrcont=sprintf('Contours: %s in m',varlistnames{overlaydatanum});
        elseif strcmp(overlayvartype,'temperature')
            overlaydatanum=1;phrcont=sprintf('Contours: %s in deg C',varlistnames{overlaydatanum});
        elseif strcmp(overlayvartype,'wind')
            overlaydatanum=4;phrcont=sprintf('Contours: %s in m/s',varlistnames{overlaydatanum});
        elseif strcmp(overlayvartype,'wet-bulb temp')
            overlaydatanum=2;phrcont=sprintf('Contours: %s in deg C',varlistnames{overlaydatanum});
        elseif strcmp(overlayvartype,'wv flux convergence')
            overlaydatanum=5;phrcont=sprintf('Contours: %s in kg/m^-2',varlistnames{overlaydatanum});
        else
            phrcont='';
        end
        contoursdescr=phrcont;
    end
end

%Phrases to display in the caption
if contour_overlay || contour_underlay
    exist underlayvartype;
    if ans==1
        if strcmp(underlayvartype,'height')
            phr=sprintf('(interval: %0.0f %s)',mystepunderlay,dispunits);
        else
            exist unevencolordemarcations;
            if ans==0;phr=sprintf(' (interval: %0.1f %s)',mystepunderlay,dispunits);end
        end
    else
        if strcmp(vartype,'height')
            phr=sprintf('(interval: %0.0f %s)',mystep,dispunits);
        else
            phr=sprintf(' (interval: %0.1f %s)',mystep,dispunits);
        end
    end
    intervaldescr=phr;
    
    fullshadingdescr=strcat([shadingdescr,' ',intervaldescr]);
    shadingphr=fullshadingdescr;
    
    exist overlayvartype;
    if ans==1
        if size(overlaydata,1)==3 %i.e. if it's a scalar, contoured thing
            fullcontoursdescr=strcat([contoursdescr,' ',intervaldescr]);
            contoursphr=fullcontoursdescr;
        end
    end
    
    %Manual contour labeling
    %if overlaynow==1
    %    disp('line 731');uicontrol('Style','text','String',phrcont,'Units','normalized',...
    %            'Position',[0.4 0.07 0.2 0.05],'BackgroundColor','w','FontName','Arial','FontSize',18);
    %end
end


%Finally, if plotting wind vectors, use quivermc to do so
exist vectorData;
if ans==1
    if length(vectorData)~=0
        [~,~,normrefveclength]=quivermc(vectorData{1}(1:q:end,1:q:end),vectorData{2}(1:q:end,1:q:end),...
            vectorData{3}(1:q:end,1:q:end),vectorData{4}(1:q:end,1:q:end),'dontaddtext',...
            'reference',refval,'maparea',maparea,'mapregion',region,'skipstep',extraskipstepfactor,...
            'refvectorshrinkfactor',refvectorshrinkfactor);
    else
        normrefveclength=0;
    end
else
    normrefveclength=0;
end

exist refval;if ans==0;refval=0;end
exist windbarbsdescr;if ans==0;windbarbsdescr='';end
exist normrefveclength;if ans==0;normrefveclength=0;end
exist fullshadingdescr;if ans==0;fullshadingdescr='';end
exist fullcontoursdescr;if ans==0;fullcontoursdescr='';end
clear centeredon;

set(gca,'Position',[0.1 0.1 0.8 0.8]);
tightmap;

if contourlabels==1
    axHidden = axesm(mapproj,'MapLatLimit',[southlat northlat],'MapLonLimit',[westlon eastlon]);
    exist manualcontourlabels;
    if ans==1
        t=clabelm(C,h,'manual');
    else
        exist omitzerocontour;
        if ans==1
            t=clabelm(C,h,2:size(v,2));
        else
            t=clabelm(C,h,[2,2.5,3]);
        end
    end
    set(t,'FontSize',cblabelfontsize,'FontWeight','bold');
    set(t,'Parent',axHidden);
end

exist manualcontourlabels;
if ans==0;tightmap;end


