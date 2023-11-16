package com.ank.ankapp.ank_app.original.bean;

import com.ank.ankapp.ank_app.original.bean.vipindex.FundingRate;

import java.util.Map;

public class FundRateLiveVo {
    public String symbol;//base coin
    public boolean follow;//是否自选
    public Map<String, FundingRate> cmap;
    public Map<String, FundingRate> umap;
}
