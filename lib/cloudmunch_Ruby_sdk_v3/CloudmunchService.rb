#!/usr/bin/ruby

require 'net/http'
require 'cgi'
require 'json'

require_relative "Util"

module CloudmunchService
  include Util  

  ##################################################################################
  ###
  ### downloadKeys(filekey, context, contextid)
  ### getResource(type)
  ### deleteKeys()
  ### getCloudmunchData(paramHash)
  ### updateCloudmunchData(paramHash, method = "POST") 
  ### deleteCloudmunchData(paramHash)
  ### parseResponse(responseJson)
  ### generateServerURL(paramHash, appendQueryParams = nil)
  ###
  ###
  ################################################################################## 

  ###################################################################################
  #### getResource(type)
  #### Return resources available for a given type
  ###################################################################################
  def getResource(type)
    if !type.nil?
      paramHash = Hash.new
      paramHash["context"] = "resources"
      paramHash["filter"] = {"type" => type}
      paramHash["fields"] = "*"

      resource = getCloudmunchData(paramHash)

      if resource.nil?
        log("DEBUG", "Unable to retrieve resource for this type")
        return nil
      else
        return resource
      end
    else
      log("DEBUG", "Type needs to be provided to retrieve resource!")
      return nil
    end
  end

    def getIntegrationWithID(integrationID)
      if !integrationID.nil?
        paramHash = Hash.new
        paramHash["context"] = "integrations"
        paramHash["contextID"] = integrationID

        integration = getCloudmunchData(paramHash)

        log("DEBUG",integration)
        if integration.nil?
          return nil
        else
          if integration["configuration"]
              return integration["configuration"]
          else
              return nil
          end
        end
      else
        return nil
      end        
  end


  def downloadKeys(filekey, context, contextid)

    paramHash = Hash.new
    paramHash["context"]     = context
    paramHash["contextID"]   = contextid
    paramHash["file"]        = filekey

    keyString = getCloudmunchData(paramHash)
    
    if !keyString.to_s == ""
      log("ERROR", "downloaded key content is empty, please re-upload key and try")
      return nil
    end
    
    filename = "keyfile_" + Time.now.strftime('%Y%m%d%H%M%S%L')
    file     = @appContext.get_data("{workspace}")+"/"+filename
    
    File.open(file, 'w') { |file| file.write(keyString) }
    system('chmod 400 '+file)
    
    if @keyArray.nil?
      @keyArray = []
    end

    @keyArray.push(file)
    return file;
  end

  def deleteKeys()
    fileName = @appContext.get_data("{workspace}")+"/keyfile_*"
    File.delete(fileName)
  end

  def getCloudmunchData(paramHash)
    serverurl = nil
    serverurl = generateServerURL(paramHash,true)

    if serverurl.nil?
        log("DEBUG", "Unable to generate server url")
        log("ERROR", "Unable to get data from cloudmunch")    
        return nil
    end

    uri = URI.parse(serverurl)              
    
    responseJson = Net::HTTP.get(uri)
    
    parseResponse(responseJson)
  end

  def updateCloudmunchData(paramHash, method = "POST") 
      paramData = Hash.new
      paramData["data"] = paramHash["data"]
      
      serverurl = nil
      serverurl = generateServerURL(paramHash)

      if serverurl.nil?
          log("DEBUG", "Unable to generate server url")
          log("ERROR", "Unable to "+method+" data on cloudmunch")    
          return nil
      end

      uri = URI.parse(serverurl)                      
      
      if method.casecmp("post") == 0
        responseJson = Net::HTTP.post_form(uri,"data" => paramData.to_json)
      elsif method.casecmp("patch") == 0
        paramData["method"] = "patch"
        responseJson = Net::HTTP.post_form(uri,"data" => paramData.to_json)
      elsif method.casecmp("put") == 0
        #code for put
      end
      return parseResponse(responseJson.body)      
  end

  def deleteCloudmunchData(paramHash)
    paramContext = paramHash["context"]
    paramContextID = paramHash["contextID"]

    if !paramContext.nil? && !paramContext.empty? && !paramContextID.nil? && !paramContextID.empty?
        serverurl=@appContext.get_data("{master_url}")+"/applications/"+@appContext.get_data("{application}")+"/"+context+"/"+contextID;
        serverurl=serverurl+"?apikey="+@appContext.get_data("{api_key}")
        uri = URI.parse(serverurl)
        Net::HTTP::Delete(uri)
        return 1
    else
        return nil
    end
  end 

  def parseResponse(responseJson)
    begin
        JSON.parse(responseJson)
    rescue
        return responseJson
    end

    requestDetails = (JSON.load(responseJson))['request']
    responseData   = (JSON.load(responseJson))['data']

    log("DEBUG", "Response : ")
    log("DEBUG", responseJson)
    
    if !requestDetails['status'].nil? && requestDetails['status'].casecmp('success') == 0    
        return responseData
    else
        if !requestDetails['message'].nil?
          log("ERROR", requestDetails['message'])
        end
        if !requestDetails['request_id'].nil?
          log("ERROR", "Request ID : "+requestDetails['request_id'])
        end
        return nil
    end
  end

  

  def generateServerURL(paramHash, appendQueryParams = nil)

    serverurl = ""
    
    if !paramHash["url"].nil?
        serverurl = @appContext.get_data("{master_url}")+"/"+paramHash["url"]
    elsif !paramHash["context"].nil?
        paramContext       = paramHash["context"].nil? ? nil : paramHash["context"]
        paramContextID     = paramHash["contextID"].nil? ? nil : paramHash["contextID"]
        paramSubContext    = paramHash["subContext"].nil? ? nil : paramHash["subContext"]
        paramSubContextID  = paramHash["subContextID"].nil? ? nil : paramHash["subContextID"]
        paramLeafContext   = paramHash["leafContext"].nil? ? nil : paramHash["leafContext"]
        paramLeafContextID = paramHash["leafContextID"].nil? ? nil : paramHash["leafContextID"]

        serverurl=@appContext.get_data("{master_url}")+"/applications/"+@appContext.get_data("{application}")+"/"+paramContext

        if !paramContextID.nil? && !paramContextID.empty?
            serverurl=serverurl+"/"+paramContextID;
            if !paramSubContext.nil? && !paramSubContext.empty?
                serverurl=serverurl+"/"+paramSubContext;              
                if !paramSubContextID.nil? && !paramSubContextID.empty?
                    serverurl=serverurl+"/"+paramSubContextID;
                    if !paramLeafContext.nil? && !paramLeafContext.empty?
                        serverurl=serverurl+"/"+paramLeafContext;
                        if !paramLeafContextID.nil? && !paramLeafContextID.empty?
                            serverurl=serverurl+"/"+paramLeafContextID;
                        end
                    end
                end
            end
        end
    else
        log("DEBUG", "No context provided for get api call");
        return nil
    end

    queryString = ""
    
    if !appendQueryParams.nil?
      queryString = queryString + "action=" + paramHash["action"].to_s + "&" if !paramHash["action"].nil?
      queryString = queryString + "filter=" + paramHash["filter"].to_json + "&" if !paramHash["filter"].nil?
      queryString = queryString + "file="   + paramHash["file"].to_s      + "&" if !paramHash["file"].nil?
      queryString = queryString + "fields=" + paramHash["fields"].to_s    + "&" if !paramHash["fields"].nil?
      queryString = queryString + "count="  + paramHash["count"].to_s     + "&" if !paramHash["count"].nil?
      queryString = queryString + "offset=" + paramHash["offset"].to_s    + "&" if !paramHash["offset"].nil?
      queryString = queryString + "request_category=" + paramHash["requestCategory"].to_s + "&" if !paramHash["requestCategory"].nil?
      queryString = queryString + "order_by=" + paramHash["orderBy"].to_s + "&" if !paramHash["orderBy"].nil?
      queryString = queryString + "group_by=" + paramHash["groupBy"].to_s + "&" if !paramHash["groupBy"].nil?
    end

    serverUrlWithoutApiKey = serverurl+"?"+queryString
    log("DEBUG", "Url :: #{serverUrlWithoutApiKey}")

    serverurl = serverurl+"?"+queryString+"apikey="+@appContext.get_data("{api_key}")
    return serverurl
  end

  def self.putCustomDataContext(server, endpoint, param)
    result = self.http_post(server, endpoint, param)
    
    if result.code.to_s == "200"
      return true 
    else
      return false 
    end     
  end

  def self.getCustomDataContext(server, endpoint, param)
      return self.http_get(server, endpoint, param)
  end

  def self.http_get(server,path,params)
    if params.nil?
     return Net::HTTP.get(server, path)
    else
       queryStr =  "#{path}?".concat(params.collect { |k,v| "#{k}=#{CGI::escape(v.to_s)}" }.join('&'))
       puts ("SDKDEBUG: Calling URL " + server+queryStr)
       uri = URI(server + "/" + queryStr)
       return Net::HTTP.get(uri) 
    end
  end
 
  def self.http_post(server,path,params)
    queryStr =  "#{path}?".concat(params.collect { |k,v| "#{k}=#{CGI::escape(v.to_s)}" }.join('&'))
    puts ("SDKDEBUG: Calling URL " + server+queryStr)
    if params.nil?
        return Net::HTTP.post(server, path)
    else
        uri = URI(server +  path)
        return Net::HTTP.post_form(uri, params)
    end
  end

  # def self.getDataContext(server, endpoint, param)
  #     getCustomDataContext(server, endpoint, param)     
  # end

  # def self.updateDataContext(server, endpoint, param)
  #     putCustomDataContext(server, endpoint, param)  
  # end

  def getDataForContext(server, endpoint, param)
      getCustomDataContext(server, endpoint, param)    
  end

  def updateDataForContext(server, endpoint, param)
      putCustomDataContext(server, endpoint, param)  
  end
end