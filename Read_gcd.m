function [KinVars,stance_time]=Read_gcd(filename)

    %Import data from text file.
    % Initialize variables.
    delimiter = '!';
    % Format string for each line of text:
    %   column1: text (%s)
    % For more information, see the TEXTSCAN documentation.
    formatSpec = '%s%*s%[^\n\r]';
    % Open the text file.
    fileID = fopen(filename,'r');

    dataArray = textscan(fileID, formatSpec, 'Delimiter', delimiter, 'MultipleDelimsAsOne', true,  'ReturnOnError', false);
    % Close the text file.
    fclose(fileID);
    % Allocate imported array to column variable names
    data = dataArray{:, 1};
    % Clear temporary variables
    clearvars filename delimiter formatSpec fileID dataArray ans pathname;


    KinNameLeft=char('LeftPelvicTilt','LeftPelvicObliquity','LeftPelvicRotation','LeftHipFlexExt','LeftHipAbAdduct','LeftHipRotation','LeftKneeFlexExt','LeftKneeValgVar','LeftKneeRotation','LeftDorsiPlanFlex','LeftFootRotation','LeftFootProgression');
    KinNameRight=char('RightPelvicTilt','RightPelvicObliquity','RightPelvicRotation','RightHipFlexExt','RightHipAbAdduct','RightHipRotation','RightKneeFlexExt','RightKneeValgVar','RightKneeRotation','RightDorsiPlanFlex','RightFootRotation','RightFootProgression');
    
    FootOffLeft=char('LeftFootOff');
    FootOffRight=char('RightFootOff');

    % Define kinematic variable names 
    % compare first KinName to see if this is a left or right file 
    test=find(strncmp(KinNameLeft(1,:),data,length(find(isletter(KinNameLeft(1,:))))),1);
    if isempty(test)
        R=1; % if right R=1
        KinName=KinNameRight;
        FootOff=FootOffRight;
    else 
        R=2;
        KinName=KinNameLeft;
        FootOff=FootOffLeft;
    end 
    % find headings 
    

    for i=1:size(KinName,1);
         index(i)=find(strncmp(KinName(i,:),data,length(find(isletter(KinName(i,:))))),1); % compare string up to how many letters are in the word..then it takes the first instance, this will only work in the kinematics is displayed before the kinetics
    ag(:,i)=data((index(i)+1):(index(i)+51));
    end  

    for i=1:size(FootOff,1);
         index(i)=find(strncmp(FootOff(i,:),data,length(find(isletter(KinName(i,:))))),1); 
        stance=data((index(i)+1));
    end 

    for i=1:size(ag,1);
    for j=1:size(ag,2);
        KinVars(i,j)=str2num(ag{i,j});
    end
    end

    stance_time=cell2mat(stance);

end

% % find where cells are empty 
% for i=1:size(AllData,2)
%     AllDataIndex(i)=isempty(AllData(i).KinVars);
% end
% index1=find(AllDataIndex==0);







