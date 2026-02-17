# Questions et Réponses SQL

---

## 1. Introduction à SQL

**Q1: Qu'est-ce que SQL?**
> **R:** SQL (Structured Query Language) est un langage standardisé pour gérer et manipuler les bases de données relationnelles. Il permet de créer, lire, mettre à jour et supprimer des données (CRUD).

**Q2: Quels sont les types de commandes SQL?**
> **R:**
> | Catégorie | Description | Commandes |
> |-----------|-------------|-----------|
> | **DDL** (Data Definition Language) | Définition de structure | CREATE, ALTER, DROP, TRUNCATE |
> | **DML** (Data Manipulation Language) | Manipulation de données | SELECT, INSERT, UPDATE, DELETE |
> | **DCL** (Data Control Language) | Contrôle d'accès | GRANT, REVOKE |
> | **TCL** (Transaction Control Language) | Gestion des transactions | COMMIT, ROLLBACK, SAVEPOINT |

**Q3: Différence entre SQL et MySQL/PostgreSQL/Oracle?**
> **R:**
> - **SQL:** Langage standard
> - **MySQL, PostgreSQL, Oracle, SQL Server:** Systèmes de gestion de bases de données (SGBD) qui implémentent SQL avec leurs propres extensions

---

## 2. Commandes DDL (Data Definition Language)

**Q4: Comment créer une table?**
> **R:**
> ```sql
> CREATE TABLE employes (
>     id INT PRIMARY KEY AUTO_INCREMENT,
>     nom VARCHAR(50) NOT NULL,
>     prenom VARCHAR(50) NOT NULL,
>     email VARCHAR(100) UNIQUE,
>     salaire DECIMAL(10, 2) DEFAULT 0,
>     date_embauche DATE,
>     departement_id INT,
>     FOREIGN KEY (departement_id) REFERENCES departements(id)
> );
> ```

**Q5: Comment modifier une table?**
> **R:**
> ```sql
> -- Ajouter une colonne
> ALTER TABLE employes ADD telephone VARCHAR(20);
> 
> -- Modifier une colonne
> ALTER TABLE employes MODIFY telephone VARCHAR(15);
> 
> -- Renommer une colonne
> ALTER TABLE employes RENAME COLUMN telephone TO tel;
> 
> -- Supprimer une colonne
> ALTER TABLE employes DROP COLUMN tel;
> 
> -- Ajouter une contrainte
> ALTER TABLE employes ADD CONSTRAINT fk_dept 
>     FOREIGN KEY (departement_id) REFERENCES departements(id);
> 
> -- Renommer une table
> ALTER TABLE employes RENAME TO employees;
> ```

**Q6: Différence entre DROP, DELETE et TRUNCATE?**
> **R:**
> | DROP | DELETE | TRUNCATE |
> |------|--------|----------|
> | Supprime la table entière | Supprime des lignes | Supprime toutes les lignes |
> | Structure supprimée | Structure conservée | Structure conservée |
> | Irréversible | Peut utiliser WHERE | Pas de WHERE |
> | Pas de rollback | Rollback possible | Pas de rollback |
> | Plus rapide | Plus lent (log) | Très rapide |

---

## 3. Commandes DML - SELECT

**Q7: Comment sélectionner des données?**
> **R:**
> ```sql
> -- Sélectionner tout
> SELECT * FROM employes;
> 
> -- Sélectionner des colonnes spécifiques
> SELECT nom, prenom, salaire FROM employes;
> 
> -- Avec alias
> SELECT nom AS "Nom Complet", salaire AS "Salaire Mensuel" FROM employes;
> 
> -- Valeurs distinctes
> SELECT DISTINCT departement_id FROM employes;
> 
> -- Limiter les résultats
> SELECT * FROM employes LIMIT 10;          -- MySQL
> SELECT TOP 10 * FROM employes;            -- SQL Server
> SELECT * FROM employes FETCH FIRST 10 ROWS ONLY;  -- Oracle/PostgreSQL
> ```

**Q8: Comment filtrer avec WHERE?**
> **R:**
> ```sql
> -- Opérateurs de comparaison
> SELECT * FROM employes WHERE salaire > 50000;
> SELECT * FROM employes WHERE salaire >= 50000;
> SELECT * FROM employes WHERE salaire <> 50000;  -- Différent de
> SELECT * FROM employes WHERE salaire != 50000;
> 
> -- Opérateurs logiques
> SELECT * FROM employes WHERE salaire > 50000 AND departement_id = 1;
> SELECT * FROM employes WHERE salaire > 50000 OR departement_id = 1;
> SELECT * FROM employes WHERE NOT departement_id = 1;
> 
> -- BETWEEN
> SELECT * FROM employes WHERE salaire BETWEEN 40000 AND 60000;
> 
> -- IN
> SELECT * FROM employes WHERE departement_id IN (1, 2, 3);
> 
> -- LIKE (pattern matching)
> SELECT * FROM employes WHERE nom LIKE 'M%';      -- Commence par M
> SELECT * FROM employes WHERE nom LIKE '%son';    -- Finit par son
> SELECT * FROM employes WHERE nom LIKE '%art%';   -- Contient art
> SELECT * FROM employes WHERE nom LIKE '_artin';  -- 1 caractère + artin
> 
> -- IS NULL / IS NOT NULL
> SELECT * FROM employes WHERE email IS NULL;
> SELECT * FROM employes WHERE email IS NOT NULL;
> ```

**Q9: Comment trier les résultats?**
> **R:**
> ```sql
> -- Tri ascendant (par défaut)
> SELECT * FROM employes ORDER BY nom ASC;
> 
> -- Tri descendant
> SELECT * FROM employes ORDER BY salaire DESC;
> 
> -- Tri multiple
> SELECT * FROM employes ORDER BY departement_id ASC, salaire DESC;
> 
> -- Tri par position de colonne
> SELECT nom, salaire FROM employes ORDER BY 2 DESC;
> ```

---

## 4. Fonctions d'Agrégation

**Q10: Quelles sont les fonctions d'agrégation?**
> **R:**
> ```sql
> -- COUNT - Compter les lignes
> SELECT COUNT(*) FROM employes;
> SELECT COUNT(DISTINCT departement_id) FROM employes;
> 
> -- SUM - Somme
> SELECT SUM(salaire) AS total_salaires FROM employes;
> 
> -- AVG - Moyenne
> SELECT AVG(salaire) AS salaire_moyen FROM employes;
> 
> -- MIN / MAX
> SELECT MIN(salaire) AS salaire_min, MAX(salaire) AS salaire_max FROM employes;
> 
> -- Combiné
> SELECT 
>     COUNT(*) AS nombre,
>     SUM(salaire) AS total,
>     AVG(salaire) AS moyenne,
>     MIN(salaire) AS minimum,
>     MAX(salaire) AS maximum
> FROM employes;
> ```

**Q11: Comment grouper les résultats avec GROUP BY?**
> **R:**
> ```sql
> -- Grouper par département
> SELECT departement_id, COUNT(*) AS nb_employes
> FROM employes
> GROUP BY departement_id;
> 
> -- Avec plusieurs colonnes
> SELECT departement_id, annee_embauche, AVG(salaire)
> FROM employes
> GROUP BY departement_id, annee_embauche;
> 
> -- HAVING - Filtrer les groupes (après agrégation)
> SELECT departement_id, AVG(salaire) AS salaire_moyen
> FROM employes
> GROUP BY departement_id
> HAVING AVG(salaire) > 50000;
> ```

**Q12: Différence entre WHERE et HAVING?**
> **R:**
> | WHERE | HAVING |
> |-------|--------|
> | Filtre les lignes avant agrégation | Filtre les groupes après agrégation |
> | Ne peut pas utiliser les fonctions d'agrégation | Peut utiliser les fonctions d'agrégation |
> | S'applique à chaque ligne | S'applique aux résultats groupés |

---

## 5. Jointures (JOINS)

**Q13: Quels sont les types de JOIN?**
> **R:**
> | Type | Description |
> |------|-------------|
> | **INNER JOIN** | Lignes correspondantes dans les deux tables |
> | **LEFT JOIN** | Toutes les lignes de gauche + correspondances |
> | **RIGHT JOIN** | Toutes les lignes de droite + correspondances |
> | **FULL OUTER JOIN** | Toutes les lignes des deux tables |
> | **CROSS JOIN** | Produit cartésien (toutes les combinaisons) |
> | **SELF JOIN** | Jointure d'une table avec elle-même |

**Q14: Comment utiliser les JOINs?**
> **R:**
> ```sql
> -- INNER JOIN
> SELECT e.nom, e.prenom, d.nom AS departement
> FROM employes e
> INNER JOIN departements d ON e.departement_id = d.id;
> 
> -- LEFT JOIN (tous les employés même sans département)
> SELECT e.nom, d.nom AS departement
> FROM employes e
> LEFT JOIN departements d ON e.departement_id = d.id;
> 
> -- RIGHT JOIN (tous les départements même sans employés)
> SELECT e.nom, d.nom AS departement
> FROM employes e
> RIGHT JOIN departements d ON e.departement_id = d.id;
> 
> -- FULL OUTER JOIN
> SELECT e.nom, d.nom AS departement
> FROM employes e
> FULL OUTER JOIN departements d ON e.departement_id = d.id;
> 
> -- CROSS JOIN (produit cartésien)
> SELECT e.nom, p.nom AS projet
> FROM employes e
> CROSS JOIN projets p;
> 
> -- SELF JOIN (hiérarchie manager/employé)
> SELECT e.nom AS employe, m.nom AS manager
> FROM employes e
> LEFT JOIN employes m ON e.manager_id = m.id;
> 
> -- JOIN multiple
> SELECT e.nom, d.nom AS departement, p.nom AS projet
> FROM employes e
> INNER JOIN departements d ON e.departement_id = d.id
> INNER JOIN affectations a ON e.id = a.employe_id
> INNER JOIN projets p ON a.projet_id = p.id;
> ```

---

## 6. Sous-requêtes

**Q15: Qu'est-ce qu'une sous-requête?**
> **R:** C'est une requête imbriquée dans une autre requête. Elle peut être utilisée dans SELECT, FROM, WHERE ou HAVING.

**Q16: Comment utiliser les sous-requêtes?**
> **R:**
> ```sql
> -- Dans WHERE (scalaire)
> SELECT * FROM employes
> WHERE salaire > (SELECT AVG(salaire) FROM employes);
> 
> -- Dans WHERE avec IN
> SELECT * FROM employes
> WHERE departement_id IN (
>     SELECT id FROM departements WHERE localisation = 'Paris'
> );
> 
> -- Dans WHERE avec EXISTS
> SELECT * FROM departements d
> WHERE EXISTS (
>     SELECT 1 FROM employes e WHERE e.departement_id = d.id
> );
> 
> -- Dans FROM (table dérivée)
> SELECT dept, salaire_moyen
> FROM (
>     SELECT departement_id AS dept, AVG(salaire) AS salaire_moyen
>     FROM employes
>     GROUP BY departement_id
> ) AS stats
> WHERE salaire_moyen > 50000;
> 
> -- Dans SELECT (sous-requête corrélée)
> SELECT nom, salaire,
>     (SELECT AVG(salaire) FROM employes) AS moyenne_globale
> FROM employes;
> 
> -- Sous-requête corrélée
> SELECT e.nom, e.salaire
> FROM employes e
> WHERE e.salaire > (
>     SELECT AVG(salaire) FROM employes 
>     WHERE departement_id = e.departement_id
> );
> ```

**Q17: Différence entre IN et EXISTS?**
> **R:**
> | IN | EXISTS |
> |----|--------|
> | Compare une valeur à une liste | Vérifie l'existence de lignes |
> | Mieux pour petites sous-requêtes | Mieux pour grandes sous-requêtes |
> | Évalue toute la sous-requête | S'arrête dès qu'une ligne est trouvée |

---

## 7. INSERT, UPDATE, DELETE

**Q18: Comment insérer des données?**
> **R:**
> ```sql
> -- Insertion simple
> INSERT INTO employes (nom, prenom, salaire)
> VALUES ('Dupont', 'Jean', 45000);
> 
> -- Insertion multiple
> INSERT INTO employes (nom, prenom, salaire) VALUES
>     ('Martin', 'Pierre', 50000),
>     ('Bernard', 'Marie', 55000),
>     ('Petit', 'Paul', 48000);
> 
> -- Insertion depuis une autre table
> INSERT INTO employes_archives (nom, prenom, salaire)
> SELECT nom, prenom, salaire
> FROM employes
> WHERE date_depart IS NOT NULL;
> ```

**Q19: Comment mettre à jour des données?**
> **R:**
> ```sql
> -- Mise à jour simple
> UPDATE employes SET salaire = 50000 WHERE id = 1;
> 
> -- Mise à jour multiple colonnes
> UPDATE employes 
> SET salaire = 55000, departement_id = 2
> WHERE id = 1;
> 
> -- Mise à jour avec calcul
> UPDATE employes SET salaire = salaire * 1.10;  -- Augmentation 10%
> 
> -- Mise à jour avec sous-requête
> UPDATE employes
> SET salaire = (SELECT AVG(salaire) FROM employes)
> WHERE departement_id = 1;
> 
> -- Mise à jour avec JOIN (MySQL)
> UPDATE employes e
> INNER JOIN departements d ON e.departement_id = d.id
> SET e.salaire = e.salaire * 1.05
> WHERE d.nom = 'IT';
> ```

**Q20: Comment supprimer des données?**
> **R:**
> ```sql
> -- Suppression avec condition
> DELETE FROM employes WHERE id = 1;
> 
> -- Suppression multiple
> DELETE FROM employes WHERE departement_id = 5;
> 
> -- Suppression avec sous-requête
> DELETE FROM employes
> WHERE departement_id IN (
>     SELECT id FROM departements WHERE actif = 0
> );
> 
> -- Supprimer toutes les lignes (avec TRUNCATE)
> TRUNCATE TABLE employes_temp;
> ```

---

## 8. Contraintes

**Q21: Quelles sont les contraintes SQL?**
> **R:**
> | Contrainte | Description |
> |------------|-------------|
> | **PRIMARY KEY** | Identifiant unique (NOT NULL + UNIQUE) |
> | **FOREIGN KEY** | Référence vers une autre table |
> | **UNIQUE** | Valeurs uniques (peut être NULL) |
> | **NOT NULL** | Valeur obligatoire |
> | **CHECK** | Condition de validation |
> | **DEFAULT** | Valeur par défaut |

**Q22: Comment définir les contraintes?**
> **R:**
> ```sql
> CREATE TABLE employes (
>     -- PRIMARY KEY
>     id INT PRIMARY KEY,
>     -- ou: id INT, PRIMARY KEY (id)
>     
>     -- NOT NULL
>     nom VARCHAR(50) NOT NULL,
>     
>     -- UNIQUE
>     email VARCHAR(100) UNIQUE,
>     
>     -- CHECK
>     age INT CHECK (age >= 18),
>     salaire DECIMAL(10,2) CHECK (salaire > 0),
>     
>     -- DEFAULT
>     statut VARCHAR(20) DEFAULT 'actif',
>     date_creation TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
>     
>     -- FOREIGN KEY
>     departement_id INT,
>     FOREIGN KEY (departement_id) REFERENCES departements(id)
>         ON DELETE SET NULL
>         ON UPDATE CASCADE
> );
> 
> -- Clé primaire composite
> CREATE TABLE affectations (
>     employe_id INT,
>     projet_id INT,
>     PRIMARY KEY (employe_id, projet_id)
> );
> ```

**Q23: Que signifient ON DELETE et ON UPDATE?**
> **R:**
> | Option | Description |
> |--------|-------------|
> | **CASCADE** | Supprime/Met à jour les lignes enfants |
> | **SET NULL** | Met la clé étrangère à NULL |
> | **SET DEFAULT** | Met la valeur par défaut |
> | **RESTRICT** | Empêche la suppression/modification |
> | **NO ACTION** | Similaire à RESTRICT |

---

## 9. Index

**Q24: Qu'est-ce qu'un Index?**
> **R:** C'est une structure de données qui améliore la vitesse des opérations de recherche sur une table, au détriment de l'espace disque et des performances d'écriture.

**Q25: Comment créer et gérer les index?**
> **R:**
> ```sql
> -- Créer un index simple
> CREATE INDEX idx_nom ON employes(nom);
> 
> -- Index unique
> CREATE UNIQUE INDEX idx_email ON employes(email);
> 
> -- Index composite (multi-colonnes)
> CREATE INDEX idx_nom_prenom ON employes(nom, prenom);
> 
> -- Supprimer un index
> DROP INDEX idx_nom ON employes;  -- MySQL
> DROP INDEX idx_nom;              -- PostgreSQL
> 
> -- Voir les index
> SHOW INDEX FROM employes;        -- MySQL
> ```

**Q26: Quand utiliser un index?**
> **R:**
> **Utiliser:**
> - Colonnes fréquemment utilisées dans WHERE
> - Colonnes utilisées dans JOIN
> - Colonnes utilisées dans ORDER BY
> - Colonnes avec haute cardinalité (beaucoup de valeurs uniques)
> 
> **Éviter:**
> - Petites tables
> - Colonnes rarement utilisées dans les requêtes
> - Colonnes avec peu de valeurs distinctes
> - Tables avec beaucoup d'INSERT/UPDATE/DELETE

---

## 10. Vues

**Q27: Qu'est-ce qu'une Vue?**
> **R:** C'est une table virtuelle basée sur le résultat d'une requête SELECT. Elle ne stocke pas de données mais affiche les données des tables sous-jacentes.

**Q28: Comment créer et utiliser une vue?**
> **R:**
> ```sql
> -- Créer une vue
> CREATE VIEW vue_employes_departement AS
> SELECT e.id, e.nom, e.prenom, e.salaire, d.nom AS departement
> FROM employes e
> INNER JOIN departements d ON e.departement_id = d.id;
> 
> -- Utiliser une vue
> SELECT * FROM vue_employes_departement WHERE departement = 'IT';
> 
> -- Modifier une vue
> CREATE OR REPLACE VIEW vue_employes_departement AS
> SELECT e.id, e.nom, e.prenom, e.salaire, e.email, d.nom AS departement
> FROM employes e
> INNER JOIN departements d ON e.departement_id = d.id;
> 
> -- Supprimer une vue
> DROP VIEW vue_employes_departement;
> ```

**Q29: Avantages et inconvénients des vues?**
> **R:**
> **Avantages:**
> - Simplifier les requêtes complexes
> - Sécurité (masquer certaines colonnes)
> - Abstraction (indépendance des tables)
> 
> **Inconvénients:**
> - Pas toujours modifiables (INSERT/UPDATE)
> - Performance (recalculées à chaque appel)
> - Maintenance si les tables changent

---

## 11. Transactions

**Q30: Qu'est-ce qu'une Transaction?**
> **R:** C'est un ensemble d'opérations SQL qui doivent être exécutées comme une unité atomique. Soit toutes réussissent, soit aucune n'est appliquée.

**Q31: Que signifie ACID?**
> **R:**
> | Propriété | Description |
> |-----------|-------------|
> | **Atomicité** | Tout ou rien |
> | **Cohérence** | État valide avant et après |
> | **Isolation** | Transactions indépendantes |
> | **Durabilité** | Changements permanents après commit |

**Q32: Comment gérer les transactions?**
> **R:**
> ```sql
> -- Démarrer une transaction
> START TRANSACTION;  -- MySQL
> BEGIN TRANSACTION;  -- SQL Server
> BEGIN;              -- PostgreSQL
> 
> -- Opérations
> UPDATE comptes SET solde = solde - 100 WHERE id = 1;
> UPDATE comptes SET solde = solde + 100 WHERE id = 2;
> 
> -- Valider la transaction
> COMMIT;
> 
> -- Annuler la transaction
> ROLLBACK;
> 
> -- Point de sauvegarde
> SAVEPOINT point1;
> -- ... opérations ...
> ROLLBACK TO point1;  -- Annuler jusqu'au savepoint
> ```

**Q33: Quels sont les niveaux d'isolation?**
> **R:**
> | Niveau | Dirty Read | Non-Repeatable Read | Phantom Read |
> |--------|------------|---------------------|--------------|
> | READ UNCOMMITTED | Oui | Oui | Oui |
> | READ COMMITTED | Non | Oui | Oui |
> | REPEATABLE READ | Non | Non | Oui |
> | SERIALIZABLE | Non | Non | Non |

---

## 12. Fonctions SQL

**Q34: Quelles sont les fonctions de chaîne courantes?**
> **R:**
> ```sql
> -- Longueur
> SELECT LENGTH('Hello');           -- 5
> SELECT CHAR_LENGTH('Hello');      -- 5
> 
> -- Majuscules/Minuscules
> SELECT UPPER('hello');            -- HELLO
> SELECT LOWER('HELLO');            -- hello
> 
> -- Extraction
> SELECT SUBSTRING('Hello World', 1, 5);   -- Hello
> SELECT LEFT('Hello', 3);                  -- Hel
> SELECT RIGHT('Hello', 2);                 -- lo
> 
> -- Concaténation
> SELECT CONCAT(nom, ' ', prenom) FROM employes;
> SELECT nom || ' ' || prenom FROM employes;  -- PostgreSQL/Oracle
> 
> -- Remplacement
> SELECT REPLACE('Hello World', 'World', 'SQL');  -- Hello SQL
> 
> -- Trim
> SELECT TRIM('  Hello  ');         -- Hello
> SELECT LTRIM('  Hello');          -- Hello
> SELECT RTRIM('Hello  ');          -- Hello
> ```

**Q35: Quelles sont les fonctions de date courantes?**
> **R:**
> ```sql
> -- Date/Heure actuelle
> SELECT NOW();                     -- Date et heure
> SELECT CURRENT_DATE;              -- Date
> SELECT CURRENT_TIME;              -- Heure
> 
> -- Extraction
> SELECT YEAR(date_embauche) FROM employes;
> SELECT MONTH(date_embauche) FROM employes;
> SELECT DAY(date_embauche) FROM employes;
> SELECT EXTRACT(YEAR FROM date_embauche) FROM employes;
> 
> -- Différence
> SELECT DATEDIFF(NOW(), date_embauche) FROM employes;  -- MySQL
> SELECT date_embauche - CURRENT_DATE FROM employes;    -- PostgreSQL
> 
> -- Ajout/Soustraction
> SELECT DATE_ADD(date_embauche, INTERVAL 1 YEAR) FROM employes;
> SELECT date_embauche + INTERVAL '1 year' FROM employes;  -- PostgreSQL
> 
> -- Formatage
> SELECT DATE_FORMAT(date_embauche, '%d/%m/%Y') FROM employes;  -- MySQL
> SELECT TO_CHAR(date_embauche, 'DD/MM/YYYY') FROM employes;    -- PostgreSQL
> ```

**Q36: Quelles sont les fonctions numériques courantes?**
> **R:**
> ```sql
> -- Arrondi
> SELECT ROUND(3.14159, 2);         -- 3.14
> SELECT CEIL(3.14);                -- 4
> SELECT FLOOR(3.99);               -- 3
> 
> -- Valeur absolue
> SELECT ABS(-10);                  -- 10
> 
> -- Puissance/Racine
> SELECT POWER(2, 3);               -- 8
> SELECT SQRT(16);                  -- 4
> 
> -- Modulo
> SELECT MOD(10, 3);                -- 1
> SELECT 10 % 3;                    -- 1
> ```

---

## 13. Fonctions Avancées

**Q37: Comment utiliser CASE WHEN?**
> **R:**
> ```sql
> -- CASE simple
> SELECT nom, salaire,
>     CASE
>         WHEN salaire < 30000 THEN 'Junior'
>         WHEN salaire BETWEEN 30000 AND 60000 THEN 'Confirmé'
>         ELSE 'Senior'
>     END AS niveau
> FROM employes;
> 
> -- CASE avec valeur
> SELECT nom,
>     CASE departement_id
>         WHEN 1 THEN 'IT'
>         WHEN 2 THEN 'RH'
>         WHEN 3 THEN 'Finance'
>         ELSE 'Autre'
>     END AS departement
> FROM employes;
> ```

**Q38: Comment utiliser COALESCE et NULLIF?**
> **R:**
> ```sql
> -- COALESCE - Première valeur non NULL
> SELECT COALESCE(telephone, email, 'Non disponible') AS contact
> FROM employes;
> 
> -- NULLIF - NULL si égaux
> SELECT NULLIF(salaire, 0) FROM employes;  -- NULL si salaire = 0
> 
> -- Éviter division par zéro
> SELECT total / NULLIF(quantite, 0) FROM commandes;
> ```

**Q39: Comment utiliser les fonctions de fenêtre (Window Functions)?**
> **R:**
> ```sql
> -- ROW_NUMBER - Numéro de ligne
> SELECT nom, salaire,
>     ROW_NUMBER() OVER (ORDER BY salaire DESC) AS rang
> FROM employes;
> 
> -- RANK - Rang avec sauts
> SELECT nom, salaire,
>     RANK() OVER (ORDER BY salaire DESC) AS rang
> FROM employes;
> 
> -- DENSE_RANK - Rang sans sauts
> SELECT nom, salaire,
>     DENSE_RANK() OVER (ORDER BY salaire DESC) AS rang
> FROM employes;
> 
> -- Partition
> SELECT nom, departement_id, salaire,
>     ROW_NUMBER() OVER (PARTITION BY departement_id ORDER BY salaire DESC) AS rang_dept
> FROM employes;
> 
> -- LAG / LEAD - Valeur précédente/suivante
> SELECT nom, salaire,
>     LAG(salaire) OVER (ORDER BY date_embauche) AS salaire_precedent,
>     LEAD(salaire) OVER (ORDER BY date_embauche) AS salaire_suivant
> FROM employes;
> 
> -- SUM / AVG cumulatifs
> SELECT nom, salaire,
>     SUM(salaire) OVER (ORDER BY date_embauche) AS cumul_salaires,
>     AVG(salaire) OVER (PARTITION BY departement_id) AS moyenne_dept
> FROM employes;
> ```

---

## 14. Optimisation et Performance

**Q40: Comment analyser une requête?**
> **R:**
> ```sql
> -- MySQL
> EXPLAIN SELECT * FROM employes WHERE nom = 'Dupont';
> EXPLAIN ANALYZE SELECT * FROM employes WHERE nom = 'Dupont';
> 
> -- PostgreSQL
> EXPLAIN (ANALYZE, BUFFERS) SELECT * FROM employes WHERE nom = 'Dupont';
> 
> -- SQL Server
> SET STATISTICS IO ON;
> SET STATISTICS TIME ON;
> ```

**Q41: Quelles sont les bonnes pratiques d'optimisation?**
> **R:**
> - **Éviter SELECT \*** : Sélectionner uniquement les colonnes nécessaires
> - **Utiliser les index** : Sur les colonnes WHERE, JOIN, ORDER BY
> - **Éviter les fonctions sur les colonnes indexées** : `WHERE YEAR(date) = 2024` → `WHERE date BETWEEN '2024-01-01' AND '2024-12-31'`
> - **Utiliser EXISTS au lieu de IN** : Pour les grandes sous-requêtes
> - **Limiter les résultats** : Utiliser LIMIT/TOP
> - **Éviter les sous-requêtes corrélées** : Préférer les JOIN
> - **Normaliser les données** : Éviter la redondance
> - **Utiliser les types appropriés** : INT au lieu de VARCHAR pour les IDs

---

## 15. Procédures Stockées et Fonctions

**Q42: Qu'est-ce qu'une procédure stockée?**
> **R:** C'est un ensemble d'instructions SQL stocké dans la base de données, pouvant être appelé par son nom. Elle peut accepter des paramètres et ne retourne pas de valeur directe.

**Q43: Comment créer une procédure stockée?**
> **R:**
> ```sql
> -- MySQL
> DELIMITER //
> CREATE PROCEDURE augmenter_salaire(IN emp_id INT, IN pourcentage DECIMAL(5,2))
> BEGIN
>     UPDATE employes
>     SET salaire = salaire * (1 + pourcentage / 100)
>     WHERE id = emp_id;
> END //
> DELIMITER ;
> 
> -- Appel
> CALL augmenter_salaire(1, 10);
> 
> -- Avec paramètre OUT
> DELIMITER //
> CREATE PROCEDURE get_salaire_moyen(IN dept_id INT, OUT moyenne DECIMAL(10,2))
> BEGIN
>     SELECT AVG(salaire) INTO moyenne
>     FROM employes
>     WHERE departement_id = dept_id;
> END //
> DELIMITER ;
> 
> -- Appel
> CALL get_salaire_moyen(1, @moyenne);
> SELECT @moyenne;
> ```

**Q44: Différence entre Procédure et Fonction?**
> **R:**
> | Procédure | Fonction |
> |-----------|----------|
> | CALL pour appeler | Utilisable dans SELECT |
> | Peut retourner plusieurs valeurs (OUT) | Retourne une seule valeur |
> | Peut modifier les données | Généralement lecture seule |
> | Ne peut pas être utilisée dans WHERE | Peut être utilisée dans WHERE |

---

## 16. Triggers

**Q45: Qu'est-ce qu'un Trigger?**
> **R:** C'est un programme qui s'exécute automatiquement en réponse à un événement (INSERT, UPDATE, DELETE) sur une table.

**Q46: Comment créer un Trigger?**
> **R:**
> ```sql
> -- MySQL - Trigger BEFORE INSERT
> DELIMITER //
> CREATE TRIGGER before_insert_employe
> BEFORE INSERT ON employes
> FOR EACH ROW
> BEGIN
>     SET NEW.date_creation = NOW();
>     SET NEW.nom = UPPER(NEW.nom);
> END //
> DELIMITER ;
> 
> -- Trigger AFTER UPDATE (audit)
> DELIMITER //
> CREATE TRIGGER after_update_employe
> AFTER UPDATE ON employes
> FOR EACH ROW
> BEGIN
>     INSERT INTO audit_employes (employe_id, ancien_salaire, nouveau_salaire, date_modif)
>     VALUES (OLD.id, OLD.salaire, NEW.salaire, NOW());
> END //
> DELIMITER ;
> 
> -- Supprimer un trigger
> DROP TRIGGER before_insert_employe;
> ```

---

## 17. Common Table Expressions (CTE)

**Q47: Qu'est-ce qu'un CTE?**
> **R:** C'est une requête nommée temporaire définie avec WITH, utilisable dans la requête principale. Elle améliore la lisibilité des requêtes complexes.

**Q48: Comment utiliser les CTEs?**
> **R:**
> ```sql
> -- CTE simple
> WITH employes_senior AS (
>     SELECT * FROM employes WHERE salaire > 60000
> )
> SELECT * FROM employes_senior WHERE departement_id = 1;
> 
> -- CTE multiple
> WITH 
> stats_dept AS (
>     SELECT departement_id, AVG(salaire) AS moyenne
>     FROM employes
>     GROUP BY departement_id
> ),
> top_dept AS (
>     SELECT departement_id FROM stats_dept WHERE moyenne > 50000
> )
> SELECT e.* FROM employes e
> WHERE e.departement_id IN (SELECT departement_id FROM top_dept);
> 
> -- CTE récursif (hiérarchie)
> WITH RECURSIVE hierarchie AS (
>     -- Cas de base
>     SELECT id, nom, manager_id, 1 AS niveau
>     FROM employes
>     WHERE manager_id IS NULL
>     
>     UNION ALL
>     
>     -- Cas récursif
>     SELECT e.id, e.nom, e.manager_id, h.niveau + 1
>     FROM employes e
>     INNER JOIN hierarchie h ON e.manager_id = h.id
> )
> SELECT * FROM hierarchie;
> ```

---

## 18. UNION et Opérations Ensemblistes

**Q49: Quelles sont les opérations ensemblistes?**
> **R:**
> ```sql
> -- UNION - Combine sans doublons
> SELECT nom FROM employes
> UNION
> SELECT nom FROM candidats;
> 
> -- UNION ALL - Combine avec doublons
> SELECT nom FROM employes
> UNION ALL
> SELECT nom FROM candidats;
> 
> -- INTERSECT - Éléments communs
> SELECT nom FROM employes
> INTERSECT
> SELECT nom FROM candidats;
> 
> -- EXCEPT / MINUS - Différence
> SELECT nom FROM employes
> EXCEPT
> SELECT nom FROM anciens_employes;
> ```

**Q50: Règles des opérations ensemblistes?**
> **R:**
> - Même nombre de colonnes
> - Types de données compatibles
> - ORDER BY à la fin uniquement
> - Les noms de colonnes viennent de la première requête

