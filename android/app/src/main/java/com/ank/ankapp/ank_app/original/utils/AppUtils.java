package com.ank.ankapp.ank_app.original.utils;

import android.content.Context;
import android.content.pm.ApplicationInfo;
import android.content.pm.PackageInfo;
import android.content.pm.PackageManager;
import android.os.Build;
import android.text.Html;
import android.text.Spanned;
import android.text.TextUtils;
import android.webkit.CookieManager;
import android.webkit.CookieSyncManager;

import com.ank.ankapp.ank_app.original.Config;
import com.ank.ankapp.ank_app.original.bean.JsonVo;
import com.ank.ankapp.ank_app.original.bean.UserInfoVo;
import com.ank.ankapp.ank_app.original.language.LanguageUtil;
import com.github.mikephil.charting.formatter.LargeValueFormatter;
import com.google.gson.Gson;
import com.google.gson.GsonBuilder;
import com.google.gson.reflect.TypeToken;

import java.math.BigDecimal;
import java.nio.charset.StandardCharsets;
import java.text.ParseException;
import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.Date;
import java.util.Locale;
import java.util.TimeZone;

public class AppUtils {
    public static String getMetaDataString(Context cot, String key)
    {
        ApplicationInfo appInfo = null;
        try {
            appInfo = cot.getPackageManager().getApplicationInfo(cot.getPackageName(), PackageManager.GET_META_DATA);
        } catch (PackageManager.NameNotFoundException e) {
            e.printStackTrace();
        }

        String val = appInfo.metaData.getString(key);
        MLog.d("meta data:" + val );
        return val;
    }

    public static String getMetaDataIntStr(Context cot, String key)
    {
        ApplicationInfo appInfo = null;
        try {
            appInfo = cot.getPackageManager().getApplicationInfo(cot.getPackageName(), PackageManager.GET_META_DATA);
        } catch (PackageManager.NameNotFoundException e) {
            e.printStackTrace();
        }

        String val = String.valueOf(appInfo.metaData.getInt(key));
        MLog.d("meta data:" + val );
        return val;
    }

    public static String encode64(String str)
    {
        if (str == null || TextUtils.isEmpty(str)) return "";
        String s = com.huawei.hms.support.log.common.Base64.encode(str.getBytes(StandardCharsets.UTF_8));
        return s;
    }

    public static String decode64(String str)
    {
        //解码
        String s = new String(com.huawei.hms.support.log.common.Base64.decode(str), StandardCharsets.UTF_8);
        return s;
    }


    public static int getTimeZone()
    {
        TimeZone timeZone = TimeZone.getDefault();
        int rawOffset = timeZone.getRawOffset();
        return  rawOffset;
    }

    public static PackageInfo getAppVersionInfo(Context cot) {
        PackageManager packageManager = cot.getPackageManager();
        PackageInfo Info = null;
        try {
            Info = packageManager.getPackageInfo(cot.getPackageName(), 0);
           // Info.versionName = "";
            //Info.versionCode = 2;
        } catch (PackageManager.NameNotFoundException e) {
            e.printStackTrace();
        }

        return Info;
    }

    public static String getExtensionByFilePath(String filePath){
        String fe = "";
        int i = filePath.lastIndexOf('.');
        if (i > 0) {
            fe = filePath.substring(i+1);
        }
        System.out.println("File extension is : "+fe);
        return fe;
    }

    public static int getPrecision(String val){
        BigDecimal bigDecimal = new BigDecimal(val);
        return bigDecimal.scale();
    }

    public static String getFormatStringValue(float val)
    {
        String s = String.valueOf(val);
        BigDecimal bigDecimal = new BigDecimal(s);
        return  bigDecimal.toPlainString();
    }

    public static String getFormatStringValue(String val)
    {
        BigDecimal bigDecimal = new BigDecimal(val);
        return  bigDecimal.toPlainString();
    }

    public static String getFormatStringValue(float val, int precision)
    {
        String format = "%." + precision + "f";
        return String.format(Locale.ENGLISH,format, val);
    }

    public static String getFormatStringValue(String val, int precision)
    {
        String format = "%." + precision + "f";
        if (!TextUtils.isEmpty(val))
        {
            return String.format(Locale.ENGLISH,format, Float.valueOf(val));
        }

        return "0";
    }

    public static String getDifTime(long currTime,long end){
        //MLog.d("getDifTime:" + currTime/1000 + " " + end/1000 + " " + (end-currTime)/1000);
        long ms = end -currTime;
        Integer ss = 1000;
        Integer mi = ss * 60;
        Integer hh = mi * 60;
        Integer dd = hh * 24;
        if (currTime >= end)
        {
            return "";
        }

        if(ms>=dd){
            return "";
        }
        Long day = ms / dd;
        Long hour = (ms -day * dd) / hh;
        Long minute = (ms - day * dd - hour * hh) / mi;
        Long second = (ms - day * dd - hour * hh - minute * mi) / ss;

        StringBuffer sb = new StringBuffer();
        if(hour > 0) {
            sb.append(String.format("%02d", hour)+":");
        }
        if(minute > 0) {
            sb.append(String.format("%02d", minute)+":");
        }else {
            sb.append("00:");
        }
        if(second > 0) {
            sb.append(String.format("%02d", second));
        }else {
            sb.append("00");
        }

        return sb.toString();
    }

    public static Spanned fromHtml(String source) {
        if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.N) {
            return Html.fromHtml(source, Html.FROM_HTML_MODE_LEGACY);
        } else {
            return Html.fromHtml(source);
        }
    }

    //时间戳转 yyyy-MM-dd HH:mm
    public static String timeStamp2Date(String time) {
        Long timeLong = Long.parseLong(time);
        SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd HH:mm");//要转换的时间格式
        Date date;
        try {
            date = sdf.parse(sdf.format(timeLong));
            return sdf.format(date);
        } catch (ParseException e) {
            e.printStackTrace();
            return null;
        }
    }

    public static String timeStamp2DateNow(String time) {
        Long timeLong = Long.parseLong(time);
        SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss");//要转换的时间格式
        Date date;
        try {
            date = sdf.parse(sdf.format(timeLong));
            return sdf.format(date);
        } catch (ParseException e) {
            e.printStackTrace();
            return null;
        }
    }

    public static String getColorHexString(int color)
    {
        return String.format("%x", color).substring(2, 8);
    }

    public static String getString(Context cot, int resid)
    {
        return cot.getResources().getString(resid);
    }

    public static String getToken(Context cot)
    {
        JsonVo<UserInfoVo> jsonVo = AppUtils.getLoginInfo(cot);
        if (jsonVo != null && jsonVo.getCode() == 1)
        {
            return jsonVo.getData().getToken();
        }

        return "";
    }

    public static JsonVo<UserInfoVo> getLoginInfo(Context cot)
    {
        String json = Config.getMMKV(cot).getString(Config.CONF_LOGIN_USER_INFO, "");
        if (TextUtils.isEmpty(json) || json.length() < 10)
        {
            return null;
        }

        JsonVo<UserInfoVo> jsonVo;

        Gson gson = new GsonBuilder().create();
        jsonVo = gson.fromJson(json, new TypeToken<JsonVo<UserInfoVo>>() {}.getType());
        //MLog.d("getLoginInfo:" + json);
        return jsonVo;
    }

    public static String getLargeFormatString(float val)
    {
        LargeValueFormatter largeValueFormatter = new LargeValueFormatter();
        return largeValueFormatter.getFormattedValue(val, null);
    }

    public static String getLargeFormatString(String val)
    {
        LargeValueFormatter largeValueFormatter = new LargeValueFormatter();
        return largeValueFormatter.getFormattedValue(Float.valueOf(val), null);
    }

    public static String getLargeFormatString(float val, String local)
    {
        if (local.equalsIgnoreCase("zh"))
        {
            return FormatterDoubleVal.amountConversion(Double.valueOf(val));
        }

        LargeValueFormatter largeValueFormatter = new LargeValueFormatter();
        return largeValueFormatter.getFormattedValue(val, null);
    }

    public static String getLargeFormatString(String val, String local)
    {
        if (local.equalsIgnoreCase("zh"))
        {
            return FormatterDoubleVal.amountConversion(Double.valueOf(val));
        }

        LargeValueFormatter largeValueFormatter = new LargeValueFormatter();
        return largeValueFormatter.getFormattedValue(Float.valueOf(val), null);
    }

    public static void setCookieValue(Context context) {
        ArrayList<String> cookieList = new ArrayList<>();
        if (Config.getMMKV(context).getBoolean(Config.DAY_NIGHT_MODE, false)) {
            //cookieList.add("theme=dark");//网站用的是dark
            cookieList.add("theme=night");//app night
        } else {
            cookieList.add("theme=light");
        }

        if (AppUtils.getLoginInfo(context) != null) {
            cookieList.add("COINSOHO_KEY=" + AppUtils.getToken(context));
        } else {
            cookieList.add("COINSOHO_KEY=" + "");
        }

        if (Config.getMMKV(context).getBoolean(Config.IS_GREEN_UP, true)) {
            cookieList.add("green-up=true");
        } else {
            cookieList.add("green-up=false");
        }


        syncCookie(context, Config.strDomain, cookieList);
        String s = LanguageUtil.getShortLanguageName(context);
        cookieList.add("i18n_redirected=" + s);

        syncCookie(context, Config.depthOrderDomain, cookieList);//实时挂单数据url cookie

        //uni-app写入cookie
        syncCookie(context, Config.uniappDomain, cookieList);
    }

    private static void syncCookie(Context context, String domain, ArrayList<String> cookieList) {
        if (domain == null) return;
        CookieManager cookieManager = CookieManager.getInstance();
        cookieManager.setAcceptCookie(true);
        if (cookieList != null && cookieList.size() > 0) {
            for (String cookie : cookieList) {
                //MLog.d(domain + ":" + cookie);
                cookieManager.setCookie(domain, cookie);
            }
        }

        cookieManager.setCookie(domain, "Domain=" + domain);
        cookieManager.setCookie(domain, "Path=/");
        String cookies = cookieManager.getCookie(domain);
        if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.LOLLIPOP) {
            cookieManager.flush();
        } else {
            CookieSyncManager.createInstance(context);
            CookieSyncManager.getInstance().sync();
        }
    }

}

