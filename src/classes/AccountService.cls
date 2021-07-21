/**
 * Created by Alex JR on 7/21/2021.
 */

public with sharing class AccountService {

    /**
     * The method updates the priority and the record owner depending on the annual revenue
     */
    public static void manageAccounts(List<Object> Records, List<PrioritySet__c> prioritySet) {
        for (Account acc : (List <Account>) Records) {
            for (PrioritySet__c pSet : prioritySet) {
                if (acc.AnnualRevenue > pSet.Range__c) {
                    acc.Priority__c = pSet.Priority__c;
                    acc.OwnerId = pSet.Owner__c; 
                    break;
                }
            }
        }
    }

    public void upsertAccountsWithContacts(AccountJSON accountJSON, fflib_SObjectUnitOfWork uow) {
        Map<String, Id> accountTracingMap = getAccountTracingMap();
        Map<String, Id> contactTracingMap = getContactTracingMap();

        if (uow == null) uow = new fflib_SObjectUnitOfWork(new Schema.SObjectType[]{
                Account.SObjectType, Contact.SObjectType
        });

        for (AccountJSON.cls_accounts acc : accountJSON.accounts) {
            Account account = AccountJSON.getAccount(acc);
            account.Id = accountTracingMap.get(account.ExtId__c);
            uow.registerUpsert(account);
            for (Contact cnt : AccountJSON.getContacts(acc.contacts)) {
                cnt.Id = contactTracingMap.get(cnt.Email);
                uow.registerRelationship(cnt, Contact.AccountId, account);
                uow.registerUpsert(cnt);
            }
        }
    }

    /**
     * key = external Id, value = SF Id
     */
    private static Map<String, Id> getAccountTracingMap() {
        Map<String, Id> r = new Map<String, Id>();
        for (Account acc : [SELECT Id, ExtId__c FROM Account WHERE ExtId__c != null]) {
            r.put(acc.ExtId__c, acc.Id);
        }
        return r;
    }
    /**
     * key = external Id, value = SF Id
     */
    private static Map<String, Id> getContactTracingMap() {
        Map<String, Id> r = new Map<String, Id>();
        for (Contact cnt : [SELECT Id, Email FROM Contact WHERE Email != null]) {
            r.put(cnt.Email, cnt.Id);
        }
        return r;
    }

}