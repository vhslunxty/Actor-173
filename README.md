# SCP-173 — Roblox Script

Script SCP-173 pour Roblox, inspiré du style addon **GMod / Facepunch** avec un système de hooks, timers et ENT modulaire.

---

## Structure

```
SCP173/
├── Main.lua       # Point d'entrée — lance la boucle et branche les hooks
├── Hook.lua       # Système d'events style GMod (hook.Add / hook.Run / hook.Remove)
├── Timer.lua      # Wrapper task.delay/spawn style GMod (timer.Create / timer.Simple)
├── ENT.lua        # Logique complète du SCP-173
├── Config.lua     # Valeurs configurables
└── README.md
```

---

## Installation dans Roblox Studio

1. Créer un `Model` dans `Workspace` nommé `SCP173`
2. Ajouter dedans :
   - `HumanoidRootPart` (PrimaryPart)
   - `Head`
   - `Humanoid`
   - `Main` → **Script**
   - `Hook` → **ModuleScript**
   - `Timer` → **ModuleScript**
   - `ENT` → **ModuleScript**
   - `Config` → **ModuleScript**
3. Copier le contenu de chaque fichier dans le ModuleScript/Script correspondant

---

## Configuration

Dans `Config.lua` :

| Clé | Défaut | Description |
|-----|--------|-------------|
| `spd` | `0` | Vitesse de marche (0 = immobile sauf si non regardé) |
| `killr` | `4` | Rayon de kill en studs |
| `blinkt` | `6` | Cooldown du blink en secondes |
| `snapr` | `60` | Distance max de détection de ligne de vue |
| `dmg` | `100` | Dégâts infligés aux joueurs proches |

---

## Système de Hooks

Inspiré de `hook.Add` / `hook.Run` de GMod. Tu peux override ou écouter n'importe quel événement sans toucher au code principal.

```lua
local hook = require(script.Parent.Hook)

hook.Add("SCP173:Blink", "monAddon", function(ent, tgt)
    print("SCP-173 a blinké vers " .. tgt.Name)
end)

hook.Add("SCP173:Think", "monAddon", function(ent)
    -- appelé chaque Heartbeat quand le SCP bouge
end)
```

### Hooks disponibles

| Hook | Arguments | Moment |
|------|-----------|--------|
| `SCP173:Spawned` | `ent` | À l'initialisation |
| `SCP173:Think` | `ent` | Chaque Heartbeat (non-freezé) |
| `SCP173:Blink` | `ent, target` | Après chaque téléportation |
| `SCP173:Removed` | `ent` | Quand le Model est retiré du Workspace |

---

## Logique

```
Heartbeat
 ├── IsWatched() → au moins 1 joueur regarde ?
 │    ├── OUI → freeze (WalkSpeed = 0)
 │    └── NON → GetTarget() → MoveTo()
 │               KillNear() → TakeDamage si dans killr
 │               hook.Run("SCP173:Think")
 │
timer (blinkt secondes)
 └── Blink() → Raycast autour de la cible → Snap() → hook.Run("SCP173:Blink")
```

---

## Détection ligne de vue

```lua
-- CanSee() dans ENT.lua
-- 1. Distance > snapr → false
-- 2. Raycast entre Head et SCP → obstrué → false  
-- 3. DotProduct LookVector > 0.6 (~53°) → true
```

---

## Licence

MIT — libre d'utilisation, modification et distribution.
