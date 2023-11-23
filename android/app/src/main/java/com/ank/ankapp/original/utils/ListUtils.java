package com.ank.ankapp.original.utils;


import com.ank.ankapp.original.bean.MarkerTickerVo;
import com.ank.ankapp.original.bean.SymbolVo;

import java.util.ArrayList;
import java.util.List;

public class ListUtils {

    public static List<SymbolVo> filter(List<SymbolVo> list, String exchangePattern, String symbol) {
        if (list == null) return null;


        List<SymbolVo> result = new ArrayList<SymbolVo>();
        //先过滤交易所
        for (int i = 0; i < list.size(); i++) {
            boolean isContainExchange = true;
            isContainExchange = list.get(i).getExchangeName().contains(exchangePattern);

            if (isContainExchange && list.get(i).getSymbol().contains(symbol.trim().toUpperCase())) {
                result.add(list.get(i));
            }
        }

        return result;
    }

    public static List<MarkerTickerVo> filter(List<MarkerTickerVo> list, String symbol) {
        if (list == null) return null;

        List<MarkerTickerVo> result = new ArrayList<MarkerTickerVo>();

        for (int i = 0; i < list.size(); i++) {
            boolean isFind = true;
            isFind = list.get(i).getBaseCoin().toUpperCase().contains(symbol.trim().toUpperCase());
            if (isFind)
            {
                result.add(list.get(i));
            }
        }

        return result;
    }

    public static List<String> filterListString(List<String> list, String symbol) {
        if (list == null) return null;

        List<String> result = new ArrayList<String>();

        for (int i = 0; i < list.size(); i++) {
            boolean isFind = true;
            isFind = list.get(i).toUpperCase().contains(symbol.trim().toUpperCase());
            if (isFind)
            {
                result.add(list.get(i));
            }
        }

        return result;
    }

    public static List<MarkerTickerVo> filter(List<MarkerTickerVo> srcList) {
        if (srcList == null) return null;

        List<MarkerTickerVo> result = new ArrayList<MarkerTickerVo>();

        for (int i = 0; i < srcList.size(); i++) {
            boolean isFind = true;
            isFind = srcList.get(i).isFollow();
            if (isFind)
            {
                result.add(srcList.get(i));
            }
        }

        return result;
    }

}


