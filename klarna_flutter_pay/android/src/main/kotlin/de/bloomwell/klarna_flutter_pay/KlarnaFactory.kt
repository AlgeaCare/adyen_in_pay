package de.bloomwell.klarna_flutter_pay

import android.content.Context
import androidx.lifecycle.Lifecycle
import com.klarna.mobile.sdk.api.KlarnaEnvironment
import com.klarna.mobile.sdk.api.KlarnaLoggingLevel
import com.klarna.mobile.sdk.api.KlarnaProduct
import com.klarna.mobile.sdk.api.KlarnaRegion
import com.klarna.mobile.sdk.api.KlarnaResourceEndpoint
import com.klarna.mobile.sdk.api.payments.KlarnaPaymentView
import com.klarna.mobile.sdk.api.payments.KlarnaPaymentViewCallback
import com.klarna.mobile.sdk.api.payments.KlarnaPaymentsSDKError
import com.klarna.mobile.sdk.api.postpurchase.KlarnaPostPurchaseSDK
import de.bloomwell.klarna_flutter_pay.KlarnaFlutterPayPlugin.Companion.VIEW_TYPE
import io.flutter.plugin.common.BinaryMessenger
import io.flutter.plugin.common.MethodChannel
import io.flutter.plugin.common.StandardMessageCodec
import io.flutter.plugin.platform.PlatformView
import io.flutter.plugin.platform.PlatformViewFactory
import java.util.HashMap

class KlarnaFactory(
    private val binaryMessage: BinaryMessenger,
    private val provider: LifecycleProvider

): PlatformViewFactory(StandardMessageCodec.INSTANCE) {

    override fun create(
        context: Context?,
        viewId: Int,
        args: Any?
    ): PlatformView {

        val argsMap = args as? HashMap<*, *> ?: HashMap<String, Any>()
        return KlarnaView(
            requireNotNull(context),
            MethodChannel(binaryMessage,"${VIEW_TYPE}_$viewId"),
            argsMap,
            argsMap["tokenClient"] as? String ?: "",
            provider
        )
    }

}