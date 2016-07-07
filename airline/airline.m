% read in the airline series
fileID = fopen('international-airline-passengers.csv', 'r');
A = textscan(fileID, '"%d-%d";%d', 'headerLines', 1);
fclose(fileID);

years = A{1};
months = A{2};
passengers = A{3} * 1000;

clear fileID A;

figure;
plot(passengers);
xlabel('month');
ylabel('passengers');
