--1.创建类型
CREATE TYPE demo_queue_payload_type AS OBJECT
(
  message VARCHAR2(4000)
)
;

--2.创建队列表
BEGIN DBMS_AQADM.CREATE_QUEUE_TABLE(queue_table => 'demo_queue_table', queue_payload_type => 'demo_queue_payload_type'); END;

--3.创建队列
BEGIN DBMS_AQADM.CREATE_QUEUE(queue_name => 'demo_queue', queue_table => 'demo_queue_table'); DBMS_AQADM.START_QUEUE(queue_name => 'demo_queue'); END;

--4.
SELECT object_name, object_type FROM user_objects WHERE object_name != 'DEMO_QUEUE_PAYLOAD_TYPE';

--5.入队
DECLARE r_enqueue_options DBMS_AQ.ENQUEUE_OPTIONS_T; r_message_properties DBMS_AQ.MESSAGE_PROPERTIES_T; v_message_handle RAW(16); o_payload demo_queue_payload_type; BEGIN o_payload := demo_queue_payload_type('Here is a message'); DBMS_AQ.ENQUEUE(queue_name => 'demo_queue', enqueue_options => r_enqueue_options, message_properties => r_message_properties, payload => o_payload, msgid => v_message_handle); COMMIT; END;

--6.
SELECT * FROM aq$demo_queue_table;

SELECT user_data FROM aq$demo_queue_table;

--7.浏览
DECLARE

r_dequeue_options DBMS_AQ.DEQUEUE_OPTIONS_T; r_message_properties DBMS_AQ.MESSAGE_PROPERTIES_T; v_message_handle RAW(16); o_payload demo_queue_payload_type;

BEGIN

r_dequeue_options.dequeue_mode := DBMS_AQ.BROWSE;

DBMS_AQ.DEQUEUE(queue_name => 'demo_queue', dequeue_options => r_dequeue_options, message_properties => r_message_properties, payload => o_payload, msgid => v_message_handle);

DBMS_OUTPUT.PUT_LINE('*** Browsed message is [' || o_payload.message || '] ***');

END;
/

--8.出列
DECLARE

r_dequeue_options DBMS_AQ.DEQUEUE_OPTIONS_T; r_message_properties DBMS_AQ.MESSAGE_PROPERTIES_T; v_message_handle RAW(16); o_payload demo_queue_payload_type;

BEGIN

DBMS_AQ.DEQUEUE(queue_name => 'demo_queue', dequeue_options => r_dequeue_options, message_properties => r_message_properties, payload => o_payload, msgid => v_message_handle);

DBMS_OUTPUT.PUT_LINE('*** Dequeued message is [' || o_payload.message || '] ***');

COMMIT;

END;
/

--9.
