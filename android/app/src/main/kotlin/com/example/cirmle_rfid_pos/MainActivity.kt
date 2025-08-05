package com.example.cirmle_rfid_pos

import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.MethodChannel

class MainActivity : FlutterActivity() {
    private val CHANNEL = "razorpay_pos"

    override fun configureFlutterEngine(flutterEngine: FlutterEngine) {
        super.configureFlutterEngine(flutterEngine)
        MethodChannel(flutterEngine.dartExecutor.binaryMessenger, CHANNEL).setMethodCallHandler { call, result ->
            if (call.method == "startPayment") {
                val orderId = call.argument<String>("orderId")
                // TODO: Integrate Razorpay POS SDK payment call here using orderId
                // For now, simulate a successful payment result
                val paymentResult = mapOf(
                    "status" to "success",
                    "orderId" to orderId,
                    "paymentId" to "pay_dummy123",
                    "signature" to "sig_dummy123"
                )
                result.success(paymentResult)
            } else {
                result.notImplemented()
            }
        }
    }
}
