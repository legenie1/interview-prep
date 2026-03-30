# Questions et Réponses React

---

## 1. Fondamentaux React

**Q1: Qu'est-ce que React?**
> **R:** React est une bibliothèque JavaScript (pas un framework) créée par Facebook pour construire des interfaces utilisateur. Elle utilise un **DOM virtuel** et une approche **déclarative** basée sur des **composants**.

**Q2: Qu'est-ce que le Virtual DOM?**
> **R:** C'est une représentation légère en mémoire du DOM réel. React compare le Virtual DOM actuel avec le précédent (algorithme de **diffing/reconciliation**), puis applique uniquement les modifications nécessaires au DOM réel — ce qui améliore les performances.
> ```
> State change → Nouveau Virtual DOM → Diff avec ancien → Mise à jour minimale du DOM réel
> ```

**Q3: Qu'est-ce que JSX?**
> **R:** JSX (JavaScript XML) est une extension syntaxique qui permet d'écrire du HTML dans du JavaScript. Il est transformé en appels `React.createElement()` par Babel.
> ```jsx
> // JSX
> const element = <h1 className="titre">Bonjour {nom}</h1>;
> 
> // Compilé en
> const element = React.createElement('h1', { className: 'titre' }, `Bonjour ${nom}`);
> ```
> **Règles JSX:**
> - `className` au lieu de `class`
> - `htmlFor` au lieu de `for`
> - Les expressions JS sont entre `{}`
> - Tout composant doit retourner un seul élément racine (ou `<Fragment>`)
> - Les balises auto-fermantes: `<img />`, `<br />`

**Q4: Quelle est la différence entre un composant fonctionnel et un composant classe?**
> **R:**
> ```jsx
> // Composant fonctionnel (recommandé)
> function Saluer({ nom }) {
>     return <h1>Bonjour {nom}</h1>;
> }
> 
> // Ou avec arrow function
> const Saluer = ({ nom }) => <h1>Bonjour {nom}</h1>;
> 
> // Composant classe (legacy)
> class Saluer extends React.Component {
>     render() {
>         return <h1>Bonjour {this.props.nom}</h1>;
>     }
> }
> ```
> | Fonctionnel | Classe |
> |---|---|
> | Plus simple et concis | Plus verbeux |
> | Utilise les Hooks | Utilise lifecycle methods |
> | Recommandé | Legacy |
> | Pas de `this` | `this.props`, `this.state` |

---

## 2. Props et State

**Q5: Qu'est-ce que les props?**
> **R:** Les props (propriétés) sont des données passées d'un composant parent à un composant enfant. Elles sont **en lecture seule** (immutables).
> ```jsx
> // Parent
> function App() {
>     return <Carte titre="React" description="Bibliothèque UI" />;
> }
> 
> // Enfant
> function Carte({ titre, description }) {
>     return (
>         <div>
>             <h2>{titre}</h2>
>             <p>{description}</p>
>         </div>
>     );
> }
> 
> // Props par défaut
> function Bouton({ texte = "Cliquer", couleur = "blue" }) {
>     return <button style={{ color: couleur }}>{texte}</button>;
> }
> 
> // Props children
> function Conteneur({ children }) {
>     return <div className="conteneur">{children}</div>;
> }
> <Conteneur><p>Contenu ici</p></Conteneur>
> ```

**Q6: Qu'est-ce que le state?**
> **R:** Le state est l'état interne d'un composant. Quand le state change, le composant se **re-render**.
> ```jsx
> import { useState } from 'react';
> 
> function Compteur() {
>     const [count, setCount] = useState(0);
> 
>     return (
>         <div>
>             <p>Compteur: {count}</p>
>             <button onClick={() => setCount(count + 1)}>+1</button>
>             <button onClick={() => setCount(prev => prev - 1)}>-1</button>
>         </div>
>     );
> }
> ```

**Q7: Quelle est la différence entre props et state?**
> **R:**
> | Props | State |
> |---|---|
> | Passées par le parent | Gérées en interne |
> | Immutables (lecture seule) | Mutables via setter |
> | Comme des paramètres de fonction | Comme des variables locales |
> | Flux de données descendant | Provoque un re-render |

**Q8: Pourquoi le state est-il immutable?**
> **R:** React détecte les changements par **comparaison de référence**. Modifier l'objet directement ne crée pas de nouvelle référence, donc React ne détecte pas le changement.
> ```jsx
> // ❌ MAUVAIS — mutation directe
> const [user, setUser] = useState({ nom: "Alice", age: 25 });
> user.age = 26;
> setUser(user); // React ne détecte pas le changement
> 
> // ✅ BON — nouvelle référence
> setUser({ ...user, age: 26 });
> 
> // ❌ MAUVAIS — mutation de tableau
> const [items, setItems] = useState([1, 2, 3]);
> items.push(4);
> setItems(items); // Ne fonctionne pas
> 
> // ✅ BON
> setItems([...items, 4]);
> ```

---

## 3. Hooks

**Q9: Qu'est-ce que les Hooks?**
> **R:** Les Hooks sont des fonctions qui permettent d'utiliser le state et d'autres fonctionnalités React dans les composants fonctionnels. Introduits en React 16.8.
> **Règles des Hooks:**
> - Appeler uniquement au **niveau supérieur** (pas dans des boucles, conditions)
> - Appeler uniquement dans des **composants fonctionnels** ou des **hooks personnalisés**

**Q10: Comment fonctionne useState?**
> **R:** Hook pour gérer l'état local d'un composant.
> ```jsx
> const [valeur, setValeur] = useState(valeurInitiale);
> 
> // Exemples
> const [nom, setNom] = useState("");
> const [items, setItems] = useState([]);
> const [user, setUser] = useState({ nom: "", age: 0 });
> 
> // Mise à jour fonctionnelle (quand la nouvelle valeur dépend de l'ancienne)
> setCount(prev => prev + 1);
> 
> // Initialisation paresseuse (calcul coûteux)
> const [data, setData] = useState(() => calculCoûteux());
> ```

**Q11: Comment fonctionne useEffect?**
> **R:** Hook pour gérer les **effets de bord** (appels API, abonnements, manipulation du DOM, timers).
> ```jsx
> import { useEffect, useState } from 'react';
> 
> function Composant() {
>     const [data, setData] = useState(null);
> 
>     // Exécuté après CHAQUE rendu
>     useEffect(() => {
>         console.log("Rendu effectué");
>     });
> 
>     // Exécuté UNE SEULE fois (montage)
>     useEffect(() => {
>         fetch("/api/data")
>             .then(res => res.json())
>             .then(setData);
>     }, []);
> 
>     // Exécuté quand `id` change
>     useEffect(() => {
>         fetch(`/api/users/${id}`)
>             .then(res => res.json())
>             .then(setData);
>     }, [id]);
> 
>     // Avec cleanup (démontage ou avant ré-exécution)
>     useEffect(() => {
>         const timer = setInterval(() => console.log("tick"), 1000);
>         return () => clearInterval(timer); // cleanup
>     }, []);
> }
> ```

**Q12: Quels sont les autres Hooks importants?**
> **R:**
> ```jsx
> // useContext — accéder au contexte
> const theme = useContext(ThemeContext);
> 
> // useRef — référence persistante (pas de re-render)
> const inputRef = useRef(null);
> inputRef.current.focus();
> 
> // useMemo — mémoriser un calcul coûteux
> const resultat = useMemo(() => calculCoûteux(data), [data]);
> 
> // useCallback — mémoriser une fonction
> const handleClick = useCallback(() => {
>     setCount(prev => prev + 1);
> }, []);
> 
> // useReducer — state complexe (alternative à useState)
> const [state, dispatch] = useReducer(reducer, initialState);
> 
> // useId — générer un ID unique (React 18)
> const id = useId();
> ```

**Q13: Comment fonctionne useReducer?**
> **R:** Alternative à `useState` pour une logique d'état complexe, inspiré de Redux.
> ```jsx
> // Reducer
> function reducer(state, action) {
>     switch (action.type) {
>         case 'INCREMENT':
>             return { ...state, count: state.count + 1 };
>         case 'DECREMENT':
>             return { ...state, count: state.count - 1 };
>         case 'RESET':
>             return { ...state, count: 0 };
>         default:
>             throw new Error(`Action inconnue: ${action.type}`);
>     }
> }
> 
> function Compteur() {
>     const [state, dispatch] = useReducer(reducer, { count: 0 });
> 
>     return (
>         <div>
>             <p>Count: {state.count}</p>
>             <button onClick={() => dispatch({ type: 'INCREMENT' })}>+</button>
>             <button onClick={() => dispatch({ type: 'DECREMENT' })}>-</button>
>             <button onClick={() => dispatch({ type: 'RESET' })}>Reset</button>
>         </div>
>     );
> }
> ```

**Q14: Comment créer un Hook personnalisé?**
> **R:** Un hook personnalisé est une fonction qui commence par `use` et peut utiliser d'autres hooks.
> ```jsx
> // Hook personnalisé pour fetch de données
> function useFetch(url) {
>     const [data, setData] = useState(null);
>     const [loading, setLoading] = useState(true);
>     const [error, setError] = useState(null);
> 
>     useEffect(() => {
>         const controller = new AbortController();
> 
>         async function fetchData() {
>             try {
>                 setLoading(true);
>                 const res = await fetch(url, { signal: controller.signal });
>                 const json = await res.json();
>                 setData(json);
>             } catch (err) {
>                 if (err.name !== 'AbortError') setError(err);
>             } finally {
>                 setLoading(false);
>             }
>         }
> 
>         fetchData();
>         return () => controller.abort();
>     }, [url]);
> 
>     return { data, loading, error };
> }
> 
> // Utilisation
> function UserList() {
>     const { data: users, loading, error } = useFetch("/api/users");
> 
>     if (loading) return <p>Chargement...</p>;
>     if (error) return <p>Erreur: {error.message}</p>;
>     return <ul>{users.map(u => <li key={u.id}>{u.nom}</li>)}</ul>;
> }
> ```

---

## 4. Gestion des Événements

**Q15: Comment gérer les événements en React?**
> **R:**
> ```jsx
> function Formulaire() {
>     const [texte, setTexte] = useState("");
> 
>     // Événement click
>     const handleClick = () => console.log("Cliqué!");
> 
>     // Événement avec paramètre
>     const handleSupprimer = (id) => console.log("Supprimer:", id);
> 
>     // Événement formulaire
>     const handleSubmit = (e) => {
>         e.preventDefault();
>         console.log("Soumis:", texte);
>     };
> 
>     return (
>         <form onSubmit={handleSubmit}>
>             <input
>                 value={texte}
>                 onChange={(e) => setTexte(e.target.value)}
>             />
>             <button type="submit">Envoyer</button>
>             <button onClick={handleClick}>Cliquer</button>
>             <button onClick={() => handleSupprimer(5)}>Supprimer</button>
>         </form>
>     );
> }
> ```

---

## 5. Rendu Conditionnel et Listes

**Q16: Comment faire du rendu conditionnel?**
> **R:**
> ```jsx
> function Composant({ estConnecte, role, messages }) {
>     return (
>         <div>
>             {/* Opérateur ternaire */}
>             {estConnecte ? <Profil /> : <Connexion />}
> 
>             {/* Opérateur && (court-circuit) */}
>             {messages.length > 0 && <Badge count={messages.length} />}
> 
>             {/* Conditions multiples */}
>             {role === 'admin' && <PanneauAdmin />}
>             {role === 'user' && <PanneauUser />}
> 
>             {/* Avec variable */}
>             {(() => {
>                 if (role === 'admin') return <PanneauAdmin />;
>                 if (role === 'user') return <PanneauUser />;
>                 return <Accueil />;
>             })()}
>         </div>
>     );
> }
> ```

**Q17: Comment afficher des listes?**
> **R:**
> ```jsx
> function ListeUtilisateurs({ utilisateurs }) {
>     return (
>         <ul>
>             {utilisateurs.map(user => (
>                 <li key={user.id}>
>                     {user.nom} — {user.email}
>                 </li>
>             ))}
>         </ul>
>     );
> }
> ```
> **Pourquoi la `key`?** React utilise les keys pour identifier les éléments et optimiser le re-render. Utiliser un **identifiant unique** (pas l'index du tableau!).
> ```jsx
> // ❌ MAUVAIS — index comme key
> {items.map((item, index) => <li key={index}>{item}</li>)}
> 
> // ✅ BON — ID unique comme key
> {items.map(item => <li key={item.id}>{item.nom}</li>)}
> ```

---

## 6. Context API

**Q18: Qu'est-ce que le Context API?**
> **R:** Le Context permet de partager des données entre composants sans passer par les props à chaque niveau (**prop drilling**).
> ```jsx
> import { createContext, useContext, useState } from 'react';
> 
> // 1. Créer le contexte
> const ThemeContext = createContext();
> 
> // 2. Provider — fournit la valeur
> function ThemeProvider({ children }) {
>     const [theme, setTheme] = useState("light");
> 
>     const toggleTheme = () => {
>         setTheme(prev => prev === "light" ? "dark" : "light");
>     };
> 
>     return (
>         <ThemeContext.Provider value={{ theme, toggleTheme }}>
>             {children}
>         </ThemeContext.Provider>
>     );
> }
> 
> // 3. Hook personnalisé pour consumer
> function useTheme() {
>     const context = useContext(ThemeContext);
>     if (!context) throw new Error("useTheme doit être dans ThemeProvider");
>     return context;
> }
> 
> // 4. Utilisation
> function App() {
>     return (
>         <ThemeProvider>
>             <Header />
>             <Main />
>         </ThemeProvider>
>     );
> }
> 
> function Header() {
>     const { theme, toggleTheme } = useTheme();
>     return (
>         <header className={theme}>
>             <button onClick={toggleTheme}>Changer thème</button>
>         </header>
>     );
> }
> ```

---

## 7. React Router

**Q19: Comment gérer le routing avec React Router?**
> **R:**
> ```jsx
> import { BrowserRouter, Routes, Route, Link, useParams, useNavigate } from 'react-router-dom';
> 
> function App() {
>     return (
>         <BrowserRouter>
>             <nav>
>                 <Link to="/">Accueil</Link>
>                 <Link to="/about">À propos</Link>
>                 <Link to="/users">Utilisateurs</Link>
>             </nav>
> 
>             <Routes>
>                 <Route path="/" element={<Accueil />} />
>                 <Route path="/about" element={<About />} />
>                 <Route path="/users" element={<Users />} />
>                 <Route path="/users/:id" element={<UserDetail />} />
>                 <Route path="*" element={<NotFound />} />
>             </Routes>
>         </BrowserRouter>
>     );
> }
> 
> // Paramètres d'URL
> function UserDetail() {
>     const { id } = useParams();
>     return <h1>Utilisateur #{id}</h1>;
> }
> 
> // Navigation programmatique
> function Formulaire() {
>     const navigate = useNavigate();
>     const handleSubmit = () => {
>         // ... sauvegarder
>         navigate("/users");
>     };
>     return <button onClick={handleSubmit}>Sauvegarder</button>;
> }
> ```

**Q20: Comment protéger des routes (route guard)?**
> **R:**
> ```jsx
> function RouteProtegee({ children }) {
>     const { estConnecte } = useAuth();
>     
>     if (!estConnecte) {
>         return <Navigate to="/login" replace />;
>     }
>     
>     return children;
> }
> 
> // Utilisation
> <Routes>
>     <Route path="/login" element={<Login />} />
>     <Route path="/dashboard" element={
>         <RouteProtegee>
>             <Dashboard />
>         </RouteProtegee>
>     } />
> </Routes>
> ```

---

## 8. Gestion d'État Globale

**Q21: Quelles sont les solutions de gestion d'état?**
> **R:**
> | Solution | Cas d'usage |
> |---|---|
> | `useState` | État local simple |
> | `useReducer` | État local complexe |
> | `Context API` | État partagé (peu fréquent) |
> | **Redux / Redux Toolkit** | État global complexe |
> | **Zustand** | État global simple |
> | **React Query / TanStack Query** | État serveur (cache API) |

**Q22: Comment fonctionne Redux Toolkit (RTK)?**
> **R:**
> ```jsx
> // store.js
> import { configureStore, createSlice } from '@reduxjs/toolkit';
> 
> // Slice = reducer + actions
> const counterSlice = createSlice({
>     name: 'counter',
>     initialState: { value: 0 },
>     reducers: {
>         increment: (state) => { state.value += 1; },
>         decrement: (state) => { state.value -= 1; },
>         incrementByAmount: (state, action) => {
>             state.value += action.payload;
>         }
>     }
> });
> 
> export const { increment, decrement, incrementByAmount } = counterSlice.actions;
> 
> export const store = configureStore({
>     reducer: { counter: counterSlice.reducer }
> });
> 
> // App.jsx — Provider
> import { Provider } from 'react-redux';
> <Provider store={store}><App /></Provider>
> 
> // Composant — useSelector + useDispatch
> import { useSelector, useDispatch } from 'react-redux';
> 
> function Compteur() {
>     const count = useSelector(state => state.counter.value);
>     const dispatch = useDispatch();
> 
>     return (
>         <div>
>             <p>{count}</p>
>             <button onClick={() => dispatch(increment())}>+</button>
>             <button onClick={() => dispatch(incrementByAmount(5))}>+5</button>
>         </div>
>     );
> }
> ```

---

## 9. Optimisation des Performances

**Q23: Comment optimiser les performances React?**
> **R:**
> ```jsx
> import { memo, useMemo, useCallback, lazy, Suspense } from 'react';
> 
> // 1. React.memo — empêche le re-render si les props n'ont pas changé
> const MonComposant = memo(function MonComposant({ nom }) {
>     return <p>{nom}</p>;
> });
> 
> // 2. useMemo — mémoriser une valeur calculée
> const listeFiltree = useMemo(() => {
>     return items.filter(item => item.actif);
> }, [items]);
> 
> // 3. useCallback — mémoriser une fonction
> const handleClick = useCallback(() => {
>     console.log("click");
> }, []);
> 
> // 4. Lazy loading de composants
> const PageAdmin = lazy(() => import('./pages/Admin'));
> 
> function App() {
>     return (
>         <Suspense fallback={<p>Chargement...</p>}>
>             <PageAdmin />
>         </Suspense>
>     );
> }
> ```

**Q24: Quand utiliser useMemo et useCallback?**
> **R:**
> - **useMemo** — quand un calcul est coûteux et ses dépendances changent rarement
> - **useCallback** — quand une fonction est passée en prop à un composant mémorisé (`memo`)
> - **Ne pas abuser** — la mémorisation a un coût. Utiliser uniquement quand il y a un vrai problème de performance.
> ```jsx
> // ✅ Utile — calcul coûteux
> const stats = useMemo(() => calculerStatistiques(data), [data]);
> 
> // ✅ Utile — évite le re-render de ListItem
> const handleDelete = useCallback((id) => {
>     setItems(prev => prev.filter(item => item.id !== id));
> }, []);
> <ListItem onDelete={handleDelete} /> // ListItem est memo()
> 
> // ❌ Inutile — calcul trivial
> const double = useMemo(() => count * 2, [count]);
> ```

---

## 10. Formulaires

**Q25: Comment gérer les formulaires en React?**
> **R:**
> ```jsx
> // Composant contrôlé (recommandé)
> function FormulaireControlé() {
>     const [form, setForm] = useState({ nom: "", email: "", message: "" });
>     const [errors, setErrors] = useState({});
> 
>     const handleChange = (e) => {
>         const { name, value } = e.target;
>         setForm(prev => ({ ...prev, [name]: value }));
>     };
> 
>     const validate = () => {
>         const newErrors = {};
>         if (!form.nom) newErrors.nom = "Nom requis";
>         if (!form.email.includes("@")) newErrors.email = "Email invalide";
>         setErrors(newErrors);
>         return Object.keys(newErrors).length === 0;
>     };
> 
>     const handleSubmit = (e) => {
>         e.preventDefault();
>         if (validate()) {
>             console.log("Soumis:", form);
>         }
>     };
> 
>     return (
>         <form onSubmit={handleSubmit}>
>             <input name="nom" value={form.nom} onChange={handleChange} />
>             {errors.nom && <span>{errors.nom}</span>}
> 
>             <input name="email" value={form.email} onChange={handleChange} />
>             {errors.email && <span>{errors.email}</span>}
> 
>             <textarea name="message" value={form.message} onChange={handleChange} />
> 
>             <button type="submit">Envoyer</button>
>         </form>
>     );
> }
> ```

**Q26: Comment gérer les formulaires avec React Hook Form?**
> **R:**
> ```jsx
> import { useForm } from 'react-hook-form';
> 
> function Formulaire() {
>     const { register, handleSubmit, formState: { errors } } = useForm();
> 
>     const onSubmit = (data) => console.log(data);
> 
>     return (
>         <form onSubmit={handleSubmit(onSubmit)}>
>             <input {...register("nom", { required: "Nom requis" })} />
>             {errors.nom && <span>{errors.nom.message}</span>}
> 
>             <input {...register("email", {
>                 required: "Email requis",
>                 pattern: {
>                     value: /^[^\s@]+@[^\s@]+\.[^\s@]+$/,
>                     message: "Email invalide"
>                 }
>             })} />
>             {errors.email && <span>{errors.email.message}</span>}
> 
>             <button type="submit">Envoyer</button>
>         </form>
>     );
> }
> ```

---

## 11. Appels API

**Q27: Comment faire des appels API en React?**
> **R:**
> ```jsx
> // Avec useEffect + fetch
> function UserList() {
>     const [users, setUsers] = useState([]);
>     const [loading, setLoading] = useState(true);
>     const [error, setError] = useState(null);
> 
>     useEffect(() => {
>         const controller = new AbortController();
> 
>         fetch("/api/users", { signal: controller.signal })
>             .then(res => {
>                 if (!res.ok) throw new Error(`Erreur ${res.status}`);
>                 return res.json();
>             })
>             .then(setUsers)
>             .catch(err => {
>                 if (err.name !== 'AbortError') setError(err);
>             })
>             .finally(() => setLoading(false));
> 
>         return () => controller.abort();
>     }, []);
> 
>     if (loading) return <p>Chargement...</p>;
>     if (error) return <p>Erreur: {error.message}</p>;
>     return <ul>{users.map(u => <li key={u.id}>{u.nom}</li>)}</ul>;
> }
> ```

**Q28: Comment utiliser TanStack Query (React Query)?**
> **R:**
> ```jsx
> import { useQuery, useMutation, useQueryClient, QueryClient, QueryClientProvider } from '@tanstack/react-query';
> 
> // Setup
> const queryClient = new QueryClient();
> <QueryClientProvider client={queryClient}><App /></QueryClientProvider>
> 
> // Lecture (GET)
> function UserList() {
>     const { data, isLoading, error } = useQuery({
>         queryKey: ['users'],
>         queryFn: () => fetch('/api/users').then(r => r.json())
>     });
> 
>     if (isLoading) return <p>Chargement...</p>;
>     if (error) return <p>Erreur</p>;
>     return <ul>{data.map(u => <li key={u.id}>{u.nom}</li>)}</ul>;
> }
> 
> // Écriture (POST/PUT/DELETE)
> function CreateUser() {
>     const queryClient = useQueryClient();
>     const mutation = useMutation({
>         mutationFn: (newUser) => fetch('/api/users', {
>             method: 'POST',
>             body: JSON.stringify(newUser),
>             headers: { 'Content-Type': 'application/json' }
>         }),
>         onSuccess: () => queryClient.invalidateQueries({ queryKey: ['users'] })
>     });
> 
>     return <button onClick={() => mutation.mutate({ nom: "Alice" })}>Créer</button>;
> }
> ```

---

## 12. Patterns et Bonnes Pratiques

**Q29: Quels sont les patterns React importants?**
> **R:**
> ```jsx
> // 1. Composition (au lieu d'héritage)
> function Layout({ sidebar, content }) {
>     return (
>         <div className="layout">
>             <aside>{sidebar}</aside>
>             <main>{content}</main>
>         </div>
>     );
> }
> <Layout sidebar={<Menu />} content={<Page />} />
> 
> // 2. Render Props
> function MouseTracker({ render }) {
>     const [pos, setPos] = useState({ x: 0, y: 0 });
>     // ... track mouse
>     return render(pos);
> }
> <MouseTracker render={({ x, y }) => <p>Position: {x}, {y}</p>} />
> 
> // 3. Higher-Order Component (HOC)
> function withAuth(Component) {
>     return function AuthenticatedComponent(props) {
>         const { user } = useAuth();
>         if (!user) return <Navigate to="/login" />;
>         return <Component {...props} user={user} />;
>     };
> }
> const ProtectedDashboard = withAuth(Dashboard);
> 
> // 4. Container/Presentational
> // Container: logique (données, état)
> function UserListContainer() {
>     const { data } = useFetch("/api/users");
>     return <UserListView users={data} />;
> }
> // Presentational: affichage (pur UI)
> function UserListView({ users }) {
>     return <ul>{users.map(u => <li key={u.id}>{u.nom}</li>)}</ul>;
> }
> ```

**Q30: Quelles sont les bonnes pratiques React?**
> **R:**
> 1. **Un composant = une responsabilité** — garder les composants petits
> 2. **Lever l'état** (*lift state up*) — placer le state au plus bas niveau commun
> 3. **Composants contrôlés** pour les formulaires
> 4. **Toujours utiliser des keys uniques** dans les listes
> 5. **Éviter les re-renders inutiles** — `memo`, `useMemo`, `useCallback`
> 6. **Extraire la logique** dans des hooks personnalisés
> 7. **Gérer les erreurs** avec Error Boundaries
> 8. **Typer ses props** avec TypeScript ou PropTypes
> 9. **Nommer clairement** — composants en PascalCase, hooks en `use*`
> 10. **Structure de dossiers** claire:
> ```
> src/
> ├── components/    # Composants réutilisables
> ├── pages/         # Pages/vues
> ├── hooks/         # Hooks personnalisés
> ├── context/       # Contextes
> ├── services/      # Appels API
> ├── utils/         # Fonctions utilitaires
> └── assets/        # Images, styles
> ```
