

class AppContext

    def initialize(param)
       load_data(param) 
    end

    def load_data(param)
        @AppContextParams = param
    end     

    def get_data(keyname)
        @AppContextParams[keyname] 
    end     

end