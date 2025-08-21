package de.bloomwell.klarna_flutter_pay

import android.content.Context
import android.util.Log
import android.view.View
import android.view.ViewGroup.LayoutParams.MATCH_PARENT
import android.widget.FrameLayout
import androidx.core.view.children
import com.klarna.mobile.sdk.KlarnaMobileSDKError
import com.klarna.mobile.sdk.api.KlarnaEventHandler
import com.klarna.mobile.sdk.api.KlarnaProductEvent
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
    private val klarnaViewPayment: KlarnaPaymentView,
    private val tokenClient: String
): PlatformView, MethodChannel.MethodCallHandler, KlarnaPaymentViewCallback, KlarnaEventHandler {
    /*val klarnaViewPayment: KlarnaPaymentView = KlarnaPaymentView(
        context,
        returnURL = ""
    )*/
    val frameLayout = FrameLayout(context).apply {
        this.layoutParams = FrameLayout.LayoutParams(FrameLayout.LayoutParams(MATCH_PARENT,MATCH_PARENT))
    }
    
    private var isKlarnaStarted = false
    
    init {
        methodChannel.setMethodCallHandler(this)
        klarnaViewPayment.registerPaymentViewCallback(this)
        klarnaViewPayment.eventHandler = this
        
        // Initialize with client token
        klarnaViewPayment.initialize(tokenClient)
        
        // Send initialization event to Flutter
        sendEventToFlutter("initializingKlarna", mapOf(
            "clientToken" to tokenClient
        ))
    }
    override fun getView(): View? {
        if(!frameLayout.children.contains(klarnaViewPayment)){
            frameLayout.addView(klarnaViewPayment)
        }
        return frameLayout
    }

    override fun dispose() {
        klarnaViewPayment.unregisterPaymentViewCallback(this)
        klarnaViewPayment.finalize(null)
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
        when(call.method) {
            "pay"-> {
                klarnaViewPayment.category = "klarna"
                klarnaViewPayment.loadPaymentReview()
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
        isKlarnaStarted = true
        sendEventToFlutter("startedKlarna", mapOf(
            "approved" to approved,
            "authToken" to authToken,
            "finalizedRequired" to (finalizedRequired ?: false)
        ))
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
    }

    override fun onFinalized(
        view: KlarnaPaymentView,
        approved: Boolean,
        authToken: String?
    ) {
        Log.d("authToken", authToken ?: "")
        sendEventToFlutter("finishKlarna", mapOf(
            "approved" to approved,
            "authToken" to authToken
        ))
    }

    override fun onInitialized(view: KlarnaPaymentView) {
        sendEventToFlutter("initKlarna", mapOf(
            "initialized" to true,
            "ready" to true
        ))
    }

    override fun onLoadPaymentReview(
        view: KlarnaPaymentView,
        showForm: Boolean
    ) {
        sendEventToFlutter("loadPaymentReviewKlarna", mapOf("showForm" to showForm))
    }

    override fun onLoaded(view: KlarnaPaymentView) {
        sendEventToFlutter("onLoadedKlarna", mapOf("loaded" to true))
    }

    override fun onReauthorized(
        view: KlarnaPaymentView,
        approved: Boolean,
        authToken: String?
    ) {
        sendEventToFlutter("reauthorizedKlarna", mapOf(
            "approved" to approved,
            "authToken" to authToken
        ))
    }

    override fun onError(
        klarnaComponent: KlarnaComponent,
        error: KlarnaMobileSDKError
    ) {
        sendEventToFlutter("errorKlarna", mapOf(
            "message" to error.message,
            "name" to error.name,
            "isFatal" to error.isFatal
        ))
    }

    override fun onEvent(
        klarnaComponent: KlarnaComponent,
        event: KlarnaProductEvent
    ) {
        Log.d("klarnaEvent", event.action)
        Log.d("klarnaEvent", event.params.toString())
        Log.d("klarnaEvent", event.sessionId ?: "no sessionId")
        
        sendEventToFlutter("klarnaEvent", mapOf(
            "action" to event.action,
            "params" to event.params,
            "sessionId" to event.sessionId
        ))
        
        if(event.action.contains("redirect")) {
            sendEventToFlutter("klarnaRedirect", mapOf(
                "action" to event.action,
                "params" to event.params
            ))
        }
    }
}