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
 
class AssetHelper
    include CloudmunchService
    include Util

    @appContext = nil;
    @cmDataManager = nil;
    @logHelper = nil;
    
    def initialize(appContext)
        @appContext = appContext
        @cloudmunchDataService = CloudmunchService.new 
    end

    def getAsset(assetID, filterData)
        paramHash = {}
        if !filterData.nil?
            paramHash["filter"] = filterData.to_json
        end
        serverUrl = @appContext.getMasterURL() + "/applications/" + @appContext.getProject() + "/assets/" + assetID
        assetResult = @cloudmunchDataService.getDataForContext(serverUrl, @appContext.getAPIJey(), paramHash)

        if assetResult == nil then 
            log("ERROR", "Unable to get data from cloudmunch") 
            return nil
        else
            assetResult = JSON.parse(assetResult)
            assetData = assetResult["data"]
            if assetData.nil? then
                log("ERROR", "Asset does not exist") 
                return nil
            else
                return assetData
            end
        end
    end
    
    def addAsset(assetName, assetType, assetStatus, assetExternalRef, assetData)
        if assetName.empty? || assetType.empty? || assetStatus.empty? then
            log("ERROR", "Asset name ,status and type need to be provided") 
            return false
        end

        statusArray = [::STATUS_RUNNING, ::STATUS_STOPPED, ::STATUS_NIL]
        if !statusArray.include?(assetStatus) then
            log("ERROR", "Invalid status sent. Allowed values " + ::STATUS_RUNNING, ::STATUS_STOPPED, ::STATUS_NIL) 
            return false
        end

        assetData["name"] = assetName
        assetData["type"] = assetType
        assetData["status"] = assetStatus
        assetData["external_reference"] = assetExternalRef

        serverUrl = @appContext.getMasterURL() + "/applications/" + @appContext.getProject() + "/assets/"
        retResult = @cloudmunchDataService.updateDataForContext(serverUrl, @appContext.getAPIKey(), assetData)

        if retResult == nil then 
            return nil
        else
            retResult = JSON.parse(retResult)
            retData = retResult["data"]
            if retData.nil? then 
                return nil
            else
                return retData
            end
        end

    end

    
    def updateAsset(assetID, assetData)
        serverUrl = @appContext.getMasterURL() + "/applications/" + @appContext.getProject() + "/assets/" + assetID
        @cloudmunchDataService.updateDataForContext(serverUrl, @appContext.getAPIKey(), assetData)
    end
    
    def deleteAsset(assetID)
        serverUrl = @appContext.getMasterURL() + "/applications/" + @appContext.getProject() + "/assets/" + assetID
        @cloudmunchDataService.deleteDataForContext(serverUrl, @appContext.getAPIKey())
    end
    
    def updateStatus(assetID, status)
        statusArray = [::STATUS_RUNNING, ::STATUS_STOPPED, ::STATUS_NIL]
        if !statusArray.include?(status) then
            log("ERROR", "Invalid status") 
            return false
        end

        assetData = {}
        assetData["status"] = status
        updateAsset(assetID, assetData)
    end

    def checkIfAssetExists(assetID)
        serverUrl = @appContext.getMasterURL() + "/applications/" + @appContext.getProject() + "/assets/" + assetID

        assetResult = @cloudmunchDataService.getDataForContext(serverUrl, @appContext.getAPIKey(), "")
        if assetResult == nil then  
            return nil
        else
            assetResult = JSON.parse(assetResult)
            assetData = assetResult["data"]
            if assetData.nil? then
                log("ERROR", "Asset does not exist") 
                return false
            else
                return true
            end
        end
    end


end
