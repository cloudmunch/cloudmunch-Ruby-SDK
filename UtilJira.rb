#!/usr/bin/ruby
require 'json'
require 'CloudmunchService'

module UtilJira   
    
    def UtilJira.getSortedSprints(server, endpoint, params)
        sprints = []
        sname_by_sequence = {}
        tseq = []

        newParam = {
            :action => 'listcustomcontext',
            :fields => 'sequence, sprint_id',
            :group_by => 'sequence',
            :count => '*'
        }

        newParam = params.merge(newParam)
        cqlQuery = CloudmunchService.getDataContext(server, endpoint, newParam)
        cqlQuery = JSON.parse(cqlQuery)
        cqlQuery.each do |v|
            # puts v[1]
            tseq << v[1]['sequence'].to_i
            sname_by_sequence[v[1]['sequence'].to_i] = v[1]['sprint_id']
        end

        tseq.sort!.each do |y|
            sprints << sname_by_sequence[y]
        end

        return sprints
    end

    def UtilJira.getActiveSprint(server, endpoint, params)
        sprints = []

        newParam = {
            :action => "listcustomcontext",
            :fields => "sprint_id,sprint_status",
            :sort_by => "sprint_status",
            :count => "*",
        }

        newParam = params.merge(newParam)
        cqlQuery = CloudmunchService.getDataContext(server, endpoint, newParam)
        cqlQuery = JSON.parse(cqlQuery)
        sprint = nil
        cqlQuery.each do |x|
            if(x['sprint_status'] == 'ACTIVE')
                sprint = x['sprint_id']
            end
        end
        return sprint
    end

    
end
