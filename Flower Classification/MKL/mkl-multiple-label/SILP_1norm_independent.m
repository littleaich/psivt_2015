function [model, trace] = SILP_1norm_independent(G, Y, param)
% this is a function  to implement SILP for multi-task kernel selection with 1norm SVM by
% solving multiple binary classification tasks INDEPENDENTLY.
% [gamma, alpha_to_return, bias_to_return, iter, trace] = SILP_1norm_independent(G, Y, C, tolerance, trace_flag, trace_step)
% Input:    G: an array of kernel matrix
%           Y: the +1/-1 class label for each task
%           C: the trade-off parameter
%           c1: the total weights of shared-kernel
%           tolerance: the parameter to determine the stopping criteria
%           trace_flag: default is false
%           trace_step: default is 10
% Output:   gamma: individual kernel coefficients (#kernels X #tasks)
%           alpha: dual vars of SVM.
%           bias:  bias of SVM.
%           iter:  number of iterations to solve each task
%           trace: the trace of each task
%
% Code is provided by Lei Tang, July 29th, 2007.

C = param.C;

if isfield(param, 'trace_flag')
  trace_flag = param.trace_flag;
else
  trace_flag = false;
end

if isfield(param, 'trace_step')
  trace_step = param.trace_step;
else
  trace_step = 10;
end

if isfield(param, 'tolerance')
  tolerance = param.tolerance;
else
  tolerance = 10^-5;
end

%% number of instances and number of tasks
[n,k] = size(Y);

% number of kernels
p = length(G);
iter = zeros(k,1);
trace = cell(k,1);
gamma = zeros(p,k);
alpha_to_return = sparse(n, k);
bias_to_return = zeros(k,1);
for i=1:k
    [gamma(:,i), alpha_to_return(:, i), bias_to_return(i), iter(i), trace{i} ] = SILP_1norm_binary(G,Y(:,i), C, tolerance, trace_flag, trace_step);
end

clear model;
model.gamma = gamma;
model.mu = 0;
model.alpha = alpha_to_return;
model.bias = bias_to_return;
model.iter = iter;


