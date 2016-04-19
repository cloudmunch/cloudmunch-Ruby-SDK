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

    @appContext = nil
    @cmDataManager = nil
    @logHelper = nil
    @defaultRole   = "Area_51"
    
    def initialize(appContext)
        @appContext = appContext
        @cloudmunchDataService = CloudmunchService.new 
        @roleHelper = RoleHelper.new
    end

   # ##
   # ## 
   # ## @param  Json Object filterData In the format {"filterfield":"=value"}
   # ## @return json object environmentdetails
   # ##
   # ##   
   def getExistingEnvironments(filterData)
        paramHash = {}
        if !filterData.nil?
            paramHash["filter"] = filterData.to_json
        end

        serverUrl = @appContext.getMasterURL() + "/applications/"  + @appContext.getProject() + "/environments"
        envResult = @cloudmunchDataService.getDataForContext(serverUrl, @appContext.getAPIJey(), paramHash)

        if envResult == nil then 
            log("ERROR", "Unable to get data from cloudmunch") 
            return nil
        else
            envResult = JSON.parse(envResult)
            envData = envResult["data"]
            if envData.nil? then
                log("ERROR", "environments do not exist") 
                return nil
            else
                return envData
            end
        end
   end

   # ###
   # ### 
   # ### @param  String  environmentID
   # ### @param  Json Object filterData In the format {"filterfield":"=value"}
   # ### @return json object environmentdetails
   # ### 
   # ###    
    def getEnvironment(environmentID, filterData)
        paramHash = {}
        if !filterData.nil?
            paramHash["filter"] = filterData.to_json
        end
        serverUrl = @appContext.getMasterURL() + "/applications/" + @appContext.getProject() + "/environments/" + environmentID
        envResult = @cloudmunchDataService.getDataForContext(serverUrl, @appContext.getAPIJey(), paramHash)

        if envResult == nil then 
            log("ERROR", "Unable to get data from cloudmunch") 
            return nil
        else
            envResult = JSON.parse(envResult)
            envData = envResult["data"]
            if envData.nil? then
                log("DEBUG", "Environment does not exist") 
                return nil
            else
                return envData
            end
        end
    end

    # ###
    # ###
    # ### @param string environmentName Name of the environment
    # ### @param string environmentStatus Environment status ,valid values are success,failed,in-progress
    # ### @param array  environmentData Array of environment properties
    # ###
    def addEnvironment(environmentName, environmentStatus, environmentData)
        if environmentName.empty? || environmentStatus.empty? then
            log("ERROR", "Environment name ,status and type need to be provided") 
            return false
        end

        statusArray = [STATUS_CREATION_IN_PROGRESS, STATUS_RUNNING, STATUS_STOPPED, STATUS_STOPPED_WITH_ERRORS, STATUS_RUNNING_WITH_WARNINGS, STATUS_ACTION_IN_PROGRESS]
        if !statusArray.include?(assetStatus) then
            log("ERROR", "Invalid status sent. Allowed values " + STATUS_CREATION_IN_PROGRESS + "," + STATUS_RUNNING + "," + STATUS_STOPPED + "," + STATUS_STOPPED_WITH_ERRORS + "," STATUS_RUNNING_WITH_WARNINGS + "," + STATUS_ACTION_IN_PROGRESS) 
            return false
        end

        environmentData["name"] = environmentName
        environmentData["status"] = environmentStatus

        serverUrl = @appContext.getMasterURL() + "/applications/" + @appContext.getProject() + "/environments/"
        retResult = @cloudmunchDataService.updateDataForContext(serverUrl, @appContext.getAPIKey(), environmentData)

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

    # ###
    # ###
    # ### @param String Environment ID
    # ### @param JsonObject Environment Data
    # ###
    def updateEnvironment(environmentID, environmentData, comment)
        serverUrl = @appContext.getMasterURL() + "/applications/" + @appContext.getProject() + "/environments/" + environmentID
        retResult = @cloudmunchDataService.updateDataForContext(serverUrl, @appContext.getAPIKey(), environmentData)
    end

    # ###
    # ###
    # ### @param String Environment ID
    # ### @param URL    Environment Data
    # ###
    def updateEnvironmentURL(environmentID, environmentURL)
        if environmentURL.nil? || environmentURL.empty then
            log("ERROR", "Environment URL is not provided to update environment details") 
            return false
        else
            comment = "Setting application URL";
            paramHash = {}
            paramHash["application_url"] = environmentURL
            updateEnvironment(environmentID, paramHash, comment);
        end
    end

    # ###
    # ### 
    # ### @param String Environment ID
    # ### @param URL    Environment Data
    # ###
    def updateEnvironmentBuildVersion(environmentID, buildNumber)
        if buildNumber.nil? || buildNumber.empty then
            log("ERROR", "Build Number is not provided to update environment details") 
            return false
        else
            comment = "Setting application build version";
            paramHash = {}
            paramInnerHash = {}
            paramInnerHash["version"] = ""
            paramInnerHash["build"] = buildNumber
            paramHash["application"] = paramInnerHash
            updateEnvironment(environmentID, paramHash, comment);
        end
    end

    # ###
    # ### 
    # ### @param String Environment ID
    # ### @param Array  AssetArray
    # ### @param String Role Id
    # ###
    def updateAsset(environmentID, assetHash, roleID)
        if assetHash.nil? || assetHash.empty? then
            log("DEBUG","An array of asset ids are excpected for updating asset details to an environment")
            return false
        end

        if !assetHash.is_h? then
            log("INFO", "Role is not provided, creating a default role with name " + @defaultRole )
            return false
        end

        if roleID.nil? || roleID.empty? then
            filter = '{"name":"' + @defaultRole + '"}'
            defaultRoleDetails = @roleHelper.getExistingRoles(filter)

            if defaultRoleDetails.empty? then
                log("INFO", "Role is not provided, creating a default role with name " + @defaultRole )
                newRoleDetails = @roleHelper.addRole(@defaultRole)
                roleID = newRoleDetails.id
                paramHash = {}
                paramInnerHash = {}
                paramDataHash = {}
                paramDataHash["id"] = roleID
                paramDataHash["name"] = @defaultRole
                paramDataHash["assets"] = assetHash
                paramInnerHash[roleID] = paramDataHash
                paramHash["tiers"] = paramInnerHash
            else
                log("INFO", "Role is not provided, linking with default role : " + @defaultRole)
                roleID = defaultRoleDetails[0]["id"]
                paramHash = {}
                paramInnerHash = {}
                paramDataHash = {}
                paramDataHash["id"] = roleID
                paramDataHash["name"] = '{$tiers/'  + roleID + '.name}'
                paramDataHash["assets"] = assetHash
                paramInnerHash[roleID] = paramDataHash
                paramHash["tiers"] = paramInnerHash
            end
        else
            paramHash = {}
            paramInnerHash = {}
            paramDataHash = {}
            paramDataHash["id"] = roleID
            paramDataHash["name"] = @defaultRole
            paramDataHash["assets"] = assetHash
            paramInnerHash[roleID] = paramDataHash
            paramHash["tiers"] = paramInnerHash
        end

        comment = "Updating role asset mapping"
        updateEnvironment(environmentID, paramHash, comment)
    end

    # ###
    # ### 
    # ### @param String environmentID
    # ### @param array  key value pairs to be updated to environment details
    # ###
    def updateVariables(environmentID, envVariables)
        if environmentID.nil? then
            log("DEBUG", "Environment id value is needed for variables update on an environment")
        else
            variablesHash = {}
            variablesHash["variables"] = envVariables
            comment = "Updating variables"
            updateEnvironment(environmentID, variablesHash, comment)
        end
    end

    # ###
    # ###
    # ### @param String Environment ID
    # ### @param String Environment status
    # ###
    def updateStatus(environmentID, status)
        statusArray = [::STATUS_CREATION_IN_PROGRESS, ::STATUS_RUNNING, ::STATUS_STOPPED, ::STATUS_STOPPED_WITH_ERRORS, ::STATUS_RUNNING_WITH_WARNINGS, ::STATUS_ACTION_IN_PROGRESS]
        if !statusArray.include?(status) then
            log("ERROR", "Invalid status, valid values are " + ::STATUS_CREATION_IN_PROGRESS + "," + ::STATUS_RUNNING + "," + ::STATUS_STOPPED + "," + ::STATUS_STOPPED_WITH_ERRORS + "," + ::STATUS_RUNNING_WITH_WARNINGS + "," + ::STATUS_ACTION_IN_PROGRESS) 
            return false
        end

        statusHash = {}
        statusHash["status"] = status
        updateEnvironment(environmentID, statusHash)
    end

    # ###
    # ### Checks if Environment exists in cloudmunch.
    # ### @param string $environmentID
    # ### @return boolean
    # ###
    def checkIfEnvironmentExists(environmentID)
        serverUrl = @appContext.getMasterURL() + "/applications/" + @appContext.getProject() + "/environments/" + environmentID

        envResult = @cloudmunchDataService.getDataForContext(serverUrl, @appContext.getAPIKey(), "")
        if envResult == nil then  
            log("DEBUG", "Could not retreive data from cloudmunch")
            return nil
        else
            envResult = JSON.parse(envResult)
            envData = envResult["data"]
            if envData.nil? then
                log("ERROR", "Environment does not exist") 
                return false
            else
                return true
            end
        end
    end


end
