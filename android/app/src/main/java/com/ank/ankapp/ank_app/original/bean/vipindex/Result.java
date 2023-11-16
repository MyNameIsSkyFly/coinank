package com.ank.ankapp.ank_app.original.bean.vipindex;


/*@Getter
@Setter*/
public class Result<T> {

    public static final String SUCCESS = "1";
    public static final String ERROR = "0";
    public static final String TIMEOUT = "-1";


    private boolean success;
    private String code;

    public void setSuccess(boolean success) {
        this.success = success;
    }

    public String getCode() {
        return code;
    }

    public void setCode(String code) {
        this.code = code;
    }

    public String getMsg() {
        return msg;
    }

    public void setMsg(String msg) {
        this.msg = msg;
    }

    public T getData() {
        return data;
    }

    public void setData(T data) {
        this.data = data;
    }

    public Object getExt() {
        return ext;
    }

    public void setExt(Object ext) {
        this.ext = ext;
    }

    private String msg;
    private T data;
    private Object ext;

    public Result(String code) {
        this.code = code;
    }

    public Result(String code, String msg) {
        this.code = code;
        this.msg = msg;
    }

    public Result(String code, T data) {
        this.code = code;
        this.data = data;
    }

    public Result() {
    }




    public static <T> Result success() {
        Result result = new Result<>();
        result.setSuccess(true);
        result.setCode(SUCCESS);
        return result;
    }

    public static <T> Result<T> success(T t) {
        Result result = new Result<>();
        result.setCode(SUCCESS);
        result.setSuccess(true);
        result.setData(t);
        return result;
    }


    public boolean isSuccess() {
        return success;
    }



    public static Result error(String code) {
        Result result = new Result<>();
        result.setCode(code);
        return result;
    }


    public static Result error(String code, String msg) {
        Result result = new Result<>();
        result.setCode(code);
        result.setMsg(msg);
        return result;
    }

    /*
    public static Result error(ResultError resultError) {
            Result result = new Result<>();
            result.setCode(resultError.getCode());
            result.setMsg(resultError.getMsg());
            return result;
    }
     */

    public static Result errorMsg(String msg) {
        Result result = new Result<>();
        result.setCode(ERROR);
        result.setMsg(msg);
        return result;
    }


    public Result code(String code) {
        this.code = code;
        return this;
    }

    public Result msg(String msg) {
        this.msg = msg;
        return this;
    }

    public Result data(T t) {
        this.data = t;
        return this;
    }

    public Result ext(Object ext) {
        this.ext = ext;
        return this;
    }

    public static  Result success(String msg) {
        Result result = new Result<>();
        result.setSuccess(true);
        result.setCode(SUCCESS);
        result.setMsg(msg);
        return result;
    }




}
