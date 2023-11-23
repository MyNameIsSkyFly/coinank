package com.ank.ankapp.original.bean;

public class VersionDataVo {

    public String versionName;
    public int versionCode;
    public String url;

    public String googleVersion;
    public int googleVersionCode;
    public String googleUrl;

    public String getGoogleVersion() {
        return googleVersion;
    }

    public void setGoogleVersion(String googleVersion) {
        this.googleVersion = googleVersion;
    }

    public int getGoogleVersionCode() {
        return googleVersionCode;
    }

    public void setGoogleVersionCode(int googleVersionCode) {
        this.googleVersionCode = googleVersionCode;
    }

    public String getGoogleUrl() {
        return googleUrl;
    }

    public void setGoogleUrl(String googleUrl) {
        this.googleUrl = googleUrl;
    }

    public String getVersionName() {
        return versionName;
    }

    public void setVersionName(String versionName) {
        this.versionName = versionName;
    }

    public int getVersionCode() {
        return versionCode;
    }

    public void setVersionCode(int versionCode) {
        this.versionCode = versionCode;
    }

    public String getUrl() {
        return url;
    }

    public void setUrl(String url) {
        this.url = url;
    }
}
