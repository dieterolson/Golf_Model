%Generate Club Quiver Plot
figure(121);
run SCRIPT_QuiverClubandShaftBaseData.m;

%Generate RH Total Force Quiver Plot
RHForceQuiver=quiver3(BASEQ.RHx(:,1),BASEQ.RHy(:,1),BASEQ.RHz(:,1),BASEQ.ClubonRHFGlobal(:,1),BASEQ.ClubonRHFGlobal(:,2),BASEQ.ClubonRHFGlobal(:,3));
RHForceQuiver.LineWidth=1;
RHForceQuiver.Color=[0 0 1];
RHForceQuiver.AutoScaleFactor=2;
RHForceQuiver.MaxHeadSize=0.1;

%Generate RE Total Force Quiver Plot
REForceQuiver=quiver3(BASEQ.REx(:,1),BASEQ.REy(:,1),BASEQ.REz(:,1),BASEQ.RArmonRForearmFGlobal(:,1),BASEQ.RArmonRForearmFGlobal(:,2),BASEQ.RArmonRForearmFGlobal(:,3));
REForceQuiver.LineWidth=1;
REForceQuiver.Color=[1 0 0];
REForceQuiver.MaxHeadSize=0.1;
REForceQuiver.AutoScaleFactor=RHForceQuiver.ScaleFactor/REForceQuiver.ScaleFactor;

%Generate Right Elbow MOF on Right Forearm
REMOFLForearmQuiver=quiver3(BASEQ.REx(:,1),BASEQ.REy(:,1),BASEQ.REz(:,1),BASEQ.RElbowonRForearmMOFGlobal(:,1),BASEQ.RElbowonRForearmMOFGlobal(:,2),BASEQ.RElbowonRForearmMOFGlobal(:,3));
REMOFLForearmQuiver.LineWidth=1;
REMOFLForearmQuiver.Color=[0 0.75 0];
REMOFLForearmQuiver.MaxHeadSize=0.1;
REMOFLForearmQuiver.AutoScaleFactor=2;

%Generate Right Wrist MOF on Right Forearm
RHristMOFLForearm=quiver3(BASEQ.RHx(:,1),BASEQ.RHy(:,1),BASEQ.RHz(:,1),BASEQ.RHonRForearmMOFGlobal(:,1),BASEQ.RHonRForearmMOFGlobal(:,2),BASEQ.RHonRForearmMOFGlobal(:,3));
RWristMOFLForearm.LineWidth=1;
RWristMOFLForearm.Color=[0 0.5 0];
RWristMOFLForearm.MaxHeadSize=0.1;
RWristMOFLForearm.AutoScaleFactor=REMOFLForearmQuiver.ScaleFactor/RWristMOFLForearm.ScaleFactor;

%Generate Right Forearm Quivers
RightForearm=quiver3(BASEQ.REx(:,1),BASEQ.REy(:,1),BASEQ.REz(:,1),BASEQ.RightForearmdx(:,1),BASEQ.RightForearmdy(:,1),BASEQ.RightForearmdz(:,1),0);
RightForearm.ShowArrowHead='off';
RightForearm.LineWidth=1;			   
RightForearm.Color=[0 0 0];	

%Add Legend to Plot
legend('','','','','RH Force','RE Force','RE MOF','RH MOF');

%Add a Title
title('Moments of Force Acting on Right Forearm');
subtitle('BASE');

%Set View
view(-0.186585735654603,37.199999973925109);

%Save Figure
savefig('BaseData Quiver Plots/BASE_Quiver Plot - Right Forearm Moments');
pause(PauseTime);

%Close Figure
close(121);

%Clear Figure from Workspace
clear RHForceQuiver;
clear REForceQuiver;
clear REMOFLForearmQuiver;
clear RWristMOFLForearm;
clear RightForearm;
clear Grip;
clear Shaft;
clear ClubPath;
clear HandPath;