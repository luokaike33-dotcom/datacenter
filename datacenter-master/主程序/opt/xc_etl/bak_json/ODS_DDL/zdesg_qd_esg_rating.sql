drop table if exists ty_ods.zdesg_qd_esg_rating;
create table if not exists ty_ods.zdesg_qd_esg_rating
(
  ticker string comment '上市公司代码',
  official_name string comment '公司全称',
  oaid string comment '上市公司oaid',
  report_date timestamp comment '报告期',
  gics string comment 'GICS行业分类',
  environment_management_score decimal(5,2) comment '环境管理得分',
  resources_efficiency_score decimal(5,2) comment '节能政策得分',
  environment_discharge_score decimal(5,2) comment '环境排放得分',
  climate_change_score decimal(5,2) comment '气候变化得分',
  human_capital_score decimal(5,2) comment '人力资本得分',
  health_and_safety_score decimal(5,2) comment '健康与安全得分',
  product_liability_score decimal(5,2) comment '产品责任得分',
  business_innovation_score decimal(5,2) comment '业务创新得分',
  social_capital_score decimal(5,2) comment '社会资本得分',
  governance_structure_score decimal(5,2) comment '治理结构得分',
  shareholders_score decimal(5,2) comment '股东得分',
  compliance_score decimal(5,2) comment '合规得分',
  audit_score decimal(5,2) comment '审计得分',
  transparency_score decimal(5,2) comment '信息披露得分',
  environment_management_rating string comment '环境管理评级',
  resources_efficiency_rating string comment '节能政策评级',
  environment_discharge_rating string comment '环境排放评级',
  climate_change_rating string comment '气候变化评级',
  human_capital_rating string comment '人力资本评级',
  health_and_safety_rating string comment '健康与安全评级',
  product_liability_rating string comment '产品责任评级',
  business_innovation_rating string comment '业务创新评级',
  social_capital_rating string comment '社会资本评级',
  governance_structure_rating string comment '治理结构评级',
  shareholders_rating string comment '股东评级',
  compliance_rating string comment '合规评级',
  audit_rating string comment '审计评级',
  transparency_rating string comment '信息披露评级',
  environmental_score decimal(5,2) comment '环境得分',
  social_score decimal(5,2) comment '社会得分',
  governance_score decimal(5,2) comment '治理得分',
  environmental_rating string comment '环境评级',
  social_rating string comment '社会评级',
  governance_rating string comment '治理评级',
  esg_score decimal(5,2) comment 'ESG得分',
  esg_rating string comment 'ESG评级',
  bath_dt string,
  data_ins_time timestamp,
  task_rs_id string
)
row format delimited fields terminated by '\t'
stored as orc;



