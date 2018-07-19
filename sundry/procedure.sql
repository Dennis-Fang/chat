/*
����˵����ֶμ�����admin�˺ŵ�
*/
drop procedure if exists importMenu;
CREATE PROCEDURE importMenu()
begin
	insert into zt_menu select * from crms.zt_menu;
	insert into zt_field select * from crms.zt_field;
	insert into zt_member select * from crms.zt_member where jobnumber='admin';
	insert into zt_ucenter_member select * from crms.zt_ucenter_member where jobnumber='admin';
	/*
		ALTER TABLE zt_customerinfo MODIFY COLUMN SourceFlag tinyint(3)  unsigned NOT NULL COMMENT '1��������/2��ҵ��/3�ཻ��';
		ALTER TABLE zt_customerinfo MODIFY COLUMN FirmPlatId tinyint(3)  unsigned NOT NULL COMMENT '������ƽ̨ID��1�㽻��/2�½���/3�ཻ��';
		ALTER TABLE zt_customerinfo ALTER SourceFlag set DEFAULT 2;
		ALTER TABLE zt_customerinfo ALTER FirmPlatId set DEFAULT 2;
	*/
	/*�޸��ֶΣ�defaultֵ���ݲ�ͬ��˾�費ֵͬ*/
	ALTER TABLE zt_customerinfo MODIFY COLUMN SourceFlag tinyint(3)  unsigned NOT NULL DEFAULT '2' COMMENT '1��������/2��ҵ��/3�ཻ��';
	ALTER TABLE zt_customerinfo MODIFY COLUMN FirmPlatId tinyint(3)  unsigned NOT NULL DEFAULT '2' COMMENT '������ƽ̨ID��1�㽻��/2�½���/3�ཻ��';
	
	drop table if exists `mapping`;
	/*�����¾ɲ��ŵ���Ϣmapping*/
	CREATE TABLE if not EXISTS  `mapping` (
	  `id` smallint(5) unsigned NOT NULL AUTO_INCREMENT,
	  `olddeptid` tinyint(3) unsigned DEFAULT NULL COMMENT '�ɲ���ID',
	  `oldtid` smallint(5) unsigned DEFAULT NULL COMMENT '��С��ID',
	  `oldjobnumber` varchar(10) DEFAULT NULL COMMENT '�ɹ���',
	  `newdeptid` tinyint(3) unsigned DEFAULT NULL COMMENT '�²���ID',
	  `newtid` smallint(5) unsigned DEFAULT NULL COMMENT '��С��ID',
	  `newjobnumber` varchar(10) DEFAULT NULL COMMENT '�¹���',
	  PRIMARY KEY (`id`)
	) ENGINE=MyISAM AUTO_INCREMENT=5 DEFAULT CHARSET=utf8;
	
	/*�����������ʱ�ֶΣ����ڳ�ȡ��Դ��ǣ����ж��ֶ��Ƿ����*/
	if not EXISTS (SELECT * FROM information_schema.columns WHERE table_schema='crms' AND table_name = 'zt_newsource' AND column_name = 'TempSourceFlag') THEN
		alter table crms.zt_newsource add `TempSourceFlag` tinyint(3) unsigned NOT NULL DEFAULT '1' COMMENT '1��ҵ��/2�½���/3�ཻ��';
		alter table crms.zt_grabagesource add `TempSourceFlag` tinyint(3) unsigned NOT NULL DEFAULT '1' COMMENT '1��ҵ��/2�½���/3�ཻ��';
		alter table crms.zt_shareaccount add `TempSourceFlag` tinyint(3) unsigned NOT NULL DEFAULT '1' COMMENT '1��ҵ��/2�½���/3�ཻ��'; 
	end if;
	
end;

call importMenu();

/*
	drop procedure importMenu(); ɾ��
	select name from mysql.proc where db='crm_fzhtest'; �鿴���ݿ�洢����
	show procedure status where db='crm_fzhtest'; �鿴���ݿ�洢����
	select routine_name from information_schema.routines where routine_schema='crm_fzhtest';
	SHOW CREATE PROCEDURE crm_fzhtest.importMenu; �鿴�洢������ϸ
*/

/*
��ȡ��Դ��������Դ����С����
*/
drop procedure if exists importSource;
CREATE PROCEDURE importSource()
begin
	/*��������*/
	declare odeptid int(3);
	declare undeptid int(3);
	declare otid int(5);
	declare ndeptid int(3);
	declare ntid int(5);
	declare done int default 0;
	/*�����α�*/
	declare mapcursor cursor for select olddeptid,oldtid,newdeptid,newtid from mapping;  /*����й��ű䶯����������¾ɹ�����Ϣ��������²���Ҳ�����*/
	declare deptcursor cursor for select distinct(olddeptid) from mapping;
	/*����ѭ��ֹͣ����*/
	declare continue handler FOR SQLSTATE '02000' SET done = 1;
	/*��ȡ��������*/
	open deptcursor;
	repeat
		fetch deptcursor into undeptid;
		if done=0 then
			insert into zt_customerinfo select * from crms.zt_customerinfo where DeptID=undeptid;
		end if;
	until done end repeat;
	close deptcursor;
	/*����ѭ��ֵֹͣ*/
	set done = 0;
	/*���¿ͻ�����*/
	open mapcursor;
	repeat
		fetch mapcursor into odeptid,otid,ndeptid,ntid;
		if done=0 then
			update zt_customerinfo set DeptID=ndeptid,TID=ntid where DeptID=odeptid and TID=otid;
		end if;
	until done end repeat;
	close mapcursor;
	
	insert into zt_customerinfoexten select * from crms.zt_customerinfoexten me where me.CID in (select CID from zt_customerinfo);
end;

call importSource();

/*
drop procedure importSource()
*/

/*
�������Դƽ�֣������ֶ����ݿ�ִ��
*/
drop procedure if exists importPool;
CREATE PROCEDURE importPool()
begin
	
	/*��������*/
	declare tmnum int(3);
	declare nsourcenum int;
	declare gsourcenum int;
	declare ssourcenum int;
	/*��ֵ������С������Ҫ����ʵ�ʵ���*/
	set tmnum=8;
	select count(1) into nsourcenum from crms.zt_newsource;
	select count(1) into gsourcenum from crms.zt_grabagesource;
	select count(1) into ssourcenum from crms.zt_shareaccount;
    set @nsourcenum=floor(nsourcenum / tmnum);
    set @gsourcenum=floor(gsourcenum / tmnum);
    set @ssourcenum=floor(ssourcenum / tmnum);
	/*
	--��ȡ�������Դ
	insert into zt_newsource select * from crms.zt_newsource order by rand() limit floor(nsourcenum / tmnum); --ƽ��������ǣ��������ϵͳ����Ҫ��ȡ�Ҳ����ظ������ֵ������Ѽ��������
	insert into zt_grabagesource select * from crms.zt_grabagesource order by rand() limit floor(gsourcenum / tmnum);
	insert into zt_shareaccount select * from crms.zt_shareaccount order by rand() limit floor(ssourcenum / tmnum);	
	*/
	CREATE INDEX index_tmpflag ON crms.zt_newsource (TempSourceFlag) USING BTREE;
	
	CREATE INDEX index_tmpflag ON crms.zt_grabagesource (TempSourceFlag) USING BTREE;
	
	CREATE INDEX index_tmpflag ON crms.zt_shareaccount (TempSourceFlag) USING BTREE;
	
	prepare psql from 'update crms.zt_newsource set TempSourceFlag=2 where TempSourceFlag=1 order by rand() limit ?';
	execute psql using @nsourcenum;
	prepare psql from 'update crms.zt_newsource set TempSourceFlag=3 where TempSourceFlag=1 order by rand() limit ?';
	execute psql using @nsourcenum;
	
	prepare psql from 'update crms.zt_grabagesource set TempSourceFlag=2 where TempSourceFlag=1 order by rand() limit ?';
	execute psql using @gsourcenum;
	prepare psql from 'update crms.zt_grabagesource set TempSourceFlag=3 where TempSourceFlag=1 order by rand() limit ?';
	execute psql using @gsourcenum;
	
	prepare psql from 'update crms.zt_shareaccount set TempSourceFlag=2 where TempSourceFlag=1 order by rand() limit ?';
	execute psql using @ssourcenum;
	prepare psql from 'update crms.zt_shareaccount set TempSourceFlag=3 where TempSourceFlag=1 order by rand() limit ?';
	execute psql using @ssourcenum;
	/*ɾ��Ԥ����*/
	DEALLOCATE PREPARE psql;
	
	alter table zt_newsource add `TempSourceFlag` tinyint(3) unsigned NOT NULL DEFAULT '1' COMMENT '1��ҵ��/2�½���/3�ཻ��';
	alter table zt_grabagesource add `TempSourceFlag` tinyint(3) unsigned NOT NULL DEFAULT '1' COMMENT '1��ҵ��/2�½���/3�ཻ��';
	alter table zt_shareaccount add `TempSourceFlag` tinyint(3) unsigned NOT NULL DEFAULT '1' COMMENT '1��ҵ��/2�½���/3�ཻ��'; 
	
	/*ѭ��������
	declare nscount int;
	declare t_error int default 0;
	declare continue HANDLER for SQLEXCEPTION set t_error=1;
	select count(1) into nscount from crms.zt_newsource where TempSourceFlag=2;
	set @fornum=10000;
	
	while @fornum <= nscount do
		start transaction;
		prepare psql from "insert into zt_newsource select * from crms.zt_newsource where TempSourceFlag=2 limit ?";
		execute psql using @fornum;
		update crms.zt_newsource cn set cn.TempSourceFlag=20 where cn.ID in (select ID from zt_newsource where TempSourceFlag=2);
		update zt_newsource set TempSourceFlag=20 where TempSourceFlag=2;
		if t_error=1 then
			rollback;
		else 
			commit;
			set @fornum = @fornum + 10000;
		end if;
	end while;
	*/
	
	insert into zt_newsource select * from crms.zt_newsource where TempSourceFlag in (2, 3);
	insert into zt_grabagesource select * from crms.zt_grabagesource where TempSourceFlag in (2, 3);
	insert into zt_shareaccount select * from crms.zt_shareaccount where TempSourceFlag in (2, 3);
	/*������Դ*/
	update zt_newsource set CallJob='' where CallJob <> '';
	update zt_grabagesource set CallJob='' where CallJob <> '';
	update zt_shareaccount set CallJob='' where CallJob <> '';
	
	alter table zt_newsource drop column TempSourceFlag;
	alter table zt_grabagesource drop column TempSourceFlag;
	alter table  zt_shareaccount drop column TempSourceFlag;
end;


/*
��ȡrecord��¼,record_exten��¼��php�ű�
*/
drop procedure if exists importRecord;
CREATE PROCEDURE importRecord()
begin
	declare extnum int(5);
	declare done int default 0;
	declare extcursor cursor for select distinct(ext) from zt_member where ext <> '';
	declare continue handler FOR SQLSTATE '02000' SET done = 1;
	open extcursor;
	repeat
		fetch extcursor into extnum;
		if done=0 then
			insert into `record` select * from crms.`record` where calleeID=extnum or callerID=extnum;
		end if;
	until done 
	end repeat;
	close extcursor;
end;

call importRecord();

/*
ɾ����ҵ�ɳ�ȡ���ĺ�����Ϣ
*/
/*
drop procedure if exists delphone;
CREATE PROCEDURE delphone()
begin
	delete from crms.zt_customerinfo mc where mc.CID in (select CID from zt_customerinfo);
	delete from crms.zt_newsource where TempSourceFlag in (2,3);
	delete from crms.zt_grabagesource where TempSourceFlag in (2,3);
	delete from crms.zt_shareaccount where TempSourceFlag in (2,3);
	drop index index_tmpflag on crms.zt_newsource;
	drop index index_tmpflag on crms.zt_grabagesource;
	drop index index_tmpflag on crms.zt_shareaccount;
	alter table crms.zt_newsource drop column TempSourceFlag;
	alter table crms.zt_grabagesource drop column TempSourceFlag;
	alter table crms.zt_shareaccount drop column TempSourceFlag;
	delete from crms.zt_allphone ma where ma.UsedPhone in (select UsedPhone from (select UsedPhone from zt_customerinfo union all select UsedPhone from zt_newsource union all select UsedPhone from zt_grabagesource union all select UsedPhone from zt_shareaccount) tmp)
	delete from crms.zt_allphone ma where ma.UsedPhone in (select PhoneA from (select PhoneA from zt_customerinfo union all select PhoneA from zt_newsource union all select PhoneA from zt_grabagesource union all select PhoneA from zt_shareaccount) tmp)
	delete from crms.zt_allphone ma where ma.UsedPhone in (select PhoneB from (select PhoneB from zt_customerinfo union all select PhoneB from zt_newsource union all select PhoneB from zt_grabagesource union all select PhoneB from zt_shareaccount) tmp)
	drop table mapping
end;
*/






