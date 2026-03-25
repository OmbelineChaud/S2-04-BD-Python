CREATE TABLE Organisme(
   SIRET NUMBER(14,0),
   raison_sociale VARCHAR2(50) NOT NULL,
   PRIMARY KEY(SIRET)
);

CREATE TABLE Plat(
   idPlat NUMBER(10),
   nom VARCHAR2(25) NOT NULL,
   PRIMARY KEY(idPlat)
);

CREATE TABLE Aliment(
   nomAliment VARCHAR2(30),
   PRIMARY KEY(nomAliment)
);

CREATE TABLE Sauce(
   nomSauce VARCHAR2(50),
   PRIMARY KEY(nomSauce)
);

CREATE TABLE Machine(
   idMachine NUMBER(10),
   nom VARCHAR2(50) NOT NULL,
   modele VARCHAR2(100) NOT NULL,
   PRIMARY KEY(idMachine)
);

CREATE TABLE Grade(
   idGrade NUMBER(1,0),
   nomGrade VARCHAR2(50) NOT NULL,
   PRIMARY KEY(idGrade),
   CONSTRAINT ch_Grade_nomGrade CHECK (nomGrade IN ('Affilie', 'Sympathisant', 'Adherent', 'Chevalier/Dame', 'Grand Chevalier/Haute Dame', 'Commandeur', 'Grand Croix'))
);

CREATE TABLE Rang(
   idRang NUMBER(1,0),
   nomRang VARCHAR2(25) NOT NULL,
   PRIMARY KEY(idRang),
   CONSTRAINT ch_Rang_nomRang CHECK (nomRang IN ('Novice', 'Compagnon'))
);

CREATE TABLE Titre(
   idTitre NUMBER(1,0),
   nomTitre VARCHAR2(50) NOT NULL,
   PRIMARY KEY(idTitre),
   CONSTRAINT ch_Titre_nomTitre CHECK (nomTitre IN ('Philanthrope', 'Protecteur', 'Honorable'))
);

CREATE TABLE Dignite(
   idDignite NUMBER(1,0),
   nomDignite VARCHAR2(50) NOT NULL,
   PRIMARY KEY(idDignite),
   CONSTRAINT ch_Dignite_nomDignite CHECK (nomDignite IN ('Maitre', 'Grand Chancelier', 'Grand Maitre'))
);

CREATE TABLE Legume(
   nomAliment VARCHAR2(30),
   PRIMARY KEY(nomAliment),
   FOREIGN KEY(nomAliment) REFERENCES Aliment(nomAliment)
);

CREATE TABLE Croyances(
   nomCroyance VARCHAR2(25),
   nomAliment VARCHAR2(30) NOT NULL,
   PRIMARY KEY(nomCroyance),
   FOREIGN KEY(nomAliment) REFERENCES Legume(nomAliment)
);

CREATE TABLE Allergenes(
   nomAllergie VARCHAR2(40),
   nomAliment VARCHAR2(30) NOT NULL,
   PRIMARY KEY(nomAllergie),
   FOREIGN KEY(nomAliment) REFERENCES Legume(nomAliment)
);

CREATE TABLE Boisson(
   nomBoisson VARCHAR2(50),
   type VARCHAR2(25),
   PRIMARY KEY(nomBoisson)
);

CREATE TABLE Registre(
   idRegistre NUMBER(10),
   PRIMARY KEY(idRegistre)
);

CREATE TABLE Menu(
   idMenu NUMBER(10),
   nomBoisson VARCHAR2(50),
   idPlat NUMBER(10) NOT NULL,
   PRIMARY KEY(idMenu),
   FOREIGN KEY(nomBoisson) REFERENCES Boisson(nomBoisson),
   FOREIGN KEY(idPlat) REFERENCES Plat(idPlat)
);

CREATE TABLE Restaurant(
   adresse VARCHAR2(50),
   nom VARCHAR2(50),
   PRIMARY KEY(adresse)
);

CREATE TABLE Repas(
   idRepas NUMBER(10),
   intitule VARCHAR2(50) NOT NULL,
   idMenu NUMBER(10) NOT NULL,
   PRIMARY KEY(idRepas),
   FOREIGN KEY(idMenu) REFERENCES Menu(idMenu)
);

CREATE TABLE Groupe(
   idGroupe NUMBER(10),
   idRegistre NUMBER(10) NOT NULL,
   PRIMARY KEY(idGroupe),
   UNIQUE(idRegistre),
   FOREIGN KEY(idRegistre) REFERENCES Registre(idRegistre)
);

CREATE TABLE Tenrac(
   SIRET NUMBER(14,0),
   idGroupe NUMBER(10),
   RFID NUMBER(10),
   nom VARCHAR2(25) NOT NULL,
   prenom VARCHAR2(25) NOT NULL,
   courriel VARCHAR2(50) NOT NULL,
   tel NUMBER(10,0) NOT NULL,
   adresse_postale NUMBER(5,0) NOT NULL,
   dateDeNaissance DATE NOT NULL,
   idDignite NUMBER(1,0),
   idGrade NUMBER(1,0) NOT NULL,
   idTitre NUMBER(1,0),
   idRang NUMBER(1,0),
   PRIMARY KEY(SIRET, idGroupe, RFID),
   UNIQUE(courriel),
   UNIQUE(tel),
   FOREIGN KEY(SIRET) REFERENCES Organisme(SIRET),
   FOREIGN KEY(idGroupe) REFERENCES Groupe(idGroupe),
   FOREIGN KEY(idDignite) REFERENCES Dignite(idDignite),
   FOREIGN KEY(idGrade) REFERENCES Grade(idGrade),
   FOREIGN KEY(idTitre) REFERENCES Titre(idTitre),
   FOREIGN KEY(idRang) REFERENCES Rang(idRang)
);

CREATE TABLE Reunion(
   adresse VARCHAR2(50),
   dateReunion DATE,
   idRepas NUMBER(10) NOT NULL,
   PRIMARY KEY(adresse, dateReunion),
   FOREIGN KEY(adresse) REFERENCES Restaurant(adresse),
   FOREIGN KEY(idRepas) REFERENCES Repas(idRepas)
);

CREATE TABLE Entretien(
   idEntretien NUMBER(10),
   dateE DATE NOT NULL,
   periodicite NUMBER(2,0) NOT NULL,
   type VARCHAR2(100) NOT NULL,
   idRegistre NUMBER(10),
   idMachine NUMBER(10) NOT NULL,
   SIRET NUMBER(14,0) NOT NULL,
   idGroupe NUMBER(10) NOT NULL,
   RFID NUMBER(10) NOT NULL,
   PRIMARY KEY(idEntretien),
   FOREIGN KEY(idRegistre) REFERENCES Registre(idRegistre),
   FOREIGN KEY(idMachine) REFERENCES Machine(idMachine),
   FOREIGN KEY(SIRET, idGroupe, RFID) REFERENCES Tenrac(SIRET, idGroupe, RFID)
);
CREATE OR REPLACE TRIGGER verification_entretien
  BEFORE INSERT ON Entretien
  FOR EACH ROW
  DECLARE 
    DigniteEntretien NUMBER(1,0);
  BEGIN
  SELECT T.idDignite INTO DigniteEntretien
  FROM Tenrac T
  WHERE T.SIRET = :NEW.SIRET
    AND T.idGroupe = :NEW.idGroupe
    AND T.RFID = :NEW.RFID;
  IF DigniteEntretien IS NULL THEN
    RAISE_APPLICATION_ERROR(
      -20001, 
      'un membre doit avoir une dignite pour effectuer un entretien'
    );
  END IF;
  EXCEPTION WHEN NO_DATA_FOUND THEN 
    RAISE_APPLICATION_ERROR( 
      -20002, 
      'Membre introuvable dans TENRAC'
    );
END;
/

CREATE TABLE TenracOrdre(
   idGroupe NUMBER(10),
   nomOrdre VARCHAR2(25) NOT NULL,
   PRIMARY KEY(idGroupe),
   FOREIGN KEY(idGroupe) REFERENCES Groupe(idGroupe)
);

CREATE TABLE Avis(
   adresse VARCHAR2(50),
   SIRET NUMBER(14,0),
   idGroupe NUMBER(10),
   RFID NUMBER(10),
   note NUMBER(5,0) NOT NULL,
   commentaire VARCHAR2(100),
   dateNotation DATE NOT NULL,
   PRIMARY KEY(adresse, SIRET, idGroupe, RFID),
   FOREIGN KEY(adresse) REFERENCES Restaurant(adresse),
   FOREIGN KEY(SIRET, idGroupe, RFID) REFERENCES Tenrac(SIRET, idGroupe, RFID)
);

CREATE TABLE TenracClub(
   idGroupe_1 NUMBER(10),
   nomClub VARCHAR2(25) NOT NULL,
   idGroupe NUMBER(10),
   PRIMARY KEY(idGroupe_1),
   FOREIGN KEY(idGroupe_1) REFERENCES Groupe(idGroupe),
   FOREIGN KEY(idGroupe) REFERENCES TenracOrdre(idGroupe)
);

CREATE TABLE participe(
   SIRET NUMBER(14,0),
   idGroupe NUMBER(10),
   RFID NUMBER(10),
   adresse VARCHAR2(50),
   dateReunion DATE,
   PRIMARY KEY(SIRET, idGroupe, RFID, adresse, dateReunion),
   FOREIGN KEY(SIRET, idGroupe, RFID) REFERENCES Tenrac(SIRET, idGroupe, RFID),
   FOREIGN KEY(adresse, dateReunion) REFERENCES Reunion(adresse, dateReunion)
);

CREATE TABLE plat_constitue_de(
   idPlat NUMBER(10),
   nomAliment VARCHAR2(30),
   PRIMARY KEY(idPlat, nomAliment),
   FOREIGN KEY(idPlat) REFERENCES Plat(idPlat),
   FOREIGN KEY(nomAliment) REFERENCES Aliment(nomAliment)
);

CREATE TABLE utilise(
   idRepas NUMBER(10),
   idMachine NUMBER(10),
   PRIMARY KEY(idRepas, idMachine),
   FOREIGN KEY(idRepas) REFERENCES Repas(idRepas),
   FOREIGN KEY(idMachine) REFERENCES Machine(idMachine)
);

CREATE TABLE crois(
   SIRET NUMBER(14,0),
   idGroupe NUMBER(10),
   RFID NUMBER(10),
   nomCroyance VARCHAR2(25),
   PRIMARY KEY(SIRET, idGroupe, RFID, nomCroyance),
   FOREIGN KEY(SIRET, idGroupe, RFID) REFERENCES Tenrac(SIRET, idGroupe, RFID),
   FOREIGN KEY(nomCroyance) REFERENCES Croyances(nomCroyance)
);

CREATE TABLE allergique_a(
   SIRET NUMBER(14,0),
   idGroupe NUMBER(10),
   RFID NUMBER(10),
   nomAllergie VARCHAR2(40),
   PRIMARY KEY(SIRET, idGroupe, RFID, nomAllergie),
   FOREIGN KEY(SIRET, idGroupe, RFID) REFERENCES Tenrac(SIRET, idGroupe, RFID),
   FOREIGN KEY(nomAllergie) REFERENCES Allergenes(nomAllergie)
);

CREATE TABLE sauce_constitue_de(
   nomAliment VARCHAR2(30),
   nomSauce VARCHAR2(50),
   PRIMARY KEY(nomAliment, nomSauce),
   FOREIGN KEY(nomAliment) REFERENCES Aliment(nomAliment),
   FOREIGN KEY(nomSauce) REFERENCES Sauce(nomSauce)
);

CREATE TABLE est_sauce(
   nomSauce VARCHAR2(50),
   idMenu NUMBER(10),
   PRIMARY KEY(nomSauce, idMenu),
   FOREIGN KEY(nomSauce) REFERENCES Sauce(nomSauce),
   FOREIGN KEY(idMenu) REFERENCES Menu(idMenu)
);

INSERT INTO Grade(idGrade,nomGrade)VALUES (1,'Affilie');
INSERT INTO Rang(idRang,nomRang) VALUES (1,'Novice');
INSERT INTO Titre(idTitre,nomTitre) VALUES (1,'Philanthrope');
INSERT INTO Dignite(idDignite,nomDignite) VALUES (1,NULL);--'Maitre'
INSERT INTO Tenrac(SIRET,idGroupe,RFID,nom,prenom,courriel,tel,adresse_postale,dateDeNaissance,idDignite,idGrade,idTitre,idRang)
VALUES (1,1,1,'Bob','Boben','Bob@gmail.com',123456789,2500,
TO_DATE('01-01-2001','DD-MM-YYYY'),NULL,1,1,1);
INSERT INTO Entretien(idEntretien,dateE,periodicite,type,idRegistre,idMachine,SIRET,idGroupe,RFID) 
  VALUES (1,TO_DATE('01-01-2021','DD-MM-YYYY'), 1,'CAFE',1,1,1,1,1);
  
  
  
  
