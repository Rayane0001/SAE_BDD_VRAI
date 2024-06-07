SET search_path TO stat_parcoursup;

--1. Ecrire la fonction plus_de_20_etablissements qui retourne les départements dans lesquels il y a plus de 20 établissements.
CREATE OR REPLACE FUNCTION plus_de_20_etablissements()
RETURNS SETOF RECORD AS
$$
    SELECT Departement.*
    FROM Departement
    NATURAL JOIN Etablissement
    GROUP BY Departement.code_dept
    HAVING COUNT(Etablissement.code_uai_etab) > 20
$$
LANGUAGE SQL;


--2. Ecrire la fonction max_professionnels qui retourne la formation qui a admis le plus de bacheliers professionnels.
CREATE OR REPLACE FUNCTION max_professionnels()
RETURNS Formation AS
$$
    SELECT Formation.*
    FROM Formation
    NATURAL JOIN Infos_Formation_Etablissement
    WHERE eff_admis_neo_bac_pro = (SELECT MAX(eff_admis_neo_bac_pro) FROM Infos_Formation_Etablissement)
$$
LANGUAGE SQL;

--3. Ecrire la fonction nb_selectives qui retourne le nombre de formations sélectives
CREATE OR REPLACE FUNCTION nb_selectives()
RETURNS INT AS
$$
    SELECT COUNT(*)::INT
    FROM Formation
    WHERE selectivite='formation sélective'
$$
LANGUAGE SQL;

--4. Ecrire la fonction nb_etablissements_dept qui retourne le nombre d’établissements dans le département passé en argument à la fonction. En utilisant la fonction nb_etablissements_dept, écrire une requête qui affiche pour chaque département son nom et son nombre d’établissements.
CREATE OR REPLACE FUNCTION nb_etablissements_dept(IN dept text)
RETURNS INT AS
$$
    SELECT COUNT(Etablissement.*)::INT
    FROM Etablissement
    NATURAL JOIN Departement
    WHERE nom_dept = dept
$$
LANGUAGE SQL;


--En utilisant la fonction nb_etablissements_dept, écrire une requête qui affiche pour chaque département son nom et son nombre d’établissements.
SELECT nom_dept,nb_etablissements_dept(nom_dept)
FROM Departement;

--5. Ecrire la fonction liste_formations qui accepte en argument l’UAI d’un établissement et retourne la liste des formations de cet établissement.
CREATE OR REPLACE FUNCTION liste_formations(IN uai TEXT)
RETURNS SETOF RECORD AS
$$
    SELECT formation.*
    FROM formation
    NATURAL JOIN Infos_Formation_Etablissement
    WHERE Infos_Formation_Etablissement.code_uai_etab = uai
$$
LANGUAGE SQL;

--6. Ecrire la fonction nb_formations_acadé mie qui accepte en argument le nom d’une académie et le type de recrutement (sélective ou non). Elle retourne le nombre de formations de ce type dans l’académie
CREATE OR REPLACE FUNCTION nb_formations_academie(IN nomAcademie TEXT, IN selectiv TEXT)
RETURNS INT AS
$$
    SELECT COUNT(formation.id_formation)::INT
    FROM formation
    NATURAL JOIN Infos_Formation_Etablissement
    NATURAL JOIN Etablissement
    NATURAL JOIN Academie
    WHERE nom_academie = nomAcademie AND formation.selectivite = selectiv
$$
LANGUAGE SQL;

--En utilisant cette fonction, écrire une requête qui affiche pour chaque académie le nombre de formations sélectives et non sélectives
SELECT nom_academie, nb_formations_academie(nom_academie,'formation sélective') AS "nb formation sélective",nb_formations_academie(nom_academie,'formation non sélective') AS "nb formation non sélective"
FROM Academie;


--7. Ecrire la fonction nombre_par_type_formation qui accepte en argument l’UAI d’un établissement et le type de formation (BTS, BUT, Licence, …). La fonction retourne le nom de l’établissement et le nombre de formations proposées du type passé en argument
CREATE OR REPLACE FUNCTION nombre_par_type_formation(IN uai TEXT, IN typeFormation TEXT)
RETURNS INT AS
$$
    SELECT COUNT(formation.id_formation)::INT
    FROM Formation
    NATURAL JOIN Infos_Formation_Etablissement
    NATURAL JOIN Etablissement
    WHERE Formation.filiere_formation_agregation = typeFormation and uai = Etablissement.code_uai_etab
$$
LANGUAGE SQL;

--En utilisant cette fonction, afficher à l’aide d’une requête le nombre de BUT proposés par chaque établissement de l’académie de Lille
SELECT Etablissement.nom_etab, nombre_par_type_formation(Etablissement.code_uai_etab,'BUT')
FROM Etablissement
NATURAL JOIN Academie
WHERE Academie.nom_academie = 'Lille';

--8. Ecrire la fonction nombre_admis_pro qui retourne le nombre de bacheliers professionnels admis dans les BUT de l’établissement passé en argument.
CREATE OR REPLACE FUNCTION nombre_admis_pro(IN uai TEXT)
RETURNs INT AS
$$
    SELECT SUM(eff_admis_neo_bac_pro)::INT
    FROM Infos_Formation_Etablissement
    NATURAL JOIN Formation
    WHERE code_uai_etab = uai AND Formation.filiere_formation_agregation = 'BUT'
$$
LANGUAGE SQL;

--En utilisant cette fonction, écrire une requête qui permet d’afficher les établissements du pas-de-calais et le nombre d’admis en BUT dans chaque établissement.
SELECT nom_etab, nombre_admis_pro(code_uai_etab)
FROM Etablissement
NATURAL JOIN Departement
WHERE nom_dept = 'Pas-de-Calais';