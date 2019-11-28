function [markovArray, cumMarkovArray, datMin, datMax] = markovChainFunction(data, bins)

%{
This function takes in an arbitrary data signal and converts it into a
Markov Chain model characterized by the specified number of bins.
%}


% Normalize data:
datMin = min(data);
datMax = max(data);
datNorm = (data - datMin)./(datMax - datMin);

% Create Markov Transition Table:
mesh = linspace(0, 1, bins);
meshReal = (mesh.*(datMax - datMin) + datMin);
dmesh = mesh(2) - mesh(1);
dmeshReal = meshReal(2) - meshReal(1);

markovArray = zeros(length(mesh), length(mesh));
cumMarkovArray = zeros(length(mesh), length(mesh));

% Populate Markov Transition Table:
for i = 2:(length(data)-1)
    datNow = datNorm(i);
    datBefore = datNorm(i-1);

    dn = round(datNow ./ dmesh) + 1; % Get index
    db = round(datBefore ./ dmesh) + 1; % Get index
    
    markovArray(db, dn) = markovArray(db, dn) + 1;  % Update MTT
    
end

% Transform data in transition table to probability:
for j = 1:bins
    markovArray(j,:) = markovArray(j,:)./ sum(markovArray(j,:));      
    cumMarkovArray(j,:) = cumsum(markovArray(j,:));
end

% Eliminate potential NaNs from potential /0:
ind = isnan(markovArray);
markovArray(ind) = 0;
cumMarkovArray(ind) = 0;

end
