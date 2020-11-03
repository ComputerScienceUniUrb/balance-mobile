import UIKit
import Flutter
<<<<<<< HEAD

@UIApplicationMain
@objc class AppDelegate: FlutterAppDelegate {
=======
import CoreMotion

@UIApplicationMain
@objc class AppDelegate: FlutterAppDelegate {

  private lazy final var sensorMonitor = SensorMonitor()
    
>>>>>>> dev
  override func application(
    _ application: UIApplication,
    didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
  ) -> Bool {
    GeneratedPluginRegistrant.register(with: self)
<<<<<<< HEAD
    return super.application(application, didFinishLaunchingWithOptions: launchOptions)
  }
}
=======

    let controller : FlutterViewController = window?.rootViewController as! FlutterViewController
    // Setup EventChannel for getting stream of sensors
    let sensors_stream = FlutterEventChannel(name: "uniurb.it/sensors/stream", binaryMessenger: controller.binaryMessenger)
    sensors_stream.setStreamHandler(sensorMonitor)
    
    // Setup MethodChannel for getting sensors information
    let sensors_info = FlutterMethodChannel(name: "uniurb.it/sensors/presence", binaryMessenger: controller.binaryMessenger)
    sensors_info.setMethodCallHandler({
      [weak self] (call: FlutterMethodCall, result: FlutterResult) -> Void in
        switch call.method {
            case "isAccelerometerPresent":
                result(self.sensorMonitor.isAccelerometerPresent())

            case "isGyroscopePresent":
                result(self.sensorMonitor.isGyroscopePresent())

            default:
               result(FlutterMethodNotImplemented)
        }
    })
    return super.application(application, didFinishLaunchingWithOptions: launchOptions)
  }
}

class SensorMonitor: NSObject, FlutterStreamHandler {
    private final var mSensorListener = SensorListener(context)
    
    /** Returns true if the accelerometer sensor is present **/
    public func isAccelerometerPresent() -> Bool {
        return mSensorListener.isAccelerometerPresent()
    }
    /** Returns true if the gyroscope sensor is present **/
    public func isGyroscopePresent() -> Bool {
        return mSensorListener.isGyroscopePresent()
    }
    
    public func onListen(withArguments arguments: Any?, eventSink events: @escaping FlutterEventSink) -> FlutterError? {
        events(true) // any generic type or more compex dictionary of [String:Any]
        events(FlutterError(code: "ERROR_CODE",
                             message: "Detailed message",
                             details: nil)) // in case of errors
        events(FlutterEndOfEventStream) // when stream is over
        return nil
    }

    public func onCancel(withArguments arguments: Any?) -> FlutterError? {
        return nil
    }
}

class SensorListener: SensorEventListener {
    private final var motion = CMMotionManager()
    
   /** Returns true if the accelerometer sensor is present **/
    public func isAccelerometerPresent() -> Bool {
        mRawAccelerometerSensor != nil
    }
   /** Returns true if the gyroscope sensor is present **/
    public func isGyroscopePresent() -> Bool {
        mRawGyroscopeSensor != nil
    }
}
>>>>>>> dev
