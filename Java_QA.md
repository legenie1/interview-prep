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
> | Type | Taille | Valeur par défaut |<br/>
> |------|--------|-------------------|<br/>
> | `byte` | 8 bits | 0 |<br/>
> | `short` | 16 bits | 0 |<br/>
> | `int` | 32 bits | 0 |<br/>
> | `long` | 64 bits | 0L |<br/>
> | `float` | 32 bits | 0.0f |<br/>
> | `double` | 64 bits | 0.0d |<br/>
> | `char` | 16 bits | '\u0000' |<br/>
> | `boolean` | 1 bit | false |

---

## 2. String et Collections

**Q5: Qu'est-ce que le framework Collections?**
> **R:** C'est un ensemble d'interfaces et de classes pour stocker et manipuler des groupes d'objets.
> ```
> Collection (interface)
> ├── List (interface) → ArrayList, LinkedList, Vector
> ├── Set (interface) → HashSet, LinkedHashSet, TreeSet
> └── Queue (interface) → PriorityQueue, LinkedList
> 
> Map (interface) → HashMap, LinkedHashMap, TreeMap, Hashtable
> ```
> **Interfaces principales:**
> - **Collection:** Interface racine (add, remove, contains, size)
> - **List:** Collection ordonnée avec doublons (accès par index)
> - **Set:** Collection sans doublons
> - **Queue:** Collection FIFO (First-In-First-Out)
> - **Map:** Paires clé-valeur (pas une sous-interface de Collection)

**Q6: Pourquoi String est immutable en Java?**
> **R:**
> - **Sécurité:** Les chaînes sont utilisées pour les mots de passe, noms de fichiers
> - **Thread-safe:** Pas de synchronisation nécessaire
> - **Pool de String:** Permet la réutilisation (String Pool)
> - **Hashcode:** Peut être caché pour les HashMap

**Q7: Différence entre String, StringBuilder et StringBuffer?**
> **R:**
> | | String | StringBuilder | StringBuffer |<br/>
> |-|--------|---------------|--------------|<br/>
> | Mutabilité | Immutable | Mutable | Mutable |<br/>
> | Thread-safe | Oui | Non | Oui (synchronized) |<br/>
> | Performance | Lente | Rapide | Moyenne |<br/>
> | Utilisation | Chaînes constantes | Single-thread | Multi-thread |

**Q8: Différence entre ArrayList et LinkedList?**
> **R:**
> | ArrayList | LinkedList |<br/>
> |-----------|------------|<br/>
> | Basé sur un tableau dynamique | Basé sur une liste doublement chaînée |<br/>
> | Accès rapide O(1) | Accès lent O(n) |<br/>
> | Insertion/Suppression lente O(n) | Insertion/Suppression rapide O(1) |<br/>
> | Moins de mémoire | Plus de mémoire (références) |

**Q9: Différence entre Map et HashMap?**
> **R:**
> | Map | HashMap |<br/>
> |-----|---------|<br/>
> | Interface | Classe qui implémente Map |<br/>
> | Définit le contrat (méthodes) | Fournit l'implémentation |<br/>
> | Ne peut pas être instanciée | Peut être instanciée |<br/>
> | Plusieurs implémentations possibles | Une implémentation spécifique |
> ```java
> // Bonne pratique: programmer vers l'interface
> Map<String, Integer> map = new HashMap<>();
> 
> // Autres implémentations de Map:
> Map<String, Integer> linkedMap = new LinkedHashMap<>(); // Ordre d'insertion
> Map<String, Integer> treeMap = new TreeMap<>();         // Ordre trié
> Map<String, Integer> hashtable = new Hashtable<>();     // Thread-safe (legacy)
> ```
> **HashMap spécifiquement:**
> - Basé sur une table de hachage
> - Accès O(1) en moyenne
> - Accepte une clé null et plusieurs valeurs null
> - Non synchronisé (pas thread-safe)

**Q10: Différence entre HashMap et HashTable?**
> **R:**
> | HashMap | HashTable |<br/>
> |---------|-----------|<br/>
> | Non synchronisé | Synchronisé |<br/>
> | Accepte null (clé et valeur) | N'accepte pas null |<br/>
> | Plus rapide | Plus lent |<br/>
> | Non thread-safe | Thread-safe |<br/>

**Q11: Différence entre Comparable et Comparator?**
> **R:**
> | Comparable | Comparator |<br/>
> |------------|------------|<br/>
> | `java.lang` | `java.util` |<br/>
> | Méthode `compareTo(Object)` | Méthode `compare(Object, Object)` |<br/>
> | Tri naturel (dans la classe) | Tri personnalisé (externe) |<br/>
> | Une seule séquence de tri | Plusieurs séquences de tri |

---

## 3. Exceptions

**Q12: Différence entre Exception et Error?**
> **R:**
> - **Exception:** Problèmes récupérables (fichier non trouvé, connexion échouée)
> - **Error:** Problèmes graves non récupérables (OutOfMemoryError, StackOverflowError)

**Q13: Différence entre Checked et Unchecked Exception?**
> **R:**
> | Checked Exception | Unchecked Exception |<br/>
> |-------------------|---------------------|<br/>
> | Vérifié à la compilation | Vérifié à l'exécution |<br/>
> | Doit être géré (try-catch ou throws) | Optionnel à gérer |<br/>
> | Hérite de `Exception` | Hérite de `RuntimeException` |<br/>
> | Ex: IOException, SQLException | Ex: NullPointerException, ArrayIndexOutOfBounds |

**Q14: Différence entre throw et throws?**
> **R:**
> - **throw:** Lance une exception explicitement
> ```java
> throw new IllegalArgumentException("Valeur invalide");
> ```
> - **throws:** Déclare les exceptions qu'une méthode peut lancer
> ```java
> public void lire() throws IOException { }
> ```

**Q15: Qu'est-ce que le bloc finally?**
> **R:** Bloc qui s'exécute toujours, que l'exception soit levée ou non. Utilisé pour libérer les ressources (fermer fichiers, connexions).

---

## 4. Multi-threading

**Q16: Différence entre Thread et Runnable?**
> **R:**
> | Thread | Runnable |<br/>
> |--------|----------|<br/>
> | Classe à étendre | Interface à implémenter |<br/>
> | Héritage simple (pas d'autre héritage) | Peut implémenter d'autres interfaces |<br/>
> | `extends Thread` | `implements Runnable` |

**Q17: Qu'est-ce que la synchronisation?**
> **R:** Mécanisme pour contrôler l'accès concurrent aux ressources partagées. Utilise le mot-clé `synchronized` pour garantir qu'un seul thread accède à une section critique.

**Q18: Différence entre wait() et sleep()?**
> **R:**
> | wait() | sleep() |<br/>
> |--------|---------|<br/>
> | Classe Object | Classe Thread |<br/>
> | Libère le verrou | Ne libère pas le verrou |<br/>
> | Doit être dans synchronized | Peut être appelé n'importe où |<br/>
> | Réveillé par notify()/notifyAll() | Réveillé après le temps spécifié |

**Q19: Qu'est-ce qu'un Deadlock?**
> **R:** Situation où deux ou plusieurs threads s'attendent mutuellement pour libérer des ressources, bloquant indéfiniment l'exécution.

---

## 5. Concepts Avancés

**Q20: Qu'est-ce que la Sérialisation?**
> **R:** Processus de conversion d'un objet en flux d'octets pour le stockage ou la transmission. On utilise l'interface `Serializable` et le mot-clé `transient` pour exclure des champs.

**Q21: Qu'est-ce que la Réflexion (Reflection)?**
> **R:** Capacité d'examiner et modifier la structure et le comportement d'un programme à l'exécution. Permet d'inspecter classes, méthodes, attributs dynamiquement.

**Q22: Différence entre == et equals()?**
> **R:**
> - **==:** Compare les références (adresses mémoire)
> - **equals():** Compare les valeurs (contenu des objets)
> ```java
> String a = new String("test");
> String b = new String("test");
> a == b;      // false (références différentes)
> a.equals(b); // true (même contenu)
> ```

**Q23: Qu'est-ce que le mot-clé volatile?**
> **R:** Indique qu'une variable peut être modifiée par plusieurs threads. Garantit la visibilité des modifications entre threads (pas de cache local).

**Q24: Différence entre Heap et Stack?**
> **R:**
> | Heap | Stack |<br/>
> |------|-------|<br/>
> | Stocke les objets | Stocke les variables locales et références |<br/>
> | Partagé entre threads | Propre à chaque thread |<br/>
> | Garbage Collected | Libéré automatiquement |<br/>
> | Plus grand, plus lent | Plus petit, plus rapide |

---

## 6. Design Patterns Courants

**Q25: Qu'est-ce que le pattern Singleton?**
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

**Q26: Qu'est-ce que le pattern Factory?**
> **R:** Délègue la création d'objets à une méthode factory, permettant de créer des objets sans spécifier la classe exacte.

**Q27: Qu'est-ce que le pattern Builder?**
> **R:** Permet de construire des objets complexes étape par étape, séparant la construction de la représentation.

