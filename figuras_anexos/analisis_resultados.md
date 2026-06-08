# Analisis computacional para la Solemne 2

Este documento resume el material que puede incorporarse a la parte final del informe.

## Metodo utilizado

Se implemento una metaheuristica Tabu Search para el escenario determinista normal. La solucion se representa mediante:

- Una ruta ordenada para cada camion.
- La asignacion de estaciones a cada camion.
- La asignacion de producto a cada compartimento.

Para evaluar cada solucion se calculan las cantidades cargadas y entregadas, el shortage, el costo fijo, el costo de distancia, el cumplimiento de ventanas de tiempo y la estabilidad de carga mediante la diferencia de fill ratios.

La funcion de evaluacion es:

```text
Z = costo fijo + costo distancia + penalizacion por shortage + penalizaciones por infactibilidad
```

Las penalizaciones de infactibilidad se activan si se viola una ventana de tiempo o si el gap de fill ratios supera `Delta = 0.30`.

Como el problema tiene solo cuatro estaciones, tambien se implemento una enumeracion exhaustiva de particiones, ordenes y asignaciones producto-compartimento. Esta enumeracion se usa como validacion de la metaheuristica.

Ademas, se implemento el MILP determinista en AMPL y se resolvio con HiGHS. La ejecucion AMPL entrega estado `solved` y costo objetivo `1130`, consistente con Tabu Search.

## Resultado determinista

La solucion reportada por Tabu Search es:

```text
T1: Deposito -> Est. 3 -> Deposito
T2: Deposito -> Est. 4 -> Est. 2 -> Est. 1 -> Deposito
```

Asignacion de compartimentos:

```text
T1 C0: Regular, T1 C1: Diesel
T2 C0: Diesel, T2 C1: Regular
```

Costos:

```text
Costo fijo: 900
Distancia total: 115 km
Costo distancia: 230
Shortage: 0 L
Penalizacion por shortage: 0
Costo total: 1130
```

La solucion cumple las ventanas de tiempo. Tambien cumple estabilidad, ya que el gap maximo de fill ratios es `0.194`, menor que el limite `0.30`.

La salida AMPL activa los arcos `0->3->0` para T1 y `0->4->2->1->0` para T2, con shortage igual a cero.

## Scheduling de carga

Para la pregunta de scheduling con volumenes fijos, las duraciones son:

```text
T1 C0 Regular: 15 min
T1 C1 Diesel: 17.5 min
T2 C0 Diesel: 15 min
T2 C1 Regular: 12 min
```

Una secuencia optima es:

```text
Bahia Regular: T1 C0 [0,15], T2 C1 [15,27]
Bahia Diesel: T2 C0 [0,15], T1 C1 [15,32.5]
```

El makespan es `32.5` minutos. Si la carga comienza a las `04:27:30`, termina a las `05:00`, por lo que ambos camiones pueden salir a tiempo.

## Comparacion con la solucion del operador

La solucion propuesta por el operador tiene:

```text
Distancia total: 150 km
Costo distancia: 300
Costo fijo: 900
Shortage minimo: 2000 L
Penalizacion shortage: 20000
Costo total minimo: 21200
```

Ademas, la solucion del operador viola estabilidad en `T2`, donde el gap de fill ratios llega aproximadamente a `0.417`, superior al limite `0.30`.

La enumeracion exhaustiva confirmo que el costo encontrado por Tabu Search no tiene una mejora dentro del espacio discreto evaluado. Por lo tanto, la solucion computacional mejora la propuesta del operador porque satisface toda la demanda, respeta estabilidad, respeta ventanas de tiempo y reduce el costo total desde `21200` hasta `1130`.
