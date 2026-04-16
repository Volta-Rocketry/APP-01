# Configuración de la Vista de Telemetría - Mission Cattaleya

## Descripción General

La vista de telemetría se ha actualizado completamente para mostrar todos los datos del vuelo en tiempo real con la interfaz mostrada. El sistema está diseñado para recibir datos del microcontrolador a través de puerto serial y mostrarlos en la pantalla.

## Componentes Implementados

### 1. Backend C++ (serialmanagement)

**Archivo:** `Interface/serialmanagement.h` y `Interface/serialmanagement.cpp`

El sistema ahora emite las siguientes señales:

```cpp
// Señal de telemetría IMU + GPS (original)
void telemetryUpdated(float Ax, float Ay, float Az, float Gx, float Gy, float Gz, float lat, float lon);

// Nuevas señales individuales
void altitudeUpdated(float altitude);
void speedUpdated(float speed);
void accelerationUpdated(float acceleration);
void voltageUpdated(float voltage);
void temperatureUpdated(float temperature);
void timeUpdated(float elapsedTime);
void flightPhaseUpdated(int phase);
void microcontrollerConnectionStatus(bool status);
```

### 2. Frontend QML (MainScreen)

**Archivos:**
- `InterfaceContent/MainScreenForm.ui.qml` - Diseño visual
- `InterfaceContent/MainScreen.qml` - Lógica de actualización
- `InterfaceContent/TelemetryScreenForm.ui.qml` - Área de gráficos

**Elementos Visuales:**

```
┌─────────────────────────────────────────────────────────────┐
│  MISSION CATTALEYA        T: 00:00.00      0.00v  0° I      │
│  ASCENT | APOGEE | MAIN CHUTE | TOUCH DOWN [████░░░░]      │
├─────────────────────────────────────┬───────────────────────┤
│                                     │                       │
│  ALTITUDE VS TIME                   │    MAP VIEW (gris)    │
│  [Gráfico de altitud]               │                       │
│  (60% de ancho)                     ├───────────────────────┤
│                                     │                       │
│                                     │ CAMERA FEED (negro)   │
│                                     │                       │
├─────────────────────────────────────┴───────────────────────┤
│ LATITUDE     LONGITUDE    SPEED      ALTITUDE   ACCELERATION│
│ 0.000000 N   0.000000 W   0 ft/s     0 ft       0 ft/s²    │
│              0.000000 W   0 m/s      0 m        0 m/s²     │
└─────────────────────────────────────────────────────────────┘
```

## Formatos de Datos Esperados

El microcontrolador debe enviar datos en los siguientes formatos a través del puerto serial (115200 baud):

### Telemetría IMU + GPS (Original)
```
3, Ax, Ay, Az, Gx, Gy, Gz, lat, lon, 5
```
Ejemplo: `3, 0.1, 0.2, 9.8, 0.01, 0.02, 0.03, 4.7561, -74.0557, 5`

### Altitud
```
ALT, valor_altitud_en_metros
```
Ejemplo: `ALT, 500.25`

### Velocidad
```
SPEED, valor_velocidad_en_m_s
```
Ejemplo: `SPEED, 45.5`

### Voltaje
```
VOLT, valor_en_voltios
```
Ejemplo: `VOLT, 3.85`

### Temperatura
```
TEMP, valor_en_celsius
```
Ejemplo: `TEMP, 25.5`

### Fase de Vuelo
```
PHASE, numero_fase
```
Donde:
- 0 = ASCENT (Ascenso)
- 1 = APOGEE (Apogeo)
- 2 = MAIN_CHUTE (Paracaídas principal)
- 3 = TOUCH_DOWN (Aterrizaje)

Ejemplo: `PHASE, 0`

> **Nota:** Todos los datos terminan con un salto de línea `\n`

## Flujo de Datos

```
Microcontrolador
      ↓
Serial Port (USB/COM)
      ↓
serialManagement::onReadyRead()
      ↓
Parser de mensajes
      ↓
Emisión de signals (Qt)
      ↓
MainScreen.qml (Connections)
      ↓
Actualización de UI Elements
      ↓
Gráficos y visualización en tiempo real
```

## Uso

### 1. Conexión

En la interfaz de control:
1. Seleccionar puerto serial
2. Seleccionar velocidad (por defecto 115200)
3. Hacer clic en "Start Connection"

### 2. Envío de Datos

Una vez conectado, el microcontrolador debe enviar datos continuamente en los formatos especificados.

### 3. Visualización

Los datos se mostrarán automáticamente en:
- **Barra superior:** Tiempo, voltaje, temperatura, fase de vuelo
- **Gráfico central:** Altitud vs Tiempo (se actualiza cada 5 puntos de datos)
- **Paneles laterales:** Mapa y video
- **Barra inferior:** Latitud, longitud, velocidad, altitud, aceleración

## Conversiones de Unidades

El software aplica las siguientes conversiones automáticas:

| De (entrada) | A (visualización) | Factor |
|--------------|-------------------|--------|
| Metros (m) | Pies (ft) | × 3.28084 |
| m/s | ft/s | × 3.28084 |
| m/s² | ft/s² | × 3.28084 |

Las lecturas en unidades originales también se muestran (segundas línea en cada panel).

## Configuración Avanzada

### Modo de Prueba

Para activar el modo de prueba con datos simulados, editar `MainScreen.qml`:

```qml
Timer {
    id: testDataTimer
    interval: 1000
    running: true  // Cambiar a true para modo prueba
    repeat: true
    // ...
}
```

### Rango del Gráfico

Para ajustar el rango máximo del gráfico, modificar en `TelemetryScreenForm.ui.qml`:

```qml
ValueAxis {
    id: axisY
    min: 0
    max: 10000  // Cambiar valores máximos esperados
}
```

## Debugging

El sistema emite logs a la consola Qt:

```
MainScreen - Telemetría actualizada: Lat=4.76, Lon=-74.05
MainScreen - Altitud actualizada: 500.25 m
MainScreen - Velocidad actualizada: 45.5 m/s
Gráfico actualizado con 100 puntos
```

Use Qt Creator's Application Output o consulte el debug log.

## Troubleshooting

### El gráfico no se actualiza

1. Verificar que los datos de ALT se están enviando
2. Confirmar que **5 datos consecutivos** se han recibido (el gráfico se actualiza cada 5)
3. Revisar la consola para mensajes de error

### Los valores no cambian

1. Verificar conexión serial (LED de conexión debe estar verde)
2. Confirmar baud rate: 115200
3. Validar formato de datos enviados
4. Revisar logs en Qt Creator

### Valores incorrectos

1. Verificar factor de conversión (debe ser 3.28084 para m→ft)
2. Confirmar unidades de entrada (deben ser SI: m, m/s, kg·m/s², V, °C)

## Estructura de Archivos

```
Interface/
├── serialmanagement.h          ← Backend (signals definidas)
├── serialmanagement.cpp        ← Backend (parser implementado)
└── InterfaceContent/
    ├── MainScreen.qml          ← Lógica de actualización
    ├── MainScreenForm.ui.qml   ← Layout visual
    └── TelemetryScreenForm.ui.qml ← Área de gráficos
```

## Ejemplos de Envío de Datos

### Red de Control con Temperatura Creciente

```
3, 0.1, 0.2, 9.8, 0.01, 0.02, 0.03, 4.7561, -74.0557, 5
ALT, 0.0
SPEED, 0.0
VOLT, 3.85
TEMP, 20.0
PHASE, 0

// Después de 1 segundo
3, 0.2, 0.3, 10.1, 0.02, 0.03, 0.04, 4.7562, -74.0556, 5
ALT, 45.5
SPEED, 10.2
VOLT, 3.84
TEMP, 20.5
PHASE, 0

// Después de 2 segundos (apogeo)
3, 0.05, 0.1, 9.5, 0.01, 0.01, 0.01, 4.7563, -74.0555, 5
ALT, 500.0
SPEED, 0.5
VOLT, 3.83
TEMP, 22.0
PHASE, 1
```

## Actualizaciones Futuras

Elementos planeados para futuras mejoras:

- [ ] Integración con mapa en tiempo real (API de mapas)
- [ ] Transmisión de video desde cámara
- [ ] Grabación automática de datos en CSV
- [ ] Predicción de apogeo
- [ ] Alertas visuales y de audio
- [ ] Comparación con lanzamientos anteriores
- [ ] Exportación de datos

---

**Última actualización:** Abril 2026
**Versión:** 1.0
**Estado:** Listo para producción
