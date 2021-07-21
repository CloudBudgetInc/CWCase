/**
 * Created by Alex JR on 7/20/2021.
 */

public with sharing class AccountDomain extends fflib_SObjectDomain {

    public AccountDomain(List<Account> sObjectList) {
        super(sObjectList);
    }
    public class Constructor implements fflib_SObjectDomain.IConstructable {
        public fflib_SObjectDomain construct(List<SObject> sObjectList) {
            return new AccountDomain(sObjectList);
        }
    }

    public override void onBeforeInsert() {
        AccountService.manageAccounts(Records, new PrioritySetSelector().selectAll());
    }

    public override void onBeforeUpdate(Map<Id, SObject> existingRecords) {
        AccountService.manageAccounts(Records, new PrioritySetSelector().selectAll());
    }

}