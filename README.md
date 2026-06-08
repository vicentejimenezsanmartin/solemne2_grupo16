# Solemne 2 - Optimizacion de distribucion de combustibles

Repositorio de apoyo para la entrega de la Solemne 2 de CINF105 Optimizacion.

El repo contiene:

- `codigo.ipynb`: notebook Jupyter ejecutado con explicacion, ejecucion AMPL, Tabu Search y analisis de resultados.
- `ampl/`: archivos `.mod`, `.dat` y `.run` del modelo AMPL.
- `salidas_resultados/`: archivos generados con rutas, costos, cargas, entregas, estabilidad, shortage, scheduling y resumen final.
- `figuras_anexos/`: figura de Gantt y analisis de respaldo.

Al ejecutar el notebook se generan y revisan las salidas de rutas, costos, estabilidad, tiempos, shortage y scheduling.

## Como ejecutar

En Jupyter, abrir `codigo.ipynb`, ejecutar las celdas en orden y revisar las tablas finales. El notebook instala `amplpy` si hace falta y ejecuta HiGHS.

Los archivos AMPL estan en `ampl/`. En este equipo no se detecto `ampl` en el PATH, por lo que esos `.run` quedan listos para ejecutarse en un ambiente que tenga AMPL y un solver configurado.

## Resultado principal

La mejor solucion encontrada para el escenario determinista normal tiene costo total `1130`:

- Costo fijo: `900`
- Costo por distancia: `230`
- Penalizacion por shortage: `0`
- Distancia total: `115 km`

Rutas:

- `T1`: Deposito -> Est. 3 -> Deposito
- `T2`: Deposito -> Est. 4 -> Est. 2 -> Est. 1 -> Deposito

Tabu Search encontro esta solucion y la enumeracion exhaustiva del espacio discreto confirmo que no existe una solucion mejor bajo la codificacion usada.
El modelo AMPL determinista tambien retorna estado `solved` y costo objetivo `1130`.
