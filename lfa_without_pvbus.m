% MATLAB Code for Gauss-Seidel Load Flow Analysis (Only PQ Buses)

clear;
clc;

% Parameters
tol = 1e-5;  % Tolerance for convergence
maxIter = 100;  % Maximum number of iterations

% System Data
% Bus data: [Bus Number | Type (1:Slack, 2:PQ) | P | Q | V | Angle (in degrees)]
% For PQ buses, V and Angle are initial guesses
busData = [
    1   1   0       0       1.05    0;      % Slack Bus
    2   2   0.2     0.1     1.00    0;      % PQ Bus
    3   2   -1.2    -0.6    1.00    0;      % PQ Bus
];

% Y-bus matrix (Admittance Matrix)
Ybus = [
    -i*9    i*5     i*4;
    i*5     -i*7.5  i*2.5;
    i*4     i*2.5  -i*6.5;
];

% Extract bus information
nBus = size(busData, 1);
busType = busData(:, 2);
P = busData(:, 3);  % Active power in p.u.
Q = busData(:, 4);  % Reactive power in p.u.
V = busData(:, 5);  % Voltage magnitude in p.u.
delta = busData(:, 6);  % Voltage angle in degrees

% Slack bus index
slackBus = find(busType == 1);

% Start Gauss-Seidel Iterations
for iter = 1:maxIter
    V_prev = V;  % Store previous iteration voltages
    Angle_prev = delta; % Store previous iteration angles
    
    % Loop through each PQ bus
    for i = 1:nBus
        if busType(i) == 2  % Skip slack bus
            sumYV = 0;
            for j = 1:nBus
                if i ~= j
                    sumYV = sumYV + Ybus(i,j) * V_prev(j) * exp(1j * deg2rad(Angle_prev(j)));
                end
            end
            
            % Calculate the new voltage for bus i
            variable = (1 / Ybus(i,i)) * (((P(i) - 1j * Q(i)) / conj(V_prev(i))) - sumYV);
            % Update magnitude and angle
            delta(i) = rad2deg(angle(variable));  % Update angle
            V(i) = abs(variable);
        end
    end
    
    % Display Results
    disp('Bus Voltages:');
    for i = 1:nBus
        fprintf('Bus %d: |V| = %.4f, Angle = %.4f degrees\n', i, V(i), delta(i));
    end

    % Check for convergence
    count=0;
    for i=1:nBus
        if abs(V(i) - V_prev(i)) > tol
            count = 1;
            break;
        end
    end

    if count == 0
        fprintf('Converged in %d iterations.\n', iter);
        break;
    end
    
end

% Display Results
disp('Bus Voltages:');
for i = 1:nBus
    fprintf('Bus %d: |V| = %.4f, Angle = %.4f degrees\n', i, V(i), delta(i));
end

if iter == maxIter
    disp('Did not converge within the maximum number of iterations.');
end
