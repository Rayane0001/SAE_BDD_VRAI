-- DEUXIEME PARTIE
-- Calcul du nombre total de candidatures par filière de formation
SELECT F.filiere_formation, SUM(IFE.eff_tot_candi_form) AS total_candidatures
FROM Infos_Formation_Etablissement IFE
INNER JOIN Formation F ON IFE.id_formation = F.id_formation
WHERE IFE.code_uai_etab IN (
	SELECT E.code_uai_etab
    FROM Etablissement E
    INNER JOIN Departement D ON E.code_dept = D.code_dept
    INNER JOIN Region R ON D.id_region = R.id_region
    WHERE R.nom_region = 'Hauts-de-France'
)
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
    GROUP BY
        f.filiere_formation
    ORDER BY
        total_candidatures_hommes DESC
    LIMIT 10;

    -- Pour les filières les moins demandées par les hommes
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
    GROUP BY
        f.filiere_formation
    ORDER BY
        total_candidatures_hommes ASC
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
GROUP BY F.filiere_formation
ORDER BY total_candidatures_reorientation DESC;


--TROISIEME PARTIE
--Requête 1 : Les filières qui attirent les meilleurs candidats
SELECT
	f.filiere_formation,
	SUM(i.eff_admis_neo_bac_TB + i.eff_admis_neo_bac_B) AS total_meilleurs_candidats
FROM
	Infos_Formation_Etablissement i
JOIN
	Formation f ON i.id_formation = f.id_formation
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
GROUP BY
	f.filiere_formation
ORDER BY
	total_candidatures_pro DESC;

-- Partie 3 . 3
--  Nombre total de candidatures en informatique
WITH Etudes_Courtes_Informatique AS (
    SELECT id_info_formation, code_uai_etab, id_formation, eff_tot_candi_form
    FROM Infos_Formation_Etablissement
    WHERE id_formation IN (
        SELECT id_formation
        FROM Formation
        WHERE filiere_formation ILIKE '%informatique%'
        OR filiere_formation_detail ILIKE '%informatique%'
    )
)

SELECT
    SUM(eci.eff_tot_candi_form) AS total_candidatures
FROM
    Etudes_Courtes_Informatique eci;

-- 1. Nombre total de candidatures féminines en informatique
WITH Etudes_Courtes_Informatique AS (
    SELECT id_info_formation, eff_candidate_form
    FROM Infos_Formation_Etablissement
    WHERE id_formation IN (
        SELECT id_formation
        FROM Formation
        WHERE filiere_formation ILIKE '%informatique%'
        OR filiere_formation_detail ILIKE '%informatique%'
    )
)

SELECT
    SUM(eci.eff_candidate_form) AS total_candidatures_femmes
FROM
    Etudes_Courtes_Informatique eci;

-- 2. Nombre total de candidatures masculines en informatique
WITH Etudes_Courtes_Informatique AS (
    SELECT id_info_formation, eff_tot_candi_form, eff_candidate_form
    FROM Infos_Formation_Etablissement
    WHERE id_formation IN (
        SELECT id_formation
        FROM Formation
        WHERE filiere_formation ILIKE '%informatique%'
        OR filiere_formation_detail ILIKE '%informatique%'
    )
)

SELECT
    SUM(eci.eff_tot_candi_form * eci.eff_candidate_form / 100) AS total_candidatures_masculines_estime
FROM
    Etudes_Courtes_Informatique eci;


-- 3. Nombre total de candidatures de boursiers en informatique
WITH Etudes_Courtes_Informatique AS (
    SELECT id_info_formation,
        eff_tot_candi_boursier_neo_bac_gene_phase_ppl_form,
        eff_tot_candi_boursier_neo_bac_tech_phase_ppl_form,
        eff_tot_candi_boursier_neo_bac_pro_phase_ppl_form,
        eff_tot_candi_boursier_autre_phase_ppl_form
    FROM Infos_Formation_Etablissement
    WHERE id_formation IN (
        SELECT id_formation
        FROM Formation
        WHERE filiere_formation ILIKE '%informatique%'
        OR filiere_formation_detail ILIKE '%informatique%'
    )
)

SELECT
    SUM(eci.eff_tot_candi_boursier_neo_bac_gene_phase_ppl_form +
        eci.eff_tot_candi_boursier_neo_bac_tech_phase_ppl_form +
        eci.eff_tot_candi_boursier_neo_bac_pro_phase_ppl_form +
        eci.eff_tot_candi_boursier_autre_phase_ppl_form) AS total_candidatures_boursiers
FROM
    Etudes_Courtes_Informatique eci;
