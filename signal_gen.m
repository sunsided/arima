f_base    = 2.5;
a_base    = 4;
f_overlay = 16;
a_overlay = 0.5;

t = linspace(0,2,1000);
x = 1:numel(t);
y = a_base*sin(2*pi*f_base*t) + a_overlay*sin(2*pi*f_overlay*t);