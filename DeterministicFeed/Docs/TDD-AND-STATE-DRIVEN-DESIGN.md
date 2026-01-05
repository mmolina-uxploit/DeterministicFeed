# Desarrollo Guiado por Tests (TDD) en `DeterministicFeed`

> Este proyecto contiene un test que forma parte del proceso de diseño del sistema.

> El test no se utiliza como verificación genérica de comportamiento ni como ejemplo didáctico, sino como **expresión formal de una transición de estado** dentro del flujo principal de la aplicación.


---

## Rol del test en la arquitectura

El test existente define un **contrato observable mínimo**:

- un estado inicial implícito
- un evento ejecutado sobre el sistema
- un estado resultante esperado

Ese contrato delimita una transición válida dentro del modelo de estado del `ViewModel`.

No se verifican detalles de implementación, efectos colaterales ni integración con frameworks externos.

---

## Relación con la arquitectura gobernada por estado

La arquitectura del proyecto se basa en estado explícito y tipos fuertes.  
El test opera directamente sobre ese modelo.

- Se valida una **transición de estado concreta**.
- El estado observado es **explícito y comparable**.
- La lógica se evalúa **sin UI y sin red real**, mediante una dependencia controlada.

El test actúa como una **especificación ejecutable mínima** del diseño actual.

---

## Alcance

El uso de tests en el proyecto, al momento, se limita a:

- el flujo inicial de carga
- la lógica de estado del `ViewModel`

No constituye una estrategia de testing completa ni una descripción exhaustiva del sistema.

---

## Síntesis

En `DeterministicFeed`, el test existente documenta una **decisión puntual de diseño**.


