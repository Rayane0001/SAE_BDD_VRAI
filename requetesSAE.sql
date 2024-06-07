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

