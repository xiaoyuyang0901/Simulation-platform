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

    x_start     = 0;                                         %����λ��
    y_start     = x_start + NP;                              %����λ��
    phi_start   = y_start + NP;                              %yaw�ĽǶȣ���X������ļн�
    cte_start   = phi_start + NP;                            %λ�����
    ephi_start  = cte_start + NP;                            %��̬���
    delta_start = ephi_start + NP;                           %ǰ��ת��

    m = 6 * NP ;                                             %״̬�����Ϳ��Ʊ������ܸ���
    
    state_0 = u;    
    nlcon = @(var)MPC_Nonlcon( var,state_0,NP,dt,v_ref );    %������Լ��
    cl = zeros( 6*NP+1,1 );                                  %Լ�����½�
    cu = zeros( 6*NP+1,1 );                                  %Լ���Ͻ�
    for i = (5*NP+1):6*NP
        cl(i) = -0.45;                                       %��ǰ��ת������25��
        cu(i) =  0.45;
    end
    state_intial = zeros(m,1);                               %��ʼ��
    func  = @(var)MPC_Costfunction( var,NP,dt );             %��ʧ����
    % opts = optiset('solver','IPOPT','display','iter','maxiter',50,'maxtime',0.5);
    opts = optiset('solver','ipopt','maxiter',60,'maxtime',0.5);
    Opt = opti('fun',func,'nl',nlcon,cl,cu,'x0',state_intial,'options',opts);
    [A,feval,exitflag,info] = solve(Opt,state_intial);
    A
    info

    
    result = zeros(2,1); 
    result(1) = v_ref;                                        %������� 5m/s
%     result(2) = A(delta_start + NC);                        %����Ż������ķ�����ת��
    if exitflag < 0
        result(2) = 0;
    else
        result(2) = A(delta_start + NC);                      %����Ż������ķ�����ת��
    end
    sys = result;
    %ÿһ���Ŀ��ӻ���������������ʱ��
%     plot(  A(1:NP),A(NP+1:2*NP),'-.p'  );
%     axis ([0 100 -30 30]);
%     axis equal;
    toc
% End of mdlOutputs.


