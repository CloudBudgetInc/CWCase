public class AccountJSON {
    public cls_accounts[] accounts;

    public class cls_accounts {
        public String uuid;
        public String company_name;
        public Integer annual_revenue;
        public Integer number_employees;
        public cls_contacts[] contacts;
    }

    public class cls_contacts {
        public String first_name;
        public String last_name;
        public String email;
    }


    /**
     * The method converts cls_accounts to Account object
     */
    public Account getAccount(cls_accounts acc) {
        return new Account(
                Name = acc.company_name,
                AnnualRevenue = acc.annual_revenue,
                NumberOfEmployees = acc.number_employees,
                ExtId__c = acc.uuid
        );
    }
    public List<Contact> getContacts(cls_contacts[] contacts) {
        List<Contact> r = new List<Contact>();
        for (cls_contacts cnt : contacts) {
            Contact newContact = new Contact(FirstName = cnt.first_name, LastName = cnt.last_name, Email = cnt.email);
            r.add(newContact);
        }
        return r;
    }

}