# DeterministicFeed
### Case Study: Component Composition & Presentation Logic

Estudio sobre la construcción de feeds dinámicos en SwiftUI, priorizando la predictibilidad del renderizado y la reutilización de componentes atómicos.

**Engineering Thesis:**
Un feed no debe conocer su contenido, solo las reglas de composición. Este proyecto desacopla la obtención de datos de su representación visual mediante una capa de presentación puramente reactiva.

**Core Objectives:**
* **Component Purity:** Componentes de UI que no tienen estado interno, solo reaccionan a datos inyectados.
* **Scalable Composition:** Estructura modular que permite añadir nuevos tipos de celdas sin modificar la lógica del feed principal.
* **Efficient Rendering:** Optimización de diffing en SwiftUI para garantizar fluidez (60fps).

**Key Decision (ADR):**
* **Decision:** Composición basada en ViewModels de Celda.
* **Why:** Permite testear la lógica de presentación de cada elemento del feed de forma independiente.
* **Trade-off:** Incrementa la cantidad de capas entre el modelo de datos y la vista.
