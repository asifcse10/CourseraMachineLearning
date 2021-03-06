function [J grad] = nnCostFunction(nn_params, ...
                                   input_layer_size, ...
                                   hidden_layer_size, ...
                                   num_labels, ...
                                   X, y, lambda)
%NNCOSTFUNCTION Implements the neural network cost function for a two layer
%neural network which performs classification
%   [J grad] = NNCOSTFUNCTON(nn_params, hidden_layer_size, num_labels, ...
%   X, y, lambda) computes the cost and gradient of the neural network. The
%   parameters for the neural network are "unrolled" into the vector
%   nn_params and need to be converted back into the weight matrices. 
% 
%   The returned parameter grad should be a "unrolled" vector of the
%   partial derivatives of the neural network.
%

% Reshape nn_params back into the parameters Theta1 and Theta2, the weight matrices
% for our 2 layer neural network
Theta1 = reshape(nn_params(1:hidden_layer_size * (input_layer_size + 1)), ...
                 hidden_layer_size, (input_layer_size + 1)); % 25 X 401

Theta2 = reshape(nn_params((1 + (hidden_layer_size * (input_layer_size + 1))):end), ...
                 num_labels, (hidden_layer_size + 1));  % 10 x 26

% Setup some useful variables
m = size(X, 1);
         
% You need to return the following variables correctly 
J = 0;
Theta1_grad = zeros(size(Theta1));
Theta2_grad = zeros(size(Theta2));

% ====================== YOUR CODE HERE ======================
% Instructions: You should complete the code by working through the
%               following parts.
%
% Part 1: Feedforward the neural network and return the cost in the
%         variable J. After implementing Part 1, you can verify that your
%         cost function computation is correct by verifying the cost
%         computed in ex4.m
%
% Part 2: Implement the backpropagation algorithm to compute the gradients
%         Theta1_grad and Theta2_grad. You should return the partial derivatives of
%         the cost function with respect to Theta1 and Theta2 in Theta1_grad and
%         Theta2_grad, respectively. After implementing Part 2, you can check
%         that your implementation is correct by running checkNNGradients
%
%         Note: The vector y passed into the function is a vector of labels
%               containing values from 1..K. You need to map this vector into a 
%               binary vector of 1's and 0's to be used with the neural network
%               cost function.
%
%         Hint: We recommend implementing backpropagation using a for-loop
%               over the training examples if you are implementing it for the 
%               first time.
%
% Part 3: Implement regularization with the cost function and gradients.
%
%         Hint: You can implement this around the code for
%               backpropagation. That is, you can compute the gradients for
%               the regularization separately and then add them to Theta1_grad
%               and Theta2_grad from Part 2.
%


% Activation1
A1 = [ones(m,1) X]; % 5000x401

% Activation2
Z2 = A1 * Theta1';
A2 = sigmoid(Z2);
A2 = [ones(m,1) A2];    % 5000 X 26

% Activation3 / HTheta
Z3 = A2 * Theta2';
A3 = sigmoid(Z3);   % 5000 X 10

% if y(i) = 5, then yk(i) = [0 0 0 0 1 0 0 0 0 0]
yk = zeros(m, num_labels);  % 5000 X 10
for i=1:m
    yk(i, y(i)) = 1;
end

%Cost Function Formula
firstTerm = -yk .* log(A3);
secondTerm = (1-yk) .* log(1-A3);

Jtemp = (1/m)*sum (sum(firstTerm - secondTerm) );
J = Jtemp;

%Always remember to take Theta from the second element
theta1Sum = sum (sum (Theta1(:, 2:end).^2) );
theta2Sum = sum( sum (Theta2(:, 2:end).^2) );

J = J + lambda/(2*m)*(theta1Sum+theta2Sum); % 1x1

%% Final Backpropagation
% step 1 (output layer)
delta3 = A3 - yk; % 5000x10

% step 2 (hidden layers)
delta2 = delta3 * Theta2; % 5000x26
delta2 = (delta2 .* [ones(size(Z2,1),1) sigmoidGradient(Z2)]); % 5000x26
delta2 = delta2(:,2:end); % 5000x25

% Step 3 (Accumulative Delta Calculation)
Delta2 = delta3' * A2; %(10x26)
Delta1 = delta2' * A1; %(25x401)

% Step 4 (Gradient calculation)
% D2 = (1/m)*Delta2 + (lambda)*Theta2;
% D1 = (1/m)*Delta1 + (lambda)*Theta1;

% (CAUTION! Must not regularize the first elements of Theta)
D2 = (1/m)*Delta2 + (lambda/m)*[zeros(size(Theta2,1),1) Theta2(:,2:end)];
D1 = (1/m)*Delta1 + (lambda/m)*[zeros(size(Theta1,1),1) Theta1(:,2:end)];

Theta1_grad = D1;
Theta2_grad = D2;

%% Unroll gradients
grad = [Theta1_grad(:) ; Theta2_grad(:)];


end
