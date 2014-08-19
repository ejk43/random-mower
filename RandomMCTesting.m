
nruns = 5; % number of runs for EACH, small and large deck

%% Small Mower Test
smalldeck = 0.26;
small_time = zeros(nruns,1);
small_a = zeros(nruns,1);
small_b = zeros(nruns,1);
small_good = zeros(nruns,1);
for i=1:nruns
    time = 10000;
    while time >= 10000-1 % Sometime the mower might run away... repeat the simulation
        [small_time(i,1) mow_pct] = RandomMower(smalldeck);
        time = small_time(i,1);
    end
    mow_pct = 1-mow_pct;
    t = 0:5:(length(mow_pct)-1)*5;
    [curve goodness] = fit(t',mow_pct,'exp1');
    small_a(i,1) = curve.a;
    small_b(i,1) = curve.b;
    small_good(i,1) = goodness.rsquare;
    if mod(i,2)~=0
        disp(['Percent done: ' num2str(i/(nruns*2)*100) '%'])
    end
end

%% Large Mower Test
largedeck = 0.50; 
large_time = zeros(nruns,1);
large_a = zeros(nruns,1);
large_b = zeros(nruns,1);
large_good = zeros(nruns,1);
for i=1:nruns
    time = 10000;
    while time >= 10000-1 % Sometime the mower might run away... repeat the simulation
        [large_time(i,1) mow_pct] = RandomMower(largedeck);
        time = large_time(i,1);
    end
    mow_pct = 1-mow_pct;
    t = 0:5:(length(mow_pct)-1)*5;
    [curve goodness] = fit(t',mow_pct,'exp1');
    large_a(i,1) = curve.a;
    large_b(i,1) = curve.b; 
    large_good(i,1) = goodness.rsquare;
    if mod(i,2)==0
        disp(['Percent done: ' num2str((i+nruns)/(nruns*2)*100) '%'])
    end
end

%% Save stuff
runningtime_large = mean(large_time)
runningtime_small = mean(small_time)
num = 1;
while exist(['MCTesting_' num2str(num) '.mat'],'file') == 2
    num = num + 1;
end
save(['MCTesting_' num2str(num) '.mat'],'large_time','large_a','large_b','large_good','small_time','small_a','small_b','small_good')