function createfigure_DR(X1, YMatrix1)
%CREATEFIGURE_DR(X1, YMatrix1)
%  X1:  x 数据的向量
%  YMATRIX1:  y 数据的矩阵

%  由 MATLAB 于 10-Mar-2023 17:04:35 自动生成

% 创建 figure
figure1 = figure('InvertHardcopy','off','NumberTitle','off','Name','Dynamic Range','Color',[1 1 1]);
% figure1.width = 600;
% figure1.height = 400;
figure1.Position = [100 100 600 450];

% 创建 axes
axes1 = axes('Parent',figure1);
hold(axes1,'on');

% 使用 plot 的矩阵输入创建多行
plot1 = plot(X1,YMatrix1,'LineWidth',2);
set(plot1(1),'DisplayName','SNDR','MarkerSize',7,'Marker','o',...
    'Color',[0 0 1]);
set(plot1(2),'DisplayName','Fit Curve','LineStyle','--','Color',[1 0 0]);

% 创建 ylabel
ylabel('SNDR [dB]','FontWeight','bold','FontName','Times New Roman');

% 创建 xlabel
xlabel('Input Amplitude [dB]','FontWeight','bold',...
    'FontName','Times New Roman');

% 创建 text annotation
text_str = {'Peak SNDR: 82 dB', 'Dynamic Range: 90.8 dB'};

t1 = text(-50,20,text_str, 'HorizontalAlignment','left','FontSize',15, ...
    'FontWeight','bold','FontName','Times New Roman');
t1.BackgroundColor = [1,1,1];

% 取消以下行的注释以保留坐标区的 X 范围
xlim(axes1,[-95 0]);
% 取消以下行的注释以保留坐标区的 Y 范围
ylim(axes1,[-10 95]);
box(axes1,'on');
grid(axes1,'on');
hold(axes1,'off');
% 设置其余坐标区属性
set(axes1,'FontName','Times New Roman','FontSize',15,'FontWeight','bold',...
    'LineWidth',2);
% 创建 legend
legend1 = legend(axes1,'show');
set(legend1,'Location','northwest');

