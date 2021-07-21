/**
 * Created by Alex JR on 7/21/2021.
 */

public with sharing class PrioritySetSelector extends fflib_SObjectSelector {

    public List<Schema.SObjectField> getSObjectFieldList() {
        return new List<Schema.SObjectField>{
                PrioritySet__c.Id,
                PrioritySet__c.Priority__c,
                PrioritySet__c.Range__c,
                PrioritySet__c.Owner__c
        };
    }
    public Schema.SObjectType getSObjectType() {
        return PrioritySet__c.sObjectType;
    }
    public List<PrioritySet__c> selectById(Set<ID> idSet) {
        return (List<PrioritySet__c>) selectSObjectsById(idSet);
    }

    public List<PrioritySet__c> selectAll() {
        return [
                SELECT
                        Id,
                        Name,
                        Owner__c,
                        Priority__c,
                        Range__c
                FROM PrioritySet__c
                ORDER BY Range__c DESC
                LIMIT 10000
        ];
    }

}