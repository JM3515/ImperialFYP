function cuffP = loadPresFile(file)

a = load(file);

cuffP = [a(1,:),a(2,:)];
cuffP(1:23) = 0; % set first values to 0 rather than initial spike 

s = 341;

for i = 1:31
    
   
    
    if s == 341
        cuffP(s:s+50) = mean(cuffP(s:s+50));
        s = s + 50;
    else
        s = s+5;
        
        cuffP(s:s+50) = mean(cuffP(s:s+50));
        s = s+50;
    
    end 
    
end
