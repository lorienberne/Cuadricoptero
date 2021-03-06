%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% Draws a plot which represents the quad in space                       %%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

function drawQuad(this, axScale)

%CALCULATE THE COORDENATES OF EACH END OF THE QUADCOPTER
    a = this.posSttVect(1:3) + (this.curLHb * ([this.l    0    0]'));
    b = this.posSttVect(1:3) + (this.curLHb * ([   0    this.l 0]'));
    c = this.posSttVect(1:3) + (this.curLHb * ([-this.l   0    0]'));
    d = this.posSttVect(1:3) + (this.curLHb * ([0      -this.l 0]'));

%ADJUST THE SCALE OF THE AXIS VALUES OF THE PLOT
    axScale = [-axScale axScale -axScale axScale -axScale axScale];

%SELECT THE FIGURE
    figure(this.quadFig);

%SET THE AXIS TO THE SELECTED SCALE
    axis(axScale);

%INSERT THE PLOT IN THE FIGURE SELECTED
    plot3([a(1) c(1)],[a(2) c(2)],[a(3) c(3)]); %PLOTS ONE OF THE ARMS OF THE QUADCOPTER

%REVERSE THE DIRECTION OF THE AXIS TO CORRESPOND TO THE ONES USED IN THE MODEL
    set(gca,'XDir','Reverse');
    set(gca,'ZDir','Reverse');

    hold on;

    %SET THE AXIS TO THE SELECTED SCALE
    axis(axScale);

    %INSERT THE PLOT IN THE FIGURE SELECTED
    plot3([b(1) d(1)],[b(2) d(2)],[b(3) d(3)]); %PLOTS THE OTHER ARM OF THE QUADCOPTER

    hold off;

%ADD LABELS TO EACH AXIS
    xlabel('X');
    ylabel('Y');
    zlabel('Z');
end
