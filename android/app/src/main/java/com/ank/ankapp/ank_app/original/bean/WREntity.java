package com.ank.ankapp.ank_app.original.bean;

import static java.lang.Float.NaN;

import java.util.ArrayList;
import java.util.List;

/**
 * Created by loro on 2017/3/2.
 */

public class WREntity {
    private ArrayList<Float> WRs;

    /**
     * @param kLineBeens
     * @param n          几日
     */
    public WREntity(List<KLineItem> kLineBeens, int n) {
        this(kLineBeens, n, NaN);
    }

    /**
     * @param kLineBeens
     * @param n          几日
     * @param defult     不足N日时的默认值
     */
    public WREntity(List<KLineItem> kLineBeens, int n, float defult) {
        WRs = new ArrayList<Float>();
        ArrayList<Float> wRs = new ArrayList<Float>();
        float wms = 0.0f;
        int index = n - 1;
        if (kLineBeens != null && kLineBeens.size() > 0) {
            KLineItem kLineItem = kLineBeens.get(0);
            float high = kLineItem.high;
            float low = kLineItem.low;

            for (int i = 0; i < kLineBeens.size(); i++) {
                if (i > 0) {
                    if (n == 0) {
                        kLineItem = kLineBeens.get(i);
                        high = high > kLineItem.high ? high : kLineItem.high;
                        low = low < kLineItem.low ? low : kLineItem.low;
                    } else {
                        kLineItem = kLineBeens.get(i);
                        int k = i - n + 1;
                        Float[] wrs = getHighAndLowByK(k, i, (ArrayList<KLineItem>) kLineBeens);
                        high = wrs[0];
                        low = wrs[1];
                    }
                }
                if (i >= index) {
                    if (high != low) {
                        wms = ((high - kLineItem.close) / (high - low)) * 100;
                    }
                } else {
                    wms = defult;
                }
                wRs.add(wms);
            }
            for (int i = 0; i < wRs.size(); i++) {
                WRs.add(wRs.get(i));
            }
        }
    }

    private Float[] getHighAndLowByK(Integer a, Integer b, ArrayList<KLineItem> kLineBeens) {
        if (a < 0)
            a = 0;

        KLineItem kLineItem = kLineBeens.get(a);
        float high = kLineItem.high;
        float low = kLineItem.low;
        Float[] wrs = new Float[2];
        for (int i = a; i <= b; i++) {
            kLineItem = kLineBeens.get(i);
            high = high > kLineItem.high ? high : kLineItem.high;
            low = low < kLineItem.low ? low : kLineItem.low;
        }

        wrs[0] = high;
        wrs[1] = low;
        return wrs;
    }

    public ArrayList<Float> getWRs() {
        return WRs;
    }

}
