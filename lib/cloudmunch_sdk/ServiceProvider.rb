

class ServiceProvider

    def initialize(providername)
        @providername = providername
    end

    def load_data(param)
    	
    	$integrations->$provname->$conf
        @SP_data = JSON.parse(param[@providername])["configuration"]
    end     

    def get_data(keyname)
        @SP_data[keyname] 
    end     

end