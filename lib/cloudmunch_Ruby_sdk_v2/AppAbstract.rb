#!/usr/bin/ruby
$LOAD_PATH << '.'

require_relative "CloudmunchService"
require_relative "Util"
require_relative "ServiceProvider"
require_relative "AppContext"

class AppAbstract
    include CloudmunchService
    include Util

    @@config_path = ENV["SDK_CONFIG_PATH"]+"/sdk_config.json"
    @@config = nil

    def initialize(param = nil)
        @domain, @project, @logfile = "", "", ""
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

    def getCloudmunchService()
         @cloudmunchservice = @cloudmunchservice ? @cloudmunchservice : CloudmunchService.new(@var_input)
        return @cloudmunchservice
    end 
    def openJSONFile(fileNameWithPath)
        Util.openJSONFile(fileNameWithPath)
    end

    def generateReport(reportFilename, reportString)
        Util.generateReport(reportFilename, reportString)
    end
    
    def getIntegrationDetails(param = nil)
        #@json_input = @json_input ? @json_input : getJSONArgs()
        serviceProvider = ServiceProvider.new(@json_input["providername"])
        serviceProvider.load_data(@integration_input)
        return serviceProvider
    end
    
    def getAppContext(var_input)
        
        return @appContext
    end

    def getDataContextFromCMDB(param)
        appContext = getAppContext()
        params = {
            "username" => @@config['username'],
            "customcontext" => param["job"] + "_" + param["context"],
            "action" => "listcustomcontext"
        }
        param.delete("context")
        params = param.merge(params)

        return CloudmunchService.getDataContext(appContext.get_data('masterurl'), @@config["endpoint"], params)
    end

    def updateDataContextToCMDB(param)
        appContext = getAppContext()
        params = {
            "username" => @@config['username'],
            "customcontext" => param["job"] + "_" + param["context"],
            "action" => "updatecustomcontext"
        }
        param.delete("context")
        params = param.merge(params)
        return CloudmunchService.updateDataContext(appContext.get_data('masterurl'), @@config['endpoint'], params)
    end


    def getCMContext(context)
        begin
            return @@config[context+"_context"]
        rescue
            return false
        end
    end

    def getTemplate(template_name)
        begin
            Util.getTemplate(template_name)
        rescue
            return false
        end
    end   

    def load_config()
        @@config = openJSONFile(@@config_path)
    end

    def initializeApp()
        #puts "initializeApp from AppAbstract"
    end

    def process()
        #puts "process func from AppAbstract"
    end

    def cleanupApp()
       log("INFO", "\nExiting app")
       #puts "cleanupApp from AppAbstract"
    end

    def start()
        load_config()
        initializeApp()
        process()
        cleanupApp()
    end

    private :load_config

end