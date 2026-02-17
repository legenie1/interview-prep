# Questions et Réponses Java

---

## 1. Les Fondamentaux Java

**Q1: Quelles sont les caractéristiques principales de Java?**
> **R:**
> - **Orienté Objet:** Tout est objet (sauf les types primitifs)
> - **Indépendant de la plateforme:** "Write Once, Run Anywhere" grâce à la JVM
> - **Robuste:** Gestion de la mémoire automatique (Garbage Collector)
> - **Sécurisé:** Pas de pointeurs, vérification du bytecode
> - **Multi-thread:** Support natif de la programmation concurrente

**Q2: Quelle est la différence entre JDK, JRE et JVM?**
> **R:**
> - **JVM (Java Virtual Machine):** Exécute le bytecode Java
> - **JRE (Java Runtime Environment):** JVM + bibliothèques de base (pour exécuter)
> - **JDK (Java Development Kit):** JRE + outils de développement (javac, debugger)

**Q3: Qu'est-ce que le Garbage Collector?**
> **R:** C'est un mécanisme automatique de gestion de la mémoire qui:
> - Identifie les objets non référencés
> - Libère la mémoire occupée par ces objets
> - Fonctionne en arrière-plan
> - Types: Serial GC, Parallel GC, G1 GC, ZGC

**Q4: Quels sont les types primitifs en Java?**
> **R:**
> | Type | Taille | Valeur par défaut |
> |------|--------|-------------------|
> | `byte` | 8 bits | 0 |
> | `short` | 16 bits | 0 |
> | `int` | 32 bits | 0 |
> | `long` | 64 bits | 0L |
> | `float` | 32 bits | 0.0f |
> | `double` | 64 bits | 0.0d |
> | `char` | 16 bits | '\u0000' |
> | `boolean` | 1 bit | false |

---

## 2. String et Collections

**Q5: Pourquoi String est immutable en Java?**
> **R:**
> - **Sécurité:** Les chaînes sont utilisées pour les mots de passe, noms de fichiers
> - **Thread-safe:** Pas de synchronisation nécessaire
> - **Pool de String:** Permet la réutilisation (String Pool)
> - **Hashcode:** Peut être caché pour les HashMap

**Q6: Différence entre String, StringBuilder et StringBuffer?**
> **R:**
> | | String | StringBuilder | StringBuffer |
> |-|--------|---------------|--------------|
> | Mutabilité | Immutable | Mutable | Mutable |
> | Thread-safe | Oui | Non | Oui (synchronized) |
> | Performance | Lente | Rapide | Moyenne |
> | Utilisation | Chaînes constantes | Single-thread | Multi-thread |

**Q7: Différence entre ArrayList et LinkedList?**
> **R:**
> | ArrayList | LinkedList |
> |-----------|------------|
> | Basé sur un tableau dynamique | Basé sur une liste doublement chaînée |
> | Accès rapide O(1) | Accès lent O(n) |
> | Insertion/Suppression lente O(n) | Insertion/Suppression rapide O(1) |
> | Moins de mémoire | Plus de mémoire (références) |

**Q8: Différence entre HashMap et HashTable?**
> **R:**
> | HashMap | HashTable |
> |---------|-----------|
> | Non synchronisé | Synchronisé |
> | Accepte null (clé et valeur) | N'accepte pas null |
> | Plus rapide | Plus lent |
> | Non thread-safe | Thread-safe |

**Q9: Différence entre Comparable et Comparator?**
> **R:**
> | Comparable | Comparator |
> |------------|------------|
> | `java.lang` | `java.util` |
> | Méthode `compareTo(Object)` | Méthode `compare(Object, Object)` |
> | Tri naturel (dans la classe) | Tri personnalisé (externe) |
> | Une seule séquence de tri | Plusieurs séquences de tri |

---

## 3. Exceptions

**Q10: Différence entre Exception et Error?**
> **R:**
> - **Exception:** Problèmes récupérables (fichier non trouvé, connexion échouée)
> - **Error:** Problèmes graves non récupérables (OutOfMemoryError, StackOverflowError)

**Q11: Différence entre Checked et Unchecked Exception?**
> **R:**
> | Checked Exception | Unchecked Exception |
> |-------------------|---------------------|
> | Vérifié à la compilation | Vérifié à l'exécution |
> | Doit être géré (try-catch ou throws) | Optionnel à gérer |
> | Hérite de `Exception` | Hérite de `RuntimeException` |
> | Ex: IOException, SQLException | Ex: NullPointerException, ArrayIndexOutOfBounds |

**Q12: Différence entre throw et throws?**
> **R:**
> - **throw:** Lance une exception explicitement
> ```java
> throw new IllegalArgumentException("Valeur invalide");
> ```
> - **throws:** Déclare les exceptions qu'une méthode peut lancer
> ```java
> public void lire() throws IOException { }
> ```

**Q13: Qu'est-ce que le bloc finally?**
> **R:** Bloc qui s'exécute toujours, que l'exception soit levée ou non. Utilisé pour libérer les ressources (fermer fichiers, connexions).

---

## 4. Multi-threading

**Q14: Différence entre Thread et Runnable?**
> **R:**
> | Thread | Runnable |
> |--------|----------|
> | Classe à étendre | Interface à implémenter |
> | Héritage simple (pas d'autre héritage) | Peut implémenter d'autres interfaces |
> | `extends Thread` | `implements Runnable` |

**Q15: Qu'est-ce que la synchronisation?**
> **R:** Mécanisme pour contrôler l'accès concurrent aux ressources partagées. Utilise le mot-clé `synchronized` pour garantir qu'un seul thread accède à une section critique.

**Q16: Différence entre wait() et sleep()?**
> **R:**
> | wait() | sleep() |
> |--------|---------|
> | Classe Object | Classe Thread |
> | Libère le verrou | Ne libère pas le verrou |
> | Doit être dans synchronized | Peut être appelé n'importe où |
> | Réveillé par notify()/notifyAll() | Réveillé après le temps spécifié |

**Q17: Qu'est-ce qu'un Deadlock?**
> **R:** Situation où deux ou plusieurs threads s'attendent mutuellement pour libérer des ressources, bloquant indéfiniment l'exécution.

---

## 5. Concepts Avancés

**Q18: Qu'est-ce que la Sérialisation?**
> **R:** Processus de conversion d'un objet en flux d'octets pour le stockage ou la transmission. On utilise l'interface `Serializable` et le mot-clé `transient` pour exclure des champs.

**Q19: Qu'est-ce que la Réflexion (Reflection)?**
> **R:** Capacité d'examiner et modifier la structure et le comportement d'un programme à l'exécution. Permet d'inspecter classes, méthodes, attributs dynamiquement.

**Q20: Différence entre == et equals()?**
> **R:**
> - **==:** Compare les références (adresses mémoire)
> - **equals():** Compare les valeurs (contenu des objets)
> ```java
> String a = new String("test");
> String b = new String("test");
> a == b;      // false (références différentes)
> a.equals(b); // true (même contenu)
> ```

**Q21: Qu'est-ce que le mot-clé volatile?**
> **R:** Indique qu'une variable peut être modifiée par plusieurs threads. Garantit la visibilité des modifications entre threads (pas de cache local).

**Q22: Différence entre Heap et Stack?**
> **R:**
> | Heap | Stack |
> |------|-------|
> | Stocke les objets | Stocke les variables locales et références |
> | Partagé entre threads | Propre à chaque thread |
> | Garbage Collected | Libéré automatiquement |
> | Plus grand, plus lent | Plus petit, plus rapide |

---

## 6. Design Patterns Courants

**Q23: Qu'est-ce que le pattern Singleton?**
> **R:** Garantit qu'une classe n'a qu'une seule instance et fournit un point d'accès global.
> ```java
> public class Singleton {
>     private static Singleton instance;
>     private Singleton() {}
>     public static synchronized Singleton getInstance() {
>         if (instance == null) instance = new Singleton();
>         return instance;
>     }
> }
> ```

**Q24: Qu'est-ce que le pattern Factory?**
> **R:** Délègue la création d'objets à une méthode factory, permettant de créer des objets sans spécifier la classe exacte.

**Q25: Qu'est-ce que le pattern Builder?**
> **R:** Permet de construire des objets complexes étape par étape, séparant la construction de la représentation.

