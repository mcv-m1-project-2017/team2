function [ mass_center ] = centerOfMass_Int( int_mask )
%UNTITLED3 Summary of this function goes here
%   Detailed explanation goes here

% doest change the meaning of the integral image
mass_center = [0,0];
int_mask = int_mask- int_mask(1,1);

% the mass center will be exactly were there are 4 qurters with 1/4 the
% pixels

% for The Vertical mass center we can only look at the Buttom row

midval = int_mask(end,end)/2;

mass_center(2) = find(int_mask(end,:)>=midval,1,'first');
mass_center(2) = mass_center(2)+ (midval-int_mask(end,mass_center(2)))/midval;
% for The Horizontal mass center we can only look at the Buttom row


mass_center(1) = find(int_mask(:,end)>=midval,1,'first');
mass_center(1) = mass_center(1)+ (midval-int_mask(mass_center(1),end))/midval;
end

