%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% INPUT -> The array with the three angles that define the orientation  %%
%%          of the quad.                                                 %%
%% OUTPUTS -> The rotation matrix result of three rotations according to %%
%%            the angles provided.                                       %%
%%         -> Three matrices that describe each individual turn.         %% 
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


function [LHb, LH1, L12, L2b] = calcRotMat(angles)
 
    LH1 = [cos(angles(1))   sin(angles(1))  0;
           -sin(angles(1))  cos(angles(1))  0;
                 0               0         1];
             
             
    L12 = [cos(angles(2))  0  -sin(angles(2));
                 0         1        0       ;
           sin(angles(2))  0   cos(angles(2))];
       
       
    L2b = [1          0              0        ;
           0     cos(angles(3)) sin(angles(3));
           0    -sin(angles(3)) cos(angles(3))];
    
    LHb = LH1 * L12 * L2b;
    
end