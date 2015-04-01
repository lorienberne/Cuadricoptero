%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% Draws a plot which represents the quad in space                       %%
%% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

function drawQuad(this, axScale)
%Calculate the global coordenates of each end of the quadcopter
    LbH = (calcRotMat(this.angles))';

    a = this.r + (LbH * ([this.l    0    0]'));
    b = this.r + (LbH * ([   0    this.l 0]'));
    c = this.r + (LbH * ([-this.l   0    0]'));
    d = this.r + (LbH * ([0      -this.l 0]'));
    
    axScale = [-axScale axScale -axScale axScale -axScale axScale];
    
    
    figure(this.quadFig);
    axis(axScale);
    plot3([a(1) c(1)],[a(2) c(2)],[a(3) c(3)]);
    set(gca,'XDir','Reverse');
%      set(gca,'YDir','Reverse');
     set(gca,'ZDir','Reverse');
    hold on;
    axis(axScale);
    plot3([b(1) d(1)],[b(2) d(2)],[b(3) d(3)]);
    hold off;
    


    
    xlabel('X');
    ylabel('Y');
    zlabel('Z');
end