

class ServiceProvider

    def initialize(providername)
        @providername = providername
    end

    def load_data(param)
    	if param[@providername].nil?
    		return nil
    	else
    		@SP_data = param[@providername]["configuration"]
        end
    end     

    def get_data(keyname)
        if @SP_data.nil?
    		return nil
    	else
	        @SP_data[keyname] 
        end
    end     

end