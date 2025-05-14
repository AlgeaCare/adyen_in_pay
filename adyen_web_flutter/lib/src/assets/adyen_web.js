
async function init(viewID, clientKey, sessionId, sessionData, env, redirectURL, amount, currency) {
    var innerWindow = getIframe(viewID).contentWindow;
    await innerWindow.init(clientKey, sessionId, sessionData, env, redirectURL, amount, currency);
    return 200;
}
async function initAdvanced(viewID, clientKey, env, redirectURL, amount, currency) {
    var innerWindow = getIframe(viewID).contentWindow;
    await innerWindow.initAdvanced(clientKey, env, redirectURL, amount, currency);
    return 200;
}
async function redirectResultAdvanced(viewID, sessionId, redirectResult) {
    var innerWindow = getIframe(viewID).contentWindow;
    await innerWindow.redirectResultAdvanced(clientKey, sessionId, redirectResult);
    return 200;
}
async function redirectResult(viewID, sessionId, redirectResult) {
    var innerWindow = getIframe(viewID).contentWindow;
    await innerWindow.redirectResult(clientKey, sessionId, redirectResult);
    return 200;
}
async function setUpJS(viewID) {
    const vJS = new AdyenPayJS(viewID);
    adyenLinks.set(viewID, vJS);
    console.log("getIframe")
    var innerWindow = getIframe(viewID).contentWindow;
    console.log(innerWindow)
    innerWindow.onStarted = () => {
        adyenLinks.get(viewID).onStarted()
    };
    innerWindow.onPayment = async (data) => {
        try {
            let result = await adyenLinks.get(viewID).payment(data);
            return result;
        } catch (e) {
            throw (e);
        }
    };
    innerWindow.onPaymentDetail = async (data) => {
        try {
            let result = await adyenLinks.get(viewID).paymentDetail(data);
            return result;
        } catch (e) {
            throw (e);
        }
    };
    innerWindow.paymentDone = (result) => {
        try {
            adyenLinks.get(viewID).paymentDone(result)
        } catch (e) {
            console.error(e);
        }
    };
    innerWindow.paymentError = (errorMsg) => { adyenLinks.get(viewID).paymentError(errorMsg) };
    console.log("done")
    return 200;
}

function getIframe(viewID) {
    var iframe = document.getElementById("adyen_bloomweel_" + viewID).firstChild;
    return iframe;
}