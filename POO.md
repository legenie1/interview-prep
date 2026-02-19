## POO avec Java
<!-- Programmation Oriente Objets -->
- Polymorphisme: Capacite d'un objets a prendre plusieurs formes
    Overriding et Overloading

- Encapsulations:

---

## Questions et Reponses POO

### 1. Les 4 Piliers de la POO

**Q1: Quels sont les 4 piliers de la POO?**
> **R:** Encapsulation, Heritage, Polymorphisme, Abstraction

**Q2: Qu'est-ce que l'Encapsulation?**
> **R:** C'est le principe de cacher les details internes d'un objet et d'exposer uniquement ce qui est necessaire via des methodes publiques (getters/setters). On utilise les modificateurs d'acces: `private`, `protected`, `public`.

**Q3: Qu'est-ce que l'Heritage?**
> **R:** C'est le mecanisme qui permet a une classe (enfant/sous-classe) d'heriter des attributs et methodes d'une autre classe (parent/super-classe). En Java, on utilise le mot-cle `extends`.

**Q4: Qu'est-ce que le Polymorphisme?**
> **R:** C'est la capacite d'un objet a prendre plusieurs formes. Il existe deux types:
> - **Overloading (surcharge):** Meme nom de methode, parametres differents (compile-time)
> - **Overriding (redefinition):** Meme signature dans la sous-classe (runtime)

**Q5: Qu'est-ce que l'Abstraction?**
> **R:** C'est le principe de cacher les details d'implementation et montrer uniquement les fonctionnalites. On utilise les classes abstraites (`abstract`) et les interfaces.

---

### 2. Classes et Objets

**Q6: Quelle est la difference entre une classe et un objet?**
> **R:** 
> - **Classe:** C'est un modele/blueprint qui definit les attributs et methodes
> - **Objet:** C'est une instance concrete d'une classe

**Q7: Qu'est-ce qu'un constructeur?**
> **R:** C'est une methode speciale appelee lors de la creation d'un objet. Elle a le meme nom que la classe et n'a pas de type de retour.

**Q8: Qu'est-ce que le mot-cle `this`?**
> **R:** `this` fait reference a l'instance courante de la classe. Il est utilise pour distinguer les attributs de classe des parametres de methode.

**Q9: Qu'est-ce que le mot-cle `super`?**
> **R:** `super` fait reference a la classe parente. Il permet d'appeler le constructeur ou les methodes de la classe parente.

---

### 3. Modificateurs d'Acces

**Q10: Quels sont les 4 modificateurs d'acces en Java?**
> **R:**
> | Modificateur | Classe | Package | Sous-classe | Monde |<br />
> |--------------|--------|---------|-------------|-------|<br />
> | `private`  | Oui    | Non     | Non         | Non   |<br />
> | `default`    | Oui    | Oui     | Non         | Non   |<br />
> | `protected`  | Oui    | Oui     | Oui         | Non   |<br />
> | `public`     | Oui    | Oui     | Oui         | Oui   |<br />

---

### 4. Classe Abstraite vs Interface

**Q11: Quelle est la difference entre une classe abstraite et une interface?**
> **R:**
> | Classe Abstraite | Interface |<br />
> |------------------|-----------|<br />
> | Peut avoir des methodes concretes et abstraites | Toutes les methodes sont abstraites (avant Java 8) |<br />
> | Peut avoir des attributs d'instance | Uniquement des constantes (`public static final`) |<br />
> | Une classe ne peut heriter que d'une seule classe abstraite | Une classe peut implementer plusieurs interfaces |<br />
> | Mot-cle: `extends` | Mot-cle: `implements` |

**Q12: Quand utiliser une classe abstraite vs une interface?**
> **R:** 
> - **Classe abstraite:** Quand les classes partagent un comportement commun et un etat
> - **Interface:** Quand on veut definir un contrat sans lien d'heritage

---

### 5. Mots-cles Importants

**Q13: Qu'est-ce que le mot-cle `static`?**
> **R:** `static` indique que l'attribut ou la methode appartient a la classe et non a une instance. Il est partage par toutes les instances.

**Q14: Qu'est-ce que le mot-cle `final`?**
> **R:** 
> - Sur une **variable:** La valeur ne peut pas etre modifiee (constante)
> - Sur une **methode:** La methode ne peut pas etre redefinie (overriding)
> - Sur une **classe:** La classe ne peut pas etre heritee

**Q15: Qu'est-ce que le mot-cle `abstract`?**
> **R:** `abstract` indique qu'une classe ne peut pas etre instanciee ou qu'une methode n'a pas d'implementation et doit etre implementee par les sous-classes.

---

### 6. Concepts Avances

**Q16: Qu'est-ce que la composition vs l'heritage?**
> **R:**
> - **Heritage (IS-A):** "Un chien EST UN animal" - relation d'extension
> - **Composition (HAS-A):** "Une voiture A UN moteur" - relation de contenance
> Preferer la composition a l'heritage pour plus de flexibilite.

**Q17: Qu'est-ce que le couplage et la cohesion?**
> **R:**
> - **Couplage:** Degre de dependance entre les modules. On veut un **faible couplage**.
> - **Cohesion:** Degre de relation entre les elements d'un module. On veut une **forte cohesion**.

**Q18: Qu'est-ce qu'une classe immutable?**
> **R:** C'est une classe dont les instances ne peuvent pas etre modifiees apres creation. Exemple: `String` en Java. Pour creer une classe immutable:
> - Declarer la classe `final`
> - Tous les attributs `private final`
> - Pas de setters
> - Initialiser via le constructeur

---

### 7. Exemples de Code

**Q19: Exemple d'Overloading (Surcharge)?**
```java
public class Calculatrice {
    public int additionner(int a, int b) {
        return a + b;
    }
    
    public double additionner(double a, double b) {
        return a + b;
    }
    
    public int additionner(int a, int b, int c) {
        return a + b + c;
    }
}
```

**Q20: Exemple d'Overriding (Redefinition)?**
```java
class Animal {
    public void parler() {
        System.out.println("L'animal fait un son");
    }
}

class Chien extends Animal {
    @Override
    public void parler() {
        System.out.println("Le chien aboie");
    }
}
```

**Q21: Exemple d'Interface?**
```java
interface Vehicule {
    void demarrer();
    void arreter();
}

class Voiture implements Vehicule {
    @Override
    public void demarrer() {
        System.out.println("La voiture demarre");
    }
    
    @Override
    public void arreter() {
        System.out.println("La voiture s'arrete");
    }
}
```

---

### 8. Principes SOLID

**Q22: Que signifie SOLID?**
> **R:**
> - **S** - Single Responsibility: Une classe = une seule responsabilite
> - **O** - Open/Closed: Ouvert a l'extension, ferme a la modification
> - **L** - Liskov Substitution: Les sous-classes doivent pouvoir remplacer leurs classes parentes
> - **I** - Interface Segregation: Plusieurs interfaces specifiques plutot qu'une interface generale
> - **D** - Dependency Inversion: Dependre des abstractions, pas des implementations
