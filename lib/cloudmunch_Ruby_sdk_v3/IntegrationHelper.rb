#!/usr/bin/ruby
###
###  (c) CloudMunch Inc.
### All Rights Reserved
### Un-authorized copying of this file, via any medium is strictly prohibited
###  Proprietary and confidential
###
###  ganesan@cloudmunch.com
###

$LOAD_PATH << '.'
require 'json'
require_relative "CloudmunchConstants"
 
class IntegrationHelper
    include CloudmunchService
    include Util

    @appContext = nil;
    @logHelper = nil;
    
    def initialize()
    end
    
    def getService(jsonParams)
        cloudproviders = jsonParams["cloudproviders"]
        cloudproviders = JSON.parse(cloudproviders)
        providerName = jsonParams["providername"]
        log("DEBUG", "Provider Name: " + providerName)
        integrationDetailsHash = nil

        if !providerName.nil? && providerName.chop.length > 0 then
            regFields = cloudproviders[providerName]

            integrationDetailsHash = {}
            regFields.each do |k,v|
                integrationDetailsHash[k] = v
            end

            return integrationDetailsHash
        else
            return nil
        end
    end

    
    def getIntegration(jsonParams, integrationHash)
        providerName = jsonParams["providername"]
        log("DEBUG", "Provider Name: " + providerName)
        integrationDetailsHash = nil

        if !providerName.nil? && providerName.chop.length > 0 then
            regFields = integrationHash[providerName]["configuration"]

            integrationDetailsHash = {}
            regFields.each do |k,v|
                integrationDetailsHash[k] = v
            end

            return integrationDetailsHash
        else
            return nil
        end
    end

   


end
