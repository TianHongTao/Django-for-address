create trigger REMARK_UPDTATE
  after INSERT
  on RELATION
  for each row
  BEGIN
  DECLARE c varchar(255);
  IF NEW.REMARK is NULL
  THEN
    SET c = (SELECT USERNAME FROM USERINFO WHERE USERINFO.ID = NEW.FRIENDID);
    SET NEW.REMARK = c;
  end if;
end;

