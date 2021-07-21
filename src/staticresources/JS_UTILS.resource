window._CBMessages = (function (messageText) {
    return {
        fireErrorMessage: function (messageText, header) {
            let resultsToast = $A.get("e.force:showToast");
            resultsToast.setParams({
                title: header == null ? messageHeader.other : header,
                message: messageText,
                duration: '7000',
                type: 'error',
                mode: 'dismissible'
            });
            resultsToast.fire();
            return 'OK'
        },
        fireWarningMessage: function (messageText, header) {
            let resultsToast = $A.get("e.force:showToast");
            resultsToast.setParams({
                title: header == null ? messageHeader.other : header,
                message: messageText,
                duration: '7000',
                type: 'warning',
                mode: 'dismissible'
            });
            resultsToast.fire();
            return 'OK'
        },
        fireOtherMessage: function (messageText, header) {
            let resultsToast = $A.get("e.force:showToast");
            resultsToast.setParams({
                title: header == null ? messageHeader.other : header,
                message: messageText,
                duration: '4000',
                type: 'info',
                mode: 'dismissible'
            });
            resultsToast.fire();
            return 'OK'
        }, //
        fireSuccessMessage: function (messageText, header) {
            let resultsToast = $A.get("e.force:showToast");
            resultsToast.setParams({
                title: header == null ? messageHeader.other : header,
                message: messageText,
                duration: '4000',
                type: 'success',
                mode: 'dismissible'
            });
            resultsToast.fire();
            return 'OK'
        }
    };
}());

let messageHeader = {
    error: 'Ooops...',
    success: 'Success',
    other: 'Note!',
    warning: 'Warning'
};


window._CBRedirect = (function (pageName, params) {
    return {
        toComponent: function (pageName, params) { // 'c:BudgetApplicationSheet', {'recordId': cmp.get("v.app.Id")}
            let evt = $A.get("e.force:navigateToComponent");
            _cl("CMP name is " + pageName, 'DeepSkyBlue');
            _cl("CMP attributes are " + JSON.stringify(params), 'DeepSkyBlue');
            evt.setParams({
                componentDef: pageName,
                componentAttributes: params,
                isredirect: true
            });
            evt.fire();
        },
        toListView: function (pageName, params) { // pageName = null
            let evt = $A.get("e.force:navigateToList");
            evt.setParams({
                "listViewId": params.listViewId, //The ID of the list view to be displayed
                "listViewName": params.listViewName, //Specifies the name for the list view and doesn't need to match the actual name. To use the actual name that's saved for the list view, set listViewName to null.
                "scope": params.scope //The name of the sObject in the view, for example, 'Account' or 'MyObject__c'
            });
            evt.fire();
        },
        toSObject: function (pageName, params) { // object Id, additional params
            let evt = $A.get("e.force:navigateToSObject");
            if (params == null) params = {};
            params.recordId = pageName;
            params.isredirect = true;
            evt.setParams(params);
            evt.fire();
        },
        toURL: function (pageName, params) {
            let evt = $A.get("e.force:navigateToURL");
            evt.setParams({
                "url": pageName
            });
            evt.fire();
        }
    };
}());

/**
 It will cover cases where value was never defined, and also any of these:
 -null
 -undefined (value of undefined is not the same as a parameter that was never defined)
 -0
 -"" (empty string)
 -false
 -NaN
 */
window._isInvalid = (function (t) {
        return (t === undefined || !t || t === 'undefined');
    }
);

window._isInvalidNumber = (function (t) {
        return (t === undefined || t === null || t === "" || isNaN(t));
    }
);

window._cleanObject = (function (o) {
        for (let p in o) if (_isInvalid(o[p])) delete o[p];
    }
);

window._cleanArray = (function (a) {
        for (let i = 0; i < a.length; i++) _cleanObject(a[i]);
    }
);

function clean(arr) {
    for (let i = 0; i < arr.length; i++) {
        let obj = arr[i];
        for (let propName in obj) {
            if (obj[propName] === "" || obj[propName] === null || obj[propName] === undefined) {
                delete obj[propName];
            } else {

            }
        }
    }

}

/**
 * function (cmp, mName, params, attr, callback, success, error)
 * 1. cmp - component
 * 2. mName - server method name
 * 3. params - an object with parameters
 * 4. attr - response attribute ("v.approvingIsAllowed")
 * 5. callback - some function
 * 6. success - success message
 * 7. error - error message
 * 8. spinner - true or null if need to show hide spinner
 */
window._CBRequest = (function (cmp, mName, params, attr, callback, success, error, spinner) {
        try {
            if (!_isInvalid(spinner) && spinner) _showSpinner(cmp);
            let a = cmp.get(mName);
            if (!_isInvalid(params)) a.setParams(params);
            a.setCallback(this, function (response) {
                if (response.getState() === "SUCCESS") {
                    if (!_isInvalid(attr)) cmp.set(attr, response.getReturnValue());
                    if (!_isInvalid(success)) _CBMessages.fireSuccessMessage(success);
                    if (!_isInvalid(callback)) callback(cmp, response);
                } else {
                    _RequestError(response, mName);
                    if (!_isInvalid(error)) _CBMessages.fireWarningMessage(error);
                    _hideSpinner(cmp);
                }
                if (!_isInvalid(spinner) && spinner) _hideSpinner(cmp);
            });
            $A.enqueueAction(a);
        } catch (e) {
            alert('window._CBRequest ' + e);
        }
    }
);

/**
 * The method displays Spinner
 ********************************************************
 * <lightning:spinner aura:id="sms" class="slds-hide"/>
 ********************************************************
 * .THIS .slds-spinner_container {
 *      z-index: 10000;
 *      position: fixed;
 * }
 *********************************************************
 */
window._showSpinner = (function (cmp) {
        try {
            document.getElementById("spinnerDiv").style = "display:";
        } catch (e) {
        }
        try {
            let sms = cmp.find("sms");
            $A.util.removeClass(sms, "slds-hide");
        } catch (e) {
        }
    }
);

window._hideSpinner = (function (cmp) {
        try {
            document.getElementById("spinnerDiv").style = "display:none";
        } catch (e) {
        }
        try {
            let sms = cmp.find("sms");
            $A.util.addClass(sms, "slds-hide");
        } catch (e) {
        }
    }
);

/**
 * getting list of CBTag__c from server with settings for current user's groups
 * * */
window._getCurrentUserSettings = (function (cmp, hideSpinner) {
        _showSpinner('_getCurrentUserSettings');
        try {
            let moduleName = cmp.get("v.moduleName");
            if (hideSpinner === undefined) {
                hideSpinner = false;
            }
            _CBRequest(cmp, "c.getCurrentUserInterfaceSettingsListServer", {"componentName": moduleName}, null, _handleSettings, null, null, hideSpinner);
        } catch (e) {
            alert('_getCurrentUserSettings: ' + e);
        }
    }
);
/**
 * creating one settings obj for current user (merge all his groups settings into one, with maximum visibility of interface)
 * and after that creating obj witch contains fields with classes for interface elements ('slds-hide' or empty)
 * sending this obj to page
 * * */
window._handleSettings = (function (cmp, response) {
        try {
            let settingsObjList = response.getReturnValue();
            let settingsObj = {};
            if (settingsObjList !== undefined && settingsObjList !== null && settingsObjList.length > 0) {
                settingsObjList.forEach(function (settingsString) {
                    let settings = JSON.parse(settingsString);
                    Object.keys(settings).forEach(function (key, index) {
                        let tempValue = settingsObj[key];
                        if (tempValue !== undefined) {
                            if (tempValue['value'] === false) {
                                settingsObj[key] = settings[key];
                            }
                        } else {
                            settingsObj[key] = settings[key];
                        }
                    });
                });
            } else {
            }
            let processedSettingsObj = {};
            let moduleName = cmp.get("v.moduleName");
            Object.keys(settingsObj).forEach(function (key) {
                if (settingsObj[key]['value']) {
                    processedSettingsObj[key] = moduleName + ' ' + key;
                } else {
                    processedSettingsObj[key] = moduleName + ' ' + key + ' slds-hide';
                }
            });
            cmp.set("v.settingsObj", processedSettingsObj);
        } catch (e) {
            alert('_handleSettings: ' + e);
        }
    }
);

/**
 * _RequestError(serverResponse, _TEXT.FF_INTEGRATION.FAILED_RUN_INTEGRATION);
 */
window._RequestError = (function (response, message, cmp) {
    let errors = response.getError();
    if (errors) {
        if (errors[0] && errors[0].message) _CBMessages.fireErrorMessage(message + ': ' + errors[0].message + ', exceptionType: ' + errors[0].exceptionType + ', stackTrace: ' + errors[0].stackTrace);
    } else {
        _CBMessages.fireErrorMessage(message);
    }
    _hideSpinner(cmp);
});

window._dragElement = (function (elementId) {
    try {

        if (_isInvalid(elementId)) elementId = "dragDiv";
        dragElement(document.getElementById(elementId));

        function dragElement(elmnt) {
            let pos1 = 0, pos2 = 0, pos3 = 0, pos4 = 0;
            if (document.getElementById(elmnt.id + "Header")) {
                document.getElementById(elmnt.id + "Header").onmousedown = dragMouseDown;
            } else elmnt.onmousedown = dragMouseDown;

            function dragMouseDown(e) {
                e = e || window.event;
                e.preventDefault();
                pos3 = e.clientX;
                pos4 = e.clientY;
                document.onmouseup = closeDragElement;
                document.onmousemove = elementDrag;
            }

            function elementDrag(e) {
                e = e || window.event;
                e.preventDefault();
                pos1 = pos3 - e.clientX;
                pos2 = pos4 - e.clientY;
                pos3 = e.clientX;
                pos4 = e.clientY;
                elmnt.style.top = (elmnt.offsetTop - pos2) + "px";
                elmnt.style.left = (elmnt.offsetLeft - pos1) + "px";
            }

            function closeDragElement() {
                document.onmouseup = null;
                document.onmousemove = null;
            }
        }
    } catch (e) {
        _cl('Drag library error: ' + e);
    }
});

/**
 *
 * message - some text
 * color - some color like "red"
 */
window._cl = (function (message, color) {
    try {
        /*if (typeof message === "object") message = message.toString();
        console.log('%c🌩️ ' + message, 'color:' + color + '; ' +
            'font: 1 Tahoma; ' +
            'font-size: 1.2em; ' +
            'font-weight: bolder; ' +
            'padding: 2px;');*/
    } catch (e) {

    }
});
/**
 * @param s length of the truncation 
 */
String.prototype.truncate = function (s) {
    if (this === null) return '';
    let r = this.match(new RegExp("^.{0," + (s == null ? 30 : s) + "}[\S]*"));
    let l = r[0].length;
    r = r[0].replace(/\s$/, '');
    r = l < this.length ? r + "…" : r;
    return r;
};

String.prototype.toConsole = function (s) {
    _cl(this);
};

window._ABC = ['A', 'B', 'C', 'D', 'E', 'F', 'G', 'H', 'I', 'J', 'K', 'L', 'M', 'N', 'O', 'P', 'Q', 'R', 'S', 'T', 'U', 'V', 'W', 'X', 'Y', 'Z',
    'AA', 'AB', 'AC', 'AD', 'AE', 'AF', 'AG', 'AH', 'AI', 'AJ', 'AK', 'AL', 'AM', 'AN', 'AO', 'AP', 'AQ', 'AR', 'AS', 'AT', 'AU', 'AV', 'AW', 'AX', 'AY', 'AZ'];

