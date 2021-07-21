({
    doInit: function (cmp, event, helper) {
        helper.helpInitVariables(cmp);
        helper.helpGetListOfAccounts(cmp);
    },

    refreshMainTable: function (cmp, event, helper) {
        helper.helpGetListOfAccounts(cmp);
    },

    handleKeyUp: function (cmp, event, helper) {
        if (event.keyCode === 13) {
            helper.helpGetListOfAccounts(cmp);
        }
    },

    handleRowAction: function (cmp, event, helper) {
        helper.helpHandleTableButtons(cmp, event);
    },
    closeAccountDialog: function (cmp, event, helper) {
        helper.helpHideAccountDialog(cmp);
    },

    goToPreviousPage: function (cmp, event, helper) {
        let pageNumber = cmp.get("v.pageNumber") - 1;
        helper.helpSwitchPage(cmp, pageNumber);
    },

    goToNextPage: function (cmp, event, helper) {
        const pageNumber = cmp.get("v.pageNumber") - 0 + 1;
        helper.helpSwitchPage(cmp, pageNumber);
    }


});