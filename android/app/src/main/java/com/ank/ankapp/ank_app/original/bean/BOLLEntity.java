package com.ank.ankapp.ank_app.original.bean;

import static java.lang.Float.NaN;

import java.util.ArrayList;

/**
 * Created by loro on 2017/3/7.
 */

public class BOLLEntity {

    private ArrayList<Float> UPs;
    private ArrayList<Float> MBs;
    private ArrayList<Float> DNs;

    /**
     * 得到BOLL指标
     * @param kLineBeens
     * @param n
     */
    public BOLLEntity(ArrayList<KLineItem> kLineBeens, int n, int bandwidth) {
        this(kLineBeens, n, bandwidth, NaN);
    }

    /**
     * 得到BOLL指标
     * @param kLineBeens
     * @param n
     * @param bandwidth
     * @param defult
     */
    public BOLLEntity(ArrayList<KLineItem> kLineBeens, int n, int bandwidth, float defult) {
        UPs = new ArrayList<>();
        MBs = new ArrayList<>();
        DNs = new ArrayList<>();

        float ma = 0.0f;
        float md = 0.0f;
        float mb = 0.0f;
        float up = 0.0f;
        float dn = 0.0f;

        if (kLineBeens != null && kLineBeens.size() > 0) {
            float closeSum = 0.0f;
            float sum = 0.0f;
            int index = 0;
            int index2 = n - 1;
            for (int i = 0; i < kLineBeens.size(); i++) {
                int k = i - n + 1;
                if (i >= n) {
                    index = n;//old code is index = 20; by listen
                } else {
                    index = i + 1;
                }
                closeSum = getSumClose(k, i, kLineBeens);
                ma = closeSum / index;
                sum = getSum(k, i, ma, kLineBeens);
                md = (float) Math.sqrt(sum / index);
                //mb = (closeSum - kLineBeens.get(i).close) / index;
                mb = (closeSum) / index;
                up = mb + (bandwidth * md);
                dn = mb - (bandwidth * md);

                if (i < index2) {
                    mb = defult;
                    up = defult;
                    dn = defult;
                }

                UPs.add(up);
                MBs.add(mb);
                DNs.add(dn);
            }

        }

    }

    private Float getSum(Integer a, Integer b, Float ma, ArrayList<KLineItem> kLineBeens) {
        if (a < 0)
            a = 0;
        KLineItem kLineItem;
        float sum = 0.0f;
        for (int i = a; i <= b; i++) {
            kLineItem = kLineBeens.get(i);
            sum += ((kLineItem.close - ma) * (kLineItem.close - ma));
        }

        return sum;
    }


    private Float getSumClose(Integer a, Integer b, ArrayList<KLineItem> kLineBeens) {
        if (a < 0)
            a = 0;
        KLineItem kLineItem;
        float close = 0.0f;
        for (int i = a; i <= b; i++) {
            kLineItem = kLineBeens.get(i);
            close += kLineItem.close;
        }

        return close;
    }


    public ArrayList<Float> getUPs() {
        return UPs;
    }

    public ArrayList<Float> getMBs() {
        return MBs;
    }

    public ArrayList<Float> getDNs() {
        return DNs;
    }
}
