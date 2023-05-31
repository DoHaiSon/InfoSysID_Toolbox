function [SNR, Err] = B_OP(Op, Monte, SNR, Output_type)

%        h=OP(L,R)
% outer product decomposition
% returned solution is ST format
% R                 is ST format
%    (estimee) matrice de correlation
%    dimension L*(m+1)
% m : ordre canal
% L : nb de capteur
% h : estimee canal

num_sq    = Op{1};     % number of sig sequences
L         = Op{2};     % number of the sensors
M         = Op{3};     % length of the channel 
Ch_type   = Op{4};     % complex
Mod_type  = Op{5};     
N         = M+1;       % Window length

Monte     = Monte;
SNR       = SNR;       % Signal to noise ratio (dB)
Output_type = Output_type;

% Generate input signal
modulation = {'Bin', 'QPSK', 'QAM4', 'QAM16', 'QAM64', 'QAM128', 'QAM256'};

res_b     = [];
for monte = 1:Monte
%     fprintf('------------------------------------------------------------\nExperience No %d \n', monte); 

    %% Generate channel
    H         = Generate_channel(L, M, Ch_type);
    H         = H / norm(H, 'fro');
    
    %% Generate signals
    [sig, data] = eval(strcat(modulation{Mod_type}, '(num_sq + M)'));
    
    % Signal rec
    sig_rec_noiseless = [];
    for l = 1:L
        sig_rec_noiseless(:, l) = conv( H(l,:).', sig ) ;
    end
    sig_rec_noiseless = sig_rec_noiseless(M+1:num_sq + M, :);

    err_b = [];
    for snr_i = SNR
%         fprintf('Working at SNR: %d dB\n', snr_i);
        sig_rec = awgn(sig_rec_noiseless, snr_i);

        %% Algorithm OP
        [R, Y]  = EstimateCov1(sig_rec, num_sq, L, N);

        if L<2                        
            input('OP error 0');
            exit;
        end
        
        lncol   = size(R);
        if lncol(1)~=lncol(2)
            input('OP error 1');
            exit;
        end

        m       = lncol(1)/L-1;
        if floor(m)~=m 
            input('OP error 2');
            exit;
        end


        Y       = R - noisengFROMSOS(L,R,m)*eye(L*(m+1));
        Ycirc   = Hae(Y(1:L,:));
        
        % calculer la pseudo inv de Y pour etre sur q'elle soit hermitienne
        [u,s,v] = svd(Y);
        for ii  = 1:2*m+1
            s(ii,ii) = 1/s(ii,ii);
        end
        for ii  = 2*m+2:L*(m+1)
            s(ii,ii) = 0;
        end
        pinvY   = u*s*u';

        D1      = Ycirc*pinvY*Ycirc';
        D2      = [   D1(L+1:L+L*m,L+1:L+L*m) zeros(L*m,L) ;
            zeros(L        ,      L*m) zeros(L  ,L) ];

        [h,lambda] = XEIG(D1-D2,1,0);
        h_est      = h*exp(-1i*angle(h(1,1)));

        % Compute MSE Channel
        ER_SNR  = ER_func(H.', h_est, Mod_type, Output_type);

        err_b   = [err_b, ER_SNR];
    end
    
    res_b   = [res_b;  err_b];
end

% Return
if Monte ~= 1
    Err = mean(res_b);
else
    Err = res_b;
end