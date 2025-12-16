clc
clear all
close all

%%% Select GCD to analze %%%%%%

filename=uigetfile(('*.GCD'));


%%%%%%%%%%%%%%%%%%%%%%%% DEFINE NORMATIVE DATA %%%%%%%%%%%%%%%%%%%%%
%%% Read norms file %%%
norms_average=readmatrix("Norm_average.csv");
norms_sd=readmatrix("Norm_sd.csv");

%define upper and lower bounds of gray bands
for i=1:51
    for j=1:12
        gray_band_upper(i,j)=norms_average(i,j)+norms_sd(i,j);
        gray_band_lower(i,j)=norms_average(i,j)-norms_sd(i,j);
    end
end

for i=1:50
    norms_slope(i)=norms_average(i+1,10)-norms_average(i,10);
end

%%%% Read patient gcd %%%%%%%
        [patient_data, patient_stance]=Read_gcd(filename);

for i=1:50
    ankle_slope(i)=patient_data(i+1,10)-patient_data(i,10);
end
   %look at 20-45% of gait cycle (row 11 to 24, 14 datapoints)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%Schwartz classification 
%as described in Rozumalski & Schwartz. Gait Posture. 2009 Aug;30(2):155-60.
Schwartz_average=readmatrix("SchwartzCrouchClusters_Mean.csv");
Schwartz_sd=readmatrix("SchwartzCrouchClusters_SD.csv");
%pelvis=rows 1-51, hip=rows 52:102, knee=rows 103-153, ankle=rows 154-204

Schwartz_lower=Schwartz_average-Schwartz_sd;
Schwartz_upper=Schwartz_average+Schwartz_sd;

%%%%Check for severe crouch
for i=11:24
%Check knee severe
    if patient_data(i,7) > Schwartz_lower(i+102,6)
          check_knee5(i)=1;   %patient is above lower bound of severe knee curve
    else
          check_knee5(i)=0;
    end
%Check hip severe
     if patient_data(i,4) > Schwartz_lower(i+51,6)
          check_hip5(i)=1;   %patient is above lower bound of severe hip curve
     else
          check_hip5(i)=0;
     end
%Check ankle for severe crouch
    if patient_data(i,10) > 5
            check_ankle5(i)=1;   %Is patient in more than 5 degrees of dorsiflexion?
    else
            check_ankle5(i)=0;
    end  
% Check for moderate crouch  
     if patient_data(i,7) > Schwartz_lower(i+102,3)         
          check_knee2(i)=1;   %patient is above lower bound of moderate (2) knee curve
     else
          check_knee2(i)=0;
     end
%Check anterior pelvic tilt 
     if patient_data(i,1) > Schwartz_lower(i,4)
            check_pelvis(i)=1;   %patient is above lower bound of moderate (3) pelvis curve
     else
            check_pelvis(i)=0;
     end
%Check ankle equinus 
    if patient_data(i,10) < Schwartz_upper(i+153,5)
            check_ankle4(i)=1;   %patient is below uper bound of moderate (4) ankle curve
    else
            check_ankle4(i)=0;
    end    

%Check ankle equinus (mild)
    if patient_data(i,10) < Schwartz_upper(i+153,2)
            check_ankle1(i)=1;   
    else
            check_ankle1(i)=0;
    end  
 end

%First check knee initial contact
if patient_data(1,7) < (norms_average(1,7)+2*norms_sd(1,7))
    Schwartz_type=0;
elseif patient_data(1,7) >= (norms_average(1,7)+2*norms_sd(1,7))  %patient is in crouch
    if sum(check_knee5)>13 & sum(check_hip5)>13 & sum(check_ankle5)>13   %hip and knee above severe curves, ankle above 5 deg
          Schwartz_type=5;  %severe crouch
    elseif sum(check_knee2)>13 & sum(check_pelvis)>13 & sum(check_ankle4)>13   %moderate crouch
          Schwartz_type=6;    %Anterior pelvic tilt & equinus
    elseif sum(check_knee2)>13 & sum(check_pelvis)>13
          Schwartz_type=3;    %Anterior pelvic tilt
    elseif sum(check_knee2)>13 & sum(check_ankle4)>13
          Schwartz_type=4;   %Equinus
    elseif sum(check_knee2)>13
        Schwartz_type=2;
    elseif sum(check_ankle1)>13 & mean(ankle_slope(11:24))< (0.5*mean(norms_slope(11:24)))
          Schwartz_type=1;
    else
          Schwartz_type=7;
    end
end
%Currently set so anything classified as crouch at initial contact but not
%catagories 2-5 is Type 1 (mild crouch with equinus)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
 %Rodda Graham classfication 
 %based on PF/KE couple described in Sangeux et al. Gait Posture Volume 41, Issue 2, February 2015, Pages 586-591
   %Calculate knee score
   for k=11:24
        knee=(patient_data(k,7)-norms_average(k,7))/norms_sd(k,7);
   end
        kneeP=mean(knee);

   %Calculate ankle score
   for k=11:24
        ankle=(patient_data(k,10)-norms_average(k,10))/norms_sd(k,10);
   end
        ankleP=mean(ankle);
%Establish classification
if ankleP > -1 && ankleP < 1 && kneeP > -1 && kneeP < 1
    SagPatternClass = 'WNL'; 
    Rodda_Graham_Type=0;
elseif ankleP < -1
    if kneeP < 1
    SagPatternClass = 'True equinus';
    Rodda_Graham_Type=1;
    elseif kneeP > 1
    SagPatternClass = 'Jump';
    Rodda_Graham_Type=2;
    end
elseif ankleP > 1
    if kneeP > 1
    SagPatternClass = 'Crouch';
    Rodda_Graham_Type=4;
    elseif kneeP > -1
    SagPatternClass = 'Ankle Crouch'; % new proposition, see discussion 
    Rodda_Graham_Type=5;
    else
    SagPatternClass = 'Impossible?'; % to document anomaly in large databases
    Rodda_Graham_Type=7;
    end
elseif kneeP > 1
SagPatternClass = 'Apparent equinus';
Rodda_Graham_Type=3;
elseif kneeP < -1
SagPatternClass = 'Knee recurvatum'; % new proposition, see discussion
Rodda_Graham_Type=6;
else 
SagPatternClass = 'Weird'; % to document anomaly in large databases
Rodda_Graham_Type=8;
end

% 
% % %Plot
  figure(1); plot_data_classify(norms_average,norms_sd,patient_data,filename,Rodda_Graham_Type,Schwartz_type)

  if Rodda_Graham_Type==1
    RG_type='True Equinus';
elseif Rodda_Graham_Type==2
    RG_type='Jump Gait';
elseif Rodda_Graham_Type==3
    RG_type='Apparent Equinus';
elseif Rodda_Graham_Type==4;
    RG_type='Crouch';
elseif Rodda_Graham_Type==5;
    RG_type='Ankle Crouch';
elseif Rodda_Graham_Type==6;
    RG_type='Knee recurvatum';
else
    RG_type='No Type';
end

if Schwartz_type==0
    RS_type='No Type';
elseif Schwartz_type==1
    RS_type='Mild Crouch with Equinus';
elseif Schwartz_type==2
    RS_type='Moderate Crouch';
elseif Schwartz_type==3
    RS_type='Moderate Crouch with Anterior Pelvic Tilt';
elseif Schwartz_type==4
    RS_type='Moderate Crouch with Equinus';
elseif Schwartz_type==5
    RS_type='Severe Crouch';
elseif Schwartz_type==6
    RS_type='Moderate Crouch with Anterior Pelvic Tilt & Equinus';
elseif Schwartz_type==7
    RS_type='No type but "crouch" at IC';
end


Rodda_Graham_Type=RG_type;
Rozumalski_Schwartz=RS_type;

Rodda_Graham_Type
Rozumalski_Schwartz