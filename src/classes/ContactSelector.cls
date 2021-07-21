/**
 * Created by Alex JR on 7/20/2021.
 */

public with sharing class ContactSelector extends fflib_SObjectSelector {
    public List<Schema.SObjectField> getSObjectFieldList() {
        return new List<Schema.SObjectField>{
                Contact.Id,
                Contact.FirstName,
                Contact.LastName,
                Contact.Email
        };
    }
    public Schema.SObjectType getSObjectType() {
        return Contact.sObjectType;
    }
    public List<Contact> selectById(Set<ID> idSet) {
        return (List<Contact>) selectSObjectsById(idSet);
    }
}