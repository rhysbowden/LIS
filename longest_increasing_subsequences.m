% find all longest increasing (actually non-decreasing) subsequences of a 
% sequence and the intersection of all these longest increasing subsequences
function intersection_heights = longest_increasing_subsequences(seq)
    % do a forward pass as per usual algorithm to find a longest 
    % increasing subsequence
    % (https://en.wikipedia.org/wiki/Longest_increasing_subsequence)
    % but keep extra information (every element of initial sequence is in
    % the set of valid tails when it is introduced, it also has a unique 
    % height). Store all elements at each given height, sorted by value
    % (which also means they will be sorted by index, but in reverse
    % order).
    
    % tails: tails(i) is an array with all elements of height i (height is 
    % the number of elements in the longest increasing sequence that ends 
    % at that element, stored as (index,value) pairs, sorted by index or 
    % value (both ways are equivalent). Ideally should be an efficient
    % data structure for sorted data, like a binary tree, but in practice
    % the array for each height is small on average.
    tails = cell(1,numel(seq));
    tails{1} = [1,seq(1)];
    % best_tails(i) is the element with lowest value at height i, at any
    % stage of the process. Convenient way to refer to tails{1,i}(1).
    % It is preallocated at larger than necessary, but for current 
    % application this is fine.
    best_tail_value = zeros(1,numel(seq));
    best_tail_index = zeros(1,numel(seq));
    best_tail_value(1) = seq(1);
    best_tail_index(1) = 1;
    height = 1;% the maximum length of any subsequence so far
    
    % predecessors. list of a valid predecessor of each element of tails,
    % not definitely necessary. Efficiently it would be a link to the range
    % of valid predecessors in the data structure, in practice it is not 
    % required to be.
    %predecessors = zeroes(1,numel(seq));
    % heights(i) - height of the ith element in the original sequence.
    heights = zeros(1,numel(seq));
    
    for i = 2:numel(seq)
       % Find the tail at the greatest height that has value <= the value 
       % at the current index, seq(i). The current height is one greater 
       % than that height, since the new tail adds at the end of that 
       % sequence.
       cheight = myBinSearch2(best_tail_value(1:height),seq(i))+1;
       if(numel(cheight)==0)
           cheight=1;
       end
       height = max(height,cheight);
       heights(i) = cheight;
       %predecessors(i,:) = [cheight best_tale_index(cheight) best_tale_value(cheight)]; % 3rd element maybe redundant
       if(cheight>numel(tails))
           tails{cheight} = [i seq(i)];
       else
           tails{cheight} = [i seq(i); tails{cheight}]; % smallest value, highest index at top of list
       end
       best_tail_value(cheight) = seq(i);
       best_tail_index(cheight) = i;
    end
    
    % do a backwards pass to find intersection of all longest increasing
    % subsequences.
    % intersection_heights(i)=the height of the ith element of the sequence
    % if seq(i) is in the intersection of all the shortest increasing 
    % subsequences; 0 otherwise
    % That is, intersection_heights>0 is the logical vector corresponding
    % to which elements of seq are in all longest increasing subsequences
    intersection_heights = zeros(1,numel(seq));
    valid_tails = tails{height}; % keeps track of the valid tails at the current height
    if(size(valid_tails,1)==1)
        intersection_heights(valid_tails(1,1)) = height;
    end
    % loop through, elements are in one of the 
    % longest increasing subsequences iff they can be a predecessor to a 
    % valid element (or they're at the maximum height). An element is in
    % the intersection of all the longest increasing subsequences iff it is
    % the only one at its height.
    for cheight = (height-1):-1:1 
        ctails = tails{cheight};
        valid_inds = zeros(size(ctails,1),1);
        for i=1:size(ctails,1)
            % to be a precedecessor index must be smaller and value must be 
            % smaller - a better order of complexity method would be to bin
            % search on both (since tails{i} is ordered in both 
            % simultaneously), but no point for our application, since both
            % lists will always be small.
            valid_inds(i) = any((ctails(i,1)<valid_tails(:,1))&(ctails(i,2)<=valid_tails(:,2)));
        end
        valid_tails = ctails(valid_inds>0,:);
        if(size(valid_tails,1)==1)
            intersection_heights(valid_tails(1,1)) = cheight;
        end
    end
end