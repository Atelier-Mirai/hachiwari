# Hachiwari

Hachiwari leitet sich vom Ziel ab, eine Siegquote von 80 % zu erreichen. Die Ruby-Gem zeigt, wie viele zusätzliche Siege nötig sind, um das gesetzte Ziel zu schaffen (Standardziel: 80 %).

Weitere Sprachen: [README.md](README.md) (Japanisch) / [README.en.md](README.en.md) (Englisch) / [README.es.md](README.es.md) (Spanisch) / [README.fr.md](README.fr.md) (Französisch).

## Installation

Installiere die Gem mit:

```
% gem install hachiwari
```

## Verwendung

### Anzahl der benötigten Siege zur Zielquote anzeigen (mit automatischer Speicherung)

```
% hachiwari [status] [wins] [losses] [target] [language]
```

- `status` kann weggelassen werden; übergib einfach die Argumente.
- Der alte Alias `s` ist veraltet. Bei Verwendung erscheint eine Warnung und `status` wird intern ausgeführt.
- Es gibt vier Argumente: Siege, Niederlagen, Zielquote und Ausgabesprache. Alle sind optional.
- Ohne Argumente wird der aktuelle Stand anhand der Standardwerte oder gespeicherter Daten gezeigt. Standard: Siege 0, Niederlagen 0, Zielquote 80 %, Sprache Japanisch (`ja`).
- Gibst du Siege als erstes Argument an, berechnet Hachiwari, wie viele zusätzliche Siege dafür noch fehlen. Die übrigen Argumente greifen auf Standard- oder gespeicherte Werte zurück.
- Die eingegebenen Siege werden automatisch in `~/.hachiwari` gespeichert.
- Um Niederlagen zu aktualisieren, übergib sie als zweites Argument.
- Zum Anpassen der Zielquote nutze das dritte Argument (z. B. `90` für 90 %).
- Zum Ändern der Sprache verwende das vierte Argument. Unterstützt werden `ja` (Japanisch, Standard), `en` (Englisch), `es` (Spanisch), `fr` (Französisch) und `de` (Deutsch).

Um das Ergebnis ohne Speicherung anzuzeigen, hänge die Option `--trial` (oder kurz `-t`) an:

```
% hachiwari [status] --trial [wins] [losses] [target] [language]
```

Die Argumente funktionieren wie beim regulären `status`, aber es wird nichts gespeichert. Die früheren Befehle `info`, `i` und `calculate` sind veraltet; sie zeigen eine Warnung und verhalten sich wie `status --trial`.

### Version von Hachiwari anzeigen

```
% hachiwari version
```

Zeigt die installierte Version von Hachiwari an.

### Gespeicherte Daten löschen

```
% hachiwari clear
```

Löscht die gespeicherte Datei `.hachiwari`. Existiert sie nicht, erscheint nur eine Warnung.

### Befehlsliste oder Detailhilfe anzeigen

```
% hachiwari --help
% hachiwari status --help
```

`hachiwari --help` listet verfügbare Befehle auf; `hachiwari <befehl> --help` zeigt detaillierte Hilfe.

### Veraltete Befehle

Folgende Befehle/Aliase sind veraltet. Bei Ausführung erscheint eine Warnung, danach erfolgt ein kompatibles Verhalten:

- **s**: Früher ein Alias von `status`. Warnung und anschließende Ausführung von `status`.
- **info / i**: Dienten früher als Simulation ohne Speicherung. Jetzt Warnung und Verhalten wie `status --trial`.
- **calculate**: Diente dem reinen Options-basierten Berechnen. Jetzt Warnung und Verhalten wie `status --trial` (Optionen `--target`/`--language` bleiben nutzbar).

## Entwicklung

Klone das Repository und richte die Umgebung mit:

```
bundle install
bundle exec rake test
```

- **Abhängigkeiten installieren**: `bundle install`
- **Tests ausführen**: `bundle exec rake test`
- **CLI manuell prüfen**: `bundle exec ruby -Ilib bin/hachiwari --help`

Zum lokalen Installieren der Gem: `bundle exec rake install`.

### Neue Version veröffentlichen

1. `VERSION` in `lib/hachiwari/version.rb` anpassen.
2. Änderungen committen und pushen.
3. `bundle exec rake release` ausführen.

Damit werden Tag und Commits erstellt und gepusht, und die Gem wird auf [rubygems.org](https://rubygems.org) veröffentlicht.

## Mitwirken

Fehlerberichte und Pull Requests sind auf [GitHub](https://github.com/Atelier-Mirai/hachiwari) willkommen.

## Lizenz

Diese Gem steht unter der [MIT-Lizenz](https://opensource.org/licenses/MIT). Details siehe [LICENSE](./LICENSE).
