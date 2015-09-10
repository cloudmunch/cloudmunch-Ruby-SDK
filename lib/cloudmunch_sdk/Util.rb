#!/usr/bin/ruby
require 'logger'
require 'json'



module Util
    def Util.logInit()
        logger = Logger.new(STDOUT)
        logger.formatter = proc do |severity, datetime, progname, msg|
             "#{severity}: #{msg}\n"
        end
        return logger
    end

    def Util.log(logger, level, logString)
        case level
        when "debug"
            logger.debug(logString)
        when "fatal"
            logger.fatal(logString)
        when "error"
            logger.error(logString)
        when "warn"
            logger.warn(logString)
        when "info"
            logger.info(logString)        
        else
            logger.unknown(logString)
        end
    end

  def Util.logIt(logger, log_level, log_level_string, messageString)   
        case log_level.downcase       
        when "debug"
            if "debug".eql? log_level_string or "fatal".eql? log_level_string or "error".eql? log_level_string or "warn".eql? log_level_string or "info".eql? log_level_string                 
                log(logger, "debug", messageString)
            end
        when "fatal"
            if "fatal".eql? log_level_string
                log(logger, "fatal", messageString)
            end
        when "error"
            if "error".eql? log_level_string
                log(logger, "error", messageString)
            end        
        when "warn"
            if "warn".eql? log_level_string
                log(logger, "warn", messageString)
            end
        when "info"
            if "info".eql? log_level_string
                log(logger, "info", messageString)
            end
        else
            log(logger, "unknown", messageString)
        end
  end

    def Util.logClose(logger)
        logger.close
    end


   def Util.getJSONArgsTEMP(jsonString)
      JSON.parse(jsonString)
   end

   def Util.getJSONArgs()
      jsonin = nil
      loop { case ARGV[0]
          when '-jsoninput' then  ARGV.shift; jsonin = ARGV.shift
          when /^-/ then  usage("Unknown option: #{ARGV[0].inspect}")
          else break
      end; }
      return JSON.load(jsonin); 
   end

   def Util.openJSONFile(fileNameWithPath)
      begin
        config = JSON.load(File.open(fileNameWithPath))
        return config
      rescue
         return false
      end
   end
   
   def Util.generateReport(reportFileName, reportContent)
      begin
        fp=File.new(reportFileName, 'w')
        fp.write(reportContent)
        fp.close
        return true
      rescue
        puts("ERROR: Could not open output file. Framework error!")
        # exit 1
        return false
      end
   end
   
    def Util.getUrlForViewCards(server, endpoint, params)
        newParam = {
            :action => "listcustomcontext",
            :fields => "*",
        }

        newParam = params.merge(newParam)
        cqlQuery = CloudmunchService.getDataContext(server, endpoint, newParam)
        cqlQuery = JSON.parse(cqlQuery)
        if !cqlQuery[0].nil? && !cqlQuery[0]["url"].nil?
            url = cqlQuery[0]["url"]
        else
            url = ""
        end

        return url
    end

    def Util.getTemplate(template_name)
      openJSONFile(File.dirname(__FILE__) +"/templates/#{template_name}.json")
    end   
    
end

