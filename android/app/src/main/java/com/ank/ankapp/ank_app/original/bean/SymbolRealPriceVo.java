package com.ank.ankapp.ank_app.original.bean;

public class SymbolRealPriceVo<T> {

    private String op;
    private Boolean success;
    private String args;
    private T data;
    private String msg;

    public static String OP_SUB = "subscribe";//订阅数据
    public static String OP_UNSUB = "unsubscribe";//取消订阅数据
    public static String OP_PUSH = "push";//推送数据

    public static boolean SUCCESS = true;
    public static boolean ERROR = false;

    public String getOp() {
        return op;
    }

    public void setOp(String op) {
        this.op = op;
    }

    public Boolean getSuccess() {
        return success;
    }

    public void setSuccess(Boolean success) {
        this.success = success;
    }

    public String getArgs() {
        return args;
    }

    public void setArgs(String args) {
        this.args = args;
    }

    public T getData() {
        return data;
    }

    public void setData(T data) {
        this.data = data;
    }

    public String getMsg() {
        return msg;
    }

    public void setMsg(String msg) {
        this.msg = msg;
    }
}
