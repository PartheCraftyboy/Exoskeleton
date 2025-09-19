T = 100;                        % gait cycle period (%)
N = 200;                        % number of points
t = linspace(0, T, N);          % time vector (% gait cycle)

knee_angle = 30 + 30*sin(2*pi*t/T) + 10*sin(4*pi*t/T);
knee_torque = 10 + 15*sin(2*pi*(t-10)/T) + 5*sin(6*pi*t/T);

L1 = 0.5; % thigh length (m)
L2 = 0.5; % shank length (m)

figure;
for i = 1:N
    clf;
    % Hip is fixed at origin
    hip = [0 0];
    % Knee joint position
    theta_hip = pi/6; % fixed hip angle
    knee = hip + L1*[cos(theta_hip), sin(theta_hip)];
    % Animate knee angle (convert from degrees)
    theta_knee = theta_hip - deg2rad(knee_angle(i));
    ankle = knee + L2*[cos(theta_knee), sin(theta_knee)];
    
    % Plot the leg
    plot([hip(1) knee(1)], [hip(2) knee(2)], 'b-', 'LineWidth', 3); hold on;
    plot([knee(1) ankle(1)], [knee(2) ankle(2)], 'r-', 'LineWidth', 3);
    plot(hip(1), hip(2), 'ko', 'MarkerSize', 8, 'MarkerFaceColor','k');
    plot(knee(1), knee(2), 'go', 'MarkerSize', 8, 'MarkerFaceColor','g');
    plot(ankle(1), ankle(2), 'mo', 'MarkerSize', 8, 'MarkerFaceColor','m');
    axis equal;
    axis([-0.2 1 -0.2 1]);
    title(sprintf('Gait Cycle: %.1f%%', t(i)));
    xlabel('X (m)'); ylabel('Y (m)');
    grid on;
    pause(0.01);
end

figure;
subplot(2,1,1);
plot(t, knee_angle, 'b', 'LineWidth', 2);
xlabel('Gait Cycle (%)');
ylabel('Knee Angle (deg)');
title('Knee Angle Across Gait Cycle');
grid on;

subplot(2,1,2);
plot(t, knee_torque, 'r', 'LineWidth', 2);
xlabel('Gait Cycle (%)');
ylabel('Knee Torque (Nm)');
title('Knee Torque Across Gait Cycle');
grid on;