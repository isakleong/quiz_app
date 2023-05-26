package com.sfa.tools.sfatools;

import android.os.Bundle;
import android.os.Handler;

import java.util.Objects;

import io.flutter.embedding.android.FlutterActivity;
import io.flutter.plugin.common.EventChannel;
import io.flutter.plugin.common.MethodCall;
import io.flutter.plugin.common.MethodChannel;
import io.flutter.plugin.common.MethodChannel.MethodCallHandler;
import io.flutter.plugin.common.MethodChannel.Result;
import io.flutter.plugin.common.PluginRegistry.Registrar;

public class MainActivity extends FlutterActivity {
    // private static final String CHANNEL = "message_channel";

    @Override
    protected void onCreate(Bundle savedInstanceState) {
    //     //Put this method inside onCreate() in MainActivity.
    //     @Override
    //     public void configureFlutterEngine(FlutterEngine flutterEngine) {
    //         super.configureFlutterEngine(flutterEngine);

    //         BinaryMessenger messenger = flutterEngine.getDartExecutor().getBinaryMessenger();

    //         new MethodChannel(flutterEngine.getDartExecutor().getBinaryMessenger(), CHANNEL)
    //                 .setMethodCallHandler(
    //                         (call, result) -> {
    //                         onMethodCall(call,result);
    //                         }
    //                 );
    //     }


    //     private void onMethodCall(MethodCall call, MethodChannel.Result result){
    //         if(call.method.equals("setMessage")){
    //             String messageText = call.argument("Message_tag");
    //             //To do Implement here
    //             result.success("Message Received");
    //         }
    //         else{
    //             result.notImplemented();
    //         }
    //     }
    }
}
