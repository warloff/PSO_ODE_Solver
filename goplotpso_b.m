% goplotpso.m
% default plotting script used in PSO functions
%
% this script is not a function,
% it is a plugin for the main PSO routine (pso_Trelea_vectorized)
% so it shares all the same variables, be careful with variable names
% when making your own plugin

% Brian Birge
% Rev 2.0
% 3/1/06

%Revised 5/15 by Karl Schmitt to allow plotting of up to 3 pairs of
%parameters.

%Added Status bar for PSO.

% setup figure, change this for your own machine
clf
set(gcf,'Position',[850    200   800   600]); % this is the computer dependent part
%set(gcf,'Position',[743    33   853   492]);
set(gcf,'Doublebuffer','on');

% particle plot, upper left
subplot('position',[.1,.65,.2,.3]);
set(gcf,'color','k')


%waitbar(i/me,h,sprintf('GBest = %10.10g Time: %3d:%2d:%2.5f sec',gbestval,...
%    round(elapsedTime/3600),round(elapsedTime/60), ...
%    rem(elapsedTime,60)));

if i>df
    
    %sb=statusbar('Iteration %d of %d (%.f%%)      Time: %3d:%2d:%2.5f sec       Delta GBest: %5.10f',...
     %   i,me,i/me*100, round(elapsedTime/3600),round(elapsedTime/60), ...
      %  rem(elapsedTime,60), tr(i+1)-tr(i-df));
else
   % sb=statusbar('Iteration %d of %d (%.f%%)      Time: %3d:%2d:%2.5f sec       Delta GBest: %5.10f',...
    %    i,me,i/me*100, round(elapsedTime/3600),round(elapsedTime/60), ...
     %   rem(elapsedTime,60), 0);
end

%set(sb(1).ProgressBar,'Visible',1,'Value',round(i/me*100));
plot3(pos(:,1),pos(:,2),out,'b.','Markersize',7)

hold on
plot3(pbest(:,1),pbest(:,2),pbestval,'g.','Markersize',7);
plot3(gbest(1),gbest(2),gbestval,'r.','Markersize',25);

% crosshairs
offx = max(abs(min(min(pbest(:,1)),min(pos(:,1)))),...
    abs(max(max(pbest(:,1)),max(pos(:,1)))));

offy = max(abs(min(min(pbest(:,2)),min(pos(:,2)))),...
    abs(min(max(pbest(:,2)),max(pos(:,2)))));

%Decrease offset, to allow seeing more variance in large values.
offx=offx/2;
offy=offy/2;

plot3([gbest(1)-offx;gbest(1)+offx],...
    [gbest(2);gbest(2)],...
    [gbestval;gbestval],...
    'r-.');
plot3([gbest(1);gbest(1)],...
    [gbest(2)-offy;gbest(2)+offy],...
    [gbestval;gbestval],...
    'r-.');

hold off

xlabel('Dimension 1','color','y')
ylabel(['Dimension ',num2str(2)],'color','y')
zlabel('Cost','color','y')

title('Particle Dynamics','color','w','fontweight','bold')

set(gca,'Xcolor','y')
set(gca,'Ycolor','y')
set(gca,'Zcolor','y')
set(gca,'color','k')

% camera control
view(2)
try
    axis([gbest(1)-offx,gbest(1)+offx,gbest(2)-offy,gbest(2)+offy]);
catch
    axis([VR(1,1),VR(1,2),VR(2,1),VR(2,2)]);
end

%2nd particle plot, for additional dimensions.
% particle plot, center
subplot('position',[.4,.65,.2,.3]);
set(gcf,'color','k')

plot3(pos(:,3),pos(:,4),out,'b.','Markersize',7)

hold on
plot3(pbest(:,3),pbest(:,4),pbestval,'g.','Markersize',7);
plot3(gbest(3),gbest(4),gbestval,'r.','Markersize',25);

% crosshairs
offx = max(abs(min(min(pbest(:,3)),min(pos(:,3)))),...
    abs(max(max(pbest(:,3)),max(pos(:,3)))));

offy = max(abs(min(min(pbest(:,4)),min(pos(:,4)))),...
    abs(min(max(pbest(:,4)),max(pos(:,4)))));

%Decrease offset, to allow seeing more variance in large values.
offx=offx/4;
offy=offy/4;
plot3([gbest(3)-offx;gbest(3)+offx],...
    [gbest(4);gbest(4)],...
    [gbestval;gbestval],...
    'r-.');
plot3([gbest(3);gbest(3)],...
    [gbest(4)-offy;gbest(4)+offy],...
    [gbestval;gbestval],...
    'r-.');

hold off

xlabel('Dimension 3','color','y')
ylabel(['Dimension ',num2str(4)],'color','y')
zlabel('Cost','color','y')

title('Particle Dynamics','color','w','fontweight','bold')

set(gca,'Xcolor','y')
set(gca,'Ycolor','y')
set(gca,'Zcolor','y')
set(gca,'color','k')

% camera control
view(2)
try
    axis([gbest(3)-offx,gbest(3)+offx,gbest(4)-offy,gbest(4)+offy]);
catch
    axis([VR(1,1),VR(1,2),VR(D,1),VR(D,2)]);
end

%3nd particle plot, for additional dimensions.
% particle plot, upper right
[m, n]=size(pos);
if n>4
    
    subplot('position',[.7,.65,.2,.3]);
    set(gcf,'color','k')
    
    plot3(pos(:,5),pos(:,6),out,'b.','Markersize',7)
    
    hold on
    plot3(pbest(:,5),pbest(:,6),pbestval,'g.','Markersize',7);
    plot3(gbest(5),gbest(6),gbestval,'r.','Markersize',25);
    
    % crosshairs
    offx = max(abs(min(min(pbest(:,5)),min(pos(:,5)))),...
        abs(max(max(pbest(:,5)),max(pos(:,5)))));
    
    offy = max(abs(min(min(pbest(:,6)),min(pos(:,6)))),...
        abs(min(max(pbest(:,6)),max(pos(:,6)))));
    
    %Decrease offset, to allow seeing more variance in large values.
    offx=offx/4;
    offy=offy/4;
    
    plot3([gbest(5)-offx;gbest(5)+offx],...
        [gbest(6);gbest(6)],...
        [gbestval;gbestval],...
        'r-.');
    plot3([gbest(5);gbest(5)],...
        [gbest(6)-offy;gbest(6)+offy],...
        [gbestval;gbestval],...
        'r-.');
    
    hold off
    
    xlabel('Dimension 5','color','y')
    ylabel(['Dimension ',num2str(6)],'color','y')
    zlabel('Cost','color','y')
    
    title('Particle Dynamics','color','w','fontweight','bold')
    
    set(gca,'Xcolor','y')
    set(gca,'Ycolor','y')
    set(gca,'Zcolor','y')
    set(gca,'color','k')
    
    % camera control
    view(2)
    try
        axis([gbest(5)-offx,gbest(5)+offx,gbest(6)-offy,gbest(6)+offy]);
    catch
        axis([VR(1,1),VR(1,2),VR(D,1),VR(D,2)]);
    end
end

% error plot, left side
subplot('position',[0.1,0.15,.5,.32]);
semilogy(tr(find(~isnan(tr))),'color','m','linewidth',2)
%plot(tr(find(~isnan(tr))),'color','m','linewidth',2)
xlabel('epoch','color','y')
ylabel('gbest val.','color','y')

if D==1
    titstr1=sprintf(['%11.6g = %s( [ %9.6g ] )'],...
        gbestval,strrep(functname,'_','\_'),gbest(1));
elseif D==2
    titstr1=sprintf(['%11.6g = %s( [ %9.6g, %9.6g ] )'],...
        gbestval,strrep(functname,'_','\_'),gbest(1),gbest(2));
elseif D==3
    titstr1=sprintf(['%11.6g = %s( [ %9.6g, %9.6g, %9.6g ] )'],...
        gbestval,strrep(functname,'_','\_'),gbest(1),gbest(2),gbest(3));
else
    titstr1=sprintf(['%11.6g = %s( [ %g inputs ] )'],...
        gbestval,strrep(functname,'_','\_'),D);
end
title(titstr1,'color','m','fontweight','bold');

grid on
%  axis tight

set(gca,'Xcolor','y')
set(gca,'Ycolor','y')
set(gca,'Zcolor','y')
set(gca,'color','k')

set(gca,'YMinorGrid','off')

% text box in lower right
% doing it this way so I can format each line any way I want
subplot('position',[.62,.2,.29,.3]);
clear titstr
if trelea==0
    PSOtype  = 'Common PSO';
    xtraname = 'Inertia Weight : ';
    xtraval  = num2str(iwt(i));
    
elseif trelea==2 || trelea==1
    
    PSOtype  = (['Trelea Type ',num2str(trelea)]);
    xtraname = ' ';
    xtraval  = ' ';
    
elseif trelea==3
    PSOtype  = (['Clerc Type 1"']);
    xtraname = '\chi value : ';
    xtraval  = num2str(chi);
    
end
if isnan(errgoal)
    errgoalstr='Unconstrained';
else
    errgoalstr=num2str(errgoal);
end
if minmax==1
    minmaxstr = ['Maximize to : '];
elseif minmax==0
    minmaxstr = ['Minimize to : '];
else
    minmaxstr = ['Target   to : '];
end

if rstflg==1
    rststat1 = 'Environment Change';
    rststat2 = ' ';
else
    rststat1 = ' ';
    rststat2 = ' ';
end

titstr={'PSO Model: '      ,PSOtype;...
    'Dimensions : '    ,num2str(D);...
    '# of particles : ',num2str(ps);...
    minmaxstr          ,errgoalstr;...
    'Function : '      ,strrep(functname,'_','\_');...
    xtraname           ,xtraval;...
    rststat1           ,rststat2};

text(.1,1,[titstr{1,1},titstr{1,2}],'color','g','fontweight','bold');
hold on
text(.1,.9,[titstr{2,1},titstr{2,2}],'color','m');
text(.1,.8,[titstr{3,1},titstr{3,2}],'color','m');
text(.1,.7,[titstr{4,1}],'color','w');
text(.55,.7,[titstr{4,2}],'color','m');
text(.1,.6,[titstr{5,1},titstr{5,2}],'color','m');
text(.1,.5,[titstr{6,1},titstr{6,2}],'color','w','fontweight','bold');
text(.1,.4,[titstr{7,1},titstr{7,2}],'color','r','fontweight','bold');

% if we are training a neural net, show a few more parameters
if strcmp('pso_neteval',functname)
    % net is passed from trainpso to pso_Trelea_vectorized in case you are
    % wondering where that structure comes from
    hiddlyrstr = [];
    for lyrcnt=1:length(net.layers)
        TF{lyrcnt} = net.layers{lyrcnt}.transferFcn;
        Sn(lyrcnt) = net.layers{lyrcnt}.dimensions;
        hiddlyrstr = [hiddlyrstr,', ',TF{lyrcnt}];
    end
    hiddlyrstr = hiddlyrstr(3:end);
    
    text(0.1,.35,['#neur/lyr = [ ',num2str(net.inputs{1}.size),'  ',...
        num2str(Sn),' ]'],'color','c','fontweight','normal',...
        'fontsize',10);
    text(0.1,.275,['Lyr Fcn: ',hiddlyrstr],...
        'color','c','fontweight','normal','fontsize',9);
    
end


legstr = {'Green = Personal Bests';...
    'Blue  = Current Positions';...
    'Red   = Global Best'};
text(.1,0.025,legstr{1},'color','g');
text(.1,-.05,legstr{2},'color','b');
text(.1,-.125,legstr{3},'color','r');

hold off

set(gca,'color','k');
set(gca,'visible','off');

drawnow