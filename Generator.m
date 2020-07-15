function [Test_Pattern]=Generator(Test_set,N)

Test_Pattern=rand(Test_set,N); % generate random training patterns. rand(N) returns uniformly distributed values between 0 and 1
Test_Pattern=Test_Pattern(:,:)>=0.5; % extracting all the numbers that are greater or equal to 0.5. This returns a logical matrix
Test_Pattern=mat2gray(Test_Pattern); % convert the logical matrix to double 
Test_Pattern=Replace(Test_Pattern, 0, -1);
Test_Pattern=unique(Test_Pattern, 'rows');

end

