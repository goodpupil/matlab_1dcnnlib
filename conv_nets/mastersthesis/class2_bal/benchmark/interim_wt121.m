function [interim, output, param, update, filt] = interim_wt121(init,p)
%% Net parameters
param = struct; %CNN parameters

param.num_iter = p;  % number of iterations

param.numfilt_phase1 = 6; % number of 1st and 2nd phase filters
param.numfilt_phase2 = 12; % number of 1st and 2nd phase filters

param.convfiltwt1 = 1; param.convfiltwt2 = 1; %weight of weights
param.fullconnwt1 = 1;param.fullconnwt2 = 1; %weight of weights
rate = 0.01;
param.fc1rate = rate; param.fc2rate = rate; %learning rates
param.fconv1rate = rate; param.fconv2rate = rate; %learning rates 

param.fcL1_interim = 400; %interim number of units in fully connected layer

%% initialize intermediate forward variables
interim = struct; % CNN interim Parameters
output = struct; % CNN output parameters

output.calculated_op = zeros(init.trainsize,1); %output calculated at the end

filt.convfilt_L1 = 2*rand(param.numfilt_phase1,init.filtsize)-1; %filters for conv layer 1
filt.convfilt_L2 = 2*rand(param.numfilt_phase2,init.filtsize)-1; %filters for conv layer 2

filt.convfilt_L1 = param.convfiltwt1*filt.convfilt_L1; %making the filters from -1 to 1
filt.convfilt_L2 = param.convfiltwt2*filt.convfilt_L2; %making the filters from -1 to 1


interim.numPoints_conv1 = init.numPoints - (init.filtsize -1);   % number of points in 1st convolution
interim.numPoints_conv2 = (interim.numPoints_conv1/2) - (init.filtsize -1); % number of points in 2nd convolution


interim.fmap_L1 = zeros(init.trainsize*param.numfilt_phase1,interim.numPoints_conv1);
%1st phase feature map
%bias_L1 = 0;
interim.fmap_L2 = zeros(init.trainsize*param.numfilt_phase1*param.numfilt_phase2,interim.numPoints_conv2);
%2nd phase feature map
%bias_L2 = 0;

interim.poolmap_L1 = zeros(init.trainsize*param.numfilt_phase1,interim.numPoints_conv1/2);
%1st phase pool map
interim.poolmap_L2 = zeros(init.trainsize*param.numfilt_phase1*param.numfilt_phase2,interim.numPoints_conv2/2);
%1st phase pool map

interim.fcL1 = zeros(init.trainsize,((param.numfilt_phase1*param.numfilt_phase2*interim.numPoints_conv2/2)));
filt.fcL1W = rand(((param.numfilt_phase1*param.numfilt_phase2*interim.numPoints_conv2/2)),param.fcL1_interim);

interim.fcL2 = zeros(init.trainsize,param.fcL1_interim);
filt.fcL2W = rand(param.fcL1_interim,1);

filt.fcL1W = param.fullconnwt1*(2*(filt.fcL1W)-1); %making the filters from -1 to 1
filt.fcL2W = param.fullconnwt2*(2*(filt.fcL2W)-1); %making the filters from -1 to 1


output.error = zeros(init.trainsize,1);

output.E = zeros(param.num_iter,1);
%% initialize update variables
update = struct; 
update.delta_fcl2 = output.error; 

end