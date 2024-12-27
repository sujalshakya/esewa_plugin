package com.example.esewa_plugin

import android.app.Activity
import android.content.ContentValues.TAG
import android.content.Context
import android.content.Intent
import android.widget.Toast
import androidx.activity.result.ActivityResultLauncher
import androidx.activity.result.contract.ActivityResultContracts
import com.f1soft.esewapaymentsdk.ESewaConfiguration
import com.f1soft.esewapaymentsdk.ESewaPayment
import com.f1soft.esewapaymentsdk.ui.ESewaPaymentActivity
import io.flutter.Log
import io.flutter.embedding.engine.plugins.FlutterPlugin
import io.flutter.embedding.engine.plugins.activity.ActivityAware
import io.flutter.embedding.engine.plugins.activity.ActivityPluginBinding
import io.flutter.plugin.common.MethodCall
import io.flutter.plugin.common.MethodChannel
import io.flutter.plugin.common.MethodChannel.MethodCallHandler
import io.flutter.plugin.common.MethodChannel.Result
import io.flutter.plugin.common.PluginRegistry

/** EsewaPlugin */
class EsewaPlugin : FlutterPlugin, MethodCallHandler, ActivityAware, PluginRegistry.ActivityResultListener {
    private lateinit var channel: MethodChannel
    private lateinit var context: Context
    private lateinit var activity: Activity

    override fun onAttachedToEngine(flutterPluginBinding: FlutterPlugin.FlutterPluginBinding) {
        channel = MethodChannel(flutterPluginBinding.binaryMessenger, "esewa_plugin")
        channel.setMethodCallHandler(this)
        context = flutterPluginBinding.applicationContext
    }

    override fun onMethodCall(call: MethodCall, result: Result) {
        if (call.method == "getPlatformVersion") {
            result.success("Android ${android.os.Build.VERSION.RELEASE}")
        } else if (call.method == "startEsewa") {
            val eSewaConfiguration: ESewaConfiguration =
                ESewaConfiguration()
                    .clientId("JB0BBQ4aD0UqIThFJwAKBgAXEUkEGQUBBAwdOgABHD4DChwUAB0R")
                    .secretKey("BhwIWQQADhIYSxILExMcAgFXFhcOBwAKBgAXEQ==")
                    .environment(ESewaConfiguration.ENVIRONMENT_TEST)

            val eSewaPayment: ESewaPayment = ESewaPayment("100", "Test", "1234", "www.google.com")

            val intent = Intent(context, ESewaPaymentActivity::class.java).apply {
                putExtra(ESewaConfiguration.ESEWA_CONFIGURATION, eSewaConfiguration)
                putExtra(ESewaPayment.ESEWA_PAYMENT, eSewaPayment)
            }

            // Using startActivityForResult (deprecated)
            activity.startActivityForResult(intent, PAYMENT_REQ_CODE)
        } else {
            result.notImplemented()
        }
    }

    // Constants
    companion object {
        const val PAYMENT_REQ_CODE = 1
    }

    // Initialize Activity Result Listener (for handling activity results)
    override fun onAttachedToActivity(binding: ActivityPluginBinding) {
        activity = binding.activity
        binding.addActivityResultListener(this)
    }

    // Handle the result of the payment activity
    override fun onActivityResult(requestCode: Int, resultCode: Int, data: Intent?): Boolean {
        if (requestCode == PAYMENT_REQ_CODE) {
            when (resultCode) {
                Activity.RESULT_OK -> {
                    val paymentResult = data?.getStringExtra(ESewaPayment.EXTRA_RESULT_MESSAGE)
                    Log.d(TAG, "Payment Result Data: $paymentResult")
                }
                Activity.RESULT_CANCELED -> {
                    Log.d(TAG, "Canceled By User")
                }
                ESewaPayment.RESULT_EXTRAS_INVALID -> {
                    val paymentResult = data?.getStringExtra(ESewaPayment.EXTRA_RESULT_MESSAGE)
                    Log.d(TAG, "Payment Result Data: $paymentResult")
                }
            }
            return true
        }
        return false
    }

    // Lifecycle methods for ActivityAware interface
    override fun onDetachedFromActivityForConfigChanges() {}

    override fun onReattachedToActivityForConfigChanges(binding: ActivityPluginBinding) {}

    override fun onDetachedFromActivity() {}

    override fun onDetachedFromEngine(binding: FlutterPlugin.FlutterPluginBinding) {
        channel.setMethodCallHandler(null)
    }
}
