%% TEMPERATURE MAP --------------------------------------------------------

function tempmap(xg,yg,T,xt,yt,points,num)
    
    % Setting up main figure
    % ========================================================
    
    figure
    pcolor(xg,yg,T);
    hold on
    shading interp
    cb = colorbar;
    cb_label = ['Temperature [' char(176) 'C]'];
    ylabel(cb, cb_label)
    title('Temperature Map')
    xlabel('x (cm)')
    ylabel('y (cm)')
    
    
    % Setting up subplots to see data from individual robots
    % ========================================================
    
    b1 = uicontrol('style','togglebutton');
    set(b1,'position',[1 1, 120,20])
    set(b1,'string',{'Individual robot data'})
    set(b1,'callback',{@eachrobotsubplots,xt,yt,points,num})
    

    % Setting up button to save figure
    % =======================================================
    
    b2 = uicontrol('style', 'togglebutton');
    set(b2,'position',[440, 1, 120,20])
    set(b2,'string',{'Save map (.png)'})
    set(b2,'callback',@save)

    
end

%% USER-INTERFACE BUTTONS -------------------------------------------------

function eachrobotsubplots(~,~,xt,yt,points,num)

% Discerning which coordinates in xtotal and ytotal were visited by
% which robot

    if num == 1
        x1 = xt;
        y1 = yt;
        
    elseif num == 2

        x1 = xt(1:points(1));
        x2 = xt(points(1)+1:end);
        y1 = yt(1:points(1));
        y2 = yt(points(1)+1:end);

    elseif num == 3
        x1 = xt(1:points(1));
        x2 = xt(points(1)+1: points(1)+points(2));
        x3 = xt(points(1)+points(2)+1: end);
        y1 = yt(1:points(1));
        y2 = yt(points(1)+1: points(1)+points(2));
        y3 = yt(points(1)+points(2)+1: end);
    end
        
% Setting up the subplots

    figure
    subplot(2,2,1)
    scatter(xt,yt,'k')
    xlim([0 300])
    ylim([0 300])
    title('All robots')
    set(gca,'xtick',[0:60:300])
    set(gca,'ytick',[0:60:300])
    hold on; grid on;
    
    if num > 0 
        subplot(2,2,2)
        scatter(x1,y1,'m')
        xlim([0 300])
        ylim([0 300])
        title('Robot 1')
        set(gca,'xtick',[0:60:300])
        set(gca,'ytick',[0:60:300])
        hold on; grid on;
    end

    if num > 1
        subplot(2,2,3)
        scatter(x2,y2,'g')
        xlim([0 300])
        ylim([0 300])
        title('Robot 2')
        set(gca,'xtick',[0:60:300])
        set(gca,'ytick',[0:60:300])
        hold on; grid on;
    end
        
    if num > 2
        subplot(2,2,4)
        scatter(x2,y2,'g')
        xlim([0 300])
        ylim([0 300])
        set(gca,'xtick',[0:60:300])
        set(gca,'ytick',[0:60:300])
        title('Robot 2')
        hold on; grid on;
    end
    
end
    

function save(~,~)

    % Filename to be changed as preferred
    filename = 'Temperature_map_2_robots.png';
    saveas(gcf,filename)
    disp(['Saved as ' filename])
    
end