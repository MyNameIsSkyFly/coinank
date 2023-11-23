package com.ank.ankapp.original;

import android.app.Notification;
import android.app.NotificationChannel;
import android.app.NotificationChannelGroup;
import android.app.NotificationManager;
import android.content.Context;
import android.graphics.Bitmap;
import android.graphics.Color;
import android.graphics.drawable.BitmapDrawable;
import android.graphics.drawable.Drawable;
import android.net.Uri;
import android.os.Build;
import android.service.notification.StatusBarNotification;
import android.text.TextUtils;

import androidx.annotation.RequiresApi;

import com.alibaba.sdk.android.push.CloudPushService;
import com.alibaba.sdk.android.push.CommonCallback;
import com.alibaba.sdk.android.push.huawei.HuaWeiRegister;
import com.alibaba.sdk.android.push.noonesdk.PushServiceFactory;
import com.alibaba.sdk.android.push.register.GcmRegister;
import com.ank.ankapp.original.utils.AppUtils;
import com.ank.ankapp.original.utils.MLog;

import java.util.List;

public class PushSetting {
    public  static final String TAG = "Init";

    public static final String DEFAULT_RES_PATH_FREFIX = "android.resource://";
    public static final String DEFAULT_RES_SOUND_TYPE = "raw";
    public static final String DEFAULT_RES_ICON_TYPE = "mipmap";

    public static final String NORMAL_NOTIFY_SOUND = "normal";
    public static final String UP_SOUND = "up";
    public static final String DOWN_SOUND = "down";
    public static final String DEFAULT_NOTICE_LARGE_ICON = "empty_icon";
    public static final String ASSIGN_NOTIFCE_LARGE_ICON = "empty_icon";
    public static final String DEFAULT_NOTICE_SMALL_ICON = "small_icon";
    public static final String ASSIGN_NOTICE_SMALL_ICON = "small_icon";

    public static Context cot;
    public static App app;

    public static CloudPushService mPushService;
    public static String PackageName;
    public static final String SETTING_NOTICE = "setting_notification";

    /**
     * 设置默认通知声音示例
     * 1. 如果用户未调用过setNotificationSoundFilePath()接口，默认取R.raw.alicloud_notification_sound声音文件
     * 则无需使用以下方式进行设置
     */
    private void setDefNotifSound(Context cot) {
        int defaultSoundId = cot.getResources().getIdentifier(NORMAL_NOTIFY_SOUND, DEFAULT_RES_SOUND_TYPE, PackageName);
        if (defaultSoundId != 0) {
            String defaultSoundPath = DEFAULT_RES_PATH_FREFIX + cot.getPackageName() + "/" + defaultSoundId;
            mPushService.setNotificationSoundFilePath(defaultSoundPath);
        } else {

        }
    }

    /**
     * 指定通知声音文件示例
     * 1. 此处指定资源Id为R.raw.alicloud_notification_sound_assgin的声音文件
     */
    private void setCusNotifSound(Context cot) {
        int assignSoundId = cot.getResources().getIdentifier(UP_SOUND, DEFAULT_RES_SOUND_TYPE, PackageName);
        if (assignSoundId != 0) {
            String defaultSoundPath = DEFAULT_RES_PATH_FREFIX + cot.getPackageName() + "/" + assignSoundId;
            mPushService.setNotificationSoundFilePath(defaultSoundPath);
        } else {
        }
    }

    /**
     * 设置默认通知图标方法示例
     * 1. 如果用户未调用过setNotificationLargeIcon()接口，默认取R.raw.alicloud_notification_largeicon图标资源
     * 则无需使用以下方式进行设置
     */
    private static void setDefNotifIcon(Context cot) {
        int defaultLargeIconId = cot.getResources().getIdentifier(DEFAULT_NOTICE_LARGE_ICON,
                DEFAULT_RES_ICON_TYPE, PackageName);
        if (defaultLargeIconId != 0) {
            Drawable drawable = cot.getResources().getDrawable(defaultLargeIconId);
            if (drawable != null) {
                Bitmap bitmap = ((BitmapDrawable)drawable).getBitmap();
                mPushService.setNotificationLargeIcon(bitmap);
            }
        } else {

        }

    }

    /**
     * 自定义通知图片示例
     * 1. 此处指定资源Id为R.raw.alicloud_notification_largeicon_assgin的图标资源
     */
    private void setCusNotifIcon(Context cot) {
        int assignLargeIconId = cot.getResources().getIdentifier(ASSIGN_NOTIFCE_LARGE_ICON,
                DEFAULT_RES_ICON_TYPE, PackageName);
        if (assignLargeIconId != 0) {
            Drawable drawable = cot.getResources().getDrawable(assignLargeIconId);
            if (drawable != null) {
                Bitmap bitmap = ((BitmapDrawable)drawable).getBitmap();
                mPushService.setNotificationLargeIcon(bitmap);
            }
        } else {
        }
    }

    /**
     * 设置默认状态栏通知图标示例
     * 1. 如果用户未调用过setNotificationSmallIcon()接口，默认取R.raw.alicloud_notification_smallicon图标资源
     * 则无需使用以下方式进行设置
     */
    private static void setDefNotifSmallIcon(Context cot) {
        int defaultSmallIconId = cot.getResources().getIdentifier(DEFAULT_NOTICE_SMALL_ICON,
                DEFAULT_RES_ICON_TYPE, PackageName);
        if (defaultSmallIconId != 0) {
            mPushService.setNotificationSmallIcon(defaultSmallIconId);
        } else {
        }
    }

    /**
     * 自定义状态栏通知图标示例
     * 1. 此处指定资源Id为R.raw.alicloud_notification_smallicon_assgin的图标资源
     */
    private void setCusNotifSmallIcon(Context cot) {
        int assignSmallIconId = cot.getResources().getIdentifier(ASSIGN_NOTICE_SMALL_ICON, DEFAULT_RES_ICON_TYPE, PackageName);
        if (assignSmallIconId != 0) {
            mPushService.setNotificationSmallIcon(assignSmallIconId);
        } else {
        }
    }

    /**
     * 初始化云推送通道
     *
     * @param applicationContext
     */
    public static void initCloudChannel(final Context applicationContext) {
        // 创建notificaiton channel
        createNotificationChannel("0", "Normal Notice", "Normal Notice", "normal");//正常通知
        createNotificationChannel("1", "Alert UP", "Alert UP", "up2");//上涨
        createNotificationChannel("2", "Alert Down", "Alert Down", "down");//下跌
        createServiceChannel("4", "Floating Window");//悬浮窗通知

        PushServiceFactory.init(applicationContext);
        mPushService = PushServiceFactory.getCloudPushService();
        mPushService.setLogLevel(CloudPushService.LOG_DEBUG);//关闭阿里云推送调试日志
        //mPushService.setPushIntentService(MyMessageIntentService.class);
        setDefNotifIcon(applicationContext);
        setDefNotifSmallIcon(applicationContext);

        //mPushService.setDebug(false);
        mPushService.register(applicationContext, new CommonCallback() {
            @Override
            public void onSuccess(String response) {
                MLog.i(TAG, "&&&&&&&&&init cloudchannel success");
                Config.DeviceID = PushServiceFactory.getCloudPushService().getDeviceId();
                Config.getMMKV(applicationContext).putString(Config.CONF_DEVICEID, Config.DeviceID);

                // 注册方法会自动判断是否支持华为系统推送，如不支持会跳过注册。
                boolean b = HuaWeiRegister.register(app);
                if (b)
                {
                    MLog.d("\nHuaWeiRegister success ********:\n" );
                }
                else
                {
                    MLog.d("\nHuaWeiRegister failure ********\n");
                }

            }

            @Override
            public void onFailed(String errorCode, String errorMessage) {
                MLog.e(TAG, "init cloudchannel failed -- errorcode:" + errorCode + " -- errorMessage:" + errorMessage);
            }
        });


        //GCM/FCM辅助通道注册
        String send = AppUtils.getMetaDataString(applicationContext, "gcm_sender").split(":")[1];
        MLog.d("sneder:" + send);
        boolean bgoogle = GcmRegister.register(applicationContext,
                send,
                AppUtils.getMetaDataString(applicationContext, "gcm_appid"),
                "coinsoho-7bc4f",
                AppUtils.decode64(AppUtils.getMetaDataString(applicationContext, "gcm_kkk")));

        if (bgoogle)
        {
            MLog.d("\n\nGcmRegister success ********:\n" );
        }
        else
        {
            MLog.d("\n\nGcmRegister failure ********\n\n");
        }

    }


    private static String createServiceChannel(String channelId, String channelName){
        if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.O) {
            NotificationChannel chan = new NotificationChannel(channelId,
                    channelName, NotificationManager.IMPORTANCE_HIGH);
            chan.setLightColor(Color.BLUE);
            chan.setLockscreenVisibility(Notification.VISIBILITY_PRIVATE);
            NotificationManager service = (NotificationManager) cot.getSystemService(Context.NOTIFICATION_SERVICE);
            service.createNotificationChannel(chan);
        }

        return channelId;
    }

    private static void createNotificationChannel(String changleID, String changleName, String changleDesc, String soundName) {
        if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.O) {
            NotificationManager mNotificationManager = (NotificationManager) cot.getSystemService(Context.NOTIFICATION_SERVICE);
            // 通知渠道的id
            String id = changleID;
            // 用户可以看到的通知渠道的名字.
            CharSequence name = changleName;
            // 用户可以看到的通知渠道的描述
            String description = changleDesc;
            int importance = NotificationManager.IMPORTANCE_HIGH;
            NotificationChannel mChannel = new NotificationChannel(id, name, importance);
            mChannel.setGroup("group");
            mChannel.setLockscreenVisibility(Notification.VISIBILITY_PRIVATE);
            // 配置通知渠道的属性
            mChannel.setDescription(description);
            int assignSoundId = cot.getResources().getIdentifier(soundName, DEFAULT_RES_SOUND_TYPE, PackageName);
            if (assignSoundId != 0) {
                String defaultSoundPath = DEFAULT_RES_PATH_FREFIX + cot.getPackageName() + "/" + assignSoundId;
                mChannel.setSound(Uri.parse(defaultSoundPath), Notification.AUDIO_ATTRIBUTES_DEFAULT);
            }


            // 设置通知出现时的闪灯（如果 android 设备支持的话）
            //mChannel.enableLights(true);
            //mChannel.setLightColor(Color.RED);
            // 设置通知出现时的震动（如果 android 设备支持的话）
            //mChannel.enableVibration(true);
            //mChannel.setVibrationPattern(new long[]{100, 200, 300, 400, 500, 400, 300, 200, 400});
            //最后在notificationmanager中创建该通知渠道
            mNotificationManager.createNotificationChannelGroup(new NotificationChannelGroup("group", "groupname"));
            mNotificationManager.createNotificationChannel(mChannel);
        }
    }

    @RequiresApi(api = Build.VERSION_CODES.O)
    private static void deleteNoNumberNotification(NotificationManager nm, String newChannelId) {
        List<NotificationChannel> notificationChannels = nm.getNotificationChannels();
        if (notificationChannels == null || notificationChannels.size() < 5) {
            return;
        }

        for (NotificationChannel channel : notificationChannels) {
            if (channel.getId() == null || channel.getId().equals(newChannelId)) {
                ///continue;
            }

            int notificationNumbers = getNotificationNumbers(nm, channel.getId());
            MLog.i(TAG, "notificationNumbers: " + notificationNumbers + " channelId:" + channel.getId());
            if (notificationNumbers == 0) {
                MLog.i(TAG, "deleteNoNumberNotification: " + channel.getId());
                nm.deleteNotificationChannel(channel.getId());
            }
        }
    }

    /**
     * 获取某个渠道下状态栏上通知显示个数
     *
     * @param mNotificationManager NotificationManager
     * @param channelId            String
     * @return int
     */
    @RequiresApi(api = Build.VERSION_CODES.O)
    private static int getNotificationNumbers(NotificationManager mNotificationManager, String channelId) {
        if (mNotificationManager == null || TextUtils.isEmpty(channelId)) {
            return -1;
        }
        int numbers = 0;
        StatusBarNotification[] activeNotifications = mNotificationManager.getActiveNotifications();
        for (StatusBarNotification item : activeNotifications) {
            Notification notification = item.getNotification();
            if (notification != null) {
                if (channelId.equals(notification.getChannelId())) {
                    numbers++;
                }
            }
        }
        return numbers;
    }

}
