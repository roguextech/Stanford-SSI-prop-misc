clc, clear, close all

% This function intakes various performance characteristics and finds the
% pressure change created by a pyrotecnic gas generation device. 
% Thomas White 2/16/2020

% Assumptions: assumes a static pressure vessel (e.g. for a rocket, assumes
% no gas exits the nozzle. 

%% Starting Settings 

% Pyrogen Details
lambda = 298968; % Nm/kg (Specific force constant)
% m = 0.003; % kg (initial charge mass)
m = linspace(0.0005, 0.004);
V = 0.0000; % m^3 (charge volume at time T)
V_0 = 0.000000215; % m^3 (charge volume at start)
Z =  1 - V/V_0; % (burned mass fraction)
roh = 12524; %kg/m^3 (density of charge)
eta = 0.00108; % (propellant co-volume)

% Chamber Details
gamma = 1.4; % Specific heat ratio of combusted gasses)
V_c = 32.7e-6; % m^3 (chamber volume at t=0) 

%% The equation

Pc = (lambda.*m.*Z)./(V_c - m.*((1./roh) - Z.*(eta - (1./roh))));

Pc_psi = Pc./6894.75729;

plot(m./1000, Pc_psi)
xlabel("BP charge (g)")
ylabel("Initial Pressure (psi)")


%% TODO - Istentropic Blowdown of the Pressure


%% Dumb Bolt Transient Calc
Pc = 3000; % psi
m_bolt = 0.03; %kg
p_flow = 650*6894.75729; %in Pa
A = 0.000000043; %m^3
F_pyro = (Pc - p_flow).*A;
x0 = 0.01; %m needs update


% syms x 
% 
% for i = 1:1:100 
%     
%     t = i/100   
%     res(i, i+1) = solve(x^2 + (Pc*(t^2)/(2*m_bolt))*x - (t^2)*A*p_flow/m_bolt, x)
% 
% end 

c1 = 0;
c2 = 0;
k = p_flow*A*x0/m_bolt;


tspan = [0 0.1];
y0 = [0.01, 0];
[t, y] = ode45(@myode, tspan, y0)


plot(t, y(:, 1))
title("Distance Traveled by Bolt Over Time")
xlabel("Time (s)")
ylabel("Distance Traveled by Bolt")


%% TODO - ODE Calc of Bolt Accel

function dydt = myode(t,y)
Pc = 3000; % psi
m_bolt = 0.03; %kg
p_flow = 650*6894.75729; %in Pa
A = 0.000000043; %m^3
F_pyro = (Pc - p_flow).*A;
x0 = 0.01; %m needs update
k = p_flow*A*x0/m_bolt;

dydt = [y(2); k/y(1)];

end 
