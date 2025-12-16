function plot_data_classify(norms_average,norms_sd,patient_data,filename, Rodda_Graham_Type,Schwartz_type)

if Rodda_Graham_Type==1
    RGtype='True Equinus';
elseif Rodda_Graham_Type==2
    RGtype='Jump Gait';
elseif Rodda_Graham_Type==3
    RGtype='Apparent Equinus';
elseif Rodda_Graham_Type==4;
    RGtype='Crouch';
elseif Rodda_Graham_Type==5;
    RGtype='Ankle Crouch';
elseif Rodda_Graham_Type==6;
    RGtype='Knee recurvatum';

else
    RGtype='No Type';
end

if Schwartz_type==0
    S_type='No Type';
elseif Schwartz_type==1
    S_type='Mild Crouch with Equinus';
elseif Schwartz_type==2
    S_type='Moderate Crouch';
elseif Schwartz_type==3
    S_type='Moderate Crouch with Anterior Pelvic Tilt';
elseif Schwartz_type==4
    S_type='Moderate Crouch with Equinus';
elseif Schwartz_type==5
    S_type='Severe Crouch';
elseif Schwartz_type==6
    S_type='Moderate Crouch with Anterior Pelvic Tilt & Equinus';
elseif Schwartz_type==7
    S_type='No type but "crouch" at IC';
end



if nargin<3, str_format = 'b'; end

t = linspace(0,100,51)';
    


    subplot(2,2,1)
    i=1;   %column 1=pelvic tilt
    hold on
    patchID = patch([t(1:51);flipdim(t(1:51),1)],[norms_average(1:51,i)+norms_sd(1:51,i);flipdim(norms_average(1:51,i)-norms_sd(1:51,i),1)],[0.6,0.6,0.6]);
    set(patchID, 'EdgeColor', 'none', 'FaceAlpha', 'Flat','FaceVertexAlphaData',0.7)

    plot(t(1:51),patient_data(:,(i)),'Color','k','LineWidth',2)
    
    hold off
    ylabel('Pelvic Tilt')
    title("Pelvis")
   

  subplot(2,2,2)
    i=4;   %column 4=Hip Flexion
    hold on
    patchID = patch([t(1:51);flipdim(t(1:51),1)],[norms_average(1:51,i)+norms_sd(1:51,i);flipdim(norms_average(1:51,i)-norms_sd(1:51,i),1)],[0.6,0.6,0.6]);
    set(patchID, 'EdgeColor', 'none', 'FaceAlpha', 'Flat','FaceVertexAlphaData',0.7)

    plot(t(1:51),patient_data(:,(i)),'Color','k','LineWidth',2)
    ylabel('Hip Flexion/Extension')

    title('Hip')


  subplot(2,2,3)
    i=7;   %column 7=knee flexion
    hold on
    patchID = patch([t(1:51);flipdim(t(1:51),1)],[norms_average(1:51,i)+norms_sd(1:51,i);flipdim(norms_average(1:51,i)-norms_sd(1:51,i),1)],[0.6,0.6,0.6]);
    set(patchID, 'EdgeColor', 'none', 'FaceAlpha', 'Flat','FaceVertexAlphaData',0.7)

    plot(t(1:51),patient_data(:,(i)),'Color','k','LineWidth',2)
    ylabel('Knee Flexion/Extension')
    title("Knee")

  hold off 


  subplot(2,2,4)
    i=10;   %column 10=Ankle
    hold on
    patchID = patch([t(1:51);flipdim(t(1:51),1)],[norms_average(1:51,i)+norms_sd(1:51,i);flipdim(norms_average(1:51,i)-norms_sd(1:51,i),1)],[0.6,0.6,0.6]);
    set(patchID, 'EdgeColor', 'none', 'FaceAlpha', 'Flat','FaceVertexAlphaData',0.7)

    plot(t(1:51),patient_data(:,(i)),'Color','k','LineWidth',2)
    ylabel('Ankle Dorsi/Plantarflexion')
    title("Ankle")

    hold off 

    a=['Rodda Graham Type ', num2str(Rodda_Graham_Type),' ', RGtype];
    b=['Schwartz Type ', num2str(Schwartz_type),' ', S_type];
   
 sgtitle({a,b})   
    
end




