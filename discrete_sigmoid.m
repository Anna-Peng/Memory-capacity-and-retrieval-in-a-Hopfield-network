function [node, p]=discrete_sigmoid(netinput, temperature)
%UNTITLED Summary of this function goes here
%   Detailed explanation goes here

E=exp(-2*netinput/temperature);
p=(E-1)/(E+1);
j=random('uniform', -1, 1);

if j> p
    node=1;
else
    node=-1;
end
end

