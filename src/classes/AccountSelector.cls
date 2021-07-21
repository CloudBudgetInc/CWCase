/**
 * Created by Alex JR on 7/20/2021.
 */

public with sharing class AccountSelector extends fflib_SObjectSelector {

    public List<Schema.SObjectField> getSObjectFieldList() { 
        return new List<Schema.SObjectField>{
                Account.Id,
                Account.Name,
                Account.ExtId__c,
                Account.AnnualRevenue,
                Account.NumberOfEmployees,
                Account.Priority__c,
                Account.Description
        };
    }
    public Schema.SObjectType getSObjectType() {
        return Account.sObjectType;
    }
    public override String getOrderBy() {
        return 'Name';
    }
    public List<Account> selectById(Set<ID> idSet) {
        return (List<Account>) selectSObjectsById(idSet);
    }

    public List<Account> getListOfAccounts(Integer numberOfRecords, Integer offset, String textFilter) {
        if (numberOfRecords == null || numberOfRecords < 1) numberOfRecords = 1000;
        if (offset == null || offset < 1) offset = 0;
        fflib_QueryFactory query = newQueryFactory();
        query.selectField('Owner.Name');
        if (!String.isBlank(textFilter))query.setCondition(' Name LIKE \'%' + textFilter + '%\' ');
        query.setOffset(offset);
        query.setLimit(numberOfRecords);
        new ContactSelector().addQueryFactorySubSelect(query, 'Contacts');
        return Database.query(query.toSOQL());
    }


}