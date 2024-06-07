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
