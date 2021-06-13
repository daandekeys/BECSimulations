% Since the center order is important, change it with this function

function[centers] = change_centerorder(centerlist, method)

n = size(centerlist,1);
centers = zeros(n,3);

if method ==1 % Turn 'linear' into 'jump'
   if mod(n,2)==1 % odd number of points
        len = (n-1)/2;
        counter = 1;
        for i = 1:len
            centers(counter,1) = centerlist(i,1);
            centers(counter,2) = centerlist(i,2);
            centers(counter,3) = centerlist(i,3);
            counter = counter + 1;
            centers(counter,1) = centerlist(n-i+1,1);
            centers(counter,2) = centerlist(n-i+1,2);
            centers(counter,3) = centerlist(n-i+1,3);
            counter = counter + 1;
        end
        centers(n,1) = centerlist(len+1,1);
        centers(n,2) = centerlist(len+1,2);
        centers(n,3) = centerlist(len+1,3);
    
    else
        len = n/2;
        counter = 1;
        for i = 1:len
            centers(counter,1) = centerlist(i,1);
            centers(counter,2) = centerlist(i,2);
            centers(counter,3) = centerlist(i,3);
            counter = counter + 1;
            centers(counter,1) = centerlist(n-i+1,1);
            centers(counter,2) = centerlist(n-i+1,2);
            centers(counter,3) = centerlist(n-i+1,3);
            counter = counter + 1;
        end
   end
   
elseif method==2 % Second, unused order that keeps jumps around half the boxsize at all times
    if mod(n,2)==1 % odd number of points
        len = (n-1)/2;
        counter = 1;
        for i = 1:len
            centers(counter,1) = centerlist(i,1); % indices start from 1
            centers(counter,2) = centerlist(i,2);
            centers(counter,3) = centerlist(i,3);
            counter = counter + 1;
            centers(counter,1) = centerlist(i+len+1,1);
            centers(counter,2) = centerlist(i+len+1,2);
            centers(counter,3) = centerlist(i+len+1,3);
            counter = counter + 1;
        end
        centers(n,1) = centerlist(len+1,1);
        centers(n,2) = centerlist(len+1,2);
        centers(n,3) = centerlist(len+1,3);
    
    else
        len = n/2;
        counter = 1;
        for i = 1:len
            centers(counter,1) = centerlist(i,1); % indices start from 1
            centers(counter,2) = centerlist(i,2);
            centers(counter,3) = centerlist(i,3);
            counter = counter + 1;
            centers(counter,1) = centerlist(i+len,1);
            centers(counter,2) = centerlist(i+len,2);
            centers(counter,3) = centerlist(i+len,3);
            counter = counter + 1;
        end
    end
       
end

end