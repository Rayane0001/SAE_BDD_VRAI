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






	SELECT
        f.filiere_formation,
        SUM(i.eff_tot_candi_femmes) AS total_candidatures_femmes
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
        total_candidatures_femmes DESC
    LIMIT 10; -- Pour les filières les plus demandées par les femmes
