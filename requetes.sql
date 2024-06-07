SET search_path TO stat_parcoursup;

--1. Le nombre de candidats classés par chaque établissement
SELECT nom_etab,SUM(eff_tot_candi_form) AS "Nombre candidats"
FROM Infos_Formation_Etablissement
INNER JOIN Etablissement
ON Infos_Formation_Etablissement.code_uai_etab = Etablissement.code_uai_etab
GROUP BY Etablissement.code_uai_etab;

--2. La liste des établissements qui ont classé plus de néo bacheliers professionnels que généraux. L’affichage doit être dans l’ordre alphabétique des noms d’établissements.
SELECT Etablissement.*
FROM Etablissement
INNER JOIN Infos_Formation_Etablissement
ON Infos_Formation_Etablissement.code_uai_etab = Etablissement.code_uai_etab
GROUP BY Etablissement.code_uai_etab
HAVING SUM(eff_admis_neo_bac_pro) > SUM(eff_admis_neo_bac_gene)
ORDER BY nom_etab;

--3. La liste des formations qui ont reçu plus de candidatures de bacheliers technologiques que généraux
SELECT code_uai_etab, id_formation
FROM Infos_Formation_Etablissement
GROUP BY code_uai_etab, id_formation
HAVING SUM(eff_tot_candi_neo_bac_tech_phase_ppl_form) > SUM(eff_tot_candi_boursier_neo_bac_gene_phase_ppl_form);

--4. La liste des académies avec le nombre d’établissements par académie. L’affichage doit être d’ont décroissant selon le nombre d’établissements
SELECT nom_academie, COUNT(code_uai_etab) AS "Nombre d'établissement"
FROM Academie
INNER JOIN Etablissement
ON Etablissement.id_academie = Academie.id_academie
GROUP BY nom_academie
ORDER BY COUNT(code_uai_etab) DESC;

--5. La liste des établissements qui proposent plus de formations sélectives que non sélectives.
SELECT E.nom_etab,E.code_uai_etab
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

--6. La liste des formations proposées dans le pas-de-calais.
SELECT Formation.*
FROM formation
INNER JOIN Infos_Formation_Etablissement IFE
ON IFE.id_formation = formation.id_formation
INNER JOIN Etablissement
ON Etablissement.code_uai_etab = IFE.code_uai_etab
INNER JOIN Departement
ON Departement.code_dept = Etablissement.code_dept
WHERE nom_dept = 'Pas-de-Calais';

--7. La liste d’établissement qui ne comptent aucune formation sélective
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

--8. La liste des académies avec le nombre de candidats par académie.
SELECT academie.*, SUM(eff_tot_candi_form) as "Nb candidats"
FROM academie
natural join Etablissement
NATURAL JOIN Infos_Formation_Etablissement
GROUP BY academie.id_academie;

--9. La liste des région avec le nombre d’admis par région
SELECT Region.*, SUM(eff_tot_admis_etab) AS "Nombre d'admis dans la région"
FROM Region
NATURAL JOIN Departement
NATURAL JOIN Etablissement
Natural JOIN Infos_Formation_Etablissement
GROUP BY Region.id_region;

--10. La liste des départements qui comptent plus de 20 établissements
SELECT Departement.*
FROM Departement
NATURAL JOIN Etablissement
GROUP BY Departement.code_dept
HAVING COUNT(Etablissement.code_uai_etab) > 20;

--11. La liste des formations qui ont admis plus de mention TB que B et plus de mention B que AB.
SELECT Formation.*
FROM Formation NATURAL JOIN Infos_Formation_Etablissement IFE
WHERE IFE.eff_admis_neo_bac_TB > IFE.eff_admis_neo_bac_B AND IFE.eff_admis_neo_bac_B > IFE.eff_admis_neo_bac_AB;

