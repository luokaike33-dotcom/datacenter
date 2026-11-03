// ORM class for table 'null'
// WARNING: This class is AUTO-GENERATED. Modify at your own risk.
//
// Debug information:
// Generated date: Fri Apr 23 01:49:58 GMT 2021
// For connector: org.apache.sqoop.manager.OracleManager
import org.apache.hadoop.io.BytesWritable;
import org.apache.hadoop.io.Text;
import org.apache.hadoop.io.Writable;
import org.apache.hadoop.mapred.lib.db.DBWritable;
import com.cloudera.sqoop.lib.JdbcWritableBridge;
import com.cloudera.sqoop.lib.DelimiterSet;
import com.cloudera.sqoop.lib.FieldFormatter;
import com.cloudera.sqoop.lib.RecordParser;
import com.cloudera.sqoop.lib.BooleanParser;
import com.cloudera.sqoop.lib.BlobRef;
import com.cloudera.sqoop.lib.ClobRef;
import com.cloudera.sqoop.lib.LargeObjectLoader;
import com.cloudera.sqoop.lib.SqoopRecord;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.io.DataInput;
import java.io.DataOutput;
import java.io.IOException;
import java.nio.ByteBuffer;
import java.nio.CharBuffer;
import java.sql.Date;
import java.sql.Time;
import java.sql.Timestamp;
import java.util.Arrays;
import java.util.Iterator;
import java.util.List;
import java.util.Map;
import java.util.HashMap;

public class QueryResult extends SqoopRecord  implements DBWritable, Writable {
  private final int PROTOCOL_VERSION = 3;
  public int getClassFormatVersion() { return PROTOCOL_VERSION; }
  public static interface FieldSetterCommand {    void setField(Object value);  }  protected ResultSet __cur_result_set;
  private Map<String, FieldSetterCommand> setters = new HashMap<String, FieldSetterCommand>();
  private void init0() {
    setters.put("C_CUSTTYPE", new FieldSetterCommand() {
      @Override
      public void setField(Object value) {
        C_CUSTTYPE = (String)value;
      }
    });
    setters.put("VC_FUNDACCO", new FieldSetterCommand() {
      @Override
      public void setField(Object value) {
        VC_FUNDACCO = (String)value;
      }
    });
    setters.put("VC_TRADEACCO", new FieldSetterCommand() {
      @Override
      public void setField(Object value) {
        VC_TRADEACCO = (String)value;
      }
    });
    setters.put("C_TRUST", new FieldSetterCommand() {
      @Override
      public void setField(Object value) {
        C_TRUST = (String)value;
      }
    });
    setters.put("VC_REQUESTDATE", new FieldSetterCommand() {
      @Override
      public void setField(Object value) {
        VC_REQUESTDATE = (String)value;
      }
    });
    setters.put("VC_REQUESTNO", new FieldSetterCommand() {
      @Override
      public void setField(Object value) {
        VC_REQUESTNO = (String)value;
      }
    });
    setters.put("VC_CONFIRMNO", new FieldSetterCommand() {
      @Override
      public void setField(Object value) {
        VC_CONFIRMNO = (String)value;
      }
    });
    setters.put("VC_CONFIRMDATE", new FieldSetterCommand() {
      @Override
      public void setField(Object value) {
        VC_CONFIRMDATE = (String)value;
      }
    });
    setters.put("VC_FUNDCODE", new FieldSetterCommand() {
      @Override
      public void setField(Object value) {
        VC_FUNDCODE = (String)value;
      }
    });
    setters.put("C_SHARETYPE", new FieldSetterCommand() {
      @Override
      public void setField(Object value) {
        C_SHARETYPE = (String)value;
      }
    });
    setters.put("VC_NETNO", new FieldSetterCommand() {
      @Override
      public void setField(Object value) {
        VC_NETNO = (String)value;
      }
    });
    setters.put("VC_CENTERNO", new FieldSetterCommand() {
      @Override
      public void setField(Object value) {
        VC_CENTERNO = (String)value;
      }
    });
    setters.put("EN_RATIO", new FieldSetterCommand() {
      @Override
      public void setField(Object value) {
        EN_RATIO = (java.math.BigDecimal)value;
      }
    });
    setters.put("EN_NAV", new FieldSetterCommand() {
      @Override
      public void setField(Object value) {
        EN_NAV = (java.math.BigDecimal)value;
      }
    });
    setters.put("EN_PROFIT", new FieldSetterCommand() {
      @Override
      public void setField(Object value) {
        EN_PROFIT = (java.math.BigDecimal)value;
      }
    });
    setters.put("C_BUSINFLAG", new FieldSetterCommand() {
      @Override
      public void setField(Object value) {
        C_BUSINFLAG = (String)value;
      }
    });
    setters.put("EN_BALANCE", new FieldSetterCommand() {
      @Override
      public void setField(Object value) {
        EN_BALANCE = (java.math.BigDecimal)value;
      }
    });
    setters.put("EN_SHARE", new FieldSetterCommand() {
      @Override
      public void setField(Object value) {
        EN_SHARE = (java.math.BigDecimal)value;
      }
    });
    setters.put("EN_CONFIRMBALA", new FieldSetterCommand() {
      @Override
      public void setField(Object value) {
        EN_CONFIRMBALA = (java.math.BigDecimal)value;
      }
    });
    setters.put("C_MONEYTYPE", new FieldSetterCommand() {
      @Override
      public void setField(Object value) {
        C_MONEYTYPE = (String)value;
      }
    });
    setters.put("EN_CONFIRMSHARE", new FieldSetterCommand() {
      @Override
      public void setField(Object value) {
        EN_CONFIRMSHARE = (java.math.BigDecimal)value;
      }
    });
    setters.put("EN_FARE", new FieldSetterCommand() {
      @Override
      public void setField(Object value) {
        EN_FARE = (java.math.BigDecimal)value;
      }
    });
    setters.put("EN_DEALFARE", new FieldSetterCommand() {
      @Override
      public void setField(Object value) {
        EN_DEALFARE = (java.math.BigDecimal)value;
      }
    });
    setters.put("EN_TAFARE", new FieldSetterCommand() {
      @Override
      public void setField(Object value) {
        EN_TAFARE = (java.math.BigDecimal)value;
      }
    });
    setters.put("EN_AFTERFARE", new FieldSetterCommand() {
      @Override
      public void setField(Object value) {
        EN_AFTERFARE = (java.math.BigDecimal)value;
      }
    });
    setters.put("EN_AGENCYFARE", new FieldSetterCommand() {
      @Override
      public void setField(Object value) {
        EN_AGENCYFARE = (java.math.BigDecimal)value;
      }
    });
    setters.put("EN_STAMPTAX", new FieldSetterCommand() {
      @Override
      public void setField(Object value) {
        EN_STAMPTAX = (java.math.BigDecimal)value;
      }
    });
    setters.put("C_CONFIRMFLAG", new FieldSetterCommand() {
      @Override
      public void setField(Object value) {
        C_CONFIRMFLAG = (String)value;
      }
    });
    setters.put("VC_ERRORCODE", new FieldSetterCommand() {
      @Override
      public void setField(Object value) {
        VC_ERRORCODE = (String)value;
      }
    });
    setters.put("VC_ERRORCAUSE", new FieldSetterCommand() {
      @Override
      public void setField(Object value) {
        VC_ERRORCAUSE = (String)value;
      }
    });
    setters.put("C_VOUCHERFLAG", new FieldSetterCommand() {
      @Override
      public void setField(Object value) {
        C_VOUCHERFLAG = (String)value;
      }
    });
    setters.put("EN_INTEREST", new FieldSetterCommand() {
      @Override
      public void setField(Object value) {
        EN_INTEREST = (java.math.BigDecimal)value;
      }
    });
    setters.put("EN_INTERESTTAX", new FieldSetterCommand() {
      @Override
      public void setField(Object value) {
        EN_INTERESTTAX = (java.math.BigDecimal)value;
      }
    });
    setters.put("C_ORGANIGER", new FieldSetterCommand() {
      @Override
      public void setField(Object value) {
        C_ORGANIGER = (String)value;
      }
    });
    setters.put("VC_OTHERACCO", new FieldSetterCommand() {
      @Override
      public void setField(Object value) {
        VC_OTHERACCO = (String)value;
      }
    });
    setters.put("VC_OTHERTRADEACCO", new FieldSetterCommand() {
      @Override
      public void setField(Object value) {
        VC_OTHERTRADEACCO = (String)value;
      }
    });
    setters.put("C_OTHERAGENCYNO", new FieldSetterCommand() {
      @Override
      public void setField(Object value) {
        C_OTHERAGENCYNO = (String)value;
      }
    });
    setters.put("VC_OTHERNETNO", new FieldSetterCommand() {
      @Override
      public void setField(Object value) {
        VC_OTHERNETNO = (String)value;
      }
    });
    setters.put("VC_OTHERFUNDCODE", new FieldSetterCommand() {
      @Override
      public void setField(Object value) {
        VC_OTHERFUNDCODE = (String)value;
      }
    });
    setters.put("C_OTHERSHARETYPE", new FieldSetterCommand() {
      @Override
      public void setField(Object value) {
        C_OTHERSHARETYPE = (String)value;
      }
    });
    setters.put("EN_UNFROZENBALA", new FieldSetterCommand() {
      @Override
      public void setField(Object value) {
        EN_UNFROZENBALA = (java.math.BigDecimal)value;
      }
    });
    setters.put("EN_RETURNFARE", new FieldSetterCommand() {
      @Override
      public void setField(Object value) {
        EN_RETURNFARE = (java.math.BigDecimal)value;
      }
    });
    setters.put("EN_ORIGINFARE", new FieldSetterCommand() {
      @Override
      public void setField(Object value) {
        EN_ORIGINFARE = (java.math.BigDecimal)value;
      }
    });
    setters.put("VC_BROKER", new FieldSetterCommand() {
      @Override
      public void setField(Object value) {
        VC_BROKER = (String)value;
      }
    });
    setters.put("C_DIVIDENDMETHOD", new FieldSetterCommand() {
      @Override
      public void setField(Object value) {
        C_DIVIDENDMETHOD = (String)value;
      }
    });
    setters.put("C_FROZENCAUSE", new FieldSetterCommand() {
      @Override
      public void setField(Object value) {
        C_FROZENCAUSE = (String)value;
      }
    });
    setters.put("VC_ORIGINNO", new FieldSetterCommand() {
      @Override
      public void setField(Object value) {
        VC_ORIGINNO = (String)value;
      }
    });
    setters.put("VC_CITYNO", new FieldSetterCommand() {
      @Override
      public void setField(Object value) {
        VC_CITYNO = (String)value;
      }
    });
    setters.put("VC_SELLER", new FieldSetterCommand() {
      @Override
      public void setField(Object value) {
        VC_SELLER = (String)value;
      }
    });
    setters.put("VC_TACODE", new FieldSetterCommand() {
      @Override
      public void setField(Object value) {
        VC_TACODE = (String)value;
      }
    });
    setters.put("EN_DISCOUNT", new FieldSetterCommand() {
      @Override
      public void setField(Object value) {
        EN_DISCOUNT = (java.math.BigDecimal)value;
      }
    });
    setters.put("EN_INCOME", new FieldSetterCommand() {
      @Override
      public void setField(Object value) {
        EN_INCOME = (java.math.BigDecimal)value;
      }
    });
    setters.put("EN_INVESTINCOME", new FieldSetterCommand() {
      @Override
      public void setField(Object value) {
        EN_INVESTINCOME = (java.math.BigDecimal)value;
      }
    });
    setters.put("EN_INVESTSHARE", new FieldSetterCommand() {
      @Override
      public void setField(Object value) {
        EN_INVESTSHARE = (java.math.BigDecimal)value;
      }
    });
    setters.put("C_FINISHFLAG", new FieldSetterCommand() {
      @Override
      public void setField(Object value) {
        C_FINISHFLAG = (String)value;
      }
    });
    setters.put("C_INTERESTFLAG", new FieldSetterCommand() {
      @Override
      public void setField(Object value) {
        C_INTERESTFLAG = (String)value;
      }
    });
    setters.put("C_CONFIRMSTATUS", new FieldSetterCommand() {
      @Override
      public void setField(Object value) {
        C_CONFIRMSTATUS = (String)value;
      }
    });
    setters.put("EN_OTHERDISCOUNT", new FieldSetterCommand() {
      @Override
      public void setField(Object value) {
        EN_OTHERDISCOUNT = (java.math.BigDecimal)value;
      }
    });
    setters.put("EN_ENDDISCOUNT", new FieldSetterCommand() {
      @Override
      public void setField(Object value) {
        EN_ENDDISCOUNT = (java.math.BigDecimal)value;
      }
    });
    setters.put("VC_LIQUIDATEDATE", new FieldSetterCommand() {
      @Override
      public void setField(Object value) {
        VC_LIQUIDATEDATE = (String)value;
      }
    });
    setters.put("C_SENDFLAG", new FieldSetterCommand() {
      @Override
      public void setField(Object value) {
        C_SENDFLAG = (String)value;
      }
    });
    setters.put("VC_BRANCHCODE", new FieldSetterCommand() {
      @Override
      public void setField(Object value) {
        VC_BRANCHCODE = (String)value;
      }
    });
    setters.put("EN_OTHERNAV", new FieldSetterCommand() {
      @Override
      public void setField(Object value) {
        EN_OTHERNAV = (java.math.BigDecimal)value;
      }
    });
    setters.put("EN_OTHERCONFIRMSHARE", new FieldSetterCommand() {
      @Override
      public void setField(Object value) {
        EN_OTHERCONFIRMSHARE = (java.math.BigDecimal)value;
      }
    });
    setters.put("EN_OTHERORIGINFARE", new FieldSetterCommand() {
      @Override
      public void setField(Object value) {
        EN_OTHERORIGINFARE = (java.math.BigDecimal)value;
      }
    });
    setters.put("C_FIXBUSINFLAG", new FieldSetterCommand() {
      @Override
      public void setField(Object value) {
        C_FIXBUSINFLAG = (String)value;
      }
    });
    setters.put("C_CAPITALMODE", new FieldSetterCommand() {
      @Override
      public void setField(Object value) {
        C_CAPITALMODE = (String)value;
      }
    });
    setters.put("C_SUBCAPITALMODE", new FieldSetterCommand() {
      @Override
      public void setField(Object value) {
        C_SUBCAPITALMODE = (String)value;
      }
    });
    setters.put("VC_ORIGINCONFIRMNO", new FieldSetterCommand() {
      @Override
      public void setField(Object value) {
        VC_ORIGINCONFIRMNO = (String)value;
      }
    });
    setters.put("C_BUSINTYPE", new FieldSetterCommand() {
      @Override
      public void setField(Object value) {
        C_BUSINTYPE = (String)value;
      }
    });
    setters.put("L_SECTIONSCHEMANO", new FieldSetterCommand() {
      @Override
      public void setField(Object value) {
        L_SECTIONSCHEMANO = (java.math.BigDecimal)value;
      }
    });
    setters.put("C_EXPTYPE", new FieldSetterCommand() {
      @Override
      public void setField(Object value) {
        C_EXPTYPE = (String)value;
      }
    });
    setters.put("C_SHAREADJUSTFLAG", new FieldSetterCommand() {
      @Override
      public void setField(Object value) {
        C_SHAREADJUSTFLAG = (String)value;
      }
    });
    setters.put("C_INCOMEFLAG", new FieldSetterCommand() {
      @Override
      public void setField(Object value) {
        C_INCOMEFLAG = (String)value;
      }
    });
    setters.put("EN_ACHIEVEMENTPAY", new FieldSetterCommand() {
      @Override
      public void setField(Object value) {
        EN_ACHIEVEMENTPAY = (java.math.BigDecimal)value;
      }
    });
    setters.put("EN_BREACHFEE", new FieldSetterCommand() {
      @Override
      public void setField(Object value) {
        EN_BREACHFEE = (java.math.BigDecimal)value;
      }
    });
    setters.put("VC_COMEFROM", new FieldSetterCommand() {
      @Override
      public void setField(Object value) {
        VC_COMEFROM = (String)value;
      }
    });
    setters.put("VC_INVESTORSYSTEMID", new FieldSetterCommand() {
      @Override
      public void setField(Object value) {
        VC_INVESTORSYSTEMID = (String)value;
      }
    });
    setters.put("VC_VOUCHERNO", new FieldSetterCommand() {
      @Override
      public void setField(Object value) {
        VC_VOUCHERNO = (String)value;
      }
    });
    setters.put("C_BANKNO", new FieldSetterCommand() {
      @Override
      public void setField(Object value) {
        C_BANKNO = (String)value;
      }
    });
    setters.put("VC_BANKNAME", new FieldSetterCommand() {
      @Override
      public void setField(Object value) {
        VC_BANKNAME = (String)value;
      }
    });
    setters.put("VC_NAMEINBANK", new FieldSetterCommand() {
      @Override
      public void setField(Object value) {
        VC_NAMEINBANK = (String)value;
      }
    });
    setters.put("VC_BANKACCO", new FieldSetterCommand() {
      @Override
      public void setField(Object value) {
        VC_BANKACCO = (String)value;
      }
    });
    setters.put("VC_CUSTNO", new FieldSetterCommand() {
      @Override
      public void setField(Object value) {
        VC_CUSTNO = (String)value;
      }
    });
    setters.put("VC_CONFIRMSETTLEDATE", new FieldSetterCommand() {
      @Override
      public void setField(Object value) {
        VC_CONFIRMSETTLEDATE = (String)value;
      }
    });
    setters.put("VC_REQUESTSETTLEDATE", new FieldSetterCommand() {
      @Override
      public void setField(Object value) {
        VC_REQUESTSETTLEDATE = (String)value;
      }
    });
    setters.put("VC_CONTRACTSERIALNO", new FieldSetterCommand() {
      @Override
      public void setField(Object value) {
        VC_CONTRACTSERIALNO = (String)value;
      }
    });
    setters.put("C_PROFITCLASS", new FieldSetterCommand() {
      @Override
      public void setField(Object value) {
        C_PROFITCLASS = (String)value;
      }
    });
    setters.put("VC_COMBREQUESTNO", new FieldSetterCommand() {
      @Override
      public void setField(Object value) {
        VC_COMBREQUESTNO = (String)value;
      }
    });
    setters.put("VC_COMBCODE", new FieldSetterCommand() {
      @Override
      public void setField(Object value) {
        VC_COMBCODE = (String)value;
      }
    });
    setters.put("C_AUTOREQUEST", new FieldSetterCommand() {
      @Override
      public void setField(Object value) {
        C_AUTOREQUEST = (String)value;
      }
    });
    setters.put("VC_EXPLAIN", new FieldSetterCommand() {
      @Override
      public void setField(Object value) {
        VC_EXPLAIN = (String)value;
      }
    });
    setters.put("C_INTERFACETYPE", new FieldSetterCommand() {
      @Override
      public void setField(Object value) {
        C_INTERFACETYPE = (String)value;
      }
    });
    setters.put("EN_OTHERFEE1", new FieldSetterCommand() {
      @Override
      public void setField(Object value) {
        EN_OTHERFEE1 = (java.math.BigDecimal)value;
      }
    });
    setters.put("EN_OTHERFEE2", new FieldSetterCommand() {
      @Override
      public void setField(Object value) {
        EN_OTHERFEE2 = (java.math.BigDecimal)value;
      }
    });
    setters.put("C_MATCHFLAG", new FieldSetterCommand() {
      @Override
      public void setField(Object value) {
        C_MATCHFLAG = (String)value;
      }
    });
    setters.put("VC_BOOKID", new FieldSetterCommand() {
      @Override
      public void setField(Object value) {
        VC_BOOKID = (String)value;
      }
    });
    setters.put("EN_GRAMNUM", new FieldSetterCommand() {
      @Override
      public void setField(Object value) {
        EN_GRAMNUM = (java.math.BigDecimal)value;
      }
    });
    setters.put("C_FORCEREDEEMREASON", new FieldSetterCommand() {
      @Override
      public void setField(Object value) {
        C_FORCEREDEEMREASON = (String)value;
      }
    });
    setters.put("EN_TOTALFROZENSHARE", new FieldSetterCommand() {
      @Override
      public void setField(Object value) {
        EN_TOTALFROZENSHARE = (java.math.BigDecimal)value;
      }
    });
    setters.put("EN_FUNDSHAREBALANCE", new FieldSetterCommand() {
      @Override
      public void setField(Object value) {
        EN_FUNDSHAREBALANCE = (java.math.BigDecimal)value;
      }
    });
    setters.put("EN_FROZENBALANCE", new FieldSetterCommand() {
      @Override
      public void setField(Object value) {
        EN_FROZENBALANCE = (java.math.BigDecimal)value;
      }
    });
    setters.put("VC_FUTURESUBSCRIBEDATE", new FieldSetterCommand() {
      @Override
      public void setField(Object value) {
        VC_FUTURESUBSCRIBEDATE = (String)value;
      }
    });
    setters.put("VC_TRANSFERDATEFROMAGENCY", new FieldSetterCommand() {
      @Override
      public void setField(Object value) {
        VC_TRANSFERDATEFROMAGENCY = (String)value;
      }
    });
    setters.put("EN_TAXADVANAMOUNT", new FieldSetterCommand() {
      @Override
      public void setField(Object value) {
        EN_TAXADVANAMOUNT = (java.math.BigDecimal)value;
      }
    });
    setters.put("VC_TAXADVANCODE", new FieldSetterCommand() {
      @Override
      public void setField(Object value) {
        VC_TAXADVANCODE = (String)value;
      }
    });
    setters.put("VC_OTHERSERIALNO", new FieldSetterCommand() {
      @Override
      public void setField(Object value) {
        VC_OTHERSERIALNO = (String)value;
      }
    });
    setters.put("C_ATTENDQUITFLAG", new FieldSetterCommand() {
      @Override
      public void setField(Object value) {
        C_ATTENDQUITFLAG = (String)value;
      }
    });
    setters.put("VC_CUSTOMNAME_GS", new FieldSetterCommand() {
      @Override
      public void setField(Object value) {
        VC_CUSTOMNAME_GS = (String)value;
      }
    });
    setters.put("C_IDENTITYTYPE_GS", new FieldSetterCommand() {
      @Override
      public void setField(Object value) {
        C_IDENTITYTYPE_GS = (String)value;
      }
    });
    setters.put("VC_IDENTITYNO_GS", new FieldSetterCommand() {
      @Override
      public void setField(Object value) {
        VC_IDENTITYNO_GS = (String)value;
      }
    });
    setters.put("VC_NATIONALITY_GS", new FieldSetterCommand() {
      @Override
      public void setField(Object value) {
        VC_NATIONALITY_GS = (String)value;
      }
    });
    setters.put("VC_CERTCODE_GS", new FieldSetterCommand() {
      @Override
      public void setField(Object value) {
        VC_CERTCODE_GS = (String)value;
      }
    });
    setters.put("VC_CERTDATE_GS", new FieldSetterCommand() {
      @Override
      public void setField(Object value) {
        VC_CERTDATE_GS = (String)value;
      }
    });
    setters.put("EN_ACCTAXPRETAKEOFF_GS", new FieldSetterCommand() {
      @Override
      public void setField(Object value) {
        EN_ACCTAXPRETAKEOFF_GS = (java.math.BigDecimal)value;
      }
    });
    setters.put("INSERTTIME", new FieldSetterCommand() {
      @Override
      public void setField(Object value) {
        INSERTTIME = (String)value;
      }
    });
    setters.put("UPDATETIME", new FieldSetterCommand() {
      @Override
      public void setField(Object value) {
        UPDATETIME = (String)value;
      }
    });
    setters.put("20210422", new FieldSetterCommand() {
      @Override
      public void setField(Object value) {
        _20210422 = (java.math.BigDecimal)value;
      }
    });
    setters.put("'SALES'", new FieldSetterCommand() {
      @Override
      public void setField(Object value) {
        _SALES_ = (String)value;
      }
    });
  }
  public QueryResult() {
    init0();
  }
  private String C_CUSTTYPE;
  public String get_C_CUSTTYPE() {
    return C_CUSTTYPE;
  }
  public void set_C_CUSTTYPE(String C_CUSTTYPE) {
    this.C_CUSTTYPE = C_CUSTTYPE;
  }
  public QueryResult with_C_CUSTTYPE(String C_CUSTTYPE) {
    this.C_CUSTTYPE = C_CUSTTYPE;
    return this;
  }
  private String VC_FUNDACCO;
  public String get_VC_FUNDACCO() {
    return VC_FUNDACCO;
  }
  public void set_VC_FUNDACCO(String VC_FUNDACCO) {
    this.VC_FUNDACCO = VC_FUNDACCO;
  }
  public QueryResult with_VC_FUNDACCO(String VC_FUNDACCO) {
    this.VC_FUNDACCO = VC_FUNDACCO;
    return this;
  }
  private String VC_TRADEACCO;
  public String get_VC_TRADEACCO() {
    return VC_TRADEACCO;
  }
  public void set_VC_TRADEACCO(String VC_TRADEACCO) {
    this.VC_TRADEACCO = VC_TRADEACCO;
  }
  public QueryResult with_VC_TRADEACCO(String VC_TRADEACCO) {
    this.VC_TRADEACCO = VC_TRADEACCO;
    return this;
  }
  private String C_TRUST;
  public String get_C_TRUST() {
    return C_TRUST;
  }
  public void set_C_TRUST(String C_TRUST) {
    this.C_TRUST = C_TRUST;
  }
  public QueryResult with_C_TRUST(String C_TRUST) {
    this.C_TRUST = C_TRUST;
    return this;
  }
  private String VC_REQUESTDATE;
  public String get_VC_REQUESTDATE() {
    return VC_REQUESTDATE;
  }
  public void set_VC_REQUESTDATE(String VC_REQUESTDATE) {
    this.VC_REQUESTDATE = VC_REQUESTDATE;
  }
  public QueryResult with_VC_REQUESTDATE(String VC_REQUESTDATE) {
    this.VC_REQUESTDATE = VC_REQUESTDATE;
    return this;
  }
  private String VC_REQUESTNO;
  public String get_VC_REQUESTNO() {
    return VC_REQUESTNO;
  }
  public void set_VC_REQUESTNO(String VC_REQUESTNO) {
    this.VC_REQUESTNO = VC_REQUESTNO;
  }
  public QueryResult with_VC_REQUESTNO(String VC_REQUESTNO) {
    this.VC_REQUESTNO = VC_REQUESTNO;
    return this;
  }
  private String VC_CONFIRMNO;
  public String get_VC_CONFIRMNO() {
    return VC_CONFIRMNO;
  }
  public void set_VC_CONFIRMNO(String VC_CONFIRMNO) {
    this.VC_CONFIRMNO = VC_CONFIRMNO;
  }
  public QueryResult with_VC_CONFIRMNO(String VC_CONFIRMNO) {
    this.VC_CONFIRMNO = VC_CONFIRMNO;
    return this;
  }
  private String VC_CONFIRMDATE;
  public String get_VC_CONFIRMDATE() {
    return VC_CONFIRMDATE;
  }
  public void set_VC_CONFIRMDATE(String VC_CONFIRMDATE) {
    this.VC_CONFIRMDATE = VC_CONFIRMDATE;
  }
  public QueryResult with_VC_CONFIRMDATE(String VC_CONFIRMDATE) {
    this.VC_CONFIRMDATE = VC_CONFIRMDATE;
    return this;
  }
  private String VC_FUNDCODE;
  public String get_VC_FUNDCODE() {
    return VC_FUNDCODE;
  }
  public void set_VC_FUNDCODE(String VC_FUNDCODE) {
    this.VC_FUNDCODE = VC_FUNDCODE;
  }
  public QueryResult with_VC_FUNDCODE(String VC_FUNDCODE) {
    this.VC_FUNDCODE = VC_FUNDCODE;
    return this;
  }
  private String C_SHARETYPE;
  public String get_C_SHARETYPE() {
    return C_SHARETYPE;
  }
  public void set_C_SHARETYPE(String C_SHARETYPE) {
    this.C_SHARETYPE = C_SHARETYPE;
  }
  public QueryResult with_C_SHARETYPE(String C_SHARETYPE) {
    this.C_SHARETYPE = C_SHARETYPE;
    return this;
  }
  private String VC_NETNO;
  public String get_VC_NETNO() {
    return VC_NETNO;
  }
  public void set_VC_NETNO(String VC_NETNO) {
    this.VC_NETNO = VC_NETNO;
  }
  public QueryResult with_VC_NETNO(String VC_NETNO) {
    this.VC_NETNO = VC_NETNO;
    return this;
  }
  private String VC_CENTERNO;
  public String get_VC_CENTERNO() {
    return VC_CENTERNO;
  }
  public void set_VC_CENTERNO(String VC_CENTERNO) {
    this.VC_CENTERNO = VC_CENTERNO;
  }
  public QueryResult with_VC_CENTERNO(String VC_CENTERNO) {
    this.VC_CENTERNO = VC_CENTERNO;
    return this;
  }
  private java.math.BigDecimal EN_RATIO;
  public java.math.BigDecimal get_EN_RATIO() {
    return EN_RATIO;
  }
  public void set_EN_RATIO(java.math.BigDecimal EN_RATIO) {
    this.EN_RATIO = EN_RATIO;
  }
  public QueryResult with_EN_RATIO(java.math.BigDecimal EN_RATIO) {
    this.EN_RATIO = EN_RATIO;
    return this;
  }
  private java.math.BigDecimal EN_NAV;
  public java.math.BigDecimal get_EN_NAV() {
    return EN_NAV;
  }
  public void set_EN_NAV(java.math.BigDecimal EN_NAV) {
    this.EN_NAV = EN_NAV;
  }
  public QueryResult with_EN_NAV(java.math.BigDecimal EN_NAV) {
    this.EN_NAV = EN_NAV;
    return this;
  }
  private java.math.BigDecimal EN_PROFIT;
  public java.math.BigDecimal get_EN_PROFIT() {
    return EN_PROFIT;
  }
  public void set_EN_PROFIT(java.math.BigDecimal EN_PROFIT) {
    this.EN_PROFIT = EN_PROFIT;
  }
  public QueryResult with_EN_PROFIT(java.math.BigDecimal EN_PROFIT) {
    this.EN_PROFIT = EN_PROFIT;
    return this;
  }
  private String C_BUSINFLAG;
  public String get_C_BUSINFLAG() {
    return C_BUSINFLAG;
  }
  public void set_C_BUSINFLAG(String C_BUSINFLAG) {
    this.C_BUSINFLAG = C_BUSINFLAG;
  }
  public QueryResult with_C_BUSINFLAG(String C_BUSINFLAG) {
    this.C_BUSINFLAG = C_BUSINFLAG;
    return this;
  }
  private java.math.BigDecimal EN_BALANCE;
  public java.math.BigDecimal get_EN_BALANCE() {
    return EN_BALANCE;
  }
  public void set_EN_BALANCE(java.math.BigDecimal EN_BALANCE) {
    this.EN_BALANCE = EN_BALANCE;
  }
  public QueryResult with_EN_BALANCE(java.math.BigDecimal EN_BALANCE) {
    this.EN_BALANCE = EN_BALANCE;
    return this;
  }
  private java.math.BigDecimal EN_SHARE;
  public java.math.BigDecimal get_EN_SHARE() {
    return EN_SHARE;
  }
  public void set_EN_SHARE(java.math.BigDecimal EN_SHARE) {
    this.EN_SHARE = EN_SHARE;
  }
  public QueryResult with_EN_SHARE(java.math.BigDecimal EN_SHARE) {
    this.EN_SHARE = EN_SHARE;
    return this;
  }
  private java.math.BigDecimal EN_CONFIRMBALA;
  public java.math.BigDecimal get_EN_CONFIRMBALA() {
    return EN_CONFIRMBALA;
  }
  public void set_EN_CONFIRMBALA(java.math.BigDecimal EN_CONFIRMBALA) {
    this.EN_CONFIRMBALA = EN_CONFIRMBALA;
  }
  public QueryResult with_EN_CONFIRMBALA(java.math.BigDecimal EN_CONFIRMBALA) {
    this.EN_CONFIRMBALA = EN_CONFIRMBALA;
    return this;
  }
  private String C_MONEYTYPE;
  public String get_C_MONEYTYPE() {
    return C_MONEYTYPE;
  }
  public void set_C_MONEYTYPE(String C_MONEYTYPE) {
    this.C_MONEYTYPE = C_MONEYTYPE;
  }
  public QueryResult with_C_MONEYTYPE(String C_MONEYTYPE) {
    this.C_MONEYTYPE = C_MONEYTYPE;
    return this;
  }
  private java.math.BigDecimal EN_CONFIRMSHARE;
  public java.math.BigDecimal get_EN_CONFIRMSHARE() {
    return EN_CONFIRMSHARE;
  }
  public void set_EN_CONFIRMSHARE(java.math.BigDecimal EN_CONFIRMSHARE) {
    this.EN_CONFIRMSHARE = EN_CONFIRMSHARE;
  }
  public QueryResult with_EN_CONFIRMSHARE(java.math.BigDecimal EN_CONFIRMSHARE) {
    this.EN_CONFIRMSHARE = EN_CONFIRMSHARE;
    return this;
  }
  private java.math.BigDecimal EN_FARE;
  public java.math.BigDecimal get_EN_FARE() {
    return EN_FARE;
  }
  public void set_EN_FARE(java.math.BigDecimal EN_FARE) {
    this.EN_FARE = EN_FARE;
  }
  public QueryResult with_EN_FARE(java.math.BigDecimal EN_FARE) {
    this.EN_FARE = EN_FARE;
    return this;
  }
  private java.math.BigDecimal EN_DEALFARE;
  public java.math.BigDecimal get_EN_DEALFARE() {
    return EN_DEALFARE;
  }
  public void set_EN_DEALFARE(java.math.BigDecimal EN_DEALFARE) {
    this.EN_DEALFARE = EN_DEALFARE;
  }
  public QueryResult with_EN_DEALFARE(java.math.BigDecimal EN_DEALFARE) {
    this.EN_DEALFARE = EN_DEALFARE;
    return this;
  }
  private java.math.BigDecimal EN_TAFARE;
  public java.math.BigDecimal get_EN_TAFARE() {
    return EN_TAFARE;
  }
  public void set_EN_TAFARE(java.math.BigDecimal EN_TAFARE) {
    this.EN_TAFARE = EN_TAFARE;
  }
  public QueryResult with_EN_TAFARE(java.math.BigDecimal EN_TAFARE) {
    this.EN_TAFARE = EN_TAFARE;
    return this;
  }
  private java.math.BigDecimal EN_AFTERFARE;
  public java.math.BigDecimal get_EN_AFTERFARE() {
    return EN_AFTERFARE;
  }
  public void set_EN_AFTERFARE(java.math.BigDecimal EN_AFTERFARE) {
    this.EN_AFTERFARE = EN_AFTERFARE;
  }
  public QueryResult with_EN_AFTERFARE(java.math.BigDecimal EN_AFTERFARE) {
    this.EN_AFTERFARE = EN_AFTERFARE;
    return this;
  }
  private java.math.BigDecimal EN_AGENCYFARE;
  public java.math.BigDecimal get_EN_AGENCYFARE() {
    return EN_AGENCYFARE;
  }
  public void set_EN_AGENCYFARE(java.math.BigDecimal EN_AGENCYFARE) {
    this.EN_AGENCYFARE = EN_AGENCYFARE;
  }
  public QueryResult with_EN_AGENCYFARE(java.math.BigDecimal EN_AGENCYFARE) {
    this.EN_AGENCYFARE = EN_AGENCYFARE;
    return this;
  }
  private java.math.BigDecimal EN_STAMPTAX;
  public java.math.BigDecimal get_EN_STAMPTAX() {
    return EN_STAMPTAX;
  }
  public void set_EN_STAMPTAX(java.math.BigDecimal EN_STAMPTAX) {
    this.EN_STAMPTAX = EN_STAMPTAX;
  }
  public QueryResult with_EN_STAMPTAX(java.math.BigDecimal EN_STAMPTAX) {
    this.EN_STAMPTAX = EN_STAMPTAX;
    return this;
  }
  private String C_CONFIRMFLAG;
  public String get_C_CONFIRMFLAG() {
    return C_CONFIRMFLAG;
  }
  public void set_C_CONFIRMFLAG(String C_CONFIRMFLAG) {
    this.C_CONFIRMFLAG = C_CONFIRMFLAG;
  }
  public QueryResult with_C_CONFIRMFLAG(String C_CONFIRMFLAG) {
    this.C_CONFIRMFLAG = C_CONFIRMFLAG;
    return this;
  }
  private String VC_ERRORCODE;
  public String get_VC_ERRORCODE() {
    return VC_ERRORCODE;
  }
  public void set_VC_ERRORCODE(String VC_ERRORCODE) {
    this.VC_ERRORCODE = VC_ERRORCODE;
  }
  public QueryResult with_VC_ERRORCODE(String VC_ERRORCODE) {
    this.VC_ERRORCODE = VC_ERRORCODE;
    return this;
  }
  private String VC_ERRORCAUSE;
  public String get_VC_ERRORCAUSE() {
    return VC_ERRORCAUSE;
  }
  public void set_VC_ERRORCAUSE(String VC_ERRORCAUSE) {
    this.VC_ERRORCAUSE = VC_ERRORCAUSE;
  }
  public QueryResult with_VC_ERRORCAUSE(String VC_ERRORCAUSE) {
    this.VC_ERRORCAUSE = VC_ERRORCAUSE;
    return this;
  }
  private String C_VOUCHERFLAG;
  public String get_C_VOUCHERFLAG() {
    return C_VOUCHERFLAG;
  }
  public void set_C_VOUCHERFLAG(String C_VOUCHERFLAG) {
    this.C_VOUCHERFLAG = C_VOUCHERFLAG;
  }
  public QueryResult with_C_VOUCHERFLAG(String C_VOUCHERFLAG) {
    this.C_VOUCHERFLAG = C_VOUCHERFLAG;
    return this;
  }
  private java.math.BigDecimal EN_INTEREST;
  public java.math.BigDecimal get_EN_INTEREST() {
    return EN_INTEREST;
  }
  public void set_EN_INTEREST(java.math.BigDecimal EN_INTEREST) {
    this.EN_INTEREST = EN_INTEREST;
  }
  public QueryResult with_EN_INTEREST(java.math.BigDecimal EN_INTEREST) {
    this.EN_INTEREST = EN_INTEREST;
    return this;
  }
  private java.math.BigDecimal EN_INTERESTTAX;
  public java.math.BigDecimal get_EN_INTERESTTAX() {
    return EN_INTERESTTAX;
  }
  public void set_EN_INTERESTTAX(java.math.BigDecimal EN_INTERESTTAX) {
    this.EN_INTERESTTAX = EN_INTERESTTAX;
  }
  public QueryResult with_EN_INTERESTTAX(java.math.BigDecimal EN_INTERESTTAX) {
    this.EN_INTERESTTAX = EN_INTERESTTAX;
    return this;
  }
  private String C_ORGANIGER;
  public String get_C_ORGANIGER() {
    return C_ORGANIGER;
  }
  public void set_C_ORGANIGER(String C_ORGANIGER) {
    this.C_ORGANIGER = C_ORGANIGER;
  }
  public QueryResult with_C_ORGANIGER(String C_ORGANIGER) {
    this.C_ORGANIGER = C_ORGANIGER;
    return this;
  }
  private String VC_OTHERACCO;
  public String get_VC_OTHERACCO() {
    return VC_OTHERACCO;
  }
  public void set_VC_OTHERACCO(String VC_OTHERACCO) {
    this.VC_OTHERACCO = VC_OTHERACCO;
  }
  public QueryResult with_VC_OTHERACCO(String VC_OTHERACCO) {
    this.VC_OTHERACCO = VC_OTHERACCO;
    return this;
  }
  private String VC_OTHERTRADEACCO;
  public String get_VC_OTHERTRADEACCO() {
    return VC_OTHERTRADEACCO;
  }
  public void set_VC_OTHERTRADEACCO(String VC_OTHERTRADEACCO) {
    this.VC_OTHERTRADEACCO = VC_OTHERTRADEACCO;
  }
  public QueryResult with_VC_OTHERTRADEACCO(String VC_OTHERTRADEACCO) {
    this.VC_OTHERTRADEACCO = VC_OTHERTRADEACCO;
    return this;
  }
  private String C_OTHERAGENCYNO;
  public String get_C_OTHERAGENCYNO() {
    return C_OTHERAGENCYNO;
  }
  public void set_C_OTHERAGENCYNO(String C_OTHERAGENCYNO) {
    this.C_OTHERAGENCYNO = C_OTHERAGENCYNO;
  }
  public QueryResult with_C_OTHERAGENCYNO(String C_OTHERAGENCYNO) {
    this.C_OTHERAGENCYNO = C_OTHERAGENCYNO;
    return this;
  }
  private String VC_OTHERNETNO;
  public String get_VC_OTHERNETNO() {
    return VC_OTHERNETNO;
  }
  public void set_VC_OTHERNETNO(String VC_OTHERNETNO) {
    this.VC_OTHERNETNO = VC_OTHERNETNO;
  }
  public QueryResult with_VC_OTHERNETNO(String VC_OTHERNETNO) {
    this.VC_OTHERNETNO = VC_OTHERNETNO;
    return this;
  }
  private String VC_OTHERFUNDCODE;
  public String get_VC_OTHERFUNDCODE() {
    return VC_OTHERFUNDCODE;
  }
  public void set_VC_OTHERFUNDCODE(String VC_OTHERFUNDCODE) {
    this.VC_OTHERFUNDCODE = VC_OTHERFUNDCODE;
  }
  public QueryResult with_VC_OTHERFUNDCODE(String VC_OTHERFUNDCODE) {
    this.VC_OTHERFUNDCODE = VC_OTHERFUNDCODE;
    return this;
  }
  private String C_OTHERSHARETYPE;
  public String get_C_OTHERSHARETYPE() {
    return C_OTHERSHARETYPE;
  }
  public void set_C_OTHERSHARETYPE(String C_OTHERSHARETYPE) {
    this.C_OTHERSHARETYPE = C_OTHERSHARETYPE;
  }
  public QueryResult with_C_OTHERSHARETYPE(String C_OTHERSHARETYPE) {
    this.C_OTHERSHARETYPE = C_OTHERSHARETYPE;
    return this;
  }
  private java.math.BigDecimal EN_UNFROZENBALA;
  public java.math.BigDecimal get_EN_UNFROZENBALA() {
    return EN_UNFROZENBALA;
  }
  public void set_EN_UNFROZENBALA(java.math.BigDecimal EN_UNFROZENBALA) {
    this.EN_UNFROZENBALA = EN_UNFROZENBALA;
  }
  public QueryResult with_EN_UNFROZENBALA(java.math.BigDecimal EN_UNFROZENBALA) {
    this.EN_UNFROZENBALA = EN_UNFROZENBALA;
    return this;
  }
  private java.math.BigDecimal EN_RETURNFARE;
  public java.math.BigDecimal get_EN_RETURNFARE() {
    return EN_RETURNFARE;
  }
  public void set_EN_RETURNFARE(java.math.BigDecimal EN_RETURNFARE) {
    this.EN_RETURNFARE = EN_RETURNFARE;
  }
  public QueryResult with_EN_RETURNFARE(java.math.BigDecimal EN_RETURNFARE) {
    this.EN_RETURNFARE = EN_RETURNFARE;
    return this;
  }
  private java.math.BigDecimal EN_ORIGINFARE;
  public java.math.BigDecimal get_EN_ORIGINFARE() {
    return EN_ORIGINFARE;
  }
  public void set_EN_ORIGINFARE(java.math.BigDecimal EN_ORIGINFARE) {
    this.EN_ORIGINFARE = EN_ORIGINFARE;
  }
  public QueryResult with_EN_ORIGINFARE(java.math.BigDecimal EN_ORIGINFARE) {
    this.EN_ORIGINFARE = EN_ORIGINFARE;
    return this;
  }
  private String VC_BROKER;
  public String get_VC_BROKER() {
    return VC_BROKER;
  }
  public void set_VC_BROKER(String VC_BROKER) {
    this.VC_BROKER = VC_BROKER;
  }
  public QueryResult with_VC_BROKER(String VC_BROKER) {
    this.VC_BROKER = VC_BROKER;
    return this;
  }
  private String C_DIVIDENDMETHOD;
  public String get_C_DIVIDENDMETHOD() {
    return C_DIVIDENDMETHOD;
  }
  public void set_C_DIVIDENDMETHOD(String C_DIVIDENDMETHOD) {
    this.C_DIVIDENDMETHOD = C_DIVIDENDMETHOD;
  }
  public QueryResult with_C_DIVIDENDMETHOD(String C_DIVIDENDMETHOD) {
    this.C_DIVIDENDMETHOD = C_DIVIDENDMETHOD;
    return this;
  }
  private String C_FROZENCAUSE;
  public String get_C_FROZENCAUSE() {
    return C_FROZENCAUSE;
  }
  public void set_C_FROZENCAUSE(String C_FROZENCAUSE) {
    this.C_FROZENCAUSE = C_FROZENCAUSE;
  }
  public QueryResult with_C_FROZENCAUSE(String C_FROZENCAUSE) {
    this.C_FROZENCAUSE = C_FROZENCAUSE;
    return this;
  }
  private String VC_ORIGINNO;
  public String get_VC_ORIGINNO() {
    return VC_ORIGINNO;
  }
  public void set_VC_ORIGINNO(String VC_ORIGINNO) {
    this.VC_ORIGINNO = VC_ORIGINNO;
  }
  public QueryResult with_VC_ORIGINNO(String VC_ORIGINNO) {
    this.VC_ORIGINNO = VC_ORIGINNO;
    return this;
  }
  private String VC_CITYNO;
  public String get_VC_CITYNO() {
    return VC_CITYNO;
  }
  public void set_VC_CITYNO(String VC_CITYNO) {
    this.VC_CITYNO = VC_CITYNO;
  }
  public QueryResult with_VC_CITYNO(String VC_CITYNO) {
    this.VC_CITYNO = VC_CITYNO;
    return this;
  }
  private String VC_SELLER;
  public String get_VC_SELLER() {
    return VC_SELLER;
  }
  public void set_VC_SELLER(String VC_SELLER) {
    this.VC_SELLER = VC_SELLER;
  }
  public QueryResult with_VC_SELLER(String VC_SELLER) {
    this.VC_SELLER = VC_SELLER;
    return this;
  }
  private String VC_TACODE;
  public String get_VC_TACODE() {
    return VC_TACODE;
  }
  public void set_VC_TACODE(String VC_TACODE) {
    this.VC_TACODE = VC_TACODE;
  }
  public QueryResult with_VC_TACODE(String VC_TACODE) {
    this.VC_TACODE = VC_TACODE;
    return this;
  }
  private java.math.BigDecimal EN_DISCOUNT;
  public java.math.BigDecimal get_EN_DISCOUNT() {
    return EN_DISCOUNT;
  }
  public void set_EN_DISCOUNT(java.math.BigDecimal EN_DISCOUNT) {
    this.EN_DISCOUNT = EN_DISCOUNT;
  }
  public QueryResult with_EN_DISCOUNT(java.math.BigDecimal EN_DISCOUNT) {
    this.EN_DISCOUNT = EN_DISCOUNT;
    return this;
  }
  private java.math.BigDecimal EN_INCOME;
  public java.math.BigDecimal get_EN_INCOME() {
    return EN_INCOME;
  }
  public void set_EN_INCOME(java.math.BigDecimal EN_INCOME) {
    this.EN_INCOME = EN_INCOME;
  }
  public QueryResult with_EN_INCOME(java.math.BigDecimal EN_INCOME) {
    this.EN_INCOME = EN_INCOME;
    return this;
  }
  private java.math.BigDecimal EN_INVESTINCOME;
  public java.math.BigDecimal get_EN_INVESTINCOME() {
    return EN_INVESTINCOME;
  }
  public void set_EN_INVESTINCOME(java.math.BigDecimal EN_INVESTINCOME) {
    this.EN_INVESTINCOME = EN_INVESTINCOME;
  }
  public QueryResult with_EN_INVESTINCOME(java.math.BigDecimal EN_INVESTINCOME) {
    this.EN_INVESTINCOME = EN_INVESTINCOME;
    return this;
  }
  private java.math.BigDecimal EN_INVESTSHARE;
  public java.math.BigDecimal get_EN_INVESTSHARE() {
    return EN_INVESTSHARE;
  }
  public void set_EN_INVESTSHARE(java.math.BigDecimal EN_INVESTSHARE) {
    this.EN_INVESTSHARE = EN_INVESTSHARE;
  }
  public QueryResult with_EN_INVESTSHARE(java.math.BigDecimal EN_INVESTSHARE) {
    this.EN_INVESTSHARE = EN_INVESTSHARE;
    return this;
  }
  private String C_FINISHFLAG;
  public String get_C_FINISHFLAG() {
    return C_FINISHFLAG;
  }
  public void set_C_FINISHFLAG(String C_FINISHFLAG) {
    this.C_FINISHFLAG = C_FINISHFLAG;
  }
  public QueryResult with_C_FINISHFLAG(String C_FINISHFLAG) {
    this.C_FINISHFLAG = C_FINISHFLAG;
    return this;
  }
  private String C_INTERESTFLAG;
  public String get_C_INTERESTFLAG() {
    return C_INTERESTFLAG;
  }
  public void set_C_INTERESTFLAG(String C_INTERESTFLAG) {
    this.C_INTERESTFLAG = C_INTERESTFLAG;
  }
  public QueryResult with_C_INTERESTFLAG(String C_INTERESTFLAG) {
    this.C_INTERESTFLAG = C_INTERESTFLAG;
    return this;
  }
  private String C_CONFIRMSTATUS;
  public String get_C_CONFIRMSTATUS() {
    return C_CONFIRMSTATUS;
  }
  public void set_C_CONFIRMSTATUS(String C_CONFIRMSTATUS) {
    this.C_CONFIRMSTATUS = C_CONFIRMSTATUS;
  }
  public QueryResult with_C_CONFIRMSTATUS(String C_CONFIRMSTATUS) {
    this.C_CONFIRMSTATUS = C_CONFIRMSTATUS;
    return this;
  }
  private java.math.BigDecimal EN_OTHERDISCOUNT;
  public java.math.BigDecimal get_EN_OTHERDISCOUNT() {
    return EN_OTHERDISCOUNT;
  }
  public void set_EN_OTHERDISCOUNT(java.math.BigDecimal EN_OTHERDISCOUNT) {
    this.EN_OTHERDISCOUNT = EN_OTHERDISCOUNT;
  }
  public QueryResult with_EN_OTHERDISCOUNT(java.math.BigDecimal EN_OTHERDISCOUNT) {
    this.EN_OTHERDISCOUNT = EN_OTHERDISCOUNT;
    return this;
  }
  private java.math.BigDecimal EN_ENDDISCOUNT;
  public java.math.BigDecimal get_EN_ENDDISCOUNT() {
    return EN_ENDDISCOUNT;
  }
  public void set_EN_ENDDISCOUNT(java.math.BigDecimal EN_ENDDISCOUNT) {
    this.EN_ENDDISCOUNT = EN_ENDDISCOUNT;
  }
  public QueryResult with_EN_ENDDISCOUNT(java.math.BigDecimal EN_ENDDISCOUNT) {
    this.EN_ENDDISCOUNT = EN_ENDDISCOUNT;
    return this;
  }
  private String VC_LIQUIDATEDATE;
  public String get_VC_LIQUIDATEDATE() {
    return VC_LIQUIDATEDATE;
  }
  public void set_VC_LIQUIDATEDATE(String VC_LIQUIDATEDATE) {
    this.VC_LIQUIDATEDATE = VC_LIQUIDATEDATE;
  }
  public QueryResult with_VC_LIQUIDATEDATE(String VC_LIQUIDATEDATE) {
    this.VC_LIQUIDATEDATE = VC_LIQUIDATEDATE;
    return this;
  }
  private String C_SENDFLAG;
  public String get_C_SENDFLAG() {
    return C_SENDFLAG;
  }
  public void set_C_SENDFLAG(String C_SENDFLAG) {
    this.C_SENDFLAG = C_SENDFLAG;
  }
  public QueryResult with_C_SENDFLAG(String C_SENDFLAG) {
    this.C_SENDFLAG = C_SENDFLAG;
    return this;
  }
  private String VC_BRANCHCODE;
  public String get_VC_BRANCHCODE() {
    return VC_BRANCHCODE;
  }
  public void set_VC_BRANCHCODE(String VC_BRANCHCODE) {
    this.VC_BRANCHCODE = VC_BRANCHCODE;
  }
  public QueryResult with_VC_BRANCHCODE(String VC_BRANCHCODE) {
    this.VC_BRANCHCODE = VC_BRANCHCODE;
    return this;
  }
  private java.math.BigDecimal EN_OTHERNAV;
  public java.math.BigDecimal get_EN_OTHERNAV() {
    return EN_OTHERNAV;
  }
  public void set_EN_OTHERNAV(java.math.BigDecimal EN_OTHERNAV) {
    this.EN_OTHERNAV = EN_OTHERNAV;
  }
  public QueryResult with_EN_OTHERNAV(java.math.BigDecimal EN_OTHERNAV) {
    this.EN_OTHERNAV = EN_OTHERNAV;
    return this;
  }
  private java.math.BigDecimal EN_OTHERCONFIRMSHARE;
  public java.math.BigDecimal get_EN_OTHERCONFIRMSHARE() {
    return EN_OTHERCONFIRMSHARE;
  }
  public void set_EN_OTHERCONFIRMSHARE(java.math.BigDecimal EN_OTHERCONFIRMSHARE) {
    this.EN_OTHERCONFIRMSHARE = EN_OTHERCONFIRMSHARE;
  }
  public QueryResult with_EN_OTHERCONFIRMSHARE(java.math.BigDecimal EN_OTHERCONFIRMSHARE) {
    this.EN_OTHERCONFIRMSHARE = EN_OTHERCONFIRMSHARE;
    return this;
  }
  private java.math.BigDecimal EN_OTHERORIGINFARE;
  public java.math.BigDecimal get_EN_OTHERORIGINFARE() {
    return EN_OTHERORIGINFARE;
  }
  public void set_EN_OTHERORIGINFARE(java.math.BigDecimal EN_OTHERORIGINFARE) {
    this.EN_OTHERORIGINFARE = EN_OTHERORIGINFARE;
  }
  public QueryResult with_EN_OTHERORIGINFARE(java.math.BigDecimal EN_OTHERORIGINFARE) {
    this.EN_OTHERORIGINFARE = EN_OTHERORIGINFARE;
    return this;
  }
  private String C_FIXBUSINFLAG;
  public String get_C_FIXBUSINFLAG() {
    return C_FIXBUSINFLAG;
  }
  public void set_C_FIXBUSINFLAG(String C_FIXBUSINFLAG) {
    this.C_FIXBUSINFLAG = C_FIXBUSINFLAG;
  }
  public QueryResult with_C_FIXBUSINFLAG(String C_FIXBUSINFLAG) {
    this.C_FIXBUSINFLAG = C_FIXBUSINFLAG;
    return this;
  }
  private String C_CAPITALMODE;
  public String get_C_CAPITALMODE() {
    return C_CAPITALMODE;
  }
  public void set_C_CAPITALMODE(String C_CAPITALMODE) {
    this.C_CAPITALMODE = C_CAPITALMODE;
  }
  public QueryResult with_C_CAPITALMODE(String C_CAPITALMODE) {
    this.C_CAPITALMODE = C_CAPITALMODE;
    return this;
  }
  private String C_SUBCAPITALMODE;
  public String get_C_SUBCAPITALMODE() {
    return C_SUBCAPITALMODE;
  }
  public void set_C_SUBCAPITALMODE(String C_SUBCAPITALMODE) {
    this.C_SUBCAPITALMODE = C_SUBCAPITALMODE;
  }
  public QueryResult with_C_SUBCAPITALMODE(String C_SUBCAPITALMODE) {
    this.C_SUBCAPITALMODE = C_SUBCAPITALMODE;
    return this;
  }
  private String VC_ORIGINCONFIRMNO;
  public String get_VC_ORIGINCONFIRMNO() {
    return VC_ORIGINCONFIRMNO;
  }
  public void set_VC_ORIGINCONFIRMNO(String VC_ORIGINCONFIRMNO) {
    this.VC_ORIGINCONFIRMNO = VC_ORIGINCONFIRMNO;
  }
  public QueryResult with_VC_ORIGINCONFIRMNO(String VC_ORIGINCONFIRMNO) {
    this.VC_ORIGINCONFIRMNO = VC_ORIGINCONFIRMNO;
    return this;
  }
  private String C_BUSINTYPE;
  public String get_C_BUSINTYPE() {
    return C_BUSINTYPE;
  }
  public void set_C_BUSINTYPE(String C_BUSINTYPE) {
    this.C_BUSINTYPE = C_BUSINTYPE;
  }
  public QueryResult with_C_BUSINTYPE(String C_BUSINTYPE) {
    this.C_BUSINTYPE = C_BUSINTYPE;
    return this;
  }
  private java.math.BigDecimal L_SECTIONSCHEMANO;
  public java.math.BigDecimal get_L_SECTIONSCHEMANO() {
    return L_SECTIONSCHEMANO;
  }
  public void set_L_SECTIONSCHEMANO(java.math.BigDecimal L_SECTIONSCHEMANO) {
    this.L_SECTIONSCHEMANO = L_SECTIONSCHEMANO;
  }
  public QueryResult with_L_SECTIONSCHEMANO(java.math.BigDecimal L_SECTIONSCHEMANO) {
    this.L_SECTIONSCHEMANO = L_SECTIONSCHEMANO;
    return this;
  }
  private String C_EXPTYPE;
  public String get_C_EXPTYPE() {
    return C_EXPTYPE;
  }
  public void set_C_EXPTYPE(String C_EXPTYPE) {
    this.C_EXPTYPE = C_EXPTYPE;
  }
  public QueryResult with_C_EXPTYPE(String C_EXPTYPE) {
    this.C_EXPTYPE = C_EXPTYPE;
    return this;
  }
  private String C_SHAREADJUSTFLAG;
  public String get_C_SHAREADJUSTFLAG() {
    return C_SHAREADJUSTFLAG;
  }
  public void set_C_SHAREADJUSTFLAG(String C_SHAREADJUSTFLAG) {
    this.C_SHAREADJUSTFLAG = C_SHAREADJUSTFLAG;
  }
  public QueryResult with_C_SHAREADJUSTFLAG(String C_SHAREADJUSTFLAG) {
    this.C_SHAREADJUSTFLAG = C_SHAREADJUSTFLAG;
    return this;
  }
  private String C_INCOMEFLAG;
  public String get_C_INCOMEFLAG() {
    return C_INCOMEFLAG;
  }
  public void set_C_INCOMEFLAG(String C_INCOMEFLAG) {
    this.C_INCOMEFLAG = C_INCOMEFLAG;
  }
  public QueryResult with_C_INCOMEFLAG(String C_INCOMEFLAG) {
    this.C_INCOMEFLAG = C_INCOMEFLAG;
    return this;
  }
  private java.math.BigDecimal EN_ACHIEVEMENTPAY;
  public java.math.BigDecimal get_EN_ACHIEVEMENTPAY() {
    return EN_ACHIEVEMENTPAY;
  }
  public void set_EN_ACHIEVEMENTPAY(java.math.BigDecimal EN_ACHIEVEMENTPAY) {
    this.EN_ACHIEVEMENTPAY = EN_ACHIEVEMENTPAY;
  }
  public QueryResult with_EN_ACHIEVEMENTPAY(java.math.BigDecimal EN_ACHIEVEMENTPAY) {
    this.EN_ACHIEVEMENTPAY = EN_ACHIEVEMENTPAY;
    return this;
  }
  private java.math.BigDecimal EN_BREACHFEE;
  public java.math.BigDecimal get_EN_BREACHFEE() {
    return EN_BREACHFEE;
  }
  public void set_EN_BREACHFEE(java.math.BigDecimal EN_BREACHFEE) {
    this.EN_BREACHFEE = EN_BREACHFEE;
  }
  public QueryResult with_EN_BREACHFEE(java.math.BigDecimal EN_BREACHFEE) {
    this.EN_BREACHFEE = EN_BREACHFEE;
    return this;
  }
  private String VC_COMEFROM;
  public String get_VC_COMEFROM() {
    return VC_COMEFROM;
  }
  public void set_VC_COMEFROM(String VC_COMEFROM) {
    this.VC_COMEFROM = VC_COMEFROM;
  }
  public QueryResult with_VC_COMEFROM(String VC_COMEFROM) {
    this.VC_COMEFROM = VC_COMEFROM;
    return this;
  }
  private String VC_INVESTORSYSTEMID;
  public String get_VC_INVESTORSYSTEMID() {
    return VC_INVESTORSYSTEMID;
  }
  public void set_VC_INVESTORSYSTEMID(String VC_INVESTORSYSTEMID) {
    this.VC_INVESTORSYSTEMID = VC_INVESTORSYSTEMID;
  }
  public QueryResult with_VC_INVESTORSYSTEMID(String VC_INVESTORSYSTEMID) {
    this.VC_INVESTORSYSTEMID = VC_INVESTORSYSTEMID;
    return this;
  }
  private String VC_VOUCHERNO;
  public String get_VC_VOUCHERNO() {
    return VC_VOUCHERNO;
  }
  public void set_VC_VOUCHERNO(String VC_VOUCHERNO) {
    this.VC_VOUCHERNO = VC_VOUCHERNO;
  }
  public QueryResult with_VC_VOUCHERNO(String VC_VOUCHERNO) {
    this.VC_VOUCHERNO = VC_VOUCHERNO;
    return this;
  }
  private String C_BANKNO;
  public String get_C_BANKNO() {
    return C_BANKNO;
  }
  public void set_C_BANKNO(String C_BANKNO) {
    this.C_BANKNO = C_BANKNO;
  }
  public QueryResult with_C_BANKNO(String C_BANKNO) {
    this.C_BANKNO = C_BANKNO;
    return this;
  }
  private String VC_BANKNAME;
  public String get_VC_BANKNAME() {
    return VC_BANKNAME;
  }
  public void set_VC_BANKNAME(String VC_BANKNAME) {
    this.VC_BANKNAME = VC_BANKNAME;
  }
  public QueryResult with_VC_BANKNAME(String VC_BANKNAME) {
    this.VC_BANKNAME = VC_BANKNAME;
    return this;
  }
  private String VC_NAMEINBANK;
  public String get_VC_NAMEINBANK() {
    return VC_NAMEINBANK;
  }
  public void set_VC_NAMEINBANK(String VC_NAMEINBANK) {
    this.VC_NAMEINBANK = VC_NAMEINBANK;
  }
  public QueryResult with_VC_NAMEINBANK(String VC_NAMEINBANK) {
    this.VC_NAMEINBANK = VC_NAMEINBANK;
    return this;
  }
  private String VC_BANKACCO;
  public String get_VC_BANKACCO() {
    return VC_BANKACCO;
  }
  public void set_VC_BANKACCO(String VC_BANKACCO) {
    this.VC_BANKACCO = VC_BANKACCO;
  }
  public QueryResult with_VC_BANKACCO(String VC_BANKACCO) {
    this.VC_BANKACCO = VC_BANKACCO;
    return this;
  }
  private String VC_CUSTNO;
  public String get_VC_CUSTNO() {
    return VC_CUSTNO;
  }
  public void set_VC_CUSTNO(String VC_CUSTNO) {
    this.VC_CUSTNO = VC_CUSTNO;
  }
  public QueryResult with_VC_CUSTNO(String VC_CUSTNO) {
    this.VC_CUSTNO = VC_CUSTNO;
    return this;
  }
  private String VC_CONFIRMSETTLEDATE;
  public String get_VC_CONFIRMSETTLEDATE() {
    return VC_CONFIRMSETTLEDATE;
  }
  public void set_VC_CONFIRMSETTLEDATE(String VC_CONFIRMSETTLEDATE) {
    this.VC_CONFIRMSETTLEDATE = VC_CONFIRMSETTLEDATE;
  }
  public QueryResult with_VC_CONFIRMSETTLEDATE(String VC_CONFIRMSETTLEDATE) {
    this.VC_CONFIRMSETTLEDATE = VC_CONFIRMSETTLEDATE;
    return this;
  }
  private String VC_REQUESTSETTLEDATE;
  public String get_VC_REQUESTSETTLEDATE() {
    return VC_REQUESTSETTLEDATE;
  }
  public void set_VC_REQUESTSETTLEDATE(String VC_REQUESTSETTLEDATE) {
    this.VC_REQUESTSETTLEDATE = VC_REQUESTSETTLEDATE;
  }
  public QueryResult with_VC_REQUESTSETTLEDATE(String VC_REQUESTSETTLEDATE) {
    this.VC_REQUESTSETTLEDATE = VC_REQUESTSETTLEDATE;
    return this;
  }
  private String VC_CONTRACTSERIALNO;
  public String get_VC_CONTRACTSERIALNO() {
    return VC_CONTRACTSERIALNO;
  }
  public void set_VC_CONTRACTSERIALNO(String VC_CONTRACTSERIALNO) {
    this.VC_CONTRACTSERIALNO = VC_CONTRACTSERIALNO;
  }
  public QueryResult with_VC_CONTRACTSERIALNO(String VC_CONTRACTSERIALNO) {
    this.VC_CONTRACTSERIALNO = VC_CONTRACTSERIALNO;
    return this;
  }
  private String C_PROFITCLASS;
  public String get_C_PROFITCLASS() {
    return C_PROFITCLASS;
  }
  public void set_C_PROFITCLASS(String C_PROFITCLASS) {
    this.C_PROFITCLASS = C_PROFITCLASS;
  }
  public QueryResult with_C_PROFITCLASS(String C_PROFITCLASS) {
    this.C_PROFITCLASS = C_PROFITCLASS;
    return this;
  }
  private String VC_COMBREQUESTNO;
  public String get_VC_COMBREQUESTNO() {
    return VC_COMBREQUESTNO;
  }
  public void set_VC_COMBREQUESTNO(String VC_COMBREQUESTNO) {
    this.VC_COMBREQUESTNO = VC_COMBREQUESTNO;
  }
  public QueryResult with_VC_COMBREQUESTNO(String VC_COMBREQUESTNO) {
    this.VC_COMBREQUESTNO = VC_COMBREQUESTNO;
    return this;
  }
  private String VC_COMBCODE;
  public String get_VC_COMBCODE() {
    return VC_COMBCODE;
  }
  public void set_VC_COMBCODE(String VC_COMBCODE) {
    this.VC_COMBCODE = VC_COMBCODE;
  }
  public QueryResult with_VC_COMBCODE(String VC_COMBCODE) {
    this.VC_COMBCODE = VC_COMBCODE;
    return this;
  }
  private String C_AUTOREQUEST;
  public String get_C_AUTOREQUEST() {
    return C_AUTOREQUEST;
  }
  public void set_C_AUTOREQUEST(String C_AUTOREQUEST) {
    this.C_AUTOREQUEST = C_AUTOREQUEST;
  }
  public QueryResult with_C_AUTOREQUEST(String C_AUTOREQUEST) {
    this.C_AUTOREQUEST = C_AUTOREQUEST;
    return this;
  }
  private String VC_EXPLAIN;
  public String get_VC_EXPLAIN() {
    return VC_EXPLAIN;
  }
  public void set_VC_EXPLAIN(String VC_EXPLAIN) {
    this.VC_EXPLAIN = VC_EXPLAIN;
  }
  public QueryResult with_VC_EXPLAIN(String VC_EXPLAIN) {
    this.VC_EXPLAIN = VC_EXPLAIN;
    return this;
  }
  private String C_INTERFACETYPE;
  public String get_C_INTERFACETYPE() {
    return C_INTERFACETYPE;
  }
  public void set_C_INTERFACETYPE(String C_INTERFACETYPE) {
    this.C_INTERFACETYPE = C_INTERFACETYPE;
  }
  public QueryResult with_C_INTERFACETYPE(String C_INTERFACETYPE) {
    this.C_INTERFACETYPE = C_INTERFACETYPE;
    return this;
  }
  private java.math.BigDecimal EN_OTHERFEE1;
  public java.math.BigDecimal get_EN_OTHERFEE1() {
    return EN_OTHERFEE1;
  }
  public void set_EN_OTHERFEE1(java.math.BigDecimal EN_OTHERFEE1) {
    this.EN_OTHERFEE1 = EN_OTHERFEE1;
  }
  public QueryResult with_EN_OTHERFEE1(java.math.BigDecimal EN_OTHERFEE1) {
    this.EN_OTHERFEE1 = EN_OTHERFEE1;
    return this;
  }
  private java.math.BigDecimal EN_OTHERFEE2;
  public java.math.BigDecimal get_EN_OTHERFEE2() {
    return EN_OTHERFEE2;
  }
  public void set_EN_OTHERFEE2(java.math.BigDecimal EN_OTHERFEE2) {
    this.EN_OTHERFEE2 = EN_OTHERFEE2;
  }
  public QueryResult with_EN_OTHERFEE2(java.math.BigDecimal EN_OTHERFEE2) {
    this.EN_OTHERFEE2 = EN_OTHERFEE2;
    return this;
  }
  private String C_MATCHFLAG;
  public String get_C_MATCHFLAG() {
    return C_MATCHFLAG;
  }
  public void set_C_MATCHFLAG(String C_MATCHFLAG) {
    this.C_MATCHFLAG = C_MATCHFLAG;
  }
  public QueryResult with_C_MATCHFLAG(String C_MATCHFLAG) {
    this.C_MATCHFLAG = C_MATCHFLAG;
    return this;
  }
  private String VC_BOOKID;
  public String get_VC_BOOKID() {
    return VC_BOOKID;
  }
  public void set_VC_BOOKID(String VC_BOOKID) {
    this.VC_BOOKID = VC_BOOKID;
  }
  public QueryResult with_VC_BOOKID(String VC_BOOKID) {
    this.VC_BOOKID = VC_BOOKID;
    return this;
  }
  private java.math.BigDecimal EN_GRAMNUM;
  public java.math.BigDecimal get_EN_GRAMNUM() {
    return EN_GRAMNUM;
  }
  public void set_EN_GRAMNUM(java.math.BigDecimal EN_GRAMNUM) {
    this.EN_GRAMNUM = EN_GRAMNUM;
  }
  public QueryResult with_EN_GRAMNUM(java.math.BigDecimal EN_GRAMNUM) {
    this.EN_GRAMNUM = EN_GRAMNUM;
    return this;
  }
  private String C_FORCEREDEEMREASON;
  public String get_C_FORCEREDEEMREASON() {
    return C_FORCEREDEEMREASON;
  }
  public void set_C_FORCEREDEEMREASON(String C_FORCEREDEEMREASON) {
    this.C_FORCEREDEEMREASON = C_FORCEREDEEMREASON;
  }
  public QueryResult with_C_FORCEREDEEMREASON(String C_FORCEREDEEMREASON) {
    this.C_FORCEREDEEMREASON = C_FORCEREDEEMREASON;
    return this;
  }
  private java.math.BigDecimal EN_TOTALFROZENSHARE;
  public java.math.BigDecimal get_EN_TOTALFROZENSHARE() {
    return EN_TOTALFROZENSHARE;
  }
  public void set_EN_TOTALFROZENSHARE(java.math.BigDecimal EN_TOTALFROZENSHARE) {
    this.EN_TOTALFROZENSHARE = EN_TOTALFROZENSHARE;
  }
  public QueryResult with_EN_TOTALFROZENSHARE(java.math.BigDecimal EN_TOTALFROZENSHARE) {
    this.EN_TOTALFROZENSHARE = EN_TOTALFROZENSHARE;
    return this;
  }
  private java.math.BigDecimal EN_FUNDSHAREBALANCE;
  public java.math.BigDecimal get_EN_FUNDSHAREBALANCE() {
    return EN_FUNDSHAREBALANCE;
  }
  public void set_EN_FUNDSHAREBALANCE(java.math.BigDecimal EN_FUNDSHAREBALANCE) {
    this.EN_FUNDSHAREBALANCE = EN_FUNDSHAREBALANCE;
  }
  public QueryResult with_EN_FUNDSHAREBALANCE(java.math.BigDecimal EN_FUNDSHAREBALANCE) {
    this.EN_FUNDSHAREBALANCE = EN_FUNDSHAREBALANCE;
    return this;
  }
  private java.math.BigDecimal EN_FROZENBALANCE;
  public java.math.BigDecimal get_EN_FROZENBALANCE() {
    return EN_FROZENBALANCE;
  }
  public void set_EN_FROZENBALANCE(java.math.BigDecimal EN_FROZENBALANCE) {
    this.EN_FROZENBALANCE = EN_FROZENBALANCE;
  }
  public QueryResult with_EN_FROZENBALANCE(java.math.BigDecimal EN_FROZENBALANCE) {
    this.EN_FROZENBALANCE = EN_FROZENBALANCE;
    return this;
  }
  private String VC_FUTURESUBSCRIBEDATE;
  public String get_VC_FUTURESUBSCRIBEDATE() {
    return VC_FUTURESUBSCRIBEDATE;
  }
  public void set_VC_FUTURESUBSCRIBEDATE(String VC_FUTURESUBSCRIBEDATE) {
    this.VC_FUTURESUBSCRIBEDATE = VC_FUTURESUBSCRIBEDATE;
  }
  public QueryResult with_VC_FUTURESUBSCRIBEDATE(String VC_FUTURESUBSCRIBEDATE) {
    this.VC_FUTURESUBSCRIBEDATE = VC_FUTURESUBSCRIBEDATE;
    return this;
  }
  private String VC_TRANSFERDATEFROMAGENCY;
  public String get_VC_TRANSFERDATEFROMAGENCY() {
    return VC_TRANSFERDATEFROMAGENCY;
  }
  public void set_VC_TRANSFERDATEFROMAGENCY(String VC_TRANSFERDATEFROMAGENCY) {
    this.VC_TRANSFERDATEFROMAGENCY = VC_TRANSFERDATEFROMAGENCY;
  }
  public QueryResult with_VC_TRANSFERDATEFROMAGENCY(String VC_TRANSFERDATEFROMAGENCY) {
    this.VC_TRANSFERDATEFROMAGENCY = VC_TRANSFERDATEFROMAGENCY;
    return this;
  }
  private java.math.BigDecimal EN_TAXADVANAMOUNT;
  public java.math.BigDecimal get_EN_TAXADVANAMOUNT() {
    return EN_TAXADVANAMOUNT;
  }
  public void set_EN_TAXADVANAMOUNT(java.math.BigDecimal EN_TAXADVANAMOUNT) {
    this.EN_TAXADVANAMOUNT = EN_TAXADVANAMOUNT;
  }
  public QueryResult with_EN_TAXADVANAMOUNT(java.math.BigDecimal EN_TAXADVANAMOUNT) {
    this.EN_TAXADVANAMOUNT = EN_TAXADVANAMOUNT;
    return this;
  }
  private String VC_TAXADVANCODE;
  public String get_VC_TAXADVANCODE() {
    return VC_TAXADVANCODE;
  }
  public void set_VC_TAXADVANCODE(String VC_TAXADVANCODE) {
    this.VC_TAXADVANCODE = VC_TAXADVANCODE;
  }
  public QueryResult with_VC_TAXADVANCODE(String VC_TAXADVANCODE) {
    this.VC_TAXADVANCODE = VC_TAXADVANCODE;
    return this;
  }
  private String VC_OTHERSERIALNO;
  public String get_VC_OTHERSERIALNO() {
    return VC_OTHERSERIALNO;
  }
  public void set_VC_OTHERSERIALNO(String VC_OTHERSERIALNO) {
    this.VC_OTHERSERIALNO = VC_OTHERSERIALNO;
  }
  public QueryResult with_VC_OTHERSERIALNO(String VC_OTHERSERIALNO) {
    this.VC_OTHERSERIALNO = VC_OTHERSERIALNO;
    return this;
  }
  private String C_ATTENDQUITFLAG;
  public String get_C_ATTENDQUITFLAG() {
    return C_ATTENDQUITFLAG;
  }
  public void set_C_ATTENDQUITFLAG(String C_ATTENDQUITFLAG) {
    this.C_ATTENDQUITFLAG = C_ATTENDQUITFLAG;
  }
  public QueryResult with_C_ATTENDQUITFLAG(String C_ATTENDQUITFLAG) {
    this.C_ATTENDQUITFLAG = C_ATTENDQUITFLAG;
    return this;
  }
  private String VC_CUSTOMNAME_GS;
  public String get_VC_CUSTOMNAME_GS() {
    return VC_CUSTOMNAME_GS;
  }
  public void set_VC_CUSTOMNAME_GS(String VC_CUSTOMNAME_GS) {
    this.VC_CUSTOMNAME_GS = VC_CUSTOMNAME_GS;
  }
  public QueryResult with_VC_CUSTOMNAME_GS(String VC_CUSTOMNAME_GS) {
    this.VC_CUSTOMNAME_GS = VC_CUSTOMNAME_GS;
    return this;
  }
  private String C_IDENTITYTYPE_GS;
  public String get_C_IDENTITYTYPE_GS() {
    return C_IDENTITYTYPE_GS;
  }
  public void set_C_IDENTITYTYPE_GS(String C_IDENTITYTYPE_GS) {
    this.C_IDENTITYTYPE_GS = C_IDENTITYTYPE_GS;
  }
  public QueryResult with_C_IDENTITYTYPE_GS(String C_IDENTITYTYPE_GS) {
    this.C_IDENTITYTYPE_GS = C_IDENTITYTYPE_GS;
    return this;
  }
  private String VC_IDENTITYNO_GS;
  public String get_VC_IDENTITYNO_GS() {
    return VC_IDENTITYNO_GS;
  }
  public void set_VC_IDENTITYNO_GS(String VC_IDENTITYNO_GS) {
    this.VC_IDENTITYNO_GS = VC_IDENTITYNO_GS;
  }
  public QueryResult with_VC_IDENTITYNO_GS(String VC_IDENTITYNO_GS) {
    this.VC_IDENTITYNO_GS = VC_IDENTITYNO_GS;
    return this;
  }
  private String VC_NATIONALITY_GS;
  public String get_VC_NATIONALITY_GS() {
    return VC_NATIONALITY_GS;
  }
  public void set_VC_NATIONALITY_GS(String VC_NATIONALITY_GS) {
    this.VC_NATIONALITY_GS = VC_NATIONALITY_GS;
  }
  public QueryResult with_VC_NATIONALITY_GS(String VC_NATIONALITY_GS) {
    this.VC_NATIONALITY_GS = VC_NATIONALITY_GS;
    return this;
  }
  private String VC_CERTCODE_GS;
  public String get_VC_CERTCODE_GS() {
    return VC_CERTCODE_GS;
  }
  public void set_VC_CERTCODE_GS(String VC_CERTCODE_GS) {
    this.VC_CERTCODE_GS = VC_CERTCODE_GS;
  }
  public QueryResult with_VC_CERTCODE_GS(String VC_CERTCODE_GS) {
    this.VC_CERTCODE_GS = VC_CERTCODE_GS;
    return this;
  }
  private String VC_CERTDATE_GS;
  public String get_VC_CERTDATE_GS() {
    return VC_CERTDATE_GS;
  }
  public void set_VC_CERTDATE_GS(String VC_CERTDATE_GS) {
    this.VC_CERTDATE_GS = VC_CERTDATE_GS;
  }
  public QueryResult with_VC_CERTDATE_GS(String VC_CERTDATE_GS) {
    this.VC_CERTDATE_GS = VC_CERTDATE_GS;
    return this;
  }
  private java.math.BigDecimal EN_ACCTAXPRETAKEOFF_GS;
  public java.math.BigDecimal get_EN_ACCTAXPRETAKEOFF_GS() {
    return EN_ACCTAXPRETAKEOFF_GS;
  }
  public void set_EN_ACCTAXPRETAKEOFF_GS(java.math.BigDecimal EN_ACCTAXPRETAKEOFF_GS) {
    this.EN_ACCTAXPRETAKEOFF_GS = EN_ACCTAXPRETAKEOFF_GS;
  }
  public QueryResult with_EN_ACCTAXPRETAKEOFF_GS(java.math.BigDecimal EN_ACCTAXPRETAKEOFF_GS) {
    this.EN_ACCTAXPRETAKEOFF_GS = EN_ACCTAXPRETAKEOFF_GS;
    return this;
  }
  private String INSERTTIME;
  public String get_INSERTTIME() {
    return INSERTTIME;
  }
  public void set_INSERTTIME(String INSERTTIME) {
    this.INSERTTIME = INSERTTIME;
  }
  public QueryResult with_INSERTTIME(String INSERTTIME) {
    this.INSERTTIME = INSERTTIME;
    return this;
  }
  private String UPDATETIME;
  public String get_UPDATETIME() {
    return UPDATETIME;
  }
  public void set_UPDATETIME(String UPDATETIME) {
    this.UPDATETIME = UPDATETIME;
  }
  public QueryResult with_UPDATETIME(String UPDATETIME) {
    this.UPDATETIME = UPDATETIME;
    return this;
  }
  private java.math.BigDecimal _20210422;
  public java.math.BigDecimal get__20210422() {
    return _20210422;
  }
  public void set__20210422(java.math.BigDecimal _20210422) {
    this._20210422 = _20210422;
  }
  public QueryResult with__20210422(java.math.BigDecimal _20210422) {
    this._20210422 = _20210422;
    return this;
  }
  private String _SALES_;
  public String get__SALES_() {
    return _SALES_;
  }
  public void set__SALES_(String _SALES_) {
    this._SALES_ = _SALES_;
  }
  public QueryResult with__SALES_(String _SALES_) {
    this._SALES_ = _SALES_;
    return this;
  }
  public boolean equals(Object o) {
    if (this == o) {
      return true;
    }
    if (!(o instanceof QueryResult)) {
      return false;
    }
    QueryResult that = (QueryResult) o;
    boolean equal = true;
    equal = equal && (this.C_CUSTTYPE == null ? that.C_CUSTTYPE == null : this.C_CUSTTYPE.equals(that.C_CUSTTYPE));
    equal = equal && (this.VC_FUNDACCO == null ? that.VC_FUNDACCO == null : this.VC_FUNDACCO.equals(that.VC_FUNDACCO));
    equal = equal && (this.VC_TRADEACCO == null ? that.VC_TRADEACCO == null : this.VC_TRADEACCO.equals(that.VC_TRADEACCO));
    equal = equal && (this.C_TRUST == null ? that.C_TRUST == null : this.C_TRUST.equals(that.C_TRUST));
    equal = equal && (this.VC_REQUESTDATE == null ? that.VC_REQUESTDATE == null : this.VC_REQUESTDATE.equals(that.VC_REQUESTDATE));
    equal = equal && (this.VC_REQUESTNO == null ? that.VC_REQUESTNO == null : this.VC_REQUESTNO.equals(that.VC_REQUESTNO));
    equal = equal && (this.VC_CONFIRMNO == null ? that.VC_CONFIRMNO == null : this.VC_CONFIRMNO.equals(that.VC_CONFIRMNO));
    equal = equal && (this.VC_CONFIRMDATE == null ? that.VC_CONFIRMDATE == null : this.VC_CONFIRMDATE.equals(that.VC_CONFIRMDATE));
    equal = equal && (this.VC_FUNDCODE == null ? that.VC_FUNDCODE == null : this.VC_FUNDCODE.equals(that.VC_FUNDCODE));
    equal = equal && (this.C_SHARETYPE == null ? that.C_SHARETYPE == null : this.C_SHARETYPE.equals(that.C_SHARETYPE));
    equal = equal && (this.VC_NETNO == null ? that.VC_NETNO == null : this.VC_NETNO.equals(that.VC_NETNO));
    equal = equal && (this.VC_CENTERNO == null ? that.VC_CENTERNO == null : this.VC_CENTERNO.equals(that.VC_CENTERNO));
    equal = equal && (this.EN_RATIO == null ? that.EN_RATIO == null : this.EN_RATIO.equals(that.EN_RATIO));
    equal = equal && (this.EN_NAV == null ? that.EN_NAV == null : this.EN_NAV.equals(that.EN_NAV));
    equal = equal && (this.EN_PROFIT == null ? that.EN_PROFIT == null : this.EN_PROFIT.equals(that.EN_PROFIT));
    equal = equal && (this.C_BUSINFLAG == null ? that.C_BUSINFLAG == null : this.C_BUSINFLAG.equals(that.C_BUSINFLAG));
    equal = equal && (this.EN_BALANCE == null ? that.EN_BALANCE == null : this.EN_BALANCE.equals(that.EN_BALANCE));
    equal = equal && (this.EN_SHARE == null ? that.EN_SHARE == null : this.EN_SHARE.equals(that.EN_SHARE));
    equal = equal && (this.EN_CONFIRMBALA == null ? that.EN_CONFIRMBALA == null : this.EN_CONFIRMBALA.equals(that.EN_CONFIRMBALA));
    equal = equal && (this.C_MONEYTYPE == null ? that.C_MONEYTYPE == null : this.C_MONEYTYPE.equals(that.C_MONEYTYPE));
    equal = equal && (this.EN_CONFIRMSHARE == null ? that.EN_CONFIRMSHARE == null : this.EN_CONFIRMSHARE.equals(that.EN_CONFIRMSHARE));
    equal = equal && (this.EN_FARE == null ? that.EN_FARE == null : this.EN_FARE.equals(that.EN_FARE));
    equal = equal && (this.EN_DEALFARE == null ? that.EN_DEALFARE == null : this.EN_DEALFARE.equals(that.EN_DEALFARE));
    equal = equal && (this.EN_TAFARE == null ? that.EN_TAFARE == null : this.EN_TAFARE.equals(that.EN_TAFARE));
    equal = equal && (this.EN_AFTERFARE == null ? that.EN_AFTERFARE == null : this.EN_AFTERFARE.equals(that.EN_AFTERFARE));
    equal = equal && (this.EN_AGENCYFARE == null ? that.EN_AGENCYFARE == null : this.EN_AGENCYFARE.equals(that.EN_AGENCYFARE));
    equal = equal && (this.EN_STAMPTAX == null ? that.EN_STAMPTAX == null : this.EN_STAMPTAX.equals(that.EN_STAMPTAX));
    equal = equal && (this.C_CONFIRMFLAG == null ? that.C_CONFIRMFLAG == null : this.C_CONFIRMFLAG.equals(that.C_CONFIRMFLAG));
    equal = equal && (this.VC_ERRORCODE == null ? that.VC_ERRORCODE == null : this.VC_ERRORCODE.equals(that.VC_ERRORCODE));
    equal = equal && (this.VC_ERRORCAUSE == null ? that.VC_ERRORCAUSE == null : this.VC_ERRORCAUSE.equals(that.VC_ERRORCAUSE));
    equal = equal && (this.C_VOUCHERFLAG == null ? that.C_VOUCHERFLAG == null : this.C_VOUCHERFLAG.equals(that.C_VOUCHERFLAG));
    equal = equal && (this.EN_INTEREST == null ? that.EN_INTEREST == null : this.EN_INTEREST.equals(that.EN_INTEREST));
    equal = equal && (this.EN_INTERESTTAX == null ? that.EN_INTERESTTAX == null : this.EN_INTERESTTAX.equals(that.EN_INTERESTTAX));
    equal = equal && (this.C_ORGANIGER == null ? that.C_ORGANIGER == null : this.C_ORGANIGER.equals(that.C_ORGANIGER));
    equal = equal && (this.VC_OTHERACCO == null ? that.VC_OTHERACCO == null : this.VC_OTHERACCO.equals(that.VC_OTHERACCO));
    equal = equal && (this.VC_OTHERTRADEACCO == null ? that.VC_OTHERTRADEACCO == null : this.VC_OTHERTRADEACCO.equals(that.VC_OTHERTRADEACCO));
    equal = equal && (this.C_OTHERAGENCYNO == null ? that.C_OTHERAGENCYNO == null : this.C_OTHERAGENCYNO.equals(that.C_OTHERAGENCYNO));
    equal = equal && (this.VC_OTHERNETNO == null ? that.VC_OTHERNETNO == null : this.VC_OTHERNETNO.equals(that.VC_OTHERNETNO));
    equal = equal && (this.VC_OTHERFUNDCODE == null ? that.VC_OTHERFUNDCODE == null : this.VC_OTHERFUNDCODE.equals(that.VC_OTHERFUNDCODE));
    equal = equal && (this.C_OTHERSHARETYPE == null ? that.C_OTHERSHARETYPE == null : this.C_OTHERSHARETYPE.equals(that.C_OTHERSHARETYPE));
    equal = equal && (this.EN_UNFROZENBALA == null ? that.EN_UNFROZENBALA == null : this.EN_UNFROZENBALA.equals(that.EN_UNFROZENBALA));
    equal = equal && (this.EN_RETURNFARE == null ? that.EN_RETURNFARE == null : this.EN_RETURNFARE.equals(that.EN_RETURNFARE));
    equal = equal && (this.EN_ORIGINFARE == null ? that.EN_ORIGINFARE == null : this.EN_ORIGINFARE.equals(that.EN_ORIGINFARE));
    equal = equal && (this.VC_BROKER == null ? that.VC_BROKER == null : this.VC_BROKER.equals(that.VC_BROKER));
    equal = equal && (this.C_DIVIDENDMETHOD == null ? that.C_DIVIDENDMETHOD == null : this.C_DIVIDENDMETHOD.equals(that.C_DIVIDENDMETHOD));
    equal = equal && (this.C_FROZENCAUSE == null ? that.C_FROZENCAUSE == null : this.C_FROZENCAUSE.equals(that.C_FROZENCAUSE));
    equal = equal && (this.VC_ORIGINNO == null ? that.VC_ORIGINNO == null : this.VC_ORIGINNO.equals(that.VC_ORIGINNO));
    equal = equal && (this.VC_CITYNO == null ? that.VC_CITYNO == null : this.VC_CITYNO.equals(that.VC_CITYNO));
    equal = equal && (this.VC_SELLER == null ? that.VC_SELLER == null : this.VC_SELLER.equals(that.VC_SELLER));
    equal = equal && (this.VC_TACODE == null ? that.VC_TACODE == null : this.VC_TACODE.equals(that.VC_TACODE));
    equal = equal && (this.EN_DISCOUNT == null ? that.EN_DISCOUNT == null : this.EN_DISCOUNT.equals(that.EN_DISCOUNT));
    equal = equal && (this.EN_INCOME == null ? that.EN_INCOME == null : this.EN_INCOME.equals(that.EN_INCOME));
    equal = equal && (this.EN_INVESTINCOME == null ? that.EN_INVESTINCOME == null : this.EN_INVESTINCOME.equals(that.EN_INVESTINCOME));
    equal = equal && (this.EN_INVESTSHARE == null ? that.EN_INVESTSHARE == null : this.EN_INVESTSHARE.equals(that.EN_INVESTSHARE));
    equal = equal && (this.C_FINISHFLAG == null ? that.C_FINISHFLAG == null : this.C_FINISHFLAG.equals(that.C_FINISHFLAG));
    equal = equal && (this.C_INTERESTFLAG == null ? that.C_INTERESTFLAG == null : this.C_INTERESTFLAG.equals(that.C_INTERESTFLAG));
    equal = equal && (this.C_CONFIRMSTATUS == null ? that.C_CONFIRMSTATUS == null : this.C_CONFIRMSTATUS.equals(that.C_CONFIRMSTATUS));
    equal = equal && (this.EN_OTHERDISCOUNT == null ? that.EN_OTHERDISCOUNT == null : this.EN_OTHERDISCOUNT.equals(that.EN_OTHERDISCOUNT));
    equal = equal && (this.EN_ENDDISCOUNT == null ? that.EN_ENDDISCOUNT == null : this.EN_ENDDISCOUNT.equals(that.EN_ENDDISCOUNT));
    equal = equal && (this.VC_LIQUIDATEDATE == null ? that.VC_LIQUIDATEDATE == null : this.VC_LIQUIDATEDATE.equals(that.VC_LIQUIDATEDATE));
    equal = equal && (this.C_SENDFLAG == null ? that.C_SENDFLAG == null : this.C_SENDFLAG.equals(that.C_SENDFLAG));
    equal = equal && (this.VC_BRANCHCODE == null ? that.VC_BRANCHCODE == null : this.VC_BRANCHCODE.equals(that.VC_BRANCHCODE));
    equal = equal && (this.EN_OTHERNAV == null ? that.EN_OTHERNAV == null : this.EN_OTHERNAV.equals(that.EN_OTHERNAV));
    equal = equal && (this.EN_OTHERCONFIRMSHARE == null ? that.EN_OTHERCONFIRMSHARE == null : this.EN_OTHERCONFIRMSHARE.equals(that.EN_OTHERCONFIRMSHARE));
    equal = equal && (this.EN_OTHERORIGINFARE == null ? that.EN_OTHERORIGINFARE == null : this.EN_OTHERORIGINFARE.equals(that.EN_OTHERORIGINFARE));
    equal = equal && (this.C_FIXBUSINFLAG == null ? that.C_FIXBUSINFLAG == null : this.C_FIXBUSINFLAG.equals(that.C_FIXBUSINFLAG));
    equal = equal && (this.C_CAPITALMODE == null ? that.C_CAPITALMODE == null : this.C_CAPITALMODE.equals(that.C_CAPITALMODE));
    equal = equal && (this.C_SUBCAPITALMODE == null ? that.C_SUBCAPITALMODE == null : this.C_SUBCAPITALMODE.equals(that.C_SUBCAPITALMODE));
    equal = equal && (this.VC_ORIGINCONFIRMNO == null ? that.VC_ORIGINCONFIRMNO == null : this.VC_ORIGINCONFIRMNO.equals(that.VC_ORIGINCONFIRMNO));
    equal = equal && (this.C_BUSINTYPE == null ? that.C_BUSINTYPE == null : this.C_BUSINTYPE.equals(that.C_BUSINTYPE));
    equal = equal && (this.L_SECTIONSCHEMANO == null ? that.L_SECTIONSCHEMANO == null : this.L_SECTIONSCHEMANO.equals(that.L_SECTIONSCHEMANO));
    equal = equal && (this.C_EXPTYPE == null ? that.C_EXPTYPE == null : this.C_EXPTYPE.equals(that.C_EXPTYPE));
    equal = equal && (this.C_SHAREADJUSTFLAG == null ? that.C_SHAREADJUSTFLAG == null : this.C_SHAREADJUSTFLAG.equals(that.C_SHAREADJUSTFLAG));
    equal = equal && (this.C_INCOMEFLAG == null ? that.C_INCOMEFLAG == null : this.C_INCOMEFLAG.equals(that.C_INCOMEFLAG));
    equal = equal && (this.EN_ACHIEVEMENTPAY == null ? that.EN_ACHIEVEMENTPAY == null : this.EN_ACHIEVEMENTPAY.equals(that.EN_ACHIEVEMENTPAY));
    equal = equal && (this.EN_BREACHFEE == null ? that.EN_BREACHFEE == null : this.EN_BREACHFEE.equals(that.EN_BREACHFEE));
    equal = equal && (this.VC_COMEFROM == null ? that.VC_COMEFROM == null : this.VC_COMEFROM.equals(that.VC_COMEFROM));
    equal = equal && (this.VC_INVESTORSYSTEMID == null ? that.VC_INVESTORSYSTEMID == null : this.VC_INVESTORSYSTEMID.equals(that.VC_INVESTORSYSTEMID));
    equal = equal && (this.VC_VOUCHERNO == null ? that.VC_VOUCHERNO == null : this.VC_VOUCHERNO.equals(that.VC_VOUCHERNO));
    equal = equal && (this.C_BANKNO == null ? that.C_BANKNO == null : this.C_BANKNO.equals(that.C_BANKNO));
    equal = equal && (this.VC_BANKNAME == null ? that.VC_BANKNAME == null : this.VC_BANKNAME.equals(that.VC_BANKNAME));
    equal = equal && (this.VC_NAMEINBANK == null ? that.VC_NAMEINBANK == null : this.VC_NAMEINBANK.equals(that.VC_NAMEINBANK));
    equal = equal && (this.VC_BANKACCO == null ? that.VC_BANKACCO == null : this.VC_BANKACCO.equals(that.VC_BANKACCO));
    equal = equal && (this.VC_CUSTNO == null ? that.VC_CUSTNO == null : this.VC_CUSTNO.equals(that.VC_CUSTNO));
    equal = equal && (this.VC_CONFIRMSETTLEDATE == null ? that.VC_CONFIRMSETTLEDATE == null : this.VC_CONFIRMSETTLEDATE.equals(that.VC_CONFIRMSETTLEDATE));
    equal = equal && (this.VC_REQUESTSETTLEDATE == null ? that.VC_REQUESTSETTLEDATE == null : this.VC_REQUESTSETTLEDATE.equals(that.VC_REQUESTSETTLEDATE));
    equal = equal && (this.VC_CONTRACTSERIALNO == null ? that.VC_CONTRACTSERIALNO == null : this.VC_CONTRACTSERIALNO.equals(that.VC_CONTRACTSERIALNO));
    equal = equal && (this.C_PROFITCLASS == null ? that.C_PROFITCLASS == null : this.C_PROFITCLASS.equals(that.C_PROFITCLASS));
    equal = equal && (this.VC_COMBREQUESTNO == null ? that.VC_COMBREQUESTNO == null : this.VC_COMBREQUESTNO.equals(that.VC_COMBREQUESTNO));
    equal = equal && (this.VC_COMBCODE == null ? that.VC_COMBCODE == null : this.VC_COMBCODE.equals(that.VC_COMBCODE));
    equal = equal && (this.C_AUTOREQUEST == null ? that.C_AUTOREQUEST == null : this.C_AUTOREQUEST.equals(that.C_AUTOREQUEST));
    equal = equal && (this.VC_EXPLAIN == null ? that.VC_EXPLAIN == null : this.VC_EXPLAIN.equals(that.VC_EXPLAIN));
    equal = equal && (this.C_INTERFACETYPE == null ? that.C_INTERFACETYPE == null : this.C_INTERFACETYPE.equals(that.C_INTERFACETYPE));
    equal = equal && (this.EN_OTHERFEE1 == null ? that.EN_OTHERFEE1 == null : this.EN_OTHERFEE1.equals(that.EN_OTHERFEE1));
    equal = equal && (this.EN_OTHERFEE2 == null ? that.EN_OTHERFEE2 == null : this.EN_OTHERFEE2.equals(that.EN_OTHERFEE2));
    equal = equal && (this.C_MATCHFLAG == null ? that.C_MATCHFLAG == null : this.C_MATCHFLAG.equals(that.C_MATCHFLAG));
    equal = equal && (this.VC_BOOKID == null ? that.VC_BOOKID == null : this.VC_BOOKID.equals(that.VC_BOOKID));
    equal = equal && (this.EN_GRAMNUM == null ? that.EN_GRAMNUM == null : this.EN_GRAMNUM.equals(that.EN_GRAMNUM));
    equal = equal && (this.C_FORCEREDEEMREASON == null ? that.C_FORCEREDEEMREASON == null : this.C_FORCEREDEEMREASON.equals(that.C_FORCEREDEEMREASON));
    equal = equal && (this.EN_TOTALFROZENSHARE == null ? that.EN_TOTALFROZENSHARE == null : this.EN_TOTALFROZENSHARE.equals(that.EN_TOTALFROZENSHARE));
    equal = equal && (this.EN_FUNDSHAREBALANCE == null ? that.EN_FUNDSHAREBALANCE == null : this.EN_FUNDSHAREBALANCE.equals(that.EN_FUNDSHAREBALANCE));
    equal = equal && (this.EN_FROZENBALANCE == null ? that.EN_FROZENBALANCE == null : this.EN_FROZENBALANCE.equals(that.EN_FROZENBALANCE));
    equal = equal && (this.VC_FUTURESUBSCRIBEDATE == null ? that.VC_FUTURESUBSCRIBEDATE == null : this.VC_FUTURESUBSCRIBEDATE.equals(that.VC_FUTURESUBSCRIBEDATE));
    equal = equal && (this.VC_TRANSFERDATEFROMAGENCY == null ? that.VC_TRANSFERDATEFROMAGENCY == null : this.VC_TRANSFERDATEFROMAGENCY.equals(that.VC_TRANSFERDATEFROMAGENCY));
    equal = equal && (this.EN_TAXADVANAMOUNT == null ? that.EN_TAXADVANAMOUNT == null : this.EN_TAXADVANAMOUNT.equals(that.EN_TAXADVANAMOUNT));
    equal = equal && (this.VC_TAXADVANCODE == null ? that.VC_TAXADVANCODE == null : this.VC_TAXADVANCODE.equals(that.VC_TAXADVANCODE));
    equal = equal && (this.VC_OTHERSERIALNO == null ? that.VC_OTHERSERIALNO == null : this.VC_OTHERSERIALNO.equals(that.VC_OTHERSERIALNO));
    equal = equal && (this.C_ATTENDQUITFLAG == null ? that.C_ATTENDQUITFLAG == null : this.C_ATTENDQUITFLAG.equals(that.C_ATTENDQUITFLAG));
    equal = equal && (this.VC_CUSTOMNAME_GS == null ? that.VC_CUSTOMNAME_GS == null : this.VC_CUSTOMNAME_GS.equals(that.VC_CUSTOMNAME_GS));
    equal = equal && (this.C_IDENTITYTYPE_GS == null ? that.C_IDENTITYTYPE_GS == null : this.C_IDENTITYTYPE_GS.equals(that.C_IDENTITYTYPE_GS));
    equal = equal && (this.VC_IDENTITYNO_GS == null ? that.VC_IDENTITYNO_GS == null : this.VC_IDENTITYNO_GS.equals(that.VC_IDENTITYNO_GS));
    equal = equal && (this.VC_NATIONALITY_GS == null ? that.VC_NATIONALITY_GS == null : this.VC_NATIONALITY_GS.equals(that.VC_NATIONALITY_GS));
    equal = equal && (this.VC_CERTCODE_GS == null ? that.VC_CERTCODE_GS == null : this.VC_CERTCODE_GS.equals(that.VC_CERTCODE_GS));
    equal = equal && (this.VC_CERTDATE_GS == null ? that.VC_CERTDATE_GS == null : this.VC_CERTDATE_GS.equals(that.VC_CERTDATE_GS));
    equal = equal && (this.EN_ACCTAXPRETAKEOFF_GS == null ? that.EN_ACCTAXPRETAKEOFF_GS == null : this.EN_ACCTAXPRETAKEOFF_GS.equals(that.EN_ACCTAXPRETAKEOFF_GS));
    equal = equal && (this.INSERTTIME == null ? that.INSERTTIME == null : this.INSERTTIME.equals(that.INSERTTIME));
    equal = equal && (this.UPDATETIME == null ? that.UPDATETIME == null : this.UPDATETIME.equals(that.UPDATETIME));
    equal = equal && (this._20210422 == null ? that._20210422 == null : this._20210422.equals(that._20210422));
    equal = equal && (this._SALES_ == null ? that._SALES_ == null : this._SALES_.equals(that._SALES_));
    return equal;
  }
  public boolean equals0(Object o) {
    if (this == o) {
      return true;
    }
    if (!(o instanceof QueryResult)) {
      return false;
    }
    QueryResult that = (QueryResult) o;
    boolean equal = true;
    equal = equal && (this.C_CUSTTYPE == null ? that.C_CUSTTYPE == null : this.C_CUSTTYPE.equals(that.C_CUSTTYPE));
    equal = equal && (this.VC_FUNDACCO == null ? that.VC_FUNDACCO == null : this.VC_FUNDACCO.equals(that.VC_FUNDACCO));
    equal = equal && (this.VC_TRADEACCO == null ? that.VC_TRADEACCO == null : this.VC_TRADEACCO.equals(that.VC_TRADEACCO));
    equal = equal && (this.C_TRUST == null ? that.C_TRUST == null : this.C_TRUST.equals(that.C_TRUST));
    equal = equal && (this.VC_REQUESTDATE == null ? that.VC_REQUESTDATE == null : this.VC_REQUESTDATE.equals(that.VC_REQUESTDATE));
    equal = equal && (this.VC_REQUESTNO == null ? that.VC_REQUESTNO == null : this.VC_REQUESTNO.equals(that.VC_REQUESTNO));
    equal = equal && (this.VC_CONFIRMNO == null ? that.VC_CONFIRMNO == null : this.VC_CONFIRMNO.equals(that.VC_CONFIRMNO));
    equal = equal && (this.VC_CONFIRMDATE == null ? that.VC_CONFIRMDATE == null : this.VC_CONFIRMDATE.equals(that.VC_CONFIRMDATE));
    equal = equal && (this.VC_FUNDCODE == null ? that.VC_FUNDCODE == null : this.VC_FUNDCODE.equals(that.VC_FUNDCODE));
    equal = equal && (this.C_SHARETYPE == null ? that.C_SHARETYPE == null : this.C_SHARETYPE.equals(that.C_SHARETYPE));
    equal = equal && (this.VC_NETNO == null ? that.VC_NETNO == null : this.VC_NETNO.equals(that.VC_NETNO));
    equal = equal && (this.VC_CENTERNO == null ? that.VC_CENTERNO == null : this.VC_CENTERNO.equals(that.VC_CENTERNO));
    equal = equal && (this.EN_RATIO == null ? that.EN_RATIO == null : this.EN_RATIO.equals(that.EN_RATIO));
    equal = equal && (this.EN_NAV == null ? that.EN_NAV == null : this.EN_NAV.equals(that.EN_NAV));
    equal = equal && (this.EN_PROFIT == null ? that.EN_PROFIT == null : this.EN_PROFIT.equals(that.EN_PROFIT));
    equal = equal && (this.C_BUSINFLAG == null ? that.C_BUSINFLAG == null : this.C_BUSINFLAG.equals(that.C_BUSINFLAG));
    equal = equal && (this.EN_BALANCE == null ? that.EN_BALANCE == null : this.EN_BALANCE.equals(that.EN_BALANCE));
    equal = equal && (this.EN_SHARE == null ? that.EN_SHARE == null : this.EN_SHARE.equals(that.EN_SHARE));
    equal = equal && (this.EN_CONFIRMBALA == null ? that.EN_CONFIRMBALA == null : this.EN_CONFIRMBALA.equals(that.EN_CONFIRMBALA));
    equal = equal && (this.C_MONEYTYPE == null ? that.C_MONEYTYPE == null : this.C_MONEYTYPE.equals(that.C_MONEYTYPE));
    equal = equal && (this.EN_CONFIRMSHARE == null ? that.EN_CONFIRMSHARE == null : this.EN_CONFIRMSHARE.equals(that.EN_CONFIRMSHARE));
    equal = equal && (this.EN_FARE == null ? that.EN_FARE == null : this.EN_FARE.equals(that.EN_FARE));
    equal = equal && (this.EN_DEALFARE == null ? that.EN_DEALFARE == null : this.EN_DEALFARE.equals(that.EN_DEALFARE));
    equal = equal && (this.EN_TAFARE == null ? that.EN_TAFARE == null : this.EN_TAFARE.equals(that.EN_TAFARE));
    equal = equal && (this.EN_AFTERFARE == null ? that.EN_AFTERFARE == null : this.EN_AFTERFARE.equals(that.EN_AFTERFARE));
    equal = equal && (this.EN_AGENCYFARE == null ? that.EN_AGENCYFARE == null : this.EN_AGENCYFARE.equals(that.EN_AGENCYFARE));
    equal = equal && (this.EN_STAMPTAX == null ? that.EN_STAMPTAX == null : this.EN_STAMPTAX.equals(that.EN_STAMPTAX));
    equal = equal && (this.C_CONFIRMFLAG == null ? that.C_CONFIRMFLAG == null : this.C_CONFIRMFLAG.equals(that.C_CONFIRMFLAG));
    equal = equal && (this.VC_ERRORCODE == null ? that.VC_ERRORCODE == null : this.VC_ERRORCODE.equals(that.VC_ERRORCODE));
    equal = equal && (this.VC_ERRORCAUSE == null ? that.VC_ERRORCAUSE == null : this.VC_ERRORCAUSE.equals(that.VC_ERRORCAUSE));
    equal = equal && (this.C_VOUCHERFLAG == null ? that.C_VOUCHERFLAG == null : this.C_VOUCHERFLAG.equals(that.C_VOUCHERFLAG));
    equal = equal && (this.EN_INTEREST == null ? that.EN_INTEREST == null : this.EN_INTEREST.equals(that.EN_INTEREST));
    equal = equal && (this.EN_INTERESTTAX == null ? that.EN_INTERESTTAX == null : this.EN_INTERESTTAX.equals(that.EN_INTERESTTAX));
    equal = equal && (this.C_ORGANIGER == null ? that.C_ORGANIGER == null : this.C_ORGANIGER.equals(that.C_ORGANIGER));
    equal = equal && (this.VC_OTHERACCO == null ? that.VC_OTHERACCO == null : this.VC_OTHERACCO.equals(that.VC_OTHERACCO));
    equal = equal && (this.VC_OTHERTRADEACCO == null ? that.VC_OTHERTRADEACCO == null : this.VC_OTHERTRADEACCO.equals(that.VC_OTHERTRADEACCO));
    equal = equal && (this.C_OTHERAGENCYNO == null ? that.C_OTHERAGENCYNO == null : this.C_OTHERAGENCYNO.equals(that.C_OTHERAGENCYNO));
    equal = equal && (this.VC_OTHERNETNO == null ? that.VC_OTHERNETNO == null : this.VC_OTHERNETNO.equals(that.VC_OTHERNETNO));
    equal = equal && (this.VC_OTHERFUNDCODE == null ? that.VC_OTHERFUNDCODE == null : this.VC_OTHERFUNDCODE.equals(that.VC_OTHERFUNDCODE));
    equal = equal && (this.C_OTHERSHARETYPE == null ? that.C_OTHERSHARETYPE == null : this.C_OTHERSHARETYPE.equals(that.C_OTHERSHARETYPE));
    equal = equal && (this.EN_UNFROZENBALA == null ? that.EN_UNFROZENBALA == null : this.EN_UNFROZENBALA.equals(that.EN_UNFROZENBALA));
    equal = equal && (this.EN_RETURNFARE == null ? that.EN_RETURNFARE == null : this.EN_RETURNFARE.equals(that.EN_RETURNFARE));
    equal = equal && (this.EN_ORIGINFARE == null ? that.EN_ORIGINFARE == null : this.EN_ORIGINFARE.equals(that.EN_ORIGINFARE));
    equal = equal && (this.VC_BROKER == null ? that.VC_BROKER == null : this.VC_BROKER.equals(that.VC_BROKER));
    equal = equal && (this.C_DIVIDENDMETHOD == null ? that.C_DIVIDENDMETHOD == null : this.C_DIVIDENDMETHOD.equals(that.C_DIVIDENDMETHOD));
    equal = equal && (this.C_FROZENCAUSE == null ? that.C_FROZENCAUSE == null : this.C_FROZENCAUSE.equals(that.C_FROZENCAUSE));
    equal = equal && (this.VC_ORIGINNO == null ? that.VC_ORIGINNO == null : this.VC_ORIGINNO.equals(that.VC_ORIGINNO));
    equal = equal && (this.VC_CITYNO == null ? that.VC_CITYNO == null : this.VC_CITYNO.equals(that.VC_CITYNO));
    equal = equal && (this.VC_SELLER == null ? that.VC_SELLER == null : this.VC_SELLER.equals(that.VC_SELLER));
    equal = equal && (this.VC_TACODE == null ? that.VC_TACODE == null : this.VC_TACODE.equals(that.VC_TACODE));
    equal = equal && (this.EN_DISCOUNT == null ? that.EN_DISCOUNT == null : this.EN_DISCOUNT.equals(that.EN_DISCOUNT));
    equal = equal && (this.EN_INCOME == null ? that.EN_INCOME == null : this.EN_INCOME.equals(that.EN_INCOME));
    equal = equal && (this.EN_INVESTINCOME == null ? that.EN_INVESTINCOME == null : this.EN_INVESTINCOME.equals(that.EN_INVESTINCOME));
    equal = equal && (this.EN_INVESTSHARE == null ? that.EN_INVESTSHARE == null : this.EN_INVESTSHARE.equals(that.EN_INVESTSHARE));
    equal = equal && (this.C_FINISHFLAG == null ? that.C_FINISHFLAG == null : this.C_FINISHFLAG.equals(that.C_FINISHFLAG));
    equal = equal && (this.C_INTERESTFLAG == null ? that.C_INTERESTFLAG == null : this.C_INTERESTFLAG.equals(that.C_INTERESTFLAG));
    equal = equal && (this.C_CONFIRMSTATUS == null ? that.C_CONFIRMSTATUS == null : this.C_CONFIRMSTATUS.equals(that.C_CONFIRMSTATUS));
    equal = equal && (this.EN_OTHERDISCOUNT == null ? that.EN_OTHERDISCOUNT == null : this.EN_OTHERDISCOUNT.equals(that.EN_OTHERDISCOUNT));
    equal = equal && (this.EN_ENDDISCOUNT == null ? that.EN_ENDDISCOUNT == null : this.EN_ENDDISCOUNT.equals(that.EN_ENDDISCOUNT));
    equal = equal && (this.VC_LIQUIDATEDATE == null ? that.VC_LIQUIDATEDATE == null : this.VC_LIQUIDATEDATE.equals(that.VC_LIQUIDATEDATE));
    equal = equal && (this.C_SENDFLAG == null ? that.C_SENDFLAG == null : this.C_SENDFLAG.equals(that.C_SENDFLAG));
    equal = equal && (this.VC_BRANCHCODE == null ? that.VC_BRANCHCODE == null : this.VC_BRANCHCODE.equals(that.VC_BRANCHCODE));
    equal = equal && (this.EN_OTHERNAV == null ? that.EN_OTHERNAV == null : this.EN_OTHERNAV.equals(that.EN_OTHERNAV));
    equal = equal && (this.EN_OTHERCONFIRMSHARE == null ? that.EN_OTHERCONFIRMSHARE == null : this.EN_OTHERCONFIRMSHARE.equals(that.EN_OTHERCONFIRMSHARE));
    equal = equal && (this.EN_OTHERORIGINFARE == null ? that.EN_OTHERORIGINFARE == null : this.EN_OTHERORIGINFARE.equals(that.EN_OTHERORIGINFARE));
    equal = equal && (this.C_FIXBUSINFLAG == null ? that.C_FIXBUSINFLAG == null : this.C_FIXBUSINFLAG.equals(that.C_FIXBUSINFLAG));
    equal = equal && (this.C_CAPITALMODE == null ? that.C_CAPITALMODE == null : this.C_CAPITALMODE.equals(that.C_CAPITALMODE));
    equal = equal && (this.C_SUBCAPITALMODE == null ? that.C_SUBCAPITALMODE == null : this.C_SUBCAPITALMODE.equals(that.C_SUBCAPITALMODE));
    equal = equal && (this.VC_ORIGINCONFIRMNO == null ? that.VC_ORIGINCONFIRMNO == null : this.VC_ORIGINCONFIRMNO.equals(that.VC_ORIGINCONFIRMNO));
    equal = equal && (this.C_BUSINTYPE == null ? that.C_BUSINTYPE == null : this.C_BUSINTYPE.equals(that.C_BUSINTYPE));
    equal = equal && (this.L_SECTIONSCHEMANO == null ? that.L_SECTIONSCHEMANO == null : this.L_SECTIONSCHEMANO.equals(that.L_SECTIONSCHEMANO));
    equal = equal && (this.C_EXPTYPE == null ? that.C_EXPTYPE == null : this.C_EXPTYPE.equals(that.C_EXPTYPE));
    equal = equal && (this.C_SHAREADJUSTFLAG == null ? that.C_SHAREADJUSTFLAG == null : this.C_SHAREADJUSTFLAG.equals(that.C_SHAREADJUSTFLAG));
    equal = equal && (this.C_INCOMEFLAG == null ? that.C_INCOMEFLAG == null : this.C_INCOMEFLAG.equals(that.C_INCOMEFLAG));
    equal = equal && (this.EN_ACHIEVEMENTPAY == null ? that.EN_ACHIEVEMENTPAY == null : this.EN_ACHIEVEMENTPAY.equals(that.EN_ACHIEVEMENTPAY));
    equal = equal && (this.EN_BREACHFEE == null ? that.EN_BREACHFEE == null : this.EN_BREACHFEE.equals(that.EN_BREACHFEE));
    equal = equal && (this.VC_COMEFROM == null ? that.VC_COMEFROM == null : this.VC_COMEFROM.equals(that.VC_COMEFROM));
    equal = equal && (this.VC_INVESTORSYSTEMID == null ? that.VC_INVESTORSYSTEMID == null : this.VC_INVESTORSYSTEMID.equals(that.VC_INVESTORSYSTEMID));
    equal = equal && (this.VC_VOUCHERNO == null ? that.VC_VOUCHERNO == null : this.VC_VOUCHERNO.equals(that.VC_VOUCHERNO));
    equal = equal && (this.C_BANKNO == null ? that.C_BANKNO == null : this.C_BANKNO.equals(that.C_BANKNO));
    equal = equal && (this.VC_BANKNAME == null ? that.VC_BANKNAME == null : this.VC_BANKNAME.equals(that.VC_BANKNAME));
    equal = equal && (this.VC_NAMEINBANK == null ? that.VC_NAMEINBANK == null : this.VC_NAMEINBANK.equals(that.VC_NAMEINBANK));
    equal = equal && (this.VC_BANKACCO == null ? that.VC_BANKACCO == null : this.VC_BANKACCO.equals(that.VC_BANKACCO));
    equal = equal && (this.VC_CUSTNO == null ? that.VC_CUSTNO == null : this.VC_CUSTNO.equals(that.VC_CUSTNO));
    equal = equal && (this.VC_CONFIRMSETTLEDATE == null ? that.VC_CONFIRMSETTLEDATE == null : this.VC_CONFIRMSETTLEDATE.equals(that.VC_CONFIRMSETTLEDATE));
    equal = equal && (this.VC_REQUESTSETTLEDATE == null ? that.VC_REQUESTSETTLEDATE == null : this.VC_REQUESTSETTLEDATE.equals(that.VC_REQUESTSETTLEDATE));
    equal = equal && (this.VC_CONTRACTSERIALNO == null ? that.VC_CONTRACTSERIALNO == null : this.VC_CONTRACTSERIALNO.equals(that.VC_CONTRACTSERIALNO));
    equal = equal && (this.C_PROFITCLASS == null ? that.C_PROFITCLASS == null : this.C_PROFITCLASS.equals(that.C_PROFITCLASS));
    equal = equal && (this.VC_COMBREQUESTNO == null ? that.VC_COMBREQUESTNO == null : this.VC_COMBREQUESTNO.equals(that.VC_COMBREQUESTNO));
    equal = equal && (this.VC_COMBCODE == null ? that.VC_COMBCODE == null : this.VC_COMBCODE.equals(that.VC_COMBCODE));
    equal = equal && (this.C_AUTOREQUEST == null ? that.C_AUTOREQUEST == null : this.C_AUTOREQUEST.equals(that.C_AUTOREQUEST));
    equal = equal && (this.VC_EXPLAIN == null ? that.VC_EXPLAIN == null : this.VC_EXPLAIN.equals(that.VC_EXPLAIN));
    equal = equal && (this.C_INTERFACETYPE == null ? that.C_INTERFACETYPE == null : this.C_INTERFACETYPE.equals(that.C_INTERFACETYPE));
    equal = equal && (this.EN_OTHERFEE1 == null ? that.EN_OTHERFEE1 == null : this.EN_OTHERFEE1.equals(that.EN_OTHERFEE1));
    equal = equal && (this.EN_OTHERFEE2 == null ? that.EN_OTHERFEE2 == null : this.EN_OTHERFEE2.equals(that.EN_OTHERFEE2));
    equal = equal && (this.C_MATCHFLAG == null ? that.C_MATCHFLAG == null : this.C_MATCHFLAG.equals(that.C_MATCHFLAG));
    equal = equal && (this.VC_BOOKID == null ? that.VC_BOOKID == null : this.VC_BOOKID.equals(that.VC_BOOKID));
    equal = equal && (this.EN_GRAMNUM == null ? that.EN_GRAMNUM == null : this.EN_GRAMNUM.equals(that.EN_GRAMNUM));
    equal = equal && (this.C_FORCEREDEEMREASON == null ? that.C_FORCEREDEEMREASON == null : this.C_FORCEREDEEMREASON.equals(that.C_FORCEREDEEMREASON));
    equal = equal && (this.EN_TOTALFROZENSHARE == null ? that.EN_TOTALFROZENSHARE == null : this.EN_TOTALFROZENSHARE.equals(that.EN_TOTALFROZENSHARE));
    equal = equal && (this.EN_FUNDSHAREBALANCE == null ? that.EN_FUNDSHAREBALANCE == null : this.EN_FUNDSHAREBALANCE.equals(that.EN_FUNDSHAREBALANCE));
    equal = equal && (this.EN_FROZENBALANCE == null ? that.EN_FROZENBALANCE == null : this.EN_FROZENBALANCE.equals(that.EN_FROZENBALANCE));
    equal = equal && (this.VC_FUTURESUBSCRIBEDATE == null ? that.VC_FUTURESUBSCRIBEDATE == null : this.VC_FUTURESUBSCRIBEDATE.equals(that.VC_FUTURESUBSCRIBEDATE));
    equal = equal && (this.VC_TRANSFERDATEFROMAGENCY == null ? that.VC_TRANSFERDATEFROMAGENCY == null : this.VC_TRANSFERDATEFROMAGENCY.equals(that.VC_TRANSFERDATEFROMAGENCY));
    equal = equal && (this.EN_TAXADVANAMOUNT == null ? that.EN_TAXADVANAMOUNT == null : this.EN_TAXADVANAMOUNT.equals(that.EN_TAXADVANAMOUNT));
    equal = equal && (this.VC_TAXADVANCODE == null ? that.VC_TAXADVANCODE == null : this.VC_TAXADVANCODE.equals(that.VC_TAXADVANCODE));
    equal = equal && (this.VC_OTHERSERIALNO == null ? that.VC_OTHERSERIALNO == null : this.VC_OTHERSERIALNO.equals(that.VC_OTHERSERIALNO));
    equal = equal && (this.C_ATTENDQUITFLAG == null ? that.C_ATTENDQUITFLAG == null : this.C_ATTENDQUITFLAG.equals(that.C_ATTENDQUITFLAG));
    equal = equal && (this.VC_CUSTOMNAME_GS == null ? that.VC_CUSTOMNAME_GS == null : this.VC_CUSTOMNAME_GS.equals(that.VC_CUSTOMNAME_GS));
    equal = equal && (this.C_IDENTITYTYPE_GS == null ? that.C_IDENTITYTYPE_GS == null : this.C_IDENTITYTYPE_GS.equals(that.C_IDENTITYTYPE_GS));
    equal = equal && (this.VC_IDENTITYNO_GS == null ? that.VC_IDENTITYNO_GS == null : this.VC_IDENTITYNO_GS.equals(that.VC_IDENTITYNO_GS));
    equal = equal && (this.VC_NATIONALITY_GS == null ? that.VC_NATIONALITY_GS == null : this.VC_NATIONALITY_GS.equals(that.VC_NATIONALITY_GS));
    equal = equal && (this.VC_CERTCODE_GS == null ? that.VC_CERTCODE_GS == null : this.VC_CERTCODE_GS.equals(that.VC_CERTCODE_GS));
    equal = equal && (this.VC_CERTDATE_GS == null ? that.VC_CERTDATE_GS == null : this.VC_CERTDATE_GS.equals(that.VC_CERTDATE_GS));
    equal = equal && (this.EN_ACCTAXPRETAKEOFF_GS == null ? that.EN_ACCTAXPRETAKEOFF_GS == null : this.EN_ACCTAXPRETAKEOFF_GS.equals(that.EN_ACCTAXPRETAKEOFF_GS));
    equal = equal && (this.INSERTTIME == null ? that.INSERTTIME == null : this.INSERTTIME.equals(that.INSERTTIME));
    equal = equal && (this.UPDATETIME == null ? that.UPDATETIME == null : this.UPDATETIME.equals(that.UPDATETIME));
    equal = equal && (this._20210422 == null ? that._20210422 == null : this._20210422.equals(that._20210422));
    equal = equal && (this._SALES_ == null ? that._SALES_ == null : this._SALES_.equals(that._SALES_));
    return equal;
  }
  public void readFields(ResultSet __dbResults) throws SQLException {
    this.__cur_result_set = __dbResults;
    this.C_CUSTTYPE = JdbcWritableBridge.readString(1, __dbResults);
    this.VC_FUNDACCO = JdbcWritableBridge.readString(2, __dbResults);
    this.VC_TRADEACCO = JdbcWritableBridge.readString(3, __dbResults);
    this.C_TRUST = JdbcWritableBridge.readString(4, __dbResults);
    this.VC_REQUESTDATE = JdbcWritableBridge.readString(5, __dbResults);
    this.VC_REQUESTNO = JdbcWritableBridge.readString(6, __dbResults);
    this.VC_CONFIRMNO = JdbcWritableBridge.readString(7, __dbResults);
    this.VC_CONFIRMDATE = JdbcWritableBridge.readString(8, __dbResults);
    this.VC_FUNDCODE = JdbcWritableBridge.readString(9, __dbResults);
    this.C_SHARETYPE = JdbcWritableBridge.readString(10, __dbResults);
    this.VC_NETNO = JdbcWritableBridge.readString(11, __dbResults);
    this.VC_CENTERNO = JdbcWritableBridge.readString(12, __dbResults);
    this.EN_RATIO = JdbcWritableBridge.readBigDecimal(13, __dbResults);
    this.EN_NAV = JdbcWritableBridge.readBigDecimal(14, __dbResults);
    this.EN_PROFIT = JdbcWritableBridge.readBigDecimal(15, __dbResults);
    this.C_BUSINFLAG = JdbcWritableBridge.readString(16, __dbResults);
    this.EN_BALANCE = JdbcWritableBridge.readBigDecimal(17, __dbResults);
    this.EN_SHARE = JdbcWritableBridge.readBigDecimal(18, __dbResults);
    this.EN_CONFIRMBALA = JdbcWritableBridge.readBigDecimal(19, __dbResults);
    this.C_MONEYTYPE = JdbcWritableBridge.readString(20, __dbResults);
    this.EN_CONFIRMSHARE = JdbcWritableBridge.readBigDecimal(21, __dbResults);
    this.EN_FARE = JdbcWritableBridge.readBigDecimal(22, __dbResults);
    this.EN_DEALFARE = JdbcWritableBridge.readBigDecimal(23, __dbResults);
    this.EN_TAFARE = JdbcWritableBridge.readBigDecimal(24, __dbResults);
    this.EN_AFTERFARE = JdbcWritableBridge.readBigDecimal(25, __dbResults);
    this.EN_AGENCYFARE = JdbcWritableBridge.readBigDecimal(26, __dbResults);
    this.EN_STAMPTAX = JdbcWritableBridge.readBigDecimal(27, __dbResults);
    this.C_CONFIRMFLAG = JdbcWritableBridge.readString(28, __dbResults);
    this.VC_ERRORCODE = JdbcWritableBridge.readString(29, __dbResults);
    this.VC_ERRORCAUSE = JdbcWritableBridge.readString(30, __dbResults);
    this.C_VOUCHERFLAG = JdbcWritableBridge.readString(31, __dbResults);
    this.EN_INTEREST = JdbcWritableBridge.readBigDecimal(32, __dbResults);
    this.EN_INTERESTTAX = JdbcWritableBridge.readBigDecimal(33, __dbResults);
    this.C_ORGANIGER = JdbcWritableBridge.readString(34, __dbResults);
    this.VC_OTHERACCO = JdbcWritableBridge.readString(35, __dbResults);
    this.VC_OTHERTRADEACCO = JdbcWritableBridge.readString(36, __dbResults);
    this.C_OTHERAGENCYNO = JdbcWritableBridge.readString(37, __dbResults);
    this.VC_OTHERNETNO = JdbcWritableBridge.readString(38, __dbResults);
    this.VC_OTHERFUNDCODE = JdbcWritableBridge.readString(39, __dbResults);
    this.C_OTHERSHARETYPE = JdbcWritableBridge.readString(40, __dbResults);
    this.EN_UNFROZENBALA = JdbcWritableBridge.readBigDecimal(41, __dbResults);
    this.EN_RETURNFARE = JdbcWritableBridge.readBigDecimal(42, __dbResults);
    this.EN_ORIGINFARE = JdbcWritableBridge.readBigDecimal(43, __dbResults);
    this.VC_BROKER = JdbcWritableBridge.readString(44, __dbResults);
    this.C_DIVIDENDMETHOD = JdbcWritableBridge.readString(45, __dbResults);
    this.C_FROZENCAUSE = JdbcWritableBridge.readString(46, __dbResults);
    this.VC_ORIGINNO = JdbcWritableBridge.readString(47, __dbResults);
    this.VC_CITYNO = JdbcWritableBridge.readString(48, __dbResults);
    this.VC_SELLER = JdbcWritableBridge.readString(49, __dbResults);
    this.VC_TACODE = JdbcWritableBridge.readString(50, __dbResults);
    this.EN_DISCOUNT = JdbcWritableBridge.readBigDecimal(51, __dbResults);
    this.EN_INCOME = JdbcWritableBridge.readBigDecimal(52, __dbResults);
    this.EN_INVESTINCOME = JdbcWritableBridge.readBigDecimal(53, __dbResults);
    this.EN_INVESTSHARE = JdbcWritableBridge.readBigDecimal(54, __dbResults);
    this.C_FINISHFLAG = JdbcWritableBridge.readString(55, __dbResults);
    this.C_INTERESTFLAG = JdbcWritableBridge.readString(56, __dbResults);
    this.C_CONFIRMSTATUS = JdbcWritableBridge.readString(57, __dbResults);
    this.EN_OTHERDISCOUNT = JdbcWritableBridge.readBigDecimal(58, __dbResults);
    this.EN_ENDDISCOUNT = JdbcWritableBridge.readBigDecimal(59, __dbResults);
    this.VC_LIQUIDATEDATE = JdbcWritableBridge.readString(60, __dbResults);
    this.C_SENDFLAG = JdbcWritableBridge.readString(61, __dbResults);
    this.VC_BRANCHCODE = JdbcWritableBridge.readString(62, __dbResults);
    this.EN_OTHERNAV = JdbcWritableBridge.readBigDecimal(63, __dbResults);
    this.EN_OTHERCONFIRMSHARE = JdbcWritableBridge.readBigDecimal(64, __dbResults);
    this.EN_OTHERORIGINFARE = JdbcWritableBridge.readBigDecimal(65, __dbResults);
    this.C_FIXBUSINFLAG = JdbcWritableBridge.readString(66, __dbResults);
    this.C_CAPITALMODE = JdbcWritableBridge.readString(67, __dbResults);
    this.C_SUBCAPITALMODE = JdbcWritableBridge.readString(68, __dbResults);
    this.VC_ORIGINCONFIRMNO = JdbcWritableBridge.readString(69, __dbResults);
    this.C_BUSINTYPE = JdbcWritableBridge.readString(70, __dbResults);
    this.L_SECTIONSCHEMANO = JdbcWritableBridge.readBigDecimal(71, __dbResults);
    this.C_EXPTYPE = JdbcWritableBridge.readString(72, __dbResults);
    this.C_SHAREADJUSTFLAG = JdbcWritableBridge.readString(73, __dbResults);
    this.C_INCOMEFLAG = JdbcWritableBridge.readString(74, __dbResults);
    this.EN_ACHIEVEMENTPAY = JdbcWritableBridge.readBigDecimal(75, __dbResults);
    this.EN_BREACHFEE = JdbcWritableBridge.readBigDecimal(76, __dbResults);
    this.VC_COMEFROM = JdbcWritableBridge.readString(77, __dbResults);
    this.VC_INVESTORSYSTEMID = JdbcWritableBridge.readString(78, __dbResults);
    this.VC_VOUCHERNO = JdbcWritableBridge.readString(79, __dbResults);
    this.C_BANKNO = JdbcWritableBridge.readString(80, __dbResults);
    this.VC_BANKNAME = JdbcWritableBridge.readString(81, __dbResults);
    this.VC_NAMEINBANK = JdbcWritableBridge.readString(82, __dbResults);
    this.VC_BANKACCO = JdbcWritableBridge.readString(83, __dbResults);
    this.VC_CUSTNO = JdbcWritableBridge.readString(84, __dbResults);
    this.VC_CONFIRMSETTLEDATE = JdbcWritableBridge.readString(85, __dbResults);
    this.VC_REQUESTSETTLEDATE = JdbcWritableBridge.readString(86, __dbResults);
    this.VC_CONTRACTSERIALNO = JdbcWritableBridge.readString(87, __dbResults);
    this.C_PROFITCLASS = JdbcWritableBridge.readString(88, __dbResults);
    this.VC_COMBREQUESTNO = JdbcWritableBridge.readString(89, __dbResults);
    this.VC_COMBCODE = JdbcWritableBridge.readString(90, __dbResults);
    this.C_AUTOREQUEST = JdbcWritableBridge.readString(91, __dbResults);
    this.VC_EXPLAIN = JdbcWritableBridge.readString(92, __dbResults);
    this.C_INTERFACETYPE = JdbcWritableBridge.readString(93, __dbResults);
    this.EN_OTHERFEE1 = JdbcWritableBridge.readBigDecimal(94, __dbResults);
    this.EN_OTHERFEE2 = JdbcWritableBridge.readBigDecimal(95, __dbResults);
    this.C_MATCHFLAG = JdbcWritableBridge.readString(96, __dbResults);
    this.VC_BOOKID = JdbcWritableBridge.readString(97, __dbResults);
    this.EN_GRAMNUM = JdbcWritableBridge.readBigDecimal(98, __dbResults);
    this.C_FORCEREDEEMREASON = JdbcWritableBridge.readString(99, __dbResults);
    this.EN_TOTALFROZENSHARE = JdbcWritableBridge.readBigDecimal(100, __dbResults);
    this.EN_FUNDSHAREBALANCE = JdbcWritableBridge.readBigDecimal(101, __dbResults);
    this.EN_FROZENBALANCE = JdbcWritableBridge.readBigDecimal(102, __dbResults);
    this.VC_FUTURESUBSCRIBEDATE = JdbcWritableBridge.readString(103, __dbResults);
    this.VC_TRANSFERDATEFROMAGENCY = JdbcWritableBridge.readString(104, __dbResults);
    this.EN_TAXADVANAMOUNT = JdbcWritableBridge.readBigDecimal(105, __dbResults);
    this.VC_TAXADVANCODE = JdbcWritableBridge.readString(106, __dbResults);
    this.VC_OTHERSERIALNO = JdbcWritableBridge.readString(107, __dbResults);
    this.C_ATTENDQUITFLAG = JdbcWritableBridge.readString(108, __dbResults);
    this.VC_CUSTOMNAME_GS = JdbcWritableBridge.readString(109, __dbResults);
    this.C_IDENTITYTYPE_GS = JdbcWritableBridge.readString(110, __dbResults);
    this.VC_IDENTITYNO_GS = JdbcWritableBridge.readString(111, __dbResults);
    this.VC_NATIONALITY_GS = JdbcWritableBridge.readString(112, __dbResults);
    this.VC_CERTCODE_GS = JdbcWritableBridge.readString(113, __dbResults);
    this.VC_CERTDATE_GS = JdbcWritableBridge.readString(114, __dbResults);
    this.EN_ACCTAXPRETAKEOFF_GS = JdbcWritableBridge.readBigDecimal(115, __dbResults);
    this.INSERTTIME = JdbcWritableBridge.readString(116, __dbResults);
    this.UPDATETIME = JdbcWritableBridge.readString(117, __dbResults);
    this._20210422 = JdbcWritableBridge.readBigDecimal(118, __dbResults);
    this._SALES_ = JdbcWritableBridge.readString(119, __dbResults);
  }
  public void readFields0(ResultSet __dbResults) throws SQLException {
    this.C_CUSTTYPE = JdbcWritableBridge.readString(1, __dbResults);
    this.VC_FUNDACCO = JdbcWritableBridge.readString(2, __dbResults);
    this.VC_TRADEACCO = JdbcWritableBridge.readString(3, __dbResults);
    this.C_TRUST = JdbcWritableBridge.readString(4, __dbResults);
    this.VC_REQUESTDATE = JdbcWritableBridge.readString(5, __dbResults);
    this.VC_REQUESTNO = JdbcWritableBridge.readString(6, __dbResults);
    this.VC_CONFIRMNO = JdbcWritableBridge.readString(7, __dbResults);
    this.VC_CONFIRMDATE = JdbcWritableBridge.readString(8, __dbResults);
    this.VC_FUNDCODE = JdbcWritableBridge.readString(9, __dbResults);
    this.C_SHARETYPE = JdbcWritableBridge.readString(10, __dbResults);
    this.VC_NETNO = JdbcWritableBridge.readString(11, __dbResults);
    this.VC_CENTERNO = JdbcWritableBridge.readString(12, __dbResults);
    this.EN_RATIO = JdbcWritableBridge.readBigDecimal(13, __dbResults);
    this.EN_NAV = JdbcWritableBridge.readBigDecimal(14, __dbResults);
    this.EN_PROFIT = JdbcWritableBridge.readBigDecimal(15, __dbResults);
    this.C_BUSINFLAG = JdbcWritableBridge.readString(16, __dbResults);
    this.EN_BALANCE = JdbcWritableBridge.readBigDecimal(17, __dbResults);
    this.EN_SHARE = JdbcWritableBridge.readBigDecimal(18, __dbResults);
    this.EN_CONFIRMBALA = JdbcWritableBridge.readBigDecimal(19, __dbResults);
    this.C_MONEYTYPE = JdbcWritableBridge.readString(20, __dbResults);
    this.EN_CONFIRMSHARE = JdbcWritableBridge.readBigDecimal(21, __dbResults);
    this.EN_FARE = JdbcWritableBridge.readBigDecimal(22, __dbResults);
    this.EN_DEALFARE = JdbcWritableBridge.readBigDecimal(23, __dbResults);
    this.EN_TAFARE = JdbcWritableBridge.readBigDecimal(24, __dbResults);
    this.EN_AFTERFARE = JdbcWritableBridge.readBigDecimal(25, __dbResults);
    this.EN_AGENCYFARE = JdbcWritableBridge.readBigDecimal(26, __dbResults);
    this.EN_STAMPTAX = JdbcWritableBridge.readBigDecimal(27, __dbResults);
    this.C_CONFIRMFLAG = JdbcWritableBridge.readString(28, __dbResults);
    this.VC_ERRORCODE = JdbcWritableBridge.readString(29, __dbResults);
    this.VC_ERRORCAUSE = JdbcWritableBridge.readString(30, __dbResults);
    this.C_VOUCHERFLAG = JdbcWritableBridge.readString(31, __dbResults);
    this.EN_INTEREST = JdbcWritableBridge.readBigDecimal(32, __dbResults);
    this.EN_INTERESTTAX = JdbcWritableBridge.readBigDecimal(33, __dbResults);
    this.C_ORGANIGER = JdbcWritableBridge.readString(34, __dbResults);
    this.VC_OTHERACCO = JdbcWritableBridge.readString(35, __dbResults);
    this.VC_OTHERTRADEACCO = JdbcWritableBridge.readString(36, __dbResults);
    this.C_OTHERAGENCYNO = JdbcWritableBridge.readString(37, __dbResults);
    this.VC_OTHERNETNO = JdbcWritableBridge.readString(38, __dbResults);
    this.VC_OTHERFUNDCODE = JdbcWritableBridge.readString(39, __dbResults);
    this.C_OTHERSHARETYPE = JdbcWritableBridge.readString(40, __dbResults);
    this.EN_UNFROZENBALA = JdbcWritableBridge.readBigDecimal(41, __dbResults);
    this.EN_RETURNFARE = JdbcWritableBridge.readBigDecimal(42, __dbResults);
    this.EN_ORIGINFARE = JdbcWritableBridge.readBigDecimal(43, __dbResults);
    this.VC_BROKER = JdbcWritableBridge.readString(44, __dbResults);
    this.C_DIVIDENDMETHOD = JdbcWritableBridge.readString(45, __dbResults);
    this.C_FROZENCAUSE = JdbcWritableBridge.readString(46, __dbResults);
    this.VC_ORIGINNO = JdbcWritableBridge.readString(47, __dbResults);
    this.VC_CITYNO = JdbcWritableBridge.readString(48, __dbResults);
    this.VC_SELLER = JdbcWritableBridge.readString(49, __dbResults);
    this.VC_TACODE = JdbcWritableBridge.readString(50, __dbResults);
    this.EN_DISCOUNT = JdbcWritableBridge.readBigDecimal(51, __dbResults);
    this.EN_INCOME = JdbcWritableBridge.readBigDecimal(52, __dbResults);
    this.EN_INVESTINCOME = JdbcWritableBridge.readBigDecimal(53, __dbResults);
    this.EN_INVESTSHARE = JdbcWritableBridge.readBigDecimal(54, __dbResults);
    this.C_FINISHFLAG = JdbcWritableBridge.readString(55, __dbResults);
    this.C_INTERESTFLAG = JdbcWritableBridge.readString(56, __dbResults);
    this.C_CONFIRMSTATUS = JdbcWritableBridge.readString(57, __dbResults);
    this.EN_OTHERDISCOUNT = JdbcWritableBridge.readBigDecimal(58, __dbResults);
    this.EN_ENDDISCOUNT = JdbcWritableBridge.readBigDecimal(59, __dbResults);
    this.VC_LIQUIDATEDATE = JdbcWritableBridge.readString(60, __dbResults);
    this.C_SENDFLAG = JdbcWritableBridge.readString(61, __dbResults);
    this.VC_BRANCHCODE = JdbcWritableBridge.readString(62, __dbResults);
    this.EN_OTHERNAV = JdbcWritableBridge.readBigDecimal(63, __dbResults);
    this.EN_OTHERCONFIRMSHARE = JdbcWritableBridge.readBigDecimal(64, __dbResults);
    this.EN_OTHERORIGINFARE = JdbcWritableBridge.readBigDecimal(65, __dbResults);
    this.C_FIXBUSINFLAG = JdbcWritableBridge.readString(66, __dbResults);
    this.C_CAPITALMODE = JdbcWritableBridge.readString(67, __dbResults);
    this.C_SUBCAPITALMODE = JdbcWritableBridge.readString(68, __dbResults);
    this.VC_ORIGINCONFIRMNO = JdbcWritableBridge.readString(69, __dbResults);
    this.C_BUSINTYPE = JdbcWritableBridge.readString(70, __dbResults);
    this.L_SECTIONSCHEMANO = JdbcWritableBridge.readBigDecimal(71, __dbResults);
    this.C_EXPTYPE = JdbcWritableBridge.readString(72, __dbResults);
    this.C_SHAREADJUSTFLAG = JdbcWritableBridge.readString(73, __dbResults);
    this.C_INCOMEFLAG = JdbcWritableBridge.readString(74, __dbResults);
    this.EN_ACHIEVEMENTPAY = JdbcWritableBridge.readBigDecimal(75, __dbResults);
    this.EN_BREACHFEE = JdbcWritableBridge.readBigDecimal(76, __dbResults);
    this.VC_COMEFROM = JdbcWritableBridge.readString(77, __dbResults);
    this.VC_INVESTORSYSTEMID = JdbcWritableBridge.readString(78, __dbResults);
    this.VC_VOUCHERNO = JdbcWritableBridge.readString(79, __dbResults);
    this.C_BANKNO = JdbcWritableBridge.readString(80, __dbResults);
    this.VC_BANKNAME = JdbcWritableBridge.readString(81, __dbResults);
    this.VC_NAMEINBANK = JdbcWritableBridge.readString(82, __dbResults);
    this.VC_BANKACCO = JdbcWritableBridge.readString(83, __dbResults);
    this.VC_CUSTNO = JdbcWritableBridge.readString(84, __dbResults);
    this.VC_CONFIRMSETTLEDATE = JdbcWritableBridge.readString(85, __dbResults);
    this.VC_REQUESTSETTLEDATE = JdbcWritableBridge.readString(86, __dbResults);
    this.VC_CONTRACTSERIALNO = JdbcWritableBridge.readString(87, __dbResults);
    this.C_PROFITCLASS = JdbcWritableBridge.readString(88, __dbResults);
    this.VC_COMBREQUESTNO = JdbcWritableBridge.readString(89, __dbResults);
    this.VC_COMBCODE = JdbcWritableBridge.readString(90, __dbResults);
    this.C_AUTOREQUEST = JdbcWritableBridge.readString(91, __dbResults);
    this.VC_EXPLAIN = JdbcWritableBridge.readString(92, __dbResults);
    this.C_INTERFACETYPE = JdbcWritableBridge.readString(93, __dbResults);
    this.EN_OTHERFEE1 = JdbcWritableBridge.readBigDecimal(94, __dbResults);
    this.EN_OTHERFEE2 = JdbcWritableBridge.readBigDecimal(95, __dbResults);
    this.C_MATCHFLAG = JdbcWritableBridge.readString(96, __dbResults);
    this.VC_BOOKID = JdbcWritableBridge.readString(97, __dbResults);
    this.EN_GRAMNUM = JdbcWritableBridge.readBigDecimal(98, __dbResults);
    this.C_FORCEREDEEMREASON = JdbcWritableBridge.readString(99, __dbResults);
    this.EN_TOTALFROZENSHARE = JdbcWritableBridge.readBigDecimal(100, __dbResults);
    this.EN_FUNDSHAREBALANCE = JdbcWritableBridge.readBigDecimal(101, __dbResults);
    this.EN_FROZENBALANCE = JdbcWritableBridge.readBigDecimal(102, __dbResults);
    this.VC_FUTURESUBSCRIBEDATE = JdbcWritableBridge.readString(103, __dbResults);
    this.VC_TRANSFERDATEFROMAGENCY = JdbcWritableBridge.readString(104, __dbResults);
    this.EN_TAXADVANAMOUNT = JdbcWritableBridge.readBigDecimal(105, __dbResults);
    this.VC_TAXADVANCODE = JdbcWritableBridge.readString(106, __dbResults);
    this.VC_OTHERSERIALNO = JdbcWritableBridge.readString(107, __dbResults);
    this.C_ATTENDQUITFLAG = JdbcWritableBridge.readString(108, __dbResults);
    this.VC_CUSTOMNAME_GS = JdbcWritableBridge.readString(109, __dbResults);
    this.C_IDENTITYTYPE_GS = JdbcWritableBridge.readString(110, __dbResults);
    this.VC_IDENTITYNO_GS = JdbcWritableBridge.readString(111, __dbResults);
    this.VC_NATIONALITY_GS = JdbcWritableBridge.readString(112, __dbResults);
    this.VC_CERTCODE_GS = JdbcWritableBridge.readString(113, __dbResults);
    this.VC_CERTDATE_GS = JdbcWritableBridge.readString(114, __dbResults);
    this.EN_ACCTAXPRETAKEOFF_GS = JdbcWritableBridge.readBigDecimal(115, __dbResults);
    this.INSERTTIME = JdbcWritableBridge.readString(116, __dbResults);
    this.UPDATETIME = JdbcWritableBridge.readString(117, __dbResults);
    this._20210422 = JdbcWritableBridge.readBigDecimal(118, __dbResults);
    this._SALES_ = JdbcWritableBridge.readString(119, __dbResults);
  }
  public void loadLargeObjects(LargeObjectLoader __loader)
      throws SQLException, IOException, InterruptedException {
  }
  public void loadLargeObjects0(LargeObjectLoader __loader)
      throws SQLException, IOException, InterruptedException {
  }
  public void write(PreparedStatement __dbStmt) throws SQLException {
    write(__dbStmt, 0);
  }

  public int write(PreparedStatement __dbStmt, int __off) throws SQLException {
    JdbcWritableBridge.writeString(C_CUSTTYPE, 1 + __off, 1, __dbStmt);
    JdbcWritableBridge.writeString(VC_FUNDACCO, 2 + __off, 12, __dbStmt);
    JdbcWritableBridge.writeString(VC_TRADEACCO, 3 + __off, 12, __dbStmt);
    JdbcWritableBridge.writeString(C_TRUST, 4 + __off, 1, __dbStmt);
    JdbcWritableBridge.writeString(VC_REQUESTDATE, 5 + __off, 12, __dbStmt);
    JdbcWritableBridge.writeString(VC_REQUESTNO, 6 + __off, 12, __dbStmt);
    JdbcWritableBridge.writeString(VC_CONFIRMNO, 7 + __off, 12, __dbStmt);
    JdbcWritableBridge.writeString(VC_CONFIRMDATE, 8 + __off, 12, __dbStmt);
    JdbcWritableBridge.writeString(VC_FUNDCODE, 9 + __off, 12, __dbStmt);
    JdbcWritableBridge.writeString(C_SHARETYPE, 10 + __off, 1, __dbStmt);
    JdbcWritableBridge.writeString(VC_NETNO, 11 + __off, 12, __dbStmt);
    JdbcWritableBridge.writeString(VC_CENTERNO, 12 + __off, 12, __dbStmt);
    JdbcWritableBridge.writeBigDecimal(EN_RATIO, 13 + __off, 2, __dbStmt);
    JdbcWritableBridge.writeBigDecimal(EN_NAV, 14 + __off, 2, __dbStmt);
    JdbcWritableBridge.writeBigDecimal(EN_PROFIT, 15 + __off, 2, __dbStmt);
    JdbcWritableBridge.writeString(C_BUSINFLAG, 16 + __off, 1, __dbStmt);
    JdbcWritableBridge.writeBigDecimal(EN_BALANCE, 17 + __off, 2, __dbStmt);
    JdbcWritableBridge.writeBigDecimal(EN_SHARE, 18 + __off, 2, __dbStmt);
    JdbcWritableBridge.writeBigDecimal(EN_CONFIRMBALA, 19 + __off, 2, __dbStmt);
    JdbcWritableBridge.writeString(C_MONEYTYPE, 20 + __off, 1, __dbStmt);
    JdbcWritableBridge.writeBigDecimal(EN_CONFIRMSHARE, 21 + __off, 2, __dbStmt);
    JdbcWritableBridge.writeBigDecimal(EN_FARE, 22 + __off, 2, __dbStmt);
    JdbcWritableBridge.writeBigDecimal(EN_DEALFARE, 23 + __off, 2, __dbStmt);
    JdbcWritableBridge.writeBigDecimal(EN_TAFARE, 24 + __off, 2, __dbStmt);
    JdbcWritableBridge.writeBigDecimal(EN_AFTERFARE, 25 + __off, 2, __dbStmt);
    JdbcWritableBridge.writeBigDecimal(EN_AGENCYFARE, 26 + __off, 2, __dbStmt);
    JdbcWritableBridge.writeBigDecimal(EN_STAMPTAX, 27 + __off, 2, __dbStmt);
    JdbcWritableBridge.writeString(C_CONFIRMFLAG, 28 + __off, 1, __dbStmt);
    JdbcWritableBridge.writeString(VC_ERRORCODE, 29 + __off, 12, __dbStmt);
    JdbcWritableBridge.writeString(VC_ERRORCAUSE, 30 + __off, 12, __dbStmt);
    JdbcWritableBridge.writeString(C_VOUCHERFLAG, 31 + __off, 1, __dbStmt);
    JdbcWritableBridge.writeBigDecimal(EN_INTEREST, 32 + __off, 2, __dbStmt);
    JdbcWritableBridge.writeBigDecimal(EN_INTERESTTAX, 33 + __off, 2, __dbStmt);
    JdbcWritableBridge.writeString(C_ORGANIGER, 34 + __off, 1, __dbStmt);
    JdbcWritableBridge.writeString(VC_OTHERACCO, 35 + __off, 12, __dbStmt);
    JdbcWritableBridge.writeString(VC_OTHERTRADEACCO, 36 + __off, 12, __dbStmt);
    JdbcWritableBridge.writeString(C_OTHERAGENCYNO, 37 + __off, 1, __dbStmt);
    JdbcWritableBridge.writeString(VC_OTHERNETNO, 38 + __off, 12, __dbStmt);
    JdbcWritableBridge.writeString(VC_OTHERFUNDCODE, 39 + __off, 12, __dbStmt);
    JdbcWritableBridge.writeString(C_OTHERSHARETYPE, 40 + __off, 1, __dbStmt);
    JdbcWritableBridge.writeBigDecimal(EN_UNFROZENBALA, 41 + __off, 2, __dbStmt);
    JdbcWritableBridge.writeBigDecimal(EN_RETURNFARE, 42 + __off, 2, __dbStmt);
    JdbcWritableBridge.writeBigDecimal(EN_ORIGINFARE, 43 + __off, 2, __dbStmt);
    JdbcWritableBridge.writeString(VC_BROKER, 44 + __off, 12, __dbStmt);
    JdbcWritableBridge.writeString(C_DIVIDENDMETHOD, 45 + __off, 1, __dbStmt);
    JdbcWritableBridge.writeString(C_FROZENCAUSE, 46 + __off, 1, __dbStmt);
    JdbcWritableBridge.writeString(VC_ORIGINNO, 47 + __off, 12, __dbStmt);
    JdbcWritableBridge.writeString(VC_CITYNO, 48 + __off, 12, __dbStmt);
    JdbcWritableBridge.writeString(VC_SELLER, 49 + __off, 12, __dbStmt);
    JdbcWritableBridge.writeString(VC_TACODE, 50 + __off, 12, __dbStmt);
    JdbcWritableBridge.writeBigDecimal(EN_DISCOUNT, 51 + __off, 2, __dbStmt);
    JdbcWritableBridge.writeBigDecimal(EN_INCOME, 52 + __off, 2, __dbStmt);
    JdbcWritableBridge.writeBigDecimal(EN_INVESTINCOME, 53 + __off, 2, __dbStmt);
    JdbcWritableBridge.writeBigDecimal(EN_INVESTSHARE, 54 + __off, 2, __dbStmt);
    JdbcWritableBridge.writeString(C_FINISHFLAG, 55 + __off, 1, __dbStmt);
    JdbcWritableBridge.writeString(C_INTERESTFLAG, 56 + __off, 1, __dbStmt);
    JdbcWritableBridge.writeString(C_CONFIRMSTATUS, 57 + __off, 1, __dbStmt);
    JdbcWritableBridge.writeBigDecimal(EN_OTHERDISCOUNT, 58 + __off, 2, __dbStmt);
    JdbcWritableBridge.writeBigDecimal(EN_ENDDISCOUNT, 59 + __off, 2, __dbStmt);
    JdbcWritableBridge.writeString(VC_LIQUIDATEDATE, 60 + __off, 12, __dbStmt);
    JdbcWritableBridge.writeString(C_SENDFLAG, 61 + __off, 1, __dbStmt);
    JdbcWritableBridge.writeString(VC_BRANCHCODE, 62 + __off, 12, __dbStmt);
    JdbcWritableBridge.writeBigDecimal(EN_OTHERNAV, 63 + __off, 2, __dbStmt);
    JdbcWritableBridge.writeBigDecimal(EN_OTHERCONFIRMSHARE, 64 + __off, 2, __dbStmt);
    JdbcWritableBridge.writeBigDecimal(EN_OTHERORIGINFARE, 65 + __off, 2, __dbStmt);
    JdbcWritableBridge.writeString(C_FIXBUSINFLAG, 66 + __off, 12, __dbStmt);
    JdbcWritableBridge.writeString(C_CAPITALMODE, 67 + __off, 12, __dbStmt);
    JdbcWritableBridge.writeString(C_SUBCAPITALMODE, 68 + __off, 1, __dbStmt);
    JdbcWritableBridge.writeString(VC_ORIGINCONFIRMNO, 69 + __off, 12, __dbStmt);
    JdbcWritableBridge.writeString(C_BUSINTYPE, 70 + __off, 1, __dbStmt);
    JdbcWritableBridge.writeBigDecimal(L_SECTIONSCHEMANO, 71 + __off, 2, __dbStmt);
    JdbcWritableBridge.writeString(C_EXPTYPE, 72 + __off, 1, __dbStmt);
    JdbcWritableBridge.writeString(C_SHAREADJUSTFLAG, 73 + __off, 1, __dbStmt);
    JdbcWritableBridge.writeString(C_INCOMEFLAG, 74 + __off, 1, __dbStmt);
    JdbcWritableBridge.writeBigDecimal(EN_ACHIEVEMENTPAY, 75 + __off, 2, __dbStmt);
    JdbcWritableBridge.writeBigDecimal(EN_BREACHFEE, 76 + __off, 2, __dbStmt);
    JdbcWritableBridge.writeString(VC_COMEFROM, 77 + __off, 12, __dbStmt);
    JdbcWritableBridge.writeString(VC_INVESTORSYSTEMID, 78 + __off, 12, __dbStmt);
    JdbcWritableBridge.writeString(VC_VOUCHERNO, 79 + __off, 12, __dbStmt);
    JdbcWritableBridge.writeString(C_BANKNO, 80 + __off, 1, __dbStmt);
    JdbcWritableBridge.writeString(VC_BANKNAME, 81 + __off, 12, __dbStmt);
    JdbcWritableBridge.writeString(VC_NAMEINBANK, 82 + __off, 12, __dbStmt);
    JdbcWritableBridge.writeString(VC_BANKACCO, 83 + __off, 12, __dbStmt);
    JdbcWritableBridge.writeString(VC_CUSTNO, 84 + __off, 12, __dbStmt);
    JdbcWritableBridge.writeString(VC_CONFIRMSETTLEDATE, 85 + __off, 12, __dbStmt);
    JdbcWritableBridge.writeString(VC_REQUESTSETTLEDATE, 86 + __off, 12, __dbStmt);
    JdbcWritableBridge.writeString(VC_CONTRACTSERIALNO, 87 + __off, 12, __dbStmt);
    JdbcWritableBridge.writeString(C_PROFITCLASS, 88 + __off, 1, __dbStmt);
    JdbcWritableBridge.writeString(VC_COMBREQUESTNO, 89 + __off, 12, __dbStmt);
    JdbcWritableBridge.writeString(VC_COMBCODE, 90 + __off, 12, __dbStmt);
    JdbcWritableBridge.writeString(C_AUTOREQUEST, 91 + __off, 1, __dbStmt);
    JdbcWritableBridge.writeString(VC_EXPLAIN, 92 + __off, 12, __dbStmt);
    JdbcWritableBridge.writeString(C_INTERFACETYPE, 93 + __off, 1, __dbStmt);
    JdbcWritableBridge.writeBigDecimal(EN_OTHERFEE1, 94 + __off, 2, __dbStmt);
    JdbcWritableBridge.writeBigDecimal(EN_OTHERFEE2, 95 + __off, 2, __dbStmt);
    JdbcWritableBridge.writeString(C_MATCHFLAG, 96 + __off, 1, __dbStmt);
    JdbcWritableBridge.writeString(VC_BOOKID, 97 + __off, 12, __dbStmt);
    JdbcWritableBridge.writeBigDecimal(EN_GRAMNUM, 98 + __off, 2, __dbStmt);
    JdbcWritableBridge.writeString(C_FORCEREDEEMREASON, 99 + __off, 1, __dbStmt);
    JdbcWritableBridge.writeBigDecimal(EN_TOTALFROZENSHARE, 100 + __off, 2, __dbStmt);
    JdbcWritableBridge.writeBigDecimal(EN_FUNDSHAREBALANCE, 101 + __off, 2, __dbStmt);
    JdbcWritableBridge.writeBigDecimal(EN_FROZENBALANCE, 102 + __off, 2, __dbStmt);
    JdbcWritableBridge.writeString(VC_FUTURESUBSCRIBEDATE, 103 + __off, 12, __dbStmt);
    JdbcWritableBridge.writeString(VC_TRANSFERDATEFROMAGENCY, 104 + __off, 12, __dbStmt);
    JdbcWritableBridge.writeBigDecimal(EN_TAXADVANAMOUNT, 105 + __off, 2, __dbStmt);
    JdbcWritableBridge.writeString(VC_TAXADVANCODE, 106 + __off, 12, __dbStmt);
    JdbcWritableBridge.writeString(VC_OTHERSERIALNO, 107 + __off, 12, __dbStmt);
    JdbcWritableBridge.writeString(C_ATTENDQUITFLAG, 108 + __off, 1, __dbStmt);
    JdbcWritableBridge.writeString(VC_CUSTOMNAME_GS, 109 + __off, 12, __dbStmt);
    JdbcWritableBridge.writeString(C_IDENTITYTYPE_GS, 110 + __off, 12, __dbStmt);
    JdbcWritableBridge.writeString(VC_IDENTITYNO_GS, 111 + __off, 12, __dbStmt);
    JdbcWritableBridge.writeString(VC_NATIONALITY_GS, 112 + __off, 12, __dbStmt);
    JdbcWritableBridge.writeString(VC_CERTCODE_GS, 113 + __off, 12, __dbStmt);
    JdbcWritableBridge.writeString(VC_CERTDATE_GS, 114 + __off, 12, __dbStmt);
    JdbcWritableBridge.writeBigDecimal(EN_ACCTAXPRETAKEOFF_GS, 115 + __off, 2, __dbStmt);
    JdbcWritableBridge.writeString(INSERTTIME, 116 + __off, 12, __dbStmt);
    JdbcWritableBridge.writeString(UPDATETIME, 117 + __off, 12, __dbStmt);
    JdbcWritableBridge.writeBigDecimal(_20210422, 118 + __off, 2, __dbStmt);
    JdbcWritableBridge.writeString(_SALES_, 119 + __off, 1, __dbStmt);
    return 119;
  }
  public void write0(PreparedStatement __dbStmt, int __off) throws SQLException {
    JdbcWritableBridge.writeString(C_CUSTTYPE, 1 + __off, 1, __dbStmt);
    JdbcWritableBridge.writeString(VC_FUNDACCO, 2 + __off, 12, __dbStmt);
    JdbcWritableBridge.writeString(VC_TRADEACCO, 3 + __off, 12, __dbStmt);
    JdbcWritableBridge.writeString(C_TRUST, 4 + __off, 1, __dbStmt);
    JdbcWritableBridge.writeString(VC_REQUESTDATE, 5 + __off, 12, __dbStmt);
    JdbcWritableBridge.writeString(VC_REQUESTNO, 6 + __off, 12, __dbStmt);
    JdbcWritableBridge.writeString(VC_CONFIRMNO, 7 + __off, 12, __dbStmt);
    JdbcWritableBridge.writeString(VC_CONFIRMDATE, 8 + __off, 12, __dbStmt);
    JdbcWritableBridge.writeString(VC_FUNDCODE, 9 + __off, 12, __dbStmt);
    JdbcWritableBridge.writeString(C_SHARETYPE, 10 + __off, 1, __dbStmt);
    JdbcWritableBridge.writeString(VC_NETNO, 11 + __off, 12, __dbStmt);
    JdbcWritableBridge.writeString(VC_CENTERNO, 12 + __off, 12, __dbStmt);
    JdbcWritableBridge.writeBigDecimal(EN_RATIO, 13 + __off, 2, __dbStmt);
    JdbcWritableBridge.writeBigDecimal(EN_NAV, 14 + __off, 2, __dbStmt);
    JdbcWritableBridge.writeBigDecimal(EN_PROFIT, 15 + __off, 2, __dbStmt);
    JdbcWritableBridge.writeString(C_BUSINFLAG, 16 + __off, 1, __dbStmt);
    JdbcWritableBridge.writeBigDecimal(EN_BALANCE, 17 + __off, 2, __dbStmt);
    JdbcWritableBridge.writeBigDecimal(EN_SHARE, 18 + __off, 2, __dbStmt);
    JdbcWritableBridge.writeBigDecimal(EN_CONFIRMBALA, 19 + __off, 2, __dbStmt);
    JdbcWritableBridge.writeString(C_MONEYTYPE, 20 + __off, 1, __dbStmt);
    JdbcWritableBridge.writeBigDecimal(EN_CONFIRMSHARE, 21 + __off, 2, __dbStmt);
    JdbcWritableBridge.writeBigDecimal(EN_FARE, 22 + __off, 2, __dbStmt);
    JdbcWritableBridge.writeBigDecimal(EN_DEALFARE, 23 + __off, 2, __dbStmt);
    JdbcWritableBridge.writeBigDecimal(EN_TAFARE, 24 + __off, 2, __dbStmt);
    JdbcWritableBridge.writeBigDecimal(EN_AFTERFARE, 25 + __off, 2, __dbStmt);
    JdbcWritableBridge.writeBigDecimal(EN_AGENCYFARE, 26 + __off, 2, __dbStmt);
    JdbcWritableBridge.writeBigDecimal(EN_STAMPTAX, 27 + __off, 2, __dbStmt);
    JdbcWritableBridge.writeString(C_CONFIRMFLAG, 28 + __off, 1, __dbStmt);
    JdbcWritableBridge.writeString(VC_ERRORCODE, 29 + __off, 12, __dbStmt);
    JdbcWritableBridge.writeString(VC_ERRORCAUSE, 30 + __off, 12, __dbStmt);
    JdbcWritableBridge.writeString(C_VOUCHERFLAG, 31 + __off, 1, __dbStmt);
    JdbcWritableBridge.writeBigDecimal(EN_INTEREST, 32 + __off, 2, __dbStmt);
    JdbcWritableBridge.writeBigDecimal(EN_INTERESTTAX, 33 + __off, 2, __dbStmt);
    JdbcWritableBridge.writeString(C_ORGANIGER, 34 + __off, 1, __dbStmt);
    JdbcWritableBridge.writeString(VC_OTHERACCO, 35 + __off, 12, __dbStmt);
    JdbcWritableBridge.writeString(VC_OTHERTRADEACCO, 36 + __off, 12, __dbStmt);
    JdbcWritableBridge.writeString(C_OTHERAGENCYNO, 37 + __off, 1, __dbStmt);
    JdbcWritableBridge.writeString(VC_OTHERNETNO, 38 + __off, 12, __dbStmt);
    JdbcWritableBridge.writeString(VC_OTHERFUNDCODE, 39 + __off, 12, __dbStmt);
    JdbcWritableBridge.writeString(C_OTHERSHARETYPE, 40 + __off, 1, __dbStmt);
    JdbcWritableBridge.writeBigDecimal(EN_UNFROZENBALA, 41 + __off, 2, __dbStmt);
    JdbcWritableBridge.writeBigDecimal(EN_RETURNFARE, 42 + __off, 2, __dbStmt);
    JdbcWritableBridge.writeBigDecimal(EN_ORIGINFARE, 43 + __off, 2, __dbStmt);
    JdbcWritableBridge.writeString(VC_BROKER, 44 + __off, 12, __dbStmt);
    JdbcWritableBridge.writeString(C_DIVIDENDMETHOD, 45 + __off, 1, __dbStmt);
    JdbcWritableBridge.writeString(C_FROZENCAUSE, 46 + __off, 1, __dbStmt);
    JdbcWritableBridge.writeString(VC_ORIGINNO, 47 + __off, 12, __dbStmt);
    JdbcWritableBridge.writeString(VC_CITYNO, 48 + __off, 12, __dbStmt);
    JdbcWritableBridge.writeString(VC_SELLER, 49 + __off, 12, __dbStmt);
    JdbcWritableBridge.writeString(VC_TACODE, 50 + __off, 12, __dbStmt);
    JdbcWritableBridge.writeBigDecimal(EN_DISCOUNT, 51 + __off, 2, __dbStmt);
    JdbcWritableBridge.writeBigDecimal(EN_INCOME, 52 + __off, 2, __dbStmt);
    JdbcWritableBridge.writeBigDecimal(EN_INVESTINCOME, 53 + __off, 2, __dbStmt);
    JdbcWritableBridge.writeBigDecimal(EN_INVESTSHARE, 54 + __off, 2, __dbStmt);
    JdbcWritableBridge.writeString(C_FINISHFLAG, 55 + __off, 1, __dbStmt);
    JdbcWritableBridge.writeString(C_INTERESTFLAG, 56 + __off, 1, __dbStmt);
    JdbcWritableBridge.writeString(C_CONFIRMSTATUS, 57 + __off, 1, __dbStmt);
    JdbcWritableBridge.writeBigDecimal(EN_OTHERDISCOUNT, 58 + __off, 2, __dbStmt);
    JdbcWritableBridge.writeBigDecimal(EN_ENDDISCOUNT, 59 + __off, 2, __dbStmt);
    JdbcWritableBridge.writeString(VC_LIQUIDATEDATE, 60 + __off, 12, __dbStmt);
    JdbcWritableBridge.writeString(C_SENDFLAG, 61 + __off, 1, __dbStmt);
    JdbcWritableBridge.writeString(VC_BRANCHCODE, 62 + __off, 12, __dbStmt);
    JdbcWritableBridge.writeBigDecimal(EN_OTHERNAV, 63 + __off, 2, __dbStmt);
    JdbcWritableBridge.writeBigDecimal(EN_OTHERCONFIRMSHARE, 64 + __off, 2, __dbStmt);
    JdbcWritableBridge.writeBigDecimal(EN_OTHERORIGINFARE, 65 + __off, 2, __dbStmt);
    JdbcWritableBridge.writeString(C_FIXBUSINFLAG, 66 + __off, 12, __dbStmt);
    JdbcWritableBridge.writeString(C_CAPITALMODE, 67 + __off, 12, __dbStmt);
    JdbcWritableBridge.writeString(C_SUBCAPITALMODE, 68 + __off, 1, __dbStmt);
    JdbcWritableBridge.writeString(VC_ORIGINCONFIRMNO, 69 + __off, 12, __dbStmt);
    JdbcWritableBridge.writeString(C_BUSINTYPE, 70 + __off, 1, __dbStmt);
    JdbcWritableBridge.writeBigDecimal(L_SECTIONSCHEMANO, 71 + __off, 2, __dbStmt);
    JdbcWritableBridge.writeString(C_EXPTYPE, 72 + __off, 1, __dbStmt);
    JdbcWritableBridge.writeString(C_SHAREADJUSTFLAG, 73 + __off, 1, __dbStmt);
    JdbcWritableBridge.writeString(C_INCOMEFLAG, 74 + __off, 1, __dbStmt);
    JdbcWritableBridge.writeBigDecimal(EN_ACHIEVEMENTPAY, 75 + __off, 2, __dbStmt);
    JdbcWritableBridge.writeBigDecimal(EN_BREACHFEE, 76 + __off, 2, __dbStmt);
    JdbcWritableBridge.writeString(VC_COMEFROM, 77 + __off, 12, __dbStmt);
    JdbcWritableBridge.writeString(VC_INVESTORSYSTEMID, 78 + __off, 12, __dbStmt);
    JdbcWritableBridge.writeString(VC_VOUCHERNO, 79 + __off, 12, __dbStmt);
    JdbcWritableBridge.writeString(C_BANKNO, 80 + __off, 1, __dbStmt);
    JdbcWritableBridge.writeString(VC_BANKNAME, 81 + __off, 12, __dbStmt);
    JdbcWritableBridge.writeString(VC_NAMEINBANK, 82 + __off, 12, __dbStmt);
    JdbcWritableBridge.writeString(VC_BANKACCO, 83 + __off, 12, __dbStmt);
    JdbcWritableBridge.writeString(VC_CUSTNO, 84 + __off, 12, __dbStmt);
    JdbcWritableBridge.writeString(VC_CONFIRMSETTLEDATE, 85 + __off, 12, __dbStmt);
    JdbcWritableBridge.writeString(VC_REQUESTSETTLEDATE, 86 + __off, 12, __dbStmt);
    JdbcWritableBridge.writeString(VC_CONTRACTSERIALNO, 87 + __off, 12, __dbStmt);
    JdbcWritableBridge.writeString(C_PROFITCLASS, 88 + __off, 1, __dbStmt);
    JdbcWritableBridge.writeString(VC_COMBREQUESTNO, 89 + __off, 12, __dbStmt);
    JdbcWritableBridge.writeString(VC_COMBCODE, 90 + __off, 12, __dbStmt);
    JdbcWritableBridge.writeString(C_AUTOREQUEST, 91 + __off, 1, __dbStmt);
    JdbcWritableBridge.writeString(VC_EXPLAIN, 92 + __off, 12, __dbStmt);
    JdbcWritableBridge.writeString(C_INTERFACETYPE, 93 + __off, 1, __dbStmt);
    JdbcWritableBridge.writeBigDecimal(EN_OTHERFEE1, 94 + __off, 2, __dbStmt);
    JdbcWritableBridge.writeBigDecimal(EN_OTHERFEE2, 95 + __off, 2, __dbStmt);
    JdbcWritableBridge.writeString(C_MATCHFLAG, 96 + __off, 1, __dbStmt);
    JdbcWritableBridge.writeString(VC_BOOKID, 97 + __off, 12, __dbStmt);
    JdbcWritableBridge.writeBigDecimal(EN_GRAMNUM, 98 + __off, 2, __dbStmt);
    JdbcWritableBridge.writeString(C_FORCEREDEEMREASON, 99 + __off, 1, __dbStmt);
    JdbcWritableBridge.writeBigDecimal(EN_TOTALFROZENSHARE, 100 + __off, 2, __dbStmt);
    JdbcWritableBridge.writeBigDecimal(EN_FUNDSHAREBALANCE, 101 + __off, 2, __dbStmt);
    JdbcWritableBridge.writeBigDecimal(EN_FROZENBALANCE, 102 + __off, 2, __dbStmt);
    JdbcWritableBridge.writeString(VC_FUTURESUBSCRIBEDATE, 103 + __off, 12, __dbStmt);
    JdbcWritableBridge.writeString(VC_TRANSFERDATEFROMAGENCY, 104 + __off, 12, __dbStmt);
    JdbcWritableBridge.writeBigDecimal(EN_TAXADVANAMOUNT, 105 + __off, 2, __dbStmt);
    JdbcWritableBridge.writeString(VC_TAXADVANCODE, 106 + __off, 12, __dbStmt);
    JdbcWritableBridge.writeString(VC_OTHERSERIALNO, 107 + __off, 12, __dbStmt);
    JdbcWritableBridge.writeString(C_ATTENDQUITFLAG, 108 + __off, 1, __dbStmt);
    JdbcWritableBridge.writeString(VC_CUSTOMNAME_GS, 109 + __off, 12, __dbStmt);
    JdbcWritableBridge.writeString(C_IDENTITYTYPE_GS, 110 + __off, 12, __dbStmt);
    JdbcWritableBridge.writeString(VC_IDENTITYNO_GS, 111 + __off, 12, __dbStmt);
    JdbcWritableBridge.writeString(VC_NATIONALITY_GS, 112 + __off, 12, __dbStmt);
    JdbcWritableBridge.writeString(VC_CERTCODE_GS, 113 + __off, 12, __dbStmt);
    JdbcWritableBridge.writeString(VC_CERTDATE_GS, 114 + __off, 12, __dbStmt);
    JdbcWritableBridge.writeBigDecimal(EN_ACCTAXPRETAKEOFF_GS, 115 + __off, 2, __dbStmt);
    JdbcWritableBridge.writeString(INSERTTIME, 116 + __off, 12, __dbStmt);
    JdbcWritableBridge.writeString(UPDATETIME, 117 + __off, 12, __dbStmt);
    JdbcWritableBridge.writeBigDecimal(_20210422, 118 + __off, 2, __dbStmt);
    JdbcWritableBridge.writeString(_SALES_, 119 + __off, 1, __dbStmt);
  }
  public void readFields(DataInput __dataIn) throws IOException {
this.readFields0(__dataIn);  }
  public void readFields0(DataInput __dataIn) throws IOException {
    if (__dataIn.readBoolean()) { 
        this.C_CUSTTYPE = null;
    } else {
    this.C_CUSTTYPE = Text.readString(__dataIn);
    }
    if (__dataIn.readBoolean()) { 
        this.VC_FUNDACCO = null;
    } else {
    this.VC_FUNDACCO = Text.readString(__dataIn);
    }
    if (__dataIn.readBoolean()) { 
        this.VC_TRADEACCO = null;
    } else {
    this.VC_TRADEACCO = Text.readString(__dataIn);
    }
    if (__dataIn.readBoolean()) { 
        this.C_TRUST = null;
    } else {
    this.C_TRUST = Text.readString(__dataIn);
    }
    if (__dataIn.readBoolean()) { 
        this.VC_REQUESTDATE = null;
    } else {
    this.VC_REQUESTDATE = Text.readString(__dataIn);
    }
    if (__dataIn.readBoolean()) { 
        this.VC_REQUESTNO = null;
    } else {
    this.VC_REQUESTNO = Text.readString(__dataIn);
    }
    if (__dataIn.readBoolean()) { 
        this.VC_CONFIRMNO = null;
    } else {
    this.VC_CONFIRMNO = Text.readString(__dataIn);
    }
    if (__dataIn.readBoolean()) { 
        this.VC_CONFIRMDATE = null;
    } else {
    this.VC_CONFIRMDATE = Text.readString(__dataIn);
    }
    if (__dataIn.readBoolean()) { 
        this.VC_FUNDCODE = null;
    } else {
    this.VC_FUNDCODE = Text.readString(__dataIn);
    }
    if (__dataIn.readBoolean()) { 
        this.C_SHARETYPE = null;
    } else {
    this.C_SHARETYPE = Text.readString(__dataIn);
    }
    if (__dataIn.readBoolean()) { 
        this.VC_NETNO = null;
    } else {
    this.VC_NETNO = Text.readString(__dataIn);
    }
    if (__dataIn.readBoolean()) { 
        this.VC_CENTERNO = null;
    } else {
    this.VC_CENTERNO = Text.readString(__dataIn);
    }
    if (__dataIn.readBoolean()) { 
        this.EN_RATIO = null;
    } else {
    this.EN_RATIO = com.cloudera.sqoop.lib.BigDecimalSerializer.readFields(__dataIn);
    }
    if (__dataIn.readBoolean()) { 
        this.EN_NAV = null;
    } else {
    this.EN_NAV = com.cloudera.sqoop.lib.BigDecimalSerializer.readFields(__dataIn);
    }
    if (__dataIn.readBoolean()) { 
        this.EN_PROFIT = null;
    } else {
    this.EN_PROFIT = com.cloudera.sqoop.lib.BigDecimalSerializer.readFields(__dataIn);
    }
    if (__dataIn.readBoolean()) { 
        this.C_BUSINFLAG = null;
    } else {
    this.C_BUSINFLAG = Text.readString(__dataIn);
    }
    if (__dataIn.readBoolean()) { 
        this.EN_BALANCE = null;
    } else {
    this.EN_BALANCE = com.cloudera.sqoop.lib.BigDecimalSerializer.readFields(__dataIn);
    }
    if (__dataIn.readBoolean()) { 
        this.EN_SHARE = null;
    } else {
    this.EN_SHARE = com.cloudera.sqoop.lib.BigDecimalSerializer.readFields(__dataIn);
    }
    if (__dataIn.readBoolean()) { 
        this.EN_CONFIRMBALA = null;
    } else {
    this.EN_CONFIRMBALA = com.cloudera.sqoop.lib.BigDecimalSerializer.readFields(__dataIn);
    }
    if (__dataIn.readBoolean()) { 
        this.C_MONEYTYPE = null;
    } else {
    this.C_MONEYTYPE = Text.readString(__dataIn);
    }
    if (__dataIn.readBoolean()) { 
        this.EN_CONFIRMSHARE = null;
    } else {
    this.EN_CONFIRMSHARE = com.cloudera.sqoop.lib.BigDecimalSerializer.readFields(__dataIn);
    }
    if (__dataIn.readBoolean()) { 
        this.EN_FARE = null;
    } else {
    this.EN_FARE = com.cloudera.sqoop.lib.BigDecimalSerializer.readFields(__dataIn);
    }
    if (__dataIn.readBoolean()) { 
        this.EN_DEALFARE = null;
    } else {
    this.EN_DEALFARE = com.cloudera.sqoop.lib.BigDecimalSerializer.readFields(__dataIn);
    }
    if (__dataIn.readBoolean()) { 
        this.EN_TAFARE = null;
    } else {
    this.EN_TAFARE = com.cloudera.sqoop.lib.BigDecimalSerializer.readFields(__dataIn);
    }
    if (__dataIn.readBoolean()) { 
        this.EN_AFTERFARE = null;
    } else {
    this.EN_AFTERFARE = com.cloudera.sqoop.lib.BigDecimalSerializer.readFields(__dataIn);
    }
    if (__dataIn.readBoolean()) { 
        this.EN_AGENCYFARE = null;
    } else {
    this.EN_AGENCYFARE = com.cloudera.sqoop.lib.BigDecimalSerializer.readFields(__dataIn);
    }
    if (__dataIn.readBoolean()) { 
        this.EN_STAMPTAX = null;
    } else {
    this.EN_STAMPTAX = com.cloudera.sqoop.lib.BigDecimalSerializer.readFields(__dataIn);
    }
    if (__dataIn.readBoolean()) { 
        this.C_CONFIRMFLAG = null;
    } else {
    this.C_CONFIRMFLAG = Text.readString(__dataIn);
    }
    if (__dataIn.readBoolean()) { 
        this.VC_ERRORCODE = null;
    } else {
    this.VC_ERRORCODE = Text.readString(__dataIn);
    }
    if (__dataIn.readBoolean()) { 
        this.VC_ERRORCAUSE = null;
    } else {
    this.VC_ERRORCAUSE = Text.readString(__dataIn);
    }
    if (__dataIn.readBoolean()) { 
        this.C_VOUCHERFLAG = null;
    } else {
    this.C_VOUCHERFLAG = Text.readString(__dataIn);
    }
    if (__dataIn.readBoolean()) { 
        this.EN_INTEREST = null;
    } else {
    this.EN_INTEREST = com.cloudera.sqoop.lib.BigDecimalSerializer.readFields(__dataIn);
    }
    if (__dataIn.readBoolean()) { 
        this.EN_INTERESTTAX = null;
    } else {
    this.EN_INTERESTTAX = com.cloudera.sqoop.lib.BigDecimalSerializer.readFields(__dataIn);
    }
    if (__dataIn.readBoolean()) { 
        this.C_ORGANIGER = null;
    } else {
    this.C_ORGANIGER = Text.readString(__dataIn);
    }
    if (__dataIn.readBoolean()) { 
        this.VC_OTHERACCO = null;
    } else {
    this.VC_OTHERACCO = Text.readString(__dataIn);
    }
    if (__dataIn.readBoolean()) { 
        this.VC_OTHERTRADEACCO = null;
    } else {
    this.VC_OTHERTRADEACCO = Text.readString(__dataIn);
    }
    if (__dataIn.readBoolean()) { 
        this.C_OTHERAGENCYNO = null;
    } else {
    this.C_OTHERAGENCYNO = Text.readString(__dataIn);
    }
    if (__dataIn.readBoolean()) { 
        this.VC_OTHERNETNO = null;
    } else {
    this.VC_OTHERNETNO = Text.readString(__dataIn);
    }
    if (__dataIn.readBoolean()) { 
        this.VC_OTHERFUNDCODE = null;
    } else {
    this.VC_OTHERFUNDCODE = Text.readString(__dataIn);
    }
    if (__dataIn.readBoolean()) { 
        this.C_OTHERSHARETYPE = null;
    } else {
    this.C_OTHERSHARETYPE = Text.readString(__dataIn);
    }
    if (__dataIn.readBoolean()) { 
        this.EN_UNFROZENBALA = null;
    } else {
    this.EN_UNFROZENBALA = com.cloudera.sqoop.lib.BigDecimalSerializer.readFields(__dataIn);
    }
    if (__dataIn.readBoolean()) { 
        this.EN_RETURNFARE = null;
    } else {
    this.EN_RETURNFARE = com.cloudera.sqoop.lib.BigDecimalSerializer.readFields(__dataIn);
    }
    if (__dataIn.readBoolean()) { 
        this.EN_ORIGINFARE = null;
    } else {
    this.EN_ORIGINFARE = com.cloudera.sqoop.lib.BigDecimalSerializer.readFields(__dataIn);
    }
    if (__dataIn.readBoolean()) { 
        this.VC_BROKER = null;
    } else {
    this.VC_BROKER = Text.readString(__dataIn);
    }
    if (__dataIn.readBoolean()) { 
        this.C_DIVIDENDMETHOD = null;
    } else {
    this.C_DIVIDENDMETHOD = Text.readString(__dataIn);
    }
    if (__dataIn.readBoolean()) { 
        this.C_FROZENCAUSE = null;
    } else {
    this.C_FROZENCAUSE = Text.readString(__dataIn);
    }
    if (__dataIn.readBoolean()) { 
        this.VC_ORIGINNO = null;
    } else {
    this.VC_ORIGINNO = Text.readString(__dataIn);
    }
    if (__dataIn.readBoolean()) { 
        this.VC_CITYNO = null;
    } else {
    this.VC_CITYNO = Text.readString(__dataIn);
    }
    if (__dataIn.readBoolean()) { 
        this.VC_SELLER = null;
    } else {
    this.VC_SELLER = Text.readString(__dataIn);
    }
    if (__dataIn.readBoolean()) { 
        this.VC_TACODE = null;
    } else {
    this.VC_TACODE = Text.readString(__dataIn);
    }
    if (__dataIn.readBoolean()) { 
        this.EN_DISCOUNT = null;
    } else {
    this.EN_DISCOUNT = com.cloudera.sqoop.lib.BigDecimalSerializer.readFields(__dataIn);
    }
    if (__dataIn.readBoolean()) { 
        this.EN_INCOME = null;
    } else {
    this.EN_INCOME = com.cloudera.sqoop.lib.BigDecimalSerializer.readFields(__dataIn);
    }
    if (__dataIn.readBoolean()) { 
        this.EN_INVESTINCOME = null;
    } else {
    this.EN_INVESTINCOME = com.cloudera.sqoop.lib.BigDecimalSerializer.readFields(__dataIn);
    }
    if (__dataIn.readBoolean()) { 
        this.EN_INVESTSHARE = null;
    } else {
    this.EN_INVESTSHARE = com.cloudera.sqoop.lib.BigDecimalSerializer.readFields(__dataIn);
    }
    if (__dataIn.readBoolean()) { 
        this.C_FINISHFLAG = null;
    } else {
    this.C_FINISHFLAG = Text.readString(__dataIn);
    }
    if (__dataIn.readBoolean()) { 
        this.C_INTERESTFLAG = null;
    } else {
    this.C_INTERESTFLAG = Text.readString(__dataIn);
    }
    if (__dataIn.readBoolean()) { 
        this.C_CONFIRMSTATUS = null;
    } else {
    this.C_CONFIRMSTATUS = Text.readString(__dataIn);
    }
    if (__dataIn.readBoolean()) { 
        this.EN_OTHERDISCOUNT = null;
    } else {
    this.EN_OTHERDISCOUNT = com.cloudera.sqoop.lib.BigDecimalSerializer.readFields(__dataIn);
    }
    if (__dataIn.readBoolean()) { 
        this.EN_ENDDISCOUNT = null;
    } else {
    this.EN_ENDDISCOUNT = com.cloudera.sqoop.lib.BigDecimalSerializer.readFields(__dataIn);
    }
    if (__dataIn.readBoolean()) { 
        this.VC_LIQUIDATEDATE = null;
    } else {
    this.VC_LIQUIDATEDATE = Text.readString(__dataIn);
    }
    if (__dataIn.readBoolean()) { 
        this.C_SENDFLAG = null;
    } else {
    this.C_SENDFLAG = Text.readString(__dataIn);
    }
    if (__dataIn.readBoolean()) { 
        this.VC_BRANCHCODE = null;
    } else {
    this.VC_BRANCHCODE = Text.readString(__dataIn);
    }
    if (__dataIn.readBoolean()) { 
        this.EN_OTHERNAV = null;
    } else {
    this.EN_OTHERNAV = com.cloudera.sqoop.lib.BigDecimalSerializer.readFields(__dataIn);
    }
    if (__dataIn.readBoolean()) { 
        this.EN_OTHERCONFIRMSHARE = null;
    } else {
    this.EN_OTHERCONFIRMSHARE = com.cloudera.sqoop.lib.BigDecimalSerializer.readFields(__dataIn);
    }
    if (__dataIn.readBoolean()) { 
        this.EN_OTHERORIGINFARE = null;
    } else {
    this.EN_OTHERORIGINFARE = com.cloudera.sqoop.lib.BigDecimalSerializer.readFields(__dataIn);
    }
    if (__dataIn.readBoolean()) { 
        this.C_FIXBUSINFLAG = null;
    } else {
    this.C_FIXBUSINFLAG = Text.readString(__dataIn);
    }
    if (__dataIn.readBoolean()) { 
        this.C_CAPITALMODE = null;
    } else {
    this.C_CAPITALMODE = Text.readString(__dataIn);
    }
    if (__dataIn.readBoolean()) { 
        this.C_SUBCAPITALMODE = null;
    } else {
    this.C_SUBCAPITALMODE = Text.readString(__dataIn);
    }
    if (__dataIn.readBoolean()) { 
        this.VC_ORIGINCONFIRMNO = null;
    } else {
    this.VC_ORIGINCONFIRMNO = Text.readString(__dataIn);
    }
    if (__dataIn.readBoolean()) { 
        this.C_BUSINTYPE = null;
    } else {
    this.C_BUSINTYPE = Text.readString(__dataIn);
    }
    if (__dataIn.readBoolean()) { 
        this.L_SECTIONSCHEMANO = null;
    } else {
    this.L_SECTIONSCHEMANO = com.cloudera.sqoop.lib.BigDecimalSerializer.readFields(__dataIn);
    }
    if (__dataIn.readBoolean()) { 
        this.C_EXPTYPE = null;
    } else {
    this.C_EXPTYPE = Text.readString(__dataIn);
    }
    if (__dataIn.readBoolean()) { 
        this.C_SHAREADJUSTFLAG = null;
    } else {
    this.C_SHAREADJUSTFLAG = Text.readString(__dataIn);
    }
    if (__dataIn.readBoolean()) { 
        this.C_INCOMEFLAG = null;
    } else {
    this.C_INCOMEFLAG = Text.readString(__dataIn);
    }
    if (__dataIn.readBoolean()) { 
        this.EN_ACHIEVEMENTPAY = null;
    } else {
    this.EN_ACHIEVEMENTPAY = com.cloudera.sqoop.lib.BigDecimalSerializer.readFields(__dataIn);
    }
    if (__dataIn.readBoolean()) { 
        this.EN_BREACHFEE = null;
    } else {
    this.EN_BREACHFEE = com.cloudera.sqoop.lib.BigDecimalSerializer.readFields(__dataIn);
    }
    if (__dataIn.readBoolean()) { 
        this.VC_COMEFROM = null;
    } else {
    this.VC_COMEFROM = Text.readString(__dataIn);
    }
    if (__dataIn.readBoolean()) { 
        this.VC_INVESTORSYSTEMID = null;
    } else {
    this.VC_INVESTORSYSTEMID = Text.readString(__dataIn);
    }
    if (__dataIn.readBoolean()) { 
        this.VC_VOUCHERNO = null;
    } else {
    this.VC_VOUCHERNO = Text.readString(__dataIn);
    }
    if (__dataIn.readBoolean()) { 
        this.C_BANKNO = null;
    } else {
    this.C_BANKNO = Text.readString(__dataIn);
    }
    if (__dataIn.readBoolean()) { 
        this.VC_BANKNAME = null;
    } else {
    this.VC_BANKNAME = Text.readString(__dataIn);
    }
    if (__dataIn.readBoolean()) { 
        this.VC_NAMEINBANK = null;
    } else {
    this.VC_NAMEINBANK = Text.readString(__dataIn);
    }
    if (__dataIn.readBoolean()) { 
        this.VC_BANKACCO = null;
    } else {
    this.VC_BANKACCO = Text.readString(__dataIn);
    }
    if (__dataIn.readBoolean()) { 
        this.VC_CUSTNO = null;
    } else {
    this.VC_CUSTNO = Text.readString(__dataIn);
    }
    if (__dataIn.readBoolean()) { 
        this.VC_CONFIRMSETTLEDATE = null;
    } else {
    this.VC_CONFIRMSETTLEDATE = Text.readString(__dataIn);
    }
    if (__dataIn.readBoolean()) { 
        this.VC_REQUESTSETTLEDATE = null;
    } else {
    this.VC_REQUESTSETTLEDATE = Text.readString(__dataIn);
    }
    if (__dataIn.readBoolean()) { 
        this.VC_CONTRACTSERIALNO = null;
    } else {
    this.VC_CONTRACTSERIALNO = Text.readString(__dataIn);
    }
    if (__dataIn.readBoolean()) { 
        this.C_PROFITCLASS = null;
    } else {
    this.C_PROFITCLASS = Text.readString(__dataIn);
    }
    if (__dataIn.readBoolean()) { 
        this.VC_COMBREQUESTNO = null;
    } else {
    this.VC_COMBREQUESTNO = Text.readString(__dataIn);
    }
    if (__dataIn.readBoolean()) { 
        this.VC_COMBCODE = null;
    } else {
    this.VC_COMBCODE = Text.readString(__dataIn);
    }
    if (__dataIn.readBoolean()) { 
        this.C_AUTOREQUEST = null;
    } else {
    this.C_AUTOREQUEST = Text.readString(__dataIn);
    }
    if (__dataIn.readBoolean()) { 
        this.VC_EXPLAIN = null;
    } else {
    this.VC_EXPLAIN = Text.readString(__dataIn);
    }
    if (__dataIn.readBoolean()) { 
        this.C_INTERFACETYPE = null;
    } else {
    this.C_INTERFACETYPE = Text.readString(__dataIn);
    }
    if (__dataIn.readBoolean()) { 
        this.EN_OTHERFEE1 = null;
    } else {
    this.EN_OTHERFEE1 = com.cloudera.sqoop.lib.BigDecimalSerializer.readFields(__dataIn);
    }
    if (__dataIn.readBoolean()) { 
        this.EN_OTHERFEE2 = null;
    } else {
    this.EN_OTHERFEE2 = com.cloudera.sqoop.lib.BigDecimalSerializer.readFields(__dataIn);
    }
    if (__dataIn.readBoolean()) { 
        this.C_MATCHFLAG = null;
    } else {
    this.C_MATCHFLAG = Text.readString(__dataIn);
    }
    if (__dataIn.readBoolean()) { 
        this.VC_BOOKID = null;
    } else {
    this.VC_BOOKID = Text.readString(__dataIn);
    }
    if (__dataIn.readBoolean()) { 
        this.EN_GRAMNUM = null;
    } else {
    this.EN_GRAMNUM = com.cloudera.sqoop.lib.BigDecimalSerializer.readFields(__dataIn);
    }
    if (__dataIn.readBoolean()) { 
        this.C_FORCEREDEEMREASON = null;
    } else {
    this.C_FORCEREDEEMREASON = Text.readString(__dataIn);
    }
    if (__dataIn.readBoolean()) { 
        this.EN_TOTALFROZENSHARE = null;
    } else {
    this.EN_TOTALFROZENSHARE = com.cloudera.sqoop.lib.BigDecimalSerializer.readFields(__dataIn);
    }
    if (__dataIn.readBoolean()) { 
        this.EN_FUNDSHAREBALANCE = null;
    } else {
    this.EN_FUNDSHAREBALANCE = com.cloudera.sqoop.lib.BigDecimalSerializer.readFields(__dataIn);
    }
    if (__dataIn.readBoolean()) { 
        this.EN_FROZENBALANCE = null;
    } else {
    this.EN_FROZENBALANCE = com.cloudera.sqoop.lib.BigDecimalSerializer.readFields(__dataIn);
    }
    if (__dataIn.readBoolean()) { 
        this.VC_FUTURESUBSCRIBEDATE = null;
    } else {
    this.VC_FUTURESUBSCRIBEDATE = Text.readString(__dataIn);
    }
    if (__dataIn.readBoolean()) { 
        this.VC_TRANSFERDATEFROMAGENCY = null;
    } else {
    this.VC_TRANSFERDATEFROMAGENCY = Text.readString(__dataIn);
    }
    if (__dataIn.readBoolean()) { 
        this.EN_TAXADVANAMOUNT = null;
    } else {
    this.EN_TAXADVANAMOUNT = com.cloudera.sqoop.lib.BigDecimalSerializer.readFields(__dataIn);
    }
    if (__dataIn.readBoolean()) { 
        this.VC_TAXADVANCODE = null;
    } else {
    this.VC_TAXADVANCODE = Text.readString(__dataIn);
    }
    if (__dataIn.readBoolean()) { 
        this.VC_OTHERSERIALNO = null;
    } else {
    this.VC_OTHERSERIALNO = Text.readString(__dataIn);
    }
    if (__dataIn.readBoolean()) { 
        this.C_ATTENDQUITFLAG = null;
    } else {
    this.C_ATTENDQUITFLAG = Text.readString(__dataIn);
    }
    if (__dataIn.readBoolean()) { 
        this.VC_CUSTOMNAME_GS = null;
    } else {
    this.VC_CUSTOMNAME_GS = Text.readString(__dataIn);
    }
    if (__dataIn.readBoolean()) { 
        this.C_IDENTITYTYPE_GS = null;
    } else {
    this.C_IDENTITYTYPE_GS = Text.readString(__dataIn);
    }
    if (__dataIn.readBoolean()) { 
        this.VC_IDENTITYNO_GS = null;
    } else {
    this.VC_IDENTITYNO_GS = Text.readString(__dataIn);
    }
    if (__dataIn.readBoolean()) { 
        this.VC_NATIONALITY_GS = null;
    } else {
    this.VC_NATIONALITY_GS = Text.readString(__dataIn);
    }
    if (__dataIn.readBoolean()) { 
        this.VC_CERTCODE_GS = null;
    } else {
    this.VC_CERTCODE_GS = Text.readString(__dataIn);
    }
    if (__dataIn.readBoolean()) { 
        this.VC_CERTDATE_GS = null;
    } else {
    this.VC_CERTDATE_GS = Text.readString(__dataIn);
    }
    if (__dataIn.readBoolean()) { 
        this.EN_ACCTAXPRETAKEOFF_GS = null;
    } else {
    this.EN_ACCTAXPRETAKEOFF_GS = com.cloudera.sqoop.lib.BigDecimalSerializer.readFields(__dataIn);
    }
    if (__dataIn.readBoolean()) { 
        this.INSERTTIME = null;
    } else {
    this.INSERTTIME = Text.readString(__dataIn);
    }
    if (__dataIn.readBoolean()) { 
        this.UPDATETIME = null;
    } else {
    this.UPDATETIME = Text.readString(__dataIn);
    }
    if (__dataIn.readBoolean()) { 
        this._20210422 = null;
    } else {
    this._20210422 = com.cloudera.sqoop.lib.BigDecimalSerializer.readFields(__dataIn);
    }
    if (__dataIn.readBoolean()) { 
        this._SALES_ = null;
    } else {
    this._SALES_ = Text.readString(__dataIn);
    }
  }
  public void write(DataOutput __dataOut) throws IOException {
    if (null == this.C_CUSTTYPE) { 
        __dataOut.writeBoolean(true);
    } else {
        __dataOut.writeBoolean(false);
    Text.writeString(__dataOut, C_CUSTTYPE);
    }
    if (null == this.VC_FUNDACCO) { 
        __dataOut.writeBoolean(true);
    } else {
        __dataOut.writeBoolean(false);
    Text.writeString(__dataOut, VC_FUNDACCO);
    }
    if (null == this.VC_TRADEACCO) { 
        __dataOut.writeBoolean(true);
    } else {
        __dataOut.writeBoolean(false);
    Text.writeString(__dataOut, VC_TRADEACCO);
    }
    if (null == this.C_TRUST) { 
        __dataOut.writeBoolean(true);
    } else {
        __dataOut.writeBoolean(false);
    Text.writeString(__dataOut, C_TRUST);
    }
    if (null == this.VC_REQUESTDATE) { 
        __dataOut.writeBoolean(true);
    } else {
        __dataOut.writeBoolean(false);
    Text.writeString(__dataOut, VC_REQUESTDATE);
    }
    if (null == this.VC_REQUESTNO) { 
        __dataOut.writeBoolean(true);
    } else {
        __dataOut.writeBoolean(false);
    Text.writeString(__dataOut, VC_REQUESTNO);
    }
    if (null == this.VC_CONFIRMNO) { 
        __dataOut.writeBoolean(true);
    } else {
        __dataOut.writeBoolean(false);
    Text.writeString(__dataOut, VC_CONFIRMNO);
    }
    if (null == this.VC_CONFIRMDATE) { 
        __dataOut.writeBoolean(true);
    } else {
        __dataOut.writeBoolean(false);
    Text.writeString(__dataOut, VC_CONFIRMDATE);
    }
    if (null == this.VC_FUNDCODE) { 
        __dataOut.writeBoolean(true);
    } else {
        __dataOut.writeBoolean(false);
    Text.writeString(__dataOut, VC_FUNDCODE);
    }
    if (null == this.C_SHARETYPE) { 
        __dataOut.writeBoolean(true);
    } else {
        __dataOut.writeBoolean(false);
    Text.writeString(__dataOut, C_SHARETYPE);
    }
    if (null == this.VC_NETNO) { 
        __dataOut.writeBoolean(true);
    } else {
        __dataOut.writeBoolean(false);
    Text.writeString(__dataOut, VC_NETNO);
    }
    if (null == this.VC_CENTERNO) { 
        __dataOut.writeBoolean(true);
    } else {
        __dataOut.writeBoolean(false);
    Text.writeString(__dataOut, VC_CENTERNO);
    }
    if (null == this.EN_RATIO) { 
        __dataOut.writeBoolean(true);
    } else {
        __dataOut.writeBoolean(false);
    com.cloudera.sqoop.lib.BigDecimalSerializer.write(this.EN_RATIO, __dataOut);
    }
    if (null == this.EN_NAV) { 
        __dataOut.writeBoolean(true);
    } else {
        __dataOut.writeBoolean(false);
    com.cloudera.sqoop.lib.BigDecimalSerializer.write(this.EN_NAV, __dataOut);
    }
    if (null == this.EN_PROFIT) { 
        __dataOut.writeBoolean(true);
    } else {
        __dataOut.writeBoolean(false);
    com.cloudera.sqoop.lib.BigDecimalSerializer.write(this.EN_PROFIT, __dataOut);
    }
    if (null == this.C_BUSINFLAG) { 
        __dataOut.writeBoolean(true);
    } else {
        __dataOut.writeBoolean(false);
    Text.writeString(__dataOut, C_BUSINFLAG);
    }
    if (null == this.EN_BALANCE) { 
        __dataOut.writeBoolean(true);
    } else {
        __dataOut.writeBoolean(false);
    com.cloudera.sqoop.lib.BigDecimalSerializer.write(this.EN_BALANCE, __dataOut);
    }
    if (null == this.EN_SHARE) { 
        __dataOut.writeBoolean(true);
    } else {
        __dataOut.writeBoolean(false);
    com.cloudera.sqoop.lib.BigDecimalSerializer.write(this.EN_SHARE, __dataOut);
    }
    if (null == this.EN_CONFIRMBALA) { 
        __dataOut.writeBoolean(true);
    } else {
        __dataOut.writeBoolean(false);
    com.cloudera.sqoop.lib.BigDecimalSerializer.write(this.EN_CONFIRMBALA, __dataOut);
    }
    if (null == this.C_MONEYTYPE) { 
        __dataOut.writeBoolean(true);
    } else {
        __dataOut.writeBoolean(false);
    Text.writeString(__dataOut, C_MONEYTYPE);
    }
    if (null == this.EN_CONFIRMSHARE) { 
        __dataOut.writeBoolean(true);
    } else {
        __dataOut.writeBoolean(false);
    com.cloudera.sqoop.lib.BigDecimalSerializer.write(this.EN_CONFIRMSHARE, __dataOut);
    }
    if (null == this.EN_FARE) { 
        __dataOut.writeBoolean(true);
    } else {
        __dataOut.writeBoolean(false);
    com.cloudera.sqoop.lib.BigDecimalSerializer.write(this.EN_FARE, __dataOut);
    }
    if (null == this.EN_DEALFARE) { 
        __dataOut.writeBoolean(true);
    } else {
        __dataOut.writeBoolean(false);
    com.cloudera.sqoop.lib.BigDecimalSerializer.write(this.EN_DEALFARE, __dataOut);
    }
    if (null == this.EN_TAFARE) { 
        __dataOut.writeBoolean(true);
    } else {
        __dataOut.writeBoolean(false);
    com.cloudera.sqoop.lib.BigDecimalSerializer.write(this.EN_TAFARE, __dataOut);
    }
    if (null == this.EN_AFTERFARE) { 
        __dataOut.writeBoolean(true);
    } else {
        __dataOut.writeBoolean(false);
    com.cloudera.sqoop.lib.BigDecimalSerializer.write(this.EN_AFTERFARE, __dataOut);
    }
    if (null == this.EN_AGENCYFARE) { 
        __dataOut.writeBoolean(true);
    } else {
        __dataOut.writeBoolean(false);
    com.cloudera.sqoop.lib.BigDecimalSerializer.write(this.EN_AGENCYFARE, __dataOut);
    }
    if (null == this.EN_STAMPTAX) { 
        __dataOut.writeBoolean(true);
    } else {
        __dataOut.writeBoolean(false);
    com.cloudera.sqoop.lib.BigDecimalSerializer.write(this.EN_STAMPTAX, __dataOut);
    }
    if (null == this.C_CONFIRMFLAG) { 
        __dataOut.writeBoolean(true);
    } else {
        __dataOut.writeBoolean(false);
    Text.writeString(__dataOut, C_CONFIRMFLAG);
    }
    if (null == this.VC_ERRORCODE) { 
        __dataOut.writeBoolean(true);
    } else {
        __dataOut.writeBoolean(false);
    Text.writeString(__dataOut, VC_ERRORCODE);
    }
    if (null == this.VC_ERRORCAUSE) { 
        __dataOut.writeBoolean(true);
    } else {
        __dataOut.writeBoolean(false);
    Text.writeString(__dataOut, VC_ERRORCAUSE);
    }
    if (null == this.C_VOUCHERFLAG) { 
        __dataOut.writeBoolean(true);
    } else {
        __dataOut.writeBoolean(false);
    Text.writeString(__dataOut, C_VOUCHERFLAG);
    }
    if (null == this.EN_INTEREST) { 
        __dataOut.writeBoolean(true);
    } else {
        __dataOut.writeBoolean(false);
    com.cloudera.sqoop.lib.BigDecimalSerializer.write(this.EN_INTEREST, __dataOut);
    }
    if (null == this.EN_INTERESTTAX) { 
        __dataOut.writeBoolean(true);
    } else {
        __dataOut.writeBoolean(false);
    com.cloudera.sqoop.lib.BigDecimalSerializer.write(this.EN_INTERESTTAX, __dataOut);
    }
    if (null == this.C_ORGANIGER) { 
        __dataOut.writeBoolean(true);
    } else {
        __dataOut.writeBoolean(false);
    Text.writeString(__dataOut, C_ORGANIGER);
    }
    if (null == this.VC_OTHERACCO) { 
        __dataOut.writeBoolean(true);
    } else {
        __dataOut.writeBoolean(false);
    Text.writeString(__dataOut, VC_OTHERACCO);
    }
    if (null == this.VC_OTHERTRADEACCO) { 
        __dataOut.writeBoolean(true);
    } else {
        __dataOut.writeBoolean(false);
    Text.writeString(__dataOut, VC_OTHERTRADEACCO);
    }
    if (null == this.C_OTHERAGENCYNO) { 
        __dataOut.writeBoolean(true);
    } else {
        __dataOut.writeBoolean(false);
    Text.writeString(__dataOut, C_OTHERAGENCYNO);
    }
    if (null == this.VC_OTHERNETNO) { 
        __dataOut.writeBoolean(true);
    } else {
        __dataOut.writeBoolean(false);
    Text.writeString(__dataOut, VC_OTHERNETNO);
    }
    if (null == this.VC_OTHERFUNDCODE) { 
        __dataOut.writeBoolean(true);
    } else {
        __dataOut.writeBoolean(false);
    Text.writeString(__dataOut, VC_OTHERFUNDCODE);
    }
    if (null == this.C_OTHERSHARETYPE) { 
        __dataOut.writeBoolean(true);
    } else {
        __dataOut.writeBoolean(false);
    Text.writeString(__dataOut, C_OTHERSHARETYPE);
    }
    if (null == this.EN_UNFROZENBALA) { 
        __dataOut.writeBoolean(true);
    } else {
        __dataOut.writeBoolean(false);
    com.cloudera.sqoop.lib.BigDecimalSerializer.write(this.EN_UNFROZENBALA, __dataOut);
    }
    if (null == this.EN_RETURNFARE) { 
        __dataOut.writeBoolean(true);
    } else {
        __dataOut.writeBoolean(false);
    com.cloudera.sqoop.lib.BigDecimalSerializer.write(this.EN_RETURNFARE, __dataOut);
    }
    if (null == this.EN_ORIGINFARE) { 
        __dataOut.writeBoolean(true);
    } else {
        __dataOut.writeBoolean(false);
    com.cloudera.sqoop.lib.BigDecimalSerializer.write(this.EN_ORIGINFARE, __dataOut);
    }
    if (null == this.VC_BROKER) { 
        __dataOut.writeBoolean(true);
    } else {
        __dataOut.writeBoolean(false);
    Text.writeString(__dataOut, VC_BROKER);
    }
    if (null == this.C_DIVIDENDMETHOD) { 
        __dataOut.writeBoolean(true);
    } else {
        __dataOut.writeBoolean(false);
    Text.writeString(__dataOut, C_DIVIDENDMETHOD);
    }
    if (null == this.C_FROZENCAUSE) { 
        __dataOut.writeBoolean(true);
    } else {
        __dataOut.writeBoolean(false);
    Text.writeString(__dataOut, C_FROZENCAUSE);
    }
    if (null == this.VC_ORIGINNO) { 
        __dataOut.writeBoolean(true);
    } else {
        __dataOut.writeBoolean(false);
    Text.writeString(__dataOut, VC_ORIGINNO);
    }
    if (null == this.VC_CITYNO) { 
        __dataOut.writeBoolean(true);
    } else {
        __dataOut.writeBoolean(false);
    Text.writeString(__dataOut, VC_CITYNO);
    }
    if (null == this.VC_SELLER) { 
        __dataOut.writeBoolean(true);
    } else {
        __dataOut.writeBoolean(false);
    Text.writeString(__dataOut, VC_SELLER);
    }
    if (null == this.VC_TACODE) { 
        __dataOut.writeBoolean(true);
    } else {
        __dataOut.writeBoolean(false);
    Text.writeString(__dataOut, VC_TACODE);
    }
    if (null == this.EN_DISCOUNT) { 
        __dataOut.writeBoolean(true);
    } else {
        __dataOut.writeBoolean(false);
    com.cloudera.sqoop.lib.BigDecimalSerializer.write(this.EN_DISCOUNT, __dataOut);
    }
    if (null == this.EN_INCOME) { 
        __dataOut.writeBoolean(true);
    } else {
        __dataOut.writeBoolean(false);
    com.cloudera.sqoop.lib.BigDecimalSerializer.write(this.EN_INCOME, __dataOut);
    }
    if (null == this.EN_INVESTINCOME) { 
        __dataOut.writeBoolean(true);
    } else {
        __dataOut.writeBoolean(false);
    com.cloudera.sqoop.lib.BigDecimalSerializer.write(this.EN_INVESTINCOME, __dataOut);
    }
    if (null == this.EN_INVESTSHARE) { 
        __dataOut.writeBoolean(true);
    } else {
        __dataOut.writeBoolean(false);
    com.cloudera.sqoop.lib.BigDecimalSerializer.write(this.EN_INVESTSHARE, __dataOut);
    }
    if (null == this.C_FINISHFLAG) { 
        __dataOut.writeBoolean(true);
    } else {
        __dataOut.writeBoolean(false);
    Text.writeString(__dataOut, C_FINISHFLAG);
    }
    if (null == this.C_INTERESTFLAG) { 
        __dataOut.writeBoolean(true);
    } else {
        __dataOut.writeBoolean(false);
    Text.writeString(__dataOut, C_INTERESTFLAG);
    }
    if (null == this.C_CONFIRMSTATUS) { 
        __dataOut.writeBoolean(true);
    } else {
        __dataOut.writeBoolean(false);
    Text.writeString(__dataOut, C_CONFIRMSTATUS);
    }
    if (null == this.EN_OTHERDISCOUNT) { 
        __dataOut.writeBoolean(true);
    } else {
        __dataOut.writeBoolean(false);
    com.cloudera.sqoop.lib.BigDecimalSerializer.write(this.EN_OTHERDISCOUNT, __dataOut);
    }
    if (null == this.EN_ENDDISCOUNT) { 
        __dataOut.writeBoolean(true);
    } else {
        __dataOut.writeBoolean(false);
    com.cloudera.sqoop.lib.BigDecimalSerializer.write(this.EN_ENDDISCOUNT, __dataOut);
    }
    if (null == this.VC_LIQUIDATEDATE) { 
        __dataOut.writeBoolean(true);
    } else {
        __dataOut.writeBoolean(false);
    Text.writeString(__dataOut, VC_LIQUIDATEDATE);
    }
    if (null == this.C_SENDFLAG) { 
        __dataOut.writeBoolean(true);
    } else {
        __dataOut.writeBoolean(false);
    Text.writeString(__dataOut, C_SENDFLAG);
    }
    if (null == this.VC_BRANCHCODE) { 
        __dataOut.writeBoolean(true);
    } else {
        __dataOut.writeBoolean(false);
    Text.writeString(__dataOut, VC_BRANCHCODE);
    }
    if (null == this.EN_OTHERNAV) { 
        __dataOut.writeBoolean(true);
    } else {
        __dataOut.writeBoolean(false);
    com.cloudera.sqoop.lib.BigDecimalSerializer.write(this.EN_OTHERNAV, __dataOut);
    }
    if (null == this.EN_OTHERCONFIRMSHARE) { 
        __dataOut.writeBoolean(true);
    } else {
        __dataOut.writeBoolean(false);
    com.cloudera.sqoop.lib.BigDecimalSerializer.write(this.EN_OTHERCONFIRMSHARE, __dataOut);
    }
    if (null == this.EN_OTHERORIGINFARE) { 
        __dataOut.writeBoolean(true);
    } else {
        __dataOut.writeBoolean(false);
    com.cloudera.sqoop.lib.BigDecimalSerializer.write(this.EN_OTHERORIGINFARE, __dataOut);
    }
    if (null == this.C_FIXBUSINFLAG) { 
        __dataOut.writeBoolean(true);
    } else {
        __dataOut.writeBoolean(false);
    Text.writeString(__dataOut, C_FIXBUSINFLAG);
    }
    if (null == this.C_CAPITALMODE) { 
        __dataOut.writeBoolean(true);
    } else {
        __dataOut.writeBoolean(false);
    Text.writeString(__dataOut, C_CAPITALMODE);
    }
    if (null == this.C_SUBCAPITALMODE) { 
        __dataOut.writeBoolean(true);
    } else {
        __dataOut.writeBoolean(false);
    Text.writeString(__dataOut, C_SUBCAPITALMODE);
    }
    if (null == this.VC_ORIGINCONFIRMNO) { 
        __dataOut.writeBoolean(true);
    } else {
        __dataOut.writeBoolean(false);
    Text.writeString(__dataOut, VC_ORIGINCONFIRMNO);
    }
    if (null == this.C_BUSINTYPE) { 
        __dataOut.writeBoolean(true);
    } else {
        __dataOut.writeBoolean(false);
    Text.writeString(__dataOut, C_BUSINTYPE);
    }
    if (null == this.L_SECTIONSCHEMANO) { 
        __dataOut.writeBoolean(true);
    } else {
        __dataOut.writeBoolean(false);
    com.cloudera.sqoop.lib.BigDecimalSerializer.write(this.L_SECTIONSCHEMANO, __dataOut);
    }
    if (null == this.C_EXPTYPE) { 
        __dataOut.writeBoolean(true);
    } else {
        __dataOut.writeBoolean(false);
    Text.writeString(__dataOut, C_EXPTYPE);
    }
    if (null == this.C_SHAREADJUSTFLAG) { 
        __dataOut.writeBoolean(true);
    } else {
        __dataOut.writeBoolean(false);
    Text.writeString(__dataOut, C_SHAREADJUSTFLAG);
    }
    if (null == this.C_INCOMEFLAG) { 
        __dataOut.writeBoolean(true);
    } else {
        __dataOut.writeBoolean(false);
    Text.writeString(__dataOut, C_INCOMEFLAG);
    }
    if (null == this.EN_ACHIEVEMENTPAY) { 
        __dataOut.writeBoolean(true);
    } else {
        __dataOut.writeBoolean(false);
    com.cloudera.sqoop.lib.BigDecimalSerializer.write(this.EN_ACHIEVEMENTPAY, __dataOut);
    }
    if (null == this.EN_BREACHFEE) { 
        __dataOut.writeBoolean(true);
    } else {
        __dataOut.writeBoolean(false);
    com.cloudera.sqoop.lib.BigDecimalSerializer.write(this.EN_BREACHFEE, __dataOut);
    }
    if (null == this.VC_COMEFROM) { 
        __dataOut.writeBoolean(true);
    } else {
        __dataOut.writeBoolean(false);
    Text.writeString(__dataOut, VC_COMEFROM);
    }
    if (null == this.VC_INVESTORSYSTEMID) { 
        __dataOut.writeBoolean(true);
    } else {
        __dataOut.writeBoolean(false);
    Text.writeString(__dataOut, VC_INVESTORSYSTEMID);
    }
    if (null == this.VC_VOUCHERNO) { 
        __dataOut.writeBoolean(true);
    } else {
        __dataOut.writeBoolean(false);
    Text.writeString(__dataOut, VC_VOUCHERNO);
    }
    if (null == this.C_BANKNO) { 
        __dataOut.writeBoolean(true);
    } else {
        __dataOut.writeBoolean(false);
    Text.writeString(__dataOut, C_BANKNO);
    }
    if (null == this.VC_BANKNAME) { 
        __dataOut.writeBoolean(true);
    } else {
        __dataOut.writeBoolean(false);
    Text.writeString(__dataOut, VC_BANKNAME);
    }
    if (null == this.VC_NAMEINBANK) { 
        __dataOut.writeBoolean(true);
    } else {
        __dataOut.writeBoolean(false);
    Text.writeString(__dataOut, VC_NAMEINBANK);
    }
    if (null == this.VC_BANKACCO) { 
        __dataOut.writeBoolean(true);
    } else {
        __dataOut.writeBoolean(false);
    Text.writeString(__dataOut, VC_BANKACCO);
    }
    if (null == this.VC_CUSTNO) { 
        __dataOut.writeBoolean(true);
    } else {
        __dataOut.writeBoolean(false);
    Text.writeString(__dataOut, VC_CUSTNO);
    }
    if (null == this.VC_CONFIRMSETTLEDATE) { 
        __dataOut.writeBoolean(true);
    } else {
        __dataOut.writeBoolean(false);
    Text.writeString(__dataOut, VC_CONFIRMSETTLEDATE);
    }
    if (null == this.VC_REQUESTSETTLEDATE) { 
        __dataOut.writeBoolean(true);
    } else {
        __dataOut.writeBoolean(false);
    Text.writeString(__dataOut, VC_REQUESTSETTLEDATE);
    }
    if (null == this.VC_CONTRACTSERIALNO) { 
        __dataOut.writeBoolean(true);
    } else {
        __dataOut.writeBoolean(false);
    Text.writeString(__dataOut, VC_CONTRACTSERIALNO);
    }
    if (null == this.C_PROFITCLASS) { 
        __dataOut.writeBoolean(true);
    } else {
        __dataOut.writeBoolean(false);
    Text.writeString(__dataOut, C_PROFITCLASS);
    }
    if (null == this.VC_COMBREQUESTNO) { 
        __dataOut.writeBoolean(true);
    } else {
        __dataOut.writeBoolean(false);
    Text.writeString(__dataOut, VC_COMBREQUESTNO);
    }
    if (null == this.VC_COMBCODE) { 
        __dataOut.writeBoolean(true);
    } else {
        __dataOut.writeBoolean(false);
    Text.writeString(__dataOut, VC_COMBCODE);
    }
    if (null == this.C_AUTOREQUEST) { 
        __dataOut.writeBoolean(true);
    } else {
        __dataOut.writeBoolean(false);
    Text.writeString(__dataOut, C_AUTOREQUEST);
    }
    if (null == this.VC_EXPLAIN) { 
        __dataOut.writeBoolean(true);
    } else {
        __dataOut.writeBoolean(false);
    Text.writeString(__dataOut, VC_EXPLAIN);
    }
    if (null == this.C_INTERFACETYPE) { 
        __dataOut.writeBoolean(true);
    } else {
        __dataOut.writeBoolean(false);
    Text.writeString(__dataOut, C_INTERFACETYPE);
    }
    if (null == this.EN_OTHERFEE1) { 
        __dataOut.writeBoolean(true);
    } else {
        __dataOut.writeBoolean(false);
    com.cloudera.sqoop.lib.BigDecimalSerializer.write(this.EN_OTHERFEE1, __dataOut);
    }
    if (null == this.EN_OTHERFEE2) { 
        __dataOut.writeBoolean(true);
    } else {
        __dataOut.writeBoolean(false);
    com.cloudera.sqoop.lib.BigDecimalSerializer.write(this.EN_OTHERFEE2, __dataOut);
    }
    if (null == this.C_MATCHFLAG) { 
        __dataOut.writeBoolean(true);
    } else {
        __dataOut.writeBoolean(false);
    Text.writeString(__dataOut, C_MATCHFLAG);
    }
    if (null == this.VC_BOOKID) { 
        __dataOut.writeBoolean(true);
    } else {
        __dataOut.writeBoolean(false);
    Text.writeString(__dataOut, VC_BOOKID);
    }
    if (null == this.EN_GRAMNUM) { 
        __dataOut.writeBoolean(true);
    } else {
        __dataOut.writeBoolean(false);
    com.cloudera.sqoop.lib.BigDecimalSerializer.write(this.EN_GRAMNUM, __dataOut);
    }
    if (null == this.C_FORCEREDEEMREASON) { 
        __dataOut.writeBoolean(true);
    } else {
        __dataOut.writeBoolean(false);
    Text.writeString(__dataOut, C_FORCEREDEEMREASON);
    }
    if (null == this.EN_TOTALFROZENSHARE) { 
        __dataOut.writeBoolean(true);
    } else {
        __dataOut.writeBoolean(false);
    com.cloudera.sqoop.lib.BigDecimalSerializer.write(this.EN_TOTALFROZENSHARE, __dataOut);
    }
    if (null == this.EN_FUNDSHAREBALANCE) { 
        __dataOut.writeBoolean(true);
    } else {
        __dataOut.writeBoolean(false);
    com.cloudera.sqoop.lib.BigDecimalSerializer.write(this.EN_FUNDSHAREBALANCE, __dataOut);
    }
    if (null == this.EN_FROZENBALANCE) { 
        __dataOut.writeBoolean(true);
    } else {
        __dataOut.writeBoolean(false);
    com.cloudera.sqoop.lib.BigDecimalSerializer.write(this.EN_FROZENBALANCE, __dataOut);
    }
    if (null == this.VC_FUTURESUBSCRIBEDATE) { 
        __dataOut.writeBoolean(true);
    } else {
        __dataOut.writeBoolean(false);
    Text.writeString(__dataOut, VC_FUTURESUBSCRIBEDATE);
    }
    if (null == this.VC_TRANSFERDATEFROMAGENCY) { 
        __dataOut.writeBoolean(true);
    } else {
        __dataOut.writeBoolean(false);
    Text.writeString(__dataOut, VC_TRANSFERDATEFROMAGENCY);
    }
    if (null == this.EN_TAXADVANAMOUNT) { 
        __dataOut.writeBoolean(true);
    } else {
        __dataOut.writeBoolean(false);
    com.cloudera.sqoop.lib.BigDecimalSerializer.write(this.EN_TAXADVANAMOUNT, __dataOut);
    }
    if (null == this.VC_TAXADVANCODE) { 
        __dataOut.writeBoolean(true);
    } else {
        __dataOut.writeBoolean(false);
    Text.writeString(__dataOut, VC_TAXADVANCODE);
    }
    if (null == this.VC_OTHERSERIALNO) { 
        __dataOut.writeBoolean(true);
    } else {
        __dataOut.writeBoolean(false);
    Text.writeString(__dataOut, VC_OTHERSERIALNO);
    }
    if (null == this.C_ATTENDQUITFLAG) { 
        __dataOut.writeBoolean(true);
    } else {
        __dataOut.writeBoolean(false);
    Text.writeString(__dataOut, C_ATTENDQUITFLAG);
    }
    if (null == this.VC_CUSTOMNAME_GS) { 
        __dataOut.writeBoolean(true);
    } else {
        __dataOut.writeBoolean(false);
    Text.writeString(__dataOut, VC_CUSTOMNAME_GS);
    }
    if (null == this.C_IDENTITYTYPE_GS) { 
        __dataOut.writeBoolean(true);
    } else {
        __dataOut.writeBoolean(false);
    Text.writeString(__dataOut, C_IDENTITYTYPE_GS);
    }
    if (null == this.VC_IDENTITYNO_GS) { 
        __dataOut.writeBoolean(true);
    } else {
        __dataOut.writeBoolean(false);
    Text.writeString(__dataOut, VC_IDENTITYNO_GS);
    }
    if (null == this.VC_NATIONALITY_GS) { 
        __dataOut.writeBoolean(true);
    } else {
        __dataOut.writeBoolean(false);
    Text.writeString(__dataOut, VC_NATIONALITY_GS);
    }
    if (null == this.VC_CERTCODE_GS) { 
        __dataOut.writeBoolean(true);
    } else {
        __dataOut.writeBoolean(false);
    Text.writeString(__dataOut, VC_CERTCODE_GS);
    }
    if (null == this.VC_CERTDATE_GS) { 
        __dataOut.writeBoolean(true);
    } else {
        __dataOut.writeBoolean(false);
    Text.writeString(__dataOut, VC_CERTDATE_GS);
    }
    if (null == this.EN_ACCTAXPRETAKEOFF_GS) { 
        __dataOut.writeBoolean(true);
    } else {
        __dataOut.writeBoolean(false);
    com.cloudera.sqoop.lib.BigDecimalSerializer.write(this.EN_ACCTAXPRETAKEOFF_GS, __dataOut);
    }
    if (null == this.INSERTTIME) { 
        __dataOut.writeBoolean(true);
    } else {
        __dataOut.writeBoolean(false);
    Text.writeString(__dataOut, INSERTTIME);
    }
    if (null == this.UPDATETIME) { 
        __dataOut.writeBoolean(true);
    } else {
        __dataOut.writeBoolean(false);
    Text.writeString(__dataOut, UPDATETIME);
    }
    if (null == this._20210422) { 
        __dataOut.writeBoolean(true);
    } else {
        __dataOut.writeBoolean(false);
    com.cloudera.sqoop.lib.BigDecimalSerializer.write(this._20210422, __dataOut);
    }
    if (null == this._SALES_) { 
        __dataOut.writeBoolean(true);
    } else {
        __dataOut.writeBoolean(false);
    Text.writeString(__dataOut, _SALES_);
    }
  }
  public void write0(DataOutput __dataOut) throws IOException {
    if (null == this.C_CUSTTYPE) { 
        __dataOut.writeBoolean(true);
    } else {
        __dataOut.writeBoolean(false);
    Text.writeString(__dataOut, C_CUSTTYPE);
    }
    if (null == this.VC_FUNDACCO) { 
        __dataOut.writeBoolean(true);
    } else {
        __dataOut.writeBoolean(false);
    Text.writeString(__dataOut, VC_FUNDACCO);
    }
    if (null == this.VC_TRADEACCO) { 
        __dataOut.writeBoolean(true);
    } else {
        __dataOut.writeBoolean(false);
    Text.writeString(__dataOut, VC_TRADEACCO);
    }
    if (null == this.C_TRUST) { 
        __dataOut.writeBoolean(true);
    } else {
        __dataOut.writeBoolean(false);
    Text.writeString(__dataOut, C_TRUST);
    }
    if (null == this.VC_REQUESTDATE) { 
        __dataOut.writeBoolean(true);
    } else {
        __dataOut.writeBoolean(false);
    Text.writeString(__dataOut, VC_REQUESTDATE);
    }
    if (null == this.VC_REQUESTNO) { 
        __dataOut.writeBoolean(true);
    } else {
        __dataOut.writeBoolean(false);
    Text.writeString(__dataOut, VC_REQUESTNO);
    }
    if (null == this.VC_CONFIRMNO) { 
        __dataOut.writeBoolean(true);
    } else {
        __dataOut.writeBoolean(false);
    Text.writeString(__dataOut, VC_CONFIRMNO);
    }
    if (null == this.VC_CONFIRMDATE) { 
        __dataOut.writeBoolean(true);
    } else {
        __dataOut.writeBoolean(false);
    Text.writeString(__dataOut, VC_CONFIRMDATE);
    }
    if (null == this.VC_FUNDCODE) { 
        __dataOut.writeBoolean(true);
    } else {
        __dataOut.writeBoolean(false);
    Text.writeString(__dataOut, VC_FUNDCODE);
    }
    if (null == this.C_SHARETYPE) { 
        __dataOut.writeBoolean(true);
    } else {
        __dataOut.writeBoolean(false);
    Text.writeString(__dataOut, C_SHARETYPE);
    }
    if (null == this.VC_NETNO) { 
        __dataOut.writeBoolean(true);
    } else {
        __dataOut.writeBoolean(false);
    Text.writeString(__dataOut, VC_NETNO);
    }
    if (null == this.VC_CENTERNO) { 
        __dataOut.writeBoolean(true);
    } else {
        __dataOut.writeBoolean(false);
    Text.writeString(__dataOut, VC_CENTERNO);
    }
    if (null == this.EN_RATIO) { 
        __dataOut.writeBoolean(true);
    } else {
        __dataOut.writeBoolean(false);
    com.cloudera.sqoop.lib.BigDecimalSerializer.write(this.EN_RATIO, __dataOut);
    }
    if (null == this.EN_NAV) { 
        __dataOut.writeBoolean(true);
    } else {
        __dataOut.writeBoolean(false);
    com.cloudera.sqoop.lib.BigDecimalSerializer.write(this.EN_NAV, __dataOut);
    }
    if (null == this.EN_PROFIT) { 
        __dataOut.writeBoolean(true);
    } else {
        __dataOut.writeBoolean(false);
    com.cloudera.sqoop.lib.BigDecimalSerializer.write(this.EN_PROFIT, __dataOut);
    }
    if (null == this.C_BUSINFLAG) { 
        __dataOut.writeBoolean(true);
    } else {
        __dataOut.writeBoolean(false);
    Text.writeString(__dataOut, C_BUSINFLAG);
    }
    if (null == this.EN_BALANCE) { 
        __dataOut.writeBoolean(true);
    } else {
        __dataOut.writeBoolean(false);
    com.cloudera.sqoop.lib.BigDecimalSerializer.write(this.EN_BALANCE, __dataOut);
    }
    if (null == this.EN_SHARE) { 
        __dataOut.writeBoolean(true);
    } else {
        __dataOut.writeBoolean(false);
    com.cloudera.sqoop.lib.BigDecimalSerializer.write(this.EN_SHARE, __dataOut);
    }
    if (null == this.EN_CONFIRMBALA) { 
        __dataOut.writeBoolean(true);
    } else {
        __dataOut.writeBoolean(false);
    com.cloudera.sqoop.lib.BigDecimalSerializer.write(this.EN_CONFIRMBALA, __dataOut);
    }
    if (null == this.C_MONEYTYPE) { 
        __dataOut.writeBoolean(true);
    } else {
        __dataOut.writeBoolean(false);
    Text.writeString(__dataOut, C_MONEYTYPE);
    }
    if (null == this.EN_CONFIRMSHARE) { 
        __dataOut.writeBoolean(true);
    } else {
        __dataOut.writeBoolean(false);
    com.cloudera.sqoop.lib.BigDecimalSerializer.write(this.EN_CONFIRMSHARE, __dataOut);
    }
    if (null == this.EN_FARE) { 
        __dataOut.writeBoolean(true);
    } else {
        __dataOut.writeBoolean(false);
    com.cloudera.sqoop.lib.BigDecimalSerializer.write(this.EN_FARE, __dataOut);
    }
    if (null == this.EN_DEALFARE) { 
        __dataOut.writeBoolean(true);
    } else {
        __dataOut.writeBoolean(false);
    com.cloudera.sqoop.lib.BigDecimalSerializer.write(this.EN_DEALFARE, __dataOut);
    }
    if (null == this.EN_TAFARE) { 
        __dataOut.writeBoolean(true);
    } else {
        __dataOut.writeBoolean(false);
    com.cloudera.sqoop.lib.BigDecimalSerializer.write(this.EN_TAFARE, __dataOut);
    }
    if (null == this.EN_AFTERFARE) { 
        __dataOut.writeBoolean(true);
    } else {
        __dataOut.writeBoolean(false);
    com.cloudera.sqoop.lib.BigDecimalSerializer.write(this.EN_AFTERFARE, __dataOut);
    }
    if (null == this.EN_AGENCYFARE) { 
        __dataOut.writeBoolean(true);
    } else {
        __dataOut.writeBoolean(false);
    com.cloudera.sqoop.lib.BigDecimalSerializer.write(this.EN_AGENCYFARE, __dataOut);
    }
    if (null == this.EN_STAMPTAX) { 
        __dataOut.writeBoolean(true);
    } else {
        __dataOut.writeBoolean(false);
    com.cloudera.sqoop.lib.BigDecimalSerializer.write(this.EN_STAMPTAX, __dataOut);
    }
    if (null == this.C_CONFIRMFLAG) { 
        __dataOut.writeBoolean(true);
    } else {
        __dataOut.writeBoolean(false);
    Text.writeString(__dataOut, C_CONFIRMFLAG);
    }
    if (null == this.VC_ERRORCODE) { 
        __dataOut.writeBoolean(true);
    } else {
        __dataOut.writeBoolean(false);
    Text.writeString(__dataOut, VC_ERRORCODE);
    }
    if (null == this.VC_ERRORCAUSE) { 
        __dataOut.writeBoolean(true);
    } else {
        __dataOut.writeBoolean(false);
    Text.writeString(__dataOut, VC_ERRORCAUSE);
    }
    if (null == this.C_VOUCHERFLAG) { 
        __dataOut.writeBoolean(true);
    } else {
        __dataOut.writeBoolean(false);
    Text.writeString(__dataOut, C_VOUCHERFLAG);
    }
    if (null == this.EN_INTEREST) { 
        __dataOut.writeBoolean(true);
    } else {
        __dataOut.writeBoolean(false);
    com.cloudera.sqoop.lib.BigDecimalSerializer.write(this.EN_INTEREST, __dataOut);
    }
    if (null == this.EN_INTERESTTAX) { 
        __dataOut.writeBoolean(true);
    } else {
        __dataOut.writeBoolean(false);
    com.cloudera.sqoop.lib.BigDecimalSerializer.write(this.EN_INTERESTTAX, __dataOut);
    }
    if (null == this.C_ORGANIGER) { 
        __dataOut.writeBoolean(true);
    } else {
        __dataOut.writeBoolean(false);
    Text.writeString(__dataOut, C_ORGANIGER);
    }
    if (null == this.VC_OTHERACCO) { 
        __dataOut.writeBoolean(true);
    } else {
        __dataOut.writeBoolean(false);
    Text.writeString(__dataOut, VC_OTHERACCO);
    }
    if (null == this.VC_OTHERTRADEACCO) { 
        __dataOut.writeBoolean(true);
    } else {
        __dataOut.writeBoolean(false);
    Text.writeString(__dataOut, VC_OTHERTRADEACCO);
    }
    if (null == this.C_OTHERAGENCYNO) { 
        __dataOut.writeBoolean(true);
    } else {
        __dataOut.writeBoolean(false);
    Text.writeString(__dataOut, C_OTHERAGENCYNO);
    }
    if (null == this.VC_OTHERNETNO) { 
        __dataOut.writeBoolean(true);
    } else {
        __dataOut.writeBoolean(false);
    Text.writeString(__dataOut, VC_OTHERNETNO);
    }
    if (null == this.VC_OTHERFUNDCODE) { 
        __dataOut.writeBoolean(true);
    } else {
        __dataOut.writeBoolean(false);
    Text.writeString(__dataOut, VC_OTHERFUNDCODE);
    }
    if (null == this.C_OTHERSHARETYPE) { 
        __dataOut.writeBoolean(true);
    } else {
        __dataOut.writeBoolean(false);
    Text.writeString(__dataOut, C_OTHERSHARETYPE);
    }
    if (null == this.EN_UNFROZENBALA) { 
        __dataOut.writeBoolean(true);
    } else {
        __dataOut.writeBoolean(false);
    com.cloudera.sqoop.lib.BigDecimalSerializer.write(this.EN_UNFROZENBALA, __dataOut);
    }
    if (null == this.EN_RETURNFARE) { 
        __dataOut.writeBoolean(true);
    } else {
        __dataOut.writeBoolean(false);
    com.cloudera.sqoop.lib.BigDecimalSerializer.write(this.EN_RETURNFARE, __dataOut);
    }
    if (null == this.EN_ORIGINFARE) { 
        __dataOut.writeBoolean(true);
    } else {
        __dataOut.writeBoolean(false);
    com.cloudera.sqoop.lib.BigDecimalSerializer.write(this.EN_ORIGINFARE, __dataOut);
    }
    if (null == this.VC_BROKER) { 
        __dataOut.writeBoolean(true);
    } else {
        __dataOut.writeBoolean(false);
    Text.writeString(__dataOut, VC_BROKER);
    }
    if (null == this.C_DIVIDENDMETHOD) { 
        __dataOut.writeBoolean(true);
    } else {
        __dataOut.writeBoolean(false);
    Text.writeString(__dataOut, C_DIVIDENDMETHOD);
    }
    if (null == this.C_FROZENCAUSE) { 
        __dataOut.writeBoolean(true);
    } else {
        __dataOut.writeBoolean(false);
    Text.writeString(__dataOut, C_FROZENCAUSE);
    }
    if (null == this.VC_ORIGINNO) { 
        __dataOut.writeBoolean(true);
    } else {
        __dataOut.writeBoolean(false);
    Text.writeString(__dataOut, VC_ORIGINNO);
    }
    if (null == this.VC_CITYNO) { 
        __dataOut.writeBoolean(true);
    } else {
        __dataOut.writeBoolean(false);
    Text.writeString(__dataOut, VC_CITYNO);
    }
    if (null == this.VC_SELLER) { 
        __dataOut.writeBoolean(true);
    } else {
        __dataOut.writeBoolean(false);
    Text.writeString(__dataOut, VC_SELLER);
    }
    if (null == this.VC_TACODE) { 
        __dataOut.writeBoolean(true);
    } else {
        __dataOut.writeBoolean(false);
    Text.writeString(__dataOut, VC_TACODE);
    }
    if (null == this.EN_DISCOUNT) { 
        __dataOut.writeBoolean(true);
    } else {
        __dataOut.writeBoolean(false);
    com.cloudera.sqoop.lib.BigDecimalSerializer.write(this.EN_DISCOUNT, __dataOut);
    }
    if (null == this.EN_INCOME) { 
        __dataOut.writeBoolean(true);
    } else {
        __dataOut.writeBoolean(false);
    com.cloudera.sqoop.lib.BigDecimalSerializer.write(this.EN_INCOME, __dataOut);
    }
    if (null == this.EN_INVESTINCOME) { 
        __dataOut.writeBoolean(true);
    } else {
        __dataOut.writeBoolean(false);
    com.cloudera.sqoop.lib.BigDecimalSerializer.write(this.EN_INVESTINCOME, __dataOut);
    }
    if (null == this.EN_INVESTSHARE) { 
        __dataOut.writeBoolean(true);
    } else {
        __dataOut.writeBoolean(false);
    com.cloudera.sqoop.lib.BigDecimalSerializer.write(this.EN_INVESTSHARE, __dataOut);
    }
    if (null == this.C_FINISHFLAG) { 
        __dataOut.writeBoolean(true);
    } else {
        __dataOut.writeBoolean(false);
    Text.writeString(__dataOut, C_FINISHFLAG);
    }
    if (null == this.C_INTERESTFLAG) { 
        __dataOut.writeBoolean(true);
    } else {
        __dataOut.writeBoolean(false);
    Text.writeString(__dataOut, C_INTERESTFLAG);
    }
    if (null == this.C_CONFIRMSTATUS) { 
        __dataOut.writeBoolean(true);
    } else {
        __dataOut.writeBoolean(false);
    Text.writeString(__dataOut, C_CONFIRMSTATUS);
    }
    if (null == this.EN_OTHERDISCOUNT) { 
        __dataOut.writeBoolean(true);
    } else {
        __dataOut.writeBoolean(false);
    com.cloudera.sqoop.lib.BigDecimalSerializer.write(this.EN_OTHERDISCOUNT, __dataOut);
    }
    if (null == this.EN_ENDDISCOUNT) { 
        __dataOut.writeBoolean(true);
    } else {
        __dataOut.writeBoolean(false);
    com.cloudera.sqoop.lib.BigDecimalSerializer.write(this.EN_ENDDISCOUNT, __dataOut);
    }
    if (null == this.VC_LIQUIDATEDATE) { 
        __dataOut.writeBoolean(true);
    } else {
        __dataOut.writeBoolean(false);
    Text.writeString(__dataOut, VC_LIQUIDATEDATE);
    }
    if (null == this.C_SENDFLAG) { 
        __dataOut.writeBoolean(true);
    } else {
        __dataOut.writeBoolean(false);
    Text.writeString(__dataOut, C_SENDFLAG);
    }
    if (null == this.VC_BRANCHCODE) { 
        __dataOut.writeBoolean(true);
    } else {
        __dataOut.writeBoolean(false);
    Text.writeString(__dataOut, VC_BRANCHCODE);
    }
    if (null == this.EN_OTHERNAV) { 
        __dataOut.writeBoolean(true);
    } else {
        __dataOut.writeBoolean(false);
    com.cloudera.sqoop.lib.BigDecimalSerializer.write(this.EN_OTHERNAV, __dataOut);
    }
    if (null == this.EN_OTHERCONFIRMSHARE) { 
        __dataOut.writeBoolean(true);
    } else {
        __dataOut.writeBoolean(false);
    com.cloudera.sqoop.lib.BigDecimalSerializer.write(this.EN_OTHERCONFIRMSHARE, __dataOut);
    }
    if (null == this.EN_OTHERORIGINFARE) { 
        __dataOut.writeBoolean(true);
    } else {
        __dataOut.writeBoolean(false);
    com.cloudera.sqoop.lib.BigDecimalSerializer.write(this.EN_OTHERORIGINFARE, __dataOut);
    }
    if (null == this.C_FIXBUSINFLAG) { 
        __dataOut.writeBoolean(true);
    } else {
        __dataOut.writeBoolean(false);
    Text.writeString(__dataOut, C_FIXBUSINFLAG);
    }
    if (null == this.C_CAPITALMODE) { 
        __dataOut.writeBoolean(true);
    } else {
        __dataOut.writeBoolean(false);
    Text.writeString(__dataOut, C_CAPITALMODE);
    }
    if (null == this.C_SUBCAPITALMODE) { 
        __dataOut.writeBoolean(true);
    } else {
        __dataOut.writeBoolean(false);
    Text.writeString(__dataOut, C_SUBCAPITALMODE);
    }
    if (null == this.VC_ORIGINCONFIRMNO) { 
        __dataOut.writeBoolean(true);
    } else {
        __dataOut.writeBoolean(false);
    Text.writeString(__dataOut, VC_ORIGINCONFIRMNO);
    }
    if (null == this.C_BUSINTYPE) { 
        __dataOut.writeBoolean(true);
    } else {
        __dataOut.writeBoolean(false);
    Text.writeString(__dataOut, C_BUSINTYPE);
    }
    if (null == this.L_SECTIONSCHEMANO) { 
        __dataOut.writeBoolean(true);
    } else {
        __dataOut.writeBoolean(false);
    com.cloudera.sqoop.lib.BigDecimalSerializer.write(this.L_SECTIONSCHEMANO, __dataOut);
    }
    if (null == this.C_EXPTYPE) { 
        __dataOut.writeBoolean(true);
    } else {
        __dataOut.writeBoolean(false);
    Text.writeString(__dataOut, C_EXPTYPE);
    }
    if (null == this.C_SHAREADJUSTFLAG) { 
        __dataOut.writeBoolean(true);
    } else {
        __dataOut.writeBoolean(false);
    Text.writeString(__dataOut, C_SHAREADJUSTFLAG);
    }
    if (null == this.C_INCOMEFLAG) { 
        __dataOut.writeBoolean(true);
    } else {
        __dataOut.writeBoolean(false);
    Text.writeString(__dataOut, C_INCOMEFLAG);
    }
    if (null == this.EN_ACHIEVEMENTPAY) { 
        __dataOut.writeBoolean(true);
    } else {
        __dataOut.writeBoolean(false);
    com.cloudera.sqoop.lib.BigDecimalSerializer.write(this.EN_ACHIEVEMENTPAY, __dataOut);
    }
    if (null == this.EN_BREACHFEE) { 
        __dataOut.writeBoolean(true);
    } else {
        __dataOut.writeBoolean(false);
    com.cloudera.sqoop.lib.BigDecimalSerializer.write(this.EN_BREACHFEE, __dataOut);
    }
    if (null == this.VC_COMEFROM) { 
        __dataOut.writeBoolean(true);
    } else {
        __dataOut.writeBoolean(false);
    Text.writeString(__dataOut, VC_COMEFROM);
    }
    if (null == this.VC_INVESTORSYSTEMID) { 
        __dataOut.writeBoolean(true);
    } else {
        __dataOut.writeBoolean(false);
    Text.writeString(__dataOut, VC_INVESTORSYSTEMID);
    }
    if (null == this.VC_VOUCHERNO) { 
        __dataOut.writeBoolean(true);
    } else {
        __dataOut.writeBoolean(false);
    Text.writeString(__dataOut, VC_VOUCHERNO);
    }
    if (null == this.C_BANKNO) { 
        __dataOut.writeBoolean(true);
    } else {
        __dataOut.writeBoolean(false);
    Text.writeString(__dataOut, C_BANKNO);
    }
    if (null == this.VC_BANKNAME) { 
        __dataOut.writeBoolean(true);
    } else {
        __dataOut.writeBoolean(false);
    Text.writeString(__dataOut, VC_BANKNAME);
    }
    if (null == this.VC_NAMEINBANK) { 
        __dataOut.writeBoolean(true);
    } else {
        __dataOut.writeBoolean(false);
    Text.writeString(__dataOut, VC_NAMEINBANK);
    }
    if (null == this.VC_BANKACCO) { 
        __dataOut.writeBoolean(true);
    } else {
        __dataOut.writeBoolean(false);
    Text.writeString(__dataOut, VC_BANKACCO);
    }
    if (null == this.VC_CUSTNO) { 
        __dataOut.writeBoolean(true);
    } else {
        __dataOut.writeBoolean(false);
    Text.writeString(__dataOut, VC_CUSTNO);
    }
    if (null == this.VC_CONFIRMSETTLEDATE) { 
        __dataOut.writeBoolean(true);
    } else {
        __dataOut.writeBoolean(false);
    Text.writeString(__dataOut, VC_CONFIRMSETTLEDATE);
    }
    if (null == this.VC_REQUESTSETTLEDATE) { 
        __dataOut.writeBoolean(true);
    } else {
        __dataOut.writeBoolean(false);
    Text.writeString(__dataOut, VC_REQUESTSETTLEDATE);
    }
    if (null == this.VC_CONTRACTSERIALNO) { 
        __dataOut.writeBoolean(true);
    } else {
        __dataOut.writeBoolean(false);
    Text.writeString(__dataOut, VC_CONTRACTSERIALNO);
    }
    if (null == this.C_PROFITCLASS) { 
        __dataOut.writeBoolean(true);
    } else {
        __dataOut.writeBoolean(false);
    Text.writeString(__dataOut, C_PROFITCLASS);
    }
    if (null == this.VC_COMBREQUESTNO) { 
        __dataOut.writeBoolean(true);
    } else {
        __dataOut.writeBoolean(false);
    Text.writeString(__dataOut, VC_COMBREQUESTNO);
    }
    if (null == this.VC_COMBCODE) { 
        __dataOut.writeBoolean(true);
    } else {
        __dataOut.writeBoolean(false);
    Text.writeString(__dataOut, VC_COMBCODE);
    }
    if (null == this.C_AUTOREQUEST) { 
        __dataOut.writeBoolean(true);
    } else {
        __dataOut.writeBoolean(false);
    Text.writeString(__dataOut, C_AUTOREQUEST);
    }
    if (null == this.VC_EXPLAIN) { 
        __dataOut.writeBoolean(true);
    } else {
        __dataOut.writeBoolean(false);
    Text.writeString(__dataOut, VC_EXPLAIN);
    }
    if (null == this.C_INTERFACETYPE) { 
        __dataOut.writeBoolean(true);
    } else {
        __dataOut.writeBoolean(false);
    Text.writeString(__dataOut, C_INTERFACETYPE);
    }
    if (null == this.EN_OTHERFEE1) { 
        __dataOut.writeBoolean(true);
    } else {
        __dataOut.writeBoolean(false);
    com.cloudera.sqoop.lib.BigDecimalSerializer.write(this.EN_OTHERFEE1, __dataOut);
    }
    if (null == this.EN_OTHERFEE2) { 
        __dataOut.writeBoolean(true);
    } else {
        __dataOut.writeBoolean(false);
    com.cloudera.sqoop.lib.BigDecimalSerializer.write(this.EN_OTHERFEE2, __dataOut);
    }
    if (null == this.C_MATCHFLAG) { 
        __dataOut.writeBoolean(true);
    } else {
        __dataOut.writeBoolean(false);
    Text.writeString(__dataOut, C_MATCHFLAG);
    }
    if (null == this.VC_BOOKID) { 
        __dataOut.writeBoolean(true);
    } else {
        __dataOut.writeBoolean(false);
    Text.writeString(__dataOut, VC_BOOKID);
    }
    if (null == this.EN_GRAMNUM) { 
        __dataOut.writeBoolean(true);
    } else {
        __dataOut.writeBoolean(false);
    com.cloudera.sqoop.lib.BigDecimalSerializer.write(this.EN_GRAMNUM, __dataOut);
    }
    if (null == this.C_FORCEREDEEMREASON) { 
        __dataOut.writeBoolean(true);
    } else {
        __dataOut.writeBoolean(false);
    Text.writeString(__dataOut, C_FORCEREDEEMREASON);
    }
    if (null == this.EN_TOTALFROZENSHARE) { 
        __dataOut.writeBoolean(true);
    } else {
        __dataOut.writeBoolean(false);
    com.cloudera.sqoop.lib.BigDecimalSerializer.write(this.EN_TOTALFROZENSHARE, __dataOut);
    }
    if (null == this.EN_FUNDSHAREBALANCE) { 
        __dataOut.writeBoolean(true);
    } else {
        __dataOut.writeBoolean(false);
    com.cloudera.sqoop.lib.BigDecimalSerializer.write(this.EN_FUNDSHAREBALANCE, __dataOut);
    }
    if (null == this.EN_FROZENBALANCE) { 
        __dataOut.writeBoolean(true);
    } else {
        __dataOut.writeBoolean(false);
    com.cloudera.sqoop.lib.BigDecimalSerializer.write(this.EN_FROZENBALANCE, __dataOut);
    }
    if (null == this.VC_FUTURESUBSCRIBEDATE) { 
        __dataOut.writeBoolean(true);
    } else {
        __dataOut.writeBoolean(false);
    Text.writeString(__dataOut, VC_FUTURESUBSCRIBEDATE);
    }
    if (null == this.VC_TRANSFERDATEFROMAGENCY) { 
        __dataOut.writeBoolean(true);
    } else {
        __dataOut.writeBoolean(false);
    Text.writeString(__dataOut, VC_TRANSFERDATEFROMAGENCY);
    }
    if (null == this.EN_TAXADVANAMOUNT) { 
        __dataOut.writeBoolean(true);
    } else {
        __dataOut.writeBoolean(false);
    com.cloudera.sqoop.lib.BigDecimalSerializer.write(this.EN_TAXADVANAMOUNT, __dataOut);
    }
    if (null == this.VC_TAXADVANCODE) { 
        __dataOut.writeBoolean(true);
    } else {
        __dataOut.writeBoolean(false);
    Text.writeString(__dataOut, VC_TAXADVANCODE);
    }
    if (null == this.VC_OTHERSERIALNO) { 
        __dataOut.writeBoolean(true);
    } else {
        __dataOut.writeBoolean(false);
    Text.writeString(__dataOut, VC_OTHERSERIALNO);
    }
    if (null == this.C_ATTENDQUITFLAG) { 
        __dataOut.writeBoolean(true);
    } else {
        __dataOut.writeBoolean(false);
    Text.writeString(__dataOut, C_ATTENDQUITFLAG);
    }
    if (null == this.VC_CUSTOMNAME_GS) { 
        __dataOut.writeBoolean(true);
    } else {
        __dataOut.writeBoolean(false);
    Text.writeString(__dataOut, VC_CUSTOMNAME_GS);
    }
    if (null == this.C_IDENTITYTYPE_GS) { 
        __dataOut.writeBoolean(true);
    } else {
        __dataOut.writeBoolean(false);
    Text.writeString(__dataOut, C_IDENTITYTYPE_GS);
    }
    if (null == this.VC_IDENTITYNO_GS) { 
        __dataOut.writeBoolean(true);
    } else {
        __dataOut.writeBoolean(false);
    Text.writeString(__dataOut, VC_IDENTITYNO_GS);
    }
    if (null == this.VC_NATIONALITY_GS) { 
        __dataOut.writeBoolean(true);
    } else {
        __dataOut.writeBoolean(false);
    Text.writeString(__dataOut, VC_NATIONALITY_GS);
    }
    if (null == this.VC_CERTCODE_GS) { 
        __dataOut.writeBoolean(true);
    } else {
        __dataOut.writeBoolean(false);
    Text.writeString(__dataOut, VC_CERTCODE_GS);
    }
    if (null == this.VC_CERTDATE_GS) { 
        __dataOut.writeBoolean(true);
    } else {
        __dataOut.writeBoolean(false);
    Text.writeString(__dataOut, VC_CERTDATE_GS);
    }
    if (null == this.EN_ACCTAXPRETAKEOFF_GS) { 
        __dataOut.writeBoolean(true);
    } else {
        __dataOut.writeBoolean(false);
    com.cloudera.sqoop.lib.BigDecimalSerializer.write(this.EN_ACCTAXPRETAKEOFF_GS, __dataOut);
    }
    if (null == this.INSERTTIME) { 
        __dataOut.writeBoolean(true);
    } else {
        __dataOut.writeBoolean(false);
    Text.writeString(__dataOut, INSERTTIME);
    }
    if (null == this.UPDATETIME) { 
        __dataOut.writeBoolean(true);
    } else {
        __dataOut.writeBoolean(false);
    Text.writeString(__dataOut, UPDATETIME);
    }
    if (null == this._20210422) { 
        __dataOut.writeBoolean(true);
    } else {
        __dataOut.writeBoolean(false);
    com.cloudera.sqoop.lib.BigDecimalSerializer.write(this._20210422, __dataOut);
    }
    if (null == this._SALES_) { 
        __dataOut.writeBoolean(true);
    } else {
        __dataOut.writeBoolean(false);
    Text.writeString(__dataOut, _SALES_);
    }
  }
  private static final DelimiterSet __outputDelimiters = new DelimiterSet((char) 1, (char) 10, (char) 0, (char) 0, false);
  public String toString() {
    return toString(__outputDelimiters, true);
  }
  public String toString(DelimiterSet delimiters) {
    return toString(delimiters, true);
  }
  public String toString(boolean useRecordDelim) {
    return toString(__outputDelimiters, useRecordDelim);
  }
  public String toString(DelimiterSet delimiters, boolean useRecordDelim) {
    StringBuilder __sb = new StringBuilder();
    char fieldDelim = delimiters.getFieldsTerminatedBy();
    // special case for strings hive, droppingdelimiters \n,\r,\01 from strings
    __sb.append(FieldFormatter.hiveStringDropDelims(C_CUSTTYPE==null?"\\N":C_CUSTTYPE, delimiters));
    __sb.append(fieldDelim);
    // special case for strings hive, droppingdelimiters \n,\r,\01 from strings
    __sb.append(FieldFormatter.hiveStringDropDelims(VC_FUNDACCO==null?"\\N":VC_FUNDACCO, delimiters));
    __sb.append(fieldDelim);
    // special case for strings hive, droppingdelimiters \n,\r,\01 from strings
    __sb.append(FieldFormatter.hiveStringDropDelims(VC_TRADEACCO==null?"\\N":VC_TRADEACCO, delimiters));
    __sb.append(fieldDelim);
    // special case for strings hive, droppingdelimiters \n,\r,\01 from strings
    __sb.append(FieldFormatter.hiveStringDropDelims(C_TRUST==null?"\\N":C_TRUST, delimiters));
    __sb.append(fieldDelim);
    // special case for strings hive, droppingdelimiters \n,\r,\01 from strings
    __sb.append(FieldFormatter.hiveStringDropDelims(VC_REQUESTDATE==null?"\\N":VC_REQUESTDATE, delimiters));
    __sb.append(fieldDelim);
    // special case for strings hive, droppingdelimiters \n,\r,\01 from strings
    __sb.append(FieldFormatter.hiveStringDropDelims(VC_REQUESTNO==null?"\\N":VC_REQUESTNO, delimiters));
    __sb.append(fieldDelim);
    // special case for strings hive, droppingdelimiters \n,\r,\01 from strings
    __sb.append(FieldFormatter.hiveStringDropDelims(VC_CONFIRMNO==null?"\\N":VC_CONFIRMNO, delimiters));
    __sb.append(fieldDelim);
    // special case for strings hive, droppingdelimiters \n,\r,\01 from strings
    __sb.append(FieldFormatter.hiveStringDropDelims(VC_CONFIRMDATE==null?"\\N":VC_CONFIRMDATE, delimiters));
    __sb.append(fieldDelim);
    // special case for strings hive, droppingdelimiters \n,\r,\01 from strings
    __sb.append(FieldFormatter.hiveStringDropDelims(VC_FUNDCODE==null?"\\N":VC_FUNDCODE, delimiters));
    __sb.append(fieldDelim);
    // special case for strings hive, droppingdelimiters \n,\r,\01 from strings
    __sb.append(FieldFormatter.hiveStringDropDelims(C_SHARETYPE==null?"\\N":C_SHARETYPE, delimiters));
    __sb.append(fieldDelim);
    // special case for strings hive, droppingdelimiters \n,\r,\01 from strings
    __sb.append(FieldFormatter.hiveStringDropDelims(VC_NETNO==null?"\\N":VC_NETNO, delimiters));
    __sb.append(fieldDelim);
    // special case for strings hive, droppingdelimiters \n,\r,\01 from strings
    __sb.append(FieldFormatter.hiveStringDropDelims(VC_CENTERNO==null?"\\N":VC_CENTERNO, delimiters));
    __sb.append(fieldDelim);
    __sb.append(FieldFormatter.escapeAndEnclose(EN_RATIO==null?"\\N":EN_RATIO.toPlainString(), delimiters));
    __sb.append(fieldDelim);
    __sb.append(FieldFormatter.escapeAndEnclose(EN_NAV==null?"\\N":EN_NAV.toPlainString(), delimiters));
    __sb.append(fieldDelim);
    __sb.append(FieldFormatter.escapeAndEnclose(EN_PROFIT==null?"\\N":EN_PROFIT.toPlainString(), delimiters));
    __sb.append(fieldDelim);
    // special case for strings hive, droppingdelimiters \n,\r,\01 from strings
    __sb.append(FieldFormatter.hiveStringDropDelims(C_BUSINFLAG==null?"\\N":C_BUSINFLAG, delimiters));
    __sb.append(fieldDelim);
    __sb.append(FieldFormatter.escapeAndEnclose(EN_BALANCE==null?"\\N":EN_BALANCE.toPlainString(), delimiters));
    __sb.append(fieldDelim);
    __sb.append(FieldFormatter.escapeAndEnclose(EN_SHARE==null?"\\N":EN_SHARE.toPlainString(), delimiters));
    __sb.append(fieldDelim);
    __sb.append(FieldFormatter.escapeAndEnclose(EN_CONFIRMBALA==null?"\\N":EN_CONFIRMBALA.toPlainString(), delimiters));
    __sb.append(fieldDelim);
    // special case for strings hive, droppingdelimiters \n,\r,\01 from strings
    __sb.append(FieldFormatter.hiveStringDropDelims(C_MONEYTYPE==null?"\\N":C_MONEYTYPE, delimiters));
    __sb.append(fieldDelim);
    __sb.append(FieldFormatter.escapeAndEnclose(EN_CONFIRMSHARE==null?"\\N":EN_CONFIRMSHARE.toPlainString(), delimiters));
    __sb.append(fieldDelim);
    __sb.append(FieldFormatter.escapeAndEnclose(EN_FARE==null?"\\N":EN_FARE.toPlainString(), delimiters));
    __sb.append(fieldDelim);
    __sb.append(FieldFormatter.escapeAndEnclose(EN_DEALFARE==null?"\\N":EN_DEALFARE.toPlainString(), delimiters));
    __sb.append(fieldDelim);
    __sb.append(FieldFormatter.escapeAndEnclose(EN_TAFARE==null?"\\N":EN_TAFARE.toPlainString(), delimiters));
    __sb.append(fieldDelim);
    __sb.append(FieldFormatter.escapeAndEnclose(EN_AFTERFARE==null?"\\N":EN_AFTERFARE.toPlainString(), delimiters));
    __sb.append(fieldDelim);
    __sb.append(FieldFormatter.escapeAndEnclose(EN_AGENCYFARE==null?"\\N":EN_AGENCYFARE.toPlainString(), delimiters));
    __sb.append(fieldDelim);
    __sb.append(FieldFormatter.escapeAndEnclose(EN_STAMPTAX==null?"\\N":EN_STAMPTAX.toPlainString(), delimiters));
    __sb.append(fieldDelim);
    // special case for strings hive, droppingdelimiters \n,\r,\01 from strings
    __sb.append(FieldFormatter.hiveStringDropDelims(C_CONFIRMFLAG==null?"\\N":C_CONFIRMFLAG, delimiters));
    __sb.append(fieldDelim);
    // special case for strings hive, droppingdelimiters \n,\r,\01 from strings
    __sb.append(FieldFormatter.hiveStringDropDelims(VC_ERRORCODE==null?"\\N":VC_ERRORCODE, delimiters));
    __sb.append(fieldDelim);
    // special case for strings hive, droppingdelimiters \n,\r,\01 from strings
    __sb.append(FieldFormatter.hiveStringDropDelims(VC_ERRORCAUSE==null?"\\N":VC_ERRORCAUSE, delimiters));
    __sb.append(fieldDelim);
    // special case for strings hive, droppingdelimiters \n,\r,\01 from strings
    __sb.append(FieldFormatter.hiveStringDropDelims(C_VOUCHERFLAG==null?"\\N":C_VOUCHERFLAG, delimiters));
    __sb.append(fieldDelim);
    __sb.append(FieldFormatter.escapeAndEnclose(EN_INTEREST==null?"\\N":EN_INTEREST.toPlainString(), delimiters));
    __sb.append(fieldDelim);
    __sb.append(FieldFormatter.escapeAndEnclose(EN_INTERESTTAX==null?"\\N":EN_INTERESTTAX.toPlainString(), delimiters));
    __sb.append(fieldDelim);
    // special case for strings hive, droppingdelimiters \n,\r,\01 from strings
    __sb.append(FieldFormatter.hiveStringDropDelims(C_ORGANIGER==null?"\\N":C_ORGANIGER, delimiters));
    __sb.append(fieldDelim);
    // special case for strings hive, droppingdelimiters \n,\r,\01 from strings
    __sb.append(FieldFormatter.hiveStringDropDelims(VC_OTHERACCO==null?"\\N":VC_OTHERACCO, delimiters));
    __sb.append(fieldDelim);
    // special case for strings hive, droppingdelimiters \n,\r,\01 from strings
    __sb.append(FieldFormatter.hiveStringDropDelims(VC_OTHERTRADEACCO==null?"\\N":VC_OTHERTRADEACCO, delimiters));
    __sb.append(fieldDelim);
    // special case for strings hive, droppingdelimiters \n,\r,\01 from strings
    __sb.append(FieldFormatter.hiveStringDropDelims(C_OTHERAGENCYNO==null?"\\N":C_OTHERAGENCYNO, delimiters));
    __sb.append(fieldDelim);
    // special case for strings hive, droppingdelimiters \n,\r,\01 from strings
    __sb.append(FieldFormatter.hiveStringDropDelims(VC_OTHERNETNO==null?"\\N":VC_OTHERNETNO, delimiters));
    __sb.append(fieldDelim);
    // special case for strings hive, droppingdelimiters \n,\r,\01 from strings
    __sb.append(FieldFormatter.hiveStringDropDelims(VC_OTHERFUNDCODE==null?"\\N":VC_OTHERFUNDCODE, delimiters));
    __sb.append(fieldDelim);
    // special case for strings hive, droppingdelimiters \n,\r,\01 from strings
    __sb.append(FieldFormatter.hiveStringDropDelims(C_OTHERSHARETYPE==null?"\\N":C_OTHERSHARETYPE, delimiters));
    __sb.append(fieldDelim);
    __sb.append(FieldFormatter.escapeAndEnclose(EN_UNFROZENBALA==null?"\\N":EN_UNFROZENBALA.toPlainString(), delimiters));
    __sb.append(fieldDelim);
    __sb.append(FieldFormatter.escapeAndEnclose(EN_RETURNFARE==null?"\\N":EN_RETURNFARE.toPlainString(), delimiters));
    __sb.append(fieldDelim);
    __sb.append(FieldFormatter.escapeAndEnclose(EN_ORIGINFARE==null?"\\N":EN_ORIGINFARE.toPlainString(), delimiters));
    __sb.append(fieldDelim);
    // special case for strings hive, droppingdelimiters \n,\r,\01 from strings
    __sb.append(FieldFormatter.hiveStringDropDelims(VC_BROKER==null?"\\N":VC_BROKER, delimiters));
    __sb.append(fieldDelim);
    // special case for strings hive, droppingdelimiters \n,\r,\01 from strings
    __sb.append(FieldFormatter.hiveStringDropDelims(C_DIVIDENDMETHOD==null?"\\N":C_DIVIDENDMETHOD, delimiters));
    __sb.append(fieldDelim);
    // special case for strings hive, droppingdelimiters \n,\r,\01 from strings
    __sb.append(FieldFormatter.hiveStringDropDelims(C_FROZENCAUSE==null?"\\N":C_FROZENCAUSE, delimiters));
    __sb.append(fieldDelim);
    // special case for strings hive, droppingdelimiters \n,\r,\01 from strings
    __sb.append(FieldFormatter.hiveStringDropDelims(VC_ORIGINNO==null?"\\N":VC_ORIGINNO, delimiters));
    __sb.append(fieldDelim);
    // special case for strings hive, droppingdelimiters \n,\r,\01 from strings
    __sb.append(FieldFormatter.hiveStringDropDelims(VC_CITYNO==null?"\\N":VC_CITYNO, delimiters));
    __sb.append(fieldDelim);
    // special case for strings hive, droppingdelimiters \n,\r,\01 from strings
    __sb.append(FieldFormatter.hiveStringDropDelims(VC_SELLER==null?"\\N":VC_SELLER, delimiters));
    __sb.append(fieldDelim);
    // special case for strings hive, droppingdelimiters \n,\r,\01 from strings
    __sb.append(FieldFormatter.hiveStringDropDelims(VC_TACODE==null?"\\N":VC_TACODE, delimiters));
    __sb.append(fieldDelim);
    __sb.append(FieldFormatter.escapeAndEnclose(EN_DISCOUNT==null?"\\N":EN_DISCOUNT.toPlainString(), delimiters));
    __sb.append(fieldDelim);
    __sb.append(FieldFormatter.escapeAndEnclose(EN_INCOME==null?"\\N":EN_INCOME.toPlainString(), delimiters));
    __sb.append(fieldDelim);
    __sb.append(FieldFormatter.escapeAndEnclose(EN_INVESTINCOME==null?"\\N":EN_INVESTINCOME.toPlainString(), delimiters));
    __sb.append(fieldDelim);
    __sb.append(FieldFormatter.escapeAndEnclose(EN_INVESTSHARE==null?"\\N":EN_INVESTSHARE.toPlainString(), delimiters));
    __sb.append(fieldDelim);
    // special case for strings hive, droppingdelimiters \n,\r,\01 from strings
    __sb.append(FieldFormatter.hiveStringDropDelims(C_FINISHFLAG==null?"\\N":C_FINISHFLAG, delimiters));
    __sb.append(fieldDelim);
    // special case for strings hive, droppingdelimiters \n,\r,\01 from strings
    __sb.append(FieldFormatter.hiveStringDropDelims(C_INTERESTFLAG==null?"\\N":C_INTERESTFLAG, delimiters));
    __sb.append(fieldDelim);
    // special case for strings hive, droppingdelimiters \n,\r,\01 from strings
    __sb.append(FieldFormatter.hiveStringDropDelims(C_CONFIRMSTATUS==null?"\\N":C_CONFIRMSTATUS, delimiters));
    __sb.append(fieldDelim);
    __sb.append(FieldFormatter.escapeAndEnclose(EN_OTHERDISCOUNT==null?"\\N":EN_OTHERDISCOUNT.toPlainString(), delimiters));
    __sb.append(fieldDelim);
    __sb.append(FieldFormatter.escapeAndEnclose(EN_ENDDISCOUNT==null?"\\N":EN_ENDDISCOUNT.toPlainString(), delimiters));
    __sb.append(fieldDelim);
    // special case for strings hive, droppingdelimiters \n,\r,\01 from strings
    __sb.append(FieldFormatter.hiveStringDropDelims(VC_LIQUIDATEDATE==null?"\\N":VC_LIQUIDATEDATE, delimiters));
    __sb.append(fieldDelim);
    // special case for strings hive, droppingdelimiters \n,\r,\01 from strings
    __sb.append(FieldFormatter.hiveStringDropDelims(C_SENDFLAG==null?"\\N":C_SENDFLAG, delimiters));
    __sb.append(fieldDelim);
    // special case for strings hive, droppingdelimiters \n,\r,\01 from strings
    __sb.append(FieldFormatter.hiveStringDropDelims(VC_BRANCHCODE==null?"\\N":VC_BRANCHCODE, delimiters));
    __sb.append(fieldDelim);
    __sb.append(FieldFormatter.escapeAndEnclose(EN_OTHERNAV==null?"\\N":EN_OTHERNAV.toPlainString(), delimiters));
    __sb.append(fieldDelim);
    __sb.append(FieldFormatter.escapeAndEnclose(EN_OTHERCONFIRMSHARE==null?"\\N":EN_OTHERCONFIRMSHARE.toPlainString(), delimiters));
    __sb.append(fieldDelim);
    __sb.append(FieldFormatter.escapeAndEnclose(EN_OTHERORIGINFARE==null?"\\N":EN_OTHERORIGINFARE.toPlainString(), delimiters));
    __sb.append(fieldDelim);
    // special case for strings hive, droppingdelimiters \n,\r,\01 from strings
    __sb.append(FieldFormatter.hiveStringDropDelims(C_FIXBUSINFLAG==null?"\\N":C_FIXBUSINFLAG, delimiters));
    __sb.append(fieldDelim);
    // special case for strings hive, droppingdelimiters \n,\r,\01 from strings
    __sb.append(FieldFormatter.hiveStringDropDelims(C_CAPITALMODE==null?"\\N":C_CAPITALMODE, delimiters));
    __sb.append(fieldDelim);
    // special case for strings hive, droppingdelimiters \n,\r,\01 from strings
    __sb.append(FieldFormatter.hiveStringDropDelims(C_SUBCAPITALMODE==null?"\\N":C_SUBCAPITALMODE, delimiters));
    __sb.append(fieldDelim);
    // special case for strings hive, droppingdelimiters \n,\r,\01 from strings
    __sb.append(FieldFormatter.hiveStringDropDelims(VC_ORIGINCONFIRMNO==null?"\\N":VC_ORIGINCONFIRMNO, delimiters));
    __sb.append(fieldDelim);
    // special case for strings hive, droppingdelimiters \n,\r,\01 from strings
    __sb.append(FieldFormatter.hiveStringDropDelims(C_BUSINTYPE==null?"\\N":C_BUSINTYPE, delimiters));
    __sb.append(fieldDelim);
    __sb.append(FieldFormatter.escapeAndEnclose(L_SECTIONSCHEMANO==null?"\\N":L_SECTIONSCHEMANO.toPlainString(), delimiters));
    __sb.append(fieldDelim);
    // special case for strings hive, droppingdelimiters \n,\r,\01 from strings
    __sb.append(FieldFormatter.hiveStringDropDelims(C_EXPTYPE==null?"\\N":C_EXPTYPE, delimiters));
    __sb.append(fieldDelim);
    // special case for strings hive, droppingdelimiters \n,\r,\01 from strings
    __sb.append(FieldFormatter.hiveStringDropDelims(C_SHAREADJUSTFLAG==null?"\\N":C_SHAREADJUSTFLAG, delimiters));
    __sb.append(fieldDelim);
    // special case for strings hive, droppingdelimiters \n,\r,\01 from strings
    __sb.append(FieldFormatter.hiveStringDropDelims(C_INCOMEFLAG==null?"\\N":C_INCOMEFLAG, delimiters));
    __sb.append(fieldDelim);
    __sb.append(FieldFormatter.escapeAndEnclose(EN_ACHIEVEMENTPAY==null?"\\N":EN_ACHIEVEMENTPAY.toPlainString(), delimiters));
    __sb.append(fieldDelim);
    __sb.append(FieldFormatter.escapeAndEnclose(EN_BREACHFEE==null?"\\N":EN_BREACHFEE.toPlainString(), delimiters));
    __sb.append(fieldDelim);
    // special case for strings hive, droppingdelimiters \n,\r,\01 from strings
    __sb.append(FieldFormatter.hiveStringDropDelims(VC_COMEFROM==null?"\\N":VC_COMEFROM, delimiters));
    __sb.append(fieldDelim);
    // special case for strings hive, droppingdelimiters \n,\r,\01 from strings
    __sb.append(FieldFormatter.hiveStringDropDelims(VC_INVESTORSYSTEMID==null?"\\N":VC_INVESTORSYSTEMID, delimiters));
    __sb.append(fieldDelim);
    // special case for strings hive, droppingdelimiters \n,\r,\01 from strings
    __sb.append(FieldFormatter.hiveStringDropDelims(VC_VOUCHERNO==null?"\\N":VC_VOUCHERNO, delimiters));
    __sb.append(fieldDelim);
    // special case for strings hive, droppingdelimiters \n,\r,\01 from strings
    __sb.append(FieldFormatter.hiveStringDropDelims(C_BANKNO==null?"\\N":C_BANKNO, delimiters));
    __sb.append(fieldDelim);
    // special case for strings hive, droppingdelimiters \n,\r,\01 from strings
    __sb.append(FieldFormatter.hiveStringDropDelims(VC_BANKNAME==null?"\\N":VC_BANKNAME, delimiters));
    __sb.append(fieldDelim);
    // special case for strings hive, droppingdelimiters \n,\r,\01 from strings
    __sb.append(FieldFormatter.hiveStringDropDelims(VC_NAMEINBANK==null?"\\N":VC_NAMEINBANK, delimiters));
    __sb.append(fieldDelim);
    // special case for strings hive, droppingdelimiters \n,\r,\01 from strings
    __sb.append(FieldFormatter.hiveStringDropDelims(VC_BANKACCO==null?"\\N":VC_BANKACCO, delimiters));
    __sb.append(fieldDelim);
    // special case for strings hive, droppingdelimiters \n,\r,\01 from strings
    __sb.append(FieldFormatter.hiveStringDropDelims(VC_CUSTNO==null?"\\N":VC_CUSTNO, delimiters));
    __sb.append(fieldDelim);
    // special case for strings hive, droppingdelimiters \n,\r,\01 from strings
    __sb.append(FieldFormatter.hiveStringDropDelims(VC_CONFIRMSETTLEDATE==null?"\\N":VC_CONFIRMSETTLEDATE, delimiters));
    __sb.append(fieldDelim);
    // special case for strings hive, droppingdelimiters \n,\r,\01 from strings
    __sb.append(FieldFormatter.hiveStringDropDelims(VC_REQUESTSETTLEDATE==null?"\\N":VC_REQUESTSETTLEDATE, delimiters));
    __sb.append(fieldDelim);
    // special case for strings hive, droppingdelimiters \n,\r,\01 from strings
    __sb.append(FieldFormatter.hiveStringDropDelims(VC_CONTRACTSERIALNO==null?"\\N":VC_CONTRACTSERIALNO, delimiters));
    __sb.append(fieldDelim);
    // special case for strings hive, droppingdelimiters \n,\r,\01 from strings
    __sb.append(FieldFormatter.hiveStringDropDelims(C_PROFITCLASS==null?"\\N":C_PROFITCLASS, delimiters));
    __sb.append(fieldDelim);
    // special case for strings hive, droppingdelimiters \n,\r,\01 from strings
    __sb.append(FieldFormatter.hiveStringDropDelims(VC_COMBREQUESTNO==null?"\\N":VC_COMBREQUESTNO, delimiters));
    __sb.append(fieldDelim);
    // special case for strings hive, droppingdelimiters \n,\r,\01 from strings
    __sb.append(FieldFormatter.hiveStringDropDelims(VC_COMBCODE==null?"\\N":VC_COMBCODE, delimiters));
    __sb.append(fieldDelim);
    // special case for strings hive, droppingdelimiters \n,\r,\01 from strings
    __sb.append(FieldFormatter.hiveStringDropDelims(C_AUTOREQUEST==null?"\\N":C_AUTOREQUEST, delimiters));
    __sb.append(fieldDelim);
    // special case for strings hive, droppingdelimiters \n,\r,\01 from strings
    __sb.append(FieldFormatter.hiveStringDropDelims(VC_EXPLAIN==null?"\\N":VC_EXPLAIN, delimiters));
    __sb.append(fieldDelim);
    // special case for strings hive, droppingdelimiters \n,\r,\01 from strings
    __sb.append(FieldFormatter.hiveStringDropDelims(C_INTERFACETYPE==null?"\\N":C_INTERFACETYPE, delimiters));
    __sb.append(fieldDelim);
    __sb.append(FieldFormatter.escapeAndEnclose(EN_OTHERFEE1==null?"\\N":EN_OTHERFEE1.toPlainString(), delimiters));
    __sb.append(fieldDelim);
    __sb.append(FieldFormatter.escapeAndEnclose(EN_OTHERFEE2==null?"\\N":EN_OTHERFEE2.toPlainString(), delimiters));
    __sb.append(fieldDelim);
    // special case for strings hive, droppingdelimiters \n,\r,\01 from strings
    __sb.append(FieldFormatter.hiveStringDropDelims(C_MATCHFLAG==null?"\\N":C_MATCHFLAG, delimiters));
    __sb.append(fieldDelim);
    // special case for strings hive, droppingdelimiters \n,\r,\01 from strings
    __sb.append(FieldFormatter.hiveStringDropDelims(VC_BOOKID==null?"\\N":VC_BOOKID, delimiters));
    __sb.append(fieldDelim);
    __sb.append(FieldFormatter.escapeAndEnclose(EN_GRAMNUM==null?"\\N":EN_GRAMNUM.toPlainString(), delimiters));
    __sb.append(fieldDelim);
    // special case for strings hive, droppingdelimiters \n,\r,\01 from strings
    __sb.append(FieldFormatter.hiveStringDropDelims(C_FORCEREDEEMREASON==null?"\\N":C_FORCEREDEEMREASON, delimiters));
    __sb.append(fieldDelim);
    __sb.append(FieldFormatter.escapeAndEnclose(EN_TOTALFROZENSHARE==null?"\\N":EN_TOTALFROZENSHARE.toPlainString(), delimiters));
    __sb.append(fieldDelim);
    __sb.append(FieldFormatter.escapeAndEnclose(EN_FUNDSHAREBALANCE==null?"\\N":EN_FUNDSHAREBALANCE.toPlainString(), delimiters));
    __sb.append(fieldDelim);
    __sb.append(FieldFormatter.escapeAndEnclose(EN_FROZENBALANCE==null?"\\N":EN_FROZENBALANCE.toPlainString(), delimiters));
    __sb.append(fieldDelim);
    // special case for strings hive, droppingdelimiters \n,\r,\01 from strings
    __sb.append(FieldFormatter.hiveStringDropDelims(VC_FUTURESUBSCRIBEDATE==null?"\\N":VC_FUTURESUBSCRIBEDATE, delimiters));
    __sb.append(fieldDelim);
    // special case for strings hive, droppingdelimiters \n,\r,\01 from strings
    __sb.append(FieldFormatter.hiveStringDropDelims(VC_TRANSFERDATEFROMAGENCY==null?"\\N":VC_TRANSFERDATEFROMAGENCY, delimiters));
    __sb.append(fieldDelim);
    __sb.append(FieldFormatter.escapeAndEnclose(EN_TAXADVANAMOUNT==null?"\\N":EN_TAXADVANAMOUNT.toPlainString(), delimiters));
    __sb.append(fieldDelim);
    // special case for strings hive, droppingdelimiters \n,\r,\01 from strings
    __sb.append(FieldFormatter.hiveStringDropDelims(VC_TAXADVANCODE==null?"\\N":VC_TAXADVANCODE, delimiters));
    __sb.append(fieldDelim);
    // special case for strings hive, droppingdelimiters \n,\r,\01 from strings
    __sb.append(FieldFormatter.hiveStringDropDelims(VC_OTHERSERIALNO==null?"\\N":VC_OTHERSERIALNO, delimiters));
    __sb.append(fieldDelim);
    // special case for strings hive, droppingdelimiters \n,\r,\01 from strings
    __sb.append(FieldFormatter.hiveStringDropDelims(C_ATTENDQUITFLAG==null?"\\N":C_ATTENDQUITFLAG, delimiters));
    __sb.append(fieldDelim);
    // special case for strings hive, droppingdelimiters \n,\r,\01 from strings
    __sb.append(FieldFormatter.hiveStringDropDelims(VC_CUSTOMNAME_GS==null?"\\N":VC_CUSTOMNAME_GS, delimiters));
    __sb.append(fieldDelim);
    // special case for strings hive, droppingdelimiters \n,\r,\01 from strings
    __sb.append(FieldFormatter.hiveStringDropDelims(C_IDENTITYTYPE_GS==null?"\\N":C_IDENTITYTYPE_GS, delimiters));
    __sb.append(fieldDelim);
    // special case for strings hive, droppingdelimiters \n,\r,\01 from strings
    __sb.append(FieldFormatter.hiveStringDropDelims(VC_IDENTITYNO_GS==null?"\\N":VC_IDENTITYNO_GS, delimiters));
    __sb.append(fieldDelim);
    // special case for strings hive, droppingdelimiters \n,\r,\01 from strings
    __sb.append(FieldFormatter.hiveStringDropDelims(VC_NATIONALITY_GS==null?"\\N":VC_NATIONALITY_GS, delimiters));
    __sb.append(fieldDelim);
    // special case for strings hive, droppingdelimiters \n,\r,\01 from strings
    __sb.append(FieldFormatter.hiveStringDropDelims(VC_CERTCODE_GS==null?"\\N":VC_CERTCODE_GS, delimiters));
    __sb.append(fieldDelim);
    // special case for strings hive, droppingdelimiters \n,\r,\01 from strings
    __sb.append(FieldFormatter.hiveStringDropDelims(VC_CERTDATE_GS==null?"\\N":VC_CERTDATE_GS, delimiters));
    __sb.append(fieldDelim);
    __sb.append(FieldFormatter.escapeAndEnclose(EN_ACCTAXPRETAKEOFF_GS==null?"\\N":EN_ACCTAXPRETAKEOFF_GS.toPlainString(), delimiters));
    __sb.append(fieldDelim);
    // special case for strings hive, droppingdelimiters \n,\r,\01 from strings
    __sb.append(FieldFormatter.hiveStringDropDelims(INSERTTIME==null?"\\N":INSERTTIME, delimiters));
    __sb.append(fieldDelim);
    // special case for strings hive, droppingdelimiters \n,\r,\01 from strings
    __sb.append(FieldFormatter.hiveStringDropDelims(UPDATETIME==null?"\\N":UPDATETIME, delimiters));
    __sb.append(fieldDelim);
    __sb.append(FieldFormatter.escapeAndEnclose(_20210422==null?"\\N":_20210422.toPlainString(), delimiters));
    __sb.append(fieldDelim);
    // special case for strings hive, droppingdelimiters \n,\r,\01 from strings
    __sb.append(FieldFormatter.hiveStringDropDelims(_SALES_==null?"\\N":_SALES_, delimiters));
    if (useRecordDelim) {
      __sb.append(delimiters.getLinesTerminatedBy());
    }
    return __sb.toString();
  }
  public void toString0(DelimiterSet delimiters, StringBuilder __sb, char fieldDelim) {
    // special case for strings hive, droppingdelimiters \n,\r,\01 from strings
    __sb.append(FieldFormatter.hiveStringDropDelims(C_CUSTTYPE==null?"\\N":C_CUSTTYPE, delimiters));
    __sb.append(fieldDelim);
    // special case for strings hive, droppingdelimiters \n,\r,\01 from strings
    __sb.append(FieldFormatter.hiveStringDropDelims(VC_FUNDACCO==null?"\\N":VC_FUNDACCO, delimiters));
    __sb.append(fieldDelim);
    // special case for strings hive, droppingdelimiters \n,\r,\01 from strings
    __sb.append(FieldFormatter.hiveStringDropDelims(VC_TRADEACCO==null?"\\N":VC_TRADEACCO, delimiters));
    __sb.append(fieldDelim);
    // special case for strings hive, droppingdelimiters \n,\r,\01 from strings
    __sb.append(FieldFormatter.hiveStringDropDelims(C_TRUST==null?"\\N":C_TRUST, delimiters));
    __sb.append(fieldDelim);
    // special case for strings hive, droppingdelimiters \n,\r,\01 from strings
    __sb.append(FieldFormatter.hiveStringDropDelims(VC_REQUESTDATE==null?"\\N":VC_REQUESTDATE, delimiters));
    __sb.append(fieldDelim);
    // special case for strings hive, droppingdelimiters \n,\r,\01 from strings
    __sb.append(FieldFormatter.hiveStringDropDelims(VC_REQUESTNO==null?"\\N":VC_REQUESTNO, delimiters));
    __sb.append(fieldDelim);
    // special case for strings hive, droppingdelimiters \n,\r,\01 from strings
    __sb.append(FieldFormatter.hiveStringDropDelims(VC_CONFIRMNO==null?"\\N":VC_CONFIRMNO, delimiters));
    __sb.append(fieldDelim);
    // special case for strings hive, droppingdelimiters \n,\r,\01 from strings
    __sb.append(FieldFormatter.hiveStringDropDelims(VC_CONFIRMDATE==null?"\\N":VC_CONFIRMDATE, delimiters));
    __sb.append(fieldDelim);
    // special case for strings hive, droppingdelimiters \n,\r,\01 from strings
    __sb.append(FieldFormatter.hiveStringDropDelims(VC_FUNDCODE==null?"\\N":VC_FUNDCODE, delimiters));
    __sb.append(fieldDelim);
    // special case for strings hive, droppingdelimiters \n,\r,\01 from strings
    __sb.append(FieldFormatter.hiveStringDropDelims(C_SHARETYPE==null?"\\N":C_SHARETYPE, delimiters));
    __sb.append(fieldDelim);
    // special case for strings hive, droppingdelimiters \n,\r,\01 from strings
    __sb.append(FieldFormatter.hiveStringDropDelims(VC_NETNO==null?"\\N":VC_NETNO, delimiters));
    __sb.append(fieldDelim);
    // special case for strings hive, droppingdelimiters \n,\r,\01 from strings
    __sb.append(FieldFormatter.hiveStringDropDelims(VC_CENTERNO==null?"\\N":VC_CENTERNO, delimiters));
    __sb.append(fieldDelim);
    __sb.append(FieldFormatter.escapeAndEnclose(EN_RATIO==null?"\\N":EN_RATIO.toPlainString(), delimiters));
    __sb.append(fieldDelim);
    __sb.append(FieldFormatter.escapeAndEnclose(EN_NAV==null?"\\N":EN_NAV.toPlainString(), delimiters));
    __sb.append(fieldDelim);
    __sb.append(FieldFormatter.escapeAndEnclose(EN_PROFIT==null?"\\N":EN_PROFIT.toPlainString(), delimiters));
    __sb.append(fieldDelim);
    // special case for strings hive, droppingdelimiters \n,\r,\01 from strings
    __sb.append(FieldFormatter.hiveStringDropDelims(C_BUSINFLAG==null?"\\N":C_BUSINFLAG, delimiters));
    __sb.append(fieldDelim);
    __sb.append(FieldFormatter.escapeAndEnclose(EN_BALANCE==null?"\\N":EN_BALANCE.toPlainString(), delimiters));
    __sb.append(fieldDelim);
    __sb.append(FieldFormatter.escapeAndEnclose(EN_SHARE==null?"\\N":EN_SHARE.toPlainString(), delimiters));
    __sb.append(fieldDelim);
    __sb.append(FieldFormatter.escapeAndEnclose(EN_CONFIRMBALA==null?"\\N":EN_CONFIRMBALA.toPlainString(), delimiters));
    __sb.append(fieldDelim);
    // special case for strings hive, droppingdelimiters \n,\r,\01 from strings
    __sb.append(FieldFormatter.hiveStringDropDelims(C_MONEYTYPE==null?"\\N":C_MONEYTYPE, delimiters));
    __sb.append(fieldDelim);
    __sb.append(FieldFormatter.escapeAndEnclose(EN_CONFIRMSHARE==null?"\\N":EN_CONFIRMSHARE.toPlainString(), delimiters));
    __sb.append(fieldDelim);
    __sb.append(FieldFormatter.escapeAndEnclose(EN_FARE==null?"\\N":EN_FARE.toPlainString(), delimiters));
    __sb.append(fieldDelim);
    __sb.append(FieldFormatter.escapeAndEnclose(EN_DEALFARE==null?"\\N":EN_DEALFARE.toPlainString(), delimiters));
    __sb.append(fieldDelim);
    __sb.append(FieldFormatter.escapeAndEnclose(EN_TAFARE==null?"\\N":EN_TAFARE.toPlainString(), delimiters));
    __sb.append(fieldDelim);
    __sb.append(FieldFormatter.escapeAndEnclose(EN_AFTERFARE==null?"\\N":EN_AFTERFARE.toPlainString(), delimiters));
    __sb.append(fieldDelim);
    __sb.append(FieldFormatter.escapeAndEnclose(EN_AGENCYFARE==null?"\\N":EN_AGENCYFARE.toPlainString(), delimiters));
    __sb.append(fieldDelim);
    __sb.append(FieldFormatter.escapeAndEnclose(EN_STAMPTAX==null?"\\N":EN_STAMPTAX.toPlainString(), delimiters));
    __sb.append(fieldDelim);
    // special case for strings hive, droppingdelimiters \n,\r,\01 from strings
    __sb.append(FieldFormatter.hiveStringDropDelims(C_CONFIRMFLAG==null?"\\N":C_CONFIRMFLAG, delimiters));
    __sb.append(fieldDelim);
    // special case for strings hive, droppingdelimiters \n,\r,\01 from strings
    __sb.append(FieldFormatter.hiveStringDropDelims(VC_ERRORCODE==null?"\\N":VC_ERRORCODE, delimiters));
    __sb.append(fieldDelim);
    // special case for strings hive, droppingdelimiters \n,\r,\01 from strings
    __sb.append(FieldFormatter.hiveStringDropDelims(VC_ERRORCAUSE==null?"\\N":VC_ERRORCAUSE, delimiters));
    __sb.append(fieldDelim);
    // special case for strings hive, droppingdelimiters \n,\r,\01 from strings
    __sb.append(FieldFormatter.hiveStringDropDelims(C_VOUCHERFLAG==null?"\\N":C_VOUCHERFLAG, delimiters));
    __sb.append(fieldDelim);
    __sb.append(FieldFormatter.escapeAndEnclose(EN_INTEREST==null?"\\N":EN_INTEREST.toPlainString(), delimiters));
    __sb.append(fieldDelim);
    __sb.append(FieldFormatter.escapeAndEnclose(EN_INTERESTTAX==null?"\\N":EN_INTERESTTAX.toPlainString(), delimiters));
    __sb.append(fieldDelim);
    // special case for strings hive, droppingdelimiters \n,\r,\01 from strings
    __sb.append(FieldFormatter.hiveStringDropDelims(C_ORGANIGER==null?"\\N":C_ORGANIGER, delimiters));
    __sb.append(fieldDelim);
    // special case for strings hive, droppingdelimiters \n,\r,\01 from strings
    __sb.append(FieldFormatter.hiveStringDropDelims(VC_OTHERACCO==null?"\\N":VC_OTHERACCO, delimiters));
    __sb.append(fieldDelim);
    // special case for strings hive, droppingdelimiters \n,\r,\01 from strings
    __sb.append(FieldFormatter.hiveStringDropDelims(VC_OTHERTRADEACCO==null?"\\N":VC_OTHERTRADEACCO, delimiters));
    __sb.append(fieldDelim);
    // special case for strings hive, droppingdelimiters \n,\r,\01 from strings
    __sb.append(FieldFormatter.hiveStringDropDelims(C_OTHERAGENCYNO==null?"\\N":C_OTHERAGENCYNO, delimiters));
    __sb.append(fieldDelim);
    // special case for strings hive, droppingdelimiters \n,\r,\01 from strings
    __sb.append(FieldFormatter.hiveStringDropDelims(VC_OTHERNETNO==null?"\\N":VC_OTHERNETNO, delimiters));
    __sb.append(fieldDelim);
    // special case for strings hive, droppingdelimiters \n,\r,\01 from strings
    __sb.append(FieldFormatter.hiveStringDropDelims(VC_OTHERFUNDCODE==null?"\\N":VC_OTHERFUNDCODE, delimiters));
    __sb.append(fieldDelim);
    // special case for strings hive, droppingdelimiters \n,\r,\01 from strings
    __sb.append(FieldFormatter.hiveStringDropDelims(C_OTHERSHARETYPE==null?"\\N":C_OTHERSHARETYPE, delimiters));
    __sb.append(fieldDelim);
    __sb.append(FieldFormatter.escapeAndEnclose(EN_UNFROZENBALA==null?"\\N":EN_UNFROZENBALA.toPlainString(), delimiters));
    __sb.append(fieldDelim);
    __sb.append(FieldFormatter.escapeAndEnclose(EN_RETURNFARE==null?"\\N":EN_RETURNFARE.toPlainString(), delimiters));
    __sb.append(fieldDelim);
    __sb.append(FieldFormatter.escapeAndEnclose(EN_ORIGINFARE==null?"\\N":EN_ORIGINFARE.toPlainString(), delimiters));
    __sb.append(fieldDelim);
    // special case for strings hive, droppingdelimiters \n,\r,\01 from strings
    __sb.append(FieldFormatter.hiveStringDropDelims(VC_BROKER==null?"\\N":VC_BROKER, delimiters));
    __sb.append(fieldDelim);
    // special case for strings hive, droppingdelimiters \n,\r,\01 from strings
    __sb.append(FieldFormatter.hiveStringDropDelims(C_DIVIDENDMETHOD==null?"\\N":C_DIVIDENDMETHOD, delimiters));
    __sb.append(fieldDelim);
    // special case for strings hive, droppingdelimiters \n,\r,\01 from strings
    __sb.append(FieldFormatter.hiveStringDropDelims(C_FROZENCAUSE==null?"\\N":C_FROZENCAUSE, delimiters));
    __sb.append(fieldDelim);
    // special case for strings hive, droppingdelimiters \n,\r,\01 from strings
    __sb.append(FieldFormatter.hiveStringDropDelims(VC_ORIGINNO==null?"\\N":VC_ORIGINNO, delimiters));
    __sb.append(fieldDelim);
    // special case for strings hive, droppingdelimiters \n,\r,\01 from strings
    __sb.append(FieldFormatter.hiveStringDropDelims(VC_CITYNO==null?"\\N":VC_CITYNO, delimiters));
    __sb.append(fieldDelim);
    // special case for strings hive, droppingdelimiters \n,\r,\01 from strings
    __sb.append(FieldFormatter.hiveStringDropDelims(VC_SELLER==null?"\\N":VC_SELLER, delimiters));
    __sb.append(fieldDelim);
    // special case for strings hive, droppingdelimiters \n,\r,\01 from strings
    __sb.append(FieldFormatter.hiveStringDropDelims(VC_TACODE==null?"\\N":VC_TACODE, delimiters));
    __sb.append(fieldDelim);
    __sb.append(FieldFormatter.escapeAndEnclose(EN_DISCOUNT==null?"\\N":EN_DISCOUNT.toPlainString(), delimiters));
    __sb.append(fieldDelim);
    __sb.append(FieldFormatter.escapeAndEnclose(EN_INCOME==null?"\\N":EN_INCOME.toPlainString(), delimiters));
    __sb.append(fieldDelim);
    __sb.append(FieldFormatter.escapeAndEnclose(EN_INVESTINCOME==null?"\\N":EN_INVESTINCOME.toPlainString(), delimiters));
    __sb.append(fieldDelim);
    __sb.append(FieldFormatter.escapeAndEnclose(EN_INVESTSHARE==null?"\\N":EN_INVESTSHARE.toPlainString(), delimiters));
    __sb.append(fieldDelim);
    // special case for strings hive, droppingdelimiters \n,\r,\01 from strings
    __sb.append(FieldFormatter.hiveStringDropDelims(C_FINISHFLAG==null?"\\N":C_FINISHFLAG, delimiters));
    __sb.append(fieldDelim);
    // special case for strings hive, droppingdelimiters \n,\r,\01 from strings
    __sb.append(FieldFormatter.hiveStringDropDelims(C_INTERESTFLAG==null?"\\N":C_INTERESTFLAG, delimiters));
    __sb.append(fieldDelim);
    // special case for strings hive, droppingdelimiters \n,\r,\01 from strings
    __sb.append(FieldFormatter.hiveStringDropDelims(C_CONFIRMSTATUS==null?"\\N":C_CONFIRMSTATUS, delimiters));
    __sb.append(fieldDelim);
    __sb.append(FieldFormatter.escapeAndEnclose(EN_OTHERDISCOUNT==null?"\\N":EN_OTHERDISCOUNT.toPlainString(), delimiters));
    __sb.append(fieldDelim);
    __sb.append(FieldFormatter.escapeAndEnclose(EN_ENDDISCOUNT==null?"\\N":EN_ENDDISCOUNT.toPlainString(), delimiters));
    __sb.append(fieldDelim);
    // special case for strings hive, droppingdelimiters \n,\r,\01 from strings
    __sb.append(FieldFormatter.hiveStringDropDelims(VC_LIQUIDATEDATE==null?"\\N":VC_LIQUIDATEDATE, delimiters));
    __sb.append(fieldDelim);
    // special case for strings hive, droppingdelimiters \n,\r,\01 from strings
    __sb.append(FieldFormatter.hiveStringDropDelims(C_SENDFLAG==null?"\\N":C_SENDFLAG, delimiters));
    __sb.append(fieldDelim);
    // special case for strings hive, droppingdelimiters \n,\r,\01 from strings
    __sb.append(FieldFormatter.hiveStringDropDelims(VC_BRANCHCODE==null?"\\N":VC_BRANCHCODE, delimiters));
    __sb.append(fieldDelim);
    __sb.append(FieldFormatter.escapeAndEnclose(EN_OTHERNAV==null?"\\N":EN_OTHERNAV.toPlainString(), delimiters));
    __sb.append(fieldDelim);
    __sb.append(FieldFormatter.escapeAndEnclose(EN_OTHERCONFIRMSHARE==null?"\\N":EN_OTHERCONFIRMSHARE.toPlainString(), delimiters));
    __sb.append(fieldDelim);
    __sb.append(FieldFormatter.escapeAndEnclose(EN_OTHERORIGINFARE==null?"\\N":EN_OTHERORIGINFARE.toPlainString(), delimiters));
    __sb.append(fieldDelim);
    // special case for strings hive, droppingdelimiters \n,\r,\01 from strings
    __sb.append(FieldFormatter.hiveStringDropDelims(C_FIXBUSINFLAG==null?"\\N":C_FIXBUSINFLAG, delimiters));
    __sb.append(fieldDelim);
    // special case for strings hive, droppingdelimiters \n,\r,\01 from strings
    __sb.append(FieldFormatter.hiveStringDropDelims(C_CAPITALMODE==null?"\\N":C_CAPITALMODE, delimiters));
    __sb.append(fieldDelim);
    // special case for strings hive, droppingdelimiters \n,\r,\01 from strings
    __sb.append(FieldFormatter.hiveStringDropDelims(C_SUBCAPITALMODE==null?"\\N":C_SUBCAPITALMODE, delimiters));
    __sb.append(fieldDelim);
    // special case for strings hive, droppingdelimiters \n,\r,\01 from strings
    __sb.append(FieldFormatter.hiveStringDropDelims(VC_ORIGINCONFIRMNO==null?"\\N":VC_ORIGINCONFIRMNO, delimiters));
    __sb.append(fieldDelim);
    // special case for strings hive, droppingdelimiters \n,\r,\01 from strings
    __sb.append(FieldFormatter.hiveStringDropDelims(C_BUSINTYPE==null?"\\N":C_BUSINTYPE, delimiters));
    __sb.append(fieldDelim);
    __sb.append(FieldFormatter.escapeAndEnclose(L_SECTIONSCHEMANO==null?"\\N":L_SECTIONSCHEMANO.toPlainString(), delimiters));
    __sb.append(fieldDelim);
    // special case for strings hive, droppingdelimiters \n,\r,\01 from strings
    __sb.append(FieldFormatter.hiveStringDropDelims(C_EXPTYPE==null?"\\N":C_EXPTYPE, delimiters));
    __sb.append(fieldDelim);
    // special case for strings hive, droppingdelimiters \n,\r,\01 from strings
    __sb.append(FieldFormatter.hiveStringDropDelims(C_SHAREADJUSTFLAG==null?"\\N":C_SHAREADJUSTFLAG, delimiters));
    __sb.append(fieldDelim);
    // special case for strings hive, droppingdelimiters \n,\r,\01 from strings
    __sb.append(FieldFormatter.hiveStringDropDelims(C_INCOMEFLAG==null?"\\N":C_INCOMEFLAG, delimiters));
    __sb.append(fieldDelim);
    __sb.append(FieldFormatter.escapeAndEnclose(EN_ACHIEVEMENTPAY==null?"\\N":EN_ACHIEVEMENTPAY.toPlainString(), delimiters));
    __sb.append(fieldDelim);
    __sb.append(FieldFormatter.escapeAndEnclose(EN_BREACHFEE==null?"\\N":EN_BREACHFEE.toPlainString(), delimiters));
    __sb.append(fieldDelim);
    // special case for strings hive, droppingdelimiters \n,\r,\01 from strings
    __sb.append(FieldFormatter.hiveStringDropDelims(VC_COMEFROM==null?"\\N":VC_COMEFROM, delimiters));
    __sb.append(fieldDelim);
    // special case for strings hive, droppingdelimiters \n,\r,\01 from strings
    __sb.append(FieldFormatter.hiveStringDropDelims(VC_INVESTORSYSTEMID==null?"\\N":VC_INVESTORSYSTEMID, delimiters));
    __sb.append(fieldDelim);
    // special case for strings hive, droppingdelimiters \n,\r,\01 from strings
    __sb.append(FieldFormatter.hiveStringDropDelims(VC_VOUCHERNO==null?"\\N":VC_VOUCHERNO, delimiters));
    __sb.append(fieldDelim);
    // special case for strings hive, droppingdelimiters \n,\r,\01 from strings
    __sb.append(FieldFormatter.hiveStringDropDelims(C_BANKNO==null?"\\N":C_BANKNO, delimiters));
    __sb.append(fieldDelim);
    // special case for strings hive, droppingdelimiters \n,\r,\01 from strings
    __sb.append(FieldFormatter.hiveStringDropDelims(VC_BANKNAME==null?"\\N":VC_BANKNAME, delimiters));
    __sb.append(fieldDelim);
    // special case for strings hive, droppingdelimiters \n,\r,\01 from strings
    __sb.append(FieldFormatter.hiveStringDropDelims(VC_NAMEINBANK==null?"\\N":VC_NAMEINBANK, delimiters));
    __sb.append(fieldDelim);
    // special case for strings hive, droppingdelimiters \n,\r,\01 from strings
    __sb.append(FieldFormatter.hiveStringDropDelims(VC_BANKACCO==null?"\\N":VC_BANKACCO, delimiters));
    __sb.append(fieldDelim);
    // special case for strings hive, droppingdelimiters \n,\r,\01 from strings
    __sb.append(FieldFormatter.hiveStringDropDelims(VC_CUSTNO==null?"\\N":VC_CUSTNO, delimiters));
    __sb.append(fieldDelim);
    // special case for strings hive, droppingdelimiters \n,\r,\01 from strings
    __sb.append(FieldFormatter.hiveStringDropDelims(VC_CONFIRMSETTLEDATE==null?"\\N":VC_CONFIRMSETTLEDATE, delimiters));
    __sb.append(fieldDelim);
    // special case for strings hive, droppingdelimiters \n,\r,\01 from strings
    __sb.append(FieldFormatter.hiveStringDropDelims(VC_REQUESTSETTLEDATE==null?"\\N":VC_REQUESTSETTLEDATE, delimiters));
    __sb.append(fieldDelim);
    // special case for strings hive, droppingdelimiters \n,\r,\01 from strings
    __sb.append(FieldFormatter.hiveStringDropDelims(VC_CONTRACTSERIALNO==null?"\\N":VC_CONTRACTSERIALNO, delimiters));
    __sb.append(fieldDelim);
    // special case for strings hive, droppingdelimiters \n,\r,\01 from strings
    __sb.append(FieldFormatter.hiveStringDropDelims(C_PROFITCLASS==null?"\\N":C_PROFITCLASS, delimiters));
    __sb.append(fieldDelim);
    // special case for strings hive, droppingdelimiters \n,\r,\01 from strings
    __sb.append(FieldFormatter.hiveStringDropDelims(VC_COMBREQUESTNO==null?"\\N":VC_COMBREQUESTNO, delimiters));
    __sb.append(fieldDelim);
    // special case for strings hive, droppingdelimiters \n,\r,\01 from strings
    __sb.append(FieldFormatter.hiveStringDropDelims(VC_COMBCODE==null?"\\N":VC_COMBCODE, delimiters));
    __sb.append(fieldDelim);
    // special case for strings hive, droppingdelimiters \n,\r,\01 from strings
    __sb.append(FieldFormatter.hiveStringDropDelims(C_AUTOREQUEST==null?"\\N":C_AUTOREQUEST, delimiters));
    __sb.append(fieldDelim);
    // special case for strings hive, droppingdelimiters \n,\r,\01 from strings
    __sb.append(FieldFormatter.hiveStringDropDelims(VC_EXPLAIN==null?"\\N":VC_EXPLAIN, delimiters));
    __sb.append(fieldDelim);
    // special case for strings hive, droppingdelimiters \n,\r,\01 from strings
    __sb.append(FieldFormatter.hiveStringDropDelims(C_INTERFACETYPE==null?"\\N":C_INTERFACETYPE, delimiters));
    __sb.append(fieldDelim);
    __sb.append(FieldFormatter.escapeAndEnclose(EN_OTHERFEE1==null?"\\N":EN_OTHERFEE1.toPlainString(), delimiters));
    __sb.append(fieldDelim);
    __sb.append(FieldFormatter.escapeAndEnclose(EN_OTHERFEE2==null?"\\N":EN_OTHERFEE2.toPlainString(), delimiters));
    __sb.append(fieldDelim);
    // special case for strings hive, droppingdelimiters \n,\r,\01 from strings
    __sb.append(FieldFormatter.hiveStringDropDelims(C_MATCHFLAG==null?"\\N":C_MATCHFLAG, delimiters));
    __sb.append(fieldDelim);
    // special case for strings hive, droppingdelimiters \n,\r,\01 from strings
    __sb.append(FieldFormatter.hiveStringDropDelims(VC_BOOKID==null?"\\N":VC_BOOKID, delimiters));
    __sb.append(fieldDelim);
    __sb.append(FieldFormatter.escapeAndEnclose(EN_GRAMNUM==null?"\\N":EN_GRAMNUM.toPlainString(), delimiters));
    __sb.append(fieldDelim);
    // special case for strings hive, droppingdelimiters \n,\r,\01 from strings
    __sb.append(FieldFormatter.hiveStringDropDelims(C_FORCEREDEEMREASON==null?"\\N":C_FORCEREDEEMREASON, delimiters));
    __sb.append(fieldDelim);
    __sb.append(FieldFormatter.escapeAndEnclose(EN_TOTALFROZENSHARE==null?"\\N":EN_TOTALFROZENSHARE.toPlainString(), delimiters));
    __sb.append(fieldDelim);
    __sb.append(FieldFormatter.escapeAndEnclose(EN_FUNDSHAREBALANCE==null?"\\N":EN_FUNDSHAREBALANCE.toPlainString(), delimiters));
    __sb.append(fieldDelim);
    __sb.append(FieldFormatter.escapeAndEnclose(EN_FROZENBALANCE==null?"\\N":EN_FROZENBALANCE.toPlainString(), delimiters));
    __sb.append(fieldDelim);
    // special case for strings hive, droppingdelimiters \n,\r,\01 from strings
    __sb.append(FieldFormatter.hiveStringDropDelims(VC_FUTURESUBSCRIBEDATE==null?"\\N":VC_FUTURESUBSCRIBEDATE, delimiters));
    __sb.append(fieldDelim);
    // special case for strings hive, droppingdelimiters \n,\r,\01 from strings
    __sb.append(FieldFormatter.hiveStringDropDelims(VC_TRANSFERDATEFROMAGENCY==null?"\\N":VC_TRANSFERDATEFROMAGENCY, delimiters));
    __sb.append(fieldDelim);
    __sb.append(FieldFormatter.escapeAndEnclose(EN_TAXADVANAMOUNT==null?"\\N":EN_TAXADVANAMOUNT.toPlainString(), delimiters));
    __sb.append(fieldDelim);
    // special case for strings hive, droppingdelimiters \n,\r,\01 from strings
    __sb.append(FieldFormatter.hiveStringDropDelims(VC_TAXADVANCODE==null?"\\N":VC_TAXADVANCODE, delimiters));
    __sb.append(fieldDelim);
    // special case for strings hive, droppingdelimiters \n,\r,\01 from strings
    __sb.append(FieldFormatter.hiveStringDropDelims(VC_OTHERSERIALNO==null?"\\N":VC_OTHERSERIALNO, delimiters));
    __sb.append(fieldDelim);
    // special case for strings hive, droppingdelimiters \n,\r,\01 from strings
    __sb.append(FieldFormatter.hiveStringDropDelims(C_ATTENDQUITFLAG==null?"\\N":C_ATTENDQUITFLAG, delimiters));
    __sb.append(fieldDelim);
    // special case for strings hive, droppingdelimiters \n,\r,\01 from strings
    __sb.append(FieldFormatter.hiveStringDropDelims(VC_CUSTOMNAME_GS==null?"\\N":VC_CUSTOMNAME_GS, delimiters));
    __sb.append(fieldDelim);
    // special case for strings hive, droppingdelimiters \n,\r,\01 from strings
    __sb.append(FieldFormatter.hiveStringDropDelims(C_IDENTITYTYPE_GS==null?"\\N":C_IDENTITYTYPE_GS, delimiters));
    __sb.append(fieldDelim);
    // special case for strings hive, droppingdelimiters \n,\r,\01 from strings
    __sb.append(FieldFormatter.hiveStringDropDelims(VC_IDENTITYNO_GS==null?"\\N":VC_IDENTITYNO_GS, delimiters));
    __sb.append(fieldDelim);
    // special case for strings hive, droppingdelimiters \n,\r,\01 from strings
    __sb.append(FieldFormatter.hiveStringDropDelims(VC_NATIONALITY_GS==null?"\\N":VC_NATIONALITY_GS, delimiters));
    __sb.append(fieldDelim);
    // special case for strings hive, droppingdelimiters \n,\r,\01 from strings
    __sb.append(FieldFormatter.hiveStringDropDelims(VC_CERTCODE_GS==null?"\\N":VC_CERTCODE_GS, delimiters));
    __sb.append(fieldDelim);
    // special case for strings hive, droppingdelimiters \n,\r,\01 from strings
    __sb.append(FieldFormatter.hiveStringDropDelims(VC_CERTDATE_GS==null?"\\N":VC_CERTDATE_GS, delimiters));
    __sb.append(fieldDelim);
    __sb.append(FieldFormatter.escapeAndEnclose(EN_ACCTAXPRETAKEOFF_GS==null?"\\N":EN_ACCTAXPRETAKEOFF_GS.toPlainString(), delimiters));
    __sb.append(fieldDelim);
    // special case for strings hive, droppingdelimiters \n,\r,\01 from strings
    __sb.append(FieldFormatter.hiveStringDropDelims(INSERTTIME==null?"\\N":INSERTTIME, delimiters));
    __sb.append(fieldDelim);
    // special case for strings hive, droppingdelimiters \n,\r,\01 from strings
    __sb.append(FieldFormatter.hiveStringDropDelims(UPDATETIME==null?"\\N":UPDATETIME, delimiters));
    __sb.append(fieldDelim);
    __sb.append(FieldFormatter.escapeAndEnclose(_20210422==null?"\\N":_20210422.toPlainString(), delimiters));
    __sb.append(fieldDelim);
    // special case for strings hive, droppingdelimiters \n,\r,\01 from strings
    __sb.append(FieldFormatter.hiveStringDropDelims(_SALES_==null?"\\N":_SALES_, delimiters));
  }
  private static final DelimiterSet __inputDelimiters = new DelimiterSet((char) 1, (char) 10, (char) 0, (char) 0, false);
  private RecordParser __parser;
  public void parse(Text __record) throws RecordParser.ParseError {
    if (null == this.__parser) {
      this.__parser = new RecordParser(__inputDelimiters);
    }
    List<String> __fields = this.__parser.parseRecord(__record);
    __loadFromFields(__fields);
  }

  public void parse(CharSequence __record) throws RecordParser.ParseError {
    if (null == this.__parser) {
      this.__parser = new RecordParser(__inputDelimiters);
    }
    List<String> __fields = this.__parser.parseRecord(__record);
    __loadFromFields(__fields);
  }

  public void parse(byte [] __record) throws RecordParser.ParseError {
    if (null == this.__parser) {
      this.__parser = new RecordParser(__inputDelimiters);
    }
    List<String> __fields = this.__parser.parseRecord(__record);
    __loadFromFields(__fields);
  }

  public void parse(char [] __record) throws RecordParser.ParseError {
    if (null == this.__parser) {
      this.__parser = new RecordParser(__inputDelimiters);
    }
    List<String> __fields = this.__parser.parseRecord(__record);
    __loadFromFields(__fields);
  }

  public void parse(ByteBuffer __record) throws RecordParser.ParseError {
    if (null == this.__parser) {
      this.__parser = new RecordParser(__inputDelimiters);
    }
    List<String> __fields = this.__parser.parseRecord(__record);
    __loadFromFields(__fields);
  }

  public void parse(CharBuffer __record) throws RecordParser.ParseError {
    if (null == this.__parser) {
      this.__parser = new RecordParser(__inputDelimiters);
    }
    List<String> __fields = this.__parser.parseRecord(__record);
    __loadFromFields(__fields);
  }

  private void __loadFromFields(List<String> fields) {
    Iterator<String> __it = fields.listIterator();
    String __cur_str = null;
    try {
    __cur_str = __it.next();
    if (__cur_str.equals("null")) { this.C_CUSTTYPE = null; } else {
      this.C_CUSTTYPE = __cur_str;
    }

    __cur_str = __it.next();
    if (__cur_str.equals("null")) { this.VC_FUNDACCO = null; } else {
      this.VC_FUNDACCO = __cur_str;
    }

    __cur_str = __it.next();
    if (__cur_str.equals("null")) { this.VC_TRADEACCO = null; } else {
      this.VC_TRADEACCO = __cur_str;
    }

    __cur_str = __it.next();
    if (__cur_str.equals("null")) { this.C_TRUST = null; } else {
      this.C_TRUST = __cur_str;
    }

    __cur_str = __it.next();
    if (__cur_str.equals("null")) { this.VC_REQUESTDATE = null; } else {
      this.VC_REQUESTDATE = __cur_str;
    }

    __cur_str = __it.next();
    if (__cur_str.equals("null")) { this.VC_REQUESTNO = null; } else {
      this.VC_REQUESTNO = __cur_str;
    }

    __cur_str = __it.next();
    if (__cur_str.equals("null")) { this.VC_CONFIRMNO = null; } else {
      this.VC_CONFIRMNO = __cur_str;
    }

    __cur_str = __it.next();
    if (__cur_str.equals("null")) { this.VC_CONFIRMDATE = null; } else {
      this.VC_CONFIRMDATE = __cur_str;
    }

    __cur_str = __it.next();
    if (__cur_str.equals("null")) { this.VC_FUNDCODE = null; } else {
      this.VC_FUNDCODE = __cur_str;
    }

    __cur_str = __it.next();
    if (__cur_str.equals("null")) { this.C_SHARETYPE = null; } else {
      this.C_SHARETYPE = __cur_str;
    }

    __cur_str = __it.next();
    if (__cur_str.equals("null")) { this.VC_NETNO = null; } else {
      this.VC_NETNO = __cur_str;
    }

    __cur_str = __it.next();
    if (__cur_str.equals("null")) { this.VC_CENTERNO = null; } else {
      this.VC_CENTERNO = __cur_str;
    }

    __cur_str = __it.next();
    if (__cur_str.equals("null") || __cur_str.length() == 0) { this.EN_RATIO = null; } else {
      this.EN_RATIO = new java.math.BigDecimal(__cur_str);
    }

    __cur_str = __it.next();
    if (__cur_str.equals("null") || __cur_str.length() == 0) { this.EN_NAV = null; } else {
      this.EN_NAV = new java.math.BigDecimal(__cur_str);
    }

    __cur_str = __it.next();
    if (__cur_str.equals("null") || __cur_str.length() == 0) { this.EN_PROFIT = null; } else {
      this.EN_PROFIT = new java.math.BigDecimal(__cur_str);
    }

    __cur_str = __it.next();
    if (__cur_str.equals("null")) { this.C_BUSINFLAG = null; } else {
      this.C_BUSINFLAG = __cur_str;
    }

    __cur_str = __it.next();
    if (__cur_str.equals("null") || __cur_str.length() == 0) { this.EN_BALANCE = null; } else {
      this.EN_BALANCE = new java.math.BigDecimal(__cur_str);
    }

    __cur_str = __it.next();
    if (__cur_str.equals("null") || __cur_str.length() == 0) { this.EN_SHARE = null; } else {
      this.EN_SHARE = new java.math.BigDecimal(__cur_str);
    }

    __cur_str = __it.next();
    if (__cur_str.equals("null") || __cur_str.length() == 0) { this.EN_CONFIRMBALA = null; } else {
      this.EN_CONFIRMBALA = new java.math.BigDecimal(__cur_str);
    }

    __cur_str = __it.next();
    if (__cur_str.equals("null")) { this.C_MONEYTYPE = null; } else {
      this.C_MONEYTYPE = __cur_str;
    }

    __cur_str = __it.next();
    if (__cur_str.equals("null") || __cur_str.length() == 0) { this.EN_CONFIRMSHARE = null; } else {
      this.EN_CONFIRMSHARE = new java.math.BigDecimal(__cur_str);
    }

    __cur_str = __it.next();
    if (__cur_str.equals("null") || __cur_str.length() == 0) { this.EN_FARE = null; } else {
      this.EN_FARE = new java.math.BigDecimal(__cur_str);
    }

    __cur_str = __it.next();
    if (__cur_str.equals("null") || __cur_str.length() == 0) { this.EN_DEALFARE = null; } else {
      this.EN_DEALFARE = new java.math.BigDecimal(__cur_str);
    }

    __cur_str = __it.next();
    if (__cur_str.equals("null") || __cur_str.length() == 0) { this.EN_TAFARE = null; } else {
      this.EN_TAFARE = new java.math.BigDecimal(__cur_str);
    }

    __cur_str = __it.next();
    if (__cur_str.equals("null") || __cur_str.length() == 0) { this.EN_AFTERFARE = null; } else {
      this.EN_AFTERFARE = new java.math.BigDecimal(__cur_str);
    }

    __cur_str = __it.next();
    if (__cur_str.equals("null") || __cur_str.length() == 0) { this.EN_AGENCYFARE = null; } else {
      this.EN_AGENCYFARE = new java.math.BigDecimal(__cur_str);
    }

    __cur_str = __it.next();
    if (__cur_str.equals("null") || __cur_str.length() == 0) { this.EN_STAMPTAX = null; } else {
      this.EN_STAMPTAX = new java.math.BigDecimal(__cur_str);
    }

    __cur_str = __it.next();
    if (__cur_str.equals("null")) { this.C_CONFIRMFLAG = null; } else {
      this.C_CONFIRMFLAG = __cur_str;
    }

    __cur_str = __it.next();
    if (__cur_str.equals("null")) { this.VC_ERRORCODE = null; } else {
      this.VC_ERRORCODE = __cur_str;
    }

    __cur_str = __it.next();
    if (__cur_str.equals("null")) { this.VC_ERRORCAUSE = null; } else {
      this.VC_ERRORCAUSE = __cur_str;
    }

    __cur_str = __it.next();
    if (__cur_str.equals("null")) { this.C_VOUCHERFLAG = null; } else {
      this.C_VOUCHERFLAG = __cur_str;
    }

    __cur_str = __it.next();
    if (__cur_str.equals("null") || __cur_str.length() == 0) { this.EN_INTEREST = null; } else {
      this.EN_INTEREST = new java.math.BigDecimal(__cur_str);
    }

    __cur_str = __it.next();
    if (__cur_str.equals("null") || __cur_str.length() == 0) { this.EN_INTERESTTAX = null; } else {
      this.EN_INTERESTTAX = new java.math.BigDecimal(__cur_str);
    }

    __cur_str = __it.next();
    if (__cur_str.equals("null")) { this.C_ORGANIGER = null; } else {
      this.C_ORGANIGER = __cur_str;
    }

    __cur_str = __it.next();
    if (__cur_str.equals("null")) { this.VC_OTHERACCO = null; } else {
      this.VC_OTHERACCO = __cur_str;
    }

    __cur_str = __it.next();
    if (__cur_str.equals("null")) { this.VC_OTHERTRADEACCO = null; } else {
      this.VC_OTHERTRADEACCO = __cur_str;
    }

    __cur_str = __it.next();
    if (__cur_str.equals("null")) { this.C_OTHERAGENCYNO = null; } else {
      this.C_OTHERAGENCYNO = __cur_str;
    }

    __cur_str = __it.next();
    if (__cur_str.equals("null")) { this.VC_OTHERNETNO = null; } else {
      this.VC_OTHERNETNO = __cur_str;
    }

    __cur_str = __it.next();
    if (__cur_str.equals("null")) { this.VC_OTHERFUNDCODE = null; } else {
      this.VC_OTHERFUNDCODE = __cur_str;
    }

    __cur_str = __it.next();
    if (__cur_str.equals("null")) { this.C_OTHERSHARETYPE = null; } else {
      this.C_OTHERSHARETYPE = __cur_str;
    }

    __cur_str = __it.next();
    if (__cur_str.equals("null") || __cur_str.length() == 0) { this.EN_UNFROZENBALA = null; } else {
      this.EN_UNFROZENBALA = new java.math.BigDecimal(__cur_str);
    }

    __cur_str = __it.next();
    if (__cur_str.equals("null") || __cur_str.length() == 0) { this.EN_RETURNFARE = null; } else {
      this.EN_RETURNFARE = new java.math.BigDecimal(__cur_str);
    }

    __cur_str = __it.next();
    if (__cur_str.equals("null") || __cur_str.length() == 0) { this.EN_ORIGINFARE = null; } else {
      this.EN_ORIGINFARE = new java.math.BigDecimal(__cur_str);
    }

    __cur_str = __it.next();
    if (__cur_str.equals("null")) { this.VC_BROKER = null; } else {
      this.VC_BROKER = __cur_str;
    }

    __cur_str = __it.next();
    if (__cur_str.equals("null")) { this.C_DIVIDENDMETHOD = null; } else {
      this.C_DIVIDENDMETHOD = __cur_str;
    }

    __cur_str = __it.next();
    if (__cur_str.equals("null")) { this.C_FROZENCAUSE = null; } else {
      this.C_FROZENCAUSE = __cur_str;
    }

    __cur_str = __it.next();
    if (__cur_str.equals("null")) { this.VC_ORIGINNO = null; } else {
      this.VC_ORIGINNO = __cur_str;
    }

    __cur_str = __it.next();
    if (__cur_str.equals("null")) { this.VC_CITYNO = null; } else {
      this.VC_CITYNO = __cur_str;
    }

    __cur_str = __it.next();
    if (__cur_str.equals("null")) { this.VC_SELLER = null; } else {
      this.VC_SELLER = __cur_str;
    }

    __cur_str = __it.next();
    if (__cur_str.equals("null")) { this.VC_TACODE = null; } else {
      this.VC_TACODE = __cur_str;
    }

    __cur_str = __it.next();
    if (__cur_str.equals("null") || __cur_str.length() == 0) { this.EN_DISCOUNT = null; } else {
      this.EN_DISCOUNT = new java.math.BigDecimal(__cur_str);
    }

    __cur_str = __it.next();
    if (__cur_str.equals("null") || __cur_str.length() == 0) { this.EN_INCOME = null; } else {
      this.EN_INCOME = new java.math.BigDecimal(__cur_str);
    }

    __cur_str = __it.next();
    if (__cur_str.equals("null") || __cur_str.length() == 0) { this.EN_INVESTINCOME = null; } else {
      this.EN_INVESTINCOME = new java.math.BigDecimal(__cur_str);
    }

    __cur_str = __it.next();
    if (__cur_str.equals("null") || __cur_str.length() == 0) { this.EN_INVESTSHARE = null; } else {
      this.EN_INVESTSHARE = new java.math.BigDecimal(__cur_str);
    }

    __cur_str = __it.next();
    if (__cur_str.equals("null")) { this.C_FINISHFLAG = null; } else {
      this.C_FINISHFLAG = __cur_str;
    }

    __cur_str = __it.next();
    if (__cur_str.equals("null")) { this.C_INTERESTFLAG = null; } else {
      this.C_INTERESTFLAG = __cur_str;
    }

    __cur_str = __it.next();
    if (__cur_str.equals("null")) { this.C_CONFIRMSTATUS = null; } else {
      this.C_CONFIRMSTATUS = __cur_str;
    }

    __cur_str = __it.next();
    if (__cur_str.equals("null") || __cur_str.length() == 0) { this.EN_OTHERDISCOUNT = null; } else {
      this.EN_OTHERDISCOUNT = new java.math.BigDecimal(__cur_str);
    }

    __cur_str = __it.next();
    if (__cur_str.equals("null") || __cur_str.length() == 0) { this.EN_ENDDISCOUNT = null; } else {
      this.EN_ENDDISCOUNT = new java.math.BigDecimal(__cur_str);
    }

    __cur_str = __it.next();
    if (__cur_str.equals("null")) { this.VC_LIQUIDATEDATE = null; } else {
      this.VC_LIQUIDATEDATE = __cur_str;
    }

    __cur_str = __it.next();
    if (__cur_str.equals("null")) { this.C_SENDFLAG = null; } else {
      this.C_SENDFLAG = __cur_str;
    }

    __cur_str = __it.next();
    if (__cur_str.equals("null")) { this.VC_BRANCHCODE = null; } else {
      this.VC_BRANCHCODE = __cur_str;
    }

    __cur_str = __it.next();
    if (__cur_str.equals("null") || __cur_str.length() == 0) { this.EN_OTHERNAV = null; } else {
      this.EN_OTHERNAV = new java.math.BigDecimal(__cur_str);
    }

    __cur_str = __it.next();
    if (__cur_str.equals("null") || __cur_str.length() == 0) { this.EN_OTHERCONFIRMSHARE = null; } else {
      this.EN_OTHERCONFIRMSHARE = new java.math.BigDecimal(__cur_str);
    }

    __cur_str = __it.next();
    if (__cur_str.equals("null") || __cur_str.length() == 0) { this.EN_OTHERORIGINFARE = null; } else {
      this.EN_OTHERORIGINFARE = new java.math.BigDecimal(__cur_str);
    }

    __cur_str = __it.next();
    if (__cur_str.equals("null")) { this.C_FIXBUSINFLAG = null; } else {
      this.C_FIXBUSINFLAG = __cur_str;
    }

    __cur_str = __it.next();
    if (__cur_str.equals("null")) { this.C_CAPITALMODE = null; } else {
      this.C_CAPITALMODE = __cur_str;
    }

    __cur_str = __it.next();
    if (__cur_str.equals("null")) { this.C_SUBCAPITALMODE = null; } else {
      this.C_SUBCAPITALMODE = __cur_str;
    }

    __cur_str = __it.next();
    if (__cur_str.equals("null")) { this.VC_ORIGINCONFIRMNO = null; } else {
      this.VC_ORIGINCONFIRMNO = __cur_str;
    }

    __cur_str = __it.next();
    if (__cur_str.equals("null")) { this.C_BUSINTYPE = null; } else {
      this.C_BUSINTYPE = __cur_str;
    }

    __cur_str = __it.next();
    if (__cur_str.equals("null") || __cur_str.length() == 0) { this.L_SECTIONSCHEMANO = null; } else {
      this.L_SECTIONSCHEMANO = new java.math.BigDecimal(__cur_str);
    }

    __cur_str = __it.next();
    if (__cur_str.equals("null")) { this.C_EXPTYPE = null; } else {
      this.C_EXPTYPE = __cur_str;
    }

    __cur_str = __it.next();
    if (__cur_str.equals("null")) { this.C_SHAREADJUSTFLAG = null; } else {
      this.C_SHAREADJUSTFLAG = __cur_str;
    }

    __cur_str = __it.next();
    if (__cur_str.equals("null")) { this.C_INCOMEFLAG = null; } else {
      this.C_INCOMEFLAG = __cur_str;
    }

    __cur_str = __it.next();
    if (__cur_str.equals("null") || __cur_str.length() == 0) { this.EN_ACHIEVEMENTPAY = null; } else {
      this.EN_ACHIEVEMENTPAY = new java.math.BigDecimal(__cur_str);
    }

    __cur_str = __it.next();
    if (__cur_str.equals("null") || __cur_str.length() == 0) { this.EN_BREACHFEE = null; } else {
      this.EN_BREACHFEE = new java.math.BigDecimal(__cur_str);
    }

    __cur_str = __it.next();
    if (__cur_str.equals("null")) { this.VC_COMEFROM = null; } else {
      this.VC_COMEFROM = __cur_str;
    }

    __cur_str = __it.next();
    if (__cur_str.equals("null")) { this.VC_INVESTORSYSTEMID = null; } else {
      this.VC_INVESTORSYSTEMID = __cur_str;
    }

    __cur_str = __it.next();
    if (__cur_str.equals("null")) { this.VC_VOUCHERNO = null; } else {
      this.VC_VOUCHERNO = __cur_str;
    }

    __cur_str = __it.next();
    if (__cur_str.equals("null")) { this.C_BANKNO = null; } else {
      this.C_BANKNO = __cur_str;
    }

    __cur_str = __it.next();
    if (__cur_str.equals("null")) { this.VC_BANKNAME = null; } else {
      this.VC_BANKNAME = __cur_str;
    }

    __cur_str = __it.next();
    if (__cur_str.equals("null")) { this.VC_NAMEINBANK = null; } else {
      this.VC_NAMEINBANK = __cur_str;
    }

    __cur_str = __it.next();
    if (__cur_str.equals("null")) { this.VC_BANKACCO = null; } else {
      this.VC_BANKACCO = __cur_str;
    }

    __cur_str = __it.next();
    if (__cur_str.equals("null")) { this.VC_CUSTNO = null; } else {
      this.VC_CUSTNO = __cur_str;
    }

    __cur_str = __it.next();
    if (__cur_str.equals("null")) { this.VC_CONFIRMSETTLEDATE = null; } else {
      this.VC_CONFIRMSETTLEDATE = __cur_str;
    }

    __cur_str = __it.next();
    if (__cur_str.equals("null")) { this.VC_REQUESTSETTLEDATE = null; } else {
      this.VC_REQUESTSETTLEDATE = __cur_str;
    }

    __cur_str = __it.next();
    if (__cur_str.equals("null")) { this.VC_CONTRACTSERIALNO = null; } else {
      this.VC_CONTRACTSERIALNO = __cur_str;
    }

    __cur_str = __it.next();
    if (__cur_str.equals("null")) { this.C_PROFITCLASS = null; } else {
      this.C_PROFITCLASS = __cur_str;
    }

    __cur_str = __it.next();
    if (__cur_str.equals("null")) { this.VC_COMBREQUESTNO = null; } else {
      this.VC_COMBREQUESTNO = __cur_str;
    }

    __cur_str = __it.next();
    if (__cur_str.equals("null")) { this.VC_COMBCODE = null; } else {
      this.VC_COMBCODE = __cur_str;
    }

    __cur_str = __it.next();
    if (__cur_str.equals("null")) { this.C_AUTOREQUEST = null; } else {
      this.C_AUTOREQUEST = __cur_str;
    }

    __cur_str = __it.next();
    if (__cur_str.equals("null")) { this.VC_EXPLAIN = null; } else {
      this.VC_EXPLAIN = __cur_str;
    }

    __cur_str = __it.next();
    if (__cur_str.equals("null")) { this.C_INTERFACETYPE = null; } else {
      this.C_INTERFACETYPE = __cur_str;
    }

    __cur_str = __it.next();
    if (__cur_str.equals("null") || __cur_str.length() == 0) { this.EN_OTHERFEE1 = null; } else {
      this.EN_OTHERFEE1 = new java.math.BigDecimal(__cur_str);
    }

    __cur_str = __it.next();
    if (__cur_str.equals("null") || __cur_str.length() == 0) { this.EN_OTHERFEE2 = null; } else {
      this.EN_OTHERFEE2 = new java.math.BigDecimal(__cur_str);
    }

    __cur_str = __it.next();
    if (__cur_str.equals("null")) { this.C_MATCHFLAG = null; } else {
      this.C_MATCHFLAG = __cur_str;
    }

    __cur_str = __it.next();
    if (__cur_str.equals("null")) { this.VC_BOOKID = null; } else {
      this.VC_BOOKID = __cur_str;
    }

    __cur_str = __it.next();
    if (__cur_str.equals("null") || __cur_str.length() == 0) { this.EN_GRAMNUM = null; } else {
      this.EN_GRAMNUM = new java.math.BigDecimal(__cur_str);
    }

    __cur_str = __it.next();
    if (__cur_str.equals("null")) { this.C_FORCEREDEEMREASON = null; } else {
      this.C_FORCEREDEEMREASON = __cur_str;
    }

    __cur_str = __it.next();
    if (__cur_str.equals("null") || __cur_str.length() == 0) { this.EN_TOTALFROZENSHARE = null; } else {
      this.EN_TOTALFROZENSHARE = new java.math.BigDecimal(__cur_str);
    }

    __cur_str = __it.next();
    if (__cur_str.equals("null") || __cur_str.length() == 0) { this.EN_FUNDSHAREBALANCE = null; } else {
      this.EN_FUNDSHAREBALANCE = new java.math.BigDecimal(__cur_str);
    }

    __cur_str = __it.next();
    if (__cur_str.equals("null") || __cur_str.length() == 0) { this.EN_FROZENBALANCE = null; } else {
      this.EN_FROZENBALANCE = new java.math.BigDecimal(__cur_str);
    }

    __cur_str = __it.next();
    if (__cur_str.equals("null")) { this.VC_FUTURESUBSCRIBEDATE = null; } else {
      this.VC_FUTURESUBSCRIBEDATE = __cur_str;
    }

    __cur_str = __it.next();
    if (__cur_str.equals("null")) { this.VC_TRANSFERDATEFROMAGENCY = null; } else {
      this.VC_TRANSFERDATEFROMAGENCY = __cur_str;
    }

    __cur_str = __it.next();
    if (__cur_str.equals("null") || __cur_str.length() == 0) { this.EN_TAXADVANAMOUNT = null; } else {
      this.EN_TAXADVANAMOUNT = new java.math.BigDecimal(__cur_str);
    }

    __cur_str = __it.next();
    if (__cur_str.equals("null")) { this.VC_TAXADVANCODE = null; } else {
      this.VC_TAXADVANCODE = __cur_str;
    }

    __cur_str = __it.next();
    if (__cur_str.equals("null")) { this.VC_OTHERSERIALNO = null; } else {
      this.VC_OTHERSERIALNO = __cur_str;
    }

    __cur_str = __it.next();
    if (__cur_str.equals("null")) { this.C_ATTENDQUITFLAG = null; } else {
      this.C_ATTENDQUITFLAG = __cur_str;
    }

    __cur_str = __it.next();
    if (__cur_str.equals("null")) { this.VC_CUSTOMNAME_GS = null; } else {
      this.VC_CUSTOMNAME_GS = __cur_str;
    }

    __cur_str = __it.next();
    if (__cur_str.equals("null")) { this.C_IDENTITYTYPE_GS = null; } else {
      this.C_IDENTITYTYPE_GS = __cur_str;
    }

    __cur_str = __it.next();
    if (__cur_str.equals("null")) { this.VC_IDENTITYNO_GS = null; } else {
      this.VC_IDENTITYNO_GS = __cur_str;
    }

    __cur_str = __it.next();
    if (__cur_str.equals("null")) { this.VC_NATIONALITY_GS = null; } else {
      this.VC_NATIONALITY_GS = __cur_str;
    }

    __cur_str = __it.next();
    if (__cur_str.equals("null")) { this.VC_CERTCODE_GS = null; } else {
      this.VC_CERTCODE_GS = __cur_str;
    }

    __cur_str = __it.next();
    if (__cur_str.equals("null")) { this.VC_CERTDATE_GS = null; } else {
      this.VC_CERTDATE_GS = __cur_str;
    }

    __cur_str = __it.next();
    if (__cur_str.equals("null") || __cur_str.length() == 0) { this.EN_ACCTAXPRETAKEOFF_GS = null; } else {
      this.EN_ACCTAXPRETAKEOFF_GS = new java.math.BigDecimal(__cur_str);
    }

    __cur_str = __it.next();
    if (__cur_str.equals("null")) { this.INSERTTIME = null; } else {
      this.INSERTTIME = __cur_str;
    }

    __cur_str = __it.next();
    if (__cur_str.equals("null")) { this.UPDATETIME = null; } else {
      this.UPDATETIME = __cur_str;
    }

    __cur_str = __it.next();
    if (__cur_str.equals("null") || __cur_str.length() == 0) { this._20210422 = null; } else {
      this._20210422 = new java.math.BigDecimal(__cur_str);
    }

    __cur_str = __it.next();
    if (__cur_str.equals("null")) { this._SALES_ = null; } else {
      this._SALES_ = __cur_str;
    }

    } catch (RuntimeException e) {    throw new RuntimeException("Can't parse input data: '" + __cur_str + "'", e);    }  }

  private void __loadFromFields0(Iterator<String> __it) {
    String __cur_str = null;
    try {
    __cur_str = __it.next();
    if (__cur_str.equals("null")) { this.C_CUSTTYPE = null; } else {
      this.C_CUSTTYPE = __cur_str;
    }

    __cur_str = __it.next();
    if (__cur_str.equals("null")) { this.VC_FUNDACCO = null; } else {
      this.VC_FUNDACCO = __cur_str;
    }

    __cur_str = __it.next();
    if (__cur_str.equals("null")) { this.VC_TRADEACCO = null; } else {
      this.VC_TRADEACCO = __cur_str;
    }

    __cur_str = __it.next();
    if (__cur_str.equals("null")) { this.C_TRUST = null; } else {
      this.C_TRUST = __cur_str;
    }

    __cur_str = __it.next();
    if (__cur_str.equals("null")) { this.VC_REQUESTDATE = null; } else {
      this.VC_REQUESTDATE = __cur_str;
    }

    __cur_str = __it.next();
    if (__cur_str.equals("null")) { this.VC_REQUESTNO = null; } else {
      this.VC_REQUESTNO = __cur_str;
    }

    __cur_str = __it.next();
    if (__cur_str.equals("null")) { this.VC_CONFIRMNO = null; } else {
      this.VC_CONFIRMNO = __cur_str;
    }

    __cur_str = __it.next();
    if (__cur_str.equals("null")) { this.VC_CONFIRMDATE = null; } else {
      this.VC_CONFIRMDATE = __cur_str;
    }

    __cur_str = __it.next();
    if (__cur_str.equals("null")) { this.VC_FUNDCODE = null; } else {
      this.VC_FUNDCODE = __cur_str;
    }

    __cur_str = __it.next();
    if (__cur_str.equals("null")) { this.C_SHARETYPE = null; } else {
      this.C_SHARETYPE = __cur_str;
    }

    __cur_str = __it.next();
    if (__cur_str.equals("null")) { this.VC_NETNO = null; } else {
      this.VC_NETNO = __cur_str;
    }

    __cur_str = __it.next();
    if (__cur_str.equals("null")) { this.VC_CENTERNO = null; } else {
      this.VC_CENTERNO = __cur_str;
    }

    __cur_str = __it.next();
    if (__cur_str.equals("null") || __cur_str.length() == 0) { this.EN_RATIO = null; } else {
      this.EN_RATIO = new java.math.BigDecimal(__cur_str);
    }

    __cur_str = __it.next();
    if (__cur_str.equals("null") || __cur_str.length() == 0) { this.EN_NAV = null; } else {
      this.EN_NAV = new java.math.BigDecimal(__cur_str);
    }

    __cur_str = __it.next();
    if (__cur_str.equals("null") || __cur_str.length() == 0) { this.EN_PROFIT = null; } else {
      this.EN_PROFIT = new java.math.BigDecimal(__cur_str);
    }

    __cur_str = __it.next();
    if (__cur_str.equals("null")) { this.C_BUSINFLAG = null; } else {
      this.C_BUSINFLAG = __cur_str;
    }

    __cur_str = __it.next();
    if (__cur_str.equals("null") || __cur_str.length() == 0) { this.EN_BALANCE = null; } else {
      this.EN_BALANCE = new java.math.BigDecimal(__cur_str);
    }

    __cur_str = __it.next();
    if (__cur_str.equals("null") || __cur_str.length() == 0) { this.EN_SHARE = null; } else {
      this.EN_SHARE = new java.math.BigDecimal(__cur_str);
    }

    __cur_str = __it.next();
    if (__cur_str.equals("null") || __cur_str.length() == 0) { this.EN_CONFIRMBALA = null; } else {
      this.EN_CONFIRMBALA = new java.math.BigDecimal(__cur_str);
    }

    __cur_str = __it.next();
    if (__cur_str.equals("null")) { this.C_MONEYTYPE = null; } else {
      this.C_MONEYTYPE = __cur_str;
    }

    __cur_str = __it.next();
    if (__cur_str.equals("null") || __cur_str.length() == 0) { this.EN_CONFIRMSHARE = null; } else {
      this.EN_CONFIRMSHARE = new java.math.BigDecimal(__cur_str);
    }

    __cur_str = __it.next();
    if (__cur_str.equals("null") || __cur_str.length() == 0) { this.EN_FARE = null; } else {
      this.EN_FARE = new java.math.BigDecimal(__cur_str);
    }

    __cur_str = __it.next();
    if (__cur_str.equals("null") || __cur_str.length() == 0) { this.EN_DEALFARE = null; } else {
      this.EN_DEALFARE = new java.math.BigDecimal(__cur_str);
    }

    __cur_str = __it.next();
    if (__cur_str.equals("null") || __cur_str.length() == 0) { this.EN_TAFARE = null; } else {
      this.EN_TAFARE = new java.math.BigDecimal(__cur_str);
    }

    __cur_str = __it.next();
    if (__cur_str.equals("null") || __cur_str.length() == 0) { this.EN_AFTERFARE = null; } else {
      this.EN_AFTERFARE = new java.math.BigDecimal(__cur_str);
    }

    __cur_str = __it.next();
    if (__cur_str.equals("null") || __cur_str.length() == 0) { this.EN_AGENCYFARE = null; } else {
      this.EN_AGENCYFARE = new java.math.BigDecimal(__cur_str);
    }

    __cur_str = __it.next();
    if (__cur_str.equals("null") || __cur_str.length() == 0) { this.EN_STAMPTAX = null; } else {
      this.EN_STAMPTAX = new java.math.BigDecimal(__cur_str);
    }

    __cur_str = __it.next();
    if (__cur_str.equals("null")) { this.C_CONFIRMFLAG = null; } else {
      this.C_CONFIRMFLAG = __cur_str;
    }

    __cur_str = __it.next();
    if (__cur_str.equals("null")) { this.VC_ERRORCODE = null; } else {
      this.VC_ERRORCODE = __cur_str;
    }

    __cur_str = __it.next();
    if (__cur_str.equals("null")) { this.VC_ERRORCAUSE = null; } else {
      this.VC_ERRORCAUSE = __cur_str;
    }

    __cur_str = __it.next();
    if (__cur_str.equals("null")) { this.C_VOUCHERFLAG = null; } else {
      this.C_VOUCHERFLAG = __cur_str;
    }

    __cur_str = __it.next();
    if (__cur_str.equals("null") || __cur_str.length() == 0) { this.EN_INTEREST = null; } else {
      this.EN_INTEREST = new java.math.BigDecimal(__cur_str);
    }

    __cur_str = __it.next();
    if (__cur_str.equals("null") || __cur_str.length() == 0) { this.EN_INTERESTTAX = null; } else {
      this.EN_INTERESTTAX = new java.math.BigDecimal(__cur_str);
    }

    __cur_str = __it.next();
    if (__cur_str.equals("null")) { this.C_ORGANIGER = null; } else {
      this.C_ORGANIGER = __cur_str;
    }

    __cur_str = __it.next();
    if (__cur_str.equals("null")) { this.VC_OTHERACCO = null; } else {
      this.VC_OTHERACCO = __cur_str;
    }

    __cur_str = __it.next();
    if (__cur_str.equals("null")) { this.VC_OTHERTRADEACCO = null; } else {
      this.VC_OTHERTRADEACCO = __cur_str;
    }

    __cur_str = __it.next();
    if (__cur_str.equals("null")) { this.C_OTHERAGENCYNO = null; } else {
      this.C_OTHERAGENCYNO = __cur_str;
    }

    __cur_str = __it.next();
    if (__cur_str.equals("null")) { this.VC_OTHERNETNO = null; } else {
      this.VC_OTHERNETNO = __cur_str;
    }

    __cur_str = __it.next();
    if (__cur_str.equals("null")) { this.VC_OTHERFUNDCODE = null; } else {
      this.VC_OTHERFUNDCODE = __cur_str;
    }

    __cur_str = __it.next();
    if (__cur_str.equals("null")) { this.C_OTHERSHARETYPE = null; } else {
      this.C_OTHERSHARETYPE = __cur_str;
    }

    __cur_str = __it.next();
    if (__cur_str.equals("null") || __cur_str.length() == 0) { this.EN_UNFROZENBALA = null; } else {
      this.EN_UNFROZENBALA = new java.math.BigDecimal(__cur_str);
    }

    __cur_str = __it.next();
    if (__cur_str.equals("null") || __cur_str.length() == 0) { this.EN_RETURNFARE = null; } else {
      this.EN_RETURNFARE = new java.math.BigDecimal(__cur_str);
    }

    __cur_str = __it.next();
    if (__cur_str.equals("null") || __cur_str.length() == 0) { this.EN_ORIGINFARE = null; } else {
      this.EN_ORIGINFARE = new java.math.BigDecimal(__cur_str);
    }

    __cur_str = __it.next();
    if (__cur_str.equals("null")) { this.VC_BROKER = null; } else {
      this.VC_BROKER = __cur_str;
    }

    __cur_str = __it.next();
    if (__cur_str.equals("null")) { this.C_DIVIDENDMETHOD = null; } else {
      this.C_DIVIDENDMETHOD = __cur_str;
    }

    __cur_str = __it.next();
    if (__cur_str.equals("null")) { this.C_FROZENCAUSE = null; } else {
      this.C_FROZENCAUSE = __cur_str;
    }

    __cur_str = __it.next();
    if (__cur_str.equals("null")) { this.VC_ORIGINNO = null; } else {
      this.VC_ORIGINNO = __cur_str;
    }

    __cur_str = __it.next();
    if (__cur_str.equals("null")) { this.VC_CITYNO = null; } else {
      this.VC_CITYNO = __cur_str;
    }

    __cur_str = __it.next();
    if (__cur_str.equals("null")) { this.VC_SELLER = null; } else {
      this.VC_SELLER = __cur_str;
    }

    __cur_str = __it.next();
    if (__cur_str.equals("null")) { this.VC_TACODE = null; } else {
      this.VC_TACODE = __cur_str;
    }

    __cur_str = __it.next();
    if (__cur_str.equals("null") || __cur_str.length() == 0) { this.EN_DISCOUNT = null; } else {
      this.EN_DISCOUNT = new java.math.BigDecimal(__cur_str);
    }

    __cur_str = __it.next();
    if (__cur_str.equals("null") || __cur_str.length() == 0) { this.EN_INCOME = null; } else {
      this.EN_INCOME = new java.math.BigDecimal(__cur_str);
    }

    __cur_str = __it.next();
    if (__cur_str.equals("null") || __cur_str.length() == 0) { this.EN_INVESTINCOME = null; } else {
      this.EN_INVESTINCOME = new java.math.BigDecimal(__cur_str);
    }

    __cur_str = __it.next();
    if (__cur_str.equals("null") || __cur_str.length() == 0) { this.EN_INVESTSHARE = null; } else {
      this.EN_INVESTSHARE = new java.math.BigDecimal(__cur_str);
    }

    __cur_str = __it.next();
    if (__cur_str.equals("null")) { this.C_FINISHFLAG = null; } else {
      this.C_FINISHFLAG = __cur_str;
    }

    __cur_str = __it.next();
    if (__cur_str.equals("null")) { this.C_INTERESTFLAG = null; } else {
      this.C_INTERESTFLAG = __cur_str;
    }

    __cur_str = __it.next();
    if (__cur_str.equals("null")) { this.C_CONFIRMSTATUS = null; } else {
      this.C_CONFIRMSTATUS = __cur_str;
    }

    __cur_str = __it.next();
    if (__cur_str.equals("null") || __cur_str.length() == 0) { this.EN_OTHERDISCOUNT = null; } else {
      this.EN_OTHERDISCOUNT = new java.math.BigDecimal(__cur_str);
    }

    __cur_str = __it.next();
    if (__cur_str.equals("null") || __cur_str.length() == 0) { this.EN_ENDDISCOUNT = null; } else {
      this.EN_ENDDISCOUNT = new java.math.BigDecimal(__cur_str);
    }

    __cur_str = __it.next();
    if (__cur_str.equals("null")) { this.VC_LIQUIDATEDATE = null; } else {
      this.VC_LIQUIDATEDATE = __cur_str;
    }

    __cur_str = __it.next();
    if (__cur_str.equals("null")) { this.C_SENDFLAG = null; } else {
      this.C_SENDFLAG = __cur_str;
    }

    __cur_str = __it.next();
    if (__cur_str.equals("null")) { this.VC_BRANCHCODE = null; } else {
      this.VC_BRANCHCODE = __cur_str;
    }

    __cur_str = __it.next();
    if (__cur_str.equals("null") || __cur_str.length() == 0) { this.EN_OTHERNAV = null; } else {
      this.EN_OTHERNAV = new java.math.BigDecimal(__cur_str);
    }

    __cur_str = __it.next();
    if (__cur_str.equals("null") || __cur_str.length() == 0) { this.EN_OTHERCONFIRMSHARE = null; } else {
      this.EN_OTHERCONFIRMSHARE = new java.math.BigDecimal(__cur_str);
    }

    __cur_str = __it.next();
    if (__cur_str.equals("null") || __cur_str.length() == 0) { this.EN_OTHERORIGINFARE = null; } else {
      this.EN_OTHERORIGINFARE = new java.math.BigDecimal(__cur_str);
    }

    __cur_str = __it.next();
    if (__cur_str.equals("null")) { this.C_FIXBUSINFLAG = null; } else {
      this.C_FIXBUSINFLAG = __cur_str;
    }

    __cur_str = __it.next();
    if (__cur_str.equals("null")) { this.C_CAPITALMODE = null; } else {
      this.C_CAPITALMODE = __cur_str;
    }

    __cur_str = __it.next();
    if (__cur_str.equals("null")) { this.C_SUBCAPITALMODE = null; } else {
      this.C_SUBCAPITALMODE = __cur_str;
    }

    __cur_str = __it.next();
    if (__cur_str.equals("null")) { this.VC_ORIGINCONFIRMNO = null; } else {
      this.VC_ORIGINCONFIRMNO = __cur_str;
    }

    __cur_str = __it.next();
    if (__cur_str.equals("null")) { this.C_BUSINTYPE = null; } else {
      this.C_BUSINTYPE = __cur_str;
    }

    __cur_str = __it.next();
    if (__cur_str.equals("null") || __cur_str.length() == 0) { this.L_SECTIONSCHEMANO = null; } else {
      this.L_SECTIONSCHEMANO = new java.math.BigDecimal(__cur_str);
    }

    __cur_str = __it.next();
    if (__cur_str.equals("null")) { this.C_EXPTYPE = null; } else {
      this.C_EXPTYPE = __cur_str;
    }

    __cur_str = __it.next();
    if (__cur_str.equals("null")) { this.C_SHAREADJUSTFLAG = null; } else {
      this.C_SHAREADJUSTFLAG = __cur_str;
    }

    __cur_str = __it.next();
    if (__cur_str.equals("null")) { this.C_INCOMEFLAG = null; } else {
      this.C_INCOMEFLAG = __cur_str;
    }

    __cur_str = __it.next();
    if (__cur_str.equals("null") || __cur_str.length() == 0) { this.EN_ACHIEVEMENTPAY = null; } else {
      this.EN_ACHIEVEMENTPAY = new java.math.BigDecimal(__cur_str);
    }

    __cur_str = __it.next();
    if (__cur_str.equals("null") || __cur_str.length() == 0) { this.EN_BREACHFEE = null; } else {
      this.EN_BREACHFEE = new java.math.BigDecimal(__cur_str);
    }

    __cur_str = __it.next();
    if (__cur_str.equals("null")) { this.VC_COMEFROM = null; } else {
      this.VC_COMEFROM = __cur_str;
    }

    __cur_str = __it.next();
    if (__cur_str.equals("null")) { this.VC_INVESTORSYSTEMID = null; } else {
      this.VC_INVESTORSYSTEMID = __cur_str;
    }

    __cur_str = __it.next();
    if (__cur_str.equals("null")) { this.VC_VOUCHERNO = null; } else {
      this.VC_VOUCHERNO = __cur_str;
    }

    __cur_str = __it.next();
    if (__cur_str.equals("null")) { this.C_BANKNO = null; } else {
      this.C_BANKNO = __cur_str;
    }

    __cur_str = __it.next();
    if (__cur_str.equals("null")) { this.VC_BANKNAME = null; } else {
      this.VC_BANKNAME = __cur_str;
    }

    __cur_str = __it.next();
    if (__cur_str.equals("null")) { this.VC_NAMEINBANK = null; } else {
      this.VC_NAMEINBANK = __cur_str;
    }

    __cur_str = __it.next();
    if (__cur_str.equals("null")) { this.VC_BANKACCO = null; } else {
      this.VC_BANKACCO = __cur_str;
    }

    __cur_str = __it.next();
    if (__cur_str.equals("null")) { this.VC_CUSTNO = null; } else {
      this.VC_CUSTNO = __cur_str;
    }

    __cur_str = __it.next();
    if (__cur_str.equals("null")) { this.VC_CONFIRMSETTLEDATE = null; } else {
      this.VC_CONFIRMSETTLEDATE = __cur_str;
    }

    __cur_str = __it.next();
    if (__cur_str.equals("null")) { this.VC_REQUESTSETTLEDATE = null; } else {
      this.VC_REQUESTSETTLEDATE = __cur_str;
    }

    __cur_str = __it.next();
    if (__cur_str.equals("null")) { this.VC_CONTRACTSERIALNO = null; } else {
      this.VC_CONTRACTSERIALNO = __cur_str;
    }

    __cur_str = __it.next();
    if (__cur_str.equals("null")) { this.C_PROFITCLASS = null; } else {
      this.C_PROFITCLASS = __cur_str;
    }

    __cur_str = __it.next();
    if (__cur_str.equals("null")) { this.VC_COMBREQUESTNO = null; } else {
      this.VC_COMBREQUESTNO = __cur_str;
    }

    __cur_str = __it.next();
    if (__cur_str.equals("null")) { this.VC_COMBCODE = null; } else {
      this.VC_COMBCODE = __cur_str;
    }

    __cur_str = __it.next();
    if (__cur_str.equals("null")) { this.C_AUTOREQUEST = null; } else {
      this.C_AUTOREQUEST = __cur_str;
    }

    __cur_str = __it.next();
    if (__cur_str.equals("null")) { this.VC_EXPLAIN = null; } else {
      this.VC_EXPLAIN = __cur_str;
    }

    __cur_str = __it.next();
    if (__cur_str.equals("null")) { this.C_INTERFACETYPE = null; } else {
      this.C_INTERFACETYPE = __cur_str;
    }

    __cur_str = __it.next();
    if (__cur_str.equals("null") || __cur_str.length() == 0) { this.EN_OTHERFEE1 = null; } else {
      this.EN_OTHERFEE1 = new java.math.BigDecimal(__cur_str);
    }

    __cur_str = __it.next();
    if (__cur_str.equals("null") || __cur_str.length() == 0) { this.EN_OTHERFEE2 = null; } else {
      this.EN_OTHERFEE2 = new java.math.BigDecimal(__cur_str);
    }

    __cur_str = __it.next();
    if (__cur_str.equals("null")) { this.C_MATCHFLAG = null; } else {
      this.C_MATCHFLAG = __cur_str;
    }

    __cur_str = __it.next();
    if (__cur_str.equals("null")) { this.VC_BOOKID = null; } else {
      this.VC_BOOKID = __cur_str;
    }

    __cur_str = __it.next();
    if (__cur_str.equals("null") || __cur_str.length() == 0) { this.EN_GRAMNUM = null; } else {
      this.EN_GRAMNUM = new java.math.BigDecimal(__cur_str);
    }

    __cur_str = __it.next();
    if (__cur_str.equals("null")) { this.C_FORCEREDEEMREASON = null; } else {
      this.C_FORCEREDEEMREASON = __cur_str;
    }

    __cur_str = __it.next();
    if (__cur_str.equals("null") || __cur_str.length() == 0) { this.EN_TOTALFROZENSHARE = null; } else {
      this.EN_TOTALFROZENSHARE = new java.math.BigDecimal(__cur_str);
    }

    __cur_str = __it.next();
    if (__cur_str.equals("null") || __cur_str.length() == 0) { this.EN_FUNDSHAREBALANCE = null; } else {
      this.EN_FUNDSHAREBALANCE = new java.math.BigDecimal(__cur_str);
    }

    __cur_str = __it.next();
    if (__cur_str.equals("null") || __cur_str.length() == 0) { this.EN_FROZENBALANCE = null; } else {
      this.EN_FROZENBALANCE = new java.math.BigDecimal(__cur_str);
    }

    __cur_str = __it.next();
    if (__cur_str.equals("null")) { this.VC_FUTURESUBSCRIBEDATE = null; } else {
      this.VC_FUTURESUBSCRIBEDATE = __cur_str;
    }

    __cur_str = __it.next();
    if (__cur_str.equals("null")) { this.VC_TRANSFERDATEFROMAGENCY = null; } else {
      this.VC_TRANSFERDATEFROMAGENCY = __cur_str;
    }

    __cur_str = __it.next();
    if (__cur_str.equals("null") || __cur_str.length() == 0) { this.EN_TAXADVANAMOUNT = null; } else {
      this.EN_TAXADVANAMOUNT = new java.math.BigDecimal(__cur_str);
    }

    __cur_str = __it.next();
    if (__cur_str.equals("null")) { this.VC_TAXADVANCODE = null; } else {
      this.VC_TAXADVANCODE = __cur_str;
    }

    __cur_str = __it.next();
    if (__cur_str.equals("null")) { this.VC_OTHERSERIALNO = null; } else {
      this.VC_OTHERSERIALNO = __cur_str;
    }

    __cur_str = __it.next();
    if (__cur_str.equals("null")) { this.C_ATTENDQUITFLAG = null; } else {
      this.C_ATTENDQUITFLAG = __cur_str;
    }

    __cur_str = __it.next();
    if (__cur_str.equals("null")) { this.VC_CUSTOMNAME_GS = null; } else {
      this.VC_CUSTOMNAME_GS = __cur_str;
    }

    __cur_str = __it.next();
    if (__cur_str.equals("null")) { this.C_IDENTITYTYPE_GS = null; } else {
      this.C_IDENTITYTYPE_GS = __cur_str;
    }

    __cur_str = __it.next();
    if (__cur_str.equals("null")) { this.VC_IDENTITYNO_GS = null; } else {
      this.VC_IDENTITYNO_GS = __cur_str;
    }

    __cur_str = __it.next();
    if (__cur_str.equals("null")) { this.VC_NATIONALITY_GS = null; } else {
      this.VC_NATIONALITY_GS = __cur_str;
    }

    __cur_str = __it.next();
    if (__cur_str.equals("null")) { this.VC_CERTCODE_GS = null; } else {
      this.VC_CERTCODE_GS = __cur_str;
    }

    __cur_str = __it.next();
    if (__cur_str.equals("null")) { this.VC_CERTDATE_GS = null; } else {
      this.VC_CERTDATE_GS = __cur_str;
    }

    __cur_str = __it.next();
    if (__cur_str.equals("null") || __cur_str.length() == 0) { this.EN_ACCTAXPRETAKEOFF_GS = null; } else {
      this.EN_ACCTAXPRETAKEOFF_GS = new java.math.BigDecimal(__cur_str);
    }

    __cur_str = __it.next();
    if (__cur_str.equals("null")) { this.INSERTTIME = null; } else {
      this.INSERTTIME = __cur_str;
    }

    __cur_str = __it.next();
    if (__cur_str.equals("null")) { this.UPDATETIME = null; } else {
      this.UPDATETIME = __cur_str;
    }

    __cur_str = __it.next();
    if (__cur_str.equals("null") || __cur_str.length() == 0) { this._20210422 = null; } else {
      this._20210422 = new java.math.BigDecimal(__cur_str);
    }

    __cur_str = __it.next();
    if (__cur_str.equals("null")) { this._SALES_ = null; } else {
      this._SALES_ = __cur_str;
    }

    } catch (RuntimeException e) {    throw new RuntimeException("Can't parse input data: '" + __cur_str + "'", e);    }  }

  public Object clone() throws CloneNotSupportedException {
    QueryResult o = (QueryResult) super.clone();
    return o;
  }

  public void clone0(QueryResult o) throws CloneNotSupportedException {
  }

  public Map<String, Object> getFieldMap() {
    Map<String, Object> __sqoop$field_map = new HashMap<String, Object>();
    __sqoop$field_map.put("C_CUSTTYPE", this.C_CUSTTYPE);
    __sqoop$field_map.put("VC_FUNDACCO", this.VC_FUNDACCO);
    __sqoop$field_map.put("VC_TRADEACCO", this.VC_TRADEACCO);
    __sqoop$field_map.put("C_TRUST", this.C_TRUST);
    __sqoop$field_map.put("VC_REQUESTDATE", this.VC_REQUESTDATE);
    __sqoop$field_map.put("VC_REQUESTNO", this.VC_REQUESTNO);
    __sqoop$field_map.put("VC_CONFIRMNO", this.VC_CONFIRMNO);
    __sqoop$field_map.put("VC_CONFIRMDATE", this.VC_CONFIRMDATE);
    __sqoop$field_map.put("VC_FUNDCODE", this.VC_FUNDCODE);
    __sqoop$field_map.put("C_SHARETYPE", this.C_SHARETYPE);
    __sqoop$field_map.put("VC_NETNO", this.VC_NETNO);
    __sqoop$field_map.put("VC_CENTERNO", this.VC_CENTERNO);
    __sqoop$field_map.put("EN_RATIO", this.EN_RATIO);
    __sqoop$field_map.put("EN_NAV", this.EN_NAV);
    __sqoop$field_map.put("EN_PROFIT", this.EN_PROFIT);
    __sqoop$field_map.put("C_BUSINFLAG", this.C_BUSINFLAG);
    __sqoop$field_map.put("EN_BALANCE", this.EN_BALANCE);
    __sqoop$field_map.put("EN_SHARE", this.EN_SHARE);
    __sqoop$field_map.put("EN_CONFIRMBALA", this.EN_CONFIRMBALA);
    __sqoop$field_map.put("C_MONEYTYPE", this.C_MONEYTYPE);
    __sqoop$field_map.put("EN_CONFIRMSHARE", this.EN_CONFIRMSHARE);
    __sqoop$field_map.put("EN_FARE", this.EN_FARE);
    __sqoop$field_map.put("EN_DEALFARE", this.EN_DEALFARE);
    __sqoop$field_map.put("EN_TAFARE", this.EN_TAFARE);
    __sqoop$field_map.put("EN_AFTERFARE", this.EN_AFTERFARE);
    __sqoop$field_map.put("EN_AGENCYFARE", this.EN_AGENCYFARE);
    __sqoop$field_map.put("EN_STAMPTAX", this.EN_STAMPTAX);
    __sqoop$field_map.put("C_CONFIRMFLAG", this.C_CONFIRMFLAG);
    __sqoop$field_map.put("VC_ERRORCODE", this.VC_ERRORCODE);
    __sqoop$field_map.put("VC_ERRORCAUSE", this.VC_ERRORCAUSE);
    __sqoop$field_map.put("C_VOUCHERFLAG", this.C_VOUCHERFLAG);
    __sqoop$field_map.put("EN_INTEREST", this.EN_INTEREST);
    __sqoop$field_map.put("EN_INTERESTTAX", this.EN_INTERESTTAX);
    __sqoop$field_map.put("C_ORGANIGER", this.C_ORGANIGER);
    __sqoop$field_map.put("VC_OTHERACCO", this.VC_OTHERACCO);
    __sqoop$field_map.put("VC_OTHERTRADEACCO", this.VC_OTHERTRADEACCO);
    __sqoop$field_map.put("C_OTHERAGENCYNO", this.C_OTHERAGENCYNO);
    __sqoop$field_map.put("VC_OTHERNETNO", this.VC_OTHERNETNO);
    __sqoop$field_map.put("VC_OTHERFUNDCODE", this.VC_OTHERFUNDCODE);
    __sqoop$field_map.put("C_OTHERSHARETYPE", this.C_OTHERSHARETYPE);
    __sqoop$field_map.put("EN_UNFROZENBALA", this.EN_UNFROZENBALA);
    __sqoop$field_map.put("EN_RETURNFARE", this.EN_RETURNFARE);
    __sqoop$field_map.put("EN_ORIGINFARE", this.EN_ORIGINFARE);
    __sqoop$field_map.put("VC_BROKER", this.VC_BROKER);
    __sqoop$field_map.put("C_DIVIDENDMETHOD", this.C_DIVIDENDMETHOD);
    __sqoop$field_map.put("C_FROZENCAUSE", this.C_FROZENCAUSE);
    __sqoop$field_map.put("VC_ORIGINNO", this.VC_ORIGINNO);
    __sqoop$field_map.put("VC_CITYNO", this.VC_CITYNO);
    __sqoop$field_map.put("VC_SELLER", this.VC_SELLER);
    __sqoop$field_map.put("VC_TACODE", this.VC_TACODE);
    __sqoop$field_map.put("EN_DISCOUNT", this.EN_DISCOUNT);
    __sqoop$field_map.put("EN_INCOME", this.EN_INCOME);
    __sqoop$field_map.put("EN_INVESTINCOME", this.EN_INVESTINCOME);
    __sqoop$field_map.put("EN_INVESTSHARE", this.EN_INVESTSHARE);
    __sqoop$field_map.put("C_FINISHFLAG", this.C_FINISHFLAG);
    __sqoop$field_map.put("C_INTERESTFLAG", this.C_INTERESTFLAG);
    __sqoop$field_map.put("C_CONFIRMSTATUS", this.C_CONFIRMSTATUS);
    __sqoop$field_map.put("EN_OTHERDISCOUNT", this.EN_OTHERDISCOUNT);
    __sqoop$field_map.put("EN_ENDDISCOUNT", this.EN_ENDDISCOUNT);
    __sqoop$field_map.put("VC_LIQUIDATEDATE", this.VC_LIQUIDATEDATE);
    __sqoop$field_map.put("C_SENDFLAG", this.C_SENDFLAG);
    __sqoop$field_map.put("VC_BRANCHCODE", this.VC_BRANCHCODE);
    __sqoop$field_map.put("EN_OTHERNAV", this.EN_OTHERNAV);
    __sqoop$field_map.put("EN_OTHERCONFIRMSHARE", this.EN_OTHERCONFIRMSHARE);
    __sqoop$field_map.put("EN_OTHERORIGINFARE", this.EN_OTHERORIGINFARE);
    __sqoop$field_map.put("C_FIXBUSINFLAG", this.C_FIXBUSINFLAG);
    __sqoop$field_map.put("C_CAPITALMODE", this.C_CAPITALMODE);
    __sqoop$field_map.put("C_SUBCAPITALMODE", this.C_SUBCAPITALMODE);
    __sqoop$field_map.put("VC_ORIGINCONFIRMNO", this.VC_ORIGINCONFIRMNO);
    __sqoop$field_map.put("C_BUSINTYPE", this.C_BUSINTYPE);
    __sqoop$field_map.put("L_SECTIONSCHEMANO", this.L_SECTIONSCHEMANO);
    __sqoop$field_map.put("C_EXPTYPE", this.C_EXPTYPE);
    __sqoop$field_map.put("C_SHAREADJUSTFLAG", this.C_SHAREADJUSTFLAG);
    __sqoop$field_map.put("C_INCOMEFLAG", this.C_INCOMEFLAG);
    __sqoop$field_map.put("EN_ACHIEVEMENTPAY", this.EN_ACHIEVEMENTPAY);
    __sqoop$field_map.put("EN_BREACHFEE", this.EN_BREACHFEE);
    __sqoop$field_map.put("VC_COMEFROM", this.VC_COMEFROM);
    __sqoop$field_map.put("VC_INVESTORSYSTEMID", this.VC_INVESTORSYSTEMID);
    __sqoop$field_map.put("VC_VOUCHERNO", this.VC_VOUCHERNO);
    __sqoop$field_map.put("C_BANKNO", this.C_BANKNO);
    __sqoop$field_map.put("VC_BANKNAME", this.VC_BANKNAME);
    __sqoop$field_map.put("VC_NAMEINBANK", this.VC_NAMEINBANK);
    __sqoop$field_map.put("VC_BANKACCO", this.VC_BANKACCO);
    __sqoop$field_map.put("VC_CUSTNO", this.VC_CUSTNO);
    __sqoop$field_map.put("VC_CONFIRMSETTLEDATE", this.VC_CONFIRMSETTLEDATE);
    __sqoop$field_map.put("VC_REQUESTSETTLEDATE", this.VC_REQUESTSETTLEDATE);
    __sqoop$field_map.put("VC_CONTRACTSERIALNO", this.VC_CONTRACTSERIALNO);
    __sqoop$field_map.put("C_PROFITCLASS", this.C_PROFITCLASS);
    __sqoop$field_map.put("VC_COMBREQUESTNO", this.VC_COMBREQUESTNO);
    __sqoop$field_map.put("VC_COMBCODE", this.VC_COMBCODE);
    __sqoop$field_map.put("C_AUTOREQUEST", this.C_AUTOREQUEST);
    __sqoop$field_map.put("VC_EXPLAIN", this.VC_EXPLAIN);
    __sqoop$field_map.put("C_INTERFACETYPE", this.C_INTERFACETYPE);
    __sqoop$field_map.put("EN_OTHERFEE1", this.EN_OTHERFEE1);
    __sqoop$field_map.put("EN_OTHERFEE2", this.EN_OTHERFEE2);
    __sqoop$field_map.put("C_MATCHFLAG", this.C_MATCHFLAG);
    __sqoop$field_map.put("VC_BOOKID", this.VC_BOOKID);
    __sqoop$field_map.put("EN_GRAMNUM", this.EN_GRAMNUM);
    __sqoop$field_map.put("C_FORCEREDEEMREASON", this.C_FORCEREDEEMREASON);
    __sqoop$field_map.put("EN_TOTALFROZENSHARE", this.EN_TOTALFROZENSHARE);
    __sqoop$field_map.put("EN_FUNDSHAREBALANCE", this.EN_FUNDSHAREBALANCE);
    __sqoop$field_map.put("EN_FROZENBALANCE", this.EN_FROZENBALANCE);
    __sqoop$field_map.put("VC_FUTURESUBSCRIBEDATE", this.VC_FUTURESUBSCRIBEDATE);
    __sqoop$field_map.put("VC_TRANSFERDATEFROMAGENCY", this.VC_TRANSFERDATEFROMAGENCY);
    __sqoop$field_map.put("EN_TAXADVANAMOUNT", this.EN_TAXADVANAMOUNT);
    __sqoop$field_map.put("VC_TAXADVANCODE", this.VC_TAXADVANCODE);
    __sqoop$field_map.put("VC_OTHERSERIALNO", this.VC_OTHERSERIALNO);
    __sqoop$field_map.put("C_ATTENDQUITFLAG", this.C_ATTENDQUITFLAG);
    __sqoop$field_map.put("VC_CUSTOMNAME_GS", this.VC_CUSTOMNAME_GS);
    __sqoop$field_map.put("C_IDENTITYTYPE_GS", this.C_IDENTITYTYPE_GS);
    __sqoop$field_map.put("VC_IDENTITYNO_GS", this.VC_IDENTITYNO_GS);
    __sqoop$field_map.put("VC_NATIONALITY_GS", this.VC_NATIONALITY_GS);
    __sqoop$field_map.put("VC_CERTCODE_GS", this.VC_CERTCODE_GS);
    __sqoop$field_map.put("VC_CERTDATE_GS", this.VC_CERTDATE_GS);
    __sqoop$field_map.put("EN_ACCTAXPRETAKEOFF_GS", this.EN_ACCTAXPRETAKEOFF_GS);
    __sqoop$field_map.put("INSERTTIME", this.INSERTTIME);
    __sqoop$field_map.put("UPDATETIME", this.UPDATETIME);
    __sqoop$field_map.put("20210422", this._20210422);
    __sqoop$field_map.put("'SALES'", this._SALES_);
    return __sqoop$field_map;
  }

  public void getFieldMap0(Map<String, Object> __sqoop$field_map) {
    __sqoop$field_map.put("C_CUSTTYPE", this.C_CUSTTYPE);
    __sqoop$field_map.put("VC_FUNDACCO", this.VC_FUNDACCO);
    __sqoop$field_map.put("VC_TRADEACCO", this.VC_TRADEACCO);
    __sqoop$field_map.put("C_TRUST", this.C_TRUST);
    __sqoop$field_map.put("VC_REQUESTDATE", this.VC_REQUESTDATE);
    __sqoop$field_map.put("VC_REQUESTNO", this.VC_REQUESTNO);
    __sqoop$field_map.put("VC_CONFIRMNO", this.VC_CONFIRMNO);
    __sqoop$field_map.put("VC_CONFIRMDATE", this.VC_CONFIRMDATE);
    __sqoop$field_map.put("VC_FUNDCODE", this.VC_FUNDCODE);
    __sqoop$field_map.put("C_SHARETYPE", this.C_SHARETYPE);
    __sqoop$field_map.put("VC_NETNO", this.VC_NETNO);
    __sqoop$field_map.put("VC_CENTERNO", this.VC_CENTERNO);
    __sqoop$field_map.put("EN_RATIO", this.EN_RATIO);
    __sqoop$field_map.put("EN_NAV", this.EN_NAV);
    __sqoop$field_map.put("EN_PROFIT", this.EN_PROFIT);
    __sqoop$field_map.put("C_BUSINFLAG", this.C_BUSINFLAG);
    __sqoop$field_map.put("EN_BALANCE", this.EN_BALANCE);
    __sqoop$field_map.put("EN_SHARE", this.EN_SHARE);
    __sqoop$field_map.put("EN_CONFIRMBALA", this.EN_CONFIRMBALA);
    __sqoop$field_map.put("C_MONEYTYPE", this.C_MONEYTYPE);
    __sqoop$field_map.put("EN_CONFIRMSHARE", this.EN_CONFIRMSHARE);
    __sqoop$field_map.put("EN_FARE", this.EN_FARE);
    __sqoop$field_map.put("EN_DEALFARE", this.EN_DEALFARE);
    __sqoop$field_map.put("EN_TAFARE", this.EN_TAFARE);
    __sqoop$field_map.put("EN_AFTERFARE", this.EN_AFTERFARE);
    __sqoop$field_map.put("EN_AGENCYFARE", this.EN_AGENCYFARE);
    __sqoop$field_map.put("EN_STAMPTAX", this.EN_STAMPTAX);
    __sqoop$field_map.put("C_CONFIRMFLAG", this.C_CONFIRMFLAG);
    __sqoop$field_map.put("VC_ERRORCODE", this.VC_ERRORCODE);
    __sqoop$field_map.put("VC_ERRORCAUSE", this.VC_ERRORCAUSE);
    __sqoop$field_map.put("C_VOUCHERFLAG", this.C_VOUCHERFLAG);
    __sqoop$field_map.put("EN_INTEREST", this.EN_INTEREST);
    __sqoop$field_map.put("EN_INTERESTTAX", this.EN_INTERESTTAX);
    __sqoop$field_map.put("C_ORGANIGER", this.C_ORGANIGER);
    __sqoop$field_map.put("VC_OTHERACCO", this.VC_OTHERACCO);
    __sqoop$field_map.put("VC_OTHERTRADEACCO", this.VC_OTHERTRADEACCO);
    __sqoop$field_map.put("C_OTHERAGENCYNO", this.C_OTHERAGENCYNO);
    __sqoop$field_map.put("VC_OTHERNETNO", this.VC_OTHERNETNO);
    __sqoop$field_map.put("VC_OTHERFUNDCODE", this.VC_OTHERFUNDCODE);
    __sqoop$field_map.put("C_OTHERSHARETYPE", this.C_OTHERSHARETYPE);
    __sqoop$field_map.put("EN_UNFROZENBALA", this.EN_UNFROZENBALA);
    __sqoop$field_map.put("EN_RETURNFARE", this.EN_RETURNFARE);
    __sqoop$field_map.put("EN_ORIGINFARE", this.EN_ORIGINFARE);
    __sqoop$field_map.put("VC_BROKER", this.VC_BROKER);
    __sqoop$field_map.put("C_DIVIDENDMETHOD", this.C_DIVIDENDMETHOD);
    __sqoop$field_map.put("C_FROZENCAUSE", this.C_FROZENCAUSE);
    __sqoop$field_map.put("VC_ORIGINNO", this.VC_ORIGINNO);
    __sqoop$field_map.put("VC_CITYNO", this.VC_CITYNO);
    __sqoop$field_map.put("VC_SELLER", this.VC_SELLER);
    __sqoop$field_map.put("VC_TACODE", this.VC_TACODE);
    __sqoop$field_map.put("EN_DISCOUNT", this.EN_DISCOUNT);
    __sqoop$field_map.put("EN_INCOME", this.EN_INCOME);
    __sqoop$field_map.put("EN_INVESTINCOME", this.EN_INVESTINCOME);
    __sqoop$field_map.put("EN_INVESTSHARE", this.EN_INVESTSHARE);
    __sqoop$field_map.put("C_FINISHFLAG", this.C_FINISHFLAG);
    __sqoop$field_map.put("C_INTERESTFLAG", this.C_INTERESTFLAG);
    __sqoop$field_map.put("C_CONFIRMSTATUS", this.C_CONFIRMSTATUS);
    __sqoop$field_map.put("EN_OTHERDISCOUNT", this.EN_OTHERDISCOUNT);
    __sqoop$field_map.put("EN_ENDDISCOUNT", this.EN_ENDDISCOUNT);
    __sqoop$field_map.put("VC_LIQUIDATEDATE", this.VC_LIQUIDATEDATE);
    __sqoop$field_map.put("C_SENDFLAG", this.C_SENDFLAG);
    __sqoop$field_map.put("VC_BRANCHCODE", this.VC_BRANCHCODE);
    __sqoop$field_map.put("EN_OTHERNAV", this.EN_OTHERNAV);
    __sqoop$field_map.put("EN_OTHERCONFIRMSHARE", this.EN_OTHERCONFIRMSHARE);
    __sqoop$field_map.put("EN_OTHERORIGINFARE", this.EN_OTHERORIGINFARE);
    __sqoop$field_map.put("C_FIXBUSINFLAG", this.C_FIXBUSINFLAG);
    __sqoop$field_map.put("C_CAPITALMODE", this.C_CAPITALMODE);
    __sqoop$field_map.put("C_SUBCAPITALMODE", this.C_SUBCAPITALMODE);
    __sqoop$field_map.put("VC_ORIGINCONFIRMNO", this.VC_ORIGINCONFIRMNO);
    __sqoop$field_map.put("C_BUSINTYPE", this.C_BUSINTYPE);
    __sqoop$field_map.put("L_SECTIONSCHEMANO", this.L_SECTIONSCHEMANO);
    __sqoop$field_map.put("C_EXPTYPE", this.C_EXPTYPE);
    __sqoop$field_map.put("C_SHAREADJUSTFLAG", this.C_SHAREADJUSTFLAG);
    __sqoop$field_map.put("C_INCOMEFLAG", this.C_INCOMEFLAG);
    __sqoop$field_map.put("EN_ACHIEVEMENTPAY", this.EN_ACHIEVEMENTPAY);
    __sqoop$field_map.put("EN_BREACHFEE", this.EN_BREACHFEE);
    __sqoop$field_map.put("VC_COMEFROM", this.VC_COMEFROM);
    __sqoop$field_map.put("VC_INVESTORSYSTEMID", this.VC_INVESTORSYSTEMID);
    __sqoop$field_map.put("VC_VOUCHERNO", this.VC_VOUCHERNO);
    __sqoop$field_map.put("C_BANKNO", this.C_BANKNO);
    __sqoop$field_map.put("VC_BANKNAME", this.VC_BANKNAME);
    __sqoop$field_map.put("VC_NAMEINBANK", this.VC_NAMEINBANK);
    __sqoop$field_map.put("VC_BANKACCO", this.VC_BANKACCO);
    __sqoop$field_map.put("VC_CUSTNO", this.VC_CUSTNO);
    __sqoop$field_map.put("VC_CONFIRMSETTLEDATE", this.VC_CONFIRMSETTLEDATE);
    __sqoop$field_map.put("VC_REQUESTSETTLEDATE", this.VC_REQUESTSETTLEDATE);
    __sqoop$field_map.put("VC_CONTRACTSERIALNO", this.VC_CONTRACTSERIALNO);
    __sqoop$field_map.put("C_PROFITCLASS", this.C_PROFITCLASS);
    __sqoop$field_map.put("VC_COMBREQUESTNO", this.VC_COMBREQUESTNO);
    __sqoop$field_map.put("VC_COMBCODE", this.VC_COMBCODE);
    __sqoop$field_map.put("C_AUTOREQUEST", this.C_AUTOREQUEST);
    __sqoop$field_map.put("VC_EXPLAIN", this.VC_EXPLAIN);
    __sqoop$field_map.put("C_INTERFACETYPE", this.C_INTERFACETYPE);
    __sqoop$field_map.put("EN_OTHERFEE1", this.EN_OTHERFEE1);
    __sqoop$field_map.put("EN_OTHERFEE2", this.EN_OTHERFEE2);
    __sqoop$field_map.put("C_MATCHFLAG", this.C_MATCHFLAG);
    __sqoop$field_map.put("VC_BOOKID", this.VC_BOOKID);
    __sqoop$field_map.put("EN_GRAMNUM", this.EN_GRAMNUM);
    __sqoop$field_map.put("C_FORCEREDEEMREASON", this.C_FORCEREDEEMREASON);
    __sqoop$field_map.put("EN_TOTALFROZENSHARE", this.EN_TOTALFROZENSHARE);
    __sqoop$field_map.put("EN_FUNDSHAREBALANCE", this.EN_FUNDSHAREBALANCE);
    __sqoop$field_map.put("EN_FROZENBALANCE", this.EN_FROZENBALANCE);
    __sqoop$field_map.put("VC_FUTURESUBSCRIBEDATE", this.VC_FUTURESUBSCRIBEDATE);
    __sqoop$field_map.put("VC_TRANSFERDATEFROMAGENCY", this.VC_TRANSFERDATEFROMAGENCY);
    __sqoop$field_map.put("EN_TAXADVANAMOUNT", this.EN_TAXADVANAMOUNT);
    __sqoop$field_map.put("VC_TAXADVANCODE", this.VC_TAXADVANCODE);
    __sqoop$field_map.put("VC_OTHERSERIALNO", this.VC_OTHERSERIALNO);
    __sqoop$field_map.put("C_ATTENDQUITFLAG", this.C_ATTENDQUITFLAG);
    __sqoop$field_map.put("VC_CUSTOMNAME_GS", this.VC_CUSTOMNAME_GS);
    __sqoop$field_map.put("C_IDENTITYTYPE_GS", this.C_IDENTITYTYPE_GS);
    __sqoop$field_map.put("VC_IDENTITYNO_GS", this.VC_IDENTITYNO_GS);
    __sqoop$field_map.put("VC_NATIONALITY_GS", this.VC_NATIONALITY_GS);
    __sqoop$field_map.put("VC_CERTCODE_GS", this.VC_CERTCODE_GS);
    __sqoop$field_map.put("VC_CERTDATE_GS", this.VC_CERTDATE_GS);
    __sqoop$field_map.put("EN_ACCTAXPRETAKEOFF_GS", this.EN_ACCTAXPRETAKEOFF_GS);
    __sqoop$field_map.put("INSERTTIME", this.INSERTTIME);
    __sqoop$field_map.put("UPDATETIME", this.UPDATETIME);
    __sqoop$field_map.put("20210422", this._20210422);
    __sqoop$field_map.put("'SALES'", this._SALES_);
  }

  public void setField(String __fieldName, Object __fieldVal) {
    if (!setters.containsKey(__fieldName)) {
      throw new RuntimeException("No such field:"+__fieldName);
    }
    setters.get(__fieldName).setField(__fieldVal);
  }

}
