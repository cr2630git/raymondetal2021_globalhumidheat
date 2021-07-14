function pressure = pressurefromelev_dynamicTandP(elev,Tbase,Pbase)
%Calculates pressure (hPa) at a certain elevation (m), given a base temperature (K) and base pressure (mb)
%   In other respects, uses the US standard atmosphere, verified with http://www.emd.dk/files/windpro/WindPRO_AirDensity.pdf

%Necessary constants
L=-6.5;         %lapse rate -- K/km
G=-9.81;        %gravity -- m/s^2
M=28.96;        %density of air -- kg/mol
R=8.314;        %universal gas constant -- J/(kg*mol)

pressure=Pbase.*((Tbase+L.*10.^-3.*elev)./Tbase).^((G.*M)./(R.*L));

end

