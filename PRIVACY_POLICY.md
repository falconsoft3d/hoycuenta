# Política de Privacidad de HoyCuenta

**Última actualización: 25 de diciembre de 2025**

**Versión 1.0**

## 1. Introducción y Filosofía

Bienvenido a HoyCuenta. En un mundo donde la privacidad digital se ha convertido en una preocupación creciente, hemos tomado la decisión consciente de construir nuestra aplicación con un enfoque radical en la protección de tu información personal.

Esta Política de Privacidad describe de manera detallada y transparente cómo HoyCuenta maneja (o más precisamente, NO maneja) tu información personal cuando utilizas nuestra aplicación móvil. Nos comprometemos a ser completamente transparentes sobre nuestras prácticas de privacidad.

**Nuestra filosofía es simple: Tus datos son tuyos. Punto.**

HoyCuenta está diseñada bajo el principio de "Privacidad por Diseño" (Privacy by Design), lo que significa que la privacidad no es una característica añadida posteriormente, sino que está integrada en la arquitectura fundamental de la aplicación desde su concepción.

## 2. Ámbito de Aplicación

Esta Política de Privacidad se aplica a:
- La aplicación móvil HoyCuenta para dispositivos iOS
- Todas las funcionalidades incluidas en la aplicación (seguimiento de hábitos, ejercicios, mediciones, ayuno intermitente)
- Cualquier actualización futura de la aplicación

Esta política NO se aplica a:
- Sitios web o aplicaciones de terceros que puedan estar vinculados desde nuestra aplicación
- Prácticas de privacidad del sistema operativo de tu dispositivo

## 3. Información que NO Recopilamos

HoyCuenta ha sido diseñada desde cero para funcionar completamente sin conexión a internet y sin recopilar ningún tipo de dato personal. Esta no es una limitación técnica, sino una decisión de diseño deliberada.

### 3.1 Información Personal
**NO** recopilamos ningún tipo de información personal identificable, incluyendo pero no limitado a:

- **Información de Identidad**: Nombre completo, nombre de usuario, fecha de nacimiento, fotografías personales, número de identificación personal
- **Información de Contacto**: Dirección de correo electrónico, número de teléfono, dirección postal, información de redes sociales
- **Información Demográfica**: Edad, género, etnia, nacionalidad, preferencias personales
- **Información Financiera**: Datos de tarjetas de crédito, información bancaria, historial de transacciones
- **Credenciales de Acceso**: Contraseñas, tokens de autenticación, claves API

### 3.2 Información Técnica
**NO** recopilamos ningún tipo de información técnica sobre tu dispositivo o uso de la aplicación:

- **Identificadores de Dispositivo**: UDID, IMEI, dirección MAC, ID de publicidad (IDFA/AAID)
- **Información del Dispositivo**: Modelo del dispositivo, versión del sistema operativo, configuración de hardware
- **Datos de Red**: Dirección IP, proveedor de servicios de internet, información de WiFi
- **Datos de Uso**: Frecuencia de uso, patrones de interacción, clics, tiempo de sesión, funciones utilizadas
- **Datos de Rendimiento**: Informes de fallos, registros de errores, métricas de rendimiento
- **Cookies o Tecnologías Similares**: No utilizamos cookies, beacons, píxeles de seguimiento ni ninguna tecnología similar

### 3.3 Información de Ubicación
**NO** recopilamos ningún tipo de información de ubicación:

- Ubicación GPS precisa
- Ubicación aproximada basada en red
- Historial de ubicaciones
- Puntos de interés visitados

### 3.4 Contenido Generado por el Usuario
Aunque creas contenido dentro de la aplicación (hábitos, ejercicios, mediciones, notas), este contenido:

- **Permanece completamente en tu dispositivo**
- **NO se envía a nuestros servidores** (de hecho, no tenemos servidores para recopilar datos)
- **NO es accesible para nosotros** de ninguna manera
- **NO puede ser analizado, procesado o utilizado** por HoyCuenta o terceros

## 4. Almacenamiento y Procesamiento de Datos

### 4.1 Almacenamiento Local

Todos los datos que ingresas en HoyCuenta se almacenan **exclusivamente en tu dispositivo** utilizando las APIs de almacenamiento seguro proporcionadas por el sistema operativo iOS (UserDefaults y almacenamiento de aplicación en sandbox).

**Tipos de datos almacenados localmente:**

- **Hábitos**: Nombre del hábito, icono seleccionado, color, objetivo, fecha de creación, estado activo/inactivo
- **Validaciones de Hábitos**: Fecha y hora de cada validación, si se completó o no, duración de sesiones con temporizador
- **Ejercicios**: Nombre del ejercicio, icono, tipo, fecha de creación, configuración de series y repeticiones
- *5. Medidas de Seguridad

Aunque no recopilamos ni transmitimos datos, tomamos en serio la seguridad de la información almacenada en tu dispositivo.

### 5.1 Protección con PIN

HoyCuenta ofrece una función opcional de protección con PIN que:

- **Requiere un código de 4 dígitos** para acceder a la aplicación
- **Se almacena en el iOS Keychain**, el sistema de almacenamiento seguro de credenciales de Apple
- **NO se transmite** fuera de tu dispositivo
- **NO puede ser recuperado** por nosotros si lo olvidas (deberás reinstalar la aplicación)
- Proporciona una **capa adicional de seguridad** contra acceso no autorizado físico a tu dispositivo

### 5.2 Arquitectura de Seguridad

**Aislamiento de Aplicación:**
- La aplicación funciona dentro del sandbox de iOS
- No puede acceder a datos de otras aplicaciones
- Otras aplicaciones no pueden acceder a datos de HoyCuenta

**Cifrado del Sistema:**
- Los datos se benefician del cifrado de iOS cuando el dispositivo está bloqueado
- Si tu dispositivo tiene Face ID/Touch ID habilitado, los datos están protegidos por el Secure Enclave

**Sin Conectividad de Red:**
- La aplicación no requiere conexión a internet
- No hay transmisión de datos que pueda ser interceptada
- Elimina por completo el riesgo de ataques de red o filtraciones de datos en tránsito

### 5.3 Mejores Prácticas Recomendadas

Para maximizar la seguridad de tus datos, te recomendamos:

1. **Mantén tu dispositivo actualizado** con la última versión de iOS
2. **Utiliza un código de desbloqueo fuerte** para tu dispositivo
3. **Habilita Face ID o Touch ID** si tu dispositivo lo soporta
4. **Activa el PIN de HoyCuenta** en la configuración de la aplicación
5. **Realiza copias de seguridad regulares** de tu dispositivo completo (si deseas preservar tus datos)
6. **No hagas jailbreak** a tu dispositivo, ya que compromete las protecciones de seguridad de iOS

## 6. Permisos del Sistema

HoyCuenta está diseñada para funcionar con los mínimos permisos posibles.

### 6.1 Permisos NO Solicitados

La aplicación **NO solicita ni requiere** los siguientes permisos:

- ❌ **Cámara**: No tomamos fotografías
- ❌ **Galería/Fotos**: No accedemos a tus imágenes
- ❌ **Ubicación**: No rastreamos dónde estás
- ❌ **Contactos**: No accedemos a tu agenda
- ❌ **Calendario**: No leemos tus eventos
- ❌8. Control y Gestión de tus Datos

### 8.1 Acceso a tus Datos

Tienes acceso completo y total a todos tus datos en todo momento a través de la interfaz de la aplicación. Puedes:

- Ver todos tus hábitos, ejercicios, mediciones y sesiones de ayuno
- Revisar tu historial completo
- Editar cualquier entrada
- Exportar o copiar información manualmente si lo necesitas

### 8.2 Eliminación de Datos

**Eliminación Selectiva:**
Puedes eliminar datos específicos en cualquier momento:
- Eliminar hábitos individuales (incluyendo todo su historial)
- Eliminar sesiones de ejercicio específicas
- Eliminar registros de mediciones individuales
- Eliminar sesiones de ayuno

**Eliminación Completa:**
Puedes eliminar TODOS tus datos de las siguientes maneras:

1. **Desde la Configuración de la App:**
   - Ve a Configuración → Borrar todos los datos
   - Confirma la acción
   - Todos los datos se eliminarán permanentemente de tu dispositivo
   - Esta acción es **irreversible**

2. **Desinstalando la Aplicación:**
   - Elimina la aplicación de tu dispositivo
   - iOS eliminará automáticamente todos los datos de la aplicación de su sandbox
   - Los datos NO permanecerán en el dispositivo después de la desinstalación

### 8.3 Portabilidad de Datos

Actualmente, HoyCuenta no ofrece una función automática de exportación de datos. Sin embargo:

- Todos tus datos son accesibles y visibles en la aplicación
- Puedes tomar capturas de pantalla de tus estadísticas y gráficos
- En futuras versiones, podríamos implementar exportación a formatos como CSV o JSON
- Los datos nunca se "bloquean" en nuestros servidores porque no existen tales servidores

### 8.4 Transferencia de Datos Entre Dispositivos

**Importante:** HoyCuenta no ofrece sincronización automática entre dispositivos. Si cambias de dispositivo:

- Tus datos NO se transferirán automáticamente
- Deberás comenzar de nuevo en el nuevo dispositivo
- **Opción recomendada:** Realiza copias de seguridad completas de tu dispositivo usando iTunes/Finder o iCloud Backup (backup del dispositivo completo, no de la app específica), lo cual preservará todos los datos de la aplicación al restaurar en un nuevo dispositivo

## 9. Privacidad de Menores

### 9.1 Edad Mínima

HoyCuenta no está dirigida específicamente a menores de edad, pero tampoco está prohibida para ellos. La aplicación es apropiada para todas las edades.

### 9.2 COPPA (Children's Online Privacy Protection Act)

Dado que HoyCuenta:
- NO recopila información personal de ningún usuario
- NO transmite datos a través de internet
- NO requiere registro o creación de cuenta

La aplicación cumple automáticamente con COPPA y puede ser utilizada por menores de 13 años sin preocupaciones de privacidad. No recopilamos "información personal" según la definición de COPPA.

### 9.3 Supervisión Parental

Recomendamos que los padres o tutores:
- Revisen la aplicación antes de permitir que menores la utilicen
- Supervisen el uso apropiado para la edad del menor
- Expliquen las funcionalidades de seguimiento de hábitos y ejercicios
- Configuren el PIN de seguridad si desean controlar el acceso

## 10. Cumplimiento Legal y Regulatorio

### 10.1 GDPR (Reglamento General de Protección de Datos - Europa)

Aunque HoyCuenta no opera activamente en la Unión Europea ni recopila datos, si un usuario europeo utiliza la aplicación:

- **No aplicable en su mayoría** porque no procesamos datos personales
- **Derecho al olvido**: Cumplido automáticamente (elimina la app o usa "Borrar todos los datos")
- **Derecho de acceso**: Cumplido (todos los datos son visibles en la app)
- **Derecho de portabilidad**: Los datos están en tu dispositivo
- **Consentimiento**: No requerido porque no recopilamos datos

### 10.2 CCPA (California Consumer Privacy Act)

Para usuarios en California:

- No vendemos información personal (porque no la recopilamos)
- No compartimos información personal con terceros
- No hay necesidad de "opt-out" porque no hay tracking
- Tienes control total sobre tus datos locales

### 10.3 Otras Jurisdicciones

HoyCuenta cumple con las leyes de privacidad de prácticamente todas las jurisdicciones porque nuestro enfoque de "cero recopilación de datos" es más estricto que cualquier regulación existente
### 10.4 Cumplimiento de Leyes de Exportación

**Regulaciones de Exportación de Criptografía:**

HoyCuenta cumple con las regulaciones de exportación de los Estados Unidos y otras jurisdicciones aplicables:

- **Criptografía Utilizada**: La aplicación utiliza únicamente las funciones de cifrado estándar proporcionadas por el sistema operativo iOS (cifrado a nivel de sistema cuando el dispositivo está bloqueado, iOS Keychain para almacenamiento seguro del PIN)

- **Clasificación ERN (Encryption Registration Number)**: No aplicable - La aplicación no implementa, contiene o utiliza criptografía propia más allá de las llamadas estándar al sistema operativo iOS

- **Exención de Exportación**: HoyCuenta califica para exención bajo las regulaciones de exportación de EE.UU. ya que:
  - Solo utiliza criptografía estándar del sistema operativo
  - No implementa algoritmos criptográficos propios
  - No se considera un "artículo criptográfico" bajo EAR (Export Administration Regulations)

- **Distribución Internacional**: La aplicación puede ser distribuida globalmente a través de la App Store sin restricciones de exportación, cumpliendo con las regulaciones aplicables de comercio internacional

**Declaración de Cumplimiento:**
Esta aplicación ha sido clasificada conforme a las regulaciones de exportación de los Estados Unidos y cumple con todos los requisitos aplicables para su distribución internacional.### 7.1 Sin Integraciones de Terceros

HoyCuenta **NO integra ni utiliza** ningún servicio, SDK, biblioteca o proveedor de terceros que recopile datos, incluyendo pero no limitado a:

**Análisis y Tracking:**
- ❌ Google Analytics
- ❌ Firebase Analytics
- ❌ Mixpanel
- ❌11. Cambios Futuros y Actualizaciones

### 11.1 Compromiso de Privacidad

Nos comprometemos a mantener nuestro enfoque de privacidad extrema en todas las futuras versiones de HoyCuenta. Si alguna vez consideramos agregar cualquier funcionalidad que requiera recopilación de datos, nos comprometeremos a:

1. **Hacerlo completamente opcional** (opt-in, no opt-out)
2. **Notificarte de manera prominente** antes de implementarlo
3. **Explicar claramente** qué datos se recopilarían y por qué
4. **Obtener tu consentimiento explícito** antes de proceder
5. **Permitirte continuar usando la aplicación** sin esa funcionalidad si lo prefieres

### 11.2 Actualizaciones de esta Política

Nos reservamos el derecho de actualizar esta Política de Privacidad en cualquier momento. Cuando lo hagamos:

- Actualizaremos la fecha de "Última actualización" al inicio de este documento
- Incrementaremos el número de versión
- Publicaremos la nueva política en esta página
- Si los cambios son significativos, lo notificaremos dentro de la aplicación en la próxima actualización

**Continuidad del Uso:**
Tu uso continuado de HoyCuenta después de cualquier modificación a esta Política de Privacidad constituye tu aceptación de dichos cambios. Te recomendamos revisar esta política periódicamente.

**Historial de Cambios:**
- Versión 1.0 (25 de diciembre de 2025): Política inicial

## 12. Transparencia y Verificación

### 12.1 Código Abierto (Futuro)

Estamos considerando hacer que HoyCuenta sea de código abierto en el futuro, lo que permitiría:

- Auditoría pública del código fuente
- Verificación independiente de nuestras afirmaciones de privacidad
- Contribuciones de la comunidad
- Mayor confianza a través de transparencia total

### 12.2 Auditorías de Privacidad

Alentamos a investigadores de seguridad y expertos en privacidad a:

- Analizar el tráfico de red de la aplicación (confirmarán que es cero)
- Revisar los permisos solicitados
- Examinar el comportamiento de la aplicación
- Reportarnos cualquier hallazgo

## 13. Preguntas Frecuentes sobre Privacidad

**P: ¿Por qué no ofrecen sincronización en la nube?**
R: Porque la sincronización en la nube requeriría enviar tus datos a nuestros servidores, violando nuestro principio fundamental de privacidad. Priorizamos tu privacidad sobre la conveniencia de la sincronización.

**P: ¿Cómo ganan dinero sin vender mis datos o mostrar anuncios?**
R: HoyCuenta es actualmente gratuita. En el futuro, podríamos ofrecer una versión de pago con funciones adicionales, pero NUNCA monetizaremos tus datos.

**P: ¿Pueden ayudarme a recuperar mis datos si pierdo mi dispositivo?**
R: Desafortunadamente no, porque no tenemos acceso a tus datos. Están solo en tu dispositivo. Recomendamos realizar copias de seguridad regulares de tu dispositivo completo.

**P: ¿Puedo confiar en que realmente no recopilan datos?**
R: Sí. Puedes verificarlo utilizando herramientas de análisis de tráfico de red como Charles Proxy o Wireshark. Verás que la aplicación no realiza ninguna conexión a internet. Además, estamos considerando hacer el código abierto para verificación pública.

**P: ¿Qué sucede con mis datos si la aplicación se actualiza?**
R: Tus datos permanecen en tu dispositivo durante las actualizaciones. Las actualizaciones solo modifican el código de la aplicación, no tus datos almacenados localmente.

**P: ¿Mis datos están cifrados?**
R: Sí, se benefician del cifrado a nivel del sistema operativo iOS cuando tu dispositivo está bloqueado. Además, el PIN opcional proporciona una capa adicional de seguridad.

## 14. Contacto y Soporte

### 14.1 Información de Contacto

Si tienes preguntas, inquietudes o solicitudes relacionadas con esta Política de Privacidad o con prácticas de privacidad en general, puedes contactarnos:

- **Email**: privacidad@hoycuenta.app
- **Soporte General**: soporte@hoycuenta.app

### 14.2 Tiempo de Respuesta

Nos esforzamos por responder a todas las consultas relacionadas con privacidad dentro de 48-72 horas hábiles.

### 14.3 Reportar Problemas de Privacidad

Si identificas algún problema o vulnerabilidad de privacidad en HoyCuenta, te pedimos que nos lo reportes responsablemente enviando un correo a: privacidad@hoycuenta.app

Tomaremos cualquier reporte seriamente e investigaremos y abordaremos los problemas de manera oportuna.

## 15. Declaración Final

En HoyCuenta, creemos que la privacidad no es solo un derecho fundamental, sino también un requisito esencial para una aplicación de seguimiento de hábitos de salud y bienestar. Tu información sobre tus hábitos, ejercicios, mediciones corporales y rutinas de ayuno es profundamente personal.

**Nuestro compromiso es simple y absoluto:**

✅ **NUNCA** recopilaremos tus datos personales
✅ **NUNCA** transmitiremos tu información fuera de tu dispositivo  
✅ **NUNCA** venderemos, compartiremos o monetizaremos tus datos
✅ **NUNCA** rastrearemos tu comportamiento o ubicación
✅ **NUNCA** mostraremos publicidad basada en tus datos
✅ **SIEMPRE** mantendremos tus datos bajo tu control exclusivo
✅ **SIEMPRE** seremos transparentes sobre nuestras prácticas
✅ **SIEMPRE** priorizaremos tu privacidad sobre cualquier otra consideración comercial

**Tu viaje de mejora personal es tuyo y solo tuyo. Tus datos deben serlo también.**

---

**Resumen Ejecutivo:**

- 🔒 **Cero recopilación**: No recopilamos ningún dato personal o técnico
- 📱 **100% local**: Todo se almacena únicamente en tu dispositivo
- 🚫 **Sin servidores**: No tenemos infraestructura para recopilar datos
- 🔍 **Sin seguimiento**: No utilizamos análisis, cookies ni tracking
- 📊 **Sin terceros**: No integramos ningún servicio externo
- 💰 **Sin monetización de datos**: Nunca venderemos tus datos
- 🛡️ **Protección con PIN**: Seguridad adicional opcional
- ✅ **Control total**: Elimina tus datos cuando quieras
- 🌍 **Cumplimiento global**: Excedemos todos los requisitos de privacidad
- 💚 **Filosofía de privacidad**: Construido desde cero con privacidad como prioridad

---

**Fecha de Vigencia:** Esta Política de Privacidad es efectiva a partir del 25 de diciembre de 2025.

**Versión:** 1.0

**Documento**: Política de Privacidad de HoyCuenta

© 2025 HoyCuenta. Todos los derechos reservados
- ❌ Crash reporting (Crashlytics, Sentry, etc.)
- ❌ Herramientas de testing A/B
- ❌ Herramientas de mapas de calor

### 7.2 Librerías de Código Abierto

La aplicación utiliza algunas librerías de código abierto estándar de Flutter para funcionalidad básica:

- **provider**: Gestión de estado (no recopila datos)
- **shared_preferences**: Almacenamiento local (no transmite datos)
- **intl**: Internacionalización (no recopila datos)
- **fl_chart**: Generación de gráficos (procesamiento local)
- **material_symbols_icons**: Iconos (recursos estáticos)

Todas estas librerías operan completamente offline y no transmiten ningún dato.tos" en Configuración
  - Restaures tu dispositivo a configuración de fábrica

**Sin Sincronización:**
- No hay sincronización automática con iCloud u otros servicios en la nube
- No hay copia de seguridad automática en servidores externos
- Si cambias de dispositivo, tus datos NO se transferirán automáticamente
- Eres responsable de mantener tus propias copias de seguridad del dispositivo si lo deseas

### 4.3 Procesamiento de Datos

Todo el procesamiento de datos ocurre **localmente en tu dispositivo**:

- **Cálculos Estadísticos**: Rachas, promedios, totales y gráficos se calculan en tiempo real en tu dispositivo
- **Generación de Gráficos**: Todos los gráficos y visualizaciones se generan localmente
- **Clasificación y Organización**: El ordenamiento y filtrado de datos se realiza en el dispositivo
- **Notificaciones**: Si implementamos notificaciones futuras, se programarán localmente sin enviar datos a servidores externos

## Seguridad

La aplicación ofrece una opción de protección con PIN para añadir una capa adicional de seguridad a tus datos locales. Este PIN se almacena de forma segura en tu dispositivo y no se transmite a ningún servidor.

## Permisos de la aplicación

HoyCuenta solicita los siguientes permisos únicamente para funcionalidades específicas:

- **Ninguno**: La aplicación no requiere permisos especiales del sistema. No accede a tu cámara, galería, contactos, ubicación ni ningún otro dato sensible.

## Datos de terceros

HoyCuenta **NO** integra:
- Servicios de análisis de terceros
- Redes publicitarias
- Herramientas de seguimiento
- SDKs de redes sociales
- Servicios de almacenamiento en la nube

## Eliminación de datos

Puedes eliminar todos tus datos en cualquier momento desde la sección de Configuración de la aplicación utilizando la opción "Borrar todos los datos". Esta acción es irreversible y borrará permanentemente toda tu información del dispositivo.

## Cambios en los datos

Si desinstalas la aplicación, todos los datos almacenados localmente se eliminarán de tu dispositivo de acuerdo con las políticas del sistema operativo.

## Niños

HoyCuenta no está dirigida específicamente a menores de 13 años, pero dado que no recopilamos ningún dato personal, puede ser utilizada por usuarios de cualquier edad bajo supervisión parental adecuada.

## Cambios a esta Política de Privacidad

Podemos actualizar nuestra Política de Privacidad ocasionalmente. Te notificaremos cualquier cambio publicando la nueva Política de Privacidad en esta página y actualizando la fecha de "Última actualización".

Se te aconseja revisar esta Política de Privacidad periódicamente para cualquier cambio. Los cambios a esta Política de Privacidad son efectivos cuando se publican en esta página.

## Contacto

Si tienes alguna pregunta sobre esta Política de Privacidad, puedes contactarnos:

- Por correo electrónico: privacidad@hoycuenta.app

## Resumen

**HoyCuenta respeta tu privacidad de forma absoluta:**
- ✅ Cero recopilación de datos personales
- ✅ Almacenamiento 100% local en tu dispositivo
- ✅ Sin servidores externos
- ✅ Sin seguimiento ni análisis
- ✅ Sin publicidad
- ✅ Control total de tus datos
- ✅ Opción de protección con PIN

Tu información es tuya y solo tuya. Así debe ser.
