#!/usr/bin/ruby

require 'net/http'
require 'cgi'
require 'json'

require_relative "Util"

module CloudmunchService
  include Util
  def initialize(appcontext)
   @applicationContext=appcontext
  end

   def updateCloudmunchData(context,contextid,data)
    
    serverurl=@applicationContext.get_data("{master_url}")+"/applications/"+@applicationContext.get_data("{application}")+"/"+context+"/"+contextid;
    serverurl=serverurl+"?apikey="+@applicationContext.get_data("{api_key}")
     uri = URI.parse(serverurl)
    
     response= Net::HTTP.post_form(uri,"data" => data.to_json)
     
     return response.body
   end



   def getCloudmunchData(context,contextid,filterdata)
    if contextid.nil? || contextid.empty?
     serverurl=@applicationContext.get_data("{master_url}")+"/applications/"+@applicationContext.get_data("{application}")+"/"+context
     else
     serverurl=@applicationContext.get_data("{master_url}")+"/applications/"+@applicationContext.get_data("{application}")+"/"+context+"/"+contextid;
    end
    querystring=""
    if filterdata.nil? || filterdata.empty?
      serverurl=serverurl+"?apikey="+@applicationContext.get_data("{api_key}")
    else
      querystring="filter="+to_json($filerdata);
      serverurl=serverurl+"?"+querystring+"&apikey="+@applicationContext.get_data("{api_key}")
    
    end
   uri = URI.parse(serverurl)
    
     return Net::HTTP.get(uri)
   end

   
   def deleteCloudmunchData(context,contextid)
    serverurl=@applicationContext.get_data("{master_url}")+"/applications/"+@applicationContext.get_data("{application}")+"/"+context+"/"+contextid;
   serverurl=serverurl+"?apikey="+@applicationContext.get_data("{api_key}")
    uri = URI.parse(serverurl)
    Net::HTTP::Delete(uri)
   end 




   def self.putCustomDataContext(server, endpoint, param)
      result = self.http_post(server, endpoint, param)
      #p result.code.to_s 
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

   def self.getDataContext(server, endpoint, param)
      getCustomDataContext(server, endpoint, param)     
   end


   def self.updateDataContext(server, endpoint, param)
      putCustomDataContext(server, endpoint, param)  
   end
end
