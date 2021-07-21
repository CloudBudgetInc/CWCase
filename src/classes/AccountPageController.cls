/**
 * Created by Alex JR on 7/20/2021.
 */

public with sharing class AccountPageController {

    @AuraEnabled
    public static List<Account> getListOfAccountsServer(Integer numberOfRecords, Integer offset, String textFilter) {
        return new AccountSelector().getListOfAccounts(numberOfRecords, offset, textFilter);
    }

}