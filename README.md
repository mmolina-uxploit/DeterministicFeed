# DeterministicFeed

## Project Overview
`DeterministicFeed` es un sistema iOS experimental que utiliza la API de Rick and Morty para demostrar una **arquitectura gobernada por estado y tipos estrictos**. El problema técnico abordado es la eliminación de la ambigüedad en la UI mediante el modelado de estados imposibles de representar y una separación radical entre la lógica pura y la infraestructura.

---

## Engineering Goals
* **Previsibilidad del Estado:** Garantizar que la UI sea una función pura del estado (`ViewState`).
* **Reducción de Carga Cognitiva:** Arquitectura que permite el razonamiento local sin conocimiento profundo del sistema global.
* **Desacoplamiento Total:** Inversión de dependencias para que el dominio sea agnóstico a frameworks (SwiftUI/Combine).
* **Diseño mediante TDD:** Uso de pruebas unitarias como especificación formal de transiciones de estado.

---

## Architecture
El sistema implementa **Clean Architecture** con un flujo de datos unidireccional.

* **Domain:** Núcleo semántico. Contiene Entidades (`Rick_and_Morty_Character`) e Interfaces (`RepositoryProtocol`). Sin dependencias externas.
* **Data:** Implementación de infraestructura. Contiene el `CharacterRepository` y el cliente de red.
* **Presentation:** Capa de visualización (SwiftUI). El `ViewModel` coordina la lógica de estado y consume abstracciones del dominio.

---

## Architectural Decisions (ADR-lite)

| Decision | Context | Why | Tradeoffs |
| :--- | :--- | :--- | :--- |
| **Modelado de estado compuesto** | Manejo de carga inicial vs. paginación. | Permite manejar errores de paginación parcial sin destruir los datos ya renderizados. | Mayor verbosidad inicial en el ViewModel. |
| **Inyección de Dependencias centralizada** | Gestión del ciclo de vida de objetos. | Facilita el TDD al permitir la sustitución inmediata de implementaciones reales por dobles de prueba. | Introduce un punto único de configuración (Composition Root). |

---

## Technology Stack
* **Swift 5.10+ / SwiftUI:** Declaración de UI reactiva basada en estado.
* **Actor Model:** Gestión de concurrencia segura en la capa de datos.
* **URLSession:** Infraestructura de red nativa sin dependencias de terceros.
* **XCTest:** Validación de lógica de negocio y transiciones de estado.

---

## Testing Strategy
* **Qué se protege:** Transiciones de estado del `ViewModel` y contratos del `Repository`.
* **Qué NO se testea:** Frameworks de Apple (SwiftUI rendering) ni detalles de implementación de red.
* **Rol:** El test es una **especificación ejecutable**. El sistema se diseña para que el estado sea comparable (`Equatable`), permitiendo aserciones directas sobre el comportamiento esperado.

---

## Project Structure
```text
Characters/
├── Domain/        # Entidades puras e interfaces (Protocolos).
├── Data/          # Implementaciones de Repositorio y Network Client.
├── Presentation/  # SwiftUI Views y ViewModels gobernados por estado.
└── DI/            # Composition Root y contenedor de dependencias.
```

## Execution

1. **Requisitos:** Xcode 15.0+ / Swift 5.10.
2. **Clonar:** Descargar el repositorio localmente.
3. **Xcode:** Abrir `DeterministicFeed.xcodeproj`.
4. **Test:** `Cmd + U` para ejecutar la suite de tests (validación de arquitectura).
5. **Run:** `Cmd + R` para ejecución en Simulador.

---

## Engineering Tradeoffs & Limitations

* **Sobre-ingeniería para escala pequeña:** La separación en capas para una sola feature aumenta el número de archivos, pero garantiza escalabilidad inquebrantable.
* **Manejo de Errores:** Actualmente simplificado para priorizar la visualización de la estructura sobre la gestión exhaustiva de tipos de error de red.

---
