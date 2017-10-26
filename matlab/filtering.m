% transition model, given previous collision, what's the probability of
% anotehr collision?
P_T = [0.9,0.1;
       0.001,0.999];
% sensor model, given collision, what's the probability of observe
% collision?
P_O_T = [0.7, 0.3; % given collision, the prob of observation
         0.01, 0.99]; % given no collision, the prob of observation
     
% observation sequences, 0 - no collision, 1 - collision 
observations = [0,0,0,0,0,0,0,1,1,1,1,0,1,1,0,0,0,0,0,1,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,1,1,1,0,1,0,1,0,0,0,0,0,0,0,0];

%observations = csvread('../Advanced_car_anomaly_detection/Anomaly_Scores/online_version/final_result/traffic_score_27655.csv');
observations(observations > 0.5) = 1;
observations(observations < 0.5) = 0;

% initial f = f1 = P(x1|o1)
f = [0.9,0.1;
     0.1,0.9];
f = f(2-observations(1), :)';
prob = [f(1)];
smoothed_prob = [];
f_list = [f];
O = [P_O_T(1,2-observations(1)), 0;
     0, P_O_T(2,2-observations(1))];
O_list = [O];
% constant lag
d = 5;
for i = 2:length(observations)
    ['Iter: ',num2str(i)]
    % filtering, use simplified matrix algroithm
    O = [P_O_T(1,2-observations(i)), 0;
         0, P_O_T(2,2-observations(i))];
    O_list = cat(3,O_list,O);
    f = O*P_T'*f;
    f = f/sum(f);
    f_list = [f_list;f];
    prob = [prob, f(1)];
    % smoothing, use simplified matrix algorithm
    
    if i > d
        b = 1;
        for j = i-d+1:i
            b = b*P_T * O_list(:,:,j);
        end
        b = b*[1;0]; % times the b_{t+1:t}, which is 1.
        smoothed = f_list(i-d,:).*b;
        smoothed = smoothed/sum(smoothed);
        smoothed_prob = [smoothed_prob,smoothed(1)];
    end
end
index = 1:length(observations);
smoothed_index = 1:length(observations)-d;
plot(index, observations, 'g-');hold on;
plot(index, prob, 'r-');
plot(smoothed_index,smoothed_prob,'k-');

legend('Real observations','Only filtering','Filtering and smoothing')
