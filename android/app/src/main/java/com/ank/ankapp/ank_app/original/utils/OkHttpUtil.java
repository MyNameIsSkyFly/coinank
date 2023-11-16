package com.ank.ankapp.ank_app.original.utils;

import android.os.Handler;
import android.text.TextUtils;

import java.io.IOException;
import java.security.SecureRandom;
import java.security.cert.CertificateException;
import java.security.cert.X509Certificate;
import java.util.concurrent.TimeUnit;

import javax.net.ssl.HostnameVerifier;
import javax.net.ssl.SSLContext;
import javax.net.ssl.SSLSession;
import javax.net.ssl.TrustManager;
import javax.net.ssl.X509TrustManager;

import okhttp3.Call;
import okhttp3.Callback;
import okhttp3.OkHttpClient;
import okhttp3.Request;
import okhttp3.RequestBody;
import okhttp3.Response;

/**
 * OkHttp的工具类
 */
public class OkHttpUtil {

    private static OkHttpClient okHttpClient;
    private static Handler handler = new Handler();

    public static void initOkHttp() {
        OkHttpClient.Builder builder = new OkHttpClient.Builder()
                .connectTimeout(10, TimeUnit.SECONDS)
                .readTimeout(10, TimeUnit.SECONDS)
                .writeTimeout(10, TimeUnit.SECONDS)
                .retryOnConnectionFailure(false);

        //处理https协议
        SSLContext sc;
        try {
            sc = SSLContext.getInstance("SSL");
            sc.init(null, new TrustManager[]{new X509TrustManager() {
                @Override
                public void checkClientTrusted(X509Certificate[] chain, String authType) throws CertificateException {}

                @Override
                public void checkServerTrusted(X509Certificate[] chain, String authType) throws CertificateException {}

                @Override
                public X509Certificate[] getAcceptedIssuers() {
                    return new X509Certificate[]{};
                }
            }}, new SecureRandom());
        } catch (Exception e) {
            e.printStackTrace();
            sc = null;
        }

        if (sc != null) {
            okHttpClient = builder.hostnameVerifier(new HostnameVerifier() {
                        @Override
                        public boolean verify(String hostname, SSLSession session) {
                            return true;
                        }
                    })
                    .sslSocketFactory(sc.getSocketFactory())
                    .build();
        } else {
            okHttpClient = builder.build();
        }
    }

    /**
     * 取消所有请求
     */
    public static void cancel() {
        okHttpClient.dispatcher().cancelAll();
    }

    //get 请求，带参数obj,vip指标加载时需要用到
    public static void getJSON(String url, Object obj, OnDataListener dataListener) {
        if (!TextUtils.isEmpty(url)) {
            Request request = new Request.Builder()
                    .url(url)
                    .addHeader("client", "android")
                    .build();
            MLog.d("url " + url);
            okHttpClient.newCall(request).enqueue(new OkHttpCallback(url, obj, dataListener));
        }
    }

    /**
     * //get请求，header添加了client
     */
    public static void getJSON(String url, OnDataListener dataListener) {
        if (!TextUtils.isEmpty(url)) {
            Request request = new Request.Builder()
                    .url(url)
                    .addHeader("client", "android")
                    .build();
            MLog.d("url " + url);
            okHttpClient.newCall(request).enqueue(new OkHttpCallback(url, dataListener));
        }
    }

    //get请求，header添加了client和token
    public static void getJSON(String url, String head, OnDataListener dataListener) {
        if (!TextUtils.isEmpty(url)) {
            Request request = new Request.Builder()
                    .url(url)
                    .addHeader("token", head)
                    .addHeader("client", "android")
                    .build();
            MLog.d("url " + url);
            okHttpClient.newCall(request).enqueue(new OkHttpCallback(url, dataListener));
        }
    }

    //post请求，header添加了client
    public static void postJson(String url, RequestBody body, OnDataListener dataListener) {
        if (!TextUtils.isEmpty(url)) {
            MLog.d("post:" + url);
            MLog.d("post params:" + body.toString());
            //RequestBody body = RequestBody.create(MediaType.parse("application/json"), json);
            Request request = new Request.Builder()
                    .url(url)
                    .addHeader("client", "android")
                    .post(body)
                    .build();
            okHttpClient.newCall(request).enqueue(new OkHttpCallback(url, dataListener));
        }
    }


    //post请求，header添加了token和client
    public static void postJson(String url,String head, RequestBody body, OnDataListener dataListener) {
        if (!TextUtils.isEmpty(url)) {
            MLog.d("post:" + url);
            MLog.d("post params:" + body.toString());
            Request request = new Request.Builder()
                    .url(url)
                    .addHeader("token", head)
                    .addHeader("client", "android")
                    .post(body)
                    .build();
            okHttpClient.newCall(request).enqueue(new OkHttpCallback(url, dataListener));
        }
    }


    /**
     * 结果回调
     */
    static class OkHttpCallback implements Callback {

        private String url;
        private Object object;
        private OnDataListener dataListener;

        public OkHttpCallback(String url, OnDataListener dataListener) {
            this.url = url;
            this.dataListener = dataListener;
        }

        public OkHttpCallback(String url, Object obj, OnDataListener dataListener) {
            this.url = url;
            this.dataListener = dataListener;
            this.object = obj;
        }

        @Override
        public void onFailure(Call call, IOException e) {
            onFail(dataListener, url, e);
        }

        @Override
        public void onResponse(Call call, Response response) throws IOException {
            onResp(dataListener, url, object, response.body().string());
        }
    }

    private static void onFail(final OnDataListener dataListener, final String url, final IOException e) {
        handler.post(new Runnable() {
            @Override
            public void run() {
                try {
                    if (dataListener != null) {
                        MLog.e("loge", "onFailure: " + url + "\n" + e.getMessage());
                        dataListener.onFailure(url, e.getMessage());
                    }
                } catch (Exception e) {
                    MLog.e("loge", "E: " + e.getMessage());
                }
            }
        });
    }

    private static void onResp(final OnDataListener dataListener, final String url, final Object obj,final String json) {
        handler.post(new Runnable() {
            @Override
            public void run() {
                try {
                    if (dataListener != null && !TextUtils.isEmpty(json)) {
                        dataListener.onResponse(url, obj, json);
                    }
                } catch (Exception e) {
                    e.printStackTrace();
                    MLog.d(" onResp exception ***&&& " + e.getMessage());
                    if (dataListener != null) {
                        dataListener.onFailure(url, e.getMessage());
                    }
                }
            }
        });
    }

    public interface OnDataListener {
        void onResponse(String url, Object obj,String json);
        void onFailure(String url, String error);
    }
}
