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
 
class ServerHelper
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
    # ### This method retreives the details of server from cloudmunch.
    # ### @param  string $servername Name of the server as registered in cloudmunch.
    # ### @return \CloudMunch\Server
    # ###
    def getServerName(serverName)
        server = nil
        serverUrl = @appContext.getMasterURL() + "/applications/" + @appContext.getProject() + "/assets/" + serverName
        log("DEBUG", "serverurl from serverhelper:" + serverUrl)

        deployResult = @cloudmunchDataService.getDataForContext(serverUrl, @appContext.getAPIKey(),nil)
        if deployResult == nil then
            return false
        else
            deployResult = JSON.parse(deployResult)
            deployData = deployResult["data"]
            if deployData.nil? then
                log("ERROR", "Server does not exist") 
                return nil
            else
                if (deployResult[serverName].include?("assetname")) && (deployResult[serverName]["assetname"] == "ElasticBeanStalk") then
                    server = ElasticBeanStalkServer.new 
                else
                    server = Server.new

                    server.servername = deployData["id"]
                    server.description = deployData["description"]
                    server.dns = deployData["dnsName"]
                    server.domainName = deployData["domainName"]
                    server.CI = deployData["CI"]
                    server.deploymentStatus = deployData["deploymentStatus"]
                    server.instanceId = deployData["instanceId"]
                    server.imageID = deployData["amiID"]
                    server.launcheduser = deployData["username"]
                    server.build = deployData["build"]
                    server.appName = deployData["appName"]
                    server.deployTempLoc = deployData["deployTempLoc"]
                    server.buildLocation = deployData["buildLoc"]
                    server.privateKeyLoc = deployData["privateKeyLoc"]
                    server.publicKeyLoc = deployData["publicKeyLoc"]
                    server.loginUser = deployData["loginUser"]
                    server.serverType = deployData["serverType"]
                    server.assetType = deployData["assettype"]
                    server.status = deployData["status"]
                    server.startTime = deployData["starttime"]
                    server.provider = deployData["provider"]
                    server.region = deployData["region"]
                    server.cmserver = deployData["cmserver"]
                    server.assetName = deployData["assetname"]
                    server.instanceSize = deployData["instancesize"]
                    server.password = deployData["password"]
                    server.sshport = deployData["sshport"]
                    server.tier = deployData["tier"]
                    
                    if server.instance_of?(ElasticBeanStalkServer) then
                        server.environmentName = deployData["environmentName"]
                        server.bucketName = deployData["bucketName"]
                        server.applicationName = deployData["applicationName"]
                        server.templateName = deployData["templateName"]
                    end

                    return server
                end
            end
        end       
    end

    
     # ###
     # ### This method can be used to add or register a server to cloudmunch data .
     # ### @param \CloudMunch\Server server
     # ### @param string docker
     # ###
    def addServer(server, serverStatus, docker)
        
        if serverStatus.empty? then
            log("ERROR", "Server status need to be provided")
            return false
        end

        statusArray = [::STATUS_RUNNING, ::STATUS_STOPPED, ::STATUS_NIL]
        if !statusArray.include?(serverStatus) then
            log("ERROR", "Invalid status")
            return false
        end

        paramHash = {}
        paramHash["description"] = server.description
        paramHash["dnsName"] = server.dns
        paramHash["domainName"] = server.domainName
        paramHash["emailID"] = server.emailID
        paramHash["CI"] = server.CI ? "y" : "n"
        paramHash["deploymentStatus"] = server.deploymentStatus
        paramHash["instanceId"] = server.instanceId
        paramHash["amiID"] = server.imageID
        paramHash["username"] = server.username
        paramHash["build"] = server.build
        paramHash["appName"] = server.appName
        paramHash["deployTempLoc"] = server.deployTempLoc
        paramHash["buildLoc"] = server.buildLocation
        paramHash["privateKeyLoc"] = server.privateKeyLoc
        paramHash["publicKeyLoc"] = server.publicKeyLoc
        paramHash["loginUser"] = server.loginUser
        paramHash["serverType"] = server.serverType
        paramHash["type"] = "server"
        paramHash["status"] = server.status
        paramHash["starttime"] = server.startTime
        paramHash["provider"] = server.provider
        paramHash["region"] = server.region
        paramHash["cmserver"] = server.cmserver
        paramHash["name"] = server.serverName
        paramHash["instancesize"] = server.instanceSize
        paramHash["password"] = server.password
        paramHash["sshport"] = server.sshport
        paramHash["tier"] = server.tier
  
        if server.instance_of?(ElasticBeanStalkServer) then
            paramHash["applicationName"] = server.applicationName
            paramHash["templateName"] = server.templateName
            paramHash["environmentName"] = server.environmentName
            paramHash["bucketName"] = server.bucketName
        end

        paramHash["status"] = serverStatus

        if docker then
            dataInnerHash = {}
            dataInnerHash["buildNo"] = server.build
            dataServerNode = {}
            dataServerNode[server.appName] = dataInnerHash
            paramHash["projects"] = dataServerNode
        end

        serverUrl = @appContext.getMasterURL() + "/applications/" + @appContext.getProject() + "/assets/"
        @cloudmunchDataService.updateDataForContext(serverUrl, @appContext.getAPIKey(), paramHash)
    end

    # ###
    # ### This method is used to update server data.
    # ### @param \CloudMunch\Server server
    # ###
    def updateServer(server, serverID)
        paramHash = {}
        paramHash["description"] = server.description
        paramHash["dnsName"] = server.dns
        paramHash["domainName"] = server.domainName
        paramHash["emailID"] = server.emailID
        paramHash["CI"] = server.CI ? "y" : "n"
        paramHash["deploymentStatus"] = server.deploymentStatus
        paramHash["instanceId"] = server.instanceId
        paramHash["amiID"] = server.imageID
        paramHash["username"] = server.username
        paramHash["build"] = server.build
        paramHash["appName"] = server.appName
        paramHash["deployTempLoc"] = server.deployTempLoc
        paramHash["buildLoc"] = server.buildLocation
        paramHash["privateKeyLoc"] = server.privateKeyLoc
        paramHash["publicKeyLoc"] = server.publicKeyLoc
        paramHash["loginUser"] = server.loginUser
        paramHash["serverType"] = server.serverType
        paramHash["type"] = "server"
        paramHash["status"] = server.status
        paramHash["starttime"] = server.startTime
        paramHash["provider"] = server.provider
        paramHash["region"] = server.region
        paramHash["cmserver"] = server.cmserver
        paramHash["name"] = server.serverName
        paramHash["instancesize"] = server.instanceSize
        paramHash["password"] = server.password
        paramHash["sshport"] = server.sshport
        paramHash["tier"] = server.tier

        serverUrl = @appContext.getMasterURL() + "/applications/" + @appContext.getProject() + "/assets/" + serverID  
        return @cloudmunchDataService.updateDataForContext(serverUrl, @appContext.getAPIKey(), paramHash)        
    end

    # ###
    # ### This method is to delete server from cloudmunch.
    # ### @param  $serverName Name of server.
    # ###
    def deleteServer(serverID)
        serverUrl = @appContext.getMasterURL() + "/applications/" + @appContext.getProject() + "/assets/" + serverID       
        return  @cloudmunchDataService.deleteDataForContext(serverUrl, @appContext.getAPIKey() )
    end

    # ###
    # ### This method checks if server exists or is registered in cloudmunch data.
    # ### @param  $servername Name of server.
    # ### @return boolean
    # ###
    def checkServerExists(serverName)
        serverUrl = @appContext.getMasterURL() + "/applications/" + @appContext.getProject() + "/assets/" + serverName

        serverResult = @cloudmunchDataService.getDataForContext(serverUrl, @appContext.getAPIKey(), "")
        if serverResult == nil then  
            return nil
        else
            serverResult = JSON.parse(serverResult)
            serverData = serverResult["data"]
            if serverData.nil? then
                log("ERROR", "Server does not exist") 
                return false
            else
                return true
            end
        end
    end

    # ###
    # ### Checks if server is up and running
    # ###
    # ### @param    string dns      :   dns of target server 
    # ### @param    number sshport  :   ssh port (22) to be used to check for connection
    # ### @return   string Success  :   displays an appropriate message
    # ###                 Failure  :   exits with a failure status with an appropriate message
    # ###
    def checkConnect(dns, sshport)
        connectionTimeout = Time.now 
        connectionTimeout = connectionTimeout + (10 * 10)
        connection = false

        while ((connection == false) && ( Time.now <  connectionTimeout )) do 
            if dns.nil? || dns.empty? then
                log("ERROR", "Invalid dns" + dns)
                return false
            end
            log("INFO", "Checking connectivity to: " + dns)

            connection = ssh2_connect(dns, sshport)
            if connection == false then
                sleep(10)
            end
        end

        if connection == false then
            log("ERROR", "Failed to connect to " + dns )
            return false
        else
            return true
        end
    end

    def checkConnectionToServer(servername)
    end
 
    def getConnectionToServer(servername)
    end
    
    # ###
    # ### This method returns SSHConnection helper
    # ### @return \CloudMunch\sshConnection
    # ###
    def getSSHConnectionHelper()
        return SSHConnection.new
    end

end
