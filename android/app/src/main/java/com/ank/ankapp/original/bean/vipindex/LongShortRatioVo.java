package com.ank.ankapp.original.bean.vipindex;

import java.util.ArrayList;
import java.util.List;

//多空人数比，大户账户数多空比，大户持仓量多空比
public class LongShortRatioVo {

    List<String> tss = new ArrayList<>();
    List<Float> longShortRatio = new ArrayList<>();

    public List<String> getTss() {
        return tss;
    }

    public void setTss(List<String> tss) {
        this.tss = tss;
    }

    public List<Float> getLongShortRatio() {
        return longShortRatio;
    }

    public void setLongShortRatio(List<Float> longShortRatio) {
        this.longShortRatio = longShortRatio;
    }
}
