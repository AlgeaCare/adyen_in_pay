var adyenLinks = new Map();
class AdyenPayJS {
    constructor(viewId) {
        this.viewId = viewId;
    }
    /*
    * shared dart function that called from js
    */
    onStarted() {
        onStarted(this.viewId);
    }
    paymentDone(result) {
        console.log('from js')
        onPaymentDone(this.viewId, JSON.stringify({
            result: result,
        }));
    }
    paymentError(errorMsg) {
        onPaymentError(this.viewId, errorMsg);
    }

}