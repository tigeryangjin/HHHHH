UPDATE log_monitor_task a
SET a.task_query_sql = concat('projectname=', a.task_condition,
                              '|select case when count(1) is null then 0 else count(1) end count_all,case when sum(case when loglevel=''info'' then 1 else 0 end) is null then 0 else sum(case when loglevel=''info'' then 1 else 0 end) end count_info,case when sum(case when loglevel=''error'' then 1 else 0 end) is null then 0 else sum(case when loglevel=''error'' then 1 else 0 end) end count_error,case when sum(case when loglevel=''warning'' then 1 else 0 end) is null then 0 else sum(case when loglevel=''warning'' then 1 else 0 end) end count_warning,case when sum(case when loglevel=''trace'' then 1 else 0 end) is null then 0 else sum(case when loglevel=''trace'' then 1 else 0 end) end count_trace,case when round(avg(totalexpend)) is null then 0 else round(avg(totalexpend)) end avg_expend_all,case when round(avg(case when loglevel=''info'' then totalexpend end)) is null then 0 else round(avg(case when loglevel=''info'' then totalexpend  end)) end avg_expend_info,case when round(avg(case when loglevel=''error'' then totalexpend end)) is null then 0 else round(avg(case when loglevel=''error'' then totalexpend end)) end avg_expend_error,case when round(avg(case when loglevel=''warning'' then totalexpend end)) is null then 0 else round(avg(case when loglevel=''warning'' then totalexpend end)) end avg_expend_warning,case when round(avg(case when loglevel=''trace'' then totalexpend end)) is null then 0 else round(avg(case when loglevel=''trace'' then totalexpend end)) end avg_expend_trace')
WHERE a.task_query_sql IS NULL;

SELECT concat('projectname=', a.task_condition,
              '|select case when count(1) is null then 0 else count(1) end count_all,case when sum(case when loglevel=''info'' then 1 else 0 end) is null then 0 else sum(case when loglevel=''info'' then 1 else 0 end) end count_info,case when sum(case when loglevel=''error'' then 1 else 0 end) is null then 0 else sum(case when loglevel=''error'' then 1 else 0 end) end count_error,case when sum(case when loglevel=''warning'' then 1 else 0 end) is null then 0 else sum(case when loglevel=''warning'' then 1 else 0 end) end count_warning,case when sum(case when loglevel=''trace'' then 1 else 0 end) is null then 0 else sum(case when loglevel=''trace'' then 1 else 0 end) end count_trace,case when round(avg(totalexpend)) is null then 0 else round(avg(totalexpend)) end avg_expend_all,case when round(avg(case when loglevel=''info'' then totalexpend end)) is null then 0 else round(avg(case when loglevel=''info'' then totalexpend  end)) end avg_expend_info,case when round(avg(case when loglevel=''error'' then totalexpend end)) is null then 0 else round(avg(case when loglevel=''error'' then totalexpend end)) end avg_expend_error,case when round(avg(case when loglevel=''warning'' then totalexpend end)) is null then 0 else round(avg(case when loglevel=''warning'' then totalexpend end)) end avg_expend_warning,case when round(avg(case when loglevel=''trace'' then totalexpend end)) is null then 0 else round(avg(case when loglevel=''trace'' then totalexpend end)) end avg_expend_trace')
FROM log_monitor_task a;
#核对数据
SELECT
  a.id,
  a.task_id,
  a.time_unit,
  from_unixtime(a.create_time + 28800) create_time,
  from_unixtime(a.start_time + 28800)  start_time,
  from_unixtime(a.end_time + 28800)    end_time,
  a.count_all,
  a.count_info,
  a.count_error,
  a.count_warning,
  a.count_trace,
  a.avg_expend_all,
  a.avg_expend_info,
  a.avg_expend_error,
  a.avg_expend_warning,
  a.avg_expend_trace
FROM log_monitor_task_detail a
WHERE a.task_id = 2
ORDER BY a.task_id, a.time_unit, a.start_time;

#每个 Resource + 请求方法，作为一个监控任务
INSERT INTO log_monitor_projectname (logstore, col_name, col_value)
VALUES ('happigo-restapi', 'resource', 'ec.addresses');
INSERT INTO log_monitor_projectname (logstore, col_name, col_value)
VALUES ('happigo-restapi', 'resource', 'ec.app.brand.adsection');
INSERT INTO log_monitor_projectname (logstore, col_name, col_value)
VALUES ('happigo-restapi', 'resource', 'ec.app.cms.adfloor');
INSERT INTO log_monitor_projectname (logstore, col_name, col_value)
VALUES ('happigo-restapi', 'resource', 'ec.app.cms.adposition');
INSERT INTO log_monitor_projectname (logstore, col_name, col_value)
VALUES ('happigo-restapi', 'resource', 'ec.app.cms.newmember.zone.adfloor');
INSERT INTO log_monitor_projectname (logstore, col_name, col_value)
VALUES ('happigo-restapi', 'resource', 'ec.app.cms.news');
INSERT INTO log_monitor_projectname (logstore, col_name, col_value)
VALUES ('happigo-restapi', 'resource', 'ec.app.cms.store.bigeye');
INSERT INTO log_monitor_projectname (logstore, col_name, col_value)
VALUES ('happigo-restapi', 'resource', 'ec.app.cms.store.information.detail');
INSERT INTO log_monitor_projectname (logstore, col_name, col_value)
VALUES ('happigo-restapi', 'resource', 'ec.app.home.baseconfig');
INSERT INTO log_monitor_projectname (logstore, col_name, col_value)
VALUES ('happigo-restapi', 'resource', 'ec.app.home.bigeyes');
INSERT INTO log_monitor_projectname (logstore, col_name, col_value)
VALUES ('happigo-restapi', 'resource', 'ec.app.home.ecconfig');
INSERT INTO log_monitor_projectname (logstore, col_name, col_value)
VALUES ('happigo-restapi', 'resource', 'ec.app.home.limitedtimesale.goods');
INSERT INTO log_monitor_projectname (logstore, col_name, col_value)
VALUES ('happigo-restapi', 'resource', 'ec.app.home.menubars');
INSERT INTO log_monitor_projectname (logstore, col_name, col_value)
VALUES ('happigo-restapi', 'resource', 'ec.app.home.tvconfig');
INSERT INTO log_monitor_projectname (logstore, col_name, col_value)
VALUES ('happigo-restapi', 'resource', 'ec.app.hot.searchkey');
INSERT INTO log_monitor_projectname (logstore, col_name, col_value)
VALUES ('happigo-restapi', 'resource', 'ec.app.hotsell.goods');
INSERT INTO log_monitor_projectname (logstore, col_name, col_value)
VALUES ('happigo-restapi', 'resource', 'ec.app.launchscreen');
INSERT INTO log_monitor_projectname (logstore, col_name, col_value)
VALUES ('happigo-restapi', 'resource', 'ec.app.live.banner');
INSERT INTO log_monitor_projectname (logstore, col_name, col_value)
VALUES ('happigo-restapi', 'resource', 'ec.app.live.channel');
INSERT INTO log_monitor_projectname (logstore, col_name, col_value)
VALUES ('happigo-restapi', 'resource', 'ec.app.live.channel.goods');
INSERT INTO log_monitor_projectname (logstore, col_name, col_value)
VALUES ('happigo-restapi', 'resource', 'ec.app.live.hotsection');
INSERT INTO log_monitor_projectname (logstore, col_name, col_value)
VALUES ('happigo-restapi', 'resource', 'ec.app.live.tv.hotgoods');
INSERT INTO log_monitor_projectname (logstore, col_name, col_value)
VALUES ('happigo-restapi', 'resource', 'ec.app.live.tv.livegoods');
INSERT INTO log_monitor_projectname (logstore, col_name, col_value)
VALUES ('happigo-restapi', 'resource', 'ec.app.live.tv.newgoods');
INSERT INTO log_monitor_projectname (logstore, col_name, col_value)
VALUES ('happigo-restapi', 'resource', 'ec.app.newandhot');
INSERT INTO log_monitor_projectname (logstore, col_name, col_value)
VALUES ('happigo-restapi', 'resource', 'ec.app.pop');
INSERT INTO log_monitor_projectname (logstore, col_name, col_value)
VALUES ('happigo-restapi', 'resource', 'ec.app.sd.entry');
INSERT INTO log_monitor_projectname (logstore, col_name, col_value)
VALUES ('happigo-restapi', 'resource', 'ec.app.sd.goods');
INSERT INTO log_monitor_projectname (logstore, col_name, col_value)
VALUES ('happigo-restapi', 'resource', 'ec.app.sd.head');
INSERT INTO log_monitor_projectname (logstore, col_name, col_value)
VALUES ('happigo-restapi', 'resource', 'ec.app.search.brand');
INSERT INTO log_monitor_projectname (logstore, col_name, col_value)
VALUES ('happigo-restapi', 'resource', 'ec.app.search.filter');
INSERT INTO log_monitor_projectname (logstore, col_name, col_value)
VALUES ('happigo-restapi', 'resource', 'ec.app.search.goods');
INSERT INTO log_monitor_projectname (logstore, col_name, col_value)
VALUES ('happigo-restapi', 'resource', 'ec.app.search.hotclass');
INSERT INTO log_monitor_projectname (logstore, col_name, col_value)
VALUES ('happigo-restapi', 'resource', 'ec.app.search.hotkey');
INSERT INTO log_monitor_projectname (logstore, col_name, col_value)
VALUES ('happigo-restapi', 'resource', 'ec.app.send');
INSERT INTO log_monitor_projectname (logstore, col_name, col_value)
VALUES ('happigo-restapi', 'resource', 'ec.app.version');
INSERT INTO log_monitor_projectname (logstore, col_name, col_value)
VALUES ('happigo-restapi', 'resource', 'ec.app.zt.detail');
INSERT INTO log_monitor_projectname (logstore, col_name, col_value)
VALUES ('happigo-restapi', 'resource', 'ec.app.zt.goods');
INSERT INTO log_monitor_projectname (logstore, col_name, col_value) VALUES ('happigo-restapi', 'resource', 'ec.brand');
INSERT INTO log_monitor_projectname (logstore, col_name, col_value)
VALUES ('happigo-restapi', 'resource', 'ec.brandzt');
INSERT INTO log_monitor_projectname (logstore, col_name, col_value)
VALUES ('happigo-restapi', 'resource', 'ec.brandzt.summary');
INSERT INTO log_monitor_projectname (logstore, col_name, col_value)
VALUES ('happigo-restapi', 'resource', 'ec.cashier');
INSERT INTO log_monitor_projectname (logstore, col_name, col_value)
VALUES ('happigo-restapi', 'resource', 'ec.cashier.payment');
INSERT INTO log_monitor_projectname (logstore, col_name, col_value)
VALUES ('happigo-restapi', 'resource', 'ec.cms.defaultsearch');
INSERT INTO log_monitor_projectname (logstore, col_name, col_value)
VALUES ('happigo-restapi', 'resource', 'ec.cms.message');
INSERT INTO log_monitor_projectname (logstore, col_name, col_value)
VALUES ('happigo-restapi', 'resource', 'ec.comments');
INSERT INTO log_monitor_projectname (logstore, col_name, col_value)
VALUES ('happigo-restapi', 'resource', 'ec.complain.list');
INSERT INTO log_monitor_projectname (logstore, col_name, col_value)
VALUES ('happigo-restapi', 'resource', 'ec.dictionary.addresses');
INSERT INTO log_monitor_projectname (logstore, col_name, col_value)
VALUES ('happigo-restapi', 'resource', 'ec.distribution.distributor');
INSERT INTO log_monitor_projectname (logstore, col_name, col_value)
VALUES ('happigo-restapi', 'resource', 'ec.distribution.distributor.account');
INSERT INTO log_monitor_projectname (logstore, col_name, col_value)
VALUES ('happigo-restapi', 'resource', 'ec.distribution.order');
INSERT INTO log_monitor_projectname (logstore, col_name, col_value)
VALUES ('happigo-restapi', 'resource', 'ec.distribution.relation');
INSERT INTO log_monitor_projectname (logstore, col_name, col_value)
VALUES ('happigo-restapi', 'resource', 'ec.favorites');
INSERT INTO log_monitor_projectname (logstore, col_name, col_value) VALUES ('happigo-restapi', 'resource', 'ec.goods');
INSERT INTO log_monitor_projectname (logstore, col_name, col_value)
VALUES ('happigo-restapi', 'resource', 'ec.goods.class');
INSERT INTO log_monitor_projectname (logstore, col_name, col_value)
VALUES ('happigo-restapi', 'resource', 'ec.goods.class.hotbrand');
INSERT INTO log_monitor_projectname (logstore, col_name, col_value)
VALUES ('happigo-restapi', 'resource', 'ec.goods.class.reftree');
INSERT INTO log_monitor_projectname (logstore, col_name, col_value)
VALUES ('happigo-restapi', 'resource', 'ec.goods.classify');
INSERT INTO log_monitor_projectname (logstore, col_name, col_value)
VALUES ('happigo-restapi', 'resource', 'ec.goods.comments');
INSERT INTO log_monitor_projectname (logstore, col_name, col_value)
VALUES ('happigo-restapi', 'resource', 'ec.goods.comments.myself');
INSERT INTO log_monitor_projectname (logstore, col_name, col_value)
VALUES ('happigo-restapi', 'resource', 'ec.goods.comments.recommend');
INSERT INTO log_monitor_projectname (logstore, col_name, col_value)
VALUES ('happigo-restapi', 'resource', 'ec.goods.gift');
INSERT INTO log_monitor_projectname (logstore, col_name, col_value)
VALUES ('happigo-restapi', 'resource', 'ec.goods.outstocklog');
INSERT INTO log_monitor_projectname (logstore, col_name, col_value)
VALUES ('happigo-restapi', 'resource', 'ec.goods.qa');
INSERT INTO log_monitor_projectname (logstore, col_name, col_value)
VALUES ('happigo-restapi', 'resource', 'ec.goods.recommend');
INSERT INTO log_monitor_projectname (logstore, col_name, col_value)
VALUES ('happigo-restapi', 'resource', 'ec.goods.refvoucher');
INSERT INTO log_monitor_projectname (logstore, col_name, col_value)
VALUES ('happigo-restapi', 'resource', 'ec.goods.rush');
INSERT INTO log_monitor_projectname (logstore, col_name, col_value)
VALUES ('happigo-restapi', 'resource', 'ec.goods.similarity');
INSERT INTO log_monitor_projectname (logstore, col_name, col_value)
VALUES ('happigo-restapi', 'resource', 'ec.goods.similarity.detail');
INSERT INTO log_monitor_projectname (logstore, col_name, col_value)
VALUES ('happigo-restapi', 'resource', 'ec.goods.specify');
INSERT INTO log_monitor_projectname (logstore, col_name, col_value)
VALUES ('happigo-restapi', 'resource', 'ec.goods.xianshi');
INSERT INTO log_monitor_projectname (logstore, col_name, col_value)
VALUES ('happigo-restapi', 'resource', 'ec.goodslist.brand');
INSERT INTO log_monitor_projectname (logstore, col_name, col_value)
VALUES ('happigo-restapi', 'resource', 'ec.goodslist.class');
INSERT INTO log_monitor_projectname (logstore, col_name, col_value)
VALUES ('happigo-restapi', 'resource', 'ec.grouppurchase');
INSERT INTO log_monitor_projectname (logstore, col_name, col_value)
VALUES ('happigo-restapi', 'resource', 'ec.grouppurchase.banner');
INSERT INTO log_monitor_projectname (logstore, col_name, col_value)
VALUES ('happigo-restapi', 'resource', 'ec.grouppurchase.goods');
INSERT INTO log_monitor_projectname (logstore, col_name, col_value)
VALUES ('happigo-restapi', 'resource', 'ec.grouppurchase.orders');
INSERT INTO log_monitor_projectname (logstore, col_name, col_value)
VALUES ('happigo-restapi', 'resource', 'ec.grouppurchase.orders.confirm');
INSERT INTO log_monitor_projectname (logstore, col_name, col_value)
VALUES ('happigo-restapi', 'resource', 'ec.grouppurchase.recommend');
INSERT INTO log_monitor_projectname (logstore, col_name, col_value)
VALUES ('happigo-restapi', 'resource', 'ec.grouppurchase.task');
INSERT INTO log_monitor_projectname (logstore, col_name, col_value)
VALUES ('happigo-restapi', 'resource', 'ec.grouppurchase.task.share');
INSERT INTO log_monitor_projectname (logstore, col_name, col_value)
VALUES ('happigo-restapi', 'resource', 'ec.headlines');
INSERT INTO log_monitor_projectname (logstore, col_name, col_value)
VALUES ('happigo-restapi', 'resource', 'ec.historyorders');
INSERT INTO log_monitor_projectname (logstore, col_name, col_value)
VALUES ('happigo-restapi', 'resource', 'ec.home.channel.adfloor');
INSERT INTO log_monitor_projectname (logstore, col_name, col_value)
VALUES ('happigo-restapi', 'resource', 'ec.home.channel.carousel');
INSERT INTO log_monitor_projectname (logstore, col_name, col_value)
VALUES ('happigo-restapi', 'resource', 'ec.home.channel.floor');
INSERT INTO log_monitor_projectname (logstore, col_name, col_value)
VALUES ('happigo-restapi', 'resource', 'ec.home.channel.goods');
INSERT INTO log_monitor_projectname (logstore, col_name, col_value)
VALUES ('happigo-restapi', 'resource', 'ec.home.recommend.floor');
INSERT INTO log_monitor_projectname (logstore, col_name, col_value)
VALUES ('happigo-restapi', 'resource', 'ec.home.recommend.goods');
INSERT INTO log_monitor_projectname (logstore, col_name, col_value)
VALUES ('happigo-restapi', 'resource', 'ec.home.recommend.realtime.orders');
INSERT INTO log_monitor_projectname (logstore, col_name, col_value)
VALUES ('happigo-restapi', 'resource', 'ec.home.recommend.top.banner.login');
INSERT INTO log_monitor_projectname (logstore, col_name, col_value)
VALUES ('happigo-restapi', 'resource', 'ec.home.recommend.top.banner.loginout');
INSERT INTO log_monitor_projectname (logstore, col_name, col_value)
VALUES ('happigo-restapi', 'resource', 'ec.home.top.menu');
INSERT INTO log_monitor_projectname (logstore, col_name, col_value)
VALUES ('happigo-restapi', 'resource', 'ec.home.tvgo.hotsale.goods');
INSERT INTO log_monitor_projectname (logstore, col_name, col_value)
VALUES ('happigo-restapi', 'resource', 'ec.home.tvgo.live.setting');
INSERT INTO log_monitor_projectname (logstore, col_name, col_value)
VALUES ('happigo-restapi', 'resource', 'ec.image.upload');
INSERT INTO log_monitor_projectname (logstore, col_name, col_value) VALUES ('happigo-restapi', 'resource', 'ec.join');
INSERT INTO log_monitor_projectname (logstore, col_name, col_value)
VALUES ('happigo-restapi', 'resource', 'ec.jsonapi.ticket');
INSERT INTO log_monitor_projectname (logstore, col_name, col_value) VALUES ('happigo-restapi', 'resource', 'ec.member');
INSERT INTO log_monitor_projectname (logstore, col_name, col_value)
VALUES ('happigo-restapi', 'resource', 'ec.member.account');
INSERT INTO log_monitor_projectname (logstore, col_name, col_value)
VALUES ('happigo-restapi', 'resource', 'ec.member.assets.summary');
INSERT INTO log_monitor_projectname (logstore, col_name, col_value)
VALUES ('happigo-restapi', 'resource', 'ec.member.assets.voucher');
INSERT INTO log_monitor_projectname (logstore, col_name, col_value)
VALUES ('happigo-restapi', 'resource', 'ec.member.auth');
INSERT INTO log_monitor_projectname (logstore, col_name, col_value)
VALUES ('happigo-restapi', 'resource', 'ec.member.authbyopenid');
INSERT INTO log_monitor_projectname (logstore, col_name, col_value)
VALUES ('happigo-restapi', 'resource', 'ec.member.authbyopenid.verifycode');
INSERT INTO log_monitor_projectname (logstore, col_name, col_value)
VALUES ('happigo-restapi', 'resource', 'ec.member.authbysms');
INSERT INTO log_monitor_projectname (logstore, col_name, col_value)
VALUES ('happigo-restapi', 'resource', 'ec.member.bind');
INSERT INTO log_monitor_projectname (logstore, col_name, col_value)
VALUES ('happigo-restapi', 'resource', 'ec.member.checktoken');
INSERT INTO log_monitor_projectname (logstore, col_name, col_value)
VALUES ('happigo-restapi', 'resource', 'ec.member.feedback');
INSERT INTO log_monitor_projectname (logstore, col_name, col_value)
VALUES ('happigo-restapi', 'resource', 'ec.member.goods.bought');
INSERT INTO log_monitor_projectname (logstore, col_name, col_value)
VALUES ('happigo-restapi', 'resource', 'ec.member.mobile');
INSERT INTO log_monitor_projectname (logstore, col_name, col_value)
VALUES ('happigo-restapi', 'resource', 'ec.member.newtag');
INSERT INTO log_monitor_projectname (logstore, col_name, col_value)
VALUES ('happigo-restapi', 'resource', 'ec.member.orders.summary');
INSERT INTO log_monitor_projectname (logstore, col_name, col_value)
VALUES ('happigo-restapi', 'resource', 'ec.member.password');
INSERT INTO log_monitor_projectname (logstore, col_name, col_value)
VALUES ('happigo-restapi', 'resource', 'ec.member.paypassword');
INSERT INTO log_monitor_projectname (logstore, col_name, col_value)
VALUES ('happigo-restapi', 'resource', 'ec.member.query');
INSERT INTO log_monitor_projectname (logstore, col_name, col_value)
VALUES ('happigo-restapi', 'resource', 'ec.member.summary');
INSERT INTO log_monitor_projectname (logstore, col_name, col_value)
VALUES ('happigo-restapi', 'resource', 'ec.member.tax');
INSERT INTO log_monitor_projectname (logstore, col_name, col_value)
VALUES ('happigo-restapi', 'resource', 'ec.member.tier');
INSERT INTO log_monitor_projectname (logstore, col_name, col_value)
VALUES ('happigo-restapi', 'resource', 'ec.message');
INSERT INTO log_monitor_projectname (logstore, col_name, col_value)
VALUES ('happigo-restapi', 'resource', 'ec.message.group');
INSERT INTO log_monitor_projectname (logstore, col_name, col_value)
VALUES ('happigo-restapi', 'resource', 'ec.message.unread');
INSERT INTO log_monitor_projectname (logstore, col_name, col_value)
VALUES ('happigo-restapi', 'resource', 'ec.messagecenter');
INSERT INTO log_monitor_projectname (logstore, col_name, col_value)
VALUES ('happigo-restapi', 'resource', 'ec.order.recommend');
INSERT INTO log_monitor_projectname (logstore, col_name, col_value)
VALUES ('happigo-restapi', 'resource', 'ec.order.share.reward');
INSERT INTO log_monitor_projectname (logstore, col_name, col_value)
VALUES ('happigo-restapi', 'resource', 'ec.order.shippingalert');
INSERT INTO log_monitor_projectname (logstore, col_name, col_value) VALUES ('happigo-restapi', 'resource', 'ec.orders');
INSERT INTO log_monitor_projectname (logstore, col_name, col_value)
VALUES ('happigo-restapi', 'resource', 'ec.orders.confirm');
INSERT INTO log_monitor_projectname (logstore, col_name, col_value)
VALUES ('happigo-restapi', 'resource', 'ec.orders.delete');
INSERT INTO log_monitor_projectname (logstore, col_name, col_value)
VALUES ('happigo-restapi', 'resource', 'ec.orders.goods');
INSERT INTO log_monitor_projectname (logstore, col_name, col_value)
VALUES ('happigo-restapi', 'resource', 'ec.orders.logistics');
INSERT INTO log_monitor_projectname (logstore, col_name, col_value)
VALUES ('happigo-restapi', 'resource', 'ec.orders.logistics.pakeage');
INSERT INTO log_monitor_projectname (logstore, col_name, col_value)
VALUES ('happigo-restapi', 'resource', 'ec.orders.payment');
INSERT INTO log_monitor_projectname (logstore, col_name, col_value)
VALUES ('happigo-restapi', 'resource', 'ec.orders.refund');
INSERT INTO log_monitor_projectname (logstore, col_name, col_value)
VALUES ('happigo-restapi', 'resource', 'ec.orders.summary');
INSERT INTO log_monitor_projectname (logstore, col_name, col_value)
VALUES ('happigo-restapi', 'resource', 'ec.payment.notify');
INSERT INTO log_monitor_projectname (logstore, col_name, col_value)
VALUES ('happigo-restapi', 'resource', 'ec.rec.home.goods');
INSERT INTO log_monitor_projectname (logstore, col_name, col_value)
VALUES ('happigo-restapi', 'resource', 'ec.return.goods');
INSERT INTO log_monitor_projectname (logstore, col_name, col_value)
VALUES ('happigo-restapi', 'resource', 'ec.return.goods.apply');
INSERT INTO log_monitor_projectname (logstore, col_name, col_value)
VALUES ('happigo-restapi', 'resource', 'ec.return.goods.info');
INSERT INTO log_monitor_projectname (logstore, col_name, col_value)
VALUES ('happigo-restapi', 'resource', 'ec.return.progress.detail');
INSERT INTO log_monitor_projectname (logstore, col_name, col_value)
VALUES ('happigo-restapi', 'resource', 'ec.search.keysuggest');
INSERT INTO log_monitor_projectname (logstore, col_name, col_value)
VALUES ('happigo-restapi', 'resource', 'ec.server.time');
INSERT INTO log_monitor_projectname (logstore, col_name, col_value)
VALUES ('happigo-restapi', 'resource', 'ec.shipping.addresses');
INSERT INTO log_monitor_projectname (logstore, col_name, col_value)
VALUES ('happigo-restapi', 'resource', 'ec.shoppingcart');
INSERT INTO log_monitor_projectname (logstore, col_name, col_value)
VALUES ('happigo-restapi', 'resource', 'ec.shoppingcart.goods');
INSERT INTO log_monitor_projectname (logstore, col_name, col_value)
VALUES ('happigo-restapi', 'resource', 'ec.shoppingcart.recommend.goods');
INSERT INTO log_monitor_projectname (logstore, col_name, col_value) VALUES ('happigo-restapi', 'resource', 'ec.store');
INSERT INTO log_monitor_projectname (logstore, col_name, col_value)
VALUES ('happigo-restapi', 'resource', 'ec.store.onlineservice');
INSERT INTO log_monitor_projectname (logstore, col_name, col_value)
VALUES ('happigo-restapi', 'resource', 'ec.store.onlineservice.lastmessage');
INSERT INTO log_monitor_projectname (logstore, col_name, col_value)
VALUES ('happigo-restapi', 'resource', 'ec.store.promotions');
INSERT INTO log_monitor_projectname (logstore, col_name, col_value)
VALUES ('happigo-restapi', 'resource', 'ec.store.recommend');
INSERT INTO log_monitor_projectname (logstore, col_name, col_value)
VALUES ('happigo-restapi', 'resource', 'ec.store.recommend.list');
INSERT INTO log_monitor_projectname (logstore, col_name, col_value)
VALUES ('happigo-restapi', 'resource', 'ec.store.summary');
INSERT INTO log_monitor_projectname (logstore, col_name, col_value)
VALUES ('happigo-restapi', 'resource', 'ec.store.voucher');
INSERT INTO log_monitor_projectname (logstore, col_name, col_value)
VALUES ('happigo-restapi', 'resource', 'ec.super.ad');
INSERT INTO log_monitor_projectname (logstore, col_name, col_value)
VALUES ('happigo-restapi', 'resource', 'ec.supplier');
INSERT INTO log_monitor_projectname (logstore, col_name, col_value)
VALUES ('happigo-restapi', 'resource', 'ec.supplier.summary');
INSERT INTO log_monitor_projectname (logstore, col_name, col_value)
VALUES ('happigo-restapi', 'resource', 'ec.system.message');
INSERT INTO log_monitor_projectname (logstore, col_name, col_value)
VALUES ('happigo-restapi', 'resource', 'ec.talent.list');
INSERT INTO log_monitor_projectname (logstore, col_name, col_value)
VALUES ('happigo-restapi', 'resource', 'ec.talent.today');
INSERT INTO log_monitor_projectname (logstore, col_name, col_value)
VALUES ('happigo-restapi', 'resource', 'ec.thirdpart.control');
INSERT INTO log_monitor_projectname (logstore, col_name, col_value)
VALUES ('happigo-restapi', 'resource', 'ec.tv.live');
INSERT INTO log_monitor_projectname (logstore, col_name, col_value)
VALUES ('happigo-restapi', 'resource', 'ec.tv.live.current');
INSERT INTO log_monitor_projectname (logstore, col_name, col_value)
VALUES ('happigo-restapi', 'resource', 'ec.tv.live.goods');
INSERT INTO log_monitor_projectname (logstore, col_name, col_value)
VALUES ('happigo-restapi', 'resource', 'ec.tv.liveroom');
INSERT INTO log_monitor_projectname (logstore, col_name, col_value)
VALUES ('happigo-restapi', 'resource', 'ec.tv.liveroom.goods');
INSERT INTO log_monitor_projectname (logstore, col_name, col_value)
VALUES ('happigo-restapi', 'resource', 'ec.verifycode');
INSERT INTO log_monitor_projectname (logstore, col_name, col_value)
VALUES ('happigo-restapi', 'resource', 'ec.verifycode.repeattime');
INSERT INTO log_monitor_projectname (logstore, col_name, col_value)
VALUES ('happigo-restapi', 'resource', 'ec.voucher.goods');
INSERT INTO log_monitor_projectname (logstore, col_name, col_value)
VALUES ('happigo-restapi', 'resource', 'ec.voucher.list');
INSERT INTO log_monitor_projectname (logstore, col_name, col_value)
VALUES ('happigo-restapi', 'resource', 'ec.wx.access');

# resource +method插入log_monitor_task
INSERT log_monitor_task (task_name, project, logstore, task_state, time_units)
  SELECT
    concat(a.col_value, '_', b.METHOD) task_name,
    'happigo-application'              project,
    a.logstore,
    -1                                 task_state,
    '5,10,60'                          time_units
  FROM log_monitor_projectname a, (SELECT 'GET' METHOD
                                   UNION ALL
                                   SELECT 'POST'
                                   UNION ALL
                                   SELECT 'PUT'
                                   UNION ALL
                                   SELECT 'DELETE') b
  WHERE a.logstore = 'happigo-restapi';
#更新task_query_sql字段
UPDATE log_monitor_task A
SET
  A.task_query_sql = concat(substring_index(A.task_name, '_', 1), ' and method=', substring_index(A.task_name, '_', -1),
                            '|select case when count(1) is null then 0 else count(1) end count_all,case when sum(case when loglevel=''info'' then 1 else 0 end) is null then 0 else sum(case when loglevel=''info'' then 1 else 0 end) end count_info,case when sum(case when loglevel=''error'' then 1 else 0 end) is null then 0 else sum(case when loglevel=''error'' then 1 else 0 end) end count_error,case when sum(case when loglevel=''warning'' then 1 else 0 end) is null then 0 else sum(case when loglevel=''warning'' then 1 else 0 end) end count_warning,case when sum(case when loglevel=''trace'' then 1 else 0 end) is null then 0 else sum(case when loglevel=''trace'' then 1 else 0 end) end count_trace,case when round(avg(totalexpend)) is null then 0 else round(avg(totalexpend)) end avg_expend_all,case when round(avg(case when loglevel=''info'' then totalexpend end)) is null then 0 else round(avg(case when loglevel=''info'' then totalexpend  end)) end avg_expend_info,case when round(avg(case when loglevel=''error'' then totalexpend end)) is null then 0 else round(avg(case when loglevel=''error'' then totalexpend end)) end avg_expend_error,case when round(avg(case when loglevel=''warning'' then totalexpend end)) is null then 0 else round(avg(case when loglevel=''warning'' then totalexpend end)) end avg_expend_warning,case when round(avg(case when loglevel=''trace'' then totalexpend end)) is null then 0 else round(avg(case when loglevel=''trace'' then totalexpend end)) end avg_expend_trace')
WHERE A.logstore = 'happigo-restapi' AND A.task_query_sql IS NULL;

#没有数据的task，把task_state写成-1
UPDATE log_monitor_task a
SET a.task_state = -1
WHERE a.logstore = 'happigo-restapi'
      /*count_all合计=0*/
      AND exists(SELECT 1
                 FROM (SELECT
                         c.task_id,
                         sum(c.count_all) count_all
                       FROM log_monitor_task_detail c
                       WHERE c.remark IS NULL
                       GROUP BY c.task_id) b
                 WHERE a.task_id = b.task_id AND b.count_all = 0)
      /*不存在bak中*/
      AND NOT exists(SELECT 1
                     FROM (SELECT concat(substring_index(substring_index(upper(d.task_name), '_', 1), '/', 1), '.',
                                         substring_index(upper(d.task_name), '_', -1)) task_name1
                           FROM log_monitor_task_bak d
                           ORDER BY d.task_name) e
                     WHERE concat(substring_index(substring_index(upper(a.task_name), '_', 1), '/', 1), '.',
                                  substring_index(upper(a.task_name), '_', -1)) = e.task_name1);

SELECT *
FROM log_monitor_task a;

SELECT
  concat(substring_index(substring_index(upper(a.task_name), '_', 1), '/', 1), '.',
         substring_index(upper(a.task_name), '_', -1)) task_name1,
  count(1)
FROM log_monitor_task_bak a
GROUP BY concat(substring_index(substring_index(upper(a.task_name), '_', 1), '/', 1), '.',
                substring_index(upper(a.task_name), '_', -1))
HAVING count(1) > 1;

SELECT *
FROM log_monitor_task_bak a
WHERE concat(substring_index(substring_index(upper(a.task_name), '_', 1), '/', 1), '.',
             substring_index(upper(a.task_name), '_', -1)) = 'EC.GOODS.CLASS.GET';

/*-------------------------------------------------------------------------------------
慢查询日志监控
-------------------------------------------------------------------------------------*/
INSERT log_monitor_slow_query (ip, project, logstore, task_name_display, task_query_sql, task_state, time_units)
VALUES ('10.16.2.156', 'happigo-application', 'happigo_mysql_slow_log', 'ip:10.16.2.156',
        '* and source: 10.16.2.156 and Query_time|select count(1) cnt limit 1000', 1, '5,10,60');
INSERT log_monitor_slow_query (ip, project, logstore, task_name_display, task_query_sql, task_state, time_units)
VALUES ('10.16.2.187', 'happigo-application', 'happigo_mysql_slow_log', 'ip:10.16.2.187',
        '* and source: 10.16.2.187 and Query_time|select count(1) cnt limit 1000', 1, '5,10,60');
INSERT log_monitor_slow_query (ip, project, logstore, task_name_display, task_query_sql, task_state, time_units)
VALUES ('10.16.2.201', 'happigo-application', 'happigo_mysql_slow_log', 'ip:10.16.2.201',
        '* and source: 10.16.2.201 and Query_time|select count(1) cnt limit 1000', 1, '5,10,60');
INSERT log_monitor_slow_query (ip, project, logstore, task_name_display, task_query_sql, task_state, time_units)
VALUES ('10.16.2.98', 'happigo-application', 'happigo_mysql_slow_log', 'ip:10.16.2.98',
        '* and source: 10.16.2.98 and Query_time|select count(1) cnt limit 1000', 1, '5,10,60');
INSERT log_monitor_slow_query (ip, project, logstore, task_name_display, task_query_sql, task_state, time_units)
VALUES ('10.16.2.177', 'happigo-application', 'happigo_mysql_slow_log', 'ip:10.16.2.177',
        '* and source: 10.16.2.177 and Query_time|select count(1) cnt limit 1000', 1, '5,10,60');
INSERT log_monitor_slow_query (ip, project, logstore, task_name_display, task_query_sql, task_state, time_units)
VALUES ('10.16.2.180', 'happigo-application', 'happigo_mysql_slow_log', 'ip:10.16.2.180',
        '* and source: 10.16.2.180 and Query_time|select count(1) cnt limit 1000', 1, '5,10,60');
INSERT log_monitor_slow_query (ip, project, logstore, task_name_display, task_query_sql, task_state, time_units)
VALUES ('10.16.2.181', 'happigo-application', 'happigo_mysql_slow_log', 'ip:10.16.2.181',
        '* and source: 10.16.2.181 and Query_time|select count(1) cnt limit 1000', 1, '5,10,60');
INSERT log_monitor_slow_query (ip, project, logstore, task_name_display, task_query_sql, task_state, time_units)
VALUES ('10.16.2.182', 'happigo-application', 'happigo_mysql_slow_log', 'ip:10.16.2.182',
        '* and source: 10.16.2.182 and Query_time|select count(1) cnt limit 1000', 1, '5,10,60');
INSERT log_monitor_slow_query (ip, project, logstore, task_name_display, task_query_sql, task_state, time_units)
VALUES ('10.16.2.183', 'happigo-application', 'happigo_mysql_slow_log', 'ip:10.16.2.183',
        '* and source: 10.16.2.183 and Query_time|select count(1) cnt limit 1000', 1, '5,10,60');
INSERT log_monitor_slow_query (ip, project, logstore, task_name_display, task_query_sql, task_state, time_units)
VALUES ('10.16.2.188', 'happigo-application', 'happigo_mysql_slow_log', 'ip:10.16.2.188',
        '* and source: 10.16.2.188 and Query_time|select count(1) cnt limit 1000', 1, '5,10,60');


SELECT *
FROM log_monitor_slow_query;
SELECT *
FROM log_monitor_task;
SELECT *
FROM log_monitor_task_detail;
SELECT *
FROM log_monitor_slow_query_detail;

/*
2018-01-19
Wxcms.AdminQrscene.Api
Wxcms.AdminSendMessage.Api
Wxcms.AdminSendHb.Api
*/
INSERT INTO log_monitor_projectname (logstore, col_name, col_value)
VALUES ('happigo-application', 'projectname', 'Wxcms.AdminQrscene.Api');
INSERT INTO log_monitor_projectname (logstore, col_name, col_value)
VALUES ('happigo-application', 'projectname', 'Wxcms.AdminSendMessage.Api');
INSERT INTO log_monitor_projectname (logstore, col_name, col_value)
VALUES ('happigo-application', 'projectname', 'Wxcms.Wxcms.AdminSendHb.Api');

INSERT log_monitor_task (task_name, project, logstore, task_state, time_units)
  SELECT
    a.col_value task_name,
    a.logstore  project,
    a.logstore,
    -1          task_state,
    '5,10,60'   time_units
  FROM log_monitor_projectname a
  WHERE a.id BETWEEN 239 AND 241;

UPDATE log_monitor_task a
SET a.task_state = 1, a.task_query_sql = concat('projectname=', a.task_name,
                                                '|select case when count(1) is null then 0 else count(1) end count_all,case when sum(case when loglevel=''info'' then 1 else 0 end) is null then 0 else sum(case when loglevel=''info'' then 1 else 0 end) end count_info,case when sum(case when loglevel=''error'' then 1 else 0 end) is null then 0 else sum(case when loglevel=''error'' then 1 else 0 end) end count_error,case when sum(case when loglevel=''warning'' then 1 else 0 end) is null then 0 else sum(case when loglevel=''warning'' then 1 else 0 end) end count_warning,case when sum(case when loglevel=''trace'' then 1 else 0 end) is null then 0 else sum(case when loglevel=''trace'' then 1 else 0 end) end count_trace,case when round(avg(totalexpend)) is null then 0 else round(avg(totalexpend)) end avg_expend_all,case when round(avg(case when loglevel=''info'' then totalexpend end)) is null then 0 else round(avg(case when loglevel=''info'' then totalexpend  end)) end avg_expend_info,case when round(avg(case when loglevel=''error'' then totalexpend end)) is null then 0 else round(avg(case when loglevel=''error'' then totalexpend end)) end avg_expend_error,case when round(avg(case when loglevel=''warning'' then totalexpend end)) is null then 0 else round(avg(case when loglevel=''warning'' then totalexpend end)) end avg_expend_warning,case when round(avg(case when loglevel=''trace'' then totalexpend end)) is null then 0 else round(avg(case when loglevel=''trace'' then totalexpend end)) end avg_expend_trace')
WHERE a.task_id BETWEEN 1152 AND 1154 AND a.task_query_sql IS NULL;

/*
2018-01-29
EC.LogMonitor.Task
EC.MqMonitor.Task
*/
INSERT INTO log_monitor_projectname (logstore, col_name, col_value)
VALUES ('happigo-application', 'projectname', 'EC.LogMonitor.Task');
INSERT INTO log_monitor_projectname (logstore, col_name, col_value)
VALUES ('happigo-application', 'projectname', 'EC.MqMonitor.Task');

SELECT *
FROM log_monitor_projectname;

INSERT log_monitor_task (task_name, project, logstore, task_state, time_units)
  SELECT
    a.col_value task_name,
    a.logstore  project,
    a.logstore,
    -1          task_state,
    '5,10,60'   time_units
  FROM log_monitor_projectname a
  WHERE a.id BETWEEN 242 AND 243;

SELECT *
FROM log_monitor_task;

UPDATE log_monitor_task a
SET a.task_state = 1, a.task_query_sql = concat('projectname=', a.task_name,
                                                '|select case when count(1) is null then 0 else count(1) end count_all,case when sum(case when loglevel=''info'' then 1 else 0 end) is null then 0 else sum(case when loglevel=''info'' then 1 else 0 end) end count_info,case when sum(case when loglevel=''error'' then 1 else 0 end) is null then 0 else sum(case when loglevel=''error'' then 1 else 0 end) end count_error,case when sum(case when loglevel=''warning'' then 1 else 0 end) is null then 0 else sum(case when loglevel=''warning'' then 1 else 0 end) end count_warning,case when sum(case when loglevel=''trace'' then 1 else 0 end) is null then 0 else sum(case when loglevel=''trace'' then 1 else 0 end) end count_trace,case when round(avg(totalexpend)) is null then 0 else round(avg(totalexpend)) end avg_expend_all,case when round(avg(case when loglevel=''info'' then totalexpend end)) is null then 0 else round(avg(case when loglevel=''info'' then totalexpend  end)) end avg_expend_info,case when round(avg(case when loglevel=''error'' then totalexpend end)) is null then 0 else round(avg(case when loglevel=''error'' then totalexpend end)) end avg_expend_error,case when round(avg(case when loglevel=''warning'' then totalexpend end)) is null then 0 else round(avg(case when loglevel=''warning'' then totalexpend end)) end avg_expend_warning,case when round(avg(case when loglevel=''trace'' then totalexpend end)) is null then 0 else round(avg(case when loglevel=''trace'' then totalexpend end)) end avg_expend_trace')
WHERE a.task_id BETWEEN 1155 AND 1156 AND a.task_query_sql IS NULL;

CALL log_monitor_add('happigo-application', 'EC.LogMonitor.Task');

/*
2018-02-11
快乐文档监控
1.0/ha.activity.user_POST
1.0/ha.activity.user.answer_POST
1.0/ha.activity.shedule_GET
1.0/ha.server.time_GET
1.0/ha.user_GET
1.0/ha.activity.onlinecount_GET
1.0/ha.activity.score_GET
1.0/ha.share.award_POST
1.0/ha.activity.user.score_GET
1.0/ha.user.score_GET
1.0/ha.score_GET

HappyAsk.Task
HappyAsk.award.Task

*/
INSERT INTO log_monitor_projectname (logstore, col_name, col_value)
VALUES ('happigo-restapi', 'resource', 'ha.activity.user_POST');
INSERT INTO log_monitor_projectname (logstore, col_name, col_value)
VALUES ('happigo-restapi', 'resource', 'ha.activity.user.answer_POST');
INSERT INTO log_monitor_projectname (logstore, col_name, col_value)
VALUES ('happigo-restapi', 'resource', 'ha.activity.shedule_GET');
INSERT INTO log_monitor_projectname (logstore, col_name, col_value)
VALUES ('happigo-restapi', 'resource', 'ha.server.time_GET');
INSERT INTO log_monitor_projectname (logstore, col_name, col_value)
VALUES ('happigo-restapi', 'resource', 'ha.user_GET');
INSERT INTO log_monitor_projectname (logstore, col_name, col_value)
VALUES ('happigo-restapi', 'resource', 'ha.activity.onlinecount_GET');
INSERT INTO log_monitor_projectname (logstore, col_name, col_value)
VALUES ('happigo-restapi', 'resource', 'ha.activity.score_GET');
INSERT INTO log_monitor_projectname (logstore, col_name, col_value)
VALUES ('happigo-restapi', 'resource', 'ha.share.award_POST');
INSERT INTO log_monitor_projectname (logstore, col_name, col_value)
VALUES ('happigo-restapi', 'resource', 'ha.activity.user.score_GET');
INSERT INTO log_monitor_projectname (logstore, col_name, col_value)
VALUES ('happigo-restapi', 'resource', 'ha.user.score_GET');
INSERT INTO log_monitor_projectname (logstore, col_name, col_value)
VALUES ('happigo-restapi', 'resource', 'ha.score_GET');

INSERT log_monitor_task (task_name, project, logstore, task_state, time_units)
  SELECT
    a.col_value           task_name,
    'happigo-application' project,
    a.logstore,
    -1                    task_state,
    '5,10,60'             time_units
  FROM log_monitor_projectname a
  WHERE a.id BETWEEN 244 AND 254;

UPDATE log_monitor_task A
SET
  A.task_query_sql = concat(substring_index(A.task_name, '_', 1), ' and method=', substring_index(A.task_name, '_', -1),
                            '|select case when count(1) is null then 0 else count(1) end count_all,case when sum(case when loglevel=''info'' then 1 else 0 end) is null then 0 else sum(case when loglevel=''info'' then 1 else 0 end) end count_info,case when sum(case when loglevel=''error'' then 1 else 0 end) is null then 0 else sum(case when loglevel=''error'' then 1 else 0 end) end count_error,case when sum(case when loglevel=''warning'' then 1 else 0 end) is null then 0 else sum(case when loglevel=''warning'' then 1 else 0 end) end count_warning,case when sum(case when loglevel=''trace'' then 1 else 0 end) is null then 0 else sum(case when loglevel=''trace'' then 1 else 0 end) end count_trace,case when round(avg(totalexpend)) is null then 0 else round(avg(totalexpend)) end avg_expend_all,case when round(avg(case when loglevel=''info'' then totalexpend end)) is null then 0 else round(avg(case when loglevel=''info'' then totalexpend  end)) end avg_expend_info,case when round(avg(case when loglevel=''error'' then totalexpend end)) is null then 0 else round(avg(case when loglevel=''error'' then totalexpend end)) end avg_expend_error,case when round(avg(case when loglevel=''warning'' then totalexpend end)) is null then 0 else round(avg(case when loglevel=''warning'' then totalexpend end)) end avg_expend_warning,case when round(avg(case when loglevel=''trace'' then totalexpend end)) is null then 0 else round(avg(case when loglevel=''trace'' then totalexpend end)) end avg_expend_trace')
WHERE A.logstore = 'happigo-restapi' AND A.task_query_sql IS NULL AND A.task_id BETWEEN 1158 AND 1168;

UPDATE log_monitor_task A
SET A.task_state = 1
WHERE A.task_id BETWEEN 1158 AND 1168;

CALL log_monitor_add('happigo-application', 'HappyAsk.Task');
CALL log_monitor_add('happigo-application', 'HappyAsk.award.Task');


INSERT INTO log_monitor_task_group (groupName, task_id) VALUES ('快乐问答', 1158);
INSERT INTO log_monitor_task_group (groupName, task_id) VALUES ('快乐问答', 1159);
INSERT INTO log_monitor_task_group (groupName, task_id) VALUES ('快乐问答', 1160);
INSERT INTO log_monitor_task_group (groupName, task_id) VALUES ('快乐问答', 1161);
INSERT INTO log_monitor_task_group (groupName, task_id) VALUES ('快乐问答', 1162);
INSERT INTO log_monitor_task_group (groupName, task_id) VALUES ('快乐问答', 1163);
INSERT INTO log_monitor_task_group (groupName, task_id) VALUES ('快乐问答', 1164);
INSERT INTO log_monitor_task_group (groupName, task_id) VALUES ('快乐问答', 1165);
INSERT INTO log_monitor_task_group (groupName, task_id) VALUES ('快乐问答', 1166);
INSERT INTO log_monitor_task_group (groupName, task_id) VALUES ('快乐问答', 1167);
INSERT INTO log_monitor_task_group (groupName, task_id) VALUES ('快乐问答', 1168);
INSERT INTO log_monitor_task_group (groupName, task_id) VALUES ('快乐问答', 1169);
INSERT INTO log_monitor_task_group (groupName, task_id) VALUES ('快乐问答', 1170);
INSERT INTO log_monitor_task_group (groupName, task_id) VALUES ('快乐问答', 1171);
INSERT INTO log_monitor_task_group (groupName, task_id) VALUES ('快乐问答', 1172);
INSERT INTO log_monitor_task_group (groupName, task_id) VALUES ('快乐问答', 1173);
INSERT INTO log_monitor_task_group (groupName, task_id) VALUES ('快乐问答', 1174);

/*
2018-03-09
1.0/ha.activity.user.role_POST
1.0/ha.user.revivecard_POST
 */
CALL log_monitor_add('happigo-restapi', '1.0/ha.activity.user.role_POST');
CALL log_monitor_add('happigo-restapi', '1.0/ha.user.revivecard_POST');

SELECT *
FROM log_monitor_task;

INSERT log_monitor_task_group (groupName, task_id, group_id) VALUES ('快乐问答', 1175, 1);
INSERT log_monitor_task_group (groupName, task_id, group_id) VALUES ('快乐问答', 1176, 1);

SELECT *
FROM log_monitor_task_group;

/*
2018-03-14
Game.Activity.choumiandan
*/
CALL log_monitor_add('happigo-application', 'Game.Activity.choumiandan');

/*
2018-03-23
Wxcms.CommunityActivism.Admin
*/
CALL log_monitor_add('happigo-application', 'Wxcms.CommunityActivism.Admin');

/*
2018-03-30
EC.Order.EvaluateGoods.Task
*/
CALL log_monitor_add('happigo-application', 'EC.Order.EvaluateGoods.Task');

/*
2018-04-03
第三方公司回调处理消费者：Ec.Third.Party.Company.Callback.Task
消费者触发网易严选库存同步：Ec.Stock.Sync.Yanxuan
*/
CALL log_monitor_add('happigo-application', 'Ec.Third.Party.Company.Callback.Task');
CALL log_monitor_add('happigo-application', 'Ec.Stock.Sync.Yanxuan.Api');

/*
2018-04-10
EC.WeixinSaveDataManagement.Task
EC.WeixinPushManagement.Task
*/
CALL log_monitor_add('happigo-application', 'EC.WeixinSaveDataManagement.Task');
CALL log_monitor_add('happigo-application', 'EC.WeixinPushManagement.Task');

/*
2018-04-13
Ec.RegisterNotice.Task
*/
CALL log_monitor_add('happigo-application', 'Ec.RegisterNotice.Task');

/*
2018-05-07
EC.Sign.Acesses.API
*/
CALL log_monitor_add('happigo-application', 'EC.Sign.Acesses.API');

/*
2018-05-14
CommenTanalysis.Task
*/
CALL log_monitor_add('happigo-application', 'CommenTanalysis.Task');

/*
2018-05-14
CommenTanalysis.Task
*/
CALL log_monitor_add('happigo-application', 'Ec.Goods.Image.Upload');

/*
2018-06-07
Ec.Voucher.mangolive.sycn.Task
*/
CALL log_monitor_add('happigo-application', 'Ec.Voucher.mangolive.sycn.Task');


/*
2018-06-14
//服务器时间戳
bargain.api.v1.ServerTime.index
//大眼睛
bargain.api.v1.ActiveBanner.index
//活动列表
bargain.api.v1.ActiveList.index
//砍价成功滚动消息和已成功砍价总人数
bargain.api.v1.ActiveNotice.index
//商品详情
bargain.api.v1.ActiveGoodsInfo.read
//活动详情
bargain.api.v1.ActiveBargainInfo.read
//活动（商品）推荐
bargain.api.v1.ActiveRecommend.read
//创建任务
bargain.api.v1.TaskAdd.save
//我的任务列表
bargain.api.v1.TaskList.index
//任务详情
bargain.api.v1.TaskInfo.read
//参加任务（帮别人砍）
bargain.api.v1.TaskHelp.save
//参与任务用户列表【好友砍价榜单】
bargain.api.v1.TaskFriend.index
//付款
bargain.api.v1.TaskPayment.save
*/
CALL log_monitor_add('happigo-application', 'bargain.api.v1.ServerTime.index');
CALL log_monitor_add('happigo-application', 'bargain.api.v1.ActiveBanner.index');
CALL log_monitor_add('happigo-application', 'bargain.api.v1.ActiveList.index');
CALL log_monitor_add('happigo-application', 'bargain.api.v1.ActiveNotice.index');
CALL log_monitor_add('happigo-application', 'bargain.api.v1.ActiveGoodsInfo.read');
CALL log_monitor_add('happigo-application', 'bargain.api.v1.ActiveBargainInfo.read');
CALL log_monitor_add('happigo-application', 'bargain.api.v1.ActiveRecommend.read');
CALL log_monitor_add('happigo-application', 'bargain.api.v1.TaskAdd.save');
CALL log_monitor_add('happigo-application', 'bargain.api.v1.TaskList.index');
CALL log_monitor_add('happigo-application', 'bargain.api.v1.TaskInfo.read');
CALL log_monitor_add('happigo-application', 'bargain.api.v1.TaskHelp.save');
CALL log_monitor_add('happigo-application', 'bargain.api.v1.TaskFriend.index');
CALL log_monitor_add('happigo-application', 'bargain.api.v1.TaskPayment.save');

/*
2018-06-27
1、获取购物车                           1.0/ec.cart  GET
2、添加购物车商品                    1.0/ec.cart  POST
3、删除购物车项                       1.0/ec.cart   DELETE
4、编辑购物车项                       1.0/ec.cart  PUT
5、选择、撤销选择购物车项       1.0/ec.cart.select PUT
6、选择购物车促销信息              1.0/ec.cart.promotion PUT
7、查询购物车促销主品             1.0/ec.cart.promotion.goods GET
8、查询购物车促销赠品             1.0/ec.cart.promotion.gift GET
9、添加购物车促销赠品             1.0/ec.cart.promotion.gift POST
10、订单确认                           2.0/ec.order.confirm  POST
11、订单提交                           2.0/ec.order  POST
*/
select *
from log_monitor_task;

CALL log_monitor_add('happigo-restapi', '1.0/ec.cart_GET');
CALL log_monitor_add('happigo-restapi', '1.0/ec.cart_POST');
CALL log_monitor_add('happigo-restapi', '1.0/ec.cart_DELETE');
CALL log_monitor_add('happigo-restapi', '1.0/ec.cart_PUT');
CALL log_monitor_add('happigo-restapi', '1.0/ec.cart.select_PUT');
CALL log_monitor_add('happigo-restapi', '1.0/ec.cart.promotion_PUT');
CALL log_monitor_add('happigo-restapi', '1.0/ec.cart.promotion.goods_GET');
CALL log_monitor_add('happigo-restapi', '1.0/ec.cart.promotion.gift_GET');
CALL log_monitor_add('happigo-restapi', '1.0/ec.cart.promotion.gift_POST');
CALL log_monitor_add('happigo-restapi', '2.0/ec.order.confirm_POST');
CALL log_monitor_add('happigo-restapi', '2.0/ec.order_POST');

SELECT *
FROM log_monitor_task_detail A
WHERE A.task_id BETWEEN 1202 AND 1212;

/*
2018-06-29
EC.Consumer.RegisterIntegral.Task
*/
CALL log_monitor_add('happigo-application', 'EC.Consumer.RegisterIntegral.Task');

/*
2018-07-17
Ec.Order.Update.Jd.Task
Ec.Order.Return.Wy.Task
*/
CALL log_monitor_add('happigo-application', 'Ec.Order.Update.Jd.Task');
CALL log_monitor_add('happigo-application', 'Ec.Order.Return.Wy.Task');

/*
2018-07-23
Ec.evaluate.sentiment.Task
*/
CALL log_monitor_add('happigo-application', 'Ec.evaluate.sentiment.Task');

/*
2018-08-10
//获取区块列表
mgtv.api.v1.blocks.index
//商品列表
mgtv.api.v1.goods.index
//商品详情
mgtv.api.v1.goodsinfo.read
//相关商品推荐
mgtv.api.v1.relategoods.read
//广告信息
mgtv.api.v1.ads.index
*/
CALL log_monitor_add('happigo-application', 'mgtv.api.v1.blocks.index');
CALL log_monitor_add('happigo-application', 'mgtv.api.v1.goods.index');
CALL log_monitor_add('happigo-application', 'mgtv.api.v1.goodsinfo.read');
CALL log_monitor_add('happigo-application', 'mgtv.api.v1.relategoods.read');
CALL log_monitor_add('happigo-application', 'mgtv.api.v1.ads.index');

/*
2018-09-06
Ec.Presale.Fakenum.task
*/
CALL log_monitor_add('happigo-application', 'Ec.Presale.Fakenum.task');

/*
Ec.Presale.ShareDiscount.task
*/
CALL log_monitor_add('happigo-application', 'Ec.Presale.ShareDiscount.task');