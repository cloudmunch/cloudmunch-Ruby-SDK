#!/usr/bin/ruby
$LOAD_PATH << '.'

require_relative "CloudmunchService"
require_relative "InsightHelper"
require_relative "Util"
require_relative "ServiceProvider"
require_relative "AppContext"

class AppAbstract
    include CloudmunchService
    include InsightHelper
    include Util

    @@config = nil

    def initialize(param = nil)
    end

    def logInit(log_level)
        @logger = @logger ? @logger : Util.logInit()
        @log_level = log_level
    end

    def log(level,logString)
        if @logger.nil?
            logInit("DEBUG")
        end     
        Util.logIt(@logger, @log_level, level.to_s.downcase, logString)
    end


    def logClose()
        Util.logClose(@logger)
    end

    def getJSONArgs()
      jsonin = nil
      varin=nil
      integrations=nil
      loop { case ARGV[0]
          when '-jsoninput' then  ARGV.shift; jsonin = ARGV.shift
          when '-variables' then  ARGV.shift; varin = ARGV.shift
          when '-integrations' then  ARGV.shift; integrations = ARGV.shift

          when /^-/ then  usage("Unknown option: #{ARGV[0].inspect}")
          else break
      end; }
        @json_input = JSON.load(jsonin)
        @var_input =JSON.load(varin)
        @integration_input=JSON.load(integrations)
        createAppContext();
        return @json_input
    end   

    def createAppContext()
        @appContext = AppContext.new(@var_input)        
    end

    def getAppContext()
        return @appContext
    end

    # def getCloudmunchContext(context)
    #     begin
    #         return @@config[context+"_context"]
    #     rescue
    #         return false
    #     end
    # end

    def getCloudmunchService()
        @cloudmunchservice = self.extend(CloudmunchService)
        return @cloudmunchservice
    end

    def getInsightHelper()
        @insightHelper = self.extend(InsightHelper)
        return @insightHelper
    end 
    
    def getIntegrationDetails(param = nil)
        serviceProvider = ServiceProvider.new(@json_input["providername"])
        serviceProvider.load_data(@integration_input)
        return serviceProvider
    end

    def initializeApp()
    end

    def process()
    end

    def cleanupApp()
       log("INFO", "\nExiting app")
    end

    def start()
        initializeApp()
        process()
        cleanupApp()
    end

    # def openJSONFile(fileNameWithPath)
    #     Util.openJSONFile(fileNameWithPath)
    # end  

    # def generateReport(reportFilename, reportString)
    #     Util.generateReport(reportFilename, reportString)
    # end

    # def getDataContextFromCMDB(param)
    #     appContext = getAppContext()
    #     params = {
    #         "username" => @@config['username'],
    #         "customcontext" => param["job"] + "_" + param["context"],
    #         "action" => "listcustomcontext"
    #     }
    #     param.delete("context")
    #     params = param.merge(params)

    #     return CloudmunchService.getDataContext(appContext.get_data('masterurl'), @@config["endpoint"], params)
    # end

    # def updateDataContextToCMDB(param)
    #     appContext = getAppContext()
    #     params = {
    #         "username" => @@config['username'],
    #         "customcontext" => param["job"] + "_" + param["context"],
    #         "action" => "updatecustomcontext"
    #     }
    #     param.delete("context")
    #     params = param.merge(params)
    #     return CloudmunchService.updateDataContext(appContext.get_data('masterurl'), @@config['endpoint'], params)
    # end
   
    # def getTemplate(template_name)
    #     begin
    #         Util.getTemplate(template_name)
    #     rescue
    #         return false
    #     end
    # end   
    

end
