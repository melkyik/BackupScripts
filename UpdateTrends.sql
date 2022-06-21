CREATE PROCEDURE UPDATE_Trends()
-- процедура обновляет тренды и сдвигает их на 5 часов назад, выполнять в шедулере sql. раз в минуту например 
BEGIN
  DECLARE buft TIMESTAMP(3); 
	bid, G_ID, M_ID INT(10) ;

  DECLARE trsec 	CURSOR FOR SELECT `id`,`Timestamp` FROM trends_data 	WHERE `Timestamp` >= DATE_SUB(CURRENT_TIMESTAMP(3), INTERVAL 5 MINUTE) ;
  DECLARE trmin 	CURSOR FOR SELECT `id`,`Timestamp` FROM trends_minute WHERE `Timestamp` >= DATE_SUB(CURRENT_TIMESTAMP(3), INTERVAL 5 MINUTE) ;
  DECLARE trhour 	CURSOR FOR SELECT `id`,`Timestamp` FROM trends_hour 	WHERE `Timestamp` >= DATE_SUB(CURRENT_TIMESTAMP(3), INTERVAL 5 MINUTE) ;
  DECLARE trday 	CURSOR FOR SELECT `id`,`Timestamp` FROM trends_day 	WHERE `Timestamp` >= DATE_SUB(CURRENT_TIMESTAMP(3), INTERVAL 5 MINUTE) ;
  
  
  DECLARE mdata CURSOR FOR SELECT  `Timestamp`, GroupID, MessageID, FROM messages_data WHERE `Timestamp` >= DATE_SUB(CURRENT_TIMESTAMP(3), INTERVAL 5 MINUTE) ;
  
  
  DECLARE CONTINUE HANDLER FOR SQLSTATE '02000' SET done = 1;
-- обновляем тренд секундный
OPEN trsec;
REPEAT
    FETCH trsec INTO bid, buft;
	 UPDATE trends_data SET `Timestamp` = 	DATE_SUB(buft, INTERVAL 5 HOUR) WHERE (id=bid) AND (`Timestamp`=buft);
UNTIL done END REPEAT;
CLOSE trsec;
-- обновляем тренд секундный
OPEN trmin;
REPEAT
    FETCH trmin INTO bid, buft;
	 UPDATE trends_minute SET `Timestamp` = 	DATE_SUB(buft, INTERVAL 5 HOUR) WHERE (id=bid) AND (`Timestamp`=buft);
UNTIL done END REPEAT;
CLOSE trmin;

-- обновляем тренд часовой
OPEN trhour;
REPEAT
    FETCH trhour INTO bid, buft;
	 UPDATE trends_hour SET `timestamp` = 	DATE_SUB(buft, INTERVAL 5 HOUR) WHERE (id=bid) AND (`timestamp`=buft);
UNTIL done END REPEAT;

CLOSE trhour;
-- обновляем тренд дневной
OPEN trday;
REPEAT
    FETCH trday INTO bid, buft;
	 UPDATE trends_day SET `timestamp` = 	DATE_SUB(buft, INTERVAL 5 HOUR) WHERE (id=bid) AND (`timestamp`=buft);
UNTIL done END REPEAT;
CLOSE trday;

-- обновляем message 
OPEN mdata;
REPEAT
    FETCH mdata INTO buft,bid, G_ID, M_ID;
	UPDATE trends_day SET `timestamp` = 	DATE_SUB(buft, INTERVAL 5 HOUR) WHERE 
                                                    id=bid AND 
                                                    `timestamp`=buft and
                                                    GroupID=G_ID and 
                                                    MessageID=M_ID;
UNTIL done END REPEAT;
CLOSE trday;

END

