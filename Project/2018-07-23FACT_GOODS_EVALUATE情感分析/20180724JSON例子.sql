DECLARE
  jsonArray json_list; --����json����
BEGIN
  jsonArray := json_list('[{
  "aspectCategory": "����/����",
  "aspectIndex": "29 31",
  "aspectTerm": "����",
  "opinionTerm": "[null]",
  "aspectPolarity": "��"
}, {
  "aspectCategory": "����Ｐ����",
  "aspectIndex": "27 29",
  "aspectTerm": "˫��",
  "opinionTerm": "˫��",
  "aspectPolarity": "��"
}, {
  "aspectCategory": "����/����",
  "aspectIndex": "33 35",
  "aspectTerm": "����",
  "opinionTerm": "[null]",
  "aspectPolarity": "��"
}, {
  "aspectCategory": "����/����",
  "aspectIndex": "44 46",
  "aspectTerm": "���",
  "opinionTerm": "[null]",
  "aspectPolarity": "��"
}]');
  for i in 1 .. jsonArray.count loop
    --ѭ��
    dbms_output.put_line(json_ext.get_string(json(jsonArray.get(i)),
                                             'aspectCategory'));
  end loop;
END;
