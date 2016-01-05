require "bundler/setup"
require "rubygems"
require "cloudmunch_sdk"
require "date"
require "json"

class RubySDKHelloWorldLoaderV2App < AppAbstract

    def initializeApp()       
        json_input = getJSONArgs()
        @cmInsightHelper = getInsightHelper()

        @insightID = json_input['insight_id'].nil? ? exitWithMessage("error", "Insight id not provided!") : json_input['insight_id']
        @greetingFrom = json_input['greeting_from'].nil? ? exitWithMessage("error", "greeting_from is not provided!") : json_input['greeting_from']
        @greetingTo = json_input['greeting_to'].nil? ? exitWithMessage("error", "greeting_to not provided!") : json_input['greeting_to']
        @greeting_message = json_input['greeting_message'].nil? ? exitWithMessage("error", "greeting_message not provided!") : json_input['greeting_message']
        @greetingTime = Time.now.strftime("%H:%M:%S")

        @log_level = !json_input['log_level'].nil? ? json_input['log_level'] : "INFO"
        logCategoryArray = ["debug", "warning", "info", "error", "fatal"]
        if !logCategoryArray.include? (@log_level.downcase) then
            @log_level = "info"
        end

        @greetingParam = Hash.new 
        @greetingParam["message"] = @greetingMessage
        @greetingParam["from"] = @greetingFrom
        @greetingParam["to"] = @greetingTo
        @greetingParam["time"] = @greetingTime
        
        logInit(@log_level)
        log("info", __method__.to_s +  "initializeApp is invoked in RubySDKHelloWorldLoaderV2 App")
        log("debug", @greetingParam.to_s)      
    end

    def process()
        log("info", "process is invoked in RubySDKHelloWorldLoaderV2 App")
        saveGreetingMessage(@greetingParam)
    end  

    def saveGreetingMessage(paramHash)
        log("info", "saveGreetingMessage is invoked in RubySDKHelloWorldLoaderV2 App")
        log("debug", paramHash.to_s)
       
        @id = "greetingMessage"
        @helloWorldRubyPluginV2Context = "helloWorldRubyPluginV2"
        log("info", "Updating cmdb with greeting message: id:"+@id) 

        wrapperHash = {}
        wrapperHash["result"] = paramHash
        puts wrapper_hash
        log("debug", wrapperHash.to_s)

        #pass the filled in hash object to the following method
        save_data(@helloWorldRubyPluginV2Context, @id, wrapperHash)
    end 

    def save_data(dataStoreName, extractName, data)
        log("info", __method__.to_s + " is invoked in RubySDKHelloWorldLoaderV2 App")
        log("debug", data)
        log("info", "Updating cmdb with extract Name:"+extractName) 
        log("debug", @insightID+" : "+dataStoreName)
        dataStoreID = nil
        dataStoreID = @cmInsightHelper.createInsightDataStore(@insightID, dataStoreName)
        log("debug", "dataStoreID : "+dataStoreID)
        extractID = nil
        extractID   = @cmInsightHelper.createInsightDataStoreExtract(@insightID, dataStoreID, extractName)
        log("debug", "extractID : "+extractID)
        response    = @cmInsightHelper.updateInsightDataStoreExtract(@insightID, dataStoreID, extractID, data)  
    end 

    def cleanupApp()
        log("info", "cleanupApp is invoked in RubySDKHelloWorldLoaderV1 App")
        logClose()
    end

    def checkForNil(response)
        if(response.nil?)
            log("debug","Empty response recieved!")
            exitWithMessage("ERROR", "Action on cloudmunch data base returned empty! refer log for more details")
        end
        return response
    end

    def exitWithMessage(msgType, msg)
        log(msgType, msg)
        exit 1
    end


end

helloWorldLoader = RubySDKHelloWorldLoaderV2App.new()
helloWorldLoader.start()
