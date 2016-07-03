a_base    = 1;
f_base    = 2;
a_overlay = 0.25;
f_overlay = 20;
t = linspace(0, 1, 1000)
y = a_base*sin(2*pi*f_base*t) + a_overlay*sin(2*pi*f_overlay*t);

var(y)
