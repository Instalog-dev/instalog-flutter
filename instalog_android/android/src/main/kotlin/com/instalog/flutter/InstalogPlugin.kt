package dev.instalog.flutter

import android.content.Context
import androidx.annotation.NonNull
import dev.instalog.mobile.*
import dev.instalog.mobile.ui.InstalogAlertData

import io.flutter.embedding.engine.plugins.FlutterPlugin
import io.flutter.plugin.common.MethodCall
import io.flutter.plugin.common.MethodChannel
import io.flutter.plugin.common.MethodChannel.MethodCallHandler
import io.flutter.plugin.common.MethodChannel.Result
import io.flutter.embedding.engine.plugins.activity.ActivityAware
import io.flutter.embedding.engine.plugins.activity.ActivityPluginBinding
import android.app.Activity
import dev.instalog.mobile.models.InstalogLogModel

class InstalogPlugin : FlutterPlugin, MethodCallHandler, InstalogAlertDialogHandler, ActivityAware {
    private val instalog = Instalog.getInstance()

    private lateinit var channel: MethodChannel
    private var context: Context? = null
    private var activity: Activity? = null

    override fun onAttachedToEngine(flutterPluginBinding: FlutterPlugin.FlutterPluginBinding) {
        channel = MethodChannel(flutterPluginBinding.binaryMessenger, "dev.instalog.flutter/channel")
        channel.setMethodCallHandler(this)
        context = flutterPluginBinding.applicationContext
    }

    override fun onMethodCall(call: MethodCall, result: Result) {
        when (call.method) {
            "get_platform_name" -> {
                result.success("Android")
            }
            "initialize" -> {
                val apiKey = call.argument<String>("api_key") ?: run {
                    result.error("MISSING_API_KEY", "API key is required", null)
                    return
                }
                val options = call.argument<Map<String, Any>>("options") ?: mapOf()
                
                initialize(apiKey, options, result)
            }
            "log" -> {
                val event = call.argument<String>("event") ?: run {
                    result.error("MISSING_EVENT", "Event name is required", null)
                    return
                }
                val params = call.argument<Map<String, Any>>("params") ?: mapOf()
                
                log(event, params, result)
            }
            "identify_user" -> {
                val id = call.argument<String>("id") ?: run {
                    result.error("MISSING_ID", "User ID is required", null)
                    return
                }
                
                identifyUser(id, result)
            }
            "send_crash" -> {
                val error = call.argument<String>("error") ?: run {
                    result.error("MISSING_ERROR", "Error message is required", null)
                    return
                }
                val stack = call.argument<String>("stack") ?: ""
                
                sendCrash(error, stack, result)
            }
            "show_feedback_modal" -> {
                showFeedbackModal(result)
            }
            "simulate_crash" -> {
                simulateCrash(result)
            }
            else -> {
                result.notImplemented()
            }
        }
    }

    private fun initialize(apiKey: String, options: Map<String, Any>, result: Result) {
        if (activity == null) {
            result.error("ACTIVITY_NULL", "Current activity is null", null)
            return
        }

        val opt = InstalogOptions(
            isLogEnabled = options["is_log_enabled"] as? Boolean ?: false,
            isLoggerEnabled = options["is_logger_enabled"] as? Boolean ?: false,
            isCrashEnabled = options["is_crash_enabled"] as? Boolean ?: false,
            isFeedbackEnabled = options["is_feedback_enabled"] as? Boolean ?: false
        )

        try {
            instalog.initialize(
                key = apiKey,
                context = activity!!.applicationContext,
                handler = this,
                options = opt
            )
            result.success(true)
        } catch (e: Exception) {
            result.error("INITIALIZE_ERROR", e.message, e)
        }
    }

    private fun log(event: String, params: Map<String, Any>, result: Result) {
        if (activity == null) {
            result.error("ACTIVITY_NULL", "Current activity is null", null)
            return
        }

        try {
            val paramsMap: HashMap<String, String> = params.mapValues { 
                it.value.toString() ?: ""
            } as HashMap<String, String>

            val log = InstalogLogModel(
                event = event,
                params = paramsMap
            )

            instalog.logEvent(activity!!.applicationContext, log)
            result.success(true)
        } catch (e: Exception) {
            result.error("LOG_ERROR", e.message, e)
        }
    }

    private fun identifyUser(id: String, result: Result) {
        try {
            instalog.identifyUser(id)
            result.success(true)
        } catch (e: Exception) {
            result.error("IDENTIFY_USER_ERROR", e.message, e)
        }
    }

    private fun sendCrash(error: String, stack: String, result: Result) {
        if (activity == null) {
            result.error("ACTIVITY_NULL", "Current activity is null", null)
            return
        }

        try {
            instalog.sendCrash(activity!!.applicationContext, error, stack)
            result.success(true)
        } catch (e: Exception) {
            result.error("SEND_CRASH_ERROR", e.message, e)
        }
    }

    private fun showFeedbackModal(result: Result) {
        if (activity == null) {
            result.error("ACTIVITY_NULL", "Current activity is null", null)
            return
        }

        try {
            instalog.showFeedbackModal(activity!!)
            result.success(true)
        } catch (e: Exception) {
            result.error("FEEDBACK_MODAL_ERROR", e.message, e)
        }
    }

    private fun simulateCrash(result: Result) {
        try {
            Instalog.crash.simulateExceptionCrash()
            result.success(true)
        } catch (e: Exception) {
            result.error("SIMULATE_CRASH_ERROR", e.message, e)
        }
    }

    override fun onDetachedFromEngine(binding: FlutterPlugin.FlutterPluginBinding) {
        channel.setMethodCallHandler(null)
        context = null
    }

    override fun show(data: InstalogAlertData) {
        TODO("Not yet implemented")
    }

    override fun onAttachedToActivity(binding: ActivityPluginBinding) {
        activity = binding.activity
    }

    override fun onDetachedFromActivityForConfigChanges() {
        activity = null
    }

    override fun onReattachedToActivityForConfigChanges(binding: ActivityPluginBinding) {
        activity = binding.activity
    }

    override fun onDetachedFromActivity() {
        activity = null
    }
}