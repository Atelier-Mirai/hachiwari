# Hachiwari

Hachiwari debe su nombre al objetivo de alcanzar un 80 % de victorias. Es una gema de Ruby que te muestra cuántas victorias necesitas para llegar a tu porcentaje objetivo (el objetivo predeterminado es 80 %).

Para documentación en otros idiomas, consulta [README.md](README.md) / [README.en.md](README.en.md) / [README.fr.md](README.fr.md) / [README.de.md](README.de.md).

## Instalación

Instálalo ejecutando:

```
% gem install hachiwari
```

## Uso

### Mostrar el número de victorias necesarias para alcanzar la tasa objetivo (con guardado automático)

```
% hachiwari [status] [wins] [losses] [target] [language]
```

- Puedes omitir `status` y pasar únicamente los argumentos.
- El alias heredado `s` está en desuso; al usarlo se mostrará una advertencia y se ejecutará `status` internamente.
- Hay cuatro argumentos: número de victorias, número de derrotas, porcentaje objetivo y idioma de salida. Todos son opcionales.
- Si no proporcionas argumentos, se mostrará el registro actual usando los valores predeterminados o los datos guardados previamente. Los valores predeterminados son victorias: 0, derrotas: 0, porcentaje objetivo: 80 %, idioma: japonés (`ja`).
- Si proporcionas el número de victorias como primer argumento, se mostrará la cantidad de victorias adicionales necesarias a partir de ese valor. El resto de los argumentos usará valores predeterminados o guardados.
- El número de victorias proporcionado se guarda automáticamente en `~/.hachiwari`.
- Para actualizar el número de derrotas, pásalo como segundo argumento.
- Para cambiar el porcentaje objetivo, proporciónalo como tercer argumento (por ejemplo `90` para un objetivo del 90 %).
- Para cambiar el idioma, usa el cuarto argumento. Especifica `ja` para japonés (predeterminado), `en` para inglés, `es` para español, `fr` para francés o `de` para alemán.

Para obtener el resultado sin guardarlo, agrega la opción `--trial` (o `-t`):

```
% hachiwari [status] --trial [wins] [losses] [target] [language]
```

Los argumentos funcionan igual que en el comando `status`, pero el estado no se persiste. Los comandos heredados `info`, `i` y `calculate` están obsoletos; se mostrará una advertencia y se comportarán como `status --trial`.

### Mostrar la versión de Hachiwari

```
% hachiwari version
```

Muestra la versión instalada de Hachiwari.

### Borrar los datos guardados

```
% hachiwari clear
```

Elimina el archivo `.hachiwari` guardado. Si no existe, solo se mostrará una advertencia.

### Mostrar la lista de comandos o la ayuda detallada

```
% hachiwari --help
% hachiwari status --help
```

`hachiwari --help` muestra la lista de comandos disponibles, y `hachiwari <comando> --help` muestra la ayuda detallada de cada comando.

### Comandos obsoletos

Los siguientes comandos/alias están obsoletos. Al ejecutarlos se mostrará una advertencia y se realizará una acción de compatibilidad:

- **s**: Era un alias de `status`. Se mostrará una advertencia y se ejecutará `status`.
- **info / i**: Realizaban una simulación sin guardar. Ahora muestran una advertencia y se comportan como `status --trial`.
- **calculate**: Permitía calcular solo con opciones. Ahora muestra una advertencia y se comporta como `status --trial` (los parámetros `--target`/`--language` siguen disponibles).

## Desarrollo

Clona el repositorio y prepara el entorno con:

```
bundle install
bundle exec rake test
```

- **Instalar dependencias**: `bundle install`
- **Ejecutar pruebas**: `bundle exec rake test`
- **Comprobar el CLI manualmente**: `bundle exec ruby -Ilib bin/hachiwari --help`

Para instalar la gema localmente, ejecuta `bundle exec rake install`.

### Publicar una nueva versión

1. Actualiza `VERSION` en `lib/hachiwari/version.rb`.
2. Haz commit y push de los cambios.
3. Ejecuta `bundle exec rake release`.

Este comando creará la etiqueta git, la publicará y subirá la gema a [rubygems.org](https://rubygems.org).

## Contribuir

Aceptamos informes de errores y pull requests en [GitHub](https://github.com/Atelier-Mirai/hachiwari).

## Licencia

Este software se distribuye bajo la [Licencia MIT](https://opensource.org/licenses/MIT). Consulta [LICENSE](./LICENSE) para más detalles.
