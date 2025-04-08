import Flutter
import InstalogIOS
import UIKit

public class InstalogPlugin: NSObject, FlutterPlugin {
    final let TAG = "InstalogPlugin"
    
    public static func register(with registrar: FlutterPluginRegistrar) {
        let channel = FlutterMethodChannel(name: "dev.instalog.flutter/channel", binaryMessenger: registrar.messenger())
        let instance = InstalogPlugin()
        registrar.addMethodCallDelegate(instance, channel: channel)
    }
    
    public func handle(_ call: FlutterMethodCall, result: @escaping FlutterResult) {
        DispatchQueue.main.async { [self] in
            switch call.method {
            case "initialize":
                initialize(call: call, result: result)
            case "show_feedback_modal":
                showFeedbackModal(call: call, result: result)
            case "log":
                logEvent(call: call, result: result)
            case "send_crash":
                sendCrash(call: call, result: result)
            case "identify_user":
                identifyUser(call: call, result: result)
            case "simulate_crash":
                simulateCrash(call: call, result: result)
            default:
                result(FlutterMethodNotImplemented)
                return
            }
        }
    }
    
    func initialize(call: FlutterMethodCall, result: FlutterResult) {
        if let args = call.arguments as? [String: Any] {
            let apiKey = args["api_key"] as? String ?? "no_key"
            let options = args["options"] as? [String: Any] ?? [:]
            
            let instalogOptions = InstalogOptions(dictionary: options)
            Instalog.shared.initialize(key: apiKey, options: instalogOptions)
            result(true)
        } else {
            result(FlutterError.init(code: TAG, message: nil, details: "initialize failed"))
        }
    }
    
    func showFeedbackModal(call: FlutterMethodCall, result: FlutterResult) {
        Instalog.shared.showFeedbackModal()
        result(true)
    }
    
    private func logEvent(call: FlutterMethodCall, result: @escaping FlutterResult) {
        guard let args = call.arguments as? [String: Any] else {
            result(FlutterError.init(code: TAG, message: "Missing arguments", details: nil))
            return
        }
        
        guard let event = args["event"] as? String else {
            result(FlutterError.init(code: TAG, message: "Missing event name", details: nil))
            return
        }
        
        let params = args["params"] as? [String: String] ?? [String: String]()
       
        let logModel = InstalogLogModel(event: event, params: params)
        Instalog.shared.logEvent(log: logModel)
        
        do {
            let jsonData = try JSONEncoder().encode(logModel)
            result(true)
        } catch {
            print(error)
            result(
                FlutterError(
                    code: "Instalog.logEvent",
                    message: "Unable to encode event",
                    details: error.localizedDescription
                )
            )
        }
    }
    
    private func sendCrash(call: FlutterMethodCall, result: @escaping FlutterResult) {
        guard let args = call.arguments as? [String: Any] else {
            result(FlutterError.init(code: TAG, message: "Missing arguments", details: nil))
            return
        }
        
        let error = args["error"] as? String
        let stack = args["stack"] as? String
        
        Instalog.shared.sendCrash(
            name: error,
            report: stack,
            completion: { sent in
                result(sent)
            }
        )
    }
    
    private func identifyUser(call: FlutterMethodCall, result: @escaping FlutterResult) {
        guard let args = call.arguments as? [String: Any] else {
            result(FlutterError.init(code: TAG, message: "Missing arguments", details: nil))
            return
        }
        
        guard let id = args["id"] as? String else {
            result(FlutterError.init(code: TAG, message: "Missing user ID", details: nil))
            return
        }
        
        Instalog.shared.identifyUser(id)
        result(true)
    }
    
    private func simulateCrash(call: FlutterMethodCall, result: @escaping FlutterResult) {
        Instalog.crash.simulateCrash()
        result(true)
    }
}
