function qarray = calcqfromTd_dynamicP(Tdarray,Psfcarray)
%Calculates q (specific humidity) from Td, using the formula of Bolton 1980
    %(listed at https://www.eol.ucar.edu/projects/ceop/dm/documents/refdata_report/eqns.html)
%Td is in C, Psfc is in Pa, q is in g/kg
%Uses actual surface pressure, as opposed to assuming it

%Table for validation: http://www.engineeringtoolbox.com/moist-air-properties-d_1256.html

%REVISED: uses vapor-pressure formulae from Huang 2018, doi:10.1175/jamc-d-17-0334.1, which is much more accurate for T<0 C


%Compute vapor pressure and then specific humidity
%vp=6.112.*exp((17.67.*Tdarray)./(Tdarray+243.5));
vp=calcvpfromTd(Tdarray);
qarray=1000.*(0.622.*(vp./100))./((Psfcarray./100)-(0.378.*(vp./100)));



end

