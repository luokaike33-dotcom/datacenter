SELECT MAX(a.l_date) - MAX(nvl(b.l_date,a.l_date)) as cnt
  FROM (SELECT a.l_date
          FROM trade.tflowinfo a
         WHERE a.vc_flow_name = '交易行为监控系统初始化'
           AND a.vc_information = '交易所异常监控执行完成'
           AND a.l_date >= to_number(to_char(SYSDATE - 10, 'yyyymmdd'))
        UNION ALL
        SELECT a.l_date
          FROM trade.thisflowinfo a
         WHERE a.vc_flow_name = '交易行为监控系统初始化'
           AND a.vc_information = '交易所异常监控执行完成'
           AND a.l_date >= to_number(to_char(SYSDATE - 10, 'yyyymmdd'))) a 
left join trade.tmarkettradeday b
   on b.l_date = to_number(to_char(trunc(SYSDATE - 6 / 24), 'yyyymmdd'))
  and b.vc_tradeday_type='00'
  and b.c_trade_flag=1;
quit;
