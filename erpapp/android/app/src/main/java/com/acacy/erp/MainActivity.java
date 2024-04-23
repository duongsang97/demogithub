package com.acacy.erp;

import android.content.Intent;
import android.content.SharedPreferences;
import java.nio.file.Files;
import java.io.IOException;
import com.acacy.erp.service.RecordService;
import android.annotation.SuppressLint;
import android.annotation.TargetApi;
import android.app.Notification;
import android.app.NotificationChannel;
import android.app.NotificationManager;
import android.app.Service;
import android.content.Context;
import android.content.Intent;
import android.content.SharedPreferences;
import android.graphics.Camera;
import android.graphics.Color;
import android.hardware.camera2.CameraAccessException;
import android.hardware.camera2.CameraManager;
import android.media.MediaRecorder;
import android.os.Build;
import android.os.Environment;
import android.os.Handler;
import android.os.IBinder;
import android.os.SystemClock;
import android.provider.Settings;
import android.util.Log;
import android.widget.Toast;
import java.util.stream.Stream;
import java.io.File;
import java.text.SimpleDateFormat;
import java.util.Date;
import java.nio.file.Path;
import java.nio.file.Paths;
import android.content.pm.PackageManager;
import java.lang.reflect.Method;
import android.os.StatFs;
import android.os.Environment;
import android.content.pm.ApplicationInfo;
import android.hardware.camera2.CameraAccessException;
import android.hardware.camera2.CameraCharacteristics;
import android.hardware.camera2.CameraManager;
import androidx.annotation.NonNull;

import io.flutter.embedding.android.FlutterActivity;
import io.flutter.embedding.engine.FlutterEngine;
import io.flutter.plugin.common.MethodChannel;
import io.flutter.embedding.android.FlutterFragmentActivity;
import java.util.List;
import io.flutter.embedding.engine.FlutterEngineGroup;
import io.flutter.plugin.common.MethodCall;
import io.flutter.plugins.GeneratedPluginRegistrant;

//FlutterActivity
public class MainActivity extends FlutterFragmentActivity {
    private static final String CHANNEL = "erp.native/helper";
    private Integer status;
    private String path = "";
    private String shopId = "";
    private SharedPreferences pref;
    @Override
    public void configureFlutterEngine(FlutterEngine flutterEngine) {
        super.configureFlutterEngine(flutterEngine);
        new MethodChannel(flutterEngine.getDartExecutor().getBinaryMessenger(),CHANNEL).setMethodCallHandler(
                (call, result) ->{
                    if(call.method.endsWith("record")) {
                        try{
                            pref = getSharedPreferences("EXAM", MODE_PRIVATE);
                            pref.edit().clear().apply();
                            status = call.argument("status");
                            shopId = call.argument("shopId");
                            if(status != null){
                                if(status == 0){
                                    Intent intentRecord = new Intent(this, RecordService.class);
                                    intentRecord.putExtra("status",status);
                                    intentRecord.putExtra("shopId",shopId);
                                    intentRecord.addFlags(Intent.FLAG_ACTIVITY_NEW_TASK);
                                    intentRecord.setAction("START_SERVICE");
                                    startService(intentRecord);
                                    result.success( "OK");
                                }else{
                                    Intent intentRecord = new Intent(this, RecordService.class);
                                    intentRecord.putExtra("status",status);
                                    intentRecord.putExtra("shopId",shopId);
                                    intentRecord.addFlags(Intent.FLAG_ACTIVITY_NEW_TASK);
                                    intentRecord.setAction("STOP_SERVICE");
                                    intentRecord.putExtra("SAVE",1); //1: luu file, 0 xoa file
                                    startService(intentRecord);
                                    result.success("OK");
                                }
                            }else{
                                result.error("error","Không khởi động chức năng ghi âm",null);
                            }
                        }catch (Exception e){
                            result.error("error",e.toString(),null);
                        }
                    }
                    if(call.method.endsWith("recordReceiver")) {
                       // pref = getSharedPreferences("EXAM", MODE_PRIVATE);
                        //path = pref.getString("RECORD_PATH",null);
                        path = getAudioDir().toString();
                        result.success(path);
                    }
                    if(call.method.endsWith("getFreeStorage")){
                        File file = new File("/sdcard");
                        long temp = file.getFreeSpace();
                        result.success(String.valueOf(temp));
                    }
                    if(call.method.endsWith("getTimeSettingStatus")){
                        boolean resultTime = false;
                        try {
                            int autoTimeSetting = Settings.Global.getInt(getContentResolver(), Settings.Global.AUTO_TIME);
                            resultTime = (autoTimeSetting == 1);
                        } catch (Settings.SettingNotFoundException e) {
                            // Handle the exception
                            e.printStackTrace();
                        }
                        result.success(String.valueOf(resultTime));
                    }
                    // if(call.method.endsWith("getCameraLensType")){
                    //   Camera camera = Camera();
                    //   Camera.Parameters parameters = camera.getParameters();
                    //   float focalLengths = parameters.getFocalLength();
                    //   String lensType = "";
                    //   if (focalLengths == 0) {
                    //     lensType = "Wide-angle lens";
                    //   } else {
                    //     lensType = "Normal lens";
                    //   }
                    //   result.success(String.valueOf(focalLengths));
                    // }
                    // if(call.method.endsWith("getCameraLensType")){
                    //   Camera.CameraInfo cameraInfo = new Camera.CameraInfo();
                    //   // Camera.getCameraInfo(Camera.CameraInfo.CAMERA_FACING_BACK, cameraInfo);
                    //   // int currentCamera = cameraInfo.facing;
                    //   // result.success(cameraInfo.toString());
                    //   Camera.CameraInfo cameraInfo = new Camera.CameraInfo();
                    //   Camera.getCameraInfo(Camera.CameraInfo.CAMERA_FACING_BACK, cameraInfo);
                    //   String lensType = cameraInfo.facing == Camera.CameraInfo.CAMERA_FACING_BACK &&
                    //           cameraInfo.getDeviceType() == Camera.CameraInfo.CAMERA_DEVICE_TYPE_WIDE_ANGLE ?
                    //           "Wide-angle lens" : "Normal lens";
                    //           result.success(String.valueOf(lensType));
                    // }
                    if(call.method.endsWith("getCameraLensType")){
                      String cameraId = call.argument("cameraId");
                      boolean isWide = false;
                      if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.LOLLIPOP) {
                        CameraManager manager = (CameraManager) getSystemService(Context.CAMERA_SERVICE);
                        try {
                            CameraCharacteristics characteristics = manager.getCameraCharacteristics(cameraId);
                            Integer lensFacing = characteristics.get(CameraCharacteristics.LENS_FACING);
                            Float minFocusDistance = characteristics.get(CameraCharacteristics.LENS_INFO_MINIMUM_FOCUS_DISTANCE);
                            if (lensFacing != null && minFocusDistance != null && minFocusDistance == 0) {
                              isWide = true; // Wide-angle camera
                            }
                        } catch (CameraAccessException e) {
                            e.printStackTrace();
                        }
                      }
                      result.success(isWide);
                    }
                }
        );
    }

    private File getAudioDir() {
        if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.N) {
            File storageDir = new File(this.getExternalFilesDir(null), "ERP");
            if (!storageDir.exists())
                storageDir.mkdirs();
            return storageDir;
        }else{
            File file = new File(Environment.getExternalStorageDirectory().getAbsolutePath(), "ERP");
            if (!file.exists())
                file.mkdirs();
            return file;
        }
    }



    @Override
    protected void onDestroy() {
        super.onDestroy();
    }
}
