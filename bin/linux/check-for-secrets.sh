#!/bin/bash

# Durchlaufe alle Unterordner im aktuellen Verzeichnis
for dir in */; do
  # Wechsle in den Unterordner
  cd "$dir"
  
  # Überprüfe, ob es sich um ein Git-Repository handelt
  if [ -d ".git" ]; then
    echo "Repository: $dir"
    # Führe den git log Befehl aus
    git log -S "kind: Secret" --pretty=format:"%h - %an, %ar : %s"
    echo # Neue Zeile für Lesbarkeit
  else
    echo "Kein Git-Repository in $dir"
  fi

  # Gehe zurück in das ursprüngliche Verzeichnis
  cd ..
done
