package com.ank.ankapp.original.bean;

import java.util.ArrayList;
import java.util.List;

/**
 * Created by loro on 2017/3/2.
 */

public class MACDEntity {

    private List<Float> DEAs;
    private List<Float> DIFs;
    private List<Float> MACDs;

    /**
     * 得到MACD数据
     *
     * @param kLineBeen
     */
    public MACDEntity(List<KLineItem> kLineBeen, int shortPeriod, int longPeriod, int ma) {
        DEAs = new ArrayList<Float>();
        DIFs = new ArrayList<Float>();
        MACDs = new ArrayList<Float>();

        List<Float> dEAs = new ArrayList<Float>();
        List<Float> dIFs = new ArrayList<Float>();
        List<Float> mACDs = new ArrayList<Float>();

        float eMA12 = 0.0f;
        float eMA26 = 0.0f;
        float close = 0f;
        float dIF = 0.0f;
        float dEA = 0.0f;
        float mACD = 0.0f;
        if (kLineBeen != null && kLineBeen.size() > 0) {
            for (int i = 0; i < kLineBeen.size(); i++) {
                close = kLineBeen.get(i).close;
                if (i == 0) {
                    eMA12 = close;
                    eMA26 = close;
                } else {
                    eMA12 = eMA12 * (shortPeriod - 1) / (shortPeriod + 1) + close * 2 / (shortPeriod + 1);
                    eMA26 = eMA26 * (longPeriod - 1) / (longPeriod+1) + close * 2 / (longPeriod+1);
                }
                dIF = eMA12 - eMA26;
                dEA = dEA * (ma-1) / (ma+1) + dIF * 2 / (ma+1);
                mACD = 2*(dIF - dEA);
                dEAs.add(dEA);
                dIFs.add(dIF);
                mACDs.add(mACD);
            }

            for (int i = 0; i < dEAs.size(); i++) {
                DEAs.add(dEAs.get(i));
                DIFs.add(dIFs.get(i));
                MACDs.add(mACDs.get(i));
            }
        }

    }

    public List<Float> getDEA() {
        return DEAs;
    }

    public List<Float> getDIF() {
        return DIFs;
    }

    public List<Float> getMACD() {
        return MACDs;
    }
}
