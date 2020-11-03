%#! /bin/octave -qf
# Plot the COGv data from the files

% Extract the path to files from arguments
path = "cogv/";
if (length(argv()) != 0)
  path = argv(){1};
endif

% Load all the data from files
initialData = -1;
if (exist(strcat(path,"test_data.txt")))
  initialData = load(strcat(path,"test_data.txt"));
endif
processedData = load(strcat(path,"dropped_data.txt"));
rotatedData = load(strcat(path,"rotated_data.txt"));
filteredData = load(strcat(path,"filtered_data.txt"));
downsampledData = load(strcat(path,"downsampled_data.txt"));
detrendedData = load(strcat(path,"detrended_data.txt"));

% Plot initial data
if (initialData != -1)
  figure("name","Original Accelerometer Data","numbertitle","off");
  hold on;
  plot(initialData(:,1,1));
  plot(initialData(:,2,1));
  plot(initialData(:,3,1));
  hold off;
  print -dpng "initial.png"
endif

% Plot all the steps
figure("name","Processing Steps","numbertitle","off");
subplot(2,2,1);
hold on;
plot(rotatedData(:,1,1));
plot(rotatedData(:,2,1));
hold off;
title("Axis Rotation");
subplot(2,2,2);
hold on;
plot(filteredData(:,1,1));
plot(filteredData(:,2,1));
hold off;
title("Filter");
subplot(2,2,3);
hold on;
plot(downsampledData(:,1,1));
plot(downsampledData(:,2,1));
hold off;
title("Downsample");
subplot(2,2,4);
hold on;
plot(detrendedData(:,1,1));
plot(detrendedData(:,2,1));
hold off;
title("Detrend");
print -dpng "processing.png"

% Plot computed data
figure("name","Processed COGv data","numbertitle","off");
subplot(2,1,1);
plot(processedData(:,1,1), processedData(:,2,1));
title("Ball of COGv data");
subplot(2,1,2);
hold on;
plot(processedData(:,1,1));
plot(processedData(:,2,1));
hold off;
title("COGvAP & COGvML");
print -dpng "processed.png"
