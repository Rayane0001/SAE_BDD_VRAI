-- DEUXIÈME PARTIE
-- Calcul du nombre total de candidatures par filière de formation
SELECT F.filiere_formation, SUM(IFE.eff_tot_candi_form) AS total_candidatures
FROM Infos_Formation_Etablissement IFE
INNER JOIN Formation F ON IFE.id_formation = F.id_formation
WHERE IFE.code_uai_etab IN (
    -- On sélectionne les établissements situés en Hauts-de-France
    SELECT E.code_uai_etab
    FROM Etablissement E
    INNER JOIN Departement D ON E.code_dept = D.code_dept
    INNER JOIN Region R ON D.id_region = R.id_region
    WHERE R.nom_region = 'Hauts-de-France'
)
-- On regroupe par filière de formation et on trie par nombre de candidatures décroissant
GROUP BY F.filiere_formation
ORDER BY total_candidatures DESC;

-- Pour les filières les plus demandées par les hommes
SELECT
    f.filiere_formation,
    SUM(i.eff_candidate_form) AS total_candidatures_hommes
FROM
    Infos_Formation_Etablissement i
JOIN
    Formation f ON i.id_formation = f.id_formation
JOIN
    Etablissement e ON i.code_uai_etab = e.code_uai_etab
JOIN
    Departement d ON e.code_dept = d.code_dept
JOIN
    Region r ON d.id_region = r.id_region
WHERE
    r.nom_region = 'Hauts-de-France'
-- On regroupe par filière de formation et on trie par nombre de candidatures décroissant
GROUP BY
    f.filiere_formation
ORDER BY
    total_candidatures_hommes DESC
LIMIT 10;

-- Pour les filières les moins demandées par les hommes
SELECT
    f.filiere_formation,
    SUM(i.eff_candidate_form) AS total_candidatures_femmes
FROM
    Infos_Formation_Etablissement i
JOIN
    Formation f ON i.id_formation = f.id_formation
JOIN
    Etablissement e ON i.code_uai_etab = e.code_uai_etab
JOIN
    Departement d ON e.code_dept = d.code_dept
JOIN
    Region r ON d.id_region = r.id_region
WHERE
    r.nom_region = 'Hauts-de-France'
-- On regroupe par filière de formation et on trie par nombre de candidatures croissant
GROUP BY
    f.filiere_formation
ORDER BY
    total_candidatures_femmes ASC
LIMIT 10;

-- Candidatures par filière de formation pour les boursiers néobacheliers
SELECT F.filiere_formation, SUM(IFE.eff_tot_candi_boursier_neo_bac_gene_phase_ppl_form
                               + IFE.eff_tot_candi_boursier_neo_bac_tech_phase_ppl_form
                               + IFE.eff_tot_candi_boursier_neo_bac_pro_phase_ppl_form) AS total_candidatures_boursiers
FROM Infos_Formation_Etablissement IFE
INNER JOIN Formation F ON IFE.id_formation = F.id_formation
JOIN
    Etablissement e ON IFE.code_uai_etab = e.code_uai_etab
JOIN
    Departement d ON e.code_dept = d.code_dept
JOIN
    Region r ON d.id_region = r.id_region
WHERE
    r.nom_region = 'Hauts-de-France'
-- On regroupe par filière de formation et on trie par nombre de candidatures décroissant
GROUP BY F.filiere_formation
ORDER BY total_candidatures_boursiers DESC;

-- Candidatures par filière de formation pour les néobacheliers généraux
SELECT F.filiere_formation, SUM(IFE.eff_tot_candi_neo_bac_gene_phase_ppl_form) AS total_candidatures_gene
FROM Infos_Formation_Etablissement IFE
INNER JOIN Formation F ON IFE.id_formation = F.id_formation
JOIN
    Etablissement e ON IFE.code_uai_etab = e.code_uai_etab
JOIN
    Departement d ON e.code_dept = d.code_dept
JOIN
    Region r ON d.id_region = r.id_region
WHERE
    r.nom_region = 'Hauts-de-France'
-- On regroupe par filière de formation et on trie par nombre de candidatures décroissant
GROUP BY F.filiere_formation
ORDER BY total_candidatures_gene DESC;

-- Candidatures par filière de formation pour les néobacheliers technologiques
SELECT F.filiere_formation, SUM(IFE.eff_tot_candi_neo_bac_tech_phase_ppl_form) AS total_candidatures_tech
FROM Infos_Formation_Etablissement IFE
INNER JOIN Formation F ON IFE.id_formation = F.id_formation
JOIN
    Etablissement e ON IFE.code_uai_etab = e.code_uai_etab
JOIN
    Departement d ON e.code_dept = d.code_dept
JOIN
    Region r ON d.id_region = r.id_region
WHERE
    r.nom_region = 'Hauts-de-France'
-- On regroupe par filière de formation et on trie par nombre de candidatures décroissant
GROUP BY F.filiere_formation
ORDER BY total_candidatures_tech DESC;

-- Candidatures par filière de formation pour les néobacheliers professionnels
SELECT F.filiere_formation, SUM(IFE.eff_tot_candi_neo_bac_pro_phase_ppl_form) AS total_candidatures_pro
FROM Infos_Formation_Etablissement IFE
INNER JOIN Formation F ON IFE.id_formation = F.id_formation
JOIN
    Etablissement e ON IFE.code_uai_etab = e.code_uai_etab
JOIN
    Departement d ON e.code_dept = d.code_dept
JOIN
    Region r ON d.id_region = r.id_region
WHERE
    r.nom_region = 'Hauts-de-France'
-- On regroupe par filière de formation et on trie par nombre de candidatures décroissant
GROUP BY F.filiere_formation
ORDER BY total_candidatures_pro DESC;

-- Candidatures par filière de formation pour les candidats en réorientation
SELECT F.filiere_formation, SUM(IFE.eff_candi_reorientation) AS total_candidatures_reorientation
FROM Infos_Formation_Etablissement IFE
INNER JOIN Formation F ON IFE.id_formation = F.id_formation
JOIN
    Etablissement e ON IFE.code_uai_etab = e.code_uai_etab
JOIN
    Departement d ON e.code_dept = d.code_dept
JOIN
    Region r ON d.id_region = r.id_region
WHERE
    r.nom_region = 'Hauts-de-France'
-- On regroupe par filière de formation et on trie par nombre de candidatures décroissant
GROUP BY F.filiere_formation
ORDER BY total_candidatures_reorientation DESC;


-- TROISIÈME PARTIE
-- Requête 1 : Les filières qui attirent les meilleurs candidats
SELECT
    f.filiere_formation,
    SUM(i.eff_admis_neo_bac_TB + i.eff_admis_neo_bac_B) AS total_meilleurs_candidats
FROM
    Infos_Formation_Etablissement i
JOIN
    Formation f ON i.id_formation = f.id_formation
-- On regroupe par filière de formation et on trie par nombre de meilleurs candidats décroissant
GROUP BY
    f.filiere_formation
ORDER BY
    total_meilleurs_candidats DESC;

-- Requête 2 : Les filières qui attirent les bacheliers technologiques (néobacheliers)
SELECT
    f.filiere_formation,
    SUM(i.eff_tot_candi_neo_bac_tech_phase_ppl_form) AS total_candidatures_tech
FROM
    Infos_Formation_Etablissement i
JOIN
    Formation f ON i.id_formation = f.id_formation
-- On regroupe par filière de formation et on trie par nombre de candidatures décroissant
GROUP BY
    f.filiere_formation
ORDER BY
    total_candidatures_tech DESC;

-- Requête 3 : Les filières qui attirent les bacheliers professionnels (néobacheliers)
SELECT
    f.filiere_formation,
    SUM(i.eff_tot_candi_neo_bac_pro_phase_ppl_form) AS total_candidatures_pro
FROM
    Infos_Formation_Etablissement i
JOIN
    Formation f ON i.id_formation = f.id_formation
-- On regroupe par filière de formation et on trie par nombre de candidatures décroissant
GROUP BY
    f.filiere_formation
ORDER BY
    total_candidatures_pro DESC;

-- Partie 3.3
-- Nombre total de candidatures en informatique
WITH Informatique_formation AS (
    -- On sélectionne les formations en informatique
    SELECT id_formation
    FROM Formation
    WHERE filiere_formation ILIKE '%informatique%'
       OR filiere_formation_detail ILIKE '%informatique%'
),

Etudes_Courtes_Informatique AS (
    -- On sélectionne les informations de candidature pour ces formations
    SELECT id_info_formation, eff_tot_candi_form
    FROM
