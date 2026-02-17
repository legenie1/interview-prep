# Questions et Réponses Java 8

---

## 1. Nouveautés Java 8

**Q1: Quelles sont les principales nouveautés de Java 8?**
> **R:**
> - **Expressions Lambda**
> - **API Stream**
> - **Interfaces fonctionnelles**
> - **Méthodes par défaut et statiques dans les interfaces**
> - **Optional**
> - **Nouvelle API Date/Time (java.time)**
> - **Nashorn JavaScript Engine**
> - **Method References**

---

## 2. Expressions Lambda

**Q2: Qu'est-ce qu'une expression Lambda?**
> **R:** C'est une fonction anonyme qui permet d'implémenter une interface fonctionnelle de manière concise.
> ```java
> // Avant Java 8
> Runnable r = new Runnable() {
>     @Override
>     public void run() {
>         System.out.println("Hello");
>     }
> };
> 
> // Avec Lambda
> Runnable r = () -> System.out.println("Hello");
> ```

**Q3: Quelle est la syntaxe d'une Lambda?**
> **R:** `(paramètres) -> expression` ou `(paramètres) -> { instructions }`
> ```java
> // Sans paramètre
> () -> System.out.println("Hello")
> 
> // Un paramètre
> x -> x * 2
> 
> // Plusieurs paramètres
> (a, b) -> a + b
> 
> // Avec bloc
> (a, b) -> {
>     int sum = a + b;
>     return sum;
> }
> ```

---

## 3. Interfaces Fonctionnelles

**Q4: Qu'est-ce qu'une interface fonctionnelle?**
> **R:** C'est une interface avec une seule méthode abstraite (SAM - Single Abstract Method). Annotée avec `@FunctionalInterface`.

**Q5: Quelles sont les interfaces fonctionnelles principales?**
> **R:**
> | Interface | Méthode | Description |
> |-----------|---------|-------------|
> | `Predicate<T>` | `test(T)` → boolean | Test une condition |
> | `Function<T,R>` | `apply(T)` → R | Transforme T en R |
> | `Consumer<T>` | `accept(T)` → void | Consomme T |
> | `Supplier<T>` | `get()` → T | Fournit T |
> | `BiFunction<T,U,R>` | `apply(T,U)` → R | Transforme T,U en R |
> | `UnaryOperator<T>` | `apply(T)` → T | Transforme T en T |
> | `BinaryOperator<T>` | `apply(T,T)` → T | Combine deux T |

**Q6: Exemples d'utilisation des interfaces fonctionnelles?**
> **R:**
> ```java
> // Predicate - tester une condition
> Predicate<Integer> estPair = n -> n % 2 == 0;
> estPair.test(4); // true
> 
> // Function - transformer
> Function<String, Integer> longueur = s -> s.length();
> longueur.apply("Hello"); // 5
> 
> // Consumer - consommer
> Consumer<String> afficher = s -> System.out.println(s);
> afficher.accept("Hello");
> 
> // Supplier - fournir
> Supplier<Double> aleatoire = () -> Math.random();
> aleatoire.get(); // 0.123...
> ```

---

## 4. API Stream

**Q7: Qu'est-ce qu'un Stream en Java 8?**
> **R:** C'est une séquence d'éléments qui supporte des opérations agrégées séquentielles ou parallèles. Ce n'est PAS une collection, mais une vue sur les données.

**Q8: Différence entre opérations intermédiaires et terminales?**
> **R:**
> | Intermédiaires | Terminales |
> |----------------|------------|
> | Retournent un Stream | Retournent un résultat ou void |
> | Lazy (exécution différée) | Déclenchent l'exécution |
> | Chaînables | Terminent le pipeline |
> | Ex: filter, map, sorted | Ex: collect, forEach, reduce |

**Q9: Quelles sont les opérations intermédiaires courantes?**
> **R:**
> ```java
> List<String> noms = Arrays.asList("Alice", "Bob", "Charlie", "David");
> 
> // filter - filtrer
> noms.stream().filter(n -> n.startsWith("A")); // Alice
> 
> // map - transformer
> noms.stream().map(String::toUpperCase); // ALICE, BOB...
> 
> // sorted - trier
> noms.stream().sorted(); // Alice, Bob, Charlie, David
> 
> // distinct - enlever doublons
> noms.stream().distinct();
> 
> // limit - limiter
> noms.stream().limit(2); // Alice, Bob
> 
> // skip - sauter
> noms.stream().skip(2); // Charlie, David
> 
> // flatMap - aplatir
> noms.stream().flatMap(n -> Arrays.stream(n.split("")));
> ```

**Q10: Quelles sont les opérations terminales courantes?**
> **R:**
> ```java
> List<Integer> nombres = Arrays.asList(1, 2, 3, 4, 5);
> 
> // forEach - itérer
> nombres.stream().forEach(System.out::println);
> 
> // collect - collecter
> List<Integer> pairs = nombres.stream()
>     .filter(n -> n % 2 == 0)
>     .collect(Collectors.toList());
> 
> // reduce - réduire
> int somme = nombres.stream().reduce(0, (a, b) -> a + b);
> 
> // count - compter
> long count = nombres.stream().count();
> 
> // findFirst / findAny
> Optional<Integer> premier = nombres.stream().findFirst();
> 
> // anyMatch / allMatch / noneMatch
> boolean tousPairs = nombres.stream().allMatch(n -> n % 2 == 0);
> 
> // min / max
> Optional<Integer> max = nombres.stream().max(Integer::compare);
> ```

**Q11: Qu'est-ce que Collectors?**
> **R:** Classe utilitaire avec des méthodes pour collecter les éléments d'un Stream.
> ```java
> // toList, toSet
> List<String> liste = stream.collect(Collectors.toList());
> 
> // toMap
> Map<Integer, String> map = stream
>     .collect(Collectors.toMap(String::length, s -> s));
> 
> // joining
> String concat = stream.collect(Collectors.joining(", "));
> 
> // groupingBy
> Map<Integer, List<String>> parLongueur = stream
>     .collect(Collectors.groupingBy(String::length));
> 
> // partitioningBy
> Map<Boolean, List<Integer>> partition = nombres.stream()
>     .collect(Collectors.partitioningBy(n -> n % 2 == 0));
> 
> // counting, summing, averaging
> long count = stream.collect(Collectors.counting());
> ```

**Q12: Différence entre Stream séquentiel et parallèle?**
> **R:**
> - **Séquentiel:** Traitement un par un, ordre garanti
> - **Parallèle:** Traitement multi-thread, plus rapide pour grandes collections
> ```java
> // Séquentiel
> list.stream().filter(...).collect(...);
> 
> // Parallèle
> list.parallelStream().filter(...).collect(...);
> // ou
> list.stream().parallel().filter(...).collect(...);
> ```

---

## 5. Optional

**Q13: Qu'est-ce qu'Optional?**
> **R:** C'est un conteneur qui peut contenir ou non une valeur non-null. Il évite les NullPointerException.

**Q14: Comment utiliser Optional?**
> **R:**
> ```java
> // Création
> Optional<String> vide = Optional.empty();
> Optional<String> present = Optional.of("valeur");
> Optional<String> nullable = Optional.ofNullable(valeurPeutEtreNull);
> 
> // Vérification
> if (opt.isPresent()) { ... }
> if (opt.isEmpty()) { ... } // Java 11+
> 
> // Récupération
> String val = opt.get(); // Attention: NoSuchElementException si vide
> String val = opt.orElse("défaut");
> String val = opt.orElseGet(() -> calculerDefaut());
> String val = opt.orElseThrow(() -> new Exception("Erreur"));
> 
> // Transformation
> Optional<Integer> longueur = opt.map(String::length);
> Optional<String> upper = opt.flatMap(s -> Optional.of(s.toUpperCase()));
> 
> // Filtrage
> Optional<String> filtre = opt.filter(s -> s.length() > 5);
> 
> // Action
> opt.ifPresent(System.out::println);
> opt.ifPresentOrElse(
>     s -> System.out.println(s),
>     () -> System.out.println("Vide")
> ); // Java 9+
> ```

---

## 6. Method References

**Q15: Qu'est-ce qu'une Method Reference?**
> **R:** C'est une syntaxe raccourcie pour les lambdas qui appellent une méthode existante.

**Q16: Quels sont les types de Method References?**
> **R:**
> ```java
> // 1. Référence à une méthode statique
> // ClassName::staticMethod
> Function<String, Integer> parse = Integer::parseInt;
> 
> // 2. Référence à une méthode d'instance sur un objet
> // object::instanceMethod
> String str = "Hello";
> Supplier<Integer> len = str::length;
> 
> // 3. Référence à une méthode d'instance sur un type
> // ClassName::instanceMethod
> Function<String, Integer> length = String::length;
> 
> // 4. Référence à un constructeur
> // ClassName::new
> Supplier<ArrayList<String>> newList = ArrayList::new;
> ```

---

## 7. Nouvelle API Date/Time

**Q17: Quelles sont les nouvelles classes Date/Time de Java 8?**
> **R:**
> ```java
> // LocalDate - date sans heure
> LocalDate date = LocalDate.now();
> LocalDate date = LocalDate.of(2024, 1, 15);
> 
> // LocalTime - heure sans date
> LocalTime time = LocalTime.now();
> LocalTime time = LocalTime.of(14, 30, 0);
> 
> // LocalDateTime - date et heure
> LocalDateTime dateTime = LocalDateTime.now();
> 
> // ZonedDateTime - avec fuseau horaire
> ZonedDateTime zdt = ZonedDateTime.now(ZoneId.of("Europe/Paris"));
> 
> // Period - période entre dates
> Period period = Period.between(date1, date2);
> 
> // Duration - durée entre temps
> Duration duration = Duration.between(time1, time2);
> 
> // DateTimeFormatter - formatage
> DateTimeFormatter formatter = DateTimeFormatter.ofPattern("dd/MM/yyyy");
> String formatted = date.format(formatter);
> ```

---

## 8. Méthodes par Défaut et Statiques

**Q18: Qu'est-ce qu'une méthode par défaut dans une interface?**
> **R:** C'est une méthode avec implémentation dans une interface, introduite avec le mot-clé `default`.
> ```java
> interface Vehicule {
>     void demarrer();
>     
>     default void klaxonner() {
>         System.out.println("Bip bip!");
>     }
> }
> ```

**Q19: Qu'est-ce qu'une méthode statique dans une interface?**
> **R:** C'est une méthode utilitaire appartenant à l'interface, appelée via le nom de l'interface.
> ```java
> interface Calculateur {
>     static int additionner(int a, int b) {
>         return a + b;
>     }
> }
> // Appel
> Calculateur.additionner(5, 3);
> ```

---

## 9. Exercices Pratiques

**Q20: Filtrer et transformer une liste avec Stream?**
> ```java
> List<String> noms = Arrays.asList("Alice", "Bob", "Charlie", "Anna");
> 
> List<String> resultat = noms.stream()
>     .filter(n -> n.startsWith("A"))
>     .map(String::toUpperCase)
>     .sorted()
>     .collect(Collectors.toList());
> // Résultat: [ALICE, ANNA]
> ```

**Q21: Grouper des éléments par critère?**
> ```java
> List<Personne> personnes = ...;
> 
> Map<String, List<Personne>> parVille = personnes.stream()
>     .collect(Collectors.groupingBy(Personne::getVille));
> ```

**Q22: Calculer des statistiques?**
> ```java
> List<Integer> nombres = Arrays.asList(1, 2, 3, 4, 5);
> 
> IntSummaryStatistics stats = nombres.stream()
>     .mapToInt(Integer::intValue)
>     .summaryStatistics();
> 
> stats.getSum();     // 15
> stats.getAverage(); // 3.0
> stats.getMax();     // 5
> stats.getMin();     // 1
> stats.getCount();   // 5
> ```

