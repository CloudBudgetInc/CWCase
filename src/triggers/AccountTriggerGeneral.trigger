trigger AccountTriggerGeneral on Account (after delete, after insert, after update, after undelete, before delete, before insert, before update) {

    fflib_SObjectDomain.triggerHandler(AccountDomain.class);

}