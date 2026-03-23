#MLD

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

CREATE TABLE Machine(a
   idMachine NUMBER(10),
   nom VARCHAR2(50) NOT NULL,
   modele VARCHAR2(100) NOT NULL,
   PRIMARY KEY(idMachine)
);

CREATE TABLE Grade(
   nomGrade VARCHAR2(50),
   PRIMARY KEY(nomGrade)
);

CREATE TABLE Rang(
   nomRang VARCHAR2(25),
   PRIMARY KEY(nomRang)
);

CREATE TABLE Titre(
   nomTitre VARCHAR2(50),
   PRIMARY KEY(nomTitre)
);

CREATE TABLE Dignite(
   nomDignite VARCHAR2(50),
   PRIMARY KEY(nomDignite)
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
   nomDignite VARCHAR2(50),
   nomGrade VARCHAR2(50) NOT NULL,
   nomTitre VARCHAR2(50),
   nomRang VARCHAR2(25),
   PRIMARY KEY(SIRET, idGroupe, RFID),
   UNIQUE(courriel),
   UNIQUE(tel),
   FOREIGN KEY(SIRET) REFERENCES Organisme(SIRET),
   FOREIGN KEY(idGroupe) REFERENCES Groupe(idGroupe),
   FOREIGN KEY(nomDignite) REFERENCES Dignite(nomDignite),
   FOREIGN KEY(nomGrade) REFERENCES Grade(nomGrade),
   FOREIGN KEY(nomTitre) REFERENCES Titre(nomTitre),
   FOREIGN KEY(nomRang) REFERENCES Rang(nomRang)
);

CREATE TABLE Reunion(
   dateReunion TIMESTAMP WITH TIME ZONE,
   adresse VARCHAR2(50),
   SIRET NUMBER(14,0) NOT NULL,
   idGroupe NUMBER(10) NOT NULL,
   RFID NUMBER(10) NOT NULL,
   idRepas NUMBER(10) NOT NULL,
   PRIMARY KEY(dateReunion),
   FOREIGN KEY(adresse) REFERENCES Restaurant(adresse),
   FOREIGN KEY(SIRET, idGroupe, RFID) REFERENCES Tenrac(SIRET, idGroupe, RFID),
   FOREIGN KEY(idRepas) REFERENCES Repas(idRepas)
);

CREATE TABLE Entretien(
   idEntretien NUMBER(10),
   dateE TIMESTAMP NOT NULL,
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

CREATE TABLE TenracOrdre(
   idGroupe NUMBER(10),
   PRIMARY KEY(idGroupe),
   FOREIGN KEY(idGroupe) REFERENCES Groupe(idGroupe)
);

CREATE TABLE Avis(
   idNotation NUMBER(10),
   note NUMBER(5,0) NOT NULL,
   commentaire VARCHAR2(100),
   dateNotation TIMESTAMP NOT NULL,
   adresse VARCHAR2(50),
   SIRET NUMBER(14,0) NOT NULL,
   idGroupe NUMBER(10) NOT NULL,
   RFID NUMBER(10) NOT NULL,
   PRIMARY KEY(idNotation),
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
