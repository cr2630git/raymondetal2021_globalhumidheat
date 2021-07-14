%Calculate geopotential of a given model level, as a function of the
    %underlying topography, surface pressure, and T & q values
%See https://github.com/johanneshorak/geopotcalc/blob/master/gpcalc.py and
%https://horak.xyz/index.php/2019/02/07/calculating-the-geopotential-of-era5-model-levels/
%for details

%In most cases, model levels retrieved are:
%137 -- approx. 1012 mb -- approx. 10 m
%135 -- approx. 1007 mb -- approx. 54 m
%133 -- approx. 1000 mb -- approx. 107 m
%130 -- approx. 989 mb -- approx. 205 m
%127 -- approx. 974 mb -- approx. 334 m
%124 -- approx. 955 mb -- approx. 501 m
%118 -- approx. 900 mb -- approx. 987 m
%114 -- approx. 850 mb -- approx. 1460 m
%105 -- approx. 700 mb
%96 -- approx. 500 mb
%83 -- approx. 300 mb
%74 -- approx. 200 mb

Rd=287.06;
Rv=461;
ml_df=csvread(strcat(icloud,'General_Academics/Research/KeyFiles/era5modellevels.csv'));

psfctouse=psfc_here*100; %to convert to Pa
ghsfctouse=ghsfc_here; %in m


summ=0;clear tv;clear levpressurediff;madelpd=0;
tv=NaN.*ones(max(mls_retrieved)-k,size(t_here,2),size(t_here,3));
levpressurediff=NaN.*ones(max(mls_retrieved)-k,size(t_here,2),size(t_here,3));

%Get geopotential at the full level k
for j=k+1:max(mls_retrieved)
    a=ml_df(j-1,2);b=ml_df(j-1,3);
    p_higherup=a+b.*psfctouse;
    a=ml_df(j,2);b=ml_df(j,3);
    p_lowerdown=a+b.*psfctouse;
    
    %Linearly interpolate temperature at levels where I didn't retrieve it
    myres=checkifthingsareelementsofvector(mls_retrieved,j);
    if myres==1 %have exact data already
        tt=t_here(mls_retrieved==j);
        qq=q_here(mls_retrieved==j);
    else %need to interpolate
        foundalready=0;
        for ii=2:size(mls_retrieved,1)
            if mls_retrieved(ii-1)<j && mls_retrieved(ii)>=j
                disttolevabove=j-mls_retrieved(ii-1);
                disttolevbelow=mls_retrieved(ii)-j;
                savedii=ii;
                foundalready=1;
            end
        end
        if foundalready==0
            fprintf('54Help!!!! for k=%d\n',k);return;
        end
        
        weightprev=disttolevbelow/(disttolevabove+disttolevbelow);
        weightnext=disttolevabove/(disttolevabove+disttolevbelow);
        if size(t_here,1)==1 %1D
            tt=squeeze(weightprev.*t_here(savedii-1)+weightnext.*t_here(savedii));
            qq=squeeze(weightprev.*q_here(savedii-1)+weightnext.*q_here(savedii));
        else %3D
            tt=squeeze(weightprev.*t_here(savedii-1,:,:)+weightnext.*t_here(savedii,:,:));
            qq=squeeze(weightprev.*q_here(savedii-1,:,:)+weightnext.*q_here(savedii,:,:));
        end
    end
    
    tv(j-k,:,:)=tt.*(1+(Rv/Rd-1).*qq);
    levpressurediff(j-k,:,:)=p_lowerdown-p_higherup;
    madelpd=1;
        
    summ=summ+Rd.*squeeze(tv(j-k,:,:)).*log(p_lowerdown./p_higherup);
    %disp(summ);
end

summ=summ+ghsfctouse;%disp(summ);
gp_here=summ; %!to get geometric height, divide by 9.81!

%Use hypsometric equation to also get pressure associated with this geopotential height
if madelpd==1
    normlevweights=levpressurediff./sum(levpressurediff);
    invalid=tv==0;tv(invalid)=NaN;
    meantv=0;
    for j=k+1:max(mls_retrieved)
        meantv=meantv+tv(j-k).*normlevweights(j);
    end
elseif k==max(mls_retrieved)
    meantv=t_here(end)*(1+(Rv/Rd-1).*q_here(end));
end

p_here=psfctouse./exp(gp_here./(Rd.*meantv));


