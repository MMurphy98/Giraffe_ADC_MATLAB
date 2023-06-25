function createfigure_GainSweep(X1, Y1, Y2)
%CREATEFIGURE(X1, Y1, Y2)
%  X1:  x 数据的向量
%  Y1:  y 数据的向量
%  Y2:  y 数据的向量

%  由 MATLAB 于 11-Mar-2023 07:33:53 自动生成

% 创建 figure
figure1 = figure('NumberTitle','off','Name','Gain Sweep','Color',[1 1 1]);
figure1.Position = [100 100 600 450];
% 创建 axes
axes1 = axes('Parent',figure1);
hold(axes1,'on');
colororder([0 0.447 0.741]);

% 激活坐标区的 left 侧
yyaxis(axes1,'left');
% 创建 plot
plot(X1,Y1,'DisplayName','Power','LineWidth',2,'Color',[0 0 1]);

% 创建 ylabel
ylabel('SNDR (dB)','FontWeight','bold','FontName','Times New Roman',...
    'Color',[0 0 1]);

 ylim(axes1,[60 85]);

% 设置其余坐标区属性
set(axes1,'YColor',[0 0 1]);
% 激活坐标区的 right 侧
yyaxis(axes1,'right');
% 创建 plot
p1 = plot(X1,Y2,'DisplayName','Fit Curve','LineWidth',2,'Color',[1 0 0]);

% datatip(p1, 15.277, -93.5, 'FontSize', 13,'FontName','Times New Roman')

% 创建 ylabel
ylabel('THD (dB)','FontWeight','bold','FontName','Times New Roman',...
    'Color',[1 0 0]);

 ylim(axes1,[-95 -60]);

% 设置其余坐标区属性
set(axes1,'YColor',[1 0 0]);
% 创建 xlabel
xlabel('Gain','FontWeight','bold','FontName','Times New Roman');

box(axes1,'on');
grid(axes1,'on');
hold(axes1,'off');
% 设置其余坐标区属性
set(axes1,'FontName','Times New Roman','FontSize',15,'FontWeight','bold',...
    'LineWidth',2,'XTick',15:0.2:16);