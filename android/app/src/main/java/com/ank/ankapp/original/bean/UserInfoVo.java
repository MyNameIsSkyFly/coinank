package com.ank.ankapp.original.bean;

public class UserInfoVo {

    private String userId;
    private String userName;
    private String userType;

    private String token;

    private Integer memberType;//会员类型
    private String memberPeriod;//会员周期
    //private long memberOpenTime;//会员开通时间
    private long memberExpiredTime;//会员失效时间
    private String status;//用户状态 0 有效 1注销
    private long ts;//创建时间
    //private Date expireDAte;//会员到期时间
//private String deviceId;//设备id
//private String rebate;
//private String indirectRebateRatio;//间接返佣比例
//private String directRebateRatio;//直接用户返佣比例


//private String referralBy;//是谁推荐过来的用户
//private String referralCode;//我的推荐吗

    private boolean trialed;//已经试用过了


    public String getUserId() {
        return userId;
    }

    public void setUserId(String userId) {
        this.userId = userId;
    }

    public String getUserName() {
        return userName;
    }

    public void setUserName(String userName) {
        this.userName = userName;
    }

    public String getUserType() {
        return userType;
    }

    public void setUserType(String userType) {
        this.userType = userType;
    }

    public String getToken() {
        return token;
    }

    public void setToken(String token) {
        this.token = token;
    }
}
