# DeterministicFeed

`DeterministicFeed` es una aplicación iOS escrita en SwiftUI que funciona como **caso de estudio** de una arquitectura guiada por estado, tipos y decisiones explícitas.

La app consume datos públicos de la API de Rick and Morty para mostrar una lista de personajes. Sin embargo, el objetivo principal no es la funcionalidad en sí, sino **explorar cómo diseñar sistemas predecibles, testeables y razonables desde su núcleo**, siguiendo la **"Teoría de Diseño de Comunicación Visual y Estado"**.

---

## Qué demuestra este proyecto

-   Modelado del dominio de la UI usando un sistema de tipos explícito (`Rick_and_Morty_Character`).
-   Gobernar la aplicación desde un estado compuesto (`struct ViewState`) que separa la carga inicial de la paginación.
-   Manejar errores parciales (un fallo de paginación) sin afectar el estado ya renderizado.
-   Separar estrictamente la lógica pura de la infraestructura (Dominio, Presentación, `Actor` para concurrencia).
-   Usar TDD como herramienta de diseño para validar el comportamiento antes de la implementación.
-   Documentar decisiones arquitectónicas como parte integral del sistema.

---

## Arquitectura Limpia (Clean Architecture)

El sistema sigue los principios de **Clean Architecture** para separar responsabilidades y un flujo de dependencias unidireccional. La arquitectura se divide en tres capas principales:

-   **Dominio (Domain)**
    El núcleo de la aplicación. Contiene los modelos de negocio (`Rick_and_Morty_Character`) y los contratos de los repositorios (`CharacterRepositoryProtocol`). No depende de ninguna otra capa.

-   **Datos (Data)**
    Responsable de la obtención de datos. Implementa los contratos del Dominio. Contiene el `CharacterRepository` (que hace las llamadas a la API) y el cliente de red.

-   **Presentación (Presentation)**
    La capa de UI, construida con SwiftUI y un patrón MVVM. Contiene las Vistas (`CharacterListView`) y los ViewModels (`CharacterListViewModel`). El ViewModel coordina la interacción entre la Vista y el Repositorio (a través de su protocolo) y gestiona el `ViewState`.

Este enfoque garantiza que la lógica de negocio no se mezcle con la UI o los detalles de la red, facilitando las pruebas y el mantenimiento.

---

## Documentación

La filosofía de diseño y las decisiones arquitectónicas están detalladas en la documentación del proyecto. El documento `ARCHITECTURE.md` describe en profundidad la implementación de Clean Architecture.

-   **[`Docs/ARCHITECTURE.md`](../Docs/ARCHITECTURE.md)**
    Este documento explica la estructura de capas, el flujo de datos y las decisiones de diseño del proyecto.

---

## Cómo ejecutar el proyecto

1.  **Clonar el repositorio.**
2.  **Abrir `DeterministicFeed.xcodeproj` en Xcode.**
3.  **Ejecutar** en un simulador o dispositivo físico (requiere Xcode 15+).

---

## Nota final

Este proyecto prioriza **claridad conceptual sobre conveniencia inmediata**.
Algunas decisiones implican más trabajo inicial, pero permiten un sistema más fácil de entender, modificar y discutir, con menos "sorpresas" en producción.

Ese `trade-off` es intencional.