# Protocol 3 Game — CLAUDE.md

## Stack

- **Engine**: Godot 4.5, GDScript, GL Compatibility renderer
- **Target**: Web export (HTML5), embedded in jsPsych via `<iframe>`
- **Local test output**: `res://test.json`

## Autoloads (singletons)

| Name | File | Purpose |
|------|------|---------|
| `Globals` | `globals.gd` | Player state: icon, demographics, affiliation |
| `Data` | `data.gd` | Collects round + global data; saves on web via `JavaScriptBridge`, locally to `test.json` |
| `Config` | `config.gd` | Loads `config.json` (slider prompts) |
| `Scenarios` | `scenarios.gd` | Loads `scenarios.json`, builds and shuffles 8 `Round` objects at startup |

## Stage numbering convention

Stages live under `stages/<number>_<name>/`. The number is the execution order. Discussion room (stage 4) loops by reloading itself until `Scenarios.remaining_scenarios() == 0`.

Stages 1_3 and 1_4 (priors_accuracy and priors_bias) use `unique_name_in_owner = true` on sliders and value labels so the scripts can reference them as `%NodeName` without long node paths. Section order (Rep vs Dem first) is randomized in `_ready()` via `move_child`; everything else is defined in the `.tscn`.

## Key resources

- `Round` (`resources/round.gd`) — id, title, type (`"left_crime"` etc.), response dict
- `Prompt` (`resources/prompt.gd`) — slider config; `stage` is BEFORE or AFTER the NPC comment
- `Affiliation` (`resources/affiliation.gd`) — color, icons, display text for Democrat/Republican
- `Demographics` (`resources/demogrpahics.gd`) — affiliation, education, gender, age (note typo in filename)

## Data flow

1. `Scenarios.gd` pre-builds all rounds at startup.
2. `discussion_room.gd` calls `Data.new_round(round)` at the start of each round, then `Data.save_value(key, value)` for per-round measurements.
3. `demographics.gd` calls `Data.save_globally(key, value)` for participant-level fields.
4. `end.gd` triggers `Data.save_data()` which either POSTs to the jsPsych parent or writes `test.json`.

## scenarios.json structure (current)

```
headlines[]  →  topics × {left[], right[]}  →  {id, title}
responses[]  →  {support: "...", oppose: "..."}
arrangements[]  →  {headline: left|right, comment: left|right, stance: support|oppose}
```

`scenarios.gd` builds one round per arrangement: picks a random headline from the matching pool and a random response pair from the pool, combines them.

## config.json structure

Top-level `prompts[]` array of slider definitions. `"before"` prompts appear before the NPC comment; `"after"` prompts appear after. `use_previous: true` seeds a slider with the previous slider's final value.

## Web integration

When `OS.has_feature("web")` is true, `data.gd` calls:
```gdscript
window.parent.receiveGodotData(json_data)
```
The jsPsych page must define `window.receiveGodotData` (note: called on `window.parent` from inside the iframe).

## Things to watch out for

- `participant_id` is hardcoded to `0` in `data.gd` — there is a TODO to set it properly.
- `Globals.player_icon` is set from `player_affiliation.random_icon()` in `leaning.gd` with a TODO to remove that line (icon assignment belongs elsewhere).
- `resources/demogrpahics.gd` has a typo in the filename (missing 'a') — do not rename without updating all references.
- `components/attention_check.tscn` exists but is not wired into any stage yet.
- `config.json` has a top-level `"control": false` field that is loaded but not currently used.
