figure(303);
hold on;

plot(ZTCFQ.Time,ZTCFQ.LSonArmLinearPower);
plot(ZTCFQ.Time,ZTCFQ.RSonArmLinearPower);
plot(ZTCFQ.Time,ZTCFQ.LEonForearmLinearPower);
plot(ZTCFQ.Time,ZTCFQ.REonForearmLinearPower);
plot(ZTCFQ.Time,ZTCFQ.LHonClubLinearPower);
plot(ZTCFQ.Time,ZTCFQ.RHonClubLinearPower);

ylabel('Power (W)');
grid 'on';

%Add Legend to Plot
legend('LS Linear Power','RS Linear Power','LE Linear Power','RE Linear Power','LH Linear Power','RH Linear Power');
legend('Location','southeast');

%Add a Title
title('Linear Power on Distal Segment');
subtitle('ZTCF');

%Save Figure
savefig('ZTCF Charts/ZTCF_Plot - Linear Power');
pause(PauseTime);

%Close Figure
close(303);