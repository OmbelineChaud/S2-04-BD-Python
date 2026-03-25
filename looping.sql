
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

--Règle 2 : La certification des machines (L'entretien)

CREATE OR REPLACE TRIGGER trg_verif_entretien
BEFORE INSERT OR UPDATE ON Entretien
FOR EACH ROW
DECLARE
    v_nomDignite VARCHAR2(50);
BEGIN
    SELECT d.nomDignite INTO v_nomDignite
    FROM Tenrac t
    JOIN Dignite d ON t.idDignite = d.idDignite
    WHERE t.SIRET = :NEW.SIRET 
      AND t.idGroupe = :NEW.idGroupe 
      AND t.RFID = :NEW.RFID;

    IF v_nomDignite NOT IN ('Maitre', 'Grand Chancelier', 'Grand Maitre') THEN
        RAISE_APPLICATION_ERROR(-20001, 'Règle 2 violée : La machine doit être certifiée par un Tenrac ayant au moins la dignité de Maître.');
    END IF;
EXCEPTION
    WHEN NO_DATA_FOUND THEN
        RAISE_APPLICATION_ERROR(-20002, 'Erreur : Le Tenrac est introuvable ou n''a pas de dignité assignée.');
END;
/


--Règle 1 : La Réunion a besoin d'un Chevalier/Dame


CREATE OR REPLACE TRIGGER trg_verif_reunion_chevalier
AFTER INSERT OR UPDATE ON participe
DECLARE
    v_reunions_invalides NUMBER;
BEGIN
    SELECT COUNT(*) INTO v_reunions_invalides
    FROM Reunion r
    WHERE EXISTS (SELECT 1 FROM participe p WHERE p.adresse = r.adresse AND p.dateReunion = r.dateReunion)
      AND NOT EXISTS (
        SELECT 1
        FROM participe p
        JOIN Tenrac t ON p.SIRET = t.SIRET AND p.idGroupe = t.idGroupe AND p.RFID = t.RFID
        JOIN Grade g ON t.idGrade = g.idGrade
        WHERE p.adresse = r.adresse AND p.dateReunion = r.dateReunion
          AND g.nomGrade IN ('Chevalier/Dame', 'Grand Chevalier/Haute Dame', 'Commandeur', 'Grand Croix')
    );

    IF v_reunions_invalides > 0 THEN
        RAISE_APPLICATION_ERROR(-20003, 'Règle 1 violée : Une réunion avec des participants doit comporter au moins un Chevalier ou une Dame.');
    END IF;
END;
/



--Club

CREATE OR REPLACE TRIGGER trg_xt_groupe_club
BEFORE INSERT OR UPDATE ON TenracClub
FOR EACH ROW
DECLARE
    v_count NUMBER;
BEGIN
    SELECT COUNT(*) INTO v_count 
    FROM TenracOrdre 
    WHERE idGroupe = :NEW.idGroupe_1;
    
    IF v_count > 0 THEN
        RAISE_APPLICATION_ERROR(-20004, 'Contrainte XT : Ce Groupe est déjà défini comme un TenracOrdre.');
    END IF;
END;
/




--Ordre

CREATE OR REPLACE TRIGGER trg_xt_groupe_ordre
BEFORE INSERT OR UPDATE ON TenracOrdre
FOR EACH ROW
DECLARE
    v_count NUMBER;
BEGIN
    SELECT COUNT(*) INTO v_count 
    FROM TenracClub 
    WHERE idGroupe_1 = :NEW.idGroupe;
    
    IF v_count > 0 THEN
        RAISE_APPLICATION_ERROR(-20005, 'Contrainte XT : Ce Groupe est déjà défini comme un TenracClub.');
    END IF;
END;
/

--Création des référentiels
INSERT INTO Organisme (SIRET, raison_sociale) VALUES (12345678901234, 'Ordre des Tenracs');
INSERT INTO Grade (idGrade, nomGrade) VALUES (1, 'Affilie');
INSERT INTO Grade (idGrade, nomGrade) VALUES (2, 'Chevalier/Dame');
INSERT INTO Dignite (idDignite, nomDignite) VALUES (1, 'Maitre');

-- Création des Groupes et Registres
INSERT INTO Registre (idRegistre) VALUES (100);
INSERT INTO Registre (idRegistre) VALUES (200);
INSERT INTO Groupe (idGroupe, idRegistre) VALUES (10, 100);
INSERT INTO Groupe (idGroupe, idRegistre) VALUES (20, 200);

-- Création de deux Tenracs (Un "Maître/Chevalier" et un "Simple Affilié")

INSERT INTO Tenrac (SIRET, idGroupe, RFID, nom, prenom, courriel, tel, adresse_postale, dateDeNaissance, idDignite, idGrade) 
VALUES (12345678901234, 10, 1, 'Dupont', 'Jean', 'jean@tenrac.fr', 0601020304, 75001, TO_DATE('1980-01-01', 'YYYY-MM-DD'), 1, 2);


INSERT INTO Tenrac (SIRET, idGroupe, RFID, nom, prenom, courriel, tel, adresse_postale, dateDeNaissance, idDignite, idGrade) 
VALUES (12345678901234, 10, 2, 'Martin', 'Paul', 'paul@tenrac.fr', 0605060708, 69002, TO_DATE('1995-05-15', 'YYYY-MM-DD'), NULL, 1);

-- Création du matériel et des lieux
INSERT INTO Machine (idMachine, nom, modele) VALUES (1, 'Machine à café', 'Delonghi X1');
INSERT INTO Restaurant (adresse, nom) VALUES ('10 Rue de la Paix', 'Le Grand Festin');
INSERT INTO Plat (idPlat, nom) VALUES (1, 'Pates aux truffes');
INSERT INTO Menu (idMenu, idPlat) VALUES (1, 1);
INSERT INTO Repas (idRepas, intitule, idMenu) VALUES (1, 'Dîner de Gala', 1);

-- Création de deux réunions
INSERT INTO Reunion (adresse, dateReunion, idRepas) VALUES ('10 Rue de la Paix', TO_DATE('2026-04-01', 'YYYY-MM-DD'), 1);
INSERT INTO Reunion (adresse, dateReunion, idRepas) VALUES ('10 Rue de la Paix', TO_DATE('2026-04-02', 'YYYY-MM-DD'), 1);

/*
-- TEST QUI RÉUSSIT : Le Tenrac 1 (qui est 'Maitre') fait l'entretien
INSERT INTO Entretien (idEntretien, dateE, periodicite, type, idMachine, SIRET, idGroupe, RFID) 
VALUES (1, TO_DATE('2026-03-25', 'YYYY-MM-DD'), 12, 'Révision annuelle', 1, 12345678901234, 10, 1);
-- Résultat : 1 ligne insérée.

-- TEST QUI ÉCHOUE : Le Tenrac 2 (qui n'a aucune dignité) essaie de faire l'entretien
INSERT INTO Entretien (idEntretien, dateE, periodicite, type, idMachine, SIRET, idGroupe, RFID) 
VALUES (2, TO_DATE('2026-03-26', 'YYYY-MM-DD'), 12, 'Réparation', 1, 12345678901234, 10, 2);
-- Résultat attendu : ORA-20002 ou ORA-20001 (Règle 2 violée).

*/

/*
-- TEST QUI RÉUSSIT : On définit le Groupe 10 comme un Club
INSERT INTO TenracClub (idGroupe_1, nomClub) VALUES (10, 'Le Club des Étoiles');
-- Résultat : 1 ligne insérée.

-- TEST QUI ÉCHOUE : On essaie de définir le MÊME Groupe 10 comme un Ordre
INSERT INTO TenracOrdre (idGroupe, nomOrdre) VALUES (10, 'Ordre Suprême');
-- Résultat attendu : ORA-20004 (Contrainte XT violée).
*/

/*

-- TEST QUI RÉUSSIT : On ajoute le Tenrac 1 (Chevalier) à la réunion du 1er avril
INSERT INTO participe (SIRET, idGroupe, RFID, adresse, dateReunion) 
VALUES (12345678901234, 10, 1, '10 Rue de la Paix', TO_DATE('2026-04-01', 'YYYY-MM-DD'));
-- Résultat : 1 ligne insérée (La réunion est validée car Jean Dupont est Chevalier).

-- TEST QUI ÉCHOUE : On ajoute UNIQUEMENT le Tenrac 2 (Affilié) à la réunion du 2 avril
INSERT INTO participe (SIRET, idGroupe, RFID, adresse, dateReunion) 
VALUES (12345678901234, 10, 2, '10 Rue de la Paix', TO_DATE('2026-04-02', 'YYYY-MM-DD'));
-- Résultat attendu : ORA-20003 (Règle 1 violée : La réunion n'a aucun Chevalier).
*/


