create trigger REMARK_UPDTATE
  after INSERT
  on RELATION
  for each row
  BEGIN
  DECLARE c varchar(255);
  IF RELATION.REMARK = NULL
  THEN
    set c = (SELECT USERNAME FROM USERINFO,RELATION,ID_WECHATID
             WHERE new.IDB=ID_WECHATID.ID AND ID_WECHATID.WECHARID = USERINFO.WECHARID);
    UPDATE RELATION SET REMARK = c WHERE IDB = NEW.IDB AND IDA = NEW.IDA;
  end if;
end;

