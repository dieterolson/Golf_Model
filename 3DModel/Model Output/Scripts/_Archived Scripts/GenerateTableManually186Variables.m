%Generate a table with a time column and the variable name set to time.
Time=out.tout
Data = table(Time, 'VariableNames', {'Time'});
% %Loop through each dataset element to add it to the table
% for i=1:out.logsout.numElements
%     %Get signal name
%     signalName=out.logsout.getElement(i).Name;
%     %Get signal data
%     signalData=out.logsout.getElement(i).Values.Data;
%     %Add the data as a new column in the table
%     Data.(signalName)=signalData;
% end

signalName=out.logsout.getElement(1).Name;
signalData=out.logsout.getElement(1).Values.Data;
Data.(signalName)=signalData;
signalName=out.logsout.getElement(2).Name;
signalData=out.logsout.getElement(2).Values.Data;
Data.(signalName)=signalData;
signalName=out.logsout.getElement(3).Name;
signalData=out.logsout.getElement(3).Values.Data;
Data.(signalName)=signalData;
signalName=out.logsout.getElement(4).Name;
signalData=out.logsout.getElement(4).Values.Data;
Data.(signalName)=signalData;
signalName=out.logsout.getElement(5).Name;
signalData=out.logsout.getElement(5).Values.Data;
Data.(signalName)=signalData;
signalName=out.logsout.getElement(6).Name;
signalData=out.logsout.getElement(6).Values.Data;
Data.(signalName)=signalData;
signalName=out.logsout.getElement(7).Name;
signalData=out.logsout.getElement(7).Values.Data;
Data.(signalName)=signalData;
signalName=out.logsout.getElement(8).Name;
signalData=out.logsout.getElement(8).Values.Data;
Data.(signalName)=signalData;
signalName=out.logsout.getElement(9).Name;
signalData=out.logsout.getElement(9).Values.Data;
Data.(signalName)=signalData;
signalName=out.logsout.getElement(10).Name;
signalData=out.logsout.getElement(10).Values.Data;
Data.(signalName)=signalData;
signalName=out.logsout.getElement(11).Name;
signalData=out.logsout.getElement(11).Values.Data;
Data.(signalName)=signalData;
signalName=out.logsout.getElement(12).Name;
signalData=out.logsout.getElement(12).Values.Data;
Data.(signalName)=signalData;
signalName=out.logsout.getElement(13).Name;
signalData=out.logsout.getElement(13).Values.Data;
Data.(signalName)=signalData;
signalName=out.logsout.getElement(14).Name;
signalData=out.logsout.getElement(14).Values.Data;
Data.(signalName)=signalData;
signalName=out.logsout.getElement(15).Name;
signalData=out.logsout.getElement(15).Values.Data;
Data.(signalName)=signalData;
signalName=out.logsout.getElement(16).Name;
signalData=out.logsout.getElement(16).Values.Data;
Data.(signalName)=signalData;
signalName=out.logsout.getElement(17).Name;
signalData=out.logsout.getElement(17).Values.Data;
Data.(signalName)=signalData;
signalName=out.logsout.getElement(18).Name;
signalData=out.logsout.getElement(18).Values.Data;
Data.(signalName)=signalData;
signalName=out.logsout.getElement(19).Name;
signalData=out.logsout.getElement(19).Values.Data;
Data.(signalName)=signalData;
signalName=out.logsout.getElement(20).Name;
signalData=out.logsout.getElement(20).Values.Data;
Data.(signalName)=signalData;
signalName=out.logsout.getElement(21).Name;
signalData=out.logsout.getElement(21).Values.Data;
Data.(signalName)=signalData;
signalName=out.logsout.getElement(22).Name;
signalData=out.logsout.getElement(22).Values.Data;
Data.(signalName)=signalData;
signalName=out.logsout.getElement(23).Name;
signalData=out.logsout.getElement(23).Values.Data;
Data.(signalName)=signalData;
signalName=out.logsout.getElement(24).Name;
signalData=out.logsout.getElement(24).Values.Data;
Data.(signalName)=signalData;
signalName=out.logsout.getElement(25).Name;
signalData=out.logsout.getElement(25).Values.Data;
Data.(signalName)=signalData;
signalName=out.logsout.getElement(26).Name;
signalData=out.logsout.getElement(26).Values.Data;
Data.(signalName)=signalData;
% signalName=out.logsout.getElement(1).Name;
% signalData=out.logsout.getElement(1).Values.Data;
% Data.(signalName)=signalData;
% signalName=out.logsout.getElement(1).Name;
% signalData=out.logsout.getElement(1).Values.Data;
% Data.(signalName)=signalData;
% signalName=out.logsout.getElement(1).Name;
% signalData=out.logsout.getElement(1).Values.Data;
% Data.(signalName)=signalData;
% signalName=out.logsout.getElement(1).Name;
% signalData=out.logsout.getElement(1).Values.Data;
% Data.(signalName)=signalData;
% signalName=out.logsout.getElement(1).Name;
% signalData=out.logsout.getElement(1).Values.Data;
% Data.(signalName)=signalData;
% signalName=out.logsout.getElement(1).Name;
% signalData=out.logsout.getElement(1).Values.Data;
% Data.(signalName)=signalData;
% signalName=out.logsout.getElement(1).Name;
% signalData=out.logsout.getElement(1).Values.Data;
% Data.(signalName)=signalData;
% signalName=out.logsout.getElement(1).Name;
% signalData=out.logsout.getElement(1).Values.Data;
% Data.(signalName)=signalData;
% signalName=out.logsout.getElement(1).Name;
% signalData=out.logsout.getElement(1).Values.Data;
% Data.(signalName)=signalData;
% signalName=out.logsout.getElement(1).Name;
% signalData=out.logsout.getElement(1).Values.Data;
% Data.(signalName)=signalData;
% signalName=out.logsout.getElement(1).Name;
% signalData=out.logsout.getElement(1).Values.Data;
% Data.(signalName)=signalData;
% signalName=out.logsout.getElement(1).Name;
% signalData=out.logsout.getElement(1).Values.Data;
% Data.(signalName)=signalData;
% signalName=out.logsout.getElement(1).Name;
% signalData=out.logsout.getElement(1).Values.Data;
% Data.(signalName)=signalData;
% signalName=out.logsout.getElement(1).Name;
% signalData=out.logsout.getElement(1).Values.Data;
% Data.(signalName)=signalData;
% signalName=out.logsout.getElement(1).Name;
% signalData=out.logsout.getElement(1).Values.Data;
% Data.(signalName)=signalData;
% signalName=out.logsout.getElement(1).Name;
% signalData=out.logsout.getElement(1).Values.Data;
% Data.(signalName)=signalData;
% signalName=out.logsout.getElement(1).Name;
% signalData=out.logsout.getElement(1).Values.Data;
% Data.(signalName)=signalData;
% signalName=out.logsout.getElement(1).Name;
% signalData=out.logsout.getElement(1).Values.Data;
% Data.(signalName)=signalData;
% signalName=out.logsout.getElement(1).Name;
% signalData=out.logsout.getElement(1).Values.Data;
% Data.(signalName)=signalData;
% signalName=out.logsout.getElement(1).Name;
% signalData=out.logsout.getElement(1).Values.Data;
% Data.(signalName)=signalData;
% signalName=out.logsout.getElement(1).Name;
% signalData=out.logsout.getElement(1).Values.Data;
% Data.(signalName)=signalData;
% signalName=out.logsout.getElement(1).Name;
% signalData=out.logsout.getElement(1).Values.Data;
% Data.(signalName)=signalData;
% signalName=out.logsout.getElement(1).Name;
% signalData=out.logsout.getElement(1).Values.Data;
% Data.(signalName)=signalData;
% signalName=out.logsout.getElement(1).Name;
% signalData=out.logsout.getElement(1).Values.Data;
% Data.(signalName)=signalData;
% signalName=out.logsout.getElement(1).Name;
% signalData=out.logsout.getElement(1).Values.Data;
% Data.(signalName)=signalData;
% signalName=out.logsout.getElement(1).Name;
% signalData=out.logsout.getElement(1).Values.Data;
% Data.(signalName)=signalData;
% signalName=out.logsout.getElement(1).Name;
% signalData=out.logsout.getElement(1).Values.Data;
% Data.(signalName)=signalData;
% signalName=out.logsout.getElement(1).Name;
% signalData=out.logsout.getElement(1).Values.Data;
% Data.(signalName)=signalData;
% signalName=out.logsout.getElement(1).Name;
% signalData=out.logsout.getElement(1).Values.Data;
% Data.(signalName)=signalData;
% signalName=out.logsout.getElement(1).Name;
% signalData=out.logsout.getElement(1).Values.Data;
% Data.(signalName)=signalData;
% signalName=out.logsout.getElement(1).Name;
% signalData=out.logsout.getElement(1).Values.Data;
% Data.(signalName)=signalData;
% signalName=out.logsout.getElement(1).Name;
% signalData=out.logsout.getElement(1).Values.Data;
% Data.(signalName)=signalData;
% signalName=out.logsout.getElement(1).Name;
% signalData=out.logsout.getElement(1).Values.Data;
% Data.(signalName)=signalData;
% signalName=out.logsout.getElement(1).Name;
% signalData=out.logsout.getElement(1).Values.Data;
% Data.(signalName)=signalData;
% signalName=out.logsout.getElement(1).Name;
% signalData=out.logsout.getElement(1).Values.Data;
% Data.(signalName)=signalData;
% signalName=out.logsout.getElement(1).Name;
% signalData=out.logsout.getElement(1).Values.Data;
% Data.(signalName)=signalData;
% signalName=out.logsout.getElement(1).Name;
% signalData=out.logsout.getElement(1).Values.Data;
% Data.(signalName)=signalData;
% signalName=out.logsout.getElement(1).Name;
% signalData=out.logsout.getElement(1).Values.Data;
% Data.(signalName)=signalData;
% signalName=out.logsout.getElement(1).Name;
% signalData=out.logsout.getElement(1).Values.Data;
% Data.(signalName)=signalData;
% signalName=out.logsout.getElement(1).Name;
% signalData=out.logsout.getElement(1).Values.Data;
% Data.(signalName)=signalData;
% signalName=out.logsout.getElement(1).Name;
% signalData=out.logsout.getElement(1).Values.Data;
% Data.(signalName)=signalData;
% signalName=out.logsout.getElement(1).Name;
% signalData=out.logsout.getElement(1).Values.Data;
% Data.(signalName)=signalData;
% signalName=out.logsout.getElement(1).Name;
% signalData=out.logsout.getElement(1).Values.Data;
% Data.(signalName)=signalData;
% signalName=out.logsout.getElement(1).Name;
% signalData=out.logsout.getElement(1).Values.Data;
% Data.(signalName)=signalData;
% signalName=out.logsout.getElement(1).Name;
% signalData=out.logsout.getElement(1).Values.Data;
% Data.(signalName)=signalData;
% signalName=out.logsout.getElement(1).Name;
% signalData=out.logsout.getElement(1).Values.Data;
% Data.(signalName)=signalData;
% signalName=out.logsout.getElement(1).Name;
% signalData=out.logsout.getElement(1).Values.Data;
% Data.(signalName)=signalData;
% signalName=out.logsout.getElement(1).Name;
% signalData=out.logsout.getElement(1).Values.Data;
% Data.(signalName)=signalData;
% signalName=out.logsout.getElement(1).Name;
% signalData=out.logsout.getElement(1).Values.Data;
% Data.(signalName)=signalData;
% signalName=out.logsout.getElement(1).Name;
% signalData=out.logsout.getElement(1).Values.Data;
% Data.(signalName)=signalData;
% signalName=out.logsout.getElement(1).Name;
% signalData=out.logsout.getElement(1).Values.Data;
% Data.(signalName)=signalData;
% signalName=out.logsout.getElement(1).Name;
% signalData=out.logsout.getElement(1).Values.Data;
% Data.(signalName)=signalData;
% signalName=out.logsout.getElement(1).Name;
% signalData=out.logsout.getElement(1).Values.Data;
% Data.(signalName)=signalData;
% signalName=out.logsout.getElement(1).Name;
% signalData=out.logsout.getElement(1).Values.Data;
% Data.(signalName)=signalData;
% signalName=out.logsout.getElement(1).Name;
% signalData=out.logsout.getElement(1).Values.Data;
% Data.(signalName)=signalData;
% signalName=out.logsout.getElement(1).Name;
% signalData=out.logsout.getElement(1).Values.Data;
% Data.(signalName)=signalData;
% signalName=out.logsout.getElement(1).Name;
% signalData=out.logsout.getElement(1).Values.Data;
% Data.(signalName)=signalData;
% signalName=out.logsout.getElement(1).Name;
% signalData=out.logsout.getElement(1).Values.Data;
% Data.(signalName)=signalData;
% signalName=out.logsout.getElement(1).Name;
% signalData=out.logsout.getElement(1).Values.Data;
% Data.(signalName)=signalData;
% signalName=out.logsout.getElement(1).Name;
% signalData=out.logsout.getElement(1).Values.Data;
% Data.(signalName)=signalData;
% signalName=out.logsout.getElement(1).Name;
% signalData=out.logsout.getElement(1).Values.Data;
% Data.(signalName)=signalData;
% signalName=out.logsout.getElement(1).Name;
% signalData=out.logsout.getElement(1).Values.Data;
% Data.(signalName)=signalData;
% signalName=out.logsout.getElement(1).Name;
% signalData=out.logsout.getElement(1).Values.Data;
% Data.(signalName)=signalData;
% signalName=out.logsout.getElement(1).Name;
% signalData=out.logsout.getElement(1).Values.Data;
% Data.(signalName)=signalData;
% signalName=out.logsout.getElement(1).Name;
% signalData=out.logsout.getElement(1).Values.Data;
% Data.(signalName)=signalData;
% signalName=out.logsout.getElement(1).Name;
% signalData=out.logsout.getElement(1).Values.Data;
% Data.(signalName)=signalData;
% signalName=out.logsout.getElement(1).Name;
% signalData=out.logsout.getElement(1).Values.Data;
% Data.(signalName)=signalData;
% signalName=out.logsout.getElement(1).Name;
% signalData=out.logsout.getElement(1).Values.Data;
% Data.(signalName)=signalData;
% signalName=out.logsout.getElement(1).Name;
% signalData=out.logsout.getElement(1).Values.Data;
% Data.(signalName)=signalData;
% signalName=out.logsout.getElement(1).Name;
% signalData=out.logsout.getElement(1).Values.Data;
% Data.(signalName)=signalData;
% signalName=out.logsout.getElement(1).Name;
% signalData=out.logsout.getElement(1).Values.Data;
% Data.(signalName)=signalData;
% signalName=out.logsout.getElement(1).Name;
% signalData=out.logsout.getElement(1).Values.Data;
% Data.(signalName)=signalData;
% signalName=out.logsout.getElement(1).Name;
% signalData=out.logsout.getElement(1).Values.Data;
% Data.(signalName)=signalData;
% signalName=out.logsout.getElement(1).Name;
% signalData=out.logsout.getElement(1).Values.Data;
% Data.(signalName)=signalData;
% signalName=out.logsout.getElement(1).Name;
% signalData=out.logsout.getElement(1).Values.Data;
% Data.(signalName)=signalData;
% signalName=out.logsout.getElement(1).Name;
% signalData=out.logsout.getElement(1).Values.Data;
% Data.(signalName)=signalData;
% signalName=out.logsout.getElement(1).Name;
% signalData=out.logsout.getElement(1).Values.Data;
% Data.(signalName)=signalData;
% signalName=out.logsout.getElement(1).Name;
% signalData=out.logsout.getElement(1).Values.Data;
% Data.(signalName)=signalData;
% signalName=out.logsout.getElement(1).Name;
% signalData=out.logsout.getElement(1).Values.Data;
% Data.(signalName)=signalData;
% signalName=out.logsout.getElement(1).Name;
% signalData=out.logsout.getElement(1).Values.Data;
% Data.(signalName)=signalData;
% signalName=out.logsout.getElement(1).Name;
% signalData=out.logsout.getElement(1).Values.Data;
% Data.(signalName)=signalData;
% signalName=out.logsout.getElement(1).Name;
% signalData=out.logsout.getElement(1).Values.Data;
% Data.(signalName)=signalData;
% signalName=out.logsout.getElement(1).Name;
% signalData=out.logsout.getElement(1).Values.Data;
% Data.(signalName)=signalData;
% signalName=out.logsout.getElement(1).Name;
% signalData=out.logsout.getElement(1).Values.Data;
% Data.(signalName)=signalData;
% signalName=out.logsout.getElement(1).Name;
% signalData=out.logsout.getElement(1).Values.Data;
% Data.(signalName)=signalData;
% signalName=out.logsout.getElement(1).Name;
% signalData=out.logsout.getElement(1).Values.Data;
% Data.(signalName)=signalData;
% signalName=out.logsout.getElement(1).Name;
% signalData=out.logsout.getElement(1).Values.Data;
% Data.(signalName)=signalData;
% signalName=out.logsout.getElement(1).Name;
% signalData=out.logsout.getElement(1).Values.Data;
% Data.(signalName)=signalData;
% signalName=out.logsout.getElement(1).Name;
% signalData=out.logsout.getElement(1).Values.Data;
% Data.(signalName)=signalData;
% signalName=out.logsout.getElement(1).Name;
% signalData=out.logsout.getElement(1).Values.Data;
% Data.(signalName)=signalData;
% signalName=out.logsout.getElement(1).Name;
% signalData=out.logsout.getElement(1).Values.Data;
% Data.(signalName)=signalData;
% signalName=out.logsout.getElement(1).Name;
% signalData=out.logsout.getElement(1).Values.Data;
% Data.(signalName)=signalData;
% signalName=out.logsout.getElement(1).Name;
% signalData=out.logsout.getElement(1).Values.Data;
% Data.(signalName)=signalData;
% signalName=out.logsout.getElement(1).Name;
% signalData=out.logsout.getElement(1).Values.Data;
% Data.(signalName)=signalData;
% signalName=out.logsout.getElement(1).Name;
% signalData=out.logsout.getElement(1).Values.Data;
% Data.(signalName)=signalData;
% signalName=out.logsout.getElement(1).Name;
% signalData=out.logsout.getElement(1).Values.Data;
% Data.(signalName)=signalData;
% signalName=out.logsout.getElement(1).Name;
% signalData=out.logsout.getElement(1).Values.Data;
% Data.(signalName)=signalData;
% signalName=out.logsout.getElement(1).Name;
% signalData=out.logsout.getElement(1).Values.Data;
% Data.(signalName)=signalData;
% signalName=out.logsout.getElement(1).Name;
% signalData=out.logsout.getElement(1).Values.Data;
% Data.(signalName)=signalData;
% signalName=out.logsout.getElement(1).Name;
% signalData=out.logsout.getElement(1).Values.Data;
% Data.(signalName)=signalData;
% signalName=out.logsout.getElement(1).Name;
% signalData=out.logsout.getElement(1).Values.Data;
% Data.(signalName)=signalData;
% signalName=out.logsout.getElement(1).Name;
% signalData=out.logsout.getElement(1).Values.Data;
% Data.(signalName)=signalData;
% signalName=out.logsout.getElement(1).Name;
% signalData=out.logsout.getElement(1).Values.Data;
% Data.(signalName)=signalData;
% signalName=out.logsout.getElement(1).Name;
% signalData=out.logsout.getElement(1).Values.Data;
% Data.(signalName)=signalData;
% signalName=out.logsout.getElement(1).Name;
% signalData=out.logsout.getElement(1).Values.Data;
% Data.(signalName)=signalData;
% signalName=out.logsout.getElement(1).Name;
% signalData=out.logsout.getElement(1).Values.Data;
% Data.(signalName)=signalData;
% signalName=out.logsout.getElement(1).Name;
% signalData=out.logsout.getElement(1).Values.Data;
% Data.(signalName)=signalData;
% signalName=out.logsout.getElement(1).Name;
% signalData=out.logsout.getElement(1).Values.Data;
% Data.(signalName)=signalData;
% signalName=out.logsout.getElement(1).Name;
% signalData=out.logsout.getElement(1).Values.Data;
% Data.(signalName)=signalData;
% signalName=out.logsout.getElement(1).Name;
% signalData=out.logsout.getElement(1).Values.Data;
% Data.(signalName)=signalData;
% signalName=out.logsout.getElement(1).Name;
% signalData=out.logsout.getElement(1).Values.Data;
% Data.(signalName)=signalData;
% signalName=out.logsout.getElement(1).Name;
% signalData=out.logsout.getElement(1).Values.Data;
% Data.(signalName)=signalData;
% signalName=out.logsout.getElement(1).Name;
% signalData=out.logsout.getElement(1).Values.Data;
% Data.(signalName)=signalData;
% signalName=out.logsout.getElement(1).Name;
% signalData=out.logsout.getElement(1).Values.Data;
% Data.(signalName)=signalData;
% signalName=out.logsout.getElement(1).Name;
% signalData=out.logsout.getElement(1).Values.Data;
% Data.(signalName)=signalData;
% signalName=out.logsout.getElement(1).Name;
% signalData=out.logsout.getElement(1).Values.Data;
% Data.(signalName)=signalData;
% signalName=out.logsout.getElement(1).Name;
% signalData=out.logsout.getElement(1).Values.Data;
% Data.(signalName)=signalData;
% signalName=out.logsout.getElement(1).Name;
% signalData=out.logsout.getElement(1).Values.Data;
% Data.(signalName)=signalData;
% signalName=out.logsout.getElement(1).Name;
% signalData=out.logsout.getElement(1).Values.Data;
% Data.(signalName)=signalData;
% signalName=out.logsout.getElement(1).Name;
% signalData=out.logsout.getElement(1).Values.Data;
% Data.(signalName)=signalData;
% signalName=out.logsout.getElement(1).Name;
% signalData=out.logsout.getElement(1).Values.Data;
% Data.(signalName)=signalData;
% signalName=out.logsout.getElement(1).Name;
% signalData=out.logsout.getElement(1).Values.Data;
% Data.(signalName)=signalData;
% signalName=out.logsout.getElement(1).Name;
% signalData=out.logsout.getElement(1).Values.Data;
% Data.(signalName)=signalData;
% signalName=out.logsout.getElement(1).Name;
% signalData=out.logsout.getElement(1).Values.Data;
% Data.(signalName)=signalData;
% signalName=out.logsout.getElement(1).Name;
% signalData=out.logsout.getElement(1).Values.Data;
% Data.(signalName)=signalData;
% signalName=out.logsout.getElement(1).Name;
% signalData=out.logsout.getElement(1).Values.Data;
% Data.(signalName)=signalData;
% signalName=out.logsout.getElement(1).Name;
% signalData=out.logsout.getElement(1).Values.Data;
% Data.(signalName)=signalData;
% signalName=out.logsout.getElement(1).Name;
% signalData=out.logsout.getElement(1).Values.Data;
% Data.(signalName)=signalData;
% signalName=out.logsout.getElement(1).Name;
% signalData=out.logsout.getElement(1).Values.Data;
% Data.(signalName)=signalData;
% signalName=out.logsout.getElement(1).Name;
% signalData=out.logsout.getElement(1).Values.Data;
% Data.(signalName)=signalData;
% signalName=out.logsout.getElement(1).Name;
% signalData=out.logsout.getElement(1).Values.Data;
% Data.(signalName)=signalData;
% signalName=out.logsout.getElement(1).Name;
% signalData=out.logsout.getElement(1).Values.Data;
% Data.(signalName)=signalData;
% signalName=out.logsout.getElement(1).Name;
% signalData=out.logsout.getElement(1).Values.Data;
% Data.(signalName)=signalData;
% signalName=out.logsout.getElement(1).Name;
% signalData=out.logsout.getElement(1).Values.Data;
% Data.(signalName)=signalData;
% signalName=out.logsout.getElement(1).Name;
% signalData=out.logsout.getElement(1).Values.Data;
% Data.(signalName)=signalData;
% signalName=out.logsout.getElement(1).Name;
% signalData=out.logsout.getElement(1).Values.Data;
% Data.(signalName)=signalData;
% signalName=out.logsout.getElement(1).Name;
% signalData=out.logsout.getElement(1).Values.Data;
% Data.(signalName)=signalData;
% signalName=out.logsout.getElement(1).Name;
% signalData=out.logsout.getElement(1).Values.Data;
% Data.(signalName)=signalData;
% signalName=out.logsout.getElement(1).Name;
% signalData=out.logsout.getElement(1).Values.Data;
% Data.(signalName)=signalData;
% signalName=out.logsout.getElement(1).Name;
% signalData=out.logsout.getElement(1).Values.Data;
% Data.(signalName)=signalData;
% signalName=out.logsout.getElement(1).Name;
% signalData=out.logsout.getElement(1).Values.Data;
% Data.(signalName)=signalData;
% signalName=out.logsout.getElement(1).Name;
% signalData=out.logsout.getElement(1).Values.Data;
% Data.(signalName)=signalData;
% signalName=out.logsout.getElement(1).Name;
% signalData=out.logsout.getElement(1).Values.Data;
% Data.(signalName)=signalData;
% signalName=out.logsout.getElement(1).Name;
% signalData=out.logsout.getElement(1).Values.Data;
% Data.(signalName)=signalData;
% signalName=out.logsout.getElement(1).Name;
% signalData=out.logsout.getElement(1).Values.Data;
% Data.(signalName)=signalData;
% signalName=out.logsout.getElement(1).Name;
% signalData=out.logsout.getElement(1).Values.Data;
% Data.(signalName)=signalData;
% signalName=out.logsout.getElement(1).Name;
% signalData=out.logsout.getElement(1).Values.Data;
% Data.(signalName)=signalData;
% signalName=out.logsout.getElement(1).Name;
% signalData=out.logsout.getElement(1).Values.Data;
% Data.(signalName)=signalData;
% signalName=out.logsout.getElement(1).Name;
% signalData=out.logsout.getElement(1).Values.Data;
% Data.(signalName)=signalData;
% signalName=out.logsout.getElement(1).Name;
% signalData=out.logsout.getElement(1).Values.Data;
% Data.(signalName)=signalData;
% signalName=out.logsout.getElement(1).Name;
% signalData=out.logsout.getElement(1).Values.Data;
% Data.(signalName)=signalData;
% signalName=out.logsout.getElement(1).Name;
% signalData=out.logsout.getElement(1).Values.Data;
% Data.(signalName)=signalData;
% signalName=out.logsout.getElement(1).Name;
% signalData=out.logsout.getElement(1).Values.Data;
% Data.(signalName)=signalData;
% signalName=out.logsout.getElement(1).Name;
% signalData=out.logsout.getElement(1).Values.Data;
% Data.(signalName)=signalData;
% signalName=out.logsout.getElement(1).Name;
% signalData=out.logsout.getElement(1).Values.Data;
% Data.(signalName)=signalData;
% signalName=out.logsout.getElement(1).Name;
% signalData=out.logsout.getElement(1).Values.Data;
% Data.(signalName)=signalData;
% signalName=out.logsout.getElement(1).Name;
% signalData=out.logsout.getElement(1).Values.Data;
% Data.(signalName)=signalData;
% signalName=out.logsout.getElement(1).Name;
% signalData=out.logsout.getElement(1).Values.Data;
% Data.(signalName)=signalData;
% signalName=out.logsout.getElement(1).Name;
% signalData=out.logsout.getElement(1).Values.Data;
% Data.(signalName)=signalData;
% signalName=out.logsout.getElement(1).Name;
% signalData=out.logsout.getElement(1).Values.Data;
% Data.(signalName)=signalData;
% signalName=out.logsout.getElement(1).Name;
% signalData=out.logsout.getElement(1).Values.Data;
% Data.(signalName)=signalData;
