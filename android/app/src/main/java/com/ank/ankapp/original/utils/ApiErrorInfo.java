package com.ank.ankapp.original.utils;

import com.ank.ankapp.original.bean.JsonVo;

public class ApiErrorInfo {

    public static String getCodeMsg(JsonVo jsonVo){
        if (jsonVo.getCode() != 1)
        {
            return jsonVo.getMsg();
        }

        return "Success";
    }
}

