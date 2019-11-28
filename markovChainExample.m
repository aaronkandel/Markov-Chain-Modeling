% Make Markov Chain From Data:
% Aaron Kandel
% 11/27/2019


%{
In this script, I show an example of how to use my Markov Chain model
function.  Specifically, I model the power demanded when a vehicle drives
the Urban Dynomometer Driving Schedule (UDDS) as a Markov Chain.  The UDDS
is a classic benchmark for vehicle testing which intends to represent 
typical driving conditions.  Therefore, I can use its trajectory to build a
Markov Chain model which allows me to simulate "typical" driving
conditions.
%}


clear 
clc
close all

%% Load Data and Create Markov Chain Model:

M = csvread('UDDS_Pdem.csv',1,0);

t = M(:,1); % [s] Time
P_dem = M(:,2)*1e3;  % convert from kW to W

data = P_dem;
bins = 50;

[markovArray, cumMarkovArray, datMin, datMax] = markovChainFunction(data, bins);


%% Simulate Markov Chain Model:

datSim = zeros(size(data));
datSim(1) = 1; % Set same initial condition:

for i = 1:length(data)
    
    % Find current row on MTT:
    curState = datSim(i);
    
    % Create random transition:
    r = rand();  
    check = find(cumMarkovArray(curState, :) > r);
    
    % Transition to next state:
    nextState = check(1);
    datSim(i+1) = nextState;
 
end


% Un-Normalize Simulated Data:
datSim = datSim./max(datSim);
datSim = (datSim.*(datMax - datMin) + datMin);


% Compare Signals:
figure
subplot(121)
hold on
plot(t./60, data)
grid on
xlabel('Time [min]')
ylabel('Power Demanded [W]')
title('UDDS Drive Cycle')
subplot(122)
plot(t./60, datSim(1:end-1))
grid on
xlabel('Time [min]')
ylabel('Power Demanded [W]')
title('Simulated Markov Chain Driving Cycle')
