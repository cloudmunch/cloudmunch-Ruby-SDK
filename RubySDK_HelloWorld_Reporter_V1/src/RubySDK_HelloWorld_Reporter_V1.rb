require 'rubygems'
require 'bundler/setup'
require 'cloudmunch_sdk'
require "date"

class RubySDKHelloWorldReporterV1App < AppAbstract

    def initializeApp()
        json_input = getJSONArgs()
        appContext = getAppContext(json_input)
        
        @domain = appContext.get_data('domain')
        @project = appContext.get_data('project')
        @jobname = json_input['loader_jobname']
        @viewcardTitle = json_input['viewcard_title']

        @reportfile = json_input['reporthtml']
        @log_level = json_input['log_level']

        logInit(@log_level)
        log("info", __method__.to_s + " method is invoked from RubySDKHelloWorldReporterV1App")
    end

    def process()
        log("info", __method__.to_s + " method from RubySDKHelloWorldReporterV1App")
        parsed_json = getDataForViewcard()
        final = constructViewcard(parsed_json)
        p final.to_json
        log("info", final.to_json)
        generateReport(@reportfile, final.to_json)        
    end

    def getDataForViewcard()
        log("info", __method__.to_s + " method from RubySDKHelloWorldReporterV1App")
        #@curr_date = Time.now.strftime('%Y-%m-%d')

        @filter_str =  '"id"' + ":" + '"messageid"'
        @filter_str = '{'+@filter_str+'}'

        params = {
            "domain" => @domain,
            "project" => @project,
            "action" => 'listcustomcontext',
            "job" => @jobname,
            "context" => "greeting",
            "fields" => 'result,id',
            "filter" => @filter_str,
            "count" => '*'
        }

        parsed_json = getDataContextFromCMDB(params)
        parsed_json = JSON.parse(parsed_json)

        return parsed_json
    end

    def constructViewcard(parsed_json)
        log("info", __method__.to_s + " method from RubySDKHelloWorldReporterV1App")  

        parsed_hash = parsed_json[0] 
        result_str = parsed_hash["result"] 

        result_arr = JSON.parse(result_str)

        result_hash = {}
        result_hash["From"] = result_arr["from"]
        result_hash["To"] = result_arr["to"]
        result_hash["Message"] = result_arr["message"]
        result_hash["Time"] = result_arr["time"]
    
        data = []
        data.push( result_hash )
        
        final = {} 
        final['data'] = viewcardDataFor("greetingmessage", data)

        viewcard_meta_info = {}
        viewcard_meta_info["viewcardType"] = "kanban"
        viewcard_meta_info["viewcardTitle"] = @viewcardTitle
        viewcard_meta_info["viewcardLabelColor"] = "grey"
        viewcard_meta_info["viewcardDataSource"] = "CMDB"
        viewcard_meta_info["viewcardXAxisLabel"] = ""
        viewcard_meta_info["viewcardYAxisLabel"] = ""
        viewcard_meta_info["viewcardXAxisColor"] = "black"
        viewcard_meta_info["viewcardYAxisColor"] = "black"

        final['meta'] = viewcardMetaFor("greetingmessage", viewcard_meta_info)
        return final
    end

    def viewcardDataFor(viewcardNameStr, viewcardData)
        log("info", __method__.to_s + " method from RubySDKHelloWorldReporterV1App")
        data = {}
        data[viewcardNameStr] = {"data":viewcardData}
        return data
    end

    def viewcardMetaFor(viewcardNameStr, viewcardMetaInfo)
        log("info", __method__.to_s + " method from RubySDKHelloWorldReporterV1App")

        # meta = {"url":"", 
        #     "name":{"label": viewcardMetaInfo["viewcardTitle"], "color":"black", "x":40, "y":10},
        #     "date":Time.now.strftime('%b %d %Y'), "source": viewcardMetaInfo["viewcardDataSource"],
        #     "cards":{viewcardNameStr : {"type":"kanban"}}, 
        #     "dimensions":{"width":410, "height":320}}

        cards = {}
        cards[viewcardNameStr] = {"type":"kanban"}
        meta = {"url":"", 
            "name":{"label": viewcardMetaInfo["viewcardTitle"], "color":"black", "x":40, "y":10},
            "date":Time.now.strftime('%b %d %Y'), "source": viewcardMetaInfo["viewcardDataSource"],
            "dimensions":{"width":410, "height":320}}

        meta["cards"] = cards
        return meta
    end

    def cleanupApp()
        log("info", __method__.to_s + " method is invoked from RubySDKHelloWorldReporterV1App")
        logClose()
    end

end

helloWorldReporterV1View = RubySDKHelloWorldReporterV1App.new()
helloWorldReporterV1View.start()
