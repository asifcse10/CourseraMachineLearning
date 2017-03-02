function [theta, J_history] = gradientDescent(X, y, theta, alpha, num_iters)
%GRADIENTDESCENT Performs gradient descent to learn theta
%   theta = GRADIENTDESCENT(X, y, theta, alpha, num_iters) updates theta by 
%   taking num_iters gradient steps with learning rate alpha

% Initialize some useful values
m = length(y); % number of training examples
J_history = zeros(num_iters, 1);

for iter = 1:num_iters

    % ====================== YOUR CODE HERE ======================
    % Instructions: Perform a single gradient step on the parameter vector
    %               theta. 
    %
    % Hint: While debugging, it can be useful to print out the values
    %       of the cost function (computeCost) and gradient here.
    %

    
    % loop method implementation
%     num_of_theta = length(theta);
%     
%     for j = 1:num_of_theta
%         sum=0;
%         for i = 1:m
%             sum = sum + ( (X(i,:)*theta)-y(i) )*X(i,j);
%         end
%         theta(j) = theta(j) - (alpha/m*sum);
%     end
    % end of loop method implementation
    
    delta = (X*theta)-y;    % (97x2)x(2x1) = (97x1)
    delta = (delta'*X);     % (1x97)x(97x2) = (1x2)
    delta = delta';         % (1x2)' = (2x1)
    theta = theta - (alpha/m)*delta;   % (2x1)
    
    % ============================================================

    % Save the cost J in every iteration    
    J_history(iter) = computeCost(X, y, theta);

end

end
