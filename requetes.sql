-- Définir le schéma de recherche
SET search_path TO stat_parcoursup;

-- 1. Nombre de candidats classés par chaque établissement
-- Cette requête agrège le nombre total de candidats pour chaque établissement.
-- Les résultats sont regroupés par le nom de l'établissement et affichent le total des candidats par établissement.
SELECT nom_etab, SUM(eff_tot_candi_form) AS "Nombre candidats"
FROM Infos_Formation_Etablissement
INNER JOIN Etablissement
ON Infos_Formation_Etablissement.code_uai_etab = Etablissement.code_uai_etab
GROUP BY Etablissement.code_uai_etab;

-- 2. Établissements classant plus de néo-bacheliers professionnels que généraux
-- Cette requête identifie les établissements qui ont admis plus de néo-bacheliers professionnels que de généraux.
-- Les résultats sont triés par ordre alphabétique des noms d'établissements.
SELECT Etablissement.*
FROM Etablissement
INNER JOIN Infos_Formation_Etablissement
ON Infos_Formation_Etablissement.code_uai_etab = Etablissement.code_uai_etab
GROUP BY Etablissement.code_uai_etab
HAVING SUM(eff_admis_neo_bac_pro) > SUM(eff_admis_neo_bac_gene)
ORDER BY nom_etab;

-- 3. Formations avec plus de candidatures de bacheliers technologiques que généraux
-- Cette requête sélectionne les formations qui ont reçu plus de candidatures de bacheliers technologiques que de bacheliers généraux.
SELECT code_uai_etab, id_formation
FROM Infos_Formation_Etablissement
GROUP BY code_uai_etab, id_formation
HAVING SUM(eff_tot_candi_neo_bac_tech_phase_ppl_form) > SUM(eff_tot_candi_boursier_neo_bac_gene_phase_ppl_form);

-- 4. Académies avec le nombre d'établissements par académie
-- Cette requête compte le nombre d'établissements dans chaque académie.
-- Les résultats sont triés par ordre décroissant du nombre d'établissements.
SELECT nom_academie, COUNT(code_uai_etab) AS "Nombre d'établissement"
FROM Academie
INNER JOIN Etablissement
ON Etablissement.id_academie = Academie.id_academie
GROUP BY nom_academie
ORDER BY COUNT(code_uai_etab) DESC;

-- 5. Établissements proposant plus de formations sélectives que non sélectives
-- Cette requête identifie les établissements qui offrent plus de formations sélectives que non sélectives.
SELECT E.nom_etab, E.code_uai_etab
FROM Etablissement E
JOIN Infos_Formation_Etablissement IFE ON E.code_uai_etab = IFE.code_uai_etab
JOIN Formation F ON IFE.id_formation = F.id_formation
GROUP BY E.nom_etab, E.code_uai_etab
HAVING (
    SELECT COUNT(*)
    FROM Infos_Formation_Etablissement IFE2
    INNER JOIN Formation F2 ON IFE2.id_formation = F2.id_formation
    WHERE IFE2.code_uai_etab = E.code_uai_etab AND F2.selectivite = 'formation sélective'
) > (
    SELECT COUNT(*)
    FROM Infos_Formation_Etablissement IFE3
    INNER JOIN Formation F3 ON IFE3.id_formation = F3.id_formation
    WHERE IFE3.code_uai_etab = E.code_uai_etab AND F3.selectivite = 'formation non sélective'
);

-- 6. Formations proposées dans le Pas-de-Calais
-- Cette requête répertorie les formations proposées dans les établissements situés dans le département du Pas-de-Calais.
SELECT Formation.*
FROM Formation
INNER JOIN Infos_Formation_Etablissement IFE
ON IFE.id_formation = Formation.id_formation
INNER JOIN Etablissement
ON Etablissement.code_uai_etab = IFE.code_uai_etab
INNER JOIN Departement
ON Departement.code_dept = Etablissement.code_dept
WHERE nom_dept = 'Pas-de-Calais';

-- 7. Établissements sans aucune formation sélective
-- Cette requête identifie les établissements qui ne proposent aucune formation sélective.
SELECT Etablissement.*
FROM Etablissement
INNER JOIN Infos_Formation_Etablissement IFE
ON IFE.code_uai_etab = Etablissement.code_uai_etab
INNER JOIN Formation
ON Formation.id_formation = IFE.id_formation
WHERE Etablissement.code_uai_etab NOT IN (
    SELECT code_uai_etab
    FROM Infos_Formation_Etablissement IFE2
    INNER JOIN Formation F2 ON F2.id_formation = IFE2.id_formation
    WHERE F2.selectivite = 'formation sélective'
);

-- 8. Académies avec le nombre de candidats par académie
-- Cette requête calcule le nombre total de candidats pour chaque académie.
SELECT academie.*, SUM(eff_tot_candi_form) AS "Nb candidats"
FROM academie
NATURAL JOIN Etablissement
NATURAL JOIN Infos_Formation_Etablissement
GROUP BY academie.id_academie;

-- 9. Régions avec le nombre d'admis par région
-- Cette requête calcule le nombre total d'admis pour chaque région.
SELECT Region.*, SUM(eff_tot_admis_etab) AS "Nombre d'admis dans la région"
FROM Region
NATURAL JOIN Departement
NATURAL JOIN Etablissement
NATURAL JOIN Infos_Formation_Etablissement
GROUP BY Region.id_region;

-- 10. Départements avec plus de 20 établissements
-- Cette requête identifie les départements comptant plus de 20 établissements.
SELECT Departement.*
FROM Departement
NATURAL JOIN Etablissement
GROUP BY Departement.code_dept
HAVING COUNT(Etablissement.code_uai_etab) > 20;

-- 11. Formations ayant admis plus de mentions Très Bien que Bien et plus de mentions Bien qu'Assez Bien
-- Cette requête liste les formations qui ont admis plus de bacheliers avec mention Très Bien (TB) que de bacheliers avec mention Bien (B), et plus de bacheliers avec mention Bien que de bacheliers avec mention Assez Bien (AB).
SELECT Formation.*
FROM Formation
NATURAL JOIN Infos_Formation_Etablissement IFE
WHERE IFE.eff_admis_neo_bac_TB > IFE.eff_admis_neo_bac_B AND IFE.eff_admis_neo_bac_B > IFE.eff_admis_neo_bac_AB;