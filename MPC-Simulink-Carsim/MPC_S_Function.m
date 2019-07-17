%===============================================================
% MPC模块的S-Function
%===============================================================
function [sys,x0,str,ts] = MPC_S_Function(t,x,u,flag)

switch flag
 case 0
  [sys,x0,str,ts] = mdlInitializeSizes; % Initialization
  
 case 2
  sys = mdlUpdates(t,x,u); % Update discrete states
  
 case 3
  sys = mdlOutputs(t,x,u); % Calculate outputs
 
 case {1,4,9} % Unused flags
  sys = [];
  
 otherwise
  error(['unhandled flag = ',num2str(flag)]); % Error handling
end
% End of S Function

%==============================================================
% Initialization
%==============================================================
function [sys,x0,str,ts] = mdlInitializeSizes

% Call simsizes for a sizes structure, fill it in, and convert it 
% to a sizes array.

sizes = simsizes;
sizes.NumContStates  = 0;
sizes.NumDiscStates  = 3;
sizes.NumOutputs     = 2;
sizes.NumInputs      = 5;
sizes.DirFeedthrough = 1; % Matrix D is non-empty.
sizes.NumSampleTimes = 1;
sys = simsizes(sizes); 
x0 =[0;0;0];   
% Initialize the discrete states.
str = [];             % Set str to an empty matrix.
ts  = [0.1 0];       % sample time: [period, offset]
		      
%==============================================================
% Update the discrete states
%==============================================================
function sys = mdlUpdates(t,x,u)
  
sys = x;

%==============================================================
% Calculate outputs
%==============================================================
function sys = mdlOutputs(t,x,u)
    tic
    fprintf('Update start, t=%6.3f\n',t)

    NP = 7;
    NC = 2;
    dt = 0.1;
    v_ref = 10; 

    x_start     = 0;                                         %横向位置
    y_start     = x_start + NP;                              %纵向位置
    phi_start   = y_start + NP;                              %yaw的角度，与X轴正向的夹角
    cte_start   = phi_start + NP;                            %位置误差
    ephi_start  = cte_start + NP;                            %姿态误差
    delta_start = ephi_start + NP;                           %前轮转角

    m = 6 * NP ;                                             %状态变量和控制变量的总个数
    
    state_0 = u;    
    nlcon = @(var)MPC_Nonlcon( var,state_0,NP,dt,v_ref );    %非线性约束
    cl = zeros( 6*NP+1,1 );                                  %约束的下界
    cu = zeros( 6*NP+1,1 );                                  %约束上界
    for i = (5*NP+1):6*NP
        cl(i) = -0.45;                                       %车前轮转角限制25°
        cu(i) =  0.45;
    end
    state_intial = zeros(m,1);                               %初始化
    func  = @(var)MPC_Costfunction( var,NP,dt );             %损失函数
    % opts = optiset('solver','IPOPT','display','iter','maxiter',50,'maxtime',0.5);
    opts = optiset('solver','ipopt','maxiter',60,'maxtime',0.5);
    Opt = opti('fun',func,'nl',nlcon,cl,cu,'x0',state_intial,'options',opts);
    [A,feval,exitflag,info] = solve(Opt,state_intial);
    A
    info

    
    result = zeros(2,1); 
    result(1) = v_ref;                                        %输出车速 5m/s
%     result(2) = A(delta_start + NC);                        %输出优化器求解的方向盘转角
    if exitflag < 0
        result(2) = 0;
    else
        result(2) = A(delta_start + NC);                      %输出优化器求解的方向盘转角
    end
    sys = result;
    %每一步的可视化，但会增加运算时长
%     plot(  A(1:NP),A(NP+1:2*NP),'-.p'  );
%     axis ([0 100 -30 30]);
%     axis equal;
    toc
% End of mdlOutputs.


