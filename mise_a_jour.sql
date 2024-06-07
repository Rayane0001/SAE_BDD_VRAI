SET search_path TO stat_parcoursup;

CREATE TABLE stat_academies(
    nom_academie VARCHAR(100) PRIMARY KEY,
    nb_etab INT,
    nb_admis INT
);

INSERT INTO stat_academies
SELECT nom_academie, COUNT(Etablissement.*), SUM(eff_tot_candi_form)
FROM Academie
NATURAL JOIN Etablissement
NATURAL JOIN Infos_Formation_Etablissement
GROUP BY nom_academie;