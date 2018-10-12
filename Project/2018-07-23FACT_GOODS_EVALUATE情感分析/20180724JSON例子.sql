DECLARE
  jsonArray json_list; --定义json数组
BEGIN
  jsonArray := json_list('[{
  "aspectCategory": "面料/材质",
  "aspectIndex": "29 31",
  "aspectTerm": "布料",
  "opinionTerm": "[null]",
  "aspectPolarity": "正"
}, {
  "aspectCategory": "填充物及含量",
  "aspectIndex": "27 29",
  "aspectTerm": "双层",
  "opinionTerm": "双层",
  "aspectPolarity": "正"
}, {
  "aspectCategory": "面料/材质",
  "aspectIndex": "33 35",
  "aspectTerm": "布料",
  "opinionTerm": "[null]",
  "aspectPolarity": "正"
}, {
  "aspectCategory": "面料/材质",
  "aspectIndex": "44 46",
  "aspectTerm": "里层",
  "opinionTerm": "[null]",
  "aspectPolarity": "负"
}]');
  for i in 1 .. jsonArray.count loop
    --循环
    dbms_output.put_line(json_ext.get_string(json(jsonArray.get(i)),
                                             'aspectCategory'));
  end loop;
END;
