# Architecture Decision Record (ADR)

## DeterministicFeed · Arquitectura Gobernada por Estado

> Este documento describe la **decisión arquitectónica central** de `DeterministicFeed` y los principios que se derivan de ella.

> Se presenta como **caso de estudio** y README de arquitectura. 


---

## Contexto

Este proyecto explora una arquitectura iOS basada en **Clean Architecture** y **estado explícito**, diseñada para priorizar:

* claridad semántica del dominio
* testabilidad
* razonamiento local sobre el comportamiento del sistema
* resistencia al cambio y al crecimiento funcional


---

## Decisión (ADR principal)

El sistema se modela como un **flujo unidireccional gobernado por estado**, donde las dependencias fluyen hacia el dominio y los estados inválidos no deben poder representarse.

Esto implica:

* uso de modelos de dominio puros (`struct`, `enum`)
* contratos explícitos mediante protocolos
* separación estricta entre dominio, datos y presentación
* estado de UI modelado fuera del dominio

**Trade-off asumido**
Mayor esfuerzo inicial de diseño y composición a cambio de menor ambigüedad, mayor previsibilidad y menos errores en runtime.

---

## Principios derivados de la decisión

### Dominio como núcleo semántico

El dominio expresa **qué es el sistema**, no cómo se renderiza ni cómo obtiene datos.

* `Rick_and_Morty_Character` representa un concepto del negocio
* `CharacterRepositoryProtocol` define capacidades, no implementaciones

El dominio no conoce:

* SwiftUI
* networking
* concurrencia
* frameworks externos

**Beneficio**: reglas claras, tests simples y refactors seguros.

---

### Inversión de dependencias

Las capas externas (Data, Presentation) dependen de **abstracciones definidas en el dominio**.

* `CharacterRepository` implementa un protocolo del dominio
* el ViewModel depende del protocolo, no de la implementación concreta

**Beneficio**: el sistema puede cambiar de fuente de datos sin alterar la lógica de presentación.

---

### Estado como contrato entre UI y sistema

La UI no decide: **reacciona al estado**.

* el `ViewModel` expone un `ViewState`
* SwiftUI se limita a proyectar ese estado

Si la UI necesita lógica adicional para decidir qué mostrar, el diseño del estado es incorrecto.

**Beneficio**: render predecible y menos bugs visuales.

---

### Flujo de datos unidireccional

1. La vista emite una intención (evento de usuario)
2. El ViewModel coordina la acción
3. El repositorio obtiene los datos
4. El estado se actualiza
5. SwiftUI re-renderiza en función del nuevo estado

No hay dependencias circulares ni mutaciones implícitas.

**Beneficio**: el comportamiento del sistema se puede razonar sin ejecutar la app.

---

### Composición explícita del sistema

La creación de dependencias no está distribuida:

* `DependencyInjector` centraliza la composición
* `CharacterExplorerApp` actúa como **Composition Root**

El ciclo de vida del `ViewModel` se gestiona explícitamente mediante `@StateObject`.

**Beneficio**: control total sobre instanciación, testeo y evolución del sistema.

---

## Estructura resultante

La estructura de carpetas refleja directamente esta decisión arquitectónica:

```
Characters/
├── Domain/
│   ├── Entities/
│   │   └── Rick_and_Morty_Character.swift
│   └── Interfaces/
│       └── CharacterRepositoryProtocol.swift
├── Data/
│   ├── Network/
│   │   └── NetworkClient.swift
│   └── Repositories/
│       └── CharacterRepository.swift
├── Presentation/
│   └── CharacterList/
│       ├── CharacterListView.swift
│       └── CharacterListViewModel.swift
└── DI/
    └── DependencyInjector.swift
```

La estructura no es estética: es una **expresión física de las decisiones del sistema**.

---

## Alternativas descartadas

* lógica de negocio en SwiftUI
* dependencias directas a `URLSession` en la UI
* estados implícitos mediante flags booleanos
* ViewModels acoplados a implementaciones concretas

Estas alternativas reducen el esfuerzo inicial, pero aumentan la ambigüedad y el costo cognitivo a medida que el sistema crece.


