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
        onPaymentDone(this.viewId, JSON.stringify({
            result: result,
        }));
    }
    async payment(data) {
        let result = await onPayment(this.viewId, JSON.stringify({
            result: data,
        }));
        return result;
    }
    async paymentDetail(data) {
        let result = await onPaymentDetail(this.viewId, JSON.stringify({
            result: data,
        }));
        return result;
    }
    paymentError(errorMsg) {
        onPaymentError(this.viewId, errorMsg);
    }

}