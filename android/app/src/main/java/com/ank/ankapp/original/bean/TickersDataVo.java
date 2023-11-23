package com.ank.ankapp.original.bean;

import java.util.List;

public class TickersDataVo {
   public List<MarkerTickerVo> list;
   public TickerPageInfoVo pagination;

   public List<MarkerTickerVo> getList() {
      return list;
   }

   public void setList(List<MarkerTickerVo> list) {
      this.list = list;
   }

   public TickerPageInfoVo getPagination() {
      return pagination;
   }

   public void setPagination(TickerPageInfoVo pagination) {
      this.pagination = pagination;
   }
}