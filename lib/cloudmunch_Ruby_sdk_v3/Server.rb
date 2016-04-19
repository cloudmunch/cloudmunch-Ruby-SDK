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
    

class Server
    attr_accessor :description
    attr_accessor :dns 
    attr_accessor :domainName 
    attr_accessor :emailID
    attr_accessor :CI
    attr_accessor :deploymentStatus
    attr_accessor :instanceId 
    attr_accessor :imageID
    attr_accessor :launcheduser 
    attr_accessor :build
    attr_accessor :appName 
    attr_accessor :deployTempLoc 
    attr_accessor :buildLocation 
    attr_accessor :privateKeyLoc 
    attr_accessor :publicKeyLoc
    attr_accessor :loginUser 
    attr_accessor :serverType
    attr_accessor :assetType
    attr_accessor :status
    attr_accessor :startTime
    attr_accessor :provider 
    attr_accessor :region
    attr_accessor :cmserver 
    attr_accessor :assetName
    attr_accessor :instanceSize 
    attr_accessor :serverName 
    attr_accessor :password
    attr_accessor :sshport 
    attr_accessor :tier

    def initialize
        @description=""
        @dns=""
        @domainName=""
        @emailID=""
        @CI=""
        @deploymentStatus=""
        @instanceId=""
        @imageID=""
        @launcheduser=""
        @build=""
        @appName=""
        @deployTempLoc=""
        @buildLocation=""
        @privateKeyLoc=""
        @publicKeyLoc=""
        @loginUser=""
        @serverType=""
        @assettype=""
        @status=""
        @starttime=""
        @provider=""
        @region=""
        @cmserver=""
        @assetname=""
        @instancesize=""
        @servername=""
        @password=""
        @sshport=22
        @tier=""
    end    

end
