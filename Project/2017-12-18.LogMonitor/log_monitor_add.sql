DROP PROCEDURE IF EXISTS log_monitor_add;
DELIMITER ;;
CREATE PROCEDURE log_monitor_add(IN in_logstore VARCHAR(200), IN in_col_value VARCHAR(100))
  BEGIN
    DECLARE log_monitor_projectname_id INT;
    DECLARE log_monitor_task_id INT;
    /*happigo-application*/
    IF in_logstore = 'happigo-application'
    THEN
      #log_monitor_projectname
      INSERT INTO log_monitor_projectname (logstore, col_name, col_value)
      VALUES (in_logstore, 'projectname', in_col_value);

      SELECT a.id
      INTO log_monitor_projectname_id
      FROM log_monitor_projectname a
      WHERE a.col_value = in_col_value;
      #log_monitor_task
      INSERT log_monitor_task (task_name, project, logstore, task_state, time_units)
        SELECT
          a.col_value task_name,
          a.logstore  project,
          a.logstore,
          -1          task_state,
          '5,10,60'   time_units
        FROM log_monitor_projectname a
        WHERE a.id = log_monitor_projectname_id;

      SELECT a.task_id
      INTO log_monitor_task_id
      FROM log_monitor_task a
      WHERE a.logstore = in_logstore AND a.task_name = in_col_value;

      UPDATE log_monitor_task a
      SET a.task_state = 1, a.task_query_sql = concat('projectname=', a.task_name,
                                                      '|select case when count(1) is null then 0 else count(1) end count_all,case when sum(case when loglevel=''info'' then 1 else 0 end) is null then 0 else sum(case when loglevel=''info'' then 1 else 0 end) end count_info,case when sum(case when loglevel=''error'' then 1 else 0 end) is null then 0 else sum(case when loglevel=''error'' then 1 else 0 end) end count_error,case when sum(case when loglevel=''warning'' then 1 else 0 end) is null then 0 else sum(case when loglevel=''warning'' then 1 else 0 end) end count_warning,case when sum(case when loglevel=''trace'' then 1 else 0 end) is null then 0 else sum(case when loglevel=''trace'' then 1 else 0 end) end count_trace,case when round(avg(totalexpend)) is null then 0 else round(avg(totalexpend)) end avg_expend_all,case when round(avg(case when loglevel=''info'' then totalexpend end)) is null then 0 else round(avg(case when loglevel=''info'' then totalexpend  end)) end avg_expend_info,case when round(avg(case when loglevel=''error'' then totalexpend end)) is null then 0 else round(avg(case when loglevel=''error'' then totalexpend end)) end avg_expend_error,case when round(avg(case when loglevel=''warning'' then totalexpend end)) is null then 0 else round(avg(case when loglevel=''warning'' then totalexpend end)) end avg_expend_warning,case when round(avg(case when loglevel=''trace'' then totalexpend end)) is null then 0 else round(avg(case when loglevel=''trace'' then totalexpend end)) end avg_expend_trace')
      WHERE a.task_id = log_monitor_task_id AND a.task_query_sql IS NULL;

    /*happigo-restapi*/
    ELSEIF in_logstore = 'happigo-restapi'
      THEN
        INSERT INTO log_monitor_projectname (logstore, col_name, col_value)
        VALUES (in_logstore, 'resource', in_col_value);

        SELECT a.id
        INTO log_monitor_projectname_id
        FROM log_monitor_projectname a
        WHERE a.col_value = in_col_value;

        INSERT log_monitor_task (task_name, project, logstore, task_state, time_units)
          SELECT
            a.col_value           task_name,
            'happigo-application' project,
            a.logstore,
            -1                    task_state,
            '5,10,60'             time_units
          FROM log_monitor_projectname a
          WHERE a.id = log_monitor_projectname_id;

        SELECT a.task_id
        INTO log_monitor_task_id
        FROM log_monitor_task a
        WHERE a.logstore = in_logstore AND a.task_name = in_col_value;

        UPDATE log_monitor_task A
        SET
          A.task_state = 1, A.task_query_sql = concat(substring_index(A.task_name, '_', 1), ' and method=',
                                                      substring_index(A.task_name, '_', -1),
                                                      '|select case when count(1) is null then 0 else count(1) end count_all,case when sum(case when loglevel=''info'' then 1 else 0 end) is null then 0 else sum(case when loglevel=''info'' then 1 else 0 end) end count_info,case when sum(case when loglevel=''error'' then 1 else 0 end) is null then 0 else sum(case when loglevel=''error'' then 1 else 0 end) end count_error,case when sum(case when loglevel=''warning'' then 1 else 0 end) is null then 0 else sum(case when loglevel=''warning'' then 1 else 0 end) end count_warning,case when sum(case when loglevel=''trace'' then 1 else 0 end) is null then 0 else sum(case when loglevel=''trace'' then 1 else 0 end) end count_trace,case when round(avg(totalexpend)) is null then 0 else round(avg(totalexpend)) end avg_expend_all,case when round(avg(case when loglevel=''info'' then totalexpend end)) is null then 0 else round(avg(case when loglevel=''info'' then totalexpend  end)) end avg_expend_info,case when round(avg(case when loglevel=''error'' then totalexpend end)) is null then 0 else round(avg(case when loglevel=''error'' then totalexpend end)) end avg_expend_error,case when round(avg(case when loglevel=''warning'' then totalexpend end)) is null then 0 else round(avg(case when loglevel=''warning'' then totalexpend end)) end avg_expend_warning,case when round(avg(case when loglevel=''trace'' then totalexpend end)) is null then 0 else round(avg(case when loglevel=''trace'' then totalexpend end)) end avg_expend_trace')
        WHERE A.logstore = 'happigo-restapi' AND A.task_query_sql IS NULL AND A.task_id = log_monitor_task_id;
    END IF;
  END;
;;
DELIMITER ;