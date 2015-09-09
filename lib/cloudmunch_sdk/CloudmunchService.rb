#!/usr/bin/ruby

require 'net/http'
require 'cgi'

require_relative "Util"

module CloudmunchService
  include Util


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
