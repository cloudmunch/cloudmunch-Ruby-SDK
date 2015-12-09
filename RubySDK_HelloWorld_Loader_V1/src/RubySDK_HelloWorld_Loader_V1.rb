require "bundler/setup"
require "rubygems"
require "cloudmunch_sdk"
require "date"

class RubySDKHelloWorldLoaderV1App < AppAbstract

    def initializeApp()
        json_input = getJSONArgs()

        @jobname = json_input['loader_jobname']

        @greetingFrom = json_input['greeting_from']
        @greetingTo = json_input['greeting_to']
        @greetingMessage = json_input['greeting_message']
        @greetingTime = Time.now.strftime("%H:%M:%S")

        @log_level = json_input['log_level'] 

        appContext = getAppContext(json_input)
        @domain = appContext.get_data('domain')
        @project = appContext.get_data('project')
        @greetingContext = "greeting"

        
  
        logInit(@log_level)
        log("info", "initializeApp is invoked in RubySDKHelloWorldLoaderV1 App")

    end

    def process()
        log("info", "process is invoked in RubySDKHelloWorldLoaderV1 App")

        greetingParam = Hash.new 
        greetingParam["message"] = @greetingMessage
        greetingParam["from"] = @greetingFrom
        greetingParam["to"] = @greetingTo
        greetingParam["time"] = @greetingTime

        finalDataFormat = {}
        finalDataFormat["result"] = greetingParam.to_json

        log("debug", finalDataFormat.to_json)
        saveGreetingMessage(finalDataFormat.to_json)
    end  

    def saveGreetingMessage(message)
        log("info", "saveGreetingMessage is invoked in RubySDKHelloWorldLoaderV1 App")
        log("debug", message)
        # the result_array needs to be stored into CMDB
        @id = "messageid"
        log("info", "Updating cmdb with greeting message: id:"+@id) 

        data_pack = {
            "domain" => @domain,
            "project" => @project,
            "job" => @jobname,
            "context" => @greetingContext,
            "id" => @id,
            "data" => message
        }
        #pass the filled in hash object to the following method
        updateDataContextToCMDB(data_pack) 
        log("info", "Updated cmdb with greeting message: id:"+@id)  
    end 

    def cleanupApp()
        log("info", "cleanupApp is invoked in RubySDKHelloWorldLoaderV1 App")
        logClose()
    end


end

helloWorldLoader = RubySDKHelloWorldLoaderV1App.new()
helloWorldLoader.start()
