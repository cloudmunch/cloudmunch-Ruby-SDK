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
 
class ElasticBeanStalkServer < Server
	attr_accessor :servername
	attr_accessor :envname
	attr_accessor :bucketname
	attr_accessor :applicationName
	attr_accessor :templateName
	attr_accessor :description
	attr_accessor :dns
	attr_accessor :appName
	attr_accessor :deployTempLoc
	attr_accessor :assettype
	attr_accessor :status
	attr_accessor :starttime
	attr_accessor :provider
	attr_accessor :provider
	attr_accessor :region
	attr_accessor :cmserver
	attr_accessor :assetname

    def initialize(appContext)
        @servername = ""
        @envname = ""
        @bucketname = ""
        @applicationName = ""
        @templateName = ""
        @description = ""
        @dns = ""
        @appName = ""
        @deployTempLoc = ""
        @assettype = ""
        @status = ""
        @starttime = ""
        @provider = ""
        @region = ""
        @cmserver = ""
        @assetname = ""
    end


end
