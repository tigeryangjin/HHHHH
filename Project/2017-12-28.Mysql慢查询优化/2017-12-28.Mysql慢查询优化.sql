SELECT
  a.*,
  c.member_crmbp
FROM ec_member_point_changelog_klg AS a
  JOIN ec_member c ON a.member_id = c.member_id
WHERE NOT EXISTS(SELECT *
                 FROM ec_order AS b
                 WHERE a.operationObjectID = b.order_sn) AND a.state_type = 0 AND operationType = 1 AND a.changeType = 0
      AND a.handle_type = 1;

SELECT
  c.*,
  d.member_crmbp
FROM (
       SELECT a.*
       FROM ec_member_point_changelog_klg a LEFT JOIN ec_order b ON a.operationObjectID = b.order_sn
       WHERE a.state_type = 0 AND a.operationType = 1 AND a.changeType = 0
             AND a.handle_type = 1 ) c
  JOIN ec_member d ON c.member_id = d.member_id;

