package de.bloomwell.klarna_flutter_pay

import android.content.Context
import android.util.Log
import android.view.View
import android.view.ViewGroup
import android.view.ViewGroup.LayoutParams.MATCH_PARENT
import android.view.ViewGroup.LayoutParams.WRAP_CONTENT
import android.widget.FrameLayout
import android.widget.LinearLayout
import android.widget.Toast
import androidx.core.view.children
import androidx.lifecycle.DefaultLifecycleObserver
import androidx.lifecycle.Lifecycle
import androidx.lifecycle.LifecycleOwner
import com.klarna.mobile.sdk.KlarnaMobileSDKError
import com.klarna.mobile.sdk.api.KlarnaEnvironment
import com.klarna.mobile.sdk.api.KlarnaEventHandler
import com.klarna.mobile.sdk.api.KlarnaLoggingLevel
import com.klarna.mobile.sdk.api.KlarnaProduct
import com.klarna.mobile.sdk.api.KlarnaProductEvent
import com.klarna.mobile.sdk.api.KlarnaRegion
import com.klarna.mobile.sdk.api.component.KlarnaComponent
import com.klarna.mobile.sdk.api.payments.KlarnaPaymentView
import com.klarna.mobile.sdk.api.payments.KlarnaPaymentViewCallback
import com.klarna.mobile.sdk.api.payments.KlarnaPaymentsSDKError
import io.flutter.plugin.common.MethodCall
import io.flutter.plugin.common.MethodChannel
import io.flutter.plugin.platform.PlatformView

class KlarnaView(
    val context: Context,
    val methodChannel: MethodChannel,
    private val argsMap: HashMap<*,*>,
    private val tokenClient: String,
    private val  provider:LifecycleProvider,
) : PlatformView, MethodChannel.MethodCallHandler, KlarnaPaymentViewCallback, KlarnaEventHandler,
    DefaultLifecycleObserver {
    var klarnaViewPayment: KlarnaPaymentView? = null
    /*val klarnaViewPayment: KlarnaPaymentView = KlarnaPaymentView(
        context,
        returnURL = ""
    )*/
    val frameLayout = FrameLayout(context).apply {
        this.layoutParams =
            FrameLayout.LayoutParams(FrameLayout.LayoutParams(WRAP_CONTENT, WRAP_CONTENT))
    }


    init {
        methodChannel.setMethodCallHandler(this)
        provider.getLifecycle()?.addObserver(this)
    }

    override fun getView(): View? {
        return frameLayout
    }

    override fun dispose() {
        provider.getLifecycle()?.removeObserver(this)
        klarnaViewPayment?.unregisterPaymentViewCallback(this)
        klarnaViewPayment?.finalize(null)
        frameLayout.removeAllViews()
    }

    override fun onCreate(owner: LifecycleOwner) {
        super.onCreate(owner)
        val returnURL = argsMap["returnURL"] as? String ?: ""
        Toast.makeText(context,"created klarna native", Toast.LENGTH_SHORT).show()
        klarnaViewPayment = KlarnaPaymentView(
            requireNotNull(context),
            returnURL = returnURL,
        )
        klarnaViewPayment!!.registerPaymentViewCallback(this)
        klarnaViewPayment!!.eventHandler = this

        // Configure Klarna payment view
        klarnaViewPayment!!.region = when(argsMap["region"] as? String) {
            "EU" -> KlarnaRegion.EU
            else -> KlarnaRegion.EU
        }
        klarnaViewPayment!!.category = argsMap["category"] as? String ?: "klarna"
        klarnaViewPayment!!.environment = when(argsMap["environment"] as? String) {
            "test", "staging" -> KlarnaEnvironment.STAGING
            "production" -> KlarnaEnvironment.PRODUCTION
            else -> KlarnaEnvironment.STAGING
        }

        klarnaViewPayment!!.loggingLevel =  KlarnaLoggingLevel.Verbose
        if (!frameLayout.children.contains(klarnaViewPayment!!)) {
            klarnaViewPayment!!.layoutParams = ViewGroup.LayoutParams(
                LinearLayout.LayoutParams(WRAP_CONTENT, WRAP_CONTENT)
            )
            frameLayout.addView(klarnaViewPayment)
        }
        // Initialize with client token
        klarnaViewPayment!!.initialize(
            tokenClient,
            returnURL = returnURL
        )

        // Send initialization event to Flutter
        sendEventToFlutter(
            "initializingKlarna", mapOf(
                "clientToken" to tokenClient
            )
        )
    }

    private fun sendEventToFlutter(eventName: String, data: Any?) {
        try {
            methodChannel.invokeMethod(eventName, data)
        } catch (e: Exception) {
            Log.e("KlarnaView", "Failed to send event $eventName to Flutter: ${e.message}")
        }
    }

    override fun onMethodCall(
        call: MethodCall,
        result: MethodChannel.Result
    ) {
        when (call.method) {
            "pay" -> {
                result.success(200)
            }
        }
    }

    override fun onAuthorized(
        view: KlarnaPaymentView,
        approved: Boolean,
        authToken: String?,
        finalizedRequired: Boolean?
    ) {
        sendEventToFlutter(
            "startedKlarna", mapOf(
                "approved" to approved,
                "authToken" to authToken,
                "finalizedRequired" to (finalizedRequired ?: false)
            )
        )
        view.finalize(sessionData = authToken)
        Toast.makeText(context,"startedKlarna:${authToken}", Toast.LENGTH_SHORT).show()

    }

    override fun onErrorOccurred(
        view: KlarnaPaymentView,
        error: KlarnaPaymentsSDKError
    ) {
        val errorData = mapOf(
            "error" to error.name,
            "action" to error.action,
            "isFatal" to error.isFatal,
            "invalidFields" to error.invalidFields.toString(),
            "message" to error.message
        )
        sendEventToFlutter("errorKlarna", errorData)
        Toast.makeText(context,errorData.toString(), Toast.LENGTH_SHORT).show()
    }

    override fun onFinalized(
        view: KlarnaPaymentView,
        approved: Boolean,
        authToken: String?
    ) {
        Log.d("authToken", authToken ?: "")
        sendEventToFlutter(
            "finishKlarna", mapOf(
                "approved" to approved,
                "authToken" to authToken
            )
        )
    }

    override fun onInitialized(view: KlarnaPaymentView) {
        Log.d(
            "initKlarna", mapOf(
                "initialized" to true,
                "ready" to true
            ).toString()
        )
        sendEventToFlutter(
            "initKlarna", mapOf(
                "initialized" to true,
                "ready" to true
            )
        )
        view.authorize(true, null)
    }

    override fun onLoadPaymentReview(
        view: KlarnaPaymentView,
        showForm: Boolean
    ) {
    }

    override fun onLoaded(view: KlarnaPaymentView) {
    }

    override fun onReauthorized(
        view: KlarnaPaymentView,
        approved: Boolean,
        authToken: String?
    ) {
        sendEventToFlutter(
            "reauthorizedKlarna", mapOf(
                "approved" to approved,
                "authToken" to authToken
            )
        )
    }

    override fun onError(
        klarnaComponent: KlarnaComponent,
        error: KlarnaMobileSDKError
    ) {
        sendEventToFlutter(
            "errorKlarna", mapOf(
                "message" to error.message,
                "name" to error.name,
                "isFatal" to error.isFatal
            )
        )
        Log.e(
            "errorKlarna", mapOf(
                "message" to error.message,
                "name" to error.name,
                "isFatal" to error.isFatal
            ).toString()
        )
        Toast.makeText(context,mapOf(
            "message" to error.message,
            "name" to error.name,
            "isFatal" to error.isFatal
        ).toString(), Toast.LENGTH_SHORT).show()
    }

    override fun onEvent(
        klarnaComponent: KlarnaComponent,
        event: KlarnaProductEvent
    ) {
        Log.d("klarnaEvent", event.action)
        Log.d("klarnaEvent", event.params.toString())
        Log.d("klarnaEvent", event.sessionId ?: "no sessionId")

        sendEventToFlutter(
            "klarnaEvent", mapOf(
                "action" to event.action,
                "params" to event.params,
                "sessionId" to event.sessionId
            )
        )

        if (event.action.contains("redirect")) {
            sendEventToFlutter(
                "klarnaRedirect", mapOf(
                    "action" to event.action,
                    "params" to event.params
                )
            )
        }
    }
}