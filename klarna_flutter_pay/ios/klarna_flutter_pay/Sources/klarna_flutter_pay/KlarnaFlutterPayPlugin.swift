import Flutter
import UIKit

public class KlarnaFlutterPayPlugin: NSObject, FlutterPlugin {
  public static func register(with registrar: FlutterPluginRegistrar) {
   
      let factory = KlarnaPayFactory(messenger: registrar.messenger())
      registrar.register(factory,withId: KlarnaPayFactory.viewType)
  }


}
