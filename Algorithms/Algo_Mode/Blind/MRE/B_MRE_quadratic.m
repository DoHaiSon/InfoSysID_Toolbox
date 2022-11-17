function [SNR, Err] = B_MRE_quadratic(Op, Monte, SNR, Output_type)

num_sq    = Op{1};     % number of sig sequences
L         = Op{2};     % number of the sensors
M         = Op{3};     % length of the channel
Ch_type   = Op{4};     % complex
Mod_type  = Op{5};     
N         = Op{6};     % number of measurements
K         = M + N;     % rank of H
Monte     = Monte;
SNR       = SNR;       % Signal to noise ratio (dB)
Output_type = Output_type;

% Generate input signal
modulation = {'Bin', 'QPSK', 'QAM4', 'QAM16'};

%% Generate channel
H         = Generate_channel(L, M, Ch_type);

res_b     = [];
for monte = 1:Monte
%     fprintf('------------------------------------------------------------\nExperience No %d \n', monte); 
    err_b = [];
    for snr_i = SNR
%         fprintf('Working at SNR: %d dB\n', snr_i);

        %% Generate signals
        [sig_src, data] = eval(strcat(modulation{Mod_type}, '(num_sq + M)'));
        
        % Signal rec
        sig_rec = [];
        for l = 1:L
            sig_rec(:, l) = conv( H(l,:).', sig_src ) ;
        end
        sig_rec = sig_rec(M+1:num_sq + M, :);

        sig_rec = awgn(sig_rec, snr_i);

        %% MRE
        Vt      = zeros(K, L*N);
        X       = [];
        for ii  = 1:L
          x     = sig_rec(:, ii);
          mat   = hankel(x(1:N), x(N:num_sq));
          mat   = mat(N:-1:1, :);
          X     = [X; mat];
        end
        
        %% ----------------------------------------------------------------
        %% Blind MRE program
        X_n     = X(:, 1:num_sq-N);
        X_n_1   = X(:, 2:num_sq-N+1);
        A       = kron(X_n.', [eye(K-1),zeros(K-1,1)]) - kron(X_n_1.', [zeros(K-1,1),eye(K-1)]);
        Q       = A' * A;                                                   % LNK x LNK
        [u,s,v] = svd(Q);
        Vt(:)   = u(:, L*N*K);
        V_b     = Vt';
        
        
        %% ----------------------------------------------------------------
        %% Select the Equalizer has min norm
        for ii  = 1:K
          x_b(ii)   = norm(V_b(:,ii));
        end
        [~, ind_b]  = min(x_b);
        
        % Equalization
        est_src_b   = conj(X' * V_b(:, ind_b));
        sig_src_b   = sig_src(K-ind_b+1:num_sq+M-ind_b+1);
        data_src    = data(K-ind_b+1:num_sq+M-ind_b+1);  
        ER_SNR      = ER_func(data_src, est_src_b, Mod_type, Output_type, sig_src_b);

        %% Compare to src signals
        err_b   = [err_b , ER_SNR];
    end
    
    res_b   = [res_b;  err_b];
end

% Return
if Monte ~= 1
    Err = mean(res_b);
else
    Err = res_b;
end