package com.ank.ankapp.original.bean;

import java.util.ArrayList;
import java.util.List;

public class ResponseSymbolVo {

    private Boolean success;
    private int code;
    private String msg;
    private List<SymbolVo> data;

    public ResponseSymbolVo() {
        data = new ArrayList<>();
    }

    public Boolean getSuccess() {
        return success;
    }

    public void setSuccess(Boolean success) {
        this.success = success;
    }

    public int getCode() {
        return code;
    }

    public void setCode(int code) {
        this.code = code;
    }

    public String getMsg() {
        return msg;
    }

    public void setMsg(String msg) {
        this.msg = msg;
    }

    public List<SymbolVo> getData() {
        return data;
    }

    public void setData(List<SymbolVo> data) {
        this.data = data;
    }
}
