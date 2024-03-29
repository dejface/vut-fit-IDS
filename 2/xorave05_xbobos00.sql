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
    ID_POISTOVNE int GENERATED BY DEFAULT AS IDENTITY (START WITH 1 INCREMENT BY 1) not null,
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


INSERT INTO SKLAD(MNOZSTVO_TOVARU_NA_SKLADE, KAPACITA) VALUES(57,2250);
INSERT INTO SKLAD(MNOZSTVO_TOVARU_NA_SKLADE, KAPACITA) VALUES(380,2250);
INSERT INTO SKLAD(MNOZSTVO_TOVARU_NA_SKLADE, KAPACITA) VALUES(2250,2250);

INSERT INTO LEKAREN(ULICA, SUPISNE_CISLO, ORIENTACNE_CISLO, PSC, MESTO, TELEFONNE_CISLO, DATUM_INVENTURY,SKLAD_ID) VALUES('Antona Bernoláka', 2135, 2, 01001, 'Žilina','+421901961271',TO_DATE('01.03.2020', 'dd.mm.yyyy'),1);
INSERT INTO LEKAREN(ULICA, SUPISNE_CISLO, PSC, MESTO, TELEFONNE_CISLO, DATUM_INVENTURY,SKLAD_ID) VALUES('Legionárska', 19, 91101, 'Trenčín','+421901961504',TO_DATE('10.03.2020', 'dd.mm.yyyy'),2);
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

INSERT INTO POCET_LIEKOV_NA_SKLADE(ID_LIEK, ID_SKLAD, POCET_LIEKOV) VALUES(1,1,30);
INSERT INTO POCET_LIEKOV_NA_SKLADE(ID_LIEK, ID_SKLAD, POCET_LIEKOV) VALUES(2,1,2);
INSERT INTO POCET_LIEKOV_NA_SKLADE(ID_LIEK, ID_SKLAD, POCET_LIEKOV) VALUES(3,1,25);
INSERT INTO POCET_LIEKOV_NA_SKLADE(ID_LIEK, ID_SKLAD, POCET_LIEKOV) VALUES(1,2,150);
INSERT INTO POCET_LIEKOV_NA_SKLADE(ID_LIEK, ID_SKLAD, POCET_LIEKOV) VALUES(2,2,80);
INSERT INTO POCET_LIEKOV_NA_SKLADE(ID_LIEK, ID_SKLAD, POCET_LIEKOV) VALUES(3,2,150);
INSERT INTO POCET_LIEKOV_NA_SKLADE(ID_LIEK, ID_SKLAD, POCET_LIEKOV) VALUES(1,3,1250);
INSERT INTO POCET_LIEKOV_NA_SKLADE(ID_LIEK, ID_SKLAD, POCET_LIEKOV) VALUES(2,3,100);
INSERT INTO POCET_LIEKOV_NA_SKLADE(ID_LIEK, ID_SKLAD, POCET_LIEKOV) VALUES(3,3,900);
