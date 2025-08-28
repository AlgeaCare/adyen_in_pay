//
//  KlarnaPayView.swift
//  Pods
//
//  Created by Mohamed Ali Hamza on 22.08.25.
//
import Flutter
import KlarnaMobileSDK

class KlarnaPayView:NSObject, FlutterPlatformView, KlarnaPaymentEventListener {
    
    let frameView: UIView
    let methodChannel:FlutterMethodChannel
    var paymentView: KlarnaPaymentView?
    var authToken: String?
    var isApproved: Bool?
    let args:[String:Any]
    init(frame: CGRect,argsMap:[String: Any], channel: FlutterMethodChannel) {
        frameView = UIView(frame: frame)
        methodChannel = channel
        args = argsMap
        super.init()
    }
    
    public func view() -> UIView {
        if(self.paymentView == nil){
            let categoryKlarna = args["category"] as? String ?? "klarna"
            let returnURL = self.args["returnURL"] as! String
            self.paymentView = KlarnaPaymentView.init(category: categoryKlarna, returnUrl: URL(string: returnURL)!,eventListener: self)
            
            self.paymentView!.translatesAutoresizingMaskIntoConstraints = false
            self.paymentView!.region = .eu
            self.paymentView!.environment = if ((self.args["environment"] as? String ) == "sandbox" || (self.args["environment"] as? String) == "staging" ) { KlarnaEnvironment.staging } else { KlarnaEnvironment.production }
            
            // Add as subview
            self.frameView.addSubview(paymentView!)
           
            // Create a height constraint that we'll update as its height changes.
            // self.paymentViewHeightConstraint = paymentView.heightAnchor.constraint(equalToConstant: 0)
            // paymentViewHeightConstraint.isActive = true
            let tokenClient = self.args["tokenClient"] as! String
            self.paymentView!.loggingLevel = .verbose
            self.paymentView!.initialize(clientToken: tokenClient)
        }
      return frameView
    }
    func klarnaResized(paymentView: KlarnaPaymentView, to newHeight: CGFloat) {
        
    }
    func klarnaInitialized(paymentView: KlarnaPaymentView) {
        self.sendToFlutter(
            method: "initKlarna",data: [
                    "initialized": true,
                    "ready" : true
                   ]
               )
        paymentView.load()
        paymentView.authorize(autoFinalize: true) // optionally load payment widget upon initialize
    }
    func klarnaAuthorized(paymentView: KlarnaPaymentView, approved: Bool, authToken: String?, finalizeRequired: Bool) {
        if let token = authToken, approved {
            // authorization is successful, backend may create order
            self.authToken = token
            self.isApproved = approved
            paymentView.finalise()
        }else {
            self.sendToFlutter(method: "finishKlarna", data: [
                "authToken": "",
                "approved": false
            ])

        }
        
       
    }

    func klarnaFailed(inPaymentView paymentView: KlarnaPaymentView, withError error: KlarnaPaymentError) {
        self.sendToFlutter(
            method: "errorKlarna",data: [
                "message": error.message,
                   ]
               )
    }
    func klarnaLoaded(paymentView: KlarnaPaymentView) {
        
    }
    func klarnaLoadedPaymentReview(paymentView: KlarnaPaymentView) {
        
    }
    func klarnaFinalized(paymentView: KlarnaPaymentView, approved: Bool, authToken: String?) {
        self.sendToFlutter(method: "finishKlarna", data: [
            "authToken": authToken ?? "",
            "approved": approved
        ])
    }
    func klarnaReauthorized(paymentView: KlarnaPaymentView, approved: Bool, authToken: String?) {
        
    }
    
    func sendToFlutter(method:String, data:Any?) {
        methodChannel.invokeMethod(method, arguments: data)
    }
    
}
