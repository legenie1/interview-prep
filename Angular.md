<!-- Hook Life Cycle Angular -->

ngOnInt - initialisation du composant
ngOnChanges - quand un @Input change
ngOnDestroy - Cleanup(unsubscribe des observables), ceci pour eviter des memory leaks
ngAfterViewInit - Apres rendu du template

<!-- Data Binding -->

{{ }} Interpolation
[property]="value" Property Binding
(event)="method()" Event Binding
[(ngModel)] Two way binding

<!-- Services & Dependecy Injection -->

- Separation des responsabilites
- Logiques metier reutilisable
- Communication entre composants
  @Injectable({
    providedIn: 'root'
  })
  export class EmployeeService{}

<!-- RxJs, Observables -->
- Rxjs is a library for reactive programming using Observables to easily compose asynchronous data

- Observables are part of RxJs(Reactive Extensions for Javascript) library, They represent a stream of data that can be oversed overtime. 
  It's actualy a way to handle data that changes, such as inputs, server responses or real-time updates
 (Asynchronous, Lazy Execution, Mulitple Operators - Transform Filters etc)
- An Observer is an Entity that subscribes to an Observable to react to emitted values

- Subscription is the process of consuming an Observable's emitted values

- Angular HttpClient returns Observables
- Observables can be used via: Subscribe, Async Pipe, Chaining Operators

- Observables can be canceled while Promise cannot be canceled
- Observables are Lazy while Promise are Eager
- Observables can handle Multiple Values while Promise handles only one value

<!-- Http Client -->
- Used in Angular for http communication, it has methods sucha as; get(), post(), put(), delete()
- The response can be intercepted using HttpInterceptor

<!-- Performance Optimization -->
- reduce re-renders with
```
    @Component({
        changeDetection: ChangeDetectionStrategy.OnPush
    })
```

- trackBy
<li *ngFor="let emp of employees; trackBy: trackById">

- Use @Input for Parent -> Child communications
- Use @Ouput for Child -> Parent communications

<!-- Testing -->
It can be done using: Karma, Jasmine, TestBed
```
    it('Should return an integer', ()=>{
        ....... Instructions ......
    })
```


<!-- Constrcutor & ngOnInit -->
- constructor   -> Injection dependances
- ngOnInit      -> Initialisation logique

<!-- Difference entre Subject et BehaviorSubject -->
Subject: Pas de valeur initiale, Pas de valeur precedente
BehaviorSubject: Valeur initiale obligatoire, Garder la derniere valeur

<!-- Difference entre AngularJs et Angular -->
AngularJs: basee sur Javascript, Basee sur controller
Angular: Basee sur Typescript, Basee sur composants, Performance Amelioree

<!-- JIT vs AOT -->
ce sont des mechanisme de compilation 
- JIT: La compilations s'effectue a l'ouverture du Navigateur
- AOT: La compilation s'effectue au montage de l'application -> Durant le build