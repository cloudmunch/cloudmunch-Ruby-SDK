# cloudmunch-Ruby-SDK
CloudMunch SDK for Ruby provides base and helper classes for CloudMunch plugin development.

Downloading Cloudmunch-Ruby-SDK-SDK

Cloudmunch-Ruby-SDK-V2 has been hosted in RubyGems.org too, as a gem file, named “cloudmunch_sdk” version “>=0.7.0”.  (See the link  https://rubygems.org/gems/cloudmunch_sdk )

The command “gem install cloudmunch_sdk” will install our cloudmunch ruby sdk into your local machine.

We recommend using bundler as package manager. All you need to install the sdk is to have the following entry in your “gemfile”. More details are provided in this document.

source 'https://rubygems.org'
gem 'cloudmunch_sdk', '0.7.0'
gem 'test-unit'


Cloudmunch SDK Details

Cloudmunch SDK contains the following classes and modules. The usage of those helper classes will be depending on the requirements of the plugin to be developed. While a plugin development may not require using all of these helper classes, few classes such as AppAbstract, CloudmunchService, ServiceProvider and Util are necessary for almost all plugins. In the case of Insight plugin (One that renders the crucial data to business operations in graphic format), InsightHelper module provides all useful functionalities for accessing and retrieving Cloudmunch DB. IntegrationHelper will be useful in the development of loader plugins, as it provides the endpoint URL and authentication credentials to the plugin in secured and safe manner, so that loader plugin can access the endpoint server for retrieving relevant datapoints. For details on these helper classes, please go through the SDK documentation ( link to SDK documentation ).

AppAbstract
AppContext
AssetHelper
CloudmunchConstants
CloudmunchService
ElasticBeanStalkServer
EnvironmentHelper
InsightHelper
IntegrationHelper
RoleHelper
Server
ServerHelper
ServiceProvider
Util

AppAbstract class

This is a base abstract class that should be extended by any plugin. This class, provides methods to read parameters, retrieve plugin context object and service objects. This class has the following lifecycle methods that the app, in order to be considered to be a plugin,  needs to override, 

initializeApp() 

This is kind of constructor function to the plugin. This user overridden method will have the variables required for the plugins to be initialized.

process() 

This method includes the business logic implementation aspect of the plugin.

cleanupApp() 

This is kind of destructor function to the plugin. This user overridden method will have the critical resource variables set to nil.

Apart from those mandatory overridable methods, there are following methods which can be invoked depends on the requirements of the plugin.

getJSONArgs()

This method provides the list of input parameters for the plugin. Usually, “initializeApp” of every plugin would invoke this method in order to get the list of input parameters of the plugin and assign them to instance level variables of the plugin class.

getCloudmunchService()

This method returns Cloudmunch Service needed to invoke any services in cloudmunch. The returned cloudmunch service instance will provide a list of methods, which are described in the section “CloudmunchService Module”.

getInsightHelper()

This method returns an instance of InsightHelper class which provides a slew of methods that are needed to deal with creating assets, objects which are Cloudmunch Insight related into Cloudmunch DB and retrieve those details from Cloudmunch DB. For details on the methods of InsightHelper class, you can see the section InsightHelper module.

getIntegrationDetails()

This methods returns and instance of IntegrationHelper class which provides a set of methods that are neede to get the integration details of the source server. For details on the methods of IntegrationHelper class, you can see the section IntegrationHelper module.


AppContext 

AppContext class Plugins can get the context or environment information from this class.

Apart from these, there are many helper modules in Ruby Cloudmunch SDK in order to provide useful functionalities.

AssetHelper

This is a helper class to manage assets in cloudmunch.

CloudmunchService

This helper class provides method to retreive/update data from cloudmunch. Below is the list of methods that can be used. 

EnvironmentHelper

This is a helper class to manage environments in cloudmunch.

InsightHelper

This is a helper class to manage insight related objects (insightID,datastore,  extract, report, report card, etc) in cloudmunch.

IntegrationHelper

This is a helper class to manage integration points of the source servers in cloudmunch platform.

RoleHelper

RoleHelper class helps us managing the roles related information. 

ServerHelper

ServerHelper class helps us managing the server related information. 

ServiceProvider

This class provides provider information about the integration servers.

Util

This is a helper class that provides utility methods such as, for example, log related methods.


Creating a Cloudmunch Insight plugin using Ruby based cloudmunch SDK.

GitHub repository contains Sample HelloWorld plugins created using the Ruby based cloudmunch SDK. In order to get started with development, the following pre requisites needs to be met.

Ruby (See the link https://www.ruby-lang.org/en/ for details.)
bundler (Ruby dependency manager. See the link http://bundler.io/  for details.)
Cloudmunch Ruby SDK gem ( https://rubygems.org/gems/cloudmunch_sdk )

Instructions for installing Ruby and bundler in local machine, is given below.

sudo su
su cloudmunch

#install RVM and ruby -s table

gpg --keyserver hkp://keys.gnupg.net --recv-keys 
<key>
curl -sSL https://get.rvm.io | bash -s stable --ruby

gem install bundler

The following Env variables need to be set in the dev machine.

#local installation
export GEM_HOME=/home/cloudmunch/.rvm/gems/ruby-2.2.1
export GEM_PATH=$PATH:/var/cloudbox/_MASTER_/data/contexts/plugins/app_gems/ruby/2.2.0/:$GEM_HOME
export MY_RUBY_HOME=/home/cloudmunch/.rvm/rubies/ruby-2.2.1
export rvm_bin_path=/home/cloudmunch/.rvm/bin
export PATH=$GEM_HOME/bin:$PATH:$MY_RUBY_HOME/bin:$rvm_bin_path


Development of a cloudmunch plugin using Ruby cloudmunch SDK would require keeping the relevant files in the following pre-determined folder structure. The folder structure of a typical plugin is given below.

root folder

This root folder will contain the following files.

gemfile ( A file that provides the list of ruby dependencies for the plugin )
install.sh (Installation script that will get executed by the deployment pipeline of cloudmunch platform, in order to download and copy the dependency files in a target machine )
plugin.json (A meta file that contains meta details about the plugin)

img folder

This folder will optionally contain the thumbnail as well as plugin’s resultant graph’s image in order to be displayed along with the plugin in cloudmunch repository.

src folder

This folder will contain the main ruby of the plugin. This file will have a class derived from AppAbstract class of Cloudmunch Ruby SDK.

test folder
	
This folder will contain the unit test file for the plugin.

About RubySDK_HelloWorld Plugins

RubySDK_HelloWorld plugin is an example but workable Cloudmunch Insight plugin. Cloudmunch Insight plugin is one that, in general, will render the data in some graphic form.There are two plugins - Loader plugin and Reporter plugin in this sample plugin folder. Loader plugin (RubySDK_HelloWorld_Loader_V2) provides details about how the plugin stores the plugin related data into Cloudmunch DB by creating the context for the data. The Reporter plugin (RubySDK_HelloWorld_Reporter_V2) provides details about accessing/retrieving the relevant data, based on a specific context and render the data in graphical format. 


RubySDK HelloWorld Loader Plugin

plugin.json for Ruby SDK Hello World Loader will have meta details about the plugin (id, name, author, version, status, execution and documentation details of the plugin) and details about the input parameters (name, type, hint, default value, etc). The plugin.json for RubySDK_HelloWorld_Loader_V2, which is given below, contains the input parameters such as insight_id, greeting_from, greeting_to, greeting_message, and log_level.

plugin.json file

{
  "id": "RubySDK_HelloWorld_Loader_V2",
  "name": "Ruby SDK HelloWorld Sample Plugin Loader Ver 2",
  "author": "Ganesan",
  "version": "1",
  "status": "enabled",
  "tags": [
    "insights",
    "greeting",
    "rubysdk",
    "sampleplugin"
  ],
  "inputs": {
    "insight_id": {
        "label": "Insight Name",
        "display": "yes",
        "type": "dropdown",
        "resource": {
          "url": "applications/{application_id}/insights"
        },
        "mandatory": true,
        "defaultValue": "",
        "hint": "Select the insight name under which data needs to be loaded"
     },
     "greeting_from": {
        "label": "Greeting From",
        "display": "yes",
        "type": "text",
        "validation_rules": [
          {
            "rule": "STRING",
            "message": "",
            "continue": false
          }
        ],
        "defaultValue": "",
        "hint": "Sender name"
       },
     "greeting_to": {
        "label": "Greeting To",
        "display": "yes",
        "type": "text",
        "validation_rules": [
          {
            "rule": "STRING",
            "message": "",
            "continue": false
          }
        ],
        "defaultValue": "",
        "hint": "Receiver name"
       },
     "greeting_message": {
        "label": "Greeting Message",
        "display": "yes",
        "type": "text",
        "validation_rules": [
          {
            "rule": "STRING",
            "message": "",
            "continue": false
          }
        ],
        "defaultValue": "Hello World!!!",
        "hint": "Greeting Message Content"
       },
      "log_level": {
        "label": "Log level",
        "display": "yes",
        "type": "text",
        "validation_rules": [
          {
            "rule": "STRING",
            "message": "",
            "continue": false
          }
        ],
        "defaultValue": "INFO",
        "hint": "DEBUG|WARNING|INFO|ERROR|FATAL"
       }
  },
  "execute": {
    "main": "RubySDK_HelloWorld_Loader_V2/src/RubySDK_HelloWorld_Loader_V2.rb",
    "language": "ruby",
    "options": ""
  },
  "documentation": {
    "description": "Saves greeting message into database."
  },
  "_created_by": "ganesan@cloudmunch.com",
  "_create_time": "2015-12-30 06:23:25.0474",
  "_updated_by": "ganesan@cloudmunch.com",
  "_update_time": ""
}

RubySDK_HelloWorld_Loader_V2.rb

RubySDK_HelloWorld_Loader_V2 file is given below. 


require "bundler/setup"
require "rubygems"
require "cloudmunch_sdk"
require "date"
require "json"

class RubySDKHelloWorldLoaderV2App < AppAbstract

    def initializeApp()       
        json_input = getJSONArgs()
        @cmInsightHelper = getInsightHelper()

        @insightID = json_input['insight_id'].nil? ? exitWithMessage("error", "Insight id not provided!") : json_input['insight_id']
        @greetingFrom = json_input['greeting_from'].nil? ? exitWithMessage("error", "greeting_from is not provided!") : json_input['greeting_from']
        @greetingTo = json_input['greeting_to'].nil? ? exitWithMessage("error", "greeting_to not provided!") : json_input['greeting_to']
        @greeting_message = json_input['greeting_message'].nil? ? exitWithMessage("error", "greeting_message not provided!") : json_input['greeting_message']
        @greetingTime = Time.now.strftime("%H:%M:%S")

        @log_level = !json_input['log_level'].nil? ? json_input['log_level'] : "INFO"
        logCategoryArray = ["debug", "warning", "info", "error", "fatal"]
        if !logCategoryArray.include? (@log_level.downcase) then
            @log_level = "info"
        end

        @greetingParam = Hash.new 
        @greetingParam["message"] = @greetingMessage
        @greetingParam["from"] = @greetingFrom
        @greetingParam["to"] = @greetingTo
        @greetingParam["time"] = @greetingTime
        
        logInit(@log_level)
        log("info", __method__.to_s +  "initializeApp is invoked in RubySDKHelloWorldLoaderV2 App")
        log("debug", @greetingParam.to_s)      
    end

    def process()
        log("info", "process is invoked in RubySDKHelloWorldLoaderV2 App")
        saveGreetingMessage(@greetingParam)
    end  

    def saveGreetingMessage(paramHash)
        log("info", "saveGreetingMessage is invoked in RubySDKHelloWorldLoaderV2 App")
        log("debug", paramHash.to_s)
       
        @id = "greetingMessage"
        @helloWorldRubyPluginV2Context = "helloWorldRubyPluginV2"
        log("info", "Updating cmdb with greeting message: id:"+@id) 

        wrapperHash = {}
        wrapperHash["result"] = paramHash
        puts wrapper_hash
        log("debug", wrapperHash.to_s)

        #pass the filled in hash object to the following method
        save_data(@helloWorldRubyPluginV2Context, @id, wrapperHash)
    end 

    def save_data(dataStoreName, extractName, data)
        log("info", __method__.to_s + " is invoked in RubySDKHelloWorldLoaderV2 App")
        log("debug", data)
        log("info", "Updating cmdb with extract Name:"+extractName) 
        log("debug", @insightID+" : "+dataStoreName)
        dataStoreID = nil
        dataStoreID = @cmInsightHelper.createInsightDataStore(@insightID, dataStoreName)
        log("debug", "dataStoreID : "+dataStoreID)
        extractID = nil
        extractID   = @cmInsightHelper.createInsightDataStoreExtract(@insightID, dataStoreID, extractName)
        log("debug", "extractID : "+extractID)
        response    = @cmInsightHelper.updateInsightDataStoreExtract(@insightID, dataStoreID, extractID, data)  
    end 

    def cleanupApp()
        log("info", "cleanupApp is invoked in RubySDKHelloWorldLoaderV1 App")
        logClose()
    end

    def checkForNil(response)
        if(response.nil?)
            log("debug","Empty response recieved!")
            exitWithMessage("ERROR", "Action on cloudmunch data base returned empty! refer log for more details")
        end
        return response
    end

    def exitWithMessage(msgType, msg)
        log(msgType, msg)
        exit 1
    end


end

helloWorldLoader = RubySDKHelloWorldLoaderV2App.new()
helloWorldLoader.start()



This file contains a class “RubySDKHelloWorldLoaderV2App” derived from base class, AppAbstract. This class implements the mandatory methods of AppAbstract such as initializeApp, process and cleanupApp. The method initializeApp() contains plugin level variables set by the values of the input parameters, retrieved through one of the AppAbstract methods, getJSONArgs. 

It is important here to know how the logging mechanism supported by Ruby SDK is being used here. The plugin gets the “log_level” as one of the input parameters and logging mechanism is initialized by passing through that “log_level” (through logInit(@log_level) method).  Once log handler is initialized thus, now crucial messages about the plugin during its runtime can be logged with specific log level to which the log messages are belonging. See the code snippet given below.
 		
logInit(@log_level)
log("info", __method__.to_s +  "initializeApp is invoked in RubySDKHelloWorldLoaderV2 App")
log("debug", @greetingParam.to_s)     

The method “process()” contains the logic to store the greeting message along with sender, receiver and date details into cloudmunch DB, by invoking an internal function “saveGreetingMessage()”.  The method “saveGreetingMessage”, in turn, invokes a method, save_data that creates a data store and data store extract in cloudmunch DB ( In order to store the loader data with a specific context so that the stored data can be accessed later, possibly in reporter plugins, we need to create data store (where all the data relevant to this specific plugin are stored)  and extract (kind of tag that identifies the sub set uniquely). The following methods from “InsightHelper” class are used to create data store and extract.

dataStoreID = @cmInsightHelper.createInsightDataStore(@insightID, dataStoreName)
extractID   = @cmInsightHelper.createInsightDataStoreExtract(@insightID, dataStoreID, extractName)

Having created required data store and extract for storing the data, we can invoke the method “updateInsightDataStoreExtract”  (see the code snipped given below) by passing the data which we need to store into cloudmunch DB. Please note that “data” parameter that is getting passed into this method should be a ruby hash object.

response    = @cmInsightHelper.updateInsightDataStoreExtract(@insightID, dataStoreID, extractID, data)  

The above method will store the loader data into cloudmunch DB in a specific data store with a given extract id. 

Since we have created RubySDK_HelloWorld_Loader_V2 that stores the greeting info into cloudmunch DB, we can now proceed with creating a reporter plugin (RubySDK_HelloWorld_Reporter_V2) that will retrieve the stored information and render the data into a graphic format - as a tabular row. 

As we have already mentioned, the plugin.json The plugin.json contains meta details about the plugin (id, name, author, version, status, execution and documentation details of the plugin) and details about the input parameters (name, type, hint, default value, etc). The plugin.json for RubySDK_HelloWorld_Reporter_V2, which is given below, contains the input parameters such as insight_id, viewcard_title and log_level.

{
  "id": "RubySDK_HelloWorld_Reporter_V2",
  "name": "Ruby SDK HelloWorld Sample Plugin Reporter Ver 2",
  "author": "Ganesan",
  "version": "1",
  "status": "enabled",
  "tags": [
    "insights",
    "greeting",
    "rubysdk",
    "sampleplugin"
  ],
  "inputs": {
    "insight_id": {
        "label": "Insight Name",
        "display": "yes",
        "type": "dropdown",
        "resource": {
          "url": "applications/{application_id}/insights"
        },
        "mandatory": true,
        "defaultValue": "",
        "hint": "Select the insight name under which data needs to be loaded"
     },
     "viewcard_title": {
        "label": "Title of Insight Viewcard",
        "display": "yes",
        "type": "text",
        "validation_rules": [
          {
            "rule": "STRING",
            "message": "",
            "continue": false
          }
        ],
        "defaultValue": "Greeting Viewcard",
        "hint": "Viewcard Title Name"
       },
      "log_level": {
        "label": "Log level",
        "display": "yes",
        "type": "text",
        "validation_rules": [
          {
            "rule": "STRING",
            "message": "",
            "continue": false
          }
        ],
        "defaultValue": "INFO",
        "hint": "DEBUG|WARNING|INFO|ERROR|FATAL"
       }
  },
  "execute": {
    "main": "RubySDK_HelloWorld_Reporter_V2/src/RubySDK_HelloWorld_Reporter_V2.rb",
    "language": "ruby",
    "options": ""
  },
  "documentation": {
    "description": "Renders greeting message in an Insight viewcard."
  },
  "_created_by": "ganesan@cloudmunch.com",
  "_create_time": "2015-12-30 06:23:25.0474",
  "_updated_by": "ganesan@cloudmunch.com",
  "_update_time": ""
}


RubySDK_HelloWorld_Reporter_V2.rb file 
 
require 'rubygems'
require 'bundler/setup'
require 'cloudmunch_sdk'
require "date"

class RubySDKHelloWorldReporterV2App < AppAbstract

    def initializeApp()
        json_input = getJSONArgs()
        @cmInsightHelper = getInsightHelper()
        
        @insightID       = json_input['insight_id']
        @viewcardTitle   = json_input['viewcard_title']
        @pluginDescription = json_input["description"]
        @reportCardName  = "HelloWorld-Ruby-SDK-V2-Sample-Plugin"   
        @log_level = !json_input['log_level'].nil? ? json_input['log_level'] : "INFO"
        logCategoryArray = ["debug", "warning", "info", "error", "fatal"]
        if !logCategoryArray.include? (@log_level.downcase) then
            @log_level = "info"
        end

        @reportID        = checkForNil(@cmInsightHelper.createInsightReport(@insightID, Time.now.strftime("%Y-%m-%d")))

        @greetingMessageExtract = "greetingMessage"
        @dataStoreName = "helloWorldRubyPluginV2"    

        logInit(@log_level)
        log("info", __method__.to_s + " method is invoked from RubySDKHelloWorldReporterV2App")
    end

    def process()
        log("info", __method__.to_s + " method from RubySDKHelloWorldReporterV2App")
        result = getDataForViewcard()
        data   = constructViewcard(result)
        
        @reportCardID = checkForNil(@cmInsightHelper.createInsightReportCard(@insightID, @reportID, @reportCardName))
        response      = checkForNil(@cmInsightHelper.updateInsightReportCard(@insightID, @reportID, @reportCardID, data))       
    end

    def getDataForViewcard()
        log("info", __method__.to_s + " method from RubySDKHelloWorldReporterV2App")

        @filterStr =  '"id"' + ":" + '"' + @greetingMessageExtract + '"'
        @filterStr = '{'+@filterStr+'}'

        @dataStoreID = checkForNil(@cmInsightHelper.getDataStoreID(@insightID, @dataStoreName))

        paramHash = {}
        paramHash["fields"] = 'result,id'
        paramHash["filter"] = @filterStr
        paramHash["insightID"]   = @insightID
        paramHash["dataStoreID"] = @dataStoreID

        response = checkForNil(@cmInsightHelper.getInsightDataStoreExtracts(paramHash))
        log("DEBUG", "Extracts : ")
        log("DEBUG", response)

        return response
    end

    def constructViewcard(parsed_hash)
        log("info", __method__.to_s + " method from InsightsGitHubOrganizationReposByCommitsApp")  

        p parsed_hash
        result = parsed_hash[0]["result"] 

        result_arr = result.to_a

        result_hash = {}
        result_arr.each do |arrElem|
            result_hash[arrElem[0]] = arrElem[1]
        end
    
        data = []
        final = {} 
        data.push( result_hash )

        viewcard_meta_info = {}
        viewcard_meta_info["viewcardTitle"] = @viewcardTitle
        viewcard_meta_info["default"] = "kanban"
        viewcard_meta_info["url"] = ""
        viewcard_meta_info["date"] = Time.now.strftime("%Y-%m-%d")
        viewcard_meta_info["label"] = @viewcardTitle
        viewcard_meta_info["source"] = ""
        viewcard_meta_info["group"] = ""
        viewcard_meta_info["description"] = @pluginDescription
        viewcard_meta_info["graphType"] = "kanban"

        final['data'] = data
        final['visualization_map'] = constructViewcardVisualizationMeta()
        final['card_meta'] = constructViewcardMeta(viewcard_meta_info)

        data = {}
        data["data"] = final  
        return data
    end

    def constructViewcardVisualizationMeta()
        log("info", __method__.to_s + " method from InsightsGitHubOrganizationReposByCommitsApp")

        visualization_map = { "cards" => { "type" => "kanban" } } 
        return visualization_map
    end

    def constructViewcardMeta(viewcardMetaInfo)
        log("info", __method__.to_s + " method from InsightsGitHubOrganizationReposByCommitsApp")

        card_meta = { 
                        "default" => viewcardMetaInfo["default"], 
                        "url"     => viewcardMetaInfo["url"], 
                        "date"    => viewcardMetaInfo["date"], 
                        "label"   => viewcardMetaInfo["label"], 
                        "source"  => viewcardMetaInfo["source"], 
                        "group"   => viewcardMetaInfo["group"],
                        "description"   => viewcardMetaInfo["description"],
                        "visualization_options" => [ viewcardMetaInfo["graphType"] ],
                        "xaxis"   => {"label" => viewcardMetaInfo["xAxisLabel"]},
                        "yaxis"   => {"label" => viewcardMetaInfo["yAxisLabel"]},
                    }

        return card_meta
    end

    def checkForNil(response)
        if(response.nil?)
            log("debug","Empty response recieved!")
            exitWithMessage("ERROR", "Action on cloudmunch data base returned empty! refer log for more details")
        end
        return response
    end

    def exitWithMessage(msgType, msg)
        log(msgType, msg)
        exit 1
    end

    def cleanupApp()
        log("info", __method__.to_s + " method is invoked from RubySDKHelloWorldReporterV2App")
        logClose()
    end

end

helloWorldReporterV2View = RubySDKHelloWorldReporterV2App.new()
helloWorldReporterV2View.start()


This file contains a class “RubySDKHelloWorldReporterV2App” derived from base class, AppAbstract. This class implements the mandatory methods of AppAbstract such as initializeApp, process and cleanupApp. The method initializeApp() contains plugin level variables set by the values of the input parameters, retrieved through one of the AppAbstract methods, getJSONArgs. 

The method process() invokes the internal methods such as getDataForViewcard (which retrieves the relevant data from cloudmunch DB) and constructViewcard (which prepares the data as well as meta required for rendering the information as a graph). See the code snippet given below.

result = getDataForViewcard()
data   = constructViewcard(result)
        
@reportCardID = checkForNil(@cmInsightHelper.createInsightReportCard(@insightID, @reportID, @reportCardName))
checkForNil(@cmInsightHelper.updateInsightReportCard(@insightID, @reportID, @reportCardID, data))       


Once data and meta for rendering as a graph are generated through the methods, we need to create a Report card through createInsightReportCard() and update the graph (as well as meta) data into that that, using updateInsightReportCard. See the code snippet given below.
However, what is to be noted here is, we need to know the data store name and extract name in order to retrieve the data stored by loader application. See the code snippet given below.

@dataStoreID = checkForNil(@cmInsightHelper.getDataStoreID(@insightID, @dataStoreName))

paramHash = {}
paramHash["fields"] = 'result,id'
paramHash["filter"] = @filterStr
paramHash["insightID"]   = @insightID
paramHash["dataStoreID"] = @dataStoreID

response = checkForNil(@cmInsightHelper.getInsightDataStoreExtracts(paramHash))






