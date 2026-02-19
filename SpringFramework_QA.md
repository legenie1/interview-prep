# Questions et Réponses Spring Framework

---

## 1. Introduction à Spring

**Q1: Qu'est-ce que Spring Framework?**
> **R:** C'est un framework Java open-source qui fournit une infrastructure complète pour développer des applications Java. Il est basé sur deux concepts clés: **IoC (Inversion of Control)** et **AOP (Aspect-Oriented Programming)**.

**Q2: Quels sont les avantages de Spring?**
> **R:**
> - **Léger:** Faible empreinte mémoire
> - **IoC:** Gestion automatique des dépendances
> - **AOP:** Séparation des préoccupations transversales
> - **Modulaire:** Utiliser uniquement ce dont on a besoin
> - **Testable:** Facilite les tests unitaires
> - **Intégration:** Compatible avec de nombreux frameworks

---

## 2. IoC et Injection de Dépendances

**Q3: Qu'est-ce que l'IoC (Inversion of Control)?**
> **R:** C'est un principe où le contrôle de la création et gestion des objets est délégué au conteneur Spring au lieu d'être géré par le développeur. Le conteneur:
> 1. Scanne les classes annotées
> 2. Crée les BeanDefinitions
> 3. Instancie les beans
> 4. Injecte les dépendances
> 5. Applique les proxies
> 6. Gère le cycle de vie

**Q4: Qu'est-ce que l'Injection de Dépendances (DI)?**
> **R:** C'est une implémentation de l'IoC où les dépendances d'un objet sont fournies (injectées) par le conteneur plutôt que créées par l'objet lui-même.

**Q5: Quels sont les types d'injection de dépendances?**
> **R:**
> ```java
> // 1. Injection par constructeur (RECOMMANDÉE)
> @Component
> public class UserService {
>     private final UserRepository repository;
>     
>     @Autowired // Optionnel si un seul constructeur
>     public UserService(UserRepository repository) {
>         this.repository = repository;
>     }
> }
> 
> // 2. Injection par setter
> @Component
> public class UserService {
>     private UserRepository repository;
>     
>     @Autowired
>     public void setRepository(UserRepository repository) {
>         this.repository = repository;
>     }
> }
> 
> // 3. Injection par champ (NON RECOMMANDÉE)
> @Component
> public class UserService {
>     @Autowired
>     private UserRepository repository;
> }
> ```

**Q6: Pourquoi l'injection par constructeur est recommandée?**
> **R:**
> - Dépendances explicites et obligatoires
> - Immutabilité possible (champs `final`)
> - Facilite les tests unitaires
> - Détection des dépendances circulaires au démarrage

---

## 3. Conteneur Spring

**Q7: Différence entre BeanFactory et ApplicationContext?**
> **R:**
> | BeanFactory | ApplicationContext |<br />
> |-------------|-------------------|<br />
> | Interface de base | Étend BeanFactory |<br />
> | Lazy loading | Eager loading |<br />
> | Fonctionnalités minimales | Fonctionnalités avancées |<br />
> | | Gestion des événements |<br />
> | | Internationalisation (i18n) |<br />
> | | Intégration AOP |

**Q8: Qu'est-ce qu'un Bean Spring?**
> **R:** C'est un objet géré par le conteneur Spring IoC. Il est créé, configuré et assemblé par le conteneur.

**Q9: Quel est le cycle de vie d'un Bean?**
> **R:**
> 1. **Instanciation** - Création de l'objet
> 2. **Injection des dépendances** - Remplissage des propriétés
> 3. **BeanNameAware** - Si implémenté
> 4. **BeanFactoryAware** - Si implémenté
> 5. **@PostConstruct** - Méthode d'initialisation
> 6. **Bean prêt à l'usage**
> 7. **@PreDestroy** - Avant destruction
> 8. **Destruction du bean**

**Q10: Quels sont les scopes des beans?**
> **R:**
> | Scope | Description |<br />
> |-------|-------------|<br />
> | `singleton` | Une seule instance (défaut) |<br />
> | `prototype` | Nouvelle instance à chaque demande |<br />
> | `request` | Une instance par requête HTTP (Web) |<br />
> | `session` | Une instance par session HTTP (Web) |<br />
> | `application` | Une instance par ServletContext (Web) |

---

## 4. Annotations Stéréotypes

**Q11: Quelles sont les annotations stéréotypes Spring?**
> **R:**
> | Annotation | Rôle |<br />
> |------------|------|<br />
> | `@Component` | Composant générique |<br />
> | `@Service` | Couche service (logique métier) |<br />
> | `@Repository` | Couche d'accès aux données (DAO) |<br />
> | `@Controller` | Contrôleur MVC (renvoie une vue) |<br />
> | `@RestController` | Contrôleur REST (renvoie JSON/XML) |<br />
> | `@Configuration` | Classe de configuration |

**Q12: Différence entre @Component et @Bean?**
> **R:**
> | @Component | @Bean |<br />
> |------------|-------|<br />
> | Sur une classe | Sur une méthode |<br />
> | Détection automatique (scan) | Déclaration explicite |<br />
> | Pas de contrôle sur l'instanciation | Contrôle total |<br />
> | | Pour les classes tierces |

---

## 5. Configuration Spring

**Q13: Quels sont les types de configuration Spring?**
> **R:**
> ```java
> // 1. Configuration XML (ancienne)
> <bean id="userService" class="com.example.UserService"/>
> 
> // 2. Configuration Java (moderne)
> @Configuration
> public class AppConfig {
>     @Bean
>     public UserService userService() {
>         return new UserService();
>     }
> }
> 
> // 3. Configuration par annotations
> @Component
> public class UserService { }
> ```

**Q14: Qu'est-ce que @Autowired et @Qualifier?**
> **R:**
> - **@Autowired:** Injection automatique de dépendances
> - **@Qualifier:** Précise quel bean injecter quand plusieurs implémentations existent
> ```java
> @Autowired
> @Qualifier("emailNotification")
> private NotificationService notification;
> ```

**Q15: Qu'est-ce que @Primary?**
> **R:** Indique le bean par défaut quand plusieurs implémentations existent.
> ```java
> @Primary
> @Component
> public class EmailNotificationService implements NotificationService { }
> ```

---

## 6. AOP (Aspect-Oriented Programming)

**Q16: Qu'est-ce que l'AOP?**
> **R:** C'est un paradigme qui permet de séparer les préoccupations transversales (cross-cutting concerns) du code métier. Exemples: logging, sécurité, transactions.

**Q17: Quels sont les concepts clés de l'AOP?**
> **R:**
> - **Aspect:** Module qui encapsule un concern transversal
> - **Join Point:** Point d'exécution (méthode, exception)
> - **Advice:** Action à exécuter (before, after, around)
> - **Pointcut:** Expression qui sélectionne les join points
> - **Weaving:** Processus de liaison des aspects au code

**Q18: Quels sont les types d'Advice?**
> **R:**
> ```java
> @Aspect
> @Component
> public class LoggingAspect {
>     
>     // Avant l'exécution
>     @Before("execution(* com.example.service.*.*(..))")
>     public void logBefore(JoinPoint jp) { }
>     
>     // Après l'exécution (succès ou échec)
>     @After("execution(* com.example.service.*.*(..))")
>     public void logAfter(JoinPoint jp) { }
>     
>     // Après succès
>     @AfterReturning(pointcut = "...", returning = "result")
>     public void logAfterReturning(Object result) { }
>     
>     // Après exception
>     @AfterThrowing(pointcut = "...", throwing = "ex")
>     public void logAfterThrowing(Exception ex) { }
>     
>     // Autour (avant et après)
>     @Around("execution(* com.example.service.*.*(..))")
>     public Object logAround(ProceedingJoinPoint pjp) throws Throwable {
>         // Avant
>         Object result = pjp.proceed();
>         // Après
>         return result;
>     }
> }
> ```

---

## 7. Spring MVC

**Q19: Qu'est-ce que Spring MVC?**
> **R:** C'est un framework web basé sur le pattern MVC (Model-View-Controller) pour créer des applications web.

**Q20: Différence entre @Controller et @RestController?**
> **R:**
> | @Controller | @RestController |<br />
> |-------------|-----------------|<br />
> | Renvoie une vue (HTML) | Renvoie des données (JSON/XML) |<br />
> | Utilise ViewResolver | Utilise HttpMessageConverter |<br />
> | Nécessite @ResponseBody | @ResponseBody inclus |

**Q21: Quelles sont les annotations de mapping?**
> **R:**
> ```java
> @RestController
> @RequestMapping("/api/users")
> public class UserController {
>     
>     @GetMapping            // GET /api/users
>     @GetMapping("/{id}")   // GET /api/users/1
>     @PostMapping           // POST /api/users
>     @PutMapping("/{id}")   // PUT /api/users/1
>     @DeleteMapping("/{id}")// DELETE /api/users/1
>     @PatchMapping("/{id}") // PATCH /api/users/1
> }
> ```

**Q22: Quelles sont les annotations pour les paramètres?**
> **R:**
> ```java
> // @PathVariable - paramètre dans l'URL
> @GetMapping("/{id}")
> public User getUser(@PathVariable Long id) { }
> 
> // @RequestParam - paramètre de requête
> @GetMapping
> public List<User> getUsers(@RequestParam String name) { }
> 
> // @RequestBody - corps de la requête
> @PostMapping
> public User createUser(@RequestBody User user) { }
> 
> // @RequestHeader - en-tête HTTP
> @GetMapping
> public String get(@RequestHeader("Authorization") String token) { }
> ```

---

## 8. Gestion des Exceptions

**Q23: Comment gérer les exceptions dans Spring?**
> **R:**
> ```java
> // 1. @ExceptionHandler - dans un contrôleur
> @RestController
> public class UserController {
>     @ExceptionHandler(UserNotFoundException.class)
>     public ResponseEntity<String> handleNotFound(UserNotFoundException ex) {
>         return ResponseEntity.notFound().build();
>     }
> }
> 
> // 2. @ControllerAdvice - global pour tous les contrôleurs
> @ControllerAdvice
> public class GlobalExceptionHandler {
>     @ExceptionHandler(Exception.class)
>     public ResponseEntity<ErrorResponse> handleAll(Exception ex) {
>         return ResponseEntity.status(500).body(new ErrorResponse(ex.getMessage()));
>     }
> }
> 
> // 3. @RestControllerAdvice - @ControllerAdvice + @ResponseBody
> @RestControllerAdvice
> public class RestExceptionHandler {
>     @ExceptionHandler(UserNotFoundException.class)
>     public ErrorResponse handleNotFound(UserNotFoundException ex) {
>         return new ErrorResponse(ex.getMessage());
>     }
> }
> ```

**Q24: Différence entre @ControllerAdvice et @RestControllerAdvice?**
> **R:**
> | @ControllerAdvice | @RestControllerAdvice |<br />
> |-------------------|----------------------|<br />
> | Pour @Controller | Pour @RestController |<br />
> | Renvoie une vue | Renvoie JSON/XML |<br />
> | Nécessite @ResponseBody | @ResponseBody inclus |

---

## 9. Transactions

**Q25: Comment gérer les transactions avec Spring?**
> **R:**
> ```java
> @Service
> public class UserService {
>     
>     @Transactional
>     public void createUser(User user) {
>         // Toutes les opérations sont dans une transaction
>         userRepository.save(user);
>         emailService.sendWelcomeEmail(user);
>     }
>     
>     @Transactional(readOnly = true)
>     public User getUser(Long id) {
>         return userRepository.findById(id);
>     }
>     
>     @Transactional(
>         propagation = Propagation.REQUIRED,
>         isolation = Isolation.READ_COMMITTED,
>         rollbackFor = Exception.class,
>         timeout = 30
>     )
>     public void complexOperation() { }
> }
> ```

**Q26: Quels sont les niveaux de propagation des transactions?**
> **R:**
> | Propagation | Description |<br />
> |-------------|-------------|<br />
> | REQUIRED | Utilise la transaction existante ou en crée une (défaut) |<br />
> | REQUIRES_NEW | Crée toujours une nouvelle transaction |<br />
> | SUPPORTS | Utilise la transaction si elle existe, sinon non |<br />
> | NOT_SUPPORTED | Exécute sans transaction |<br />
> | MANDATORY | Transaction obligatoire, sinon exception |<br />
> | NEVER | Exception si une transaction existe |<br />
> | NESTED | Transaction imbriquée |

