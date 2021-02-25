REM **********************************************************************
REM Script ORACLE de crétion de la base Promotion
REM **********************************************************************   

alter session set nls_date_format = 'DD/MM/RRRR';

PURGE RECYCLEBIN;

REM SUPPRESSION des tables

DROP TABLE Promotion CASCADE CONSTRAINT PURGE;
DROP TABLE Secteur CASCADE CONSTRAINT PURGE;
DROP TABLE Commercial CASCADE CONSTRAINT PURGE;
DROP TABLE Offre CASCADE CONSTRAINT PURGE;
DROP TABLE Sponsoriser CASCADE CONSTRAINT PURGE;
DROP TABLE Annoncer CASCADE CONSTRAINT PURGE;

DROP SEQUENCE IncremSecteur;
DROP SEQUENCE IncremPromotion;
DROP SEQUENCE IncremOffre;
DROP SEQUENCE IncremCommercial;

REM CREATION TABLE Promotion 

CREATE TABLE Promotion
(
   Id_Prom INTEGER,
   Intitule_Prom VARCHAR(50) NOT NULL,
   NbreAnnonceur INTEGER DEFAULT 0 NOT NULL ,
   MontantTotal NUMBER(10,2) DEFAULT 0 NOT NULL
);


REM CREATION TABLE Secteur 

CREATE TABLE Secteur(
   Id_Secteur INTEGER,
   Nom_Secteur VARCHAR(50) NOT NULL UNIQUE,
   NbRepresentant INT DEFAULT 0 NOT NULL 
);


REM CREATION TABLE  

CREATE TABLE Commercial(
   Id_Com INTEGER,
   Nom_Com VARCHAR(30) NOT NULL,
   Prenom_Com VARCHAR(30) NOT NULL,
   Localisation_Com VARCHAR(50) NOT NULL UNIQUE,
   Email_Com VARCHAR(50) UNIQUE,
   Tel_Com INTEGER UNIQUE,
   Id_Secteur INTEGER NOT NULL
);


REM CREATION TABLE Offre

CREATE TABLE Offre(
   Id_Offre INTEGER,
   Nom_Offre VARCHAR(30) NOT NULL UNIQUE,
   Id_Prom INTEGER NOT NULL
);


REM CREATION TABLE Sponsoriser

CREATE TABLE Sponsoriser(
   Id_Offre INTEGER,
   Id_Com INTEGER,
   Accorder CHAR(1) NOT NULL
);


REM CREATION TABLE Annoncer

CREATE TABLE Annoncer(
   Id_Prom INTEGER,
   Id_Com INTEGER,
   DateAnnonce DATE NOT NULL
);


ALTER TABLE Promotion 
ADD CONSTRAINT PK_MY_Promotion PRIMARY KEY(Id_Prom)
/

ALTER TABLE Secteur
ADD CONSTRAINT PK_MY_Secteur PRIMARY KEY(Id_Secteur) 
/

ALTER TABLE Commercial
ADD CONSTRAINT PK_MY_Commercial PRIMARY KEY(Id_Com)
ADD CONSTRAINT FK_MY_CS FOREIGN KEY(Id_Secteur) 
	REFERENCES Secteur(Id_Secteur)ON DELETE CASCADE
/

ALTER TABLE Offre
ADD CONSTRAINT PK_MY_Offre PRIMARY KEY(Id_Offre)
ADD CONSTRAINT FK_MY_OP FOREIGN KEY(Id_Prom) 
	REFERENCES Promotion(Id_Prom)ON DELETE CASCADE
/

ALTER TABLE Sponsoriser
ADD CONSTRAINT PK_MY_Sponsoriser PRIMARY KEY(Id_Offre, Id_Com)
ADD CONSTRAINT FK_MY_SO FOREIGN KEY(Id_Offre) 
	REFERENCES Offre(Id_Offre) ON DELETE CASCADE
ADD CONSTRAINT FK_MY_SC FOREIGN KEY(Id_Com) 
	REFERENCES Commercial(Id_Com)ON DELETE CASCADE
ADD CONSTRAINT CK_MY_Accorder CHECK (UPPER(Accorder)IN('O','N'))
/

ALTER TABLE Annoncer
ADD CONSTRAINT PK_MY_Annoncer PRIMARY KEY(Id_Prom, Id_Com)
ADD CONSTRAINT FK_MY_AP FOREIGN KEY(Id_Prom) 
	REFERENCES Promotion(Id_Prom) ON DELETE CASCADE
ADD CONSTRAINT FK_MY_AC FOREIGN KEY(Id_Com) 
	REFERENCES Commercial(Id_Com) ON DELETE CASCADE
/

CREATE SEQUENCE IncremSecteur 
    START WITH 1  
    INCREMENT BY 1 ; 

CREATE SEQUENCE IncremPromotion
    START WITH 1  
    INCREMENT BY 1 ; 
	
CREATE SEQUENCE IncremOffre
    START WITH 1  
    INCREMENT BY 1 ; 
	
CREATE SEQUENCE IncremCommercial
    START WITH 1  
    INCREMENT BY 1 ; 


REM INSERTION dans la table Secteur

INSERT INTO Secteur (Id_Secteur,Nom_Secteur,NbRepresentant) VALUES (IncremSecteur.nextval ,'alimentaire',2);
INSERT INTO Secteur (Id_Secteur,Nom_Secteur,NbRepresentant) VALUES (IncremSecteur.nextval,'numérique',3);
INSERT INTO Secteur (Id_Secteur,Nom_Secteur,NbRepresentant) VALUES (IncremSecteur.nextval,'cosmétique',3);


REM INSERTION dans la table Promotion

INSERT INTO Promotion (Id_Prom,Intitule_Prom,NbreAnnonceur,MontantTotal) VALUES (IncremPromotion.nextval,'produit naturel 20%',2,25);
INSERT INTO Promotion (Id_Prom,Intitule_Prom,NbreAnnonceur,MontantTotal) VALUES (IncremPromotion.nextval,'super promo',2,70);
INSERT INTO Promotion (Id_Prom,Intitule_Prom,NbreAnnonceur,MontantTotal) VALUES (IncremPromotion.nextval,'serie spéciale',2,299);
INSERT INTO Promotion (Id_Prom,Intitule_Prom,NbreAnnonceur,MontantTotal) VALUES (IncremPromotion.nextval,'2ème à 30%',3,15);
INSERT INTO Promotion (Id_Prom,Intitule_Prom,NbreAnnonceur,MontantTotal) VALUES (IncremPromotion.nextval,'2 packs achetés le 3ème offert',4,7);
INSERT INTO Promotion (Id_Prom,Intitule_Prom,NbreAnnonceur,MontantTotal) VALUES (IncremPromotion.nextval,'produit bio',4,8);


REM INSERTION dans la table Offre

INSERT INTO Offre (Id_Offre,Nom_Offre,Id_Prom) VALUES (IncremOffre.nextval,'crème',1);
INSERT INTO Offre (Id_Offre,Nom_Offre,Id_Prom) VALUES (IncremOffre.nextval,'clavier',2);
INSERT INTO Offre (Id_Offre,Nom_Offre,Id_Prom) VALUES (IncremOffre.nextval,'ordinateur',3);
INSERT INTO Offre (Id_Offre,Nom_Offre,Id_Prom) VALUES (IncremOffre.nextval,'tomates',5);
INSERT INTO Offre (Id_Offre,Nom_Offre,Id_Prom) VALUES (IncremOffre.nextval,'patates',6);
INSERT INTO Offre (Id_Offre,Nom_Offre,Id_Prom) VALUES (IncremOffre.nextval,'orange',6);
INSERT INTO Offre (Id_Offre,Nom_Offre,Id_Prom) VALUES (IncremOffre.nextval,'huile',5);
INSERT INTO Offre (Id_Offre,Nom_Offre,Id_Prom) VALUES (IncremOffre.nextval,'shampoo',1);
INSERT INTO Offre (Id_Offre,Nom_Offre,Id_Prom) VALUES (IncremOffre.nextval,'chaussette',1);


REM INSERTION dans la table Commercial

INSERT INTO Commercial (Id_Com,Nom_Com,Prenom_Com,Localisation_Com,Email_Com,Tel_Com,Id_Secteur) VALUES (IncremCommercial.nextval,'BRIEND','CESAR','12 Rue des Champs Elysée','cesar.b@gmail.com',0658763453,1);
INSERT INTO Commercial (Id_Com,Nom_Com,Prenom_Com,Localisation_Com,Email_Com,Tel_Com,Id_Secteur) VALUES (IncremCommercial.nextval,'FEHM','CHARLES','89 Rue Alsace','charles.F@gmail.com',0658537453,1);
INSERT INTO Commercial (Id_Com,Nom_Com,Prenom_Com,Localisation_Com,Email_Com,Tel_Com,Id_Secteur) VALUES (IncremCommercial.nextval,'GARCIA','LUIS','46 avenue des pres','luis.garcia@hotmail.fr',0667654573,2);
INSERT INTO Commercial (Id_Com,Nom_Com,Prenom_Com,Localisation_Com,Email_Com,Tel_Com,Id_Secteur) VALUES (IncremCommercial.nextval,'ROCHIER','MARIE','15 Rue du Présent Wilson','marie.rochier@outlool.fr',0637459256,2);
INSERT INTO Commercial (Id_Com,Nom_Com,Prenom_Com,Localisation_Com,Email_Com,Tel_Com,Id_Secteur) VALUES (IncremCommercial.nextval,'LEMOINE','AGATHE','48 Rue Edouard Vaillant','agathe.lemoine@yahoo.com',0634598625,3);


REM INSERTION dans la table Sponsoriser

INSERT INTO Sponsoriser (Id_Offre,Id_Com,Accorder)VALUES (1,3,'o');
INSERT INTO Sponsoriser (Id_Offre,Id_Com,Accorder)VALUES (2,3,'o');
INSERT INTO Sponsoriser (Id_Offre,Id_Com,Accorder)VALUES (3,3,'n');
INSERT INTO Sponsoriser (Id_Offre,Id_Com,Accorder)VALUES (4,1,'o');
INSERT INTO Sponsoriser (Id_Offre,Id_Com,Accorder)VALUES (5,1,'o');
INSERT INTO Sponsoriser (Id_Offre,Id_Com,Accorder)VALUES (6,5,'o');
INSERT INTO Sponsoriser (Id_Offre,Id_Com,Accorder)VALUES (1,4,'o');
INSERT INTO Sponsoriser (Id_Offre,Id_Com,Accorder)VALUES (1,2,'o');
INSERT INTO Sponsoriser (Id_Offre,Id_Com,Accorder)VALUES (1,5,'n');
INSERT INTO Sponsoriser (Id_Offre,Id_Com,Accorder)VALUES (8,1,'o');
INSERT INTO Sponsoriser (Id_Offre,Id_Com,Accorder)VALUES (9,2,'o');
INSERT INTO Sponsoriser (Id_Offre,Id_Com,Accorder)VALUES (5,3,'o');


REM INSERTION dans la table Annoncer

INSERT INTO Annoncer (Id_Prom,Id_Com,DateAnnonce) VALUES (1,1,'09/03/2021');
INSERT INTO Annoncer (Id_Prom,Id_Com,DateAnnonce) VALUES (1,2,'12/04/2021');
INSERT INTO Annoncer (Id_Prom,Id_Com,DateAnnonce) VALUES (2,2,'26/10/2021');
INSERT INTO Annoncer (Id_Prom,Id_Com,DateAnnonce) VALUES (3,3,'12/06/2021');
INSERT INTO Annoncer (Id_Prom,Id_Com,DateAnnonce) VALUES (4,5,'03/11/2021');

COMMIT;

