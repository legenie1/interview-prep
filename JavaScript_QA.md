# Questions et Réponses JavaScript

---

## 1. Fondamentaux

**Q1: Quels sont les types de données primitifs en JavaScript?**
> **R:** Il y a 7 types primitifs:
> - `string` — chaîne de caractères
> - `number` — nombre (entier ou flottant)
> - `boolean` — true/false
> - `null` — absence intentionnelle de valeur
> - `undefined` — variable déclarée mais non assignée
> - `symbol` — identifiant unique (ES6)
> - `bigint` — grands entiers (ES2020)

**Q2: Quelle est la différence entre `var`, `let` et `const`?**
> **R:**
> | | `var` | `let` | `const` |
> |---|-------|-------|---------|
> | Portée | Fonction | Bloc | Bloc |
> | Hoisting | Oui (initialisé à `undefined`) | Oui (zone morte temporelle) | Oui (zone morte temporelle) |
> | Réassignation | Oui | Oui | Non |
> | Redéclaration | Oui | Non | Non |
> ```js
> var x = 1;   // portée fonction
> let y = 2;   // portée bloc
> const z = 3; // portée bloc, non réassignable
> 
> if (true) {
>     var a = 10;   // accessible hors du bloc
>     let b = 20;   // non accessible hors du bloc
>     const c = 30; // non accessible hors du bloc
> }
> console.log(a); // 10
> console.log(b); // ReferenceError
> ```

**Q3: Quelle est la différence entre `==` et `===`?**
> **R:**
> - `==` (égalité faible) : compare les valeurs avec coercion de type
> - `===` (égalité stricte) : compare les valeurs ET les types
> ```js
> 5 == "5"    // true  (coercion)
> 5 === "5"   // false (types différents)
> null == undefined  // true
> null === undefined // false
> ```

**Q4: Qu'est-ce que le hoisting?**
> **R:** Le hoisting est le comportement de JavaScript qui déplace les déclarations (variables et fonctions) en haut de leur portée avant l'exécution.
> ```js
> console.log(x); // undefined (pas d'erreur grâce au hoisting)
> var x = 5;
> 
> console.log(y); // ReferenceError (zone morte temporelle)
> let y = 10;
> 
> saluer(); // "Bonjour" (la fonction est hoistée)
> function saluer() {
>     console.log("Bonjour");
> }
> ```

**Q5: Qu'est-ce qu'une closure (fermeture)?**
> **R:** Une closure est une fonction qui a accès aux variables de sa portée extérieure, même après que la fonction extérieure a terminé son exécution.
> ```js
> function compteur() {
>     let count = 0;
>     return {
>         incrementer: () => ++count,
>         obtenir: () => count
>     };
> }
> 
> const c = compteur();
> c.incrementer(); // 1
> c.incrementer(); // 2
> c.obtenir();     // 2
> ```

---

## 2. Fonctions

**Q6: Quels sont les différents types de fonctions?**
> **R:**
> ```js
> // 1. Déclaration de fonction
> function saluer(nom) {
>     return `Bonjour ${nom}`;
> }
> 
> // 2. Expression de fonction
> const saluer = function(nom) {
>     return `Bonjour ${nom}`;
> };
> 
> // 3. Arrow function (ES6)
> const saluer = (nom) => `Bonjour ${nom}`;
> 
> // 4. IIFE (Immediately Invoked Function Expression)
> (function() {
>     console.log("Exécution immédiate");
> })();
> ```

**Q7: Quelle est la différence entre une arrow function et une fonction classique?**
> **R:**
> | Arrow function | Fonction classique |
> |---|---|
> | Pas son propre `this` | Son propre `this` |
> | Pas de `arguments` | Objet `arguments` disponible |
> | Ne peut pas être constructeur (`new`) | Peut être constructeur |
> | Pas de `prototype` | A un `prototype` |
> ```js
> const obj = {
>     nom: "Alice",
>     saluerClassique: function() {
>         console.log(this.nom); // "Alice"
>     },
>     saluerArrow: () => {
>         console.log(this.nom); // undefined (this = contexte parent)
>     }
> };
> ```

**Q8: Qu'est-ce que `this` en JavaScript?**
> **R:** `this` fait référence au contexte d'exécution. Sa valeur dépend de la manière dont la fonction est appelée:
> ```js
> // 1. Global → window (navigateur) ou global (Node.js)
> console.log(this); // window
> 
> // 2. Méthode d'objet → l'objet
> const obj = {
>     nom: "Alice",
>     saluer() { console.log(this.nom); } // "Alice"
> };
> 
> // 3. Constructeur → la nouvelle instance
> function Personne(nom) { this.nom = nom; }
> const p = new Personne("Bob"); // this = p
> 
> // 4. call/apply/bind → l'objet spécifié
> function dire() { console.log(this.nom); }
> dire.call({ nom: "Charlie" }); // "Charlie"
> dire.apply({ nom: "Charlie" }); // "Charlie"
> const fn = dire.bind({ nom: "Charlie" });
> fn(); // "Charlie"
> ```

**Q9: Quelle est la différence entre `call`, `apply` et `bind`?**
> **R:**
> - `call(obj, arg1, arg2)` — appelle immédiatement avec des arguments séparés
> - `apply(obj, [arg1, arg2])` — appelle immédiatement avec un tableau d'arguments
> - `bind(obj, arg1)` — retourne une nouvelle fonction liée (pas d'appel immédiat)
> ```js
> function presenter(age, ville) {
>     console.log(`${this.nom}, ${age} ans, ${ville}`);
> }
> presenter.call({ nom: "Alice" }, 25, "Paris");
> presenter.apply({ nom: "Bob" }, [30, "Lyon"]);
> const fn = presenter.bind({ nom: "Charlie" }, 28);
> fn("Marseille");
> ```

---

## 3. Objets et Prototypes

**Q10: Comment fonctionne l'héritage prototypal?**
> **R:** Chaque objet en JS a un prototype interne (`__proto__`). Quand on accède à une propriété, JS remonte la chaîne des prototypes jusqu'à la trouver ou atteindre `null`.
> ```js
> const animal = {
>     respirer() { console.log("Je respire"); }
> };
> 
> const chien = Object.create(animal);
> chien.aboyer = function() { console.log("Woof!"); };
> 
> chien.aboyer();    // "Woof!" (propre méthode)
> chien.respirer();  // "Je respire" (hérité du prototype)
> ```

**Q11: Quelle est la différence entre spread et rest operator?**
> **R:** Même syntaxe `...` mais usage différent:
> ```js
> // Spread — décompose un itérable
> const arr1 = [1, 2, 3];
> const arr2 = [...arr1, 4, 5]; // [1, 2, 3, 4, 5]
> 
> const obj1 = { a: 1, b: 2 };
> const obj2 = { ...obj1, c: 3 }; // { a: 1, b: 2, c: 3 }
> 
> // Rest — regroupe les arguments restants
> function somme(...nombres) {
>     return nombres.reduce((a, b) => a + b, 0);
> }
> somme(1, 2, 3); // 6
> 
> const { a, ...reste } = { a: 1, b: 2, c: 3 };
> // a = 1, reste = { b: 2, c: 3 }
> ```

**Q12: Qu'est-ce que la déstructuration?**
> **R:**
> ```js
> // Déstructuration d'objet
> const personne = { nom: "Alice", age: 25, ville: "Paris" };
> const { nom, age, ville = "Inconnu" } = personne;
> 
> // Renommage
> const { nom: prenom } = personne;
> 
> // Déstructuration de tableau
> const [premier, deuxieme, ...reste] = [1, 2, 3, 4, 5];
> // premier = 1, deuxieme = 2, reste = [3, 4, 5]
> 
> // Dans les paramètres de fonction
> function afficher({ nom, age }) {
>     console.log(`${nom} a ${age} ans`);
> }
> afficher(personne);
> ```

---

## 4. Programmation Asynchrone

**Q13: Qu'est-ce qu'une callback?**
> **R:** C'est une fonction passée en argument à une autre fonction, pour être exécutée ultérieurement.
> ```js
> function chargerDonnees(url, callback) {
>     // Simulation d'appel async
>     setTimeout(() => {
>         const data = { id: 1, nom: "Alice" };
>         callback(null, data);
>     }, 1000);
> }
> 
> chargerDonnees("/api/user", (erreur, data) => {
>     if (erreur) console.error(erreur);
>     else console.log(data);
> });
> ```

**Q14: Qu'est-ce qu'une Promise?**
> **R:** Un objet représentant la complétion (ou l'échec) éventuelle d'une opération asynchrone. Elle a 3 états: **pending**, **fulfilled**, **rejected**.
> ```js
> // Création
> const maPromise = new Promise((resolve, reject) => {
>     const succes = true;
>     if (succes) resolve("Données reçues");
>     else reject("Erreur!");
> });
> 
> // Utilisation
> maPromise
>     .then(data => console.log(data))    // "Données reçues"
>     .catch(err => console.error(err))
>     .finally(() => console.log("Terminé"));
> 
> // Chaînage
> fetch("/api/user")
>     .then(res => res.json())
>     .then(data => console.log(data))
>     .catch(err => console.error(err));
> ```

**Q15: Quelles sont les méthodes statiques de Promise?**
> **R:**
> ```js
> // Promise.all — attend que TOUTES soient résolues
> Promise.all([p1, p2, p3]).then(resultats => {...});
> // Échoue si UNE échoue
> 
> // Promise.allSettled — attend que toutes soient terminées
> Promise.allSettled([p1, p2]).then(resultats => {
>     // [{status: 'fulfilled', value: ...}, {status: 'rejected', reason: ...}]
> });
> 
> // Promise.race — la première terminée (résolue OU rejetée)
> Promise.race([p1, p2]).then(premier => {...});
> 
> // Promise.any — la première résolue avec succès
> Promise.any([p1, p2]).then(premier => {...});
> // Échoue si TOUTES échouent
> ```

**Q16: Qu'est-ce que async/await?**
> **R:** Syntaxe simplifiée pour travailler avec les Promises. `async` déclare une fonction asynchrone, `await` attend la résolution d'une Promise.
> ```js
> async function chargerUtilisateur(id) {
>     try {
>         const response = await fetch(`/api/users/${id}`);
>         const data = await response.json();
>         return data;
>     } catch (erreur) {
>         console.error("Erreur:", erreur);
>         throw erreur;
>     }
> }
> 
> // Appel
> const user = await chargerUtilisateur(1);
> 
> // Parallèle
> const [users, posts] = await Promise.all([
>     fetch("/api/users").then(r => r.json()),
>     fetch("/api/posts").then(r => r.json())
> ]);
> ```

**Q17: Qu'est-ce que l'Event Loop?**
> **R:** C'est le mécanisme qui gère l'exécution asynchrone en JavaScript (mono-thread).
> - **Call Stack** — pile d'exécution des fonctions
> - **Web APIs** — setTimeout, fetch, DOM events (exécutés par le navigateur)
> - **Callback Queue (Task Queue)** — callbacks prêtes (setTimeout, events)
> - **Microtask Queue** — Promises, MutationObserver (priorité plus haute)
> ```js
> console.log("1");                    // Call Stack
> setTimeout(() => console.log("2"), 0); // Task Queue
> Promise.resolve().then(() => console.log("3")); // Microtask Queue
> console.log("4");
> // Sortie: 1, 4, 3, 2
> ```

---

## 5. Manipulation du DOM

**Q18: Comment sélectionner des éléments du DOM?**
> **R:**
> ```js
> // Par ID
> document.getElementById("monId");
> 
> // Par classe
> document.getElementsByClassName("maClasse");
> 
> // Par sélecteur CSS (premier trouvé)
> document.querySelector(".maClasse p");
> 
> // Par sélecteur CSS (tous)
> document.querySelectorAll("div.card");
> 
> // Par nom de balise
> document.getElementsByTagName("p");
> ```

**Q19: Comment manipuler des éléments du DOM?**
> **R:**
> ```js
> const el = document.querySelector("#monElement");
> 
> // Contenu
> el.textContent = "Nouveau texte";
> el.innerHTML = "<strong>HTML</strong>";
> 
> // Attributs
> el.setAttribute("data-id", "123");
> el.getAttribute("data-id");
> el.removeAttribute("data-id");
> 
> // Classes
> el.classList.add("active");
> el.classList.remove("active");
> el.classList.toggle("active");
> el.classList.contains("active");
> 
> // Style
> el.style.backgroundColor = "red";
> el.style.display = "none";
> 
> // Créer et ajouter
> const div = document.createElement("div");
> div.textContent = "Nouveau";
> document.body.appendChild(div);
> 
> // Supprimer
> el.remove();
> ```

**Q20: Comment gérer les événements?**
> **R:**
> ```js
> const btn = document.querySelector("#monBtn");
> 
> // addEventListener (recommandé)
> btn.addEventListener("click", (e) => {
>     console.log("Cliqué!", e.target);
> });
> 
> // Supprimer un listener
> function handler(e) { console.log("Cliqué!"); }
> btn.addEventListener("click", handler);
> btn.removeEventListener("click", handler);
> 
> // Event delegation (délégation)
> document.querySelector("#liste").addEventListener("click", (e) => {
>     if (e.target.matches("li")) {
>         console.log("Élément:", e.target.textContent);
>     }
> });
> 
> // Empêcher le comportement par défaut
> form.addEventListener("submit", (e) => {
>     e.preventDefault();
> });
> 
> // Arrêter la propagation
> el.addEventListener("click", (e) => {
>     e.stopPropagation();
> });
> ```

---

## 6. ES6+ Fonctionnalités Modernes

**Q21: Qu'est-ce que les template literals?**
> **R:** Chaînes de caractères avec backticks permettant l'interpolation et le multi-lignes.
> ```js
> const nom = "Alice";
> const age = 25;
> 
> // Interpolation
> const message = `Bonjour ${nom}, vous avez ${age} ans`;
> 
> // Multi-lignes
> const html = `
>     <div>
>         <h1>${nom}</h1>
>         <p>Age: ${age}</p>
>     </div>
> `;
> 
> // Expressions
> const prix = `Total: ${10 * 1.2}€`;
> 
> // Tagged template
> function emphasize(strings, ...values) {
>     return strings.reduce((result, str, i) => 
>         `${result}${str}<strong>${values[i] || ''}</strong>`, '');
> }
> emphasize`Bonjour ${nom}, age ${age}`;
> ```

**Q22: Qu'est-ce qu'un Map et un Set?**
> **R:**
> ```js
> // Map — collection de paires clé-valeur (clé de tout type)
> const map = new Map();
> map.set("nom", "Alice");
> map.set(42, "réponse");
> map.get("nom");       // "Alice"
> map.has(42);           // true
> map.delete(42);
> map.size;              // 1
> map.forEach((val, key) => console.log(key, val));
> 
> // Set — collection de valeurs uniques
> const set = new Set([1, 2, 3, 2, 1]);
> set.add(4);
> set.has(3);    // true
> set.delete(2);
> set.size;      // 3
> 
> // Dédoublonner un array
> const unique = [...new Set([1, 2, 2, 3, 3])]; // [1, 2, 3]
> ```

**Q23: Qu'est-ce que les modules ES6?**
> **R:**
> ```js
> // Export nommé (math.js)
> export const PI = 3.14;
> export function additionner(a, b) { return a + b; }
> 
> // Export par défaut
> export default class Calculateur { ... }
> 
> // Import nommé
> import { PI, additionner } from './math.js';
> 
> // Import par défaut
> import Calculateur from './math.js';
> 
> // Import tout
> import * as MathUtils from './math.js';
> 
> // Import dynamique (lazy loading)
> const module = await import('./math.js');
> ```

**Q24: Qu'est-ce que le chaînage optionnel et l'opérateur de coalescence nulle?**
> **R:**
> ```js
> // Optional chaining (?.) — accès sécurisé aux propriétés
> const user = { adresse: { ville: "Paris" } };
> const ville = user?.adresse?.ville;       // "Paris"
> const code = user?.adresse?.codePostal;   // undefined (pas d'erreur)
> const fn = user?.methode?.();             // undefined si methode n'existe pas
> 
> // Nullish coalescing (??) — valeur par défaut si null/undefined
> const nom = null ?? "Inconnu";      // "Inconnu"
> const age = 0 ?? 25;                // 0 (0 n'est pas null/undefined)
> const vide = "" ?? "défaut";        // "" (string vide n'est pas null/undefined)
> 
> // Comparaison avec ||
> const age2 = 0 || 25;   // 25 (|| traite 0 comme falsy)
> const age3 = 0 ?? 25;   // 0  (?? ne traite que null/undefined)
> ```

---

## 7. Classes ES6

**Q25: Comment fonctionnent les classes en JavaScript?**
> **R:**
> ```js
> class Personne {
>     // Propriété privée (ES2022)
>     #age;
> 
>     // Constructeur
>     constructor(nom, age) {
>         this.nom = nom;   // propriété publique
>         this.#age = age;  // propriété privée
>     }
> 
>     // Méthode
>     saluer() {
>         return `Bonjour, je suis ${this.nom}`;
>     }
> 
>     // Getter
>     get age() { return this.#age; }
> 
>     // Setter
>     set age(val) {
>         if (val < 0) throw new Error("Age invalide");
>         this.#age = val;
>     }
> 
>     // Méthode statique
>     static creer(nom, age) {
>         return new Personne(nom, age);
>     }
> }
> 
> // Héritage
> class Employe extends Personne {
>     constructor(nom, age, poste) {
>         super(nom, age); // appel au constructeur parent
>         this.poste = poste;
>     }
> 
>     saluer() {
>         return `${super.saluer()}, je suis ${this.poste}`;
>     }
> }
> 
> const emp = new Employe("Alice", 30, "Développeur");
> emp.saluer(); // "Bonjour, je suis Alice, je suis Développeur"
> ```

---

## 8. Gestion des Erreurs

**Q26: Comment gérer les erreurs en JavaScript?**
> **R:**
> ```js
> // try/catch/finally
> try {
>     const data = JSON.parse(texteInvalide);
> } catch (erreur) {
>     console.error("Type:", erreur.name);      // SyntaxError
>     console.error("Message:", erreur.message);
>     console.error("Stack:", erreur.stack);
> } finally {
>     console.log("Toujours exécuté");
> }
> 
> // Erreurs personnalisées
> class ValidationError extends Error {
>     constructor(message, champ) {
>         super(message);
>         this.name = "ValidationError";
>         this.champ = champ;
>     }
> }
> 
> throw new ValidationError("Email invalide", "email");
> 
> // Gestion d'erreurs async
> async function charger() {
>     try {
>         const res = await fetch("/api/data");
>         if (!res.ok) throw new Error(`HTTP ${res.status}`);
>         return await res.json();
>     } catch (err) {
>         console.error(err);
>     }
> }
> ```

---

## 9. Méthodes Array Importantes

**Q27: Quelles sont les méthodes de tableau essentielles?**
> **R:**
> ```js
> const nombres = [1, 2, 3, 4, 5];
> 
> // map — transformer chaque élément
> nombres.map(n => n * 2);         // [2, 4, 6, 8, 10]
> 
> // filter — filtrer
> nombres.filter(n => n > 3);      // [4, 5]
> 
> // reduce — réduire à une seule valeur
> nombres.reduce((acc, n) => acc + n, 0); // 15
> 
> // find — trouver le premier correspondant
> nombres.find(n => n > 3);        // 4
> 
> // findIndex — index du premier correspondant
> nombres.findIndex(n => n > 3);   // 3
> 
> // some — au moins un correspond?
> nombres.some(n => n > 4);        // true
> 
> // every — tous correspondent?
> nombres.every(n => n > 0);       // true
> 
> // includes — contient?
> nombres.includes(3);             // true
> 
> // flat — aplatir
> [[1, 2], [3, [4]]].flat(2);     // [1, 2, 3, 4]
> 
> // flatMap — map + flat
> [1, 2, 3].flatMap(n => [n, n * 2]); // [1, 2, 2, 4, 3, 6]
> 
> // sort — trier (mutable!)
> nombres.sort((a, b) => a - b);   // croissant
> nombres.sort((a, b) => b - a);   // décroissant
> 
> // slice — extraire (immutable)
> nombres.slice(1, 3);             // [2, 3]
> 
> // splice — modifier (mutable)
> nombres.splice(1, 2, 10, 20);   // supprime 2 à index 1, insère 10, 20
> ```

---

## 10. Concepts Avancés

**Q28: Qu'est-ce qu'un Proxy?**
> **R:** Objet qui enveloppe un autre objet et intercepte ses opérations (lecture, écriture, etc.).
> ```js
> const handler = {
>     get(cible, prop) {
>         return prop in cible ? cible[prop] : `Propriété ${prop} inexistante`;
>     },
>     set(cible, prop, valeur) {
>         if (typeof valeur !== 'string') throw new TypeError("String requis");
>         cible[prop] = valeur;
>         return true;
>     }
> };
> 
> const proxy = new Proxy({}, handler);
> proxy.nom = "Alice";
> console.log(proxy.nom);     // "Alice"
> console.log(proxy.inconnu); // "Propriété inconnu inexistante"
> ```

**Q29: Qu'est-ce que le debounce et le throttle?**
> **R:** Techniques pour limiter la fréquence d'exécution d'une fonction.
> ```js
> // Debounce — exécute après un délai d'inactivité
> function debounce(fn, delai) {
>     let timer;
>     return function(...args) {
>         clearTimeout(timer);
>         timer = setTimeout(() => fn.apply(this, args), delai);
>     };
> }
> input.addEventListener("input", debounce(rechercher, 300));
> 
> // Throttle — exécute au plus une fois par intervalle
> function throttle(fn, intervalle) {
>     let dernierAppel = 0;
>     return function(...args) {
>         const maintenant = Date.now();
>         if (maintenant - dernierAppel >= intervalle) {
>             dernierAppel = maintenant;
>             fn.apply(this, args);
>         }
>     };
> }
> window.addEventListener("scroll", throttle(gererScroll, 200));
> ```

**Q30: Qu'est-ce que le localStorage et le sessionStorage?**
> **R:**
> | | `localStorage` | `sessionStorage` |
> |---|---|---|
> | Durée | Persistant | Onglet/session |
> | Capacité | ~5-10 MB | ~5-10 MB |
> | Portée | Même origine | Même onglet |
> ```js
> // Stocker
> localStorage.setItem("nom", "Alice");
> localStorage.setItem("user", JSON.stringify({ id: 1, nom: "Alice" }));
> 
> // Lire
> const nom = localStorage.getItem("nom");
> const user = JSON.parse(localStorage.getItem("user"));
> 
> // Supprimer
> localStorage.removeItem("nom");
> localStorage.clear(); // tout supprimer
> ```
