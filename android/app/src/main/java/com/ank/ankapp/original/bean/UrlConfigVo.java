package com.ank.ankapp.original.bean;

public class UrlConfigVo {

    public String urlDepth;
    public String strDomain;
    public String websocketUrl;
    public String apiPrefix;
    public String h5Prefix;

    public String newUrlDepth;//1.0.14版本之后用这个新的配置，
    public String depthOrderDomain;//1.0.14版本之后用这个新的配置，

    public String newDepthOrderDomain;

    public String uniappDomain;

    public String urlCommonChart;
    public String urlImagePrefix;//币 logo路径前缀

    public String getUniappDomain() {
        return uniappDomain;
    }

    public void setUniappDomain(String uniappDomain) {
        this.uniappDomain = uniappDomain;
    }

    public String getNewDepthOrderDomain() {
        return newDepthOrderDomain;
    }

    public void setNewDepthOrderDomain(String newDepthOrderDomain) {
        this.newDepthOrderDomain = newDepthOrderDomain;
    }

    public String getNewUrlDepth() {
        return newUrlDepth;
    }

    public void setNewUrlDepth(String newUrlDepth) {
        this.newUrlDepth = newUrlDepth;
    }



    public String getDepthOrderDomain() {
        return depthOrderDomain;
    }

    public void setDepthOrderDomain(String depthOrderDomain) {
        this.depthOrderDomain = depthOrderDomain;
    }

    public String getUrlDepth() {
        return urlDepth;
    }

    public void setUrlDepth(String urlDepth) {
        this.urlDepth = urlDepth;
    }

    public String getStrDomain() {
        return strDomain;
    }

    public void setStrDomain(String strDomain) {
        this.strDomain = strDomain;
    }

    public String getWebsocketUrl() {
        return websocketUrl;
    }

    public void setWebsocketUrl(String websocketUrl) {
        this.websocketUrl = websocketUrl;
    }

    public String getApiPrefix() {
        return apiPrefix;
    }

    public void setApiPrefix(String apiPrefix) {
        this.apiPrefix = apiPrefix;
    }

    public String getH5Prefix() {
        return h5Prefix;
    }

    public void setH5Prefix(String h5Prefix) {
        this.h5Prefix = h5Prefix;
    }
}
