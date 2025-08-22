package de.bloomwell.klarna_flutter_pay

import androidx.lifecycle.Lifecycle
import io.flutter.embedding.engine.plugins.FlutterPlugin
import io.flutter.embedding.engine.plugins.activity.ActivityAware
import io.flutter.embedding.engine.plugins.activity.ActivityPluginBinding
import io.flutter.embedding.engine.plugins.lifecycle.FlutterLifecycleAdapter


/** KlarnaFlutterPayPlugin */
class KlarnaFlutterPayPlugin :
    FlutterPlugin, ActivityAware
     {
    companion object {
        const val VIEW_TYPE= "de.bloomwell/klarna_pay"
    }
    var klarnaFactoryView: KlarnaFactory? = null
         var lifecycle: Lifecycle? = null
    override fun onAttachedToEngine(flutterPluginBinding: FlutterPlugin.FlutterPluginBinding) {
        klarnaFactoryView = KlarnaFactory(binaryMessage = flutterPluginBinding.binaryMessenger,
            provider = object : LifecycleProvider {
                override fun getLifecycle(): Lifecycle? {
                    return  lifecycle
                }
            })
        flutterPluginBinding.platformViewRegistry.registerViewFactory(
            VIEW_TYPE,klarnaFactoryView!!
        )
    }



    override fun onDetachedFromEngine(binding: FlutterPlugin.FlutterPluginBinding) {
        klarnaFactoryView = null
    }

    override fun onAttachedToActivity(binding: ActivityPluginBinding) {
        lifecycle = FlutterLifecycleAdapter.getActivityLifecycle(binding)
    }

    override fun onDetachedFromActivityForConfigChanges() {

    }

    override fun onReattachedToActivityForConfigChanges(binding: ActivityPluginBinding) {

    }

    override fun onDetachedFromActivity() {

    }
}
interface LifecycleProvider {
    fun getLifecycle(): Lifecycle?
}
