T = 100;                 % gait cycle percent
N = 200;                 % points in gait cycle
t = linspace(0, T, N);

% Knee angle (degrees) - as before
knee_angle = 30 + 30*sin(2*pi*t/T) + 10*sin(4*pi*t/T);

% Hip angle (degrees) - empirical approx, phase-lead to knee
A0 = 10;                 % average hip angle offset (degrees)
A1 = 25;                 % first harmonic amplitude
A2 = 5;                  % second harmonic amplitude
phi1 = -pi/4;            % phase lead
phi2 = -pi/2;

hip_angle = A0 + A1*sin(2*pi*t/T + phi1) + A2*sin(4*pi*t/T + phi2);

% Link lengths
L1 = 0.5;    % thigh length (m)
L2 = 0.5;    % shank length (m)

figure;
for i=1:N
    clf;
    hip = [0 0];

    % Calculate knee position
    theta_hip = deg2rad(hip_angle(i));         % variable hip angle in radians
    knee = hip + L1 * [cos(theta_hip), sin(theta_hip)];

    % Calculate ankle position using dynamic knee angle
    theta_knee = theta_hip - deg2rad(knee_angle(i));
    ankle = knee + L2 * [cos(theta_knee), sin(theta_knee)];

    % Plot leg segments and joints
    plot([hip(1) knee(1)], [hip(2) knee(2)], 'b-', 'LineWidth', 3); hold on;
    plot([knee(1) ankle(1)], [knee(2) ankle(2)], 'r-', 'LineWidth', 3);

    plot(hip(1), hip(2), 'ko', 'MarkerSize',8,'MarkerFaceColor','k');
    plot(knee(1), knee(2), 'go', 'MarkerSize',8,'MarkerFaceColor','g');
    plot(ankle(1), ankle(2), 'mo', 'MarkerSize',8,'MarkerFaceColor','m');

    axis equal;
    axis([-0.2 1 -0.2 1]);
    title(sprintf('Gait Cycle: %.1f%%', t(i)));
    xlabel('X (m)'); ylabel('Y (m)');
    grid on;
    pause(0.01);
end

figure;
plot(t, knee_angle, 'b', 'LineWidth', 2);
xlabel('Gait Cycle (%)');
ylabel('Knee Angle (deg)');
title('Knee Angle Across Gait Cycle');
grid on;
