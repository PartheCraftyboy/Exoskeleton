% Parameters
a = 0.15;    % Proximal links (m)
b = 0.25;    % Distal links (m)
d = 0.30;    % Base separation (m)

% Time vector and joint angles
t = linspace(0, 3, 500);
theta2 = 2 * pi/3 * sin(t + pi/9);
theta1 = 2 * pi/3 * sin(t + pi/9);

% Modified forward kinematics function with 6 outputs
function [x_ee, y_ee, x1, y1, x2, y2] = forward_kinematics_5R(theta1, theta2, a, b, d)
    % Position of passive joints
    x1 = a * cos(theta1);
    y1 = a * sin(theta1);
    x2 = d + a * cos(theta2);
    y2 = a * sin(theta2);
    
    % Distance between passive joints
    d12 = sqrt((x2 - x1)^2 + (y2 - y1)^2);
    
    % Midpoint
    x_mid = (x1 + x2)/2;
    y_mid = (y1 + y2)/2;
    
    % Vector between joints
    dx = x2 - x1;
    dy = y2 - y1;
    
    % Perpendicular direction
    perp_x = -dy;
    perp_y = dx;
    perp_len = sqrt(perp_x^2 + perp_y^2);
    
    % Avoid division by zero
    if perp_len > eps
        perp_x = perp_x / perp_len;
        perp_y = perp_y / perp_len;
    else
        perp_x = 0;
        perp_y = 0;
    end
    
    % Height calculation
    h = sqrt(b^2 - (d12/2)^2);
    
    % End-effector position
    x_ee = x_mid + h * perp_x;
    y_ee = y_mid + h * perp_y;
end

% Pre-calculate positions
x_ee_trace = zeros(1, length(t));
y_ee_trace = zeros(1, length(t));
for i = 1:length(t)
    [x_ee_trace(i), y_ee_trace(i)] = forward_kinematics_5R(theta1(i), theta2(i), a, b, d);
end

% Initialize figure
fig = figure('Color', 'white', 'Position', [100, 100, 800, 600]);
ax = gca;
hold(ax, 'on');
axis(ax, 'equal');
grid(ax, 'on');
xlim(ax, [-0.5, 0.8]);  % Adjusted limits
ylim(ax, [-0.5, 0.5]);
xlabel(ax, 'X (m)');
ylabel(ax, 'Y (m)');
title(ax, '2-DOF 5R Parallel Robot Animation');

% Plot base joints
plot(ax, 0, 0, 'ro', 'MarkerSize', 10, 'MarkerFaceColor', 'r');
plot(ax, d, 0, 'ro', 'MarkerSize', 10, 'MarkerFaceColor', 'r');
text(0, 0, 'Base Joint 1', 'VerticalAlignment', 'top');
text(d, 0, 'Base Joint 2', 'VerticalAlignment', 'top');

% Initialize plot objects
link1_plot = plot(ax, [0,0], [0,0], 'r-o', 'LineWidth', 2, 'MarkerSize', 5, 'MarkerFaceColor', 'r');
link2_plot = plot(ax, [0,0], [0,0], 'r-o', 'LineWidth', 2, 'MarkerSize', 5, 'MarkerFaceColor', 'r');
link3_plot = plot(ax, [0,0], [0,0], 'b-o', 'LineWidth', 2, 'MarkerSize', 5, 'MarkerFaceColor', 'b');
link4_plot = plot(ax, [0,0], [0,0], 'b-o', 'LineWidth', 2, 'MarkerSize', 5, 'MarkerFaceColor', 'b');
ee_marker = plot(ax, 0, 0, 'ms', 'MarkerSize', 8, 'MarkerFaceColor', 'm');
trace_plot = plot(ax, [], [], 'g-', 'LineWidth', 1.5);  % Green trace

% Animation parameters
fps = 30;
delay = 1/fps;

% Animation loop
for i = 1:length(t)
    % Get all positions (now using 6 outputs)
    [x_ee, y_ee, x1, y1, x2, y2] = forward_kinematics_5R(theta1(i), theta2(i), a, b, d);
    
    % Update proximal links
    set(link1_plot, 'XData', [0, x1], 'YData', [0, y1]);
    set(link2_plot, 'XData', [d, x2], 'YData', [0, y2]);
    
    % Update distal links
    set(link3_plot, 'XData', [x1, x_ee], 'YData', [y1, y_ee]);
    set(link4_plot, 'XData', [x2, x_ee], 'YData', [y2, y_ee]);
    
    % Update end-effector
    set(ee_marker, 'XData', x_ee, 'YData', y_ee);
    
    % Update green trace
    set(trace_plot, 'XData', x_ee_trace(1:i), 'YData', y_ee_trace(1:i));
    
    % Maintain frame rate
    pause(delay);
    drawnow;
end
