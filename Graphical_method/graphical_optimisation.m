clc; clear; close all;

%% User Inputs
disp('Enter the constraint matrix A (each row is an inequality, format: [a11 a12; a21 a22; ...]):');
A = input('A = ');

disp('Enter the RHS vector b (column vector, format: [b1; b2; ...]):');
b = input('b = ');

disp('Enter the objective function coefficients C (row vector, format: [c1 c2]):');
C = input('C = '); % Objective function to maximize C*x

%% Define x1 and x2 range dynamically
x1_min = 0;  % Since x1, x2 ≥ 0
x1_max = max(b ./ A(:, 1)); % Max limit based on constraints
x2_min = 0;
x2_max = max(b ./ A(:, 2)); % Max limit based on constraints

[x1, x2] = meshgrid(linspace(x1_min, x1_max, 500), linspace(x2_min, x2_max, 500));

%% Identify feasible region
feasible = ones(size(x1)); % Start with all points valid
for i = 1:size(A,1)
    feasible = feasible & (A(i,1)*x1 + A(i,2)*x2 <= b(i));
end

% Plot Feasible Region
hold on;
contourf(x1, x2, feasible, [1 1], 'FaceColor', 'cyan', 'EdgeColor', 'none', 'FaceAlpha', 0.5);
colormap winter;

% Plot Constraint Boundaries
colors = {'r', 'g', 'b', 'm', 'c', 'k'}; % Different colors for lines
for i = 1:size(A,1)
    x2_boundary = (b(i) - A(i,1)*x1) / A(i,2);
    x2_boundary(x2_boundary < 0) = NaN; % Ensure x2 ≥ 0
    plot(x1, x2_boundary, colors{mod(i, length(colors)) + 1}, 'LineWidth', 2, ...
        'DisplayName', sprintf('%d x_1 + %d x_2 ≤ %d', A(i,1), A(i,2), b(i)));
end

% Solve the LP using linprog
f = -C;  % Maximizing C*x is same as minimizing -C*x
lb = [0; 0];  % Constraints x1, x2 ≥ 0
% options = optimoptions('linprog','Display','off'); % Suppress output
[x_opt, max_value, exitflag] = linprog(f, A, b, [], [], lb, [], options);

if exitflag == 1
    % Plot Optimal Point
    scatter(x_opt(1), x_opt(2), 100, 'g', 'filled', 'DisplayName', 'Optimal Solution');
    fprintf('Optimal solution found at x1 = %.2f, x2 = %.2f with Max Value = %.2f\n', ...
        x_opt(1), x_opt(2), -max_value);
else
    fprintf('No feasible solution found.\n');
end

% Set plot limits and labels
xlim([x1_min x1_max]);
ylim([x2_min x2_max]);
xlabel('x_1');
ylabel('x_2');
title('Feasible Region and Optimal Solution');
legend('Location', 'northeast');
grid on;
axis equal;
hold off;

