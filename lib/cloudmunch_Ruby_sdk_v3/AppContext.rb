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
 
class AppContext
    attr_accessor :masterurl
    attr_accessor :cloudproviders 
    attr_accessor :domainName 
    attr_accessor :project
    attr_accessor :job
    attr_accessor :workspaceLocation
    attr_accessor :archiveLocation 
    attr_accessor :stepid
    attr_accessor :targetServer
    attr_accessor :integrations
    attr_accessor :reportsLocation
    attr_accessor :runnumber
    attr_accessor :apikey 
    attr_accessor :stepname 
    attr_accessor :environmentId


    def initialize(param)
        @masterurl = ""
        @cloudproviders = ""
        @domainName = ""
        @project = ""
        @job = ""
        @workspaceLocation = ""
        @archiveLocation = ""
        @stepid = ""
        @targetServer=""
        @integrations=""
        @reportsLocation=""
        @runnumber=""
        @apikey=""
        @stepname=""
        @environmentId=""
       load_data(param) 
    end

    def load_data(param)
        @AppContextParams = param
    end     

    def get_data(keyname)
        @AppContextParams[keyname] 
    end     


end
