package com.ank.ankapp.ank_app.original.bean;

import java.util.ArrayList;

/**
 * Created by loro on 2017/3/7.
 */

public class RSIEntity {

    private ArrayList<Float> RSIs01;
    private ArrayList<Float> RSIs02;
    private ArrayList<Float> RSIs03;

    /**
     */
    public RSIEntity(ArrayList<KLineItem> datas, float a, float b, float c) {
        RSIs01 = new ArrayList<>();
        RSIs02 = new ArrayList<>();
        RSIs03 = new ArrayList<>();

        float rsi1 = 0;
        float rsi2 = 0;
        float rsi3 = 0;
        float rsi1ABSEma = 0;
        float rsi2ABSEma = 0;
        float rsi3ABSEma = 0;
        float rsi1MaxEma = 0;
        float rsi2MaxEma = 0;
        float rsi3MaxEma = 0;
        for (int i = 0; i < datas.size(); i++) {
            KLineItem point = datas.get(i);
            final float closePrice = point.close;
            if (i == 0) {
                rsi1 = 0;
                rsi2 = 0;
                rsi3 = 0;
                rsi1ABSEma = 0;
                rsi2ABSEma = 0;
                rsi3ABSEma = 0;
                rsi1MaxEma = 0;
                rsi2MaxEma = 0;
                rsi3MaxEma = 0;
            } else {
                float Rmax = Math.max(0, closePrice - datas.get(i - 1).close);
                float RAbs = Math.abs(closePrice - datas.get(i - 1).close);
                rsi1MaxEma = (Rmax + (a - 1) * rsi1MaxEma) / a;
                rsi1ABSEma = (RAbs + (a - 1) * rsi1ABSEma) / a;

                rsi2MaxEma = (Rmax + (b - 1) * rsi2MaxEma) / b;
                rsi2ABSEma = (RAbs + (b - 1) * rsi2ABSEma) / b;

                rsi3MaxEma = (Rmax + (c - 1) * rsi3MaxEma) / c;
                rsi3ABSEma = (RAbs + (c - 1) * rsi3ABSEma) / c;

                rsi1 = (rsi1MaxEma / rsi1ABSEma) * 100;
                rsi2 = (rsi2MaxEma / rsi2ABSEma) * 100;
                rsi3 = (rsi3MaxEma / rsi3ABSEma) * 100;
            }

            RSIs01.add(rsi1);
            RSIs02.add(rsi2);
            RSIs03.add(rsi3);
        }
    }


    private Float[] getAAndB(Integer a, Integer b, ArrayList<KLineItem> kLineBeens) {
        if (a < 0)
            a = 0;
        float sum = 0.0f;
        float dif = 0.0f;
        float closeT, closeY;
        Float[] abs = new Float[2];
        for (int i = a; i <= b; i++) {
            if (i > a) {
                closeT = kLineBeens.get(i).close;
                closeY = kLineBeens.get(i - 1).close;

                float c = closeT - closeY;
                if (c > 0) {
                    sum = sum + c;
                } else {
                    dif = sum + c;
                }

                dif = Math.abs(dif);
            }
        }

        abs[0] = sum;
        abs[1] = dif;
        return abs;
    }

    public ArrayList<Float> getRSIs1() {
        return RSIs01;
    }

    public ArrayList<Float> getRSIs2() {
        return RSIs02;
    }
    public ArrayList<Float> getRSIs3() {
        return RSIs03;
    }
}
