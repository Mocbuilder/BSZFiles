CREATE DATABASE IF NOT EXISTS FI24_DB_Mietvertrag;
USE FI24_DB_Mietvertrag;

CREATE TABLE Mieter (
    M_ID INT AUTO_INCREMENT PRIMARY KEY NOT NULL,
    Vorname VARCHAR(255) NOT NULL,
    Nachname VARCHAR(255) NOT NULL,
    GebDat DATE,
    GebOrt VARCHAR(255),
    Telefonnummer VARCHAR(50),
    Email VARCHAR(255),
    Straße VARCHAR(255),
    Hausnummer VARCHAR(20),
    PLZ VARCHAR(10),
    Stadt VARCHAR(255),
    IBAN VARCHAR(34),
    BIC VARCHAR(11),
    Bankname VARCHAR(255),
    Kontoinhaber VARCHAR(255)
);

CREATE TABLE Gebäude (
    G_ID INT AUTO_INCREMENT PRIMARY KEY NOT NULL,
    Eigentümer VARCHAR(255) DEFAULT 'Wohngenossenschaft',
    Stadt VARCHAR(255) NOT NULL,
    Straße VARCHAR(255) NOT NULL,
    H_NR VARCHAR(20) NOT NULL,
    PLZ VARCHAR(10),
    Baujahr YEAR,
    WohnungenGesamt INT,
    Beschreibung TEXT
);

CREATE TABLE Wohnungen (
    W_ID INT AUTO_INCREMENT PRIMARY KEY NOT NULL,
    G_ID INT NOT NULL,
    Etage VARCHAR(50),
    Wohnungsnummer VARCHAR(50),
    Fläche DECIMAL(10,2),
    Zimmer INT,
    Balkon BOOLEAN DEFAULT FALSE,
    MieteKalt DECIMAL(10,2),
    MieteWarm DECIMAL(10,2),
    Status ENUM('frei', 'vermietet', 'renovierung') DEFAULT 'frei',
    M_ID INT NULL,
    
    FOREIGN KEY (G_ID) REFERENCES Gebäude(G_ID)
        ON DELETE CASCADE
        ON UPDATE CASCADE,
    FOREIGN KEY (M_ID) REFERENCES Mieter(M_ID)
        ON DELETE SET NULL
        ON UPDATE CASCADE
);

CREATE TABLE Mietvertrag (
    V_ID INT AUTO_INCREMENT PRIMARY KEY NOT NULL,
    M_ID INT NOT NULL,
    G_ID INT NOT NULL,
    W_ID INT NOT NULL,
    DatumAB DATE NOT NULL,
    DatumBis DATE,
    Kaution DECIMAL(10,2) DEFAULT 0.00,
    MonatlicheMiete DECIMAL(10,2),
    NebenkostenVorauszahlung DECIMAL(10,2),
    Zahlungsintervall ENUM('monatlich', 'vierteljährlich', 'jährlich') DEFAULT 'monatlich',
    Vertragsstatus ENUM('aktiv', 'beendet', 'gekündigt') DEFAULT 'aktiv',
    Vertragsnummer VARCHAR(50),
    
    FOREIGN KEY (M_ID) REFERENCES Mieter(M_ID)
        ON DELETE CASCADE
        ON UPDATE CASCADE,
    FOREIGN KEY (G_ID) REFERENCES Gebäude(G_ID)
        ON DELETE CASCADE
        ON UPDATE CASCADE,
    FOREIGN KEY (W_ID) REFERENCES Wohnungen(W_ID)
        ON DELETE CASCADE
        ON UPDATE CASCADE
);

CREATE TABLE Zahlung (
    Z_ID INT AUTO_INCREMENT PRIMARY KEY NOT NULL,
    V_ID INT NOT NULL,
    Zahlungszweck ENUM('Miete', 'Nebenkosten', 'Kaution', 'Sonstiges') DEFAULT 'Miete',
    Zahlungsart ENUM('Überweisung', 'Bar', 'Lastschrift', 'PayPal', 'Sonstiges') DEFAULT 'Überweisung',
    Betrag DECIMAL(10,2) NOT NULL,
    Zahlungsdatum DATE NOT NULL,
    ZeitraumVon DATE,
    ZeitraumBis DATE,
    IBAN VARCHAR(34),
    BIC VARCHAR(11),
    Kontoinhaber VARCHAR(255),
    Verwendungszweck VARCHAR(255),
    Rechnungsnummer VARCHAR(50),
    Eingegangen BOOLEAN DEFAULT TRUE,
    Buchungsdatum DATE DEFAULT CURRENT_DATE,
    Kommentar VARCHAR(255),
    
    FOREIGN KEY (V_ID) REFERENCES Mietvertrag(V_ID)
        ON DELETE CASCADE
        ON UPDATE CASCADE
);

CREATE TABLE Nebenkosten (
    N_ID INT AUTO_INCREMENT PRIMARY KEY NOT NULL,
    V_ID INT NOT NULL,
    AbrechnungszeitraumVon DATE NOT NULL,
    AbrechnungszeitraumBis DATE NOT NULL,
    Heizkosten DECIMAL(10,2) DEFAULT 0.00,
    Wasserkosten DECIMAL(10,2) DEFAULT 0.00,
    Stromkosten DECIMAL(10,2) DEFAULT 0.00,
    Müllabfuhr DECIMAL(10,2) DEFAULT 0.00,
    Hausmeister DECIMAL(10,2) DEFAULT 0.00,
    Versicherung DECIMAL(10,2) DEFAULT 0.00,
    SonstigeKosten DECIMAL(10,2) DEFAULT 0.00,
    Gesamtbetrag DECIMAL(10,2) GENERATED ALWAYS AS 
        (Heizkosten + Wasserkosten + Stromkosten + Müllabfuhr + Hausmeister + Versicherung + SonstigeKosten) STORED,
    Beschreibung VARCHAR(255),
    Abrechnungsdatum DATE DEFAULT CURRENT_DATE,
    Bezahlt BOOLEAN DEFAULT FALSE,
    Zahlungsdatum DATE,
    
    FOREIGN KEY (V_ID) REFERENCES Mietvertrag(V_ID)
        ON DELETE CASCADE
        ON UPDATE CASCADE
);

-- Man kann auch einfach nur die DB droppen, aber der vollständigkeit halber schreib ichs mal so
DROP TABLE Mieter;
DROP TABLE Gebäude;
DROP TABLE Wohnungen;
DROP TABLE Mietvertrag;
DROP TABLE Zahlung;
DROP TABLE Nebenkosten;
DROP SCHEMA FI24_DB_Mietvertrag;