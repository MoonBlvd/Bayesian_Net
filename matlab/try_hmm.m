clear all; clc;
% Rb = csvread('/home/brianyao/Documents/Smart_Black_Box/anomaly_score/discrepancy_score_euc_0.2_25_scalebeforesum.csv');
Yb = csvread('/home/brianyao/Documents/Smart_Black_Box/Brightness_features.csv');
Yb = Yb';
Yb(3,:) = Yb(3,:)*255;
Xb = csvread('/home/brianyao/Documents/Smart_Black_Box/anomaly_score/ground_truth/brightness.csv');
Xb = Xb(1:27655)';
Xb(Xb~=0)=2;
Xb(Xb==0)=1;
% Rb=Rb'/max(Rb);
% Rb = round(Rb*9)+1;
min(Yb,[],2)
max(Yb,[],2)
Yb = round(Yb); % discretize
Yb = Yb+1;

new_Yb = cell(1,size(Yb,2));
for i =1:size(Yb,2)
    new_Yb{i} = num2str(Yb(:,i)');
end

% HMM
% [TRANS, EMIS]=hmmestimate(Rb,Xb);
% [ESTTR, ESTEMIT] = hmmtrain(Rb,TRANS, EMIS);
% STATES = hmmviterbi(Rb, ESTTR, ESREMIT);
[TRANS, EMIS]=hmmestimate(new_Yb,Xb,'Symbols', unique(new_Yb));
[ESTTR, ESREMIT] = hmmtrain(new_Yb,TRANS, EMIS,'Symbols', unique(new_Yb));
STATES = hmmviterbi(new_Yb, ESTTR, ESREMIT,'Symbols', unique(new_Yb));
