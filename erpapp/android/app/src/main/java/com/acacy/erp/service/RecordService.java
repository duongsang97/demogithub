package com.acacy.erp.service;

import android.annotation.SuppressLint;
import android.annotation.TargetApi;
import android.app.Notification;
import android.app.NotificationChannel;
import android.app.NotificationManager;
import android.app.Service;
import android.content.Context;
import android.content.Intent;
import android.content.SharedPreferences;
import android.graphics.Color;
import android.media.MediaRecorder;
import android.os.Build;
import android.os.Environment;
import android.os.Handler;
import android.os.IBinder;
import android.os.SystemClock;
import android.util.Log;
import android.widget.Toast;

import androidx.core.app.NotificationCompat;

import com.acacy.erp.R;

import java.io.File;
import java.text.SimpleDateFormat;
import java.util.Date;
import java.util.Random;


@SuppressLint("SimpleDateFormat")
public class RecordService extends Service {
    private static final String TAG = "RecorderService";
    private boolean mRecordingStatus;
    private MediaRecorder mMediaRecorder;
    private String OutFilePath;
    private Integer status;
    private String shopId;

    @Override
    public void onCreate() {
        super.onCreate();

    }

    @Override
    public void onStart(Intent intent, int startId) {
        // TODO Auto-generated method stub

    }

    private Handler mHandler = new Handler();
    private long mStartTime = 0;
    private Runnable mUpdateTimeTask = new Runnable() {
        public void run() {
            final long start = mStartTime;
            long millis = SystemClock.uptimeMillis() - start;
            int seconds = (int) (millis / 1000);
            int minutes = seconds / 60;
            seconds = seconds % 60;
            mHandler.postAtTime(this, start
                    + (((minutes * 60) + seconds + 1) * 1000));
//            Log.e("lblTimer", minutes + ":"
//                    + (seconds > 9 ? seconds : new StringBuilder().append(0).append(seconds)).toString());
        }
    };

    @Override
    public IBinder onBind(Intent intent) {
        // TODO Auto-generated method stub
        return onBind(intent);
    }

    @SuppressLint("CommitPrefEdits")
    void send(String pathAudio){
        SharedPreferences pref = getSharedPreferences("EXAM", MODE_PRIVATE);
        pref.edit().putString("RECORD_PATH",pathAudio).commit();
    };

    @SuppressWarnings("deprecation")
    @Override
    public int onStartCommand(Intent intent, int flags, int startId) {
        // TODO Auto-generated method stub
        try{
            if(intent.getExtras() != null){
                status = intent.getExtras().getInt("status");
                shopId = intent.getExtras().getString("shopId");

                if(shopId == null || shopId == ""){
                   send("Error");
                   stopSelf();
                }
            }
            if (intent.getAction().equals("STOP_SERVICE")) {
                int Status = intent.getIntExtra("SAVE", 0);
                stopRecording();
                if (Status > 0) {
                    mRecordingStatus = false;
					/*AudioInfo info = new AudioInfo();
					info.setAudioLocal(OutFilePath);
					long now_datetime = DateTime.now1();

					String audioname = "AUDIO_"
							+ Preferences.getInt("EmployeeId") + "_"
							+ DateTime.today() + "_" + now_datetime + ".3gpp";

					info.setAudioPath(audioname);
					long auditID = Long.parseLong(Convert_AudioKey("AUDITID"));
					info.setAuditId(auditID);
					info.setCreateDate(now_datetime);
					info.setIsUpload(0);
					controller.insert(info);*/
                    send(OutFilePath); // gửi path audio ra ngoài.
                    Toast.makeText(getApplicationContext(), "Đã dừng và lưu file ghi âm.", Toast.LENGTH_SHORT).show();

                } else {
                    File tmp = new File(OutFilePath);
                    if (tmp.exists()){
                        tmp.delete();
                    }
                    Toast.makeText(getApplicationContext(), "Xóa file ghi âm thành công.", Toast.LENGTH_SHORT).show();
                }
				/*Preferences.put("AUDIO_KEY", String.valueOf(0));
				Preferences.put("PG_KEY", String.valueOf(0));*/
                stopNotification(111);
                this.onDestroy();
            } else {
                mRecordingStatus = false;
                super.onStart(intent, startId);
                if (!mRecordingStatus) {
                    if(startRecording()){
                        mStartTime = System.currentTimeMillis();
                        mHandler.removeCallbacks(mUpdateTimeTask);
                        mHandler.postDelayed(mUpdateTimeTask, 100);
                        Toast.makeText(getApplicationContext(), "Đang ghi âm", Toast.LENGTH_SHORT).show();
                    }else{
                        Toast.makeText(getApplicationContext(), "Lỗi tạo file ghi âm", Toast.LENGTH_SHORT).show();
                    }
                }

            }
            return super.onStartCommand(intent, flags, startId);
        }catch(Exception e){
            return START_REDELIVER_INTENT;
        }
    }


    @Override
    public void onDestroy() {
        super.onDestroy();
        stopSelf();
    }

    @Override
    public void onTaskRemoved(Intent rootIntent) {
        try{
            stopRecording();
            mRecordingStatus = false;
            Toast.makeText(getApplicationContext(), "Đã dừng và lưu file ghi âm.", Toast.LENGTH_SHORT).show();
			/*Preferences.put("AUDIO_KEY", String.valueOf(0));
			Preferences.put("PG_KEY", String.valueOf(0));*/
        }catch (Exception e){
            Log.d("GHIAM",e.toString());
        }
        stopNotification(111);
        this.stopSelf();
        super.onTaskRemoved(rootIntent);
    }
        // shopId_date_randomString.ext
    public boolean startRecording() {
        try {
            /*Preferences.put("RECORD_STATUS", true);*/
            String sDate = new SimpleDateFormat("yyyyMMdd").format(new Date(
                    System.currentTimeMillis()));
            Toast.makeText(getBaseContext(), "Recording Started",
                    Toast.LENGTH_SHORT).show();
            String FileName =  new StringBuilder().append(shopId).append("_").append(new Random().nextInt()).append(".mp4").toString(); //shopId+"_"+sDate+"_"+new Random().nextInt()+ ".mp4";
            OutFilePath = new StringBuilder().append(getAudioDir()).append("/").append(FileName).toString();
            mMediaRecorder = new MediaRecorder();
            mMediaRecorder.setAudioSource(MediaRecorder.AudioSource.MIC);
            mMediaRecorder.setAudioEncodingBitRate(128000);
            mMediaRecorder.setAudioSamplingRate(44100);
            mMediaRecorder.setOutputFormat(MediaRecorder.OutputFormat.MPEG_4);
            mMediaRecorder.setAudioEncoder(MediaRecorder.AudioEncoder.AAC);
            mMediaRecorder.setOutputFile(OutFilePath);
            mMediaRecorder.prepare();
            mMediaRecorder.start();
            mRecordingStatus = true;
            startNotification(111);
            return true;

        } catch (Exception e) {
            Log.d(TAG, e.getMessage());
            e.printStackTrace();
            return false;
        }
    }

    private File getAudioDir() {
        if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.N) {
            File storageDir = new File(this.getExternalFilesDir(null), "ERP");
            if (!storageDir.exists())
                storageDir.mkdirs();
            storageDir = new File(storageDir, String.valueOf(new SimpleDateFormat("yyyy-MM-dd").format(new Date(
                    System.currentTimeMillis()))));
            if (!storageDir.exists())
                storageDir.mkdirs();
            return storageDir;
        }else{
            File file = new File(Environment.getExternalStorageDirectory().getAbsolutePath(),
                    "ERP");
            if (!file.exists())
                file.mkdirs();
            return file;
        }
    }

    public void stopRecording() {
        Toast.makeText(getBaseContext(), "Recording Stopped", Toast.LENGTH_SHORT).show();
        stopNotification(111);
        try{
            mMediaRecorder.stop();
            mMediaRecorder.reset();
            mMediaRecorder.release();
        }catch(Exception e){
            Log.d("",e.toString());
        }
        //Preferences.put("RECORD_STATUS", false);
    }

    public void startNotification(int i) {
        if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.O){
            startMyOwnForeground();
        } else if((Build.VERSION.SDK_INT >= Build.VERSION_CODES.N) && (Build.VERSION.SDK_INT < Build.VERSION_CODES.O)){
            Notification();
        }else {
            Toast.makeText(getBaseContext(),"Start record.",Toast.LENGTH_SHORT).show();
        }

    }

    public void stopNotification(int i) {
        if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.O){
            stopForeground(i);
        } else{
            NotificationManager notificationManager = (NotificationManager)getSystemService(Context.NOTIFICATION_SERVICE);
            notificationManager.cancel(111);
        }
        stopSelf();
    }

    @TargetApi(26)
    private void startMyOwnForeground() {
        String NOTIFICATION_CHANNEL_ID = "com.example.notification_example";
        String channelName = "My Background Service";
        NotificationChannel chan = new NotificationChannel(NOTIFICATION_CHANNEL_ID, channelName, NotificationManager.IMPORTANCE_NONE);
        chan.setLightColor(Color.BLUE);
        chan.setLockscreenVisibility(Notification.VISIBILITY_PRIVATE);
        NotificationManager manager = (NotificationManager) getSystemService(Context.NOTIFICATION_SERVICE);
        assert manager != null;
        manager.createNotificationChannel(chan);

        NotificationCompat.Builder notificationBuilder = new NotificationCompat.Builder(this, NOTIFICATION_CHANNEL_ID);

        Notification notification = notificationBuilder.setOngoing(true)
                .setSmallIcon(R.mipmap.ic_launcher)
                .setContentTitle("Đang ghi âm.")
                .setPriority(NotificationManager.IMPORTANCE_MIN)
                .setCategory(Notification.CATEGORY_SERVICE)
                .build();

        this.startForeground(111, notification);
    }

    private void Notification() {
        Notification notification = new Notification(R.drawable.stop_record, "Đang ghi âm", System.currentTimeMillis());
        NotificationManager notificationManager = (NotificationManager) getSystemService(Context.NOTIFICATION_SERVICE);
        notification.flags |= Notification.FLAG_AUTO_CANCEL;
        notificationManager.notify(111, notification);
    }


}

