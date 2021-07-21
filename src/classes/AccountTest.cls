/**
 * Created by Alex JR on 7/21/2021.
 */
@isTest
public with sharing class AccountTest {

    static String testJSON = '{' +
            '    "accounts": [{' +
            '        "uuid": "123456-123456",' +
            '        "company_name": "Acme Corp.",' +
            '        "annual_revenue": 120000,' +
            '        "number_employees": 8,' +
            '        "contacts": [{' +
            '            "first_name": "John",' +
            '            "last_name": "Smith",' +
            '            "email": "john@acme.com"' +
            '        }, {' +
            '            "first_name": "Maria",' +
            '            "last_name": "Doe",' +
            '            "email": "maria@acme.com"' +
            '        }]' +
            '    }]' +
            '}';

    @isTest
    static void testCreateAccounts() {
        RestRequest request = new RestRequest();
        request.requestUri = 'https://d5e000002rloseak-dev-ed.lightning.force.com/services/apexrest/Accounts/';
        request.httpMethod = 'POST';
        request.requestBody = Blob.valueof(testJSON);
        RestContext.request = request;

        AccountRESTManager.createAccounts();
    }

}