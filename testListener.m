classdef testListener < handle
    
    properties (Access = public)
        
        dummyVar
        
    end
    
    methods
        
        function p = testListener()
            p.dummyVar = 1;
        end
        
        function p = handleMoved(p,src,eventdata)
            fprintf('hi\n');
        end
    end
end
