DROP SCHEMA IF EXISTS stat_parcoursup CASCADE;
CREATE SCHEMA stat_parcoursup;
SET search_path TO stat_parcoursup;

CREATE TABLE Academie(
   id_academie SERIAL,
   nom_academie VARCHAR(300) NOT NULL,
   PRIMARY KEY(id_academie)
);

CREATE TABLE Region(
   id_region SERIAL,
   nom_region VARCHAR(300) NOT NULL,
   PRIMARY KEY(id_region)
);

CREATE TABLE Formation(
   id_formation SERIAL,
   filiere_formation_agregation VARCHAR(300) NOT NULL,
   filiere_formation VARCHAR(300) NOT NULL,
   filiere_formation_detail VARCHAR(300) NOT NULL,
   selectivite VARCHAR(300),
   PRIMARY KEY(id_formation)
);

CREATE TABLE Departement(
   code_dept VARCHAR(3),
   nom_dept VARCHAR(300) NOT NULL,
   id_region INT NOT NULL,
   PRIMARY KEY(code_dept),
   FOREIGN KEY(id_region) REFERENCES Region(id_region)
   ON DELETE RESTRICT ON UPDATE CASCADE
);

/*CREATE TABLE Commune(
   id_commune SERIAL,
   nom_commune VARCHAR(300) NOT NULL,
   code_dept VARCHAR(3) NOT NULL,
   PRIMARY KEY(id_commune),
   FOREIGN KEY(code_dept) REFERENCES Departement(code_dept)
   ON DELETE RESTRICT ON UPDATE CASCADE
);*/

CREATE TABLE Etablissement (
   code_uai_etab VARCHAR(300),
   nom_etab VARCHAR(300) NOT NULL,
   id_academie INT NOT NULL,
   --id_commune INT NOT NULL,
   code_dept VARCHAR(300) NOT NULL,
   PRIMARY KEY(code_uai_etab),
   FOREIGN KEY(id_academie) REFERENCES Academie(id_academie) ON DELETE CASCADE ON UPDATE CASCADE,
   --FOREIGN KEY(id_commune) REFERENCES Commune(id_commune) ON DELETE CASCADE ON UPDATE CASCADE
   FOREIGN KEY(code_dept) REFERENCES Departement(code_dept) ON DELETE CASCADE ON UPDATE CASCADE
);

CREATE TABLE Infos_Formation_Etablissement(
   id_info_formation SERIAL,
   code_uai_etab VARCHAR(300),
   id_formation INT,
   capacite_par_form INT,
   eff_tot_candi_form INT,
   eff_candidate_form INT,
   eff_tot_candi_phase_ppl_form INT,
   eff_tot_candi_neo_bac_gene_phase_ppl_form INT,
   eff_tot_candi_boursier_neo_bac_gene_phase_ppl_form INT,
   eff_tot_candi_neo_bac_tech_phase_ppl_form INT,
   eff_tot_candi_boursier_neo_bac_tech_phase_ppl_form INT,
   eff_tot_candi_neo_bac_pro_phase_ppl_form INT,
   eff_tot_candi_boursier_neo_bac_pro_phase_ppl_form INT,
   eff_tot_candi_boursier_autre_phase_ppl_form INT,
   eff_tot_classes_etab_phase_principale INT,
   eff_tot_candi_neo_bac_gene_classes_etab INT,
   eff_tot_candi_boursier_neo_bac_gene_classes_etab INT,
   eff_candi_neo_bac_tech_classes_etab INT,
   eff_candi_boursier_neo_bac_tech_classes_etab INT,
   eff_candi_neo_bac_pro_classes_etab INT,
   eff_candi_boursier_neo_bac_pro_classes_etab INT,
   eff_candi_autre_classe_par_etab INT,
   eff_candi_autre_ayant_recu_prop_classe_par_etab INT,
   eff_tot_admis_etab INT,
   eff_candidates_admises INT,
   eff_admis_phase_principale INT,
   eff_admis_neo_bac INT,
   eff_admis_neo_bac_gene INT,
   eff_admis_neo_bac_tech INT,
   eff_admis_neo_bac_pro INT,
   eff_autres_admis INT,
   eff_admis_neo_bac_sans_mention INT,
   eff_admis_neo_bac_AB INT,
   eff_admis_neo_bac_B INT,
   eff_admis_neo_bac_TB INT,
   eff_admis_neo_bac_TB_feli INT,
   eff_admis_neo_bac_gene_mention INT,
   eff_admis_neo_bac_tech_mention INT,
   eff_admis_neo_bac_pro_mention INT,
   statut_etab VARCHAR(300) NOT NULL,
   PRIMARY KEY(id_info_formation),
   FOREIGN KEY(code_uai_etab) REFERENCES Etablissement(code_uai_etab) ON UPDATE CASCADE,
   FOREIGN KEY(id_formation) REFERENCES Formation(id_formation) ON UPDATE CASCADE,
   CHECK(capacite_par_form>=0),
   CHECK(eff_candidate_form>=0),
   CHECK(eff_tot_candi_phase_ppl_form>=0),
   CHECK(eff_tot_candi_form>=0),
   CHECK(eff_tot_candi_neo_bac_gene_phase_ppl_form>=0),
   CHECK(eff_tot_candi_boursier_neo_bac_gene_phase_ppl_form>=0),
   CHECK(eff_tot_candi_neo_bac_tech_phase_ppl_form>=0),
   CHECK(eff_tot_candi_boursier_neo_bac_tech_phase_ppl_form>=0),
   CHECK(eff_tot_candi_neo_bac_pro_phase_ppl_form>=0),
   CHECK(eff_tot_candi_boursier_neo_bac_pro_phase_ppl_form>=0),
   CHECK(eff_tot_candi_boursier_autre_phase_ppl_form>=0),
   CHECK(eff_tot_classes_etab_phase_principale>=0),
   CHECK(eff_tot_candi_neo_bac_gene_classes_etab>=0),
   CHECK(eff_tot_candi_boursier_neo_bac_gene_classes_etab>=0),
   CHECK(eff_candi_neo_bac_tech_classes_etab>=0),
   CHECK(eff_candi_boursier_neo_bac_tech_classes_etab>=0),
   CHECK(eff_candi_neo_bac_pro_classes_etab>=0),
   CHECK(eff_candi_boursier_neo_bac_pro_classes_etab>=0),
   CHECK(eff_candi_autre_classe_par_etab>=0),
   CHECK(eff_candi_autre_ayant_recu_prop_classe_par_etab>=0),
   CHECK(eff_tot_admis_etab>=0),
   CHECK(eff_candidates_admises>=0),
   CHECK(eff_admis_phase_principale>=0),
   CHECK(eff_admis_neo_bac>=0),
   CHECK(eff_admis_neo_bac_gene>=0),
   CHECK(eff_admis_neo_bac_tech>=0),
   CHECK(eff_admis_neo_bac_pro>=0),
   CHECK(eff_autres_admis>=0),
   CHECK(eff_admis_neo_bac_sans_mention>=0),
   CHECK(eff_admis_neo_bac_AB>=0),
   CHECK(eff_admis_neo_bac_B>=0),
   CHECK(eff_admis_neo_bac_TB>=0),
   CHECK(eff_admis_neo_bac_TB_feli>=0),
   CHECK(eff_admis_neo_bac_gene_mention>=0),
   CHECK(eff_admis_neo_bac_tech_mention>=0),
   CHECK(eff_admis_neo_bac_pro_mention>=0),
   CHECK(statut_etab='Public' OR statut_etab='Privé hors contrat' OR statut_etab='Privé sous contrat d''association' OR statut_etab='Privé enseignement supérieur')
);

create table donnees_S204_05(
   statut_etab VARCHAR(300) NOT NULL,
   code_uai_etab VARCHAR(300),
   nom_etab VARCHAR(300) NOT NULL,
   code_dept VARCHAR(3),
   nom_dept VARCHAR(300) NOT NULL,
   nom_region VARCHAR(300) NOT NULL,
   nom_academie VARCHAR(300) NOT NULL,
   nom_commune VARCHAR(300) NOT NULL,
   selectivite VARCHAR(300),
   filiere_formation_agregation VARCHAR(300) NOT NULL,
   filiere_formation VARCHAR(300) NOT NULL,
   filiere_formation_detail VARCHAR(300) NOT NULL,
   capacite_par_form INT,
   eff_candidate_form INT,
   eff_tot_candi_phase_ppl_form INT,
   eff_tot_candi_form INT,
   eff_tot_candi_neo_bac_gene_phase_ppl_form INT,
   eff_tot_candi_boursier_neo_bac_gene_phase_ppl_form INT,
   eff_tot_candi_neo_bac_tech_phase_ppl_form INT,
   eff_tot_candi_boursier_neo_bac_tech_phase_ppl_form INT,
   eff_tot_candi_neo_bac_pro_phase_ppl_form INT,
   eff_tot_candi_boursier_neo_bac_pro_phase_ppl_form INT,
   eff_tot_candi_boursier_autre_phase_ppl_form INT,
   eff_tot_classes_etab_phase_principale INT,
   eff_tot_candi_neo_bac_gene_classes_etab INT,
   eff_tot_candi_boursier_neo_bac_gene_classes_etab INT,
   eff_candi_neo_bac_tech_classes_etab INT,
   eff_candi_boursier_neo_bac_tech_classes_etab INT,
   eff_candi_neo_bac_pro_classes_etab INT,
   eff_candi_boursier_neo_bac_pro_classes_etab INT,
   eff_candi_autre_classe_par_etab INT,
   eff_candi_autre_ayant_recu_prop_classe_par_etab INT,
   eff_tot_admis_etab INT,
   eff_candidates_admises INT,
   eff_admis_phase_principale INT,
   eff_admis_neo_bac INT,
   eff_admis_neo_bac_gene INT,
   eff_admis_neo_bac_tech INT,
   eff_admis_neo_bac_pro INT,
   eff_autres_admis INT,
   eff_admis_neo_bac_sans_mention INT,
   eff_admis_neo_bac_AB INT,
   eff_admis_neo_bac_B INT,
   eff_admis_neo_bac_TB INT,
   eff_admis_neo_bac_TB_feli INT,
   eff_admis_neo_bac_gene_mention INT,
   eff_admis_neo_bac_tech_mention INT,
   eff_admis_neo_bac_pro_mention INT
);
