package com.ank.ankapp.ank_app.original.utils;

import com.ank.ankapp.ank_app.original.bean.JsonVo;

public class ApiErrorInfo {

    public static String getCodeMsg(JsonVo jsonVo){
        if (jsonVo.getCode() != 1)
        {
            return jsonVo.getMsg();
        }

        return "Success";
    }
}

