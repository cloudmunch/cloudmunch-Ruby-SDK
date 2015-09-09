

class ServiceProvider

    def initialize(providername)
        @providername = providername
    end

    def load_data(param)
        @SP_data = JSON.parse(param["cloudproviders"])[@providername]
    end     

    def get_data(keyname)
        @SP_data[keyname] 
    end     

end