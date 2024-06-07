SET search_path TO stat_parcoursup;

\copy donnees_S204_05 FROM 'donnees_S204_05-juin.csv' DELIMITER ',' CSV HEADER;

insert into academie(nom_academie)
select distinct nom_academie
from donnees_S204_05
order by nom_academie;

select * from Academie;

insert into region(nom_region)
select distinct nom_region
from donnees_S204_05
order by nom_region;

select * from Region;

INSERT INTO Formation(filiere_formation_agregation, filiere_formation, filiere_formation_detail, selectivite)
SELECT filiere_formation_agregation, filiere_formation, filiere_formation_detail, selectivite
FROM donnees_S204_05
GROUP BY filiere_formation_agregation, filiere_formation, filiere_formation_detail, selectivite
order by filiere_formation_detail;

select * from Formation;

INSERT INTO Departement(code_dept, nom_dept, id_region)
SELECT code_dept, nom_dept, id_region
FROM (
    select code_dept, nom_dept, nom_region 
    from donnees_S204_05
    GROUP BY code_dept, nom_dept, nom_region
) as dept natural join Region
order by code_dept;

select * from Departement;

/*
INSERT INTO Commune(nom_commune, code_dept)
SELECT nom_commune, code_dept
from donnees_S204_05
GROUP BY nom_commune, code_dept
order by nom_commune;*/

--select * from Commune;


INSERT INTO Etablissement(code_uai_etab, nom_etab, id_academie, code_dept)
SELECT code_uai_etab, nom_etab, id_academie, code_dept
FROM (
    select code_uai_etab, nom_etab, nom_academie, nom_dept
    from donnees_S204_05
    GROUP BY code_uai_etab, nom_etab, nom_academie, nom_dept
) as etab natural join Academie natural join Departement
order by nom_etab;

select * from Etablissement;

INSERT INTO Infos_Formation_Etablissement(code_uai_etab,
                                          id_formation,
                                          capacite_par_form,
                                          eff_candidate_form,
                                          eff_tot_candi_phase_ppl_form,
                                          eff_tot_candi_form,
                                          eff_tot_candi_neo_bac_gene_phase_ppl_form,
                                          eff_tot_candi_boursier_neo_bac_gene_phase_ppl_form,
                                          eff_tot_candi_neo_bac_tech_phase_ppl_form,
                                          eff_tot_candi_boursier_neo_bac_tech_phase_ppl_form,
                                          eff_tot_candi_neo_bac_pro_phase_ppl_form,
                                          eff_tot_candi_boursier_neo_bac_pro_phase_ppl_form,
                                          eff_tot_candi_boursier_autre_phase_ppl_form,
                                          eff_tot_classes_etab_phase_principale,
                                          eff_tot_candi_neo_bac_gene_classes_etab,
                                          eff_tot_candi_boursier_neo_bac_gene_classes_etab,
                                          eff_candi_neo_bac_tech_classes_etab,
                                          eff_candi_boursier_neo_bac_tech_classes_etab,
                                          eff_candi_neo_bac_pro_classes_etab,
                                          eff_candi_boursier_neo_bac_pro_classes_etab,
                                          eff_candi_autre_classe_par_etab,
                                          eff_candi_autre_ayant_recu_prop_classe_par_etab,
                                          eff_tot_admis_etab,
                                          eff_candidates_admises,
                                          eff_admis_phase_principale,
                                          eff_admis_neo_bac,
                                          eff_admis_neo_bac_gene,
                                          eff_admis_neo_bac_tech,
                                          eff_admis_neo_bac_pro,
                                          eff_autres_admis,
                                          eff_admis_neo_bac_sans_mention,
                                          eff_admis_neo_bac_AB,
                                          eff_admis_neo_bac_B,
                                          eff_admis_neo_bac_TB,
                                          eff_admis_neo_bac_TB_feli,
                                          eff_admis_neo_bac_gene_mention,
                                          eff_admis_neo_bac_tech_mention,
                                          eff_admis_neo_bac_pro_mention,
                                          statut_etab)
SELECT  code_uai_etab,
        id_formation,
        capacite_par_form,
        eff_candidate_form,
        eff_tot_candi_phase_ppl_form,
        eff_tot_candi_form,
        eff_tot_candi_neo_bac_gene_phase_ppl_form,
        eff_tot_candi_boursier_neo_bac_gene_phase_ppl_form,
        eff_tot_candi_neo_bac_tech_phase_ppl_form,
        eff_tot_candi_boursier_neo_bac_tech_phase_ppl_form,
        eff_tot_candi_neo_bac_pro_phase_ppl_form,
        eff_tot_candi_boursier_neo_bac_pro_phase_ppl_form,
        eff_tot_candi_boursier_autre_phase_ppl_form,
        eff_tot_classes_etab_phase_principale,
        eff_tot_candi_neo_bac_gene_classes_etab,
        eff_tot_candi_boursier_neo_bac_gene_classes_etab,
        eff_candi_neo_bac_tech_classes_etab,
        eff_candi_boursier_neo_bac_tech_classes_etab,
        eff_candi_neo_bac_pro_classes_etab,
        eff_candi_boursier_neo_bac_pro_classes_etab,
        eff_candi_autre_classe_par_etab,
        eff_candi_autre_ayant_recu_prop_classe_par_etab,
        eff_tot_admis_etab,
        eff_candidates_admises,
        eff_admis_phase_principale,
        eff_admis_neo_bac,
        eff_admis_neo_bac_gene,
        eff_admis_neo_bac_tech,
        eff_admis_neo_bac_pro,
        eff_autres_admis,
        eff_admis_neo_bac_sans_mention,
        eff_admis_neo_bac_AB,
        eff_admis_neo_bac_B,
        eff_admis_neo_bac_TB,
        eff_admis_neo_bac_TB_feli,
        eff_admis_neo_bac_gene_mention,
        eff_admis_neo_bac_tech_mention,
        eff_admis_neo_bac_pro_mention,
        statut_etab
FROM (
    SELECT code_uai_etab, id_formation, capacite_par_form, eff_candidate_form, eff_tot_candi_phase_ppl_form, eff_tot_candi_form, eff_tot_candi_neo_bac_gene_phase_ppl_form, eff_tot_candi_boursier_neo_bac_gene_phase_ppl_form, eff_tot_candi_neo_bac_tech_phase_ppl_form, eff_tot_candi_boursier_neo_bac_tech_phase_ppl_form, eff_tot_candi_neo_bac_pro_phase_ppl_form, eff_tot_candi_boursier_neo_bac_pro_phase_ppl_form, eff_tot_candi_boursier_autre_phase_ppl_form, eff_tot_classes_etab_phase_principale, eff_tot_candi_neo_bac_gene_classes_etab, eff_tot_candi_boursier_neo_bac_gene_classes_etab, eff_candi_neo_bac_tech_classes_etab, eff_candi_boursier_neo_bac_tech_classes_etab, eff_candi_neo_bac_pro_classes_etab, eff_candi_boursier_neo_bac_pro_classes_etab, eff_candi_autre_classe_par_etab, eff_candi_autre_ayant_recu_prop_classe_par_etab, eff_tot_admis_etab, eff_candidates_admises, eff_admis_phase_principale, eff_admis_neo_bac, eff_admis_neo_bac_gene, eff_admis_neo_bac_tech, eff_admis_neo_bac_pro, eff_autres_admis, eff_admis_neo_bac_sans_mention, eff_admis_neo_bac_AB, eff_admis_neo_bac_B, eff_admis_neo_bac_TB, eff_admis_neo_bac_TB_feli, eff_admis_neo_bac_gene_mention, eff_admis_neo_bac_tech_mention, eff_admis_neo_bac_pro_mention, statut_etab
    FROM donnees_S204_05
    JOIN Formation ON donnees_S204_05.filiere_formation_agregation = Formation.filiere_formation_agregation 
                  AND donnees_S204_05.filiere_formation = Formation.filiere_formation 
                  AND donnees_S204_05.filiere_formation_detail = Formation.filiere_formation_detail
) AS info_form_etab;


select * from Infos_Formation_Etablissement;

