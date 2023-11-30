package com.ank.ankapp.original.utils;

import android.os.Handler;

import androidx.annotation.Nullable;

import com.ank.ankapp.original.Config;

import org.json.JSONException;
import org.json.JSONObject;

import java.util.ArrayList;
import java.util.concurrent.TimeUnit;

import okhttp3.OkHttpClient;
import okhttp3.Request;
import okhttp3.Response;
import okhttp3.WebSocket;
import okhttp3.WebSocketListener;
import okio.ByteString;


public class WebSocketUtils {
    private int invokenTickCnt = 1;//请求次数，悬浮窗和K线界面请求了不同实时价格，则业务退出一次减少一次计数
    private final long tickInterval = 5*1000;

    private WebSocket mWebSocket;
    private OkHttpClient mClient;
    private Request mRequest;
    private ArrayList<String> subscribeArrList;

    public WebSocketUtils() {}

    private static class SingleInstance
    {
        private static final  WebSocketUtils instance = new WebSocketUtils();
    }

    public static WebSocketUtils getInstance()
    {
        return SingleInstance.instance;
    }



    public void createWebSocket() {
        invokenTickCnt = 1;
        mClient = new OkHttpClient.Builder().
                readTimeout(8, TimeUnit.SECONDS).
                writeTimeout(5, TimeUnit.SECONDS).
                connectTimeout(8, TimeUnit.SECONDS).
                pingInterval(30, TimeUnit.SECONDS).
                //proxy(new Proxy(Proxy.Type.HTTP, new InetSocketAddress("192.168.10.103", 7890))).
                build();
        mRequest = new Request.Builder().url(Config.websocketUrl).build();
        removeAllSubscribe();//由于是静态对象,移除之前的
        startConnect();
        tickPro();
    }

    public void deinitWebSocket()
    {
        removeAllSubscribe();
        closeWebSocket();
    }

    public void addSubscribe(String args) {
        if (subscribeArrList == null) {
            subscribeArrList = new ArrayList<>();
        }

        if (args.contains("kline@"))
        {
            subscribeArrList.add(args);
            sendMsg(0, args);
        }
    }

    public void removeSubscribe(String args) {
        if (subscribeArrList == null) {
            subscribeArrList = new ArrayList<>();
        }

        int size = subscribeArrList.size();
        if (size > 0) {
            if (args.contains("kline@"))
            {
                for (int i = 0; i < size; i++)
                {
                    if (subscribeArrList.get(i).equals(args))
                    {
                        sendMsg(1, args);
                        subscribeArrList.remove(i);
                        return;
                    }
                }
            }
        }

        if (args.contains("kline@"))
        {
            sendMsg(1, args);
        }

    }

    public void removeAllSubscribe() {
        if (subscribeArrList == null) {
            subscribeArrList = new ArrayList<>();
        }

        int size = subscribeArrList.size();
        if (size > 0) {
            for (int i = 0; i < size; i++)
            {
                sendMsg(1, subscribeArrList.get(i));
            }

            subscribeArrList.clear();
        }
    }

    //msgType 0为订阅  1为取消订阅
    public void sendMsg(int msgType, String args)
    {
        if (mWebSocket == null) return;

        String type = "";
        if (msgType == 0)
        {
            type = "subscribe";
        }
        else
        {
            type = "unsubscribe";
        }

        String message = "";
        JSONObject jobj = new JSONObject();
        try {
            jobj.put("op", type);
            jobj.put("args", args);
            message = jobj.toString();
            //MLog.d("send msg:" + message);
        } catch (JSONException e) {
            e.printStackTrace();
        }

        mWebSocket.send(message);
    }

    public void sendMsg(WebSocket webSocket, int msgType, String args)
    {
        if (webSocket == null) return;

        String type = "";
        if (msgType == 0)
        {
            type = "subscribe";
        }
        else
        {
            type = "unsubscribe";
        }

        String message = "";
        JSONObject jobj = new JSONObject();
        try {
            jobj.put("op", type);
            jobj.put("args", args);
            message = jobj.toString();
            //MLog.d("send msg:" + message);
        } catch (JSONException e) {
            e.printStackTrace();
        }

        webSocket.send(message);
    }

    public void closeWebSocket(WebSocket webSocket)
    {
        if (webSocket != null)
        {
            webSocket.close(1000, null);
            webSocket = null;
        }

    }

    public void closeWebSocket()
    {
        invokenTickCnt = 0;
        mHandler.removeCallbacks(tickRunable);
        if (mWebSocket != null)
        {
            mWebSocket.close(1000, null);
            mWebSocket = null;
        }

    }

    private void startConnect()
    {
        //MLog.i("uukr", "startConnect invokenTickCnt=" + invokenTickCnt);
        if (invokenTickCnt <= 0) return;

        mClient.newWebSocket(mRequest, new WebSocketListener() {
            @Override
            public void onOpen(WebSocket webSocket, Response response) {//开启长连接成功的回调
                super.onOpen(webSocket, response);
                //MLog.d("uukr", "onOpen:"+response.toString());

                if (onMsgListener != null)
                {
                    onMsgListener.doEvent();
                }

                mWebSocket = webSocket;

                if (subscribeArrList == null) {
                    subscribeArrList = new ArrayList<>();
                }

                for (int i = 0; i < subscribeArrList.size(); i++)
                {
                    sendMsg(0, subscribeArrList.get(i));
                }
            }

            @Override
            public void onMessage(WebSocket webSocket, String text) {//接收消息的回调
                super.onMessage(webSocket, text);
                if (webSocket != mWebSocket)
                {
                    MLog.d("onMessage closeWebSocket");
                    closeWebSocket(webSocket);//added by listen 220818
                    return;
                }

                if (onMsgListener != null)
                {
                    onMsgListener.onMsg(text);
                    onMsgListener.onMsg(webSocket, text);
                }
            }

            @Override
            public void onMessage(WebSocket webSocket, ByteString bytes) {
                super.onMessage(webSocket, bytes);
            }

            @Override
            public void onClosing(WebSocket webSocket, int code, String reason) {
                super.onClosing(webSocket, code, reason);
                MLog.d("uukr", "onClosing:"+reason);
                if (onMsgListener != null)
                {
                    onMsgListener.doEvent();
                }
            }

            @Override
            public void onClosed(WebSocket webSocket, int code, String reason) {
                super.onClosed(webSocket, code, reason);
                MLog.d("uukr", "onClosed:"+reason);
                if (onMsgListener != null)
                {
                    onMsgListener.doEvent();
                }
            }

            @Override
            public void onFailure(WebSocket webSocket, Throwable t, @Nullable Response response) {//长连接连接失败的回调
                super.onFailure(webSocket, t, response);
                MLog.d("uukr", "onFailure:");
                if(response != null)
                {
                    MLog.d("uukr", "onFailure:"+ response);
                }

                if (onMsgListener != null)
                {
                    onMsgListener.doEvent();
                }

                mHandler.removeCallbacks(tickRunable);
                mHandler.postDelayed(tickRunable, 2000);
                //tickPro();
            }
        });

        // mClient.dispatcher().executorService().shutdown();

        MLog.d("uukr", "initsocket done");
    }

    private  void tickPro()
    {
        mHandler.removeCallbacks(tickRunable);
        mHandler.postDelayed(tickRunable, tickInterval);
    }

    private long sendTime = 0L;
    // 发送心跳包
    private final Handler mHandler = new Handler();
    private final Runnable tickRunable = new Runnable() {
        @Override
        public void run() {
            //MLog.d("tickRunable ready run");
            if (invokenTickCnt <= 0) return;
            if (System.currentTimeMillis() - sendTime >= tickInterval) {

                if(mWebSocket!=null) {
                    String message = "";
                    message = "ping";
                    boolean isSuccess = mWebSocket.send(message);//发送一个消息给服务器，通过发送消息的成功失败来判断长连接的连接状态
                    if (!isSuccess) {//长连接已断开，
                        MLog.d("Tick Failure");
                        mHandler.removeCallbacks(tickRunable);
                        mWebSocket.cancel();//取消掉以前的长连接
                        startConnect();
                    } else {//长连接处于连接状态---
                        //MLog.d("Tick  is OK");
                    }
                }
                else
                {
                    MLog.d("mWebSocket is null else startConnect");
                    startConnect();
                }

                if (onMsgListener != null)
                {
                    onMsgListener.doEvent();
                }

                sendTime = System.currentTimeMillis();
            }


            mHandler.postDelayed(tickRunable, tickInterval);
        }
    };

    private OnMessageListener onMsgListener;
    public void setOnMsgListener(OnMessageListener listener)
    {
        onMsgListener = listener;
    }

    public interface OnMessageListener {
        void onMsg(String json);
        void onMsg(WebSocket webSocket, String json);
        void doEvent();
    }

}

