# Questions et Réponses Spring Boot

---

## 1. Introduction à Spring Boot

**Q1: Qu'est-ce que Spring Boot?**
> **R:** C'est un projet Spring qui simplifie la création d'applications Spring en fournissant:
> - **Auto-configuration:** Configuration automatique basée sur les dépendances
> - **Starters:** Dépendances préconfigurées
> - **Serveur embarqué:** Tomcat, Jetty, Undertow intégrés
> - **Production-ready:** Métriques, health checks, etc.

**Q2: Différence entre Spring et Spring Boot?**
> **R:**
> | Spring | Spring Boot |
> |--------|-------------|
> | Configuration manuelle | Auto-configuration |
> | Beaucoup de XML/annotations | Convention over configuration |
> | Serveur externe requis | Serveur embarqué |
> | Setup complexe | Démarrage rapide |

**Q3: Quels sont les avantages de Spring Boot?**
> **R:**
> - Démarrage rapide d'un projet
> - Pas de configuration XML
> - Serveur embarqué
> - Gestion simplifiée des dépendances (starters)
> - Actuator pour monitoring
> - DevTools pour le développement

---

## 2. Annotations Spring Boot

**Q4: Qu'est-ce que @SpringBootApplication?**
> **R:** C'est une méta-annotation qui combine:
> ```java
> @SpringBootApplication
> // Équivalent à:
> @Configuration        // Classe de configuration
> @EnableAutoConfiguration  // Active l'auto-configuration
> @ComponentScan       // Scanne les composants
> ```

**Q5: Qu'est-ce que @EnableAutoConfiguration?**
> **R:** Active l'auto-configuration de Spring Boot basée sur les dépendances présentes dans le classpath. Par exemple, si spring-web est présent, configure automatiquement un serveur web.

**Q6: Comment exclure une auto-configuration?**
> **R:**
> ```java
> @SpringBootApplication(exclude = {DataSourceAutoConfiguration.class})
> public class Application { }
> 
> // Ou dans application.properties
> spring.autoconfigure.exclude=org.springframework.boot.autoconfigure.jdbc.DataSourceAutoConfiguration
> ```

---

## 3. Configuration et Properties

**Q7: Quels fichiers de configuration utilise Spring Boot?**
> **R:**
> - `application.properties` - Format clé=valeur
> - `application.yml` - Format YAML (hiérarchique)
> - Les deux peuvent coexister, .properties a priorité

**Q8: Comment définir des profils?**
> **R:**
> ```properties
> # application.properties
> spring.profiles.active=dev
> 
> # application-dev.properties
> server.port=8080
> 
> # application-prod.properties
> server.port=80
> ```
> ```yaml
> # application.yml
> spring:
>   profiles:
>     active: dev
> 
> ---
> spring:
>   config:
>     activate:
>       on-profile: dev
> server:
>   port: 8080
> ```

**Q9: Comment injecter des propriétés?**
> **R:**
> ```java
> // @Value - une propriété
> @Value("${app.name}")
> private String appName;
> 
> @Value("${app.timeout:30}")  // Valeur par défaut
> private int timeout;
> 
> // @ConfigurationProperties - groupe de propriétés
> @Component
> @ConfigurationProperties(prefix = "app")
> public class AppProperties {
>     private String name;
>     private int timeout;
>     // getters et setters
> }
> ```

---

## 4. Starters Spring Boot

**Q10: Qu'est-ce qu'un Starter?**
> **R:** C'est un ensemble de dépendances préconfigurées pour une fonctionnalité spécifique.

**Q11: Quels sont les starters courants?**
> **R:**
> | Starter | Description |
> |---------|-------------|
> | `spring-boot-starter-web` | Application web (REST) |
> | `spring-boot-starter-data-jpa` | JPA avec Hibernate |
> | `spring-boot-starter-security` | Sécurité |
> | `spring-boot-starter-test` | Tests (JUnit, Mockito) |
> | `spring-boot-starter-actuator` | Monitoring |
> | `spring-boot-starter-validation` | Validation des données |
> | `spring-boot-starter-cache` | Cache |
> | `spring-boot-starter-aop` | AOP |

---

## 5. Spring Boot Actuator

**Q12: Qu'est-ce que Spring Boot Actuator?**
> **R:** C'est un module qui fournit des fonctionnalités de monitoring et gestion pour les applications en production.

**Q13: Quels sont les endpoints Actuator courants?**
> **R:**
> | Endpoint | Description |
> |----------|-------------|
> | `/actuator/health` | État de santé de l'application |
> | `/actuator/info` | Informations sur l'application |
> | `/actuator/metrics` | Métriques (mémoire, CPU, etc.) |
> | `/actuator/env` | Variables d'environnement |
> | `/actuator/beans` | Liste des beans Spring |
> | `/actuator/mappings` | Mappings des URLs |
> | `/actuator/loggers` | Gestion des logs |

**Q14: Comment configurer Actuator?**
> **R:**
> ```properties
> # Exposer tous les endpoints
> management.endpoints.web.exposure.include=*
> 
> # Exposer certains endpoints
> management.endpoints.web.exposure.include=health,info,metrics
> 
> # Changer le chemin de base
> management.endpoints.web.base-path=/manage
> 
> # Détails du health check
> management.endpoint.health.show-details=always
> ```

---

## 6. Spring Data JPA

**Q15: Qu'est-ce que Spring Data JPA?**
> **R:** C'est un module qui simplifie l'accès aux données en fournissant une abstraction sur JPA avec des repositories.

**Q16: Comment créer un Repository?**
> **R:**
> ```java
> // Repository de base
> public interface UserRepository extends JpaRepository<User, Long> {
>     // Méthodes CRUD automatiques: save, findById, findAll, delete, etc.
> }
> 
> // Avec méthodes personnalisées
> public interface UserRepository extends JpaRepository<User, Long> {
>     
>     // Query Methods - générées automatiquement
>     List<User> findByName(String name);
>     List<User> findByNameAndAge(String name, int age);
>     List<User> findByNameContaining(String keyword);
>     List<User> findByAgeBetween(int min, int max);
>     List<User> findByActiveTrue();
>     Optional<User> findByEmail(String email);
>     
>     // @Query - JPQL personnalisé
>     @Query("SELECT u FROM User u WHERE u.email = ?1")
>     User findByEmailQuery(String email);
>     
>     @Query("SELECT u FROM User u WHERE u.name LIKE %:keyword%")
>     List<User> searchByName(@Param("keyword") String keyword);
>     
>     // Native Query
>     @Query(value = "SELECT * FROM users WHERE email = ?1", nativeQuery = true)
>     User findByEmailNative(String email);
> }
> ```

**Q17: Quelles sont les interfaces Repository?**
> **R:**
> | Interface | Description |
> |-----------|-------------|
> | `Repository<T, ID>` | Interface de base (marker) |
> | `CrudRepository<T, ID>` | CRUD basique |
> | `PagingAndSortingRepository<T, ID>` | Pagination et tri |
> | `JpaRepository<T, ID>` | Toutes les fonctionnalités JPA |

---

## 7. Validation

**Q18: Comment valider les données d'entrée?**
> **R:**
> ```java
> // DTO avec contraintes de validation
> public class UserDTO {
>     @NotNull(message = "Le nom est obligatoire")
>     @Size(min = 2, max = 50)
>     private String name;
>     
>     @Email(message = "Email invalide")
>     @NotBlank
>     private String email;
>     
>     @Min(18)
>     @Max(120)
>     private int age;
>     
>     @Pattern(regexp = "^[0-9]{10}$")
>     private String phone;
> }
> 
> // Contrôleur avec @Valid
> @PostMapping
> public ResponseEntity<User> createUser(@Valid @RequestBody UserDTO dto) {
>     // dto est validé automatiquement
> }
> ```

**Q19: Quelles sont les annotations de validation courantes?**
> **R:**
> | Annotation | Description |
> |------------|-------------|
> | `@NotNull` | Non null |
> | `@NotEmpty` | Non null et non vide |
> | `@NotBlank` | Non null, non vide, avec caractères |
> | `@Size(min, max)` | Taille min/max |
> | `@Min`, `@Max` | Valeur min/max |
> | `@Email` | Format email |
> | `@Pattern` | Expression régulière |
> | `@Past`, `@Future` | Date passée/future |
> | `@Positive`, `@Negative` | Nombre positif/négatif |

---

## 8. Sécurité (Spring Security)

**Q20: Qu'est-ce que Spring Security?**
> **R:** C'est un framework de sécurité qui fournit l'authentification, l'autorisation et la protection contre les attaques.

**Q21: Différence entre Authentification et Autorisation?**
> **R:**
> - **Authentification:** Vérifier l'identité (Qui êtes-vous?)
> - **Autorisation:** Vérifier les permissions (Que pouvez-vous faire?)

**Q22: Comment configurer Spring Security basique?**
> **R:**
> ```java
> @Configuration
> @EnableWebSecurity
> public class SecurityConfig {
>     
>     @Bean
>     public SecurityFilterChain filterChain(HttpSecurity http) throws Exception {
>         http
>             .csrf().disable()
>             .authorizeHttpRequests(auth -> auth
>                 .requestMatchers("/api/public/**").permitAll()
>                 .requestMatchers("/api/admin/**").hasRole("ADMIN")
>                 .anyRequest().authenticated()
>             )
>             .httpBasic();
>         return http.build();
>     }
>     
>     @Bean
>     public PasswordEncoder passwordEncoder() {
>         return new BCryptPasswordEncoder();
>     }
> }
> ```

---

## 9. Microservices et Résilience

**Q23: Qu'est-ce que le Circuit Breaker?**
> **R:** C'est un pattern de résilience qui empêche les appels répétés vers un service défaillant.
> 
> **Les 3 états:**
> - **CLOSED:** Normal, les appels passent
> - **OPEN:** Service défaillant, appels bloqués
> - **HALF-OPEN:** Test périodique pour vérifier si le service est rétabli

**Q24: Comment implémenter le Circuit Breaker avec Resilience4j?**
> **R:**
> ```java
> @Service
> public class UserService {
>     
>     @CircuitBreaker(name = "userService", fallbackMethod = "fallback")
>     public User getUser(Long id) {
>         return externalService.getUser(id);
>     }
>     
>     public User fallback(Long id, Exception ex) {
>         return new User("Default User");
>     }
> }
> ```
> ```properties
> # Configuration
> resilience4j.circuitbreaker.instances.userService.failure-rate-threshold=50
> resilience4j.circuitbreaker.instances.userService.wait-duration-in-open-state=10s
> resilience4j.circuitbreaker.instances.userService.sliding-window-size=10
> ```

**Q25: Quels sont les patterns de résilience?**
> **R:**
> | Pattern | Description |
> |---------|-------------|
> | **Circuit Breaker** | Coupe les appels vers un service défaillant |
> | **Retry** | Réessaie les appels échoués |
> | **Rate Limiter** | Limite le nombre d'appels |
> | **Bulkhead** | Isole les ressources |
> | **Time Limiter** | Définit un timeout |

---

## 10. Tests

**Q26: Comment tester une application Spring Boot?**
> **R:**
> ```java
> // Test d'intégration complet
> @SpringBootTest
> class ApplicationTests {
>     @Autowired
>     private UserService userService;
>     
>     @Test
>     void contextLoads() { }
> }
> 
> // Test de contrôleur avec MockMvc
> @WebMvcTest(UserController.class)
> class UserControllerTest {
>     @Autowired
>     private MockMvc mockMvc;
>     
>     @MockBean
>     private UserService userService;
>     
>     @Test
>     void getUser_ShouldReturnUser() throws Exception {
>         when(userService.getUser(1L)).thenReturn(new User("John"));
>         
>         mockMvc.perform(get("/api/users/1"))
>             .andExpect(status().isOk())
>             .andExpect(jsonPath("$.name").value("John"));
>     }
> }
> 
> // Test de repository
> @DataJpaTest
> class UserRepositoryTest {
>     @Autowired
>     private UserRepository repository;
>     
>     @Test
>     void findByEmail_ShouldReturnUser() {
>         User user = repository.save(new User("test@email.com"));
>         Optional<User> found = repository.findByEmail("test@email.com");
>         assertTrue(found.isPresent());
>     }
> }
> ```

**Q27: Quelles sont les annotations de test Spring Boot?**
> **R:**
> | Annotation | Description |
> |------------|-------------|
> | `@SpringBootTest` | Test d'intégration complet |
> | `@WebMvcTest` | Test des contrôleurs |
> | `@DataJpaTest` | Test des repositories |
> | `@MockBean` | Mock un bean Spring |
> | `@TestConfiguration` | Configuration de test |

---

## 11. DevTools et Bonnes Pratiques

**Q28: Qu'est-ce que Spring Boot DevTools?**
> **R:** Outils de développement qui offrent:
> - **Redémarrage automatique** à chaque modification
> - **LiveReload** du navigateur
> - **Désactivation du cache** des templates
> - **Remote debugging**

**Q29: Comment structurer un projet Spring Boot?**
> **R:**
> ```
> src/main/java/com/example/
> ├── Application.java          # Point d'entrée
> ├── config/                   # Configuration
> │   └── SecurityConfig.java
> ├── controller/               # Contrôleurs REST
> │   └── UserController.java
> ├── service/                  # Logique métier
> │   └── UserService.java
> ├── repository/               # Accès données
> │   └── UserRepository.java
> ├── model/                    # Entités JPA
> │   └── User.java
> ├── dto/                      # Data Transfer Objects
> │   └── UserDTO.java
> └── exception/                # Exceptions personnalisées
>     └── UserNotFoundException.java
> ```

**Q30: Quelles sont les bonnes pratiques Spring Boot?**
> **R:**
> - Utiliser l'injection par constructeur
> - Externaliser la configuration
> - Utiliser les profils pour les environnements
> - Valider les entrées avec `@Valid`
> - Gérer les exceptions globalement
> - Documenter l'API (Swagger/OpenAPI)
> - Écrire des tests unitaires et d'intégration
> - Utiliser Actuator pour le monitoring
> - Sécuriser les endpoints sensibles

