DROP TABLE LEKAREN CASCADE CONSTRAINTS;
DROP TABLE JE_V_ZMLUVE CASCADE CONSTRAINTS;
DROP TABLE VYKAZ CASCADE CONSTRAINTS;
DROP TABLE NAKUP CASCADE CONSTRAINTS;
DROP TABLE AKTUALIZUJE CASCADE CONSTRAINTS;
DROP TABLE SUCAST_NAKUPU CASCADE CONSTRAINTS;
DROP TABLE LIEK CASCADE CONSTRAINTS;
DROP TABLE NA_PREDPIS CASCADE CONSTRAINTS;
DROP TABLE BEZ_PREDPISU CASCADE CONSTRAINTS;
DROP TABLE HRADI_DOPLATOK CASCADE CONSTRAINTS;
DROP TABLE POCET_LIEKOV_NA_SKLADE CASCADE CONSTRAINTS;
DROP TABLE ZDRAVOTNA_POISTOVNA CASCADE CONSTRAINTS;
DROP TABLE SKLAD CASCADE CONSTRAINTS;

DROP SEQUENCE  ID_POISTOVNE_seq;

create table LEKAREN
(
    ID_LEKARNE      int GENERATED BY DEFAULT AS IDENTITY (START WITH 1 INCREMENT BY 1) not null,
    ULICA           VARCHAR(20) not null,
    SUPISNE_CISLO   NUMBER(5) not null,
    ORIENTACNE_CISLO NUMBER(3),
    PSC             NUMBER(5) not null,
    MESTO           VARCHAR(20) not null,
    TELEFONNE_CISLO CHAR(13),
    DATUM_INVENTURY DATE,
    SKLAD_ID        int not null,

    CHECK (REGEXP_LIKE(TELEFONNE_CISLO, '^\+421\d{9}$') )
);

create table JE_V_ZMLUVE
(
    ID_table        int GENERATED BY DEFAULT AS IDENTITY (START WITH 1 INCREMENT BY 1) not null,
    POISTOVNA_ID    int not null,
    LEKAREN_ID      int,
    CHECK ( LEKAREN_ID > 0 )
);

create table VYKAZ
(
    ID_VYKAZU           int GENERATED BY DEFAULT AS IDENTITY (START WITH 1 INCREMENT BY 1) not null,
    DATUM_VYHOTOVENIA   DATE,
    POISTOVNA_ID        int not null
);

create table NAKUP
(
    CISLO_POKLADNICNEHO_BLOKU int GENERATED BY DEFAULT AS IDENTITY (START WITH 1 INCREMENT BY 1) not null,
    DATUM_PREDAJA             DATE,
    LEKAREN                   int not null
);

create table AKTUALIZUJE
(
    ID_table        int GENERATED BY DEFAULT AS IDENTITY (START WITH 1 INCREMENT BY 1) not null,
    ID_VYKAZ            int not null,
    ID_NAKUP            int not null,
    LIEKY_NA_PREDPIS    int not null
);


create table SUCAST_NAKUPU
(
    ID_table        int GENERATED BY DEFAULT AS IDENTITY (START WITH 1 INCREMENT BY 1) not null,
    NAKUP_ID    int not null,
    LIEK_ID     int not null
);

create table LIEK
(
    CISLO_LIEKU      int GENERATED BY DEFAULT AS IDENTITY (START WITH 1 INCREMENT BY 1) not null,
    NAZOV            VARCHAR(50),
    CENA             DECIMAL(5, 2),
    DENNA_DAVKA      VARCHAR(70),
    UCINNA_LATKA     VARCHAR(150),
    EXPIRACIA        DATE,
    VEDLAJSIE_UCINKY VARCHAR(150),
    CHECK ( CENA <= 99999.99 )
);

CREATE TABLE NA_PREDPIS
(
    CISLO_LIEKU int GENERATED BY DEFAULT AS IDENTITY (START WITH 1 INCREMENT BY 1) not null
);

CREATE TABLE  BEZ_PREDPISU
(
    CISLO_LIEKU int GENERATED BY DEFAULT AS IDENTITY (START WITH 1 INCREMENT BY 1) not null
);

create table HRADI_DOPLATOK
(
    ID_table        int GENERATED BY DEFAULT AS IDENTITY (START WITH 1 INCREMENT BY 1) not null,
    ID_LIEK         int not null,
    POISTOVNA       int not null,
    VYSKA_DOPLATKU  DECIMAL(5, 2),
    CHECK ( VYSKA_DOPLATKU <= 99999.99 )
);

create table POCET_LIEKOV_NA_SKLADE
(
    ID_table        int GENERATED BY DEFAULT AS IDENTITY (START WITH 1 INCREMENT BY 1) not null,
    ID_LIEK         int not null,
    ID_SKLAD        int not null ,
    POCET_LIEKOV    NUMBER(4),
    CHECK ( POCET_LIEKOV <= 9999 )
);

create table ZDRAVOTNA_POISTOVNA
(
    ID_POISTOVNE int default null,
    NAZOV       VARCHAR(20),
    PLATNOST_ZMLUVY DATE
);

create table SKLAD
(
    ID_SKLADU int GENERATED BY DEFAULT AS IDENTITY (START WITH 1 INCREMENT BY 1) not null,
    MNOZSTVO_TOVARU_NA_SKLADE NUMBER,
    KAPACITA                  NUMBER,
    CHECK (MNOZSTVO_TOVARU_NA_SKLADE <= KAPACITA)
);

ALTER TABLE LEKAREN ADD CONSTRAINT pk_lekaren PRIMARY KEY(ID_LEKARNE);
ALTER TABLE VYKAZ ADD CONSTRAINT pk_vykaz PRIMARY KEY(ID_VYKAZU);
ALTER TABLE NAKUP ADD CONSTRAINT pk_nakup PRIMARY KEY(CISLO_POKLADNICNEHO_BLOKU);
ALTER TABLE LIEK ADD CONSTRAINT pk_liek PRIMARY KEY(CISLO_LIEKU);
ALTER TABLE ZDRAVOTNA_POISTOVNA ADD CONSTRAINT pk_poistovna PRIMARY KEY(ID_POISTOVNE);
ALTER TABLE SKLAD ADD CONSTRAINT pk_sklad PRIMARY KEY(ID_SKLADU);
ALTER TABLE NA_PREDPIS ADD CONSTRAINT PK_NA_PREDPIS PRIMARY KEY (CISLO_LIEKU);
ALTER TABLE BEZ_PREDPISU ADD CONSTRAINT PK_BEZ_PREDPISU PRIMARY KEY (CISLO_LIEKU);
ALTER TABLE JE_V_ZMLUVE ADD CONSTRAINT pk_je_v_zmluve PRIMARY KEY (ID_table);
ALTER TABLE AKTUALIZUJE ADD CONSTRAINT pk_aktualizuje PRIMARY KEY (ID_table);
ALTER TABLE SUCAST_NAKUPU ADD CONSTRAINT pk_sucast_nakupu PRIMARY KEY (ID_table);
ALTER TABLE HRADI_DOPLATOK ADD CONSTRAINT pk_hradi_doplatok PRIMARY KEY (ID_table);
ALTER TABLE POCET_LIEKOV_NA_SKLADE ADD CONSTRAINT pk_pocet_liekov_na_sklade PRIMARY KEY (ID_table);

ALTER TABLE LEKAREN ADD CONSTRAINT SKLAD_LEKARNE FOREIGN KEY (SKLAD_ID) REFERENCES SKLAD(ID_SKLADU) ON DELETE CASCADE;
ALTER TABLE JE_V_ZMLUVE ADD CONSTRAINT VZTAH_LEKAREN FOREIGN KEY (LEKAREN_ID) REFERENCES LEKAREN(ID_LEKARNE) ON DELETE CASCADE;
ALTER TABLE JE_V_ZMLUVE ADD CONSTRAINT VZTAH_POISTOVNA FOREIGN KEY (POISTOVNA_ID) REFERENCES ZDRAVOTNA_POISTOVNA (ID_POISTOVNE) ON DELETE CASCADE;
ALTER TABLE VYKAZ ADD CONSTRAINT VYDAVA_POISTOVNI FOREIGN KEY (POISTOVNA_ID) REFERENCES ZDRAVOTNA_POISTOVNA (ID_POISTOVNE) ON DELETE CASCADE;
ALTER TABLE NAKUP ADD CONSTRAINT ZAKUPENY_V FOREIGN KEY (LEKAREN) REFERENCES LEKAREN(ID_LEKARNE) ON DELETE CASCADE;
ALTER TABLE SUCAST_NAKUPU ADD CONSTRAINT NAKUP FOREIGN KEY (NAKUP_ID) REFERENCES NAKUP(CISLO_POKLADNICNEHO_BLOKU) ON DELETE CASCADE;
ALTER TABLE SUCAST_NAKUPU ADD CONSTRAINT LIEKY FOREIGN KEY (LIEK_ID) REFERENCES LIEK(CISLO_LIEKU) ON DELETE CASCADE;
ALTER TABLE POCET_LIEKOV_NA_SKLADE ADD CONSTRAINT SKLAD_POCET FOREIGN KEY (ID_SKLAD) REFERENCES SKLAD(ID_SKLADU) ON DELETE CASCADE;
ALTER TABLE POCET_LIEKOV_NA_SKLADE ADD CONSTRAINT LIEK_POCET FOREIGN KEY (ID_LIEK) REFERENCES LIEK(CISLO_LIEKU) ON DELETE CASCADE;
ALTER TABLE AKTUALIZUJE ADD FOREIGN KEY (ID_VYKAZ) REFERENCES VYKAZ(ID_VYKAZU);
ALTER TABLE AKTUALIZUJE ADD FOREIGN KEY (ID_NAKUP) REFERENCES NAKUP(CISLO_POKLADNICNEHO_BLOKU);
ALTER TABLE NA_PREDPIS ADD CONSTRAINT FK_NA_PREDPIS FOREIGN KEY (CISLO_LIEKU) REFERENCES LIEK (CISLO_LIEKU);
ALTER TABLE BEZ_PREDPISU ADD CONSTRAINT FK_BEZ_PREDPISU FOREIGN KEY (CISLO_LIEKU) REFERENCES LIEK (CISLO_LIEKU);
ALTER TABLE HRADI_DOPLATOK ADD FOREIGN KEY (ID_LIEK) REFERENCES LIEK(CISLO_LIEKU);
ALTER TABLE HRADI_DOPLATOK ADD FOREIGN KEY (POISTOVNA) REFERENCES ZDRAVOTNA_POISTOVNA(ID_POISTOVNE);


-- TRIGGERS
-- Trigger zabezpecujuci pridanie primarneho kluca pre tabulku ZDRAVOTNA POISTOVNA v pripade ze je null
CREATE SEQUENCE ID_POISTOVNE_seq START WITH 1 INCREMENT BY 1;
CREATE OR REPLACE TRIGGER ID_POISTOVNE_trigger
    BEFORE INSERT
    ON ZDRAVOTNA_POISTOVNA
    FOR EACH ROW
BEGIN
    SELECT ID_POISTOVNE_seq.nextval INTO :NEW.ID_POISTOVNE FROM DUAL;
END;
/

-- TRIGGERS --
-- Trigger (X out of N) zisťujúci či nevypršal dátum expirácie lieku
CREATE OR REPLACE TRIGGER datum_expiracie_trigger
    AFTER INSERT
    ON LIEK
    FOR EACH ROW
BEGIN
    IF :new.EXPIRACIA < SYSDATE
    THEN
        RAISE_APPLICATION_ERROR(-20000, 'Liek je po dátume expirácie!');
    END IF;
end;
/


INSERT INTO SKLAD(MNOZSTVO_TOVARU_NA_SKLADE, KAPACITA) VALUES(57,2250);
INSERT INTO SKLAD(MNOZSTVO_TOVARU_NA_SKLADE, KAPACITA) VALUES(380,2250);
INSERT INTO SKLAD(MNOZSTVO_TOVARU_NA_SKLADE, KAPACITA) VALUES(2250,2250);

INSERT INTO LEKAREN(ULICA, SUPISNE_CISLO, ORIENTACNE_CISLO, PSC, MESTO, TELEFONNE_CISLO, DATUM_INVENTURY,SKLAD_ID) VALUES('Antona Bernoláka', 2135, 2, 01001, 'Žilina','+421901961271',TO_DATE('01.03.2020', 'dd.mm.yyyy'),1);
INSERT INTO LEKAREN(ULICA, SUPISNE_CISLO, ORIENTACNE_CISLO, PSC, MESTO, TELEFONNE_CISLO, DATUM_INVENTURY,SKLAD_ID) VALUES('Legionárska', 1459, 19, 91101, 'Trenčín','+421901961504',TO_DATE('10.03.2020', 'dd.mm.yyyy'),2);
INSERT INTO LEKAREN(ULICA, SUPISNE_CISLO, ORIENTACNE_CISLO, PSC, MESTO, TELEFONNE_CISLO, DATUM_INVENTURY,SKLAD_ID) VALUES('Betliarska', 3776, 17,85107,'Bratislava','+421901961312',TO_DATE('08.03.2020', 'dd.mm.yyyy'),3);

INSERT INTO ZDRAVOTNA_POISTOVNA(PLATNOST_ZMLUVY,NAZOV) VALUES(TO_DATE('30.06.2025', 'dd.mm.yyyy'),'VSZP');
INSERT INTO ZDRAVOTNA_POISTOVNA(PLATNOST_ZMLUVY,NAZOV) VALUES(TO_DATE('31.12.2027', 'dd.mm.yyyy'),'DOVERA');
INSERT INTO ZDRAVOTNA_POISTOVNA(PLATNOST_ZMLUVY,NAZOV) VALUES(TO_DATE('31.08.2024', 'dd.mm.yyyy'), 'UNION');

INSERT INTO VYKAZ(DATUM_VYHOTOVENIA, POISTOVNA_ID) VALUES(TO_DATE('11.03.2020', 'dd.mm.yyyy'),1);
INSERT INTO VYKAZ(DATUM_VYHOTOVENIA, POISTOVNA_ID) VALUES(TO_DATE('11.03.2020', 'dd.mm.yyyy'),2);
INSERT INTO VYKAZ(DATUM_VYHOTOVENIA, POISTOVNA_ID) VALUES(TO_DATE('12.03.2020', 'dd.mm.yyyy'),3);

INSERT INTO NAKUP(DATUM_PREDAJA, LEKAREN) VALUES(TO_DATE('08.03.2020', 'dd.mm.yyyy'),1);
INSERT INTO NAKUP(DATUM_PREDAJA, LEKAREN) VALUES(TO_DATE('10.02.2020', 'dd.mm.yyyy'),2);
INSERT INTO NAKUP(DATUM_PREDAJA, LEKAREN) VALUES(TO_DATE('12.12.2019', 'dd.mm.yyyy'),3);

INSERT INTO LIEK(NAZOV, CENA, DENNA_DAVKA, UCINNA_LATKA, EXPIRACIA, VEDLAJSIE_UCINKY) VALUES ('Šumivé tablety',2.99,'1 šumivá tableta denne','horčík a vitamín B6',TO_DATE('20.03.2021','dd.mm.yyyy'),'laxatívne účinky');
INSERT INTO LIEK(NAZOV, CENA, DENNA_DAVKA, UCINNA_LATKA, EXPIRACIA, VEDLAJSIE_UCINKY) VALUES ('Drahé dobré tablety',99.89,'3-krát 5 až 3-krát 10 tabliet denne','pankreatín, amyláza, lipáza, bromelaín, trypsín, papaín, chymotrypsín, rutozid trihydrát',TO_DATE('03.08.2021','dd.mm.yyyy'),'nevýrazná zmena konzistencie, farby a zápachu stolice, pocit plnosti');
INSERT INTO LIEK(NAZOV, CENA, DENNA_DAVKA, UCINNA_LATKA, EXPIRACIA, VEDLAJSIE_UCINKY) VALUES ('Sprej do nosa', 3.69,'1 vstrek do každej nosovej dierky maximálne 3x denne','xylometazolíniumchlorid',TO_DATE('09.12.2020','dd.mm.yyyy'),'bolesti hlavy,nevoľnosť,krvácanie z nosa,zvýšený krvný tlak');
INSERT INTO LIEK(NAZOV, CENA, DENNA_DAVKA, UCINNA_LATKA, EXPIRACIA, VEDLAJSIE_UCINKY) VALUES ('Parapyrex',1.99,'1-2 tablety v jednej dávke, maximálne 6 tabliet/deň','paracetamol',TO_DATE('07.08.2021','dd.mm.yyyy'),'nezvyčajná funkcia pečene, zlyhanie pečene, cirhóza (odumretie pečeňových buniek) a žltačka');
INSERT INTO LIEK(NAZOV, CENA, DENNA_DAVKA, UCINNA_LATKA, EXPIRACIA, VEDLAJSIE_UCINKY) VALUES ('Acylpirin', 2.29,' individuálne v závislosti od charakteru základného ochorenia','kyselina acetylsalicylová',TO_DATE('31.12.2020','dd.mm.yyyy'),'poruchy tráviaceho ústrojenstva (bolesť brucha, pálenie záhy, žalúdočná nevoľnosť, vracanie)');

INSERT INTO AKTUALIZUJE(ID_VYKAZ, ID_NAKUP, LIEKY_NA_PREDPIS) VALUES(1,1,2);
INSERT INTO AKTUALIZUJE(ID_VYKAZ, ID_NAKUP, LIEKY_NA_PREDPIS) VALUES(2,2,1);
INSERT INTO AKTUALIZUJE(ID_VYKAZ, ID_NAKUP, LIEKY_NA_PREDPIS) VALUES(3,3,1);

INSERT INTO SUCAST_NAKUPU(NAKUP_ID,LIEK_ID) VALUES(1,1);
INSERT INTO SUCAST_NAKUPU(NAKUP_ID,LIEK_ID) VALUES(1,2);
INSERT INTO SUCAST_NAKUPU(NAKUP_ID,LIEK_ID) VALUES(1,3);
INSERT INTO SUCAST_NAKUPU(NAKUP_ID,LIEK_ID) VALUES(2,2);
INSERT INTO SUCAST_NAKUPU(NAKUP_ID,LIEK_ID) VALUES(3,3);

INSERT INTO JE_V_ZMLUVE(POISTOVNA_ID, LEKAREN_ID) VALUES(1,1);
INSERT INTO JE_V_ZMLUVE(POISTOVNA_ID, LEKAREN_ID) VALUES(1,2);
INSERT INTO JE_V_ZMLUVE(POISTOVNA_ID, LEKAREN_ID) VALUES(1,3);
INSERT INTO JE_V_ZMLUVE(POISTOVNA_ID, LEKAREN_ID) VALUES(2,2);
INSERT INTO JE_V_ZMLUVE(POISTOVNA_ID, LEKAREN_ID) VALUES(2,3);
INSERT INTO JE_V_ZMLUVE(POISTOVNA_ID, LEKAREN_ID) VALUES(3,1);

INSERT INTO HRADI_DOPLATOK(VYSKA_DOPLATKU, ID_LIEK, POISTOVNA) VALUES(15.53,2,1);
INSERT INTO HRADI_DOPLATOK(VYSKA_DOPLATKU, ID_LIEK, POISTOVNA) VALUES(1.22,3,1);
INSERT INTO HRADI_DOPLATOK(VYSKA_DOPLATKU, ID_LIEK, POISTOVNA) VALUES(23.26,2,2);
INSERT INTO HRADI_DOPLATOK(VYSKA_DOPLATKU, ID_LIEK, POISTOVNA) VALUES(0.76,3,2);
INSERT INTO HRADI_DOPLATOK(VYSKA_DOPLATKU, ID_LIEK, POISTOVNA) VALUES(20.53,2,3);

INSERT INTO NA_PREDPIS(CISLO_LIEKU) VALUES(2);
INSERT INTO NA_PREDPIS(CISLO_LIEKU) VALUES(3);

INSERT INTO BEZ_PREDPISU(CISLO_LIEKU) VALUES(1);
INSERT INTO BEZ_PREDPISU(CISLO_LIEKU) VALUES(3);
INSERT INTO BEZ_PREDPISU(CISLO_LIEKU) VALUES(4);
INSERT INTO BEZ_PREDPISU(CISLO_LIEKU) VALUES(5);

INSERT INTO POCET_LIEKOV_NA_SKLADE(ID_LIEK, ID_SKLAD, POCET_LIEKOV) VALUES(1,1,30);
INSERT INTO POCET_LIEKOV_NA_SKLADE(ID_LIEK, ID_SKLAD, POCET_LIEKOV) VALUES(2,1,2);
INSERT INTO POCET_LIEKOV_NA_SKLADE(ID_LIEK, ID_SKLAD, POCET_LIEKOV) VALUES(3,1,25);
INSERT INTO POCET_LIEKOV_NA_SKLADE(ID_LIEK, ID_SKLAD, POCET_LIEKOV) VALUES(1,2,150);
INSERT INTO POCET_LIEKOV_NA_SKLADE(ID_LIEK, ID_SKLAD, POCET_LIEKOV) VALUES(2,2,80);
INSERT INTO POCET_LIEKOV_NA_SKLADE(ID_LIEK, ID_SKLAD, POCET_LIEKOV) VALUES(3,2,150);
INSERT INTO POCET_LIEKOV_NA_SKLADE(ID_LIEK, ID_SKLAD, POCET_LIEKOV) VALUES(1,3,1250);
INSERT INTO POCET_LIEKOV_NA_SKLADE(ID_LIEK, ID_SKLAD, POCET_LIEKOV) VALUES(2,3,100);
INSERT INTO POCET_LIEKOV_NA_SKLADE(ID_LIEK, ID_SKLAD, POCET_LIEKOV) VALUES(3,3,900);

-- -- -- -- -- -- -- -- -- -- -- PREDVEDENIE TRIGGEROV -- -- -- -- -- -- -- -- -- -- -- -- --
-- Predvedenie triggeru 1, ktory vygeneruje ID poistovne automaticky
-- na zaklade dat vyssie by malo byt ID VSZP = 1, DOVERA = 2, UNION = 3
SELECT ID_POISTOVNE, NAZOV  FROM ZDRAVOTNA_POISTOVNA
ORDER BY ID_POISTOVNE;

-- Predvedenie triggeru 2
--Pri pokuse o vlozenie polozky do tabulky liek sa vyhodi application error kvoli lieku po expiracii
--INSERT INTO LIEK(NAZOV, CENA, DENNA_DAVKA, UCINNA_LATKA, EXPIRACIA, VEDLAJSIE_UCINKY) VALUES ('Šumivé tablety',2.99,'1 šumivá tableta denne','horčík a vitamín B6',TO_DATE('20.03.2019','dd.mm.yyyy'),'laxatívne účinky');

-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --
--3/5-- --PRIKAZY SELECT--


--2x JOIN 2 TABLES
--Zobrazí všetky lekárne, ktoré majú zmluvu so zdravotnou poistovňou UNION
SELECT *
  from LEKAREN NATURAL JOIN ZDRAVOTNA_POISTOVNA
  WHERE  NAZOV = 'UNION';

--Zobrazi lieky a vysky doplatkov na liek ktore hradi poistovna VSZP
SELECT DISTINCT ID_LIEK, VYSKA_DOPLATKU
  from ZDRAVOTNA_POISTOVNA NATURAL JOIN HRADI_DOPLATOK
  WHERE  POISTOVNA = 1;

--1x JOIN 3 TABLES
--Zobrazí sklady, ktoré majú počet na sklade nejakého lieku na predpis pod 50
SELECT DISTINCT ID_SKLAD, ID_LIEK, POCET_LIEKOV
  FROM SKLAD NATURAL JOIN POCET_LIEKOV_NA_SKLADE, NA_PREDPIS
  WHERE  NA_PREDPIS.CISLO_LIEKU = POCET_LIEKOV_NA_SKLADE.ID_LIEK AND POCET_LIEKOV_NA_SKLADE.POCET_LIEKOV < 50 ;

--2x  GROUP BY s agregačnou funkciou
--Aký je najväčší počet liekov na sklade v jednotlivých lekárňach?
SELECT L.MESTO, L.ULICA, MAX(S.POCET_LIEKOV)
FROM LEKAREN L, POCET_LIEKOV_NA_SKLADE S
WHERE L.ID_LEKARNE = S.ID_SKLAD
GROUP BY L.MESTO, L.ULICA
ORDER BY 3 DESC;

--Ktoré lekárne majú na svojom sklade celkovo viac než 300 liekov?
SELECT L.MESTO, L.ULICA, SUM(S.POCET_LIEKOV)
FROM LEKAREN L, POCET_LIEKOV_NA_SKLADE S
WHERE L.ID_LEKARNE = S.ID_SKLAD
GROUP BY L.MESTO, L.ULICA HAVING SUM(S.POCET_LIEKOV) > 300;

--1x IN s vnoreným selectom
--Aký je počet šumivých tabliet na skladoch lekární?
SELECT S.ID_SKLAD, S.POCET_LIEKOV
FROM POCET_LIEKOV_NA_SKLADE S
WHERE S.ID_LIEK IN (SELECT L.CISLO_LIEKU FROM LIEK L WHERE L.CISLO_LIEKU = 1)
ORDER BY S.ID_SKLAD;

--1x prediát EXISTS
-- Vypíše lieky, ktoré boli kúpene s cenou väčšou ako 3€
SELECT N.LIEK_ID, N.NAKUP_ID
FROM SUCAST_NAKUPU N
WHERE EXISTS (SELECT L.CISLO_LIEKU FROM LIEK L WHERE L.CISLO_LIEKU = N.LIEK_ID AND L.CENA > 3.00)
ORDER BY N.NAKUP_ID DESC;


-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --
--4/5-- -- VYTVORENIE POKROČILÝCH OBJEKTOV SCHÉMY DATABÁZE --

-- ------------------------------------------EXPLAIN PLAN -- ---------------------------------
-- first run bez použitia indexu
-- zobrazí dátum predaja, lekárne, v ktorých sa uskutočnil nákup a sumu všetkých zakúpených liekov na predpis
EXPLAIN PLAN FOR
SELECT NAKUP.DATUM_PREDAJA, NAKUP.LEKAREN, SUM(LIEK.CENA) AS celkova_cena
FROM SUCAST_NAKUPU, NAKUP, NA_PREDPIS, LIEK
WHERE NA_PREDPIS.CISLO_LIEKU = SUCAST_NAKUPU.LIEK_ID AND NA_PREDPIS.CISLO_LIEKU = LIEK.CISLO_LIEKU
GROUP BY NAKUP.DATUM_PREDAJA, NAKUP.LEKAREN;

-- OUTPUT
SELECT PLAN_TABLE_OUTPUT FROM TABLE(DBMS_XPLAN.DISPLAY());

-- vytváranie indexov pre najčastejšie používané tabuľky
-- !!!ALERT!!!!, neviem či znížená réžia stačí a či som ich zvolil správne, keď tak daj na to look
CREATE INDEX liek_index ON LIEK (CISLO_LIEKU, CENA);
CREATE INDEX sucast_index ON SUCAST_NAKUPU (ID_TABLE, NAKUP_ID, LIEK_ID);

-- second run s použitím indexov
EXPLAIN PLAN FOR
SELECT NAKUP.DATUM_PREDAJA, NAKUP.LEKAREN, SUM(LIEK.CENA) AS celkova_cena
FROM SUCAST_NAKUPU, NAKUP, NA_PREDPIS, LIEK
WHERE NA_PREDPIS.CISLO_LIEKU = SUCAST_NAKUPU.LIEK_ID AND NA_PREDPIS.CISLO_LIEKU = LIEK.CISLO_LIEKU
GROUP BY NAKUP.DATUM_PREDAJA, NAKUP.LEKAREN;

-- OUTPUT
SELECT PLAN_TABLE_OUTPUT FROM TABLE(DBMS_XPLAN.DISPLAY());
DROP INDEX liek_index;
DROP INDEX sucast_index;

-----------------------------------------------PROCEDURES------------------------------------

-- procedúra (1/2) zistí koľko percent liekov na sklade "sklad_id_arg" je
-- z celkového počtu liekov vo všetkých skladoch
-- v prípade že nie je žiaden liek na sklade vypíše chybu
CREATE OR REPLACE PROCEDURE percenta_lieku_z_kapacity(sklad_id_arg in int) AS
BEGIN
    DECLARE CURSOR cursor_lieky is
        SELECT A.ID_SKLAD, A.ID_LIEK, A.POCET_LIEKOV
        FROM POCET_LIEKOV_NA_SKLADE A;
            id_sklad POCET_LIEKOV_NA_SKLADE.ID_SKLAD%TYPE;
            id_liek POCET_LIEKOV_NA_SKLADE.ID_LIEK%TYPE;
            liek POCET_LIEKOV_NA_SKLADE.POCET_LIEKOV%TYPE;
            lieky_sklad NUMBER;
            pocet_vsetkych_liekov NUMBER;
            percenta_liekov NUMERIC(5,2);
                BEGIN
                    pocet_vsetkych_liekov := 0;
                    lieky_sklad := 0;
                    OPEN cursor_lieky;
                    LOOP
                        FETCH cursor_lieky INTO id_sklad, id_liek, liek;
                        EXIT WHEN cursor_lieky%NOTFOUND;
                            IF id_sklad = sklad_id_arg THEN
                                lieky_sklad := lieky_sklad + liek;
                            END IF;
                                pocet_vsetkych_liekov := pocet_vsetkych_liekov + liek;
                    END LOOP;
                    CLOSE cursor_lieky;
                    percenta_liekov := (lieky_sklad / pocet_vsetkych_liekov) * 100;

                    DBMS_OUTPUT.put_line('SKLAD ID ' || sklad_id_arg || ' skladuje: ' || percenta_liekov || '% všetkých liekov na všetkých skladoch');
                    EXCEPTION WHEN ZERO_DIVIDE THEN
                    BEGIN
                        DBMS_OUTPUT.put_line('Nijaké lieky na sklade!' );
                    END;
				END;
END;
/

CALL percenta_lieku_z_kapacity(1);
CALL percenta_lieku_z_kapacity(2);
CALL percenta_lieku_z_kapacity(3);


-- procedúra (2/2)
--NEVIEM JU NAPISAT LEBO SOM KOKOKOKOKOT
CREATE OR REPLACE PROCEDURE volne_miesto_v_sklade AS
    lieky_na_sklade NUMBER;
    kapacita_skladu NUMBER;
    final_id NUMBER;
    DECLARE CURSOR sklad_id is SELECT S.ID_SKLADU FROM SKLAD S;
        BEGIN
            OPEN sklad_id;
            LOOP
                FETCH sklad_id INTO final_id;
                EXIT WHEN sklad_id%NOTFOUND;

            end loop;
        end;

------------------------------------- MATERIALIZED VIEW -----------------
-- vypise zoznam lekarni a k nim priradeny sklad

DROP MATERIALIZED VIEW sklady_lekarni;
CREATE MATERIALIZED VIEW sklady_lekarni
CACHE BUILD IMMEDIATE
REFRESH ON COMMIT AS
SELECT XORAVE05.LEKAREN.ID_LEKARNE AS lekaren, XORAVE05.LEKAREN.ULICA as ulica, XORAVE05.LEKAREN.MESTO as mesto,
XORAVE05.SKLAD.ID_SKLADU as sklad
FROM XORAVE05.LEKAREN JOIN XORAVE05.SKLAD ON XORAVE05.LEKAREN.ID_LEKARNE = XORAVE05.SKLAD.ID_SKLADU
GROUP BY XORAVE05.LEKAREN.ID_LEKARNE, XORAVE05.LEKAREN.ULICA, XORAVE05.LEKAREN.MESTO, XORAVE05.SKLAD.ID_SKLADU;

-- predvedenie:

SELECT * FROM sklady_lekarni;  -- materializovany pohlad
UPDATE LEKAREN SET MESTO = 'Brno' WHERE ID_LEKARNE = 1;
SELECT * FROM sklady_lekarni;   -- stale nezmeneny materializovany pohlad
COMMIT;
SELECT * FROM sklady_lekarni;  -- tu by to malo byt zmenene



------------------------------------- PRIVILEGIA ------------------------

GRANT ALL ON LEKAREN                     TO xbobos00;
GRANT ALL ON VYKAZ                       TO xbobos00;
GRANT ALL ON NAKUP                       TO xbobos00;
GRANT ALL ON AKTUALIZUJE                 TO xbobos00;
GRANT ALL ON SUCAST_NAKUPU               TO xbobos00;
GRANT ALL ON LIEK                        TO xbobos00;
GRANT ALL ON NA_PREDPIS                  TO xbobos00;
GRANT ALL ON BEZ_PREDPISU                TO xbobos00;
GRANT ALL ON HRADI_DOPLATOK              TO xbobos00;
GRANT ALL ON POCET_LIEKOV_NA_SKLADE      TO xbobos00;
GRANT ALL ON ZDRAVOTNA_POISTOVNA         TO xbobos00;
GRANT ALL ON SKLAD                       TO xbobos00;

GRANT EXECUTE ON percenta_lieku_z_kapacity TO xbobos00;

GRANT ALL ON sklady_lekarni              TO xbobos00;