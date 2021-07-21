/**
 * Created by Alex JR on 7/20/2021.
 */
@RestResource(urlMapping='/Accounts/*')
global with sharing class AccountRESTManager { 


    @HttpPost
    global static void createAccounts() {
        try {
            String restJSON = RestContext.request.requestBody.toString();
            AccountJSON parsedAccounts = (AccountJSON) System.JSON.deserialize(restJSON, AccountJSON.class);
            fflib_SObjectUnitOfWork uow = new fflib_SObjectUnitOfWork(new Schema.SObjectType[]{
                    Account.SObjectType, Contact.SObjectType
            });
            new AccountService().upsertAccountsWithContacts(parsedAccounts, uow);
            uow.commitWork();
        } catch (Exception e) {
            RestResponse res = RestContext.response;
            res.statusCode = 500;
            String jsonResponse = '{"response": {"status": "Failure", "message": "' + e + '"}}';
            res.responseBody = blob.valueOf(jsonResponse);
        }
    }


}