({
    helpInitVariables: function (cmp) {
        cmp.set("v.columns", this.columns);
        cmp.set("v.numberOfRecords", this.numberOfRecords);
        cmp.set("v.offset", this.offset);
    },

    helpGetListOfAccounts: function (cmp) {
        _showSpinner(cmp);
        const postMethod = () => {
            let accounts = cmp.get("v.accounts");
            accounts.forEach(acc => acc.OwnerName = acc.Owner.Name);
            cmp.set("v.accounts", accounts);
        };
        const params = this.helpPrepareAndGetMainTableParams(cmp);
        if (_isInvalid(params)) return null;
        _CBRequest(cmp, "c.getListOfAccountsServer", params, "v.accounts", postMethod, null, 'Failed to get the accounts list', true);
    },

    helpPrepareAndGetMainTableParams: function (cmp) {
        try {
            const numberOfRecords = cmp.get("v.numberOfRecords");
            const offset = cmp.get("v.offset");
            const textFilter = cmp.get("v.textFilter");
            console.log(`numberOfRecords: ${numberOfRecords} & Offset: ${offset} & TextFilter: ${textFilter} `, 'yellow');
            if (numberOfRecords == null || offset == null || numberOfRecords < 1 || offset < 0) {
                _CBMessages.fireErrorMessage('Please put correct numberOfRecords and offset');
                _hideSpinner(cmp);
                return null
            }
            return {
                'numberOfRecords': numberOfRecords,
                'offset': offset,
                'textFilter': textFilter
            };
        } catch (e) {
            _CBMessages.fireErrorMessage('Validation Error: ' + e);
            _hideSpinner(cmp);
        }
    },

    helpSwitchPage: function (cmp, pageNumber) {
        const numberOfRecords = cmp.get("v.numberOfRecords");
        let offset = pageNumber * numberOfRecords;
        if (pageNumber < 0) {
            pageNumber = 0;
            offset = 0;
        }
        if (offset >= 3000) {
            _CBMessages.fireWarningMessage('No more pages');
            return;
        }
        cmp.set("v.offset", offset);
        cmp.set("v.pageNumber", pageNumber);
        this.helpGetListOfAccounts(cmp);
    },

    helpHandleTableButtons: function (cmp, event) {
        const action = event.getParam('action');
        const row = event.getParam('row');
        switch (action.name) {
            case 'getDetails':
                try {
                    this.helpDisplayAccountDialog(cmp);
                    const accounts = cmp.get("v.accounts");
                    const account = accounts.find(acc => acc.Id === row.Id);
                    console.log(JSON.stringify(account));
                    cmp.set("v.account", account);
                } catch (e) {
                    _CBMessages.fireErrorMessage(e);
                }
                break;
        }
    },

    helpDisplayAccountDialog: function (cmp) {
        $A.util.removeClass(cmp.find('accountDialog'), 'slds-hide');
    },

    helpHideAccountDialog: function (cmp) {
        $A.util.addClass(cmp.find('accountDialog'), 'slds-hide');
    },

    ////// DEFAULT PARAMETERS
    columns: [
        {
            type: "button",
            label: '',
            initialWidth: 250,
            typeAttributes: {
                fieldName: 'Id',
                label: {fieldName: 'Name'},
                variant: 'base',
                name: 'getDetails',
                value: 'test',
                title: 'Click to Edit'
            }
        },
        {label: 'External Number', fieldName: 'ExtId__c'},

        {label: 'Priority', fieldName: 'Priority__c', type: 'text'},
        {label: 'Number of Employees', fieldName: 'NumberOfEmployees', type: 'number'},

        {
            label: 'Annual Revenue',
            fieldName: 'AnnualRevenue',
            type: 'currency',
            typeAttributes: {currencyCode: 'EUR', maximumSignificantDigits: 2}
        },
        {label: 'Owner', fieldName: 'OwnerName'},
        {label: 'Description', fieldName: 'Description'},
    ],
    offset: 0, // the number of the start position
    numberOfRecords: 1000, // the number on records in the main table
});