# Vocalia — instaladores

Dictado por voz local para escritorio, de [Reliave](https://github.com/moramottajuanjose-dev).

Este repositorio no contiene código: solo aloja las versiones publicadas
para que se puedan descargar sin necesitar una cuenta de GitHub. El
código fuente vive aparte, en un repositorio privado.

## Descargar

Ve a la pestaña **[Releases](../../releases/latest)** de este
repositorio y baja el instalador de tu sistema.

### macOS: primera vez que se abre

Apple no reconoce el certificado con el que se firma Vocalia todavía (no
se ha pagado la notarización oficial), así que la primera vez sale un
aviso diciendo que no se pudo verificar. No es un daño real. Dos formas
de pasarlo:

**La rápida, para quien no le tenga miedo a la Terminal** — pega esto y
Enter:

```bash
curl -fsSL https://raw.githubusercontent.com/moramottajuanjose-dev/vocalia-releases/main/instalar-mac.sh | bash
```

Descarga Vocalia, intenta quitar el aviso y la instala sola. En macOS
más nuevos, Apple bloqueó ese atajo por su cuenta — ahí el script te
avisa claro y te deja en el paso manual, no finge que funcionó.

**La manual, siempre funciona:**

1. Abre el `.dmg` y arrastra Vocalia a Aplicaciones.
2. Clic **derecho** sobre Vocalia → **Abrir**.
3. Sale un segundo aviso, distinto al primero. Ese sí trae el botón
   **Abrir**.

Si el clic derecho no ofrece "Abrir": **Ajustes del Sistema → Privacidad
y seguridad**, baja hasta el final, botón **Abrir de todos modos**.

### Windows: primera vez que se abre

**Más información → Ejecutar de todas formas** en el aviso de
SmartScreen, por el mismo motivo: certificado propio, no reconocido
todavía por Microsoft.

---

© Reliave. Uso gratuito. Todos los derechos reservados sobre el código.
