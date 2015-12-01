require "bundler/setup"
require "rubygems"
require "cloudmunch_sdk"
require "date"

class RubySDKHelloWorldPluginApp < AppAbstract

    def initializeApp()
        json_input = getJSONArgs()

       # @jobname = json_input['loader_jobname']
        @greeting_message = json_input['greeting_param']
        @log_level = json_input['log_level'] 

        
        @greetingContext = "greeting"
        
        logInit(@log_level)
        log("info", "initializeApp is invoked in RubySDK_HelloWorld_plugin App")     
    end

    def process()
        log("info", "process is invoked in RubySDK_HelloWorld_plugin App")
        #saveGreetingMessage(@greeting_param.to_json)
        log("info","Hello "+ @greeting_message )
    end  

    def saveGreetingMessage(message)
        log("info", "saveGreetingMessage is invoked in RubySDK_HelloWorld_plugin App")
        log("debug", message)
        # the result_array needs to be stored into CMDB
        # updateCustomContext()
       # @id = "messageid"
        log("info", "Updating cmdb with exceldata: id:"+@id) 
       
        data_pack = {
            
            "data" => message
        }
        #pass the filled in hash object to the following method
         cms= getCloudmunchService()
        cms.updateCloudmunchData(@greetingContext,@id,data_pack) 
    end 

    def cleanupApp()
        log("info", "cleanupApp is invoked in RubySDK_HelloWorld_plugin App")
        logClose()
    end


end

helloWorldPlugin = RubySDKHelloWorldPluginApp.new()
helloWorldPlugin.start()
