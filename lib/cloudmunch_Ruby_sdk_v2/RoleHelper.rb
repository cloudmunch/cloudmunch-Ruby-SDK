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
 
class RoleHelper
    include CloudmunchService
    include Util

    @appContext = nil;
    @cmDataManager = nil;
    @logHelper = nil;
    
    def initialize(appContext)
        @appContext = appContext
        @cloudmunchDataService = CloudmunchService.new 
    end

    # ###
    # ###  Check if given name of the role is unique with existing ones
    # ###  @param  string  roleName       :  name of the environment name to be created
    # ###  @param  string  existingRoles  :  list of existing environments
    # ###  @return boolean true if name is unique
    # ###
    def isRoleNameUnique(existingRoles, roleName)
        existingRoles.each do |k,v|
            if v["name"] == roleName then
                return false
            end
        end
        return true
    end

    # ###
    # ###
    # ### @param  Json Object $filterdata In the format {"filterfield":"=value"}
    # ### @return json object roledetails
    # ###
    # ###
    def getExistingRoles(filterData)
        paramHash = {}
        if !filterData.nil?
            paramHash["filter"] = filterData.to_json
        end

        serverUrl = @appContext.getMasterURL() + "/applications/" + @appContext.getProject() + "/tiers"
        roleResult = @cloudmunchDataService.getDataForContext(serverUrl, @appContext.getAPIKey(), paramHash)

        if roleResult == nil then 
            log("ERROR", "Unable to get data from cloudmunch") 
            return nil
        else
            roleResult = JSON.parse(roleResult)
            roleData = roleResult["data"]
            if roleData.nil? then
                log("ERROR", "Role does not exist") 
                return nil
            else
                return roleData
            end
        end
    end

    # ###
    # ###
    # ### @param  String  $roleID
    # ### @param  Json Object $filterdata In the format {"filterfield":"=value"}
    # ### @return json object roledetails
    # ### 
    # ###
    def getRole(roleID, filterData)
        paramHash = {}
        if !filterData.nil?
            paramHash["filter"] = filterData.to_json
        end

        serverUrl = @appContext.getMasterURL() + "/applications/" + @appContext.getProject() + "/tiers/" + roleID
        roleResult = @cloudmunchDataService.getDataForContext(serverUrl, @appContext.getAPIKey(), paramHash)

        if roleResult == nil then 
            log("ERROR", "Unable to get data from cloudmunch") 
            return nil
        else
            roleResult = JSON.parse(roleResult)
            roleData = roleResult["data"]
            if roleData.nil? then
                log("ERROR", "Role does not exist") 
                return nil
            else
                return roleData
            end
        end
    end

    # /**
    #  * 
    #  * @param string $roleName Name of the role
    #  * @param string $role_status Role status ,valid values are success,failed,in-progress
    #  * @param array  $roleData Array of role properties
    #  */
    def addRole(roleName, roleData)
        if roleName.empty? then
            log("ERROR", "Role name need to be provided") 
            return false
        end

        roleData["name"] = roleName

        serverUrl = @appContext.getMasterURL() + "/applications/" + @appContext.getProject() + "/tiers/"
        retResult = @cloudmunchDataService.updateDataForContext(serverUrl, @appContext.getAPIKey(), roleData)

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
    # ### @param String Role ID
    # ### @param JsonObject Role Data
    # ###
    def updateRole(roleID, roleData)
        serverUrl = @appContext.getMasterURL() + "/applications/" + @appContext.getProject() + "/tiers/" + roleID
        @cloudmunchDataService.updateDataForContext(serverUrl, @appContext.getAPIKey(), roleData)
    end

    # ###
    # ### Checks if Role exists in cloudmunch.
    # ### @param string $roleID
    # ### @return boolean
    # ###
    def checkIfRoleExists(roleID)
        serverUrl = @appContext.getMasterURL() + "/applications/" + @appContext.getProject() + "/tiers/" + roleID

        roleResult = @cloudmunchDataService.getDataForContext(serverUrl, @appContext.getAPIKey(), "")
        if roleResult == nil then  
            return nil
        else
            roleResult = JSON.parse(roleResult)
            roleData = roleResult["data"]
            if roleData.nil? then
                log("ERROR", "Role does not exist") 
                return false
            else
                return true
            end
        end
    end



end
