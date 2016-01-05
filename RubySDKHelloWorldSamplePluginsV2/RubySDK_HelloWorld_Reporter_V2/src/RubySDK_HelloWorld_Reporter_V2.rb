require 'rubygems'
require 'bundler/setup'
require 'cloudmunch_sdk'
require "date"

class RubySDKHelloWorldReporterV2App < AppAbstract

    def initializeApp()
        json_input = getJSONArgs()
        @cmInsightHelper = getInsightHelper()
        
        @insightID       = json_input['insight_id']
        @viewcardTitle   = json_input['viewcard_title']
        @pluginDescription = json_input["description"]
        @reportCardName  = "HelloWorld-Ruby-SDK-V2-Sample-Plugin"   
        @log_level = !json_input['log_level'].nil? ? json_input['log_level'] : "INFO"
        logCategoryArray = ["debug", "warning", "info", "error", "fatal"]
        if !logCategoryArray.include? (@log_level.downcase) then
            @log_level = "info"
        end

        @reportID        = checkForNil(@cmInsightHelper.createInsightReport(@insightID, Time.now.strftime("%Y-%m-%d")))

        @greetingMessageExtract = "greetingMessage"
        @dataStoreName = "helloWorldRubyPluginV2"    

        logInit(@log_level)
        log("info", __method__.to_s + " method is invoked from RubySDKHelloWorldReporterV2App")
    end

    def process()
        log("info", __method__.to_s + " method from RubySDKHelloWorldReporterV2App")
        result = getDataForViewcard()
        data   = constructViewcard(result)
        
        @reportCardID = checkForNil(@cmInsightHelper.createInsightReportCard(@insightID, @reportID, @reportCardName))
        response      = checkForNil(@cmInsightHelper.updateInsightReportCard(@insightID, @reportID, @reportCardID, data))       
    end

    def getDataForViewcard()
        log("info", __method__.to_s + " method from RubySDKHelloWorldReporterV2App")

        @filterStr =  '"id"' + ":" + '"' + @greetingMessageExtract + '"'
        @filterStr = '{'+@filterStr+'}'

        @dataStoreID = checkForNil(@cmInsightHelper.getDataStoreID(@insightID, @dataStoreName))

        paramHash = {}
        paramHash["fields"] = 'result,id'
        paramHash["filter"] = @filterStr
        paramHash["insightID"]   = @insightID
        paramHash["dataStoreID"] = @dataStoreID

        response = checkForNil(@cmInsightHelper.getInsightDataStoreExtracts(paramHash))
        log("DEBUG", "Extracts : ")
        log("DEBUG", response)

        return response
    end

    def constructViewcard(parsed_hash)
        log("info", __method__.to_s + " method from InsightsGitHubOrganizationReposByCommitsApp")  

        p parsed_hash
        result = parsed_hash[0]["result"] 

        result_arr = result.to_a

        result_hash = {}
        result_arr.each do |arrElem|
            result_hash[arrElem[0]] = arrElem[1]
        end
    
        data = []
        final = {} 
        data.push( result_hash )

        viewcard_meta_info = {}
        viewcard_meta_info["viewcardTitle"] = @viewcardTitle
        viewcard_meta_info["default"] = "kanban"
        viewcard_meta_info["url"] = ""
        viewcard_meta_info["date"] = Time.now.strftime("%Y-%m-%d")
        viewcard_meta_info["label"] = @viewcardTitle
        viewcard_meta_info["source"] = ""
        viewcard_meta_info["group"] = ""
        viewcard_meta_info["description"] = @pluginDescription
        viewcard_meta_info["graphType"] = "kanban"

        final['data'] = data
        final['visualization_map'] = constructViewcardVisualizationMeta()
        final['card_meta'] = constructViewcardMeta(viewcard_meta_info)

        data = {}
        data["data"] = final  
        return data
    end

    def constructViewcardVisualizationMeta()
        log("info", __method__.to_s + " method from InsightsGitHubOrganizationReposByCommitsApp")

        visualization_map = { "cards" => { "type" => "kanban" } } 
        return visualization_map
    end

    def constructViewcardMeta(viewcardMetaInfo)
        log("info", __method__.to_s + " method from InsightsGitHubOrganizationReposByCommitsApp")

        card_meta = { 
                        "default" => viewcardMetaInfo["default"], 
                        "url"     => viewcardMetaInfo["url"], 
                        "date"    => viewcardMetaInfo["date"], 
                        "label"   => viewcardMetaInfo["label"], 
                        "source"  => viewcardMetaInfo["source"], 
                        "group"   => viewcardMetaInfo["group"],
                        "description"   => viewcardMetaInfo["description"],
                        "visualization_options" => [ viewcardMetaInfo["graphType"] ],
                        "xaxis"   => {"label" => viewcardMetaInfo["xAxisLabel"]},
                        "yaxis"   => {"label" => viewcardMetaInfo["yAxisLabel"]},
                    }

        return card_meta
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

    def cleanupApp()
        log("info", __method__.to_s + " method is invoked from RubySDKHelloWorldReporterV2App")
        logClose()
    end

end

helloWorldReporterV2View = RubySDKHelloWorldReporterV2App.new()
helloWorldReporterV2View.start()
