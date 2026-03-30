# Questions et Réponses Angular 8

---

## 1. Introduction à Angular

**Q1: Qu'est-ce qu'Angular?**
> **R:** C'est un framework front-end open-source développé par Google pour créer des applications web SPA (Single Page Application). Il utilise TypeScript et est basé sur une architecture de composants.

**Q2: Différence entre AngularJS et Angular (2+)?**
> **R:**
> | AngularJS (1.x) | Angular (2+) |
> |-----------------|--------------|
> | JavaScript | TypeScript |
> | Architecture MVC | Architecture composants |
> | Two-way binding (scope) | One-way binding par défaut |
> | Directives | Composants + Directives |
> | Plus lent | Plus rapide (Change Detection) |

**Q3: Quelles sont les nouveautés d'Angular 8?**
> **R:**
> - **Differential Loading:** Build séparé pour navigateurs modernes et anciens
> - **Lazy Loading avec import():** Syntaxe dynamique
> - **Ivy Renderer (preview):** Nouveau moteur de rendu
> - **Web Workers:** Support amélioré
> - **Bazel (preview):** Nouvel outil de build
> - **@angular/fire:** Intégration Firebase améliorée

---

## 2. Architecture Angular

**Q4: Qu'est-ce qu'un Module Angular?**
> **R:** C'est un conteneur qui regroupe des composants, directives, pipes et services liés. Chaque application a au minimum un module racine (`AppModule`).
> ```typescript
> @NgModule({
>   declarations: [AppComponent, HeaderComponent], // Composants, directives, pipes
>   imports: [BrowserModule, FormsModule],         // Modules importés
>   providers: [UserService],                      // Services
>   bootstrap: [AppComponent],                     // Composant racine
>   exports: [HeaderComponent]                     // Éléments exportés
> })
> export class AppModule { }
> ```

**Q5: Qu'est-ce qu'un Composant Angular?**
> **R:** C'est la brique de base de l'interface utilisateur. Il combine:
> - Un template HTML (vue)
> - Une classe TypeScript (logique)
> - Des styles CSS
> ```typescript
> @Component({
>   selector: 'app-user',
>   templateUrl: './user.component.html',
>   styleUrls: ['./user.component.css']
> })
> export class UserComponent {
>   name: string = 'John';
> }
> ```

**Q6: Quel est le cycle de vie d'un composant?**
> **R:**
> | Hook | Description |
> |------|-------------|
> | `ngOnChanges` | Appelé quand les @Input changent |
> | `ngOnInit` | Initialisation (après le constructeur) |
> | `ngDoCheck` | Détection de changements personnalisée |
> | `ngAfterContentInit` | Après projection du contenu |
> | `ngAfterContentChecked` | Après vérification du contenu |
> | `ngAfterViewInit` | Après initialisation de la vue |
> | `ngAfterViewChecked` | Après vérification de la vue |
> | `ngOnDestroy` | Avant destruction (cleanup) |

**Q7: Quelle est la différence entre constructor et ngOnInit?**
> **R:**
> | Constructor | ngOnInit |
> |-------------|----------|
> | Fonction TypeScript/JavaScript native | Hook du cycle de vie Angular |
> | Appelé lors de la création de l'instance | Appelé après l'initialisation des propriétés |
> | Utilisé pour l'injection de dépendances | Utilisé pour l'initialisation de la logique |
> | Les `@Input()` ne sont pas encore disponibles | Les `@Input()` sont disponibles |
> | Exécuté avant Angular | Exécuté par Angular |
> ```typescript
> @Component({ selector: 'app-user' })
> export class UserComponent implements OnInit {
>   @Input() userId: number;
>   user: User;
>   
>   // Constructor: Injection de dépendances uniquement
>   constructor(private userService: UserService) {
>     // ❌ this.userId est undefined ici
>     console.log(this.userId);  // undefined
>   }
>   
>   // ngOnInit: Logique d'initialisation
>   ngOnInit() {
>     // ✅ this.userId est disponible ici
>     console.log(this.userId);  // valeur reçue du parent
>     this.userService.getUser(this.userId).subscribe(
>       user => this.user = user
>     );
>   }
> }
> ```
> **Règle:** Utilisez le constructor uniquement pour l'injection de dépendances, et ngOnInit pour toute logique d'initialisation.

---

## 3. Data Binding

**Q8: Quels sont les types de data binding?**
> **R:**
> ```html
> <!-- 1. Interpolation (Component → View) -->
> <p>{{ name }}</p>
> 
> <!-- 2. Property Binding (Component → View) -->
> <img [src]="imageUrl">
> <button [disabled]="isDisabled">Click</button>
> 
> <!-- 3. Event Binding (View → Component) -->
> <button (click)="onClick()">Click</button>
> <input (keyup)="onKeyUp($event)">
> 
> <!-- 4. Two-Way Binding (Component ↔ View) -->
> <input [(ngModel)]="name">
> <!-- Équivalent à: -->
> <input [ngModel]="name" (ngModelChange)="name = $event">
> ```

**Q9: Différence entre Property Binding et Interpolation?**
> **R:**
> | Interpolation {{ }} | Property Binding [ ] |
> |---------------------|---------------------|
> | Uniquement pour les chaînes | Tous types de données |
> | `<p>{{ name }}</p>` | `<img [src]="imageUrl">` |
> | Pas pour les attributs booléens | Fonctionne avec les booléens |

---

## 4. Directives

**Q10: Qu'est-ce qu'une Directive?**
> **R:** C'est une classe qui modifie le comportement ou l'apparence des éléments DOM. Il existe 3 types:
> - **Composants:** Directives avec template
> - **Directives structurelles:** Modifient le DOM (*ngIf, *ngFor)
> - **Directives d'attributs:** Modifient l'apparence (ngClass, ngStyle)

**Q11: Quelles sont les directives structurelles principales?**
> **R:**
> ```html
> <!-- *ngIf - Condition -->
> <div *ngIf="isVisible">Visible</div>
> <div *ngIf="isLoggedIn; else loginTemplate">Bienvenue</div>
> <ng-template #loginTemplate>
>   <p>Veuillez vous connecter</p>
> </ng-template>
> 
> <!-- *ngFor - Boucle -->
> <li *ngFor="let item of items; let i = index; let first = first; let last = last">
>   {{ i }} - {{ item.name }}
> </li>
> 
> <!-- *ngSwitch - Switch -->
> <div [ngSwitch]="color">
>   <p *ngSwitchCase="'red'">Rouge</p>
>   <p *ngSwitchCase="'blue'">Bleu</p>
>   <p *ngSwitchDefault>Autre</p>
> </div>
> ```

**Q12: Quelles sont les directives d'attributs principales?**
> **R:**
> ```html
> <!-- ngClass - Classes CSS dynamiques -->
> <div [ngClass]="{'active': isActive, 'disabled': isDisabled}"></div>
> <div [ngClass]="['class1', 'class2']"></div>
> 
> <!-- ngStyle - Styles inline dynamiques -->
> <div [ngStyle]="{'color': textColor, 'font-size': fontSize + 'px'}"></div>
> 
> <!-- ngModel - Two-way binding (FormsModule requis) -->
> <input [(ngModel)]="name">
> ```

**Q13: Comment créer une directive personnalisée?**
> **R:**
> ```typescript
> @Directive({
>   selector: '[appHighlight]'
> })
> export class HighlightDirective {
>   @Input() appHighlight: string = 'yellow';
>   
>   constructor(private el: ElementRef) {}
>   
>   @HostListener('mouseenter') onMouseEnter() {
>     this.highlight(this.appHighlight);
>   }
>   
>   @HostListener('mouseleave') onMouseLeave() {
>     this.highlight('');
>   }
>   
>   private highlight(color: string) {
>     this.el.nativeElement.style.backgroundColor = color;
>   }
> }
> 
> // Utilisation
> <p appHighlight="lightblue">Texte surligné</p>
> ```

---

## 5. Services et Injection de Dépendances

**Q14: Qu'est-ce qu'un Service Angular?**
> **R:** C'est une classe qui encapsule la logique métier réutilisable (appels HTTP, validation, etc.). Il est injecté dans les composants via le système DI.
> ```typescript
> @Injectable({
>   providedIn: 'root'  // Singleton global
> })
> export class UserService {
>   private apiUrl = '/api/users';
>   
>   constructor(private http: HttpClient) {}
>   
>   getUsers(): Observable<User[]> {
>     return this.http.get<User[]>(this.apiUrl);
>   }
> }
> ```

**Q15: Qu'est-ce que l'Injection de Dépendances?**
> **R:** C'est un design pattern où les dépendances sont fournies à une classe plutôt que créées par celle-ci. Angular utilise un système d'injection hiérarchique.

**Q16: Quels sont les niveaux de providedIn?**
> **R:**
> ```typescript
> // 1. Root - Singleton global (recommandé)
> @Injectable({ providedIn: 'root' })
> 
> // 2. Module - Une instance par module
> @Injectable({ providedIn: UserModule })
> 
> // 3. Component - Une instance par composant
> @Component({
>   providers: [UserService]  // Instance locale
> })
> 
> // 4. any - Une instance par lazy-loaded module
> @Injectable({ providedIn: 'any' })
> ```

---

## 6. Pipes

**Q17: Qu'est-ce qu'un Pipe?**
> **R:** C'est une fonction de transformation de données dans le template.
> ```html
> <!-- Pipes intégrés -->
> {{ name | uppercase }}              <!-- JOHN -->
> {{ name | lowercase }}              <!-- john -->
> {{ name | titlecase }}              <!-- John -->
> {{ price | currency:'EUR' }}        <!-- €100.00 -->
> {{ date | date:'dd/MM/yyyy' }}      <!-- 17/02/2026 -->
> {{ value | number:'1.2-2' }}        <!-- 3.14 -->
> {{ text | slice:0:10 }}             <!-- 10 premiers caractères -->
> {{ object | json }}                 <!-- JSON formaté -->
> 
> <!-- Chaînage de pipes -->
> {{ name | uppercase | slice:0:5 }}
> ```

**Q18: Comment créer un Pipe personnalisé?**
> **R:**
> ```typescript
> @Pipe({
>   name: 'filter'
> })
> export class FilterPipe implements PipeTransform {
>   transform(items: any[], searchText: string): any[] {
>     if (!items || !searchText) return items;
>     return items.filter(item => 
>       item.name.toLowerCase().includes(searchText.toLowerCase())
>     );
>   }
> }
> 
> // Utilisation
> <li *ngFor="let item of items | filter:searchText">{{ item.name }}</li>
> ```

**Q19: Différence entre Pure et Impure Pipe?**
> **R:**
> | Pure Pipe (défaut) | Impure Pipe |
> |--------------------|-------------| 
> | Exécuté si input change | Exécuté à chaque cycle de détection |
> | Plus performant | Moins performant |
> | `pure: true` | `pure: false` |

---

## 7. Routing

**Q20: Comment configurer le routing?**
> **R:**
> ```typescript
> // app-routing.module.ts
> const routes: Routes = [
>   { path: '', redirectTo: '/home', pathMatch: 'full' },
>   { path: 'home', component: HomeComponent },
>   { path: 'users', component: UserListComponent },
>   { path: 'users/:id', component: UserDetailComponent },
>   { path: 'admin', component: AdminComponent, canActivate: [AuthGuard] },
>   { 
>     path: 'products', 
>     loadChildren: () => import('./products/products.module')
>       .then(m => m.ProductsModule)  // Lazy Loading
>   },
>   { path: '**', component: NotFoundComponent }  // Wildcard
> ];
> 
> @NgModule({
>   imports: [RouterModule.forRoot(routes)],
>   exports: [RouterModule]
> })
> export class AppRoutingModule { }
> ```

**Q21: Comment naviguer entre les routes?**
> **R:**
> ```html
> <!-- Navigation déclarative -->
> <a routerLink="/users">Users</a>
> <a [routerLink]="['/users', user.id]">User Detail</a>
> <a routerLink="/users" routerLinkActive="active">Users</a>
> 
> <!-- Router Outlet -->
> <router-outlet></router-outlet>
> ```
> ```typescript
> // Navigation programmatique
> constructor(private router: Router) {}
> 
> goToUsers() {
>   this.router.navigate(['/users']);
>   // Avec paramètres
>   this.router.navigate(['/users', userId]);
>   // Avec query params
>   this.router.navigate(['/users'], { queryParams: { page: 1 } });
> }
> ```

**Q22: Comment récupérer les paramètres de route?**
> **R:**
> ```typescript
> constructor(private route: ActivatedRoute) {}
> 
> ngOnInit() {
>   // Snapshot (valeur initiale)
>   const id = this.route.snapshot.paramMap.get('id');
>   
>   // Observable (changements)
>   this.route.paramMap.subscribe(params => {
>     this.userId = params.get('id');
>   });
>   
>   // Query params
>   this.route.queryParamMap.subscribe(params => {
>     this.page = params.get('page');
>   });
> }
> ```

**Q23: Qu'est-ce qu'un Guard?**
> **R:** C'est une classe qui contrôle l'accès aux routes.
> ```typescript
> @Injectable({ providedIn: 'root' })
> export class AuthGuard implements CanActivate {
>   constructor(private authService: AuthService, private router: Router) {}
>   
>   canActivate(
>     route: ActivatedRouteSnapshot,
>     state: RouterStateSnapshot
>   ): boolean | Observable<boolean> {
>     if (this.authService.isLoggedIn()) {
>       return true;
>     }
>     this.router.navigate(['/login']);
>     return false;
>   }
> }
> ```

**Q24: Quels sont les types de Guards?**
> **R:**
> | Guard | Description |
> |-------|-------------|
> | `CanActivate` | Peut activer la route? |
> | `CanActivateChild` | Peut activer les routes enfants? |
> | `CanDeactivate` | Peut quitter la route? |
> | `CanLoad` | Peut charger le module lazy? |
> | `Resolve` | Résout les données avant activation |

---

## 8. HTTP et Observables

**Q25: Comment faire des appels HTTP?**
> **R:**
> ```typescript
> // app.module.ts
> import { HttpClientModule } from '@angular/common/http';
> 
> @NgModule({
>   imports: [HttpClientModule]
> })
> 
> // user.service.ts
> @Injectable({ providedIn: 'root' })
> export class UserService {
>   private apiUrl = 'https://api.example.com/users';
>   
>   constructor(private http: HttpClient) {}
>   
>   // GET
>   getUsers(): Observable<User[]> {
>     return this.http.get<User[]>(this.apiUrl);
>   }
>   
>   // GET by ID
>   getUser(id: number): Observable<User> {
>     return this.http.get<User>(`${this.apiUrl}/${id}`);
>   }
>   
>   // POST
>   createUser(user: User): Observable<User> {
>     return this.http.post<User>(this.apiUrl, user);
>   }
>   
>   // PUT
>   updateUser(user: User): Observable<User> {
>     return this.http.put<User>(`${this.apiUrl}/${user.id}`, user);
>   }
>   
>   // DELETE
>   deleteUser(id: number): Observable<void> {
>     return this.http.delete<void>(`${this.apiUrl}/${id}`);
>   }
> }
> ```

**Q26: Qu'est-ce qu'un Observable?**
> **R:** C'est un flux de données asynchrone (de RxJS). Il peut émettre plusieurs valeurs au fil du temps.
> ```typescript
> // Création
> const obs$ = new Observable(subscriber => {
>   subscriber.next('Hello');
>   subscriber.next('World');
>   subscriber.complete();
> });
> 
> // Souscription
> obs$.subscribe({
>   next: value => console.log(value),
>   error: err => console.error(err),
>   complete: () => console.log('Terminé')
> });
> ```

**Q27: Quels sont les opérateurs RxJS courants?**
> **R:**
> ```typescript
> import { map, filter, tap, catchError, switchMap, debounceTime } from 'rxjs/operators';
> 
> // map - Transformer les valeurs
> this.http.get<User[]>(url).pipe(
>   map(users => users.filter(u => u.active))
> );
> 
> // filter - Filtrer les émissions
> obs$.pipe(filter(x => x > 10));
> 
> // tap - Effet secondaire (debug)
> obs$.pipe(tap(value => console.log(value)));
> 
> // catchError - Gérer les erreurs
> this.http.get(url).pipe(
>   catchError(error => {
>     console.error(error);
>     return of([]);  // Valeur par défaut
>   })
> );
> 
> // switchMap - Chaîner les observables
> this.route.paramMap.pipe(
>   switchMap(params => this.userService.getUser(params.get('id')))
> );
> 
> // debounceTime - Attendre avant d'émettre
> searchInput$.pipe(debounceTime(300));
> ```

**Q28: Différence entre Observable et Promise?**
> **R:**
> | Observable | Promise |
> |------------|---------|
> | Plusieurs valeurs | Une seule valeur |
> | Lazy (exécuté à la souscription) | Eager (exécuté immédiatement) |
> | Annulable | Non annulable |
> | Opérateurs RxJS | async/await |

**Q29: Qu'est-ce qu'un Subject?**
> **R:** C'est un type spécial d'Observable qui permet d'émettre des valeurs à plusieurs souscripteurs (multicast). Il agit à la fois comme Observable et Observer.
> ```typescript
> import { Subject } from 'rxjs';
> 
> const subject = new Subject<string>();
> 
> // Souscription 1
> subject.subscribe(value => console.log('Sub 1:', value));
> 
> // Souscription 2
> subject.subscribe(value => console.log('Sub 2:', value));
> 
> // Émission de valeurs
> subject.next('Hello');    // Sub 1: Hello, Sub 2: Hello
> subject.next('World');    // Sub 1: World, Sub 2: World
> subject.complete();       // Termine le Subject
> ```

**Q30: Qu'est-ce qu'un BehaviorSubject?**
> **R:** C'est un Subject qui stocke la dernière valeur émise et la fournit immédiatement à tout nouveau souscripteur. Il nécessite une valeur initiale.
> ```typescript
> import { BehaviorSubject } from 'rxjs';
> 
> const behaviorSubject = new BehaviorSubject<string>('Initial Value');
> 
> // Souscription 1 - reçoit immédiatement 'Initial Value'
> behaviorSubject.subscribe(value => console.log('Sub 1:', value));
> 
> behaviorSubject.next('Hello');  // Sub 1: Hello
> 
> // Souscription 2 - reçoit immédiatement 'Hello' (dernière valeur)
> behaviorSubject.subscribe(value => console.log('Sub 2:', value));
> 
> behaviorSubject.next('World');  // Sub 1: World, Sub 2: World
> 
> // Accès à la valeur actuelle sans souscrire
> console.log(behaviorSubject.getValue());  // 'World'
> ```

**Q31: Quels sont les différents types de Subjects?**
> **R:**
> | Type | Description | Cas d'utilisation |
> |------|-------------|-------------------|
> | `Subject` | Multicast basique, pas de valeur initiale | Événements simples |
> | `BehaviorSubject` | Stocke la dernière valeur, valeur initiale requise | État de l'application |
> | `ReplaySubject` | Rejoue N dernières valeurs aux nouveaux souscripteurs | Historique de valeurs |
> | `AsyncSubject` | Émet uniquement la dernière valeur à la completion | Requêtes HTTP simulées |
> ```typescript
> import { ReplaySubject, AsyncSubject } from 'rxjs';
> 
> // ReplaySubject - rejoue les 2 dernières valeurs
> const replaySubject = new ReplaySubject<number>(2);
> replaySubject.next(1);
> replaySubject.next(2);
> replaySubject.next(3);
> replaySubject.subscribe(v => console.log(v));  // 2, 3
> 
> // AsyncSubject - émet seulement à la fin
> const asyncSubject = new AsyncSubject<string>();
> asyncSubject.next('A');
> asyncSubject.next('B');
> asyncSubject.subscribe(v => console.log(v));
> asyncSubject.complete();  // 'B' (dernière valeur)
> ```

**Q31: Comment utiliser BehaviorSubject dans un Service pour gérer l'état?**
> **R:**
> ```typescript
> @Injectable({ providedIn: 'root' })
> export class AuthService {
>   private currentUserSubject = new BehaviorSubject<User | null>(null);
>   currentUser$ = this.currentUserSubject.asObservable();
>   
>   get currentUserValue(): User | null {
>     return this.currentUserSubject.getValue();
>   }
>   
>   login(credentials: { email: string; password: string }): Observable<User> {
>     return this.http.post<User>('/api/login', credentials).pipe(
>       tap(user => this.currentUserSubject.next(user))
>     );
>   }
>   
>   logout(): void {
>     this.currentUserSubject.next(null);
>   }
>   
>   isLoggedIn(): boolean {
>     return this.currentUserValue !== null;
>   }
> }
> 
> // Utilisation dans un composant
> @Component({ ... })
> export class HeaderComponent implements OnInit {
>   currentUser$: Observable<User | null>;
>   
>   constructor(private authService: AuthService) {
>     this.currentUser$ = this.authService.currentUser$;
>   }
> }
> 
> // Dans le template avec async pipe
> <div *ngIf="currentUser$ | async as user">
>   Bienvenue {{ user.name }}
> </div>
> ```

**Q32: Différence entre Subject et BehaviorSubject?**
> **R:**
> | Subject | BehaviorSubject |
> |---------|-----------------|
> | Pas de valeur initiale | Valeur initiale requise |
> | Nouveaux souscripteurs ne reçoivent rien | Nouveaux souscripteurs reçoivent la dernière valeur |
> | Pas d'accès à la valeur courante | `getValue()` disponible |
> | Pour les événements | Pour l'état de l'application |

---

## 9. Formulaires

**Q33: Quels sont les types de formulaires Angular?**
> **R:**
> - **Template-driven:** Logique dans le template (FormsModule)
> - **Reactive (Model-driven):** Logique dans la classe (ReactiveFormsModule)

**Q34: Comment créer un formulaire Template-driven?**
> **R:**
> ```html
> <!-- FormsModule requis -->
> <form #userForm="ngForm" (ngSubmit)="onSubmit(userForm)">
>   <input name="name" [(ngModel)]="user.name" required #nameInput="ngModel">
>   <div *ngIf="nameInput.invalid && nameInput.touched">
>     Nom requis
>   </div>
>   
>   <input name="email" [(ngModel)]="user.email" required email>
>   
>   <button type="submit" [disabled]="userForm.invalid">Envoyer</button>
> </form>
> ```

**Q35: Comment créer un formulaire Reactive?**
> **R:**
> ```typescript
> // ReactiveFormsModule requis
> import { FormGroup, FormControl, Validators, FormBuilder } from '@angular/forms';
> 
> export class UserFormComponent implements OnInit {
>   userForm: FormGroup;
>   
>   constructor(private fb: FormBuilder) {}
>   
>   ngOnInit() {
>     // Avec FormBuilder (recommandé)
>     this.userForm = this.fb.group({
>       name: ['', [Validators.required, Validators.minLength(2)]],
>       email: ['', [Validators.required, Validators.email]],
>       password: ['', [Validators.required, Validators.minLength(6)]],
>       address: this.fb.group({
>         street: [''],
>         city: ['']
>       })
>     });
>     
>     // Ou manuellement
>     this.userForm = new FormGroup({
>       name: new FormControl('', Validators.required),
>       email: new FormControl('', [Validators.required, Validators.email])
>     });
>   }
>   
>   onSubmit() {
>     if (this.userForm.valid) {
>       console.log(this.userForm.value);
>     }
>   }
>   
>   // Accès aux contrôles
>   get name() { return this.userForm.get('name'); }
> }
> ```
> ```html
> <form [formGroup]="userForm" (ngSubmit)="onSubmit()">
>   <input formControlName="name">
>   <div *ngIf="name.invalid && name.touched">
>     <span *ngIf="name.errors.required">Nom requis</span>
>     <span *ngIf="name.errors.minlength">Min 2 caractères</span>
>   </div>
>   
>   <input formControlName="email">
>   
>   <div formGroupName="address">
>     <input formControlName="street">
>     <input formControlName="city">
>   </div>
>   
>   <button type="submit" [disabled]="userForm.invalid">Envoyer</button>
> </form>
> ```

---

## 10. Communication entre Composants

**Q36: Comment communiquer du Parent vers l'Enfant?**
> **R:** Avec `@Input()`
> ```typescript
> // Enfant
> @Component({ selector: 'app-child' })
> export class ChildComponent {
>   @Input() message: string;
>   @Input('alias') data: any;  // Avec alias
> }
> 
> // Parent
> <app-child [message]="parentMessage" [alias]="parentData"></app-child>
> ```

**Q37: Comment communiquer de l'Enfant vers le Parent?**
> **R:** Avec `@Output()` et `EventEmitter`
> ```typescript
> // Enfant
> @Component({ selector: 'app-child' })
> export class ChildComponent {
>   @Output() notify = new EventEmitter<string>();
>   
>   sendMessage() {
>     this.notify.emit('Hello from child');
>   }
> }
> 
> // Parent
> <app-child (notify)="onNotify($event)"></app-child>
> 
> onNotify(message: string) {
>   console.log(message);
> }
> ```

**Q38: Comment communiquer entre composants non liés?**
> **R:** Avec un Service partagé et Subject
> ```typescript
> @Injectable({ providedIn: 'root' })
> export class MessageService {
>   private messageSubject = new Subject<string>();
>   message$ = this.messageSubject.asObservable();
>   
>   sendMessage(message: string) {
>     this.messageSubject.next(message);
>   }
> }
> 
> // Composant émetteur
> this.messageService.sendMessage('Hello');
> 
> // Composant récepteur
> this.messageService.message$.subscribe(msg => console.log(msg));
> ```

---

## 11. Intercepteurs HTTP

**Q39: Qu'est-ce qu'un Intercepteur HTTP?**
> **R:** C'est une classe qui intercepte les requêtes/réponses HTTP pour les modifier (ajout de headers, logging, gestion d'erreurs).
> ```typescript
> @Injectable()
> export class AuthInterceptor implements HttpInterceptor {
>   
>   constructor(private authService: AuthService) {}
>   
>   intercept(req: HttpRequest<any>, next: HttpHandler): Observable<HttpEvent<any>> {
>     const token = this.authService.getToken();
>     
>     if (token) {
>       const clonedReq = req.clone({
>         headers: req.headers.set('Authorization', `Bearer ${token}`)
>       });
>       return next.handle(clonedReq);
>     }
>     
>     return next.handle(req);
>   }
> }
> 
> // app.module.ts
> providers: [
>   { provide: HTTP_INTERCEPTORS, useClass: AuthInterceptor, multi: true }
> ]
> ```

---

## 12. Tests Angular

**Q40: Comment tester un composant?**
> **R:**
> ```typescript
> describe('UserComponent', () => {
>   let component: UserComponent;
>   let fixture: ComponentFixture<UserComponent>;
>   
>   beforeEach(async () => {
>     await TestBed.configureTestingModule({
>       declarations: [UserComponent],
>       imports: [HttpClientTestingModule],
>       providers: [{ provide: UserService, useClass: MockUserService }]
>     }).compileComponents();
>     
>     fixture = TestBed.createComponent(UserComponent);
>     component = fixture.componentInstance;
>     fixture.detectChanges();
>   });
>   
>   it('should create', () => {
>     expect(component).toBeTruthy();
>   });
>   
>   it('should display user name', () => {
>     component.user = { name: 'John' };
>     fixture.detectChanges();
>     const element = fixture.nativeElement.querySelector('h1');
>     expect(element.textContent).toContain('John');
>   });
> });
> ```

**Q41: Comment tester un service?**
> **R:**
> ```typescript
> describe('UserService', () => {
>   let service: UserService;
>   let httpMock: HttpTestingController;
>   
>   beforeEach(() => {
>     TestBed.configureTestingModule({
>       imports: [HttpClientTestingModule],
>       providers: [UserService]
>     });
>     service = TestBed.inject(UserService);
>     httpMock = TestBed.inject(HttpTestingController);
>   });
>   
>   it('should fetch users', () => {
>     const mockUsers = [{ id: 1, name: 'John' }];
>     
>     service.getUsers().subscribe(users => {
>       expect(users.length).toBe(1);
>       expect(users[0].name).toBe('John');
>     });
>     
>     const req = httpMock.expectOne('/api/users');
>     expect(req.request.method).toBe('GET');
>     req.flush(mockUsers);
>   });
>   
>   afterEach(() => {
>     httpMock.verify();
>   });
> });
> ```

---

## 13. Bonnes Pratiques

**Q42: Comment structurer un projet Angular?**
> **R:**
> ```
> src/app/
> ├── core/                    # Services singleton, guards, interceptors
> │   ├── services/
> │   ├── guards/
> │   └── interceptors/
> ├── shared/                  # Composants, pipes, directives réutilisables
> │   ├── components/
> │   ├── pipes/
> │   └── directives/
> ├── features/                # Modules fonctionnels
> │   ├── users/
> │   │   ├── user-list/
> │   │   ├── user-detail/
> │   │   └── users.module.ts
> │   └── products/
> ├── app.component.ts
> ├── app.module.ts
> └── app-routing.module.ts
> ```

**Q43: Quelles sont les bonnes pratiques Angular?**
> **R:**
> - Utiliser le Lazy Loading pour les modules
> - Préférer les formulaires Reactive
> - Unsubscribe des Observables (ngOnDestroy ou async pipe)
> - Utiliser le ChangeDetectionStrategy.OnPush
> - Séparer la logique métier dans les services
> - Utiliser les Smart/Dumb components
> - Suivre le style guide Angular officiel
> - Utiliser TrackBy avec *ngFor

**Q44: Comment optimiser les performances?**
> **R:**
> - **OnPush Change Detection:** Détection de changements optimisée
> - **TrackBy:** Pour les listes avec *ngFor
> - **Lazy Loading:** Chargement différé des modules
> - **Pure Pipes:** Éviter les impure pipes
> - **AOT Compilation:** Compilation Ahead-of-Time
> - **Tree Shaking:** Élimination du code mort
> - **Bundle Optimization:** Analyser avec webpack-bundle-analyzer

---

## 14. ViewChild, ContentChild et Queries

**Q45: Qu'est-ce que `@ViewChild`?**
> **R:** `@ViewChild` permet de récupérer une référence vers un élément, un composant, une directive ou un `TemplateRef` présent dans la **vue du composant courant** (template HTML du composant).
> ```typescript
> @Component({
>   selector: 'app-parent',
>   template: `
>     <app-child #childCmp></app-child>
>     <input #searchInput>
>   `
> })
> export class ParentComponent implements AfterViewInit {
>   @ViewChild('searchInput') inputRef: ElementRef<HTMLInputElement>;
>   @ViewChild('childCmp') childComponent: ChildComponent;
> 
>   ngAfterViewInit() {
>     this.inputRef.nativeElement.focus();
>     this.childComponent.loadData();
>   }
> }
> ```

**Q46: Qu'est-ce que `@ContentChild`?**
> **R:** `@ContentChild` récupère un élément projeté via `<ng-content>` depuis le parent (contenu externe), et non un élément déclaré dans le template interne du composant.
> ```typescript
> // card.component.ts
> @Component({
>   selector: 'app-card',
>   template: `<div class="card"><ng-content></ng-content></div>`
> })
> export class CardComponent implements AfterContentInit {
>   @ContentChild('title') titleRef: ElementRef;
> 
>   ngAfterContentInit() {
>     console.log(this.titleRef.nativeElement.textContent);
>   }
> }
> 
> // utilisation
> <app-card>
>   <h2 #title>Mon titre projeté</h2>
> </app-card>
> ```

**Q47: Différence entre `@ViewChild` et `@ContentChild`?**
> **R:**
> | `@ViewChild` | `@ContentChild` |
> |--------------|-----------------|
> | Lit le template du composant lui-même | Lit le contenu projeté (`ng-content`) |
> | Disponible via les hooks *view* | Disponible via les hooks *content* |
> | Cas: accéder à un enfant direct dans la vue | Cas: accéder à ce que le parent injecte dans le composant |

**Q48: Que fait l'option `{ static: true/false }` avec `@ViewChild` (Angular 8)?**
> **R:** En Angular 8, il faut préciser `static`:
> - `static: true` → la query est résolue avant `ngOnInit` (utile si l'élément est toujours présent)
> - `static: false` → la query est résolue en `ngAfterViewInit` (recommandé si l'élément dépend de `*ngIf`, `*ngFor`, etc.)
> ```typescript
> @ViewChild('alwaysHere', { static: true }) alwaysHere: ElementRef;
> @ViewChild('maybeHere', { static: false }) maybeHere: ElementRef;
> ```

**Q49: Quand utiliser `@ViewChildren` et `@ContentChildren`?**
> **R:** Quand on veut plusieurs résultats (liste) au lieu d'un seul.
> ```typescript
> @Component({
>   selector: 'app-list',
>   template: `<app-item *ngFor="let item of items"></app-item>`
> })
> export class ListComponent implements AfterViewInit {
>   @ViewChildren(ItemComponent) itemComponents: QueryList<ItemComponent>;
> 
>   ngAfterViewInit() {
>     console.log(this.itemComponents.length);
>     this.itemComponents.changes.subscribe(() => {
>       console.log('La liste a changé');
>     });
>   }
> }
> ```

**Q50: Quels hooks utiliser avec `ViewChild`/`ContentChild`?**
> **R:**
> - `@ContentChild` / `@ContentChildren` → `ngAfterContentInit` et `ngAfterContentChecked`
> - `@ViewChild` / `@ViewChildren` → `ngAfterViewInit` et `ngAfterViewChecked`
> - Éviter d'utiliser ces références dans le constructor

**Q51: Quelles bonnes pratiques avec `ViewChild`/`ContentChild`?**
> **R:**
> - Préférer `@Input()` / `@Output()` pour la communication métier
> - Utiliser `ViewChild` pour interaction UI (focus, accès API composant enfant, `TemplateRef`)
> - Limiter l'accès direct au DOM (`ElementRef`) et privilégier `Renderer2` si possible
> - Vérifier la présence de la référence avant usage (`if (this.child) { ... }`)
> - Éviter une logique métier lourde dans `ngAfterViewInit` / `ngAfterContentInit`

