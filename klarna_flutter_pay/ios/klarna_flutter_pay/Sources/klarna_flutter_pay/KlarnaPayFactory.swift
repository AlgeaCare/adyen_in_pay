//
//  KlarnaPayFactory.swift
//  Pods
//
//  Created by Mohamed Ali Hamza on 22.08.25.
//
import Flutter

class KlarnaPayFactory : NSObject, FlutterPlatformViewFactory {
    static let viewType:String = "de.bloomwell/klarna_pay"
    
    let messenger:FlutterBinaryMessenger
    init(messenger:FlutterBinaryMessenger) {
        self.messenger = messenger
    }
    
    func create(withFrame frame: CGRect, viewIdentifier viewId: Int64, arguments args: Any?)
      -> FlutterPlatformView
    {
      let argsMaps = args as! [String: Any]
        let methodChannel = FlutterMethodChannel(name: "\(KlarnaPayFactory.viewType)_\(viewId)", binaryMessenger: self.messenger)
      return KlarnaPayView(frame: frame, argsMap: argsMaps, channel: methodChannel)
    }
    public func createArgsCodec() -> FlutterMessageCodec & NSObjectProtocol {
          return FlutterStandardMessageCodec.sharedInstance()
      }
}
