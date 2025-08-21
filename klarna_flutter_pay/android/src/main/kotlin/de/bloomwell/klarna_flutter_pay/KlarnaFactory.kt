package de.bloomwell.klarna_flutter_pay

import android.content.Context
import com.klarna.mobile.sdk.api.KlarnaEnvironment
import com.klarna.mobile.sdk.api.KlarnaLoggingLevel
import com.klarna.mobile.sdk.api.KlarnaRegion
import com.klarna.mobile.sdk.api.payments.KlarnaPaymentView
import de.bloomwell.klarna_flutter_pay.KlarnaFlutterPayPlugin.Companion.VIEW_TYPE
import io.flutter.plugin.common.BinaryMessenger
import io.flutter.plugin.common.MethodChannel
import io.flutter.plugin.common.StandardMessageCodec
import io.flutter.plugin.platform.PlatformView
import io.flutter.plugin.platform.PlatformViewFactory
import java.util.HashMap

class KlarnaFactory(
    private val binaryMessage: BinaryMessenger,

): PlatformViewFactory(StandardMessageCodec.INSTANCE) {
    override fun create(
        context: Context?,
        viewId: Int,
        args: Any?
    ): PlatformView {
        val argsMap = args as? HashMap<*, *> ?: HashMap<String, Any>()
        
        val klarnaViewPayment: KlarnaPaymentView = KlarnaPaymentView(
            requireNotNull(context),
            returnURL = argsMap["returnURL"] as? String ?: ""
        )
        
        // Configure Klarna payment view
        klarnaViewPayment.region = when(argsMap["region"] as? String) {
            "EU" -> KlarnaRegion.EU
            else -> KlarnaRegion.EU
        }
        
        klarnaViewPayment.environment = when(argsMap["environment"] as? String) {
            "test", "staging" -> KlarnaEnvironment.STAGING
            "production" -> KlarnaEnvironment.PRODUCTION
            else -> KlarnaEnvironment.STAGING
        }
        
        klarnaViewPayment.loggingLevel =  KlarnaLoggingLevel.Verbose
        
        // Extract additional arguments
        val additionalArgs = argsMap.filterKeys { key ->
            key !in listOf("returnURL", "tokenClient", "environment", "region", "loggingLevel")
        }.mapKeys { it.key.toString() }
        
        return KlarnaView(
            requireNotNull(context),
            MethodChannel(binaryMessage,"${VIEW_TYPE}_$viewId"),
            klarnaViewPayment,
            argsMap["tokenClient"] as? String ?: ""
        )
    }

}