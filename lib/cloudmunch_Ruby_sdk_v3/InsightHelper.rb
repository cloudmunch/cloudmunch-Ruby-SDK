#!/usr/bin/ruby
require 'logger'
require 'json'
require_relative 'Util'

module InsightHelper
    include Util

  ##################################################################################
  ###
  ###
  ### createInsight(insightName)
  ### createInsightDataStore(insightID, dataStoreName)
  ### createInsightDataStoreExtract(insightID, dataStoreID, extractName)
  ### createInsightReport(insightID, reportName)
  ### createInsightReportCard(insightID, reportID, cardName)
  ### createInsightReportKeyMetric(insightID, reportID, keyMetricName)
  ###
  ###
  ### getDataStoreID(insightID, dataStoreName)
  ### getExtractID(insightID, dataStoreID, extractName)
  ### getReportID(insightID, reportName) 
  ### getReportCardID(insightID, reportID, cardName)
  ### getKeyMetricID(insightID, reportID, keyMetricName)
  ###
  ###
  ### getInsights(paramHash)
  ### getInsightDataStores(paramHash)
  ### getInsightDataStoreExtracts(paramHash)
  ### getInsightReports(paramHash)
  ### getInsightReportCards(paramHash)
  ### getInsightReportKeyMetrics(paramHash)
  ###
  ###
  ### updateInsight(insightID, data)
  ### updateInsightDataStore(insightID, dataStoreID, data)
  ### updateInsightDataStoreExtract(insightID, dataStoreID, extractID, data)
  ### updateInsightReport(insightID, reportID, data)
  ### updateInsightReportCard(insightID, reportID, cardID, data)
  ### updateInsightReportKeyMetric(insightID, reportID, keyMetricID, data)
  ###
  ### getListOfDatesForADuration(durationUnitNameStr, durationUnitNumber)
  ### getInsightReportDataTemplateHash(reportTypeStr)
  ### getInsightReportMetaTemplateHash(reportTypeStr)
  ### getInsightReportVisualizationMapTemplateHash(reportTypeStr)
  ################################################################################## 


 

  ###################################################################################
  #### createInsight(insightName)
  #### Creates An Insight space in Server Workspace
  #### Needed in Loader plugins
  ###################################################################################
  def createInsight(insightName)
    if !insightName.nil?
      insightID = nil
      insightID = getInsightID(insightName)
      
      if !insightID.nil?
        log("DEBUG", "Insight with name "+insightName+" already exists!")
        return insightID
      else
        paramHash = {}
        paramHash["context"]    = "resources"
        paramHash["data"]       = {"name" => insightName}
        insight = updateCloudmunchData(paramHash)
        
        if insight["id"].nil?
          log("DEBUG", "Unable to create insight : "+insightName+"! refer log for more details")
          return nil
        else
          return insight["id"]
        end
      end
    else
        log("DEBUG", "Insights name is needed for creating an insight")
        return nil
    end
  end

  ###################################################################################
  #### createInsightDataStore(insightID, dataStoreName)
  #### Creates An Insight DataStore in Server Workspace
  #### Needed in Loader plugins
  ###################################################################################
  def createInsightDataStore(insightID, dataStoreName)
    if !dataStoreName.nil? && !dataStoreName.empty? && !insightID.nil?
      dataStoreID = nil
      dataStoreID = getDataStoreID(insightID, dataStoreName)
      
      if !dataStoreID.nil?
        log("DEBUG", "Data store with name "+dataStoreName+" already exists!")
        return dataStoreID
      else
        paramHash = {}
        paramHash["context"]    = "resources"
        paramHash["contextID"]  = insightID
        paramHash["subContext"] = "datastores"
        paramHash["data"]       = {"name" => dataStoreName}
        dataStore = updateCloudmunchData(paramHash)
        
        if dataStore.nil?
          return nil
        else
          return dataStore["id"]
        end
      end
    else
        log("DEBUG", "Datastore name and insights id is needed for creating a data store")
        return nil
    end
  end

  ###################################################################################
  #### createInsightDataStoreExtract(insightID, dataStoreID, extractName)
  #### Creates An Insight DataStore Extract in Server Workspace
  #### Needed In Loader Plugins
  ###################################################################################
  def createInsightDataStoreExtract(insightID, dataStoreID, extractName)
    if !extractName.nil? && !extractName.empty? && !insightID.nil?  && !dataStoreID.nil?

      extractID = nil
      extractID = getExtractID(insightID, dataStoreID, extractName)
      
      if !extractID.nil?
        return extractID
      else
        paramHash = Hash.new
        paramHash["context"]      = "resources"
        paramHash["contextID"]    = insightID
        paramHash["subContext"]   = "datastores"
        paramHash["subContextID"] = dataStoreID
        paramHash["leafContext"]  = "extracts"
        paramHash["data"]         = {"name" => extractName}

        log("DEBUG", "Attempting creation of extract with name " + extractName + "...")
        extract = updateCloudmunchData(paramHash)

        if extract["id"].nil? then return nil else extract["id"] end
      end
    else
        log("DEBUG", "Extract name, insights id and datastore id is needed for creating an extract")
        return nil
    end
  end


  ###################################################################################
  #### createInsightReport(insightID, reportName)
  #### Creates An Insight Report in Server Workspace
  #### Needed In Reporter Plugins
  ###################################################################################
  def createInsightReport(insightID, reportName)
    if !reportName.nil? && !reportName.empty? && !insightID.nil?

      reportID = nil
      reportID = getReportID(insightID, reportName)
      
      if !reportID.nil?
        return reportID
      else
        paramHash = Hash.new
        paramHash["context"]     = "resources"
        paramHash["contextID"]   = insightID
        paramHash["subContext"]  = "insight_reports"
        paramHash["data"]        = {"name" => reportName}

        log("DEBUG", "Attempting creation of report with name " + reportName + "...")
        report = updateCloudmunchData(paramHash)

        if report["id"].nil? then return nil else report["id"] end
      end
    else
        log("DEBUG", "Report name and insight id is needed for creating a report")
        return nil
    end
  end

  ###################################################################################
  #### createInsightReportCard(insightID, reportID, cardName)
  #### Creates An Insight Report Card in Server Workspace
  #### Needed In Reporter Plugins
  ###################################################################################
  def createInsightReportCard(insightID, reportID, cardName)
    if !cardName.nil? && !cardName.empty? && !insightID.nil?  && !reportID.nil?

      cardID = nil
      cardID = getReportCardID(insightID, reportID, cardName)
      
      if !cardID.nil?
        return cardID
      else
        paramHash = Hash.new
        paramHash["context"]      = "resources"
        paramHash["contextID"]    = insightID
        paramHash["subContext"]   = "insight_reports"
        paramHash["subContextID"] = reportID
        paramHash["leafContext"]  = "insight_cards"
        paramHash["data"]         = {"name" => cardName}

        log("DEBUG", "Attempting creation of report card with name " + cardName + "...")
        card = updateCloudmunchData(paramHash)

        if card["id"].nil? then return nil else card["id"] end
      end
    else
        log("DEBUG", "Extract name, insight id and report id is needed for creating a report card")
        return nil
    end
  end

  

  ###################################################################################
  #### createInsightReportKeyMetric(insightID, reportID, keyMetricName)
  #### Creates An Insight Report Key Metric in Server Workspace
  #### Needed In Reporter Plugins
  ###################################################################################
  def createInsightReportKeyMetric(insightID, reportID, keyMetricName)
    if !keyMetricName.nil? && !keyMetricName.empty? && !insightID.nil?  && !reportID.nil?

      keyMetricID = nil
      keyMetricID = getReportKeyMetricID(insightID, reportID, keyMetricName)
      
      if !keyMetricID.nil?
        return keyMetricID
      else
        paramHash = Hash.new
        paramHash["context"]      = "resources"
        paramHash["contextID"]    = insightID
        paramHash["subContext"]   = "insight_reports"
        paramHash["subContextID"] = reportID
        paramHash["leafContext"]  = "insight_cards"
        paramHash["data"]         = {"name" => keyMetricName}

        log("DEBUG", "Attempting creation of report key metric with name " + keyMetricName + "...")
        keyMetric = updateCloudmunchData(paramHash)

        if keyMetric["id"].nil? then return nil else keyMetric["id"] end
      end
    else
        log("DEBUG", "Key metric name, insight id and report id is needed for creating a report key metric")
        return nil
    end
  end


   ###################################################################################
  #### getDataStoreID(insightID, dataStoreName)
  #### Gets DataStore ID for a given DataStore
  #### <NOTE>
  ###################################################################################
  def getDataStoreID(insightID, dataStoreName)
      if insightID.nil? || dataStoreName.nil?
        log("DEBUG", "insight id and datastore name is needed to get datastore id")
        return nil
      end

      paramHash = Hash.new
      paramHash["insightID"] = insightID
      paramHash["filter"] = {"name" => dataStoreName} 
      paramHash["count"]  = 1
      paramHash["fields"] = "id" 

      dataStore = getInsightDataStores(paramHash)
      
      if dataStore.nil? 
        log("DEBUG", "Data store with name "+dataStoreName+" does not exist")
        return nil
      elsif (dataStore.kind_of?(Array)) && (dataStore.length.to_i > 0)
        return dataStore[0]["id"]
      else
        log("DEBUG", "Data store with name "+dataStoreName+" does not exist")
        return nil
      end
  end

  ###################################################################################
  #### getExtractID(insightID, dataStoreID, extractName)
  #### Gets Extract ID for a given extract in a DataStore
  #### <NOTE>
  ###################################################################################
  def getExtractID(insightID, dataStoreID, extractName)
      if insightID.nil? || dataStoreID.nil? || extractName.nil?
        log("DEBUG", "insight id, datastore id and extract name is needed to get extract id")
        return nil
      end

      extract = nil
      paramHash = Hash.new
      paramHash["insightID"]   = insightID
      paramHash["dataStoreID"] = dataStoreID
      paramHash["filter"] = {"name" => extractName}
      paramHash["count"]  = 1
      paramHash["fields"] = "id" 

      extract = getInsightDataStoreExtracts(paramHash)

      if extract.nil? 
        log("DEBUG", "Extract with name "+extractName+" does not exist")
        return nil
      elsif (extract.kind_of?(Array)) && (extract.length.to_i > 0)
        return extract[0]["id"]
      else
        log("DEBUG", "Extract with name "+extractName+" does not exist")
        return nil
      end
  end

  ###################################################################################
  #### getReportID(insightID, reportName)
  #### Gets Report ID for a given report
  #### <NOTE>
  ###################################################################################
  def getReportID(insightID, reportName)
    if insightID.nil? || reportName.nil?
      log("DEBUG", "insight id and report name is needed to get report id")
      return nil
    end

    paramHash = Hash.new
    paramHash["insightID"] = insightID
    paramHash["filter"] = {"name" => reportName} 
    paramHash["count"]  = 1
    paramHash["fields"] = "id" 

    report = getInsightReports(paramHash)

    if report.nil? 
      log("DEBUG", "Report with name "+reportName+" does not exist")
      return nil
    elsif (report.kind_of?(Array)) && (report.length.to_i > 0)
      return report[0]["id"]
    else
      log("DEBUG", "Report with name "+reportName+" does not exist")
      return nil
    end
end


  
  ###################################################################################
  #### getReportCardID(insightID, reportID, cardName)
  #### Gets Report Card ID for a given report card
  #### <NOTE>
  ###################################################################################
  def getReportCardID(insightID, reportID, cardName)
      if insightID.nil? || reportID.nil? || cardName.nil?
        log("DEBUG", "insight id, report id and card name is needed to get report card id")
        return nil
      end

      card = nil
      paramHash = Hash.new
      paramHash["insightID"] = insightID
      paramHash["reportID"] = reportID
      paramHash["filter"] = {"name" => cardName}
      paramHash["count"]  = 1
      paramHash["fields"] = "id" 

      card = getInsightReportCards(paramHash)

      if card.nil? 
        log("DEBUG", "Report with name "+cardName+" does not exist")
        return nil
      elsif (card.kind_of?(Array)) && (card.length.to_i > 0)
        return card[0]["id"]
      else
        log("DEBUG", "Report with name "+cardName+" does not exist")
        return nil
      end
  end

  ###################################################################################
  #### getKeyMetricID(insightID, reportID, keyMetricName)
  #### Gets Key Metric ID for a given report card
  #### <NOTE>
  ###################################################################################
  def getKeyMetricID(insightID, reportID, keyMetricName)
      paramHash = Hash.new
      paramHash["insightID"] = insightID
      paramHash["reportID"] = reportID
      paramHash["filter"] = {"name" => keyMetricName}
      paramHash["count"]  = 1
      paramHash["fields"] = "id" 

      keyMetric = getInsightReportCards(paramHash)
      if keyMetric.nil? || !keyMetric.any?
        log("DEBUG", "Report key metric with name "+keyMetricName+" does not exist")
        return nil
      else
        return keyMetric[0]["id"]
      end
  end

  ###################################################################################
  #### getInsights(paramHash)
  #### Get Insights from Server Workspace
  #### Needed In Reporter Plugins
  ###################################################################################
  def getInsights(paramHash)
    # /insights/{insight_id}
    paraminsightID = paramHash["insightID"].nil? ? nil : paramHash["insightID"]

    paramFormatted = Hash.new
    paramFormatted = paramHash
    paramFormatted["context"] = "resources"
    
    if !paraminsightID.nil? && !paraminsightID.empty?
        paramFormatted["contextID"]  = paramInsightID
    end    

    return getCloudmunchData(paramFormatted)          
  end


  ###################################################################################
  #### getInsightDataStores(paramHash)
  #### Get Insight DataStores from Server Workspace
  #### Needed In Reporter Plugins
  ###################################################################################
  def getInsightDataStores(paramHash)
    # /insights/{insight_id}/datastores/{datastore_id}
    paramInsightID  = paramHash["insightID"].nil? ? nil : paramHash["insightID"]

    if paramInsightID.nil? || paramInsightID.empty?
      log("DEBUG", "Insight id is not provided")
      return nil
    end

    paramFormatted = Hash.new
    paramFormatted = paramHash
    paramFormatted["context"]    = "resources"
    paramFormatted["subContext"] = "datastores"
    paramFormatted["contextID"]  = paramInsightID
    
    if !paramHash["dataStoreID"].nil?
      paramFormatted["subContextID"] = paramHash["dataStoreID"]
    end
    return getCloudmunchData(paramFormatted)          
  end

  ###################################################################################
  #### getInsightDataStoreExtracts(paramHash)
  #### Get Insight DataStore Extracts from Server Workspace
  #### Needed In Reporter Plugins
  ###################################################################################
  def getInsightDataStoreExtracts(paramHash)
    # /insights/{insight_id}/datastores/{datastore_id}/extracts/{extract_id}
    paramDataStoreId = paramHash["dataStoreID"].nil? ? nil : paramHash["dataStoreID"]
    paramInsightID   = paramHash["insightID"].nil? ? nil : paramHash["insightID"]

    serverurl   = nil

    if paramInsightID.nil? || paramInsightID.empty? || paramDataStoreId.nil? || paramDataStoreId.empty?
      log("DEBUG", "Insight id and datastore id is needed to gets its extract details")
      return nil
    end

    paramFormatted = Hash.new
    paramFormatted = paramHash
    paramFormatted["context"]      = "resources"
    paramFormatted["subContext"]   = "datastores"
    paramFormatted["leafContext"]  = "extracts"
    paramFormatted["contextID"]    = paramInsightID
    paramFormatted["subContextID"] = paramDataStoreId
    
    if !paramHash["extractID"].nil?
      paramFormatted["leafContextID"] = paramHash["extractID"]
    end

    return getCloudmunchData(paramFormatted)
  end

  ###################################################################################
  #### getInsightReports(paramHash)
  #### Get Insight Reports from Server Workspace
  #### Needed In Reporter Plugins
  ###################################################################################
  def getInsightReports(paramHash)
    # /applications/{application_id}/insights/{insight_id}/insight_reports/{insight_report_id}
    paramInsightID = paramHash["insightID"].nil? ? nil : paramHash["insightID"]

    if paramInsightID.nil? || paramInsightID.empty?
      log("DEBUG", "Insight id is needed to gets its report details")
      return nil
    end

    paramFormatted = Hash.new
    paramFormatted = paramHash
    paramFormatted["context"]    = "resources"
    paramFormatted["subContext"] = "insight_reports"
    paramFormatted["contextID"]  = paramInsightID
    
    if !paramHash["reportID"].nil?
      paramFormatted["subContextID"] = paramHash["reportID"]
    end

    return getCloudmunchData(paramFormatted)
  end

  ###################################################################################
  #### getInsightReportCards(paramHash)
  #### Get Insight Report Cards from Server Workspace
  #### Needed In Reporter Plugins
  ###################################################################################
  def getInsightReportCards(paramHash)
    # /applications/{application_id}/insights/{insight_id}/insight_reports/{insight_report_id}/insight_cards/{insight_card_id}
    paramReportId  = paramHash["reportID"].nil? ? nil : paramHash["reportID"]
    paramInsightID = paramHash["insightID"].nil? ? nil : paramHash["insightID"]

    if paramInsightID.nil? || paramInsightID.empty? || paramReportId.nil? || paramReportId.empty?
      log("DEBUG", "Insight id and report id is needed to gets its report card details")
      return nil
    end

    paramFormatted = Hash.new
    paramFormatted = paramHash
    paramFormatted["context"]      = "resources"
    paramFormatted["subContext"]   = "insight_reports"
    paramFormatted["leafContext"]  = "insight_cards"
    paramFormatted["contextID"]    = paramInsightID
    paramFormatted["subContextID"] = paramReportId
    
    if !paramHash["cardID"].nil?
      paramFormatted["leafContextID"] = paramHash["cardID"]
    end

    return getCloudmunchData(paramFormatted)
  end

  ###################################################################################
  #### getInsightReportKeyMetrics(paramHash)
  #### Get Insight Report Key Metrics from Server Workspace
  #### Needed In Reporter Plugins
  ###################################################################################
  def getInsightReportKeyMetrics(paramHash)
    # /applications/{application_id}/insights/{insight_id}/insight_reports/{insight_report_id}/key_metrics/{key_metric_id}
    paramReportId  = paramHash["reportID"].nil? ? nil : paramHash["reportID"]
    paramInsightID = paramHash["insightID"].nil? ? nil : paramHash["insightID"]

    if paramInsightID.nil? || paramInsightID.empty? || paramReportId.nil? || paramReportId.empty?
      log("DEBUG", "Insight id and report id is needed to gets its report key metric details")
      return nil
    end

    paramFormatted = Hash.new
    paramFormatted = paramHash
    paramFormatted["context"]      = "resources"
    paramFormatted["subContext"]   = "insight_reports"
    paramFormatted["leafContext"]  = "key_metrics"
    paramFormatted["contextID"]    = paramInsightID
    paramFormatted["subContextID"] = paramReportId
    
    if !paramHash["keyMetricID"].nil?
      paramFormatted["leafContextID"] = paramHash["keyMetricID"]
    end

    return getCloudmunchData(paramFormatted)
  end

  ###################################################################################
  #### updateInsight(insightID, data)
  #### Updates Insight Into Server Workspace
  #### Needed In Reporter Plugins
  ###################################################################################
  def updateInsight(insightID, data)
    # /applications/{application_id}/insights/{insight_id}

    if (insightID.nil? || insightID.empty?) && data.nil?
      log("DEBUG", "Insight id and data is needed to be update an existing data store")
      return nil
    end

    paramHash = {}
    paramHash["context"]   = "resources"
    paramHash["contextID"] = insightID
    paramHash["data"]      = data
    return updateCloudmunchData(paramHash)
  end


  ###################################################################################
  #### updateInsightDataStore(insightID, dataStoreID, data)
  #### Updates Insight DataStore Into Server Workspace
  #### Needed In Reporter Plugins
  ###################################################################################
  def updateInsightDataStore(insightID, dataStoreID, data)
    # /applications/{application_id}/insights/{insight_id}/datastores/{datastore_id}

    if (insightID.nil? || insightID.empty?) && (dataStoreID.nil? || dataStoreID.empty?) && data.nil?
      log("DEBUG", "Insight id, datastore id and data is needed to be update an existing data store")
      return nil
    end
        paramHash = {}
        paramHash["context"]      = "resources"
        paramHash["contextID"]    = insightID
        paramHash["subContext"]   = "datastores"
        paramHash["subContextID"] = dataStoreID
        paramHash["data"]         = data
        return updateCloudmunchData(paramHash)
  end

  ###################################################################################
  #### updateInsightDataStoreExtract(insightID, dataStoreID, extractID, data)
  #### Updates Insight DataStore Extract In Server Workspace
  #### Needed In Reporter Plugins
  ###################################################################################
  def updateInsightDataStoreExtract(insightID, dataStoreID, extractID, data)
    # /insights/{insight_id}/datastores/{datastore_id}/extracts/{extract_id}

    if (insightID.nil? || insightID.empty?) && (dataStoreID.nil? || dataStoreID.empty?) && (extractID.nil? || extractID.empty?) && data.nil?
      log("DEBUG", "Insight id, datastore id, extract id and data is needed to be update an existing extract")
      return nil
    end
        paramHash = {}
        paramHash["context"]       = "resources"
        paramHash["contextID"]     = insightID
        paramHash["subContext"]    = "datastores"
        paramHash["subContextID"]  = dataStoreID
        paramHash["leafContext"]   = "extracts"
        paramHash["leafContextID"] = extractID
        paramHash["data"]          = data
        return updateCloudmunchData(paramHash)
  end

  ###################################################################################
  #### updateInsightReport(insightID, reportID, data)
  #### Updates Insight Report In Server Workspace
  #### Needed In Reporter Plugins
  ###################################################################################
  def updateInsightReport(insightID, reportID, data)
    # /applications/{application_id}/insights/{insight_id}/insight_reports/{insight_report_id}

    if (insightID.nil? || insightID.empty?) && (reportID.nil? || reportID.empty?) && data.nil?
      log("DEBUG", "Insight id, report id and data is needed to be update an existing report")
      return nil
    end
        paramHash = {}
        paramHash["context"]      = "resources"
        paramHash["contextID"]    = insightID
        paramHash["subContext"]   = "insight_reports"
        paramHash["subContextID"] = reportID
        paramHash["data"]         = data
        return updateCloudmunchData(paramHash)
  end


  ###################################################################################
  #### updateInsightReportCard(insightID, reportID, cardID, data)
  #### Updates Insight Report Card In Server Workspace
  #### Needed In Reporter Plugins
  ###################################################################################
  def updateInsightReportCard(insightID, reportID, cardID, data)
    # /applications/{application_id}/insights/{insight_id}/insight_reports/{insight_report_id}/insight_cards/{insight_card_id}

    if (insightID.nil? || insightID.empty?) && (reportID.nil? || reportID.empty?) && (cardID.nil? || cardID.empty?) && data.nil?
      log("DEBUG", "Insight id, report id, cardID and data is needed to be update an existing report card")
      return nil
    end

    paramHash = {}
    paramHash["context"]       = "resources"
    paramHash["contextID"]     = insightID
    paramHash["subContext"]    = "insight_reports"
    paramHash["subContextID"]  = reportID
    paramHash["leafContext"]   = "insight_cards"
    paramHash["leafContextID"] = cardID
    paramHash["data"]          = data
    return updateCloudmunchData(paramHash)
  end

  ###################################################################################
  #### updateInsightReportKeyMetric(insightID, reportID, keyMetricID, data)
  #### Updates Insight Report KeyMetric In Server Workspace
  #### Needed In Reporter Plugins
  ###################################################################################
  def updateInsightReportKeyMetric(insightID, reportID, keyMetricID, data)
    # /applications/{application_id}/insights/{insight_id}/insight_reports/{insight_report_id}/key_metrics/{key_metric_id}

    if (insightID.nil? || insightID.empty?) && (reportID.nil? || reportID.empty?) && (keyMetricID.nil? || keyMetricID.empty?) && data.nil?
      log("DEBUG", "Insight id, report id, keyMetricID and data is needed to be update an existing report key metric")
      return nil
    end

    paramHash = {}
    paramHash["context"]       = "resources"
    paramHash["contextID"]     = insightID
    paramHash["subContext"]    = "insight_reports"
    paramHash["subContextID"]  = reportID
    paramHash["leafContext"]   = "key_metrics"
    paramHash["leafContextID"] = keyMetricID
    paramHash["data"]          = data
    return updateCloudmunchData(paramHash)
  end

  ###################################################################################
  #### getListOfDatesForADuration(durationUnitNameStr, durationUnitNumber)
  #### durationUnitNameStr : days | weeks | months
  #### durationUnitNumber : Eg. 1 to N
  #### Get List(Array) of Dates (history) for a given duration from current day
  #### Needed In Reporter Plugins
  ###################################################################################
  def getListOfDatesForADuration(durationUnitNameStr, durationUnitNumber)
        log("info", __method__.to_s + " method is invoked from InsightsGitHubOrgsReposWithSize")
        $i = 0
        duration_arr = []
        $curr_date = Date.today
        $tmp_unit = nil
        $tmp_days_in_month = nil

        case durationUnitNameStr.downcase
        when "days"
            while $i < durationUnitNumber
                $tmp_unit = $curr_date.strftime("%Y-%m-%d")
                duration_arr[$i] = $tmp_unit
                $curr_date -= 1
                $i += 1
            end
        when "weeks"
            while $i < durationUnitNumber
                $tmp_unit = $curr_date.strftime("%Y-%m-%d")
                duration_arr[$i] = $tmp_unit
                $curr_date -= 7
                $i += 1
            end
        when "months"
            while $i < durationUnitNumber
                $tmp_unit = $curr_date.strftime("%Y-%m-%d")
                $tmp_days_in_month = $curr_date.day
                duration_arr[$i] = $tmp_unit
                $curr_date -= $tmp_days_in_month
                $i += 1
            end
        end

        return duration_arr
  end

  ###################################################################################
  #### getInsightReportDataTemplateHash(reportTypeStr)
  #### Gets the data template Hash that needs to be filled in for a given report type
  #### Needed In Reporter Plugins
  ###################################################################################
  def getInsightReportDataTemplateHash(reportTypeStr)

  end

  ###################################################################################
  #### getInsightReportMetaTemplateHash(reportTypeStr)
  #### Gets the meta template Hash that needs to be filled in for a given report type
  #### Needed In Reporter Plugins
  ###################################################################################
  def getInsightReportMetaTemplateHash(reportTypeStr)

  end

  ###################################################################################
  #### getInsightReportVisualizationMapTemplateHash(reportTypeStr)
  #### Gets the visualization map template Hash that needs to be filled in for a given report type
  #### Needed In Reporter Plugins
  ###################################################################################
  def getInsightReportVisualizationMapTemplateHash(reportTypeStr)

  end

end

