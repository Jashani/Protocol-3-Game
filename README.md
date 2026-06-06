# Protocol 3 Game

A Godot 4.5 web application used as a political psychology research tool. Participants are shown politically-charged news headlines alongside a simulated social-media comment, rate their beliefs, and post a response. Exported as a web build and embedded in a jsPsych study via `<iframe>`.

---

## Participant flow

| Stage | Scene | What happens |
|-------|-------|--------------|
| 1a | `stages/1_1_instructions` | Information sheet — bullet-point consent items, single "I agree" checkbox gates proceed |
| 1b | `stages/1_2_instructions` | Task instructions — single proceed button |
| 2 | `stages/2_1_leaning` | Player selects political affiliation (Republican / Democrat) |
| 2a | `stages/1_3_priors_accuracy` | Prior beliefs: expected accuracy of Republican/Democrat users per topic (order randomized) |
| 2b | `stages/1_4_priors_bias` | Prior beliefs: expected bias of Republican/Democrat users per topic (order randomized) |
| 3a | `stages/3_1_waiting_room` | Fake matchmaking wait (random 5–15 s) |
| 3b | `stages/3_2_post_waiting_room` | "You've been matched" screen before entering the discussion |
| 4 | `stages/4_discussion_room` | **Core loop** — repeated for each of the 8 scenarios (see below) |
| 5 | `stages/5_demographics` | Age, gender, education, required sharing-feeling response, optional comments |
| 6 | `stages/6_end` | Saves all data and shows completion screen |

### Discussion room loop (stage 4)

For each scenario the discussion room:

1. Displays the headline as the room title.
2. Shows **before** slider prompts (prior belief in headline truthfulness).
3. After a short simulated typing delay, shows the NPC comment.
4. Shows **after** slider prompts (posterior belief, NPC reliability, attention check, commenter bias).
5. Shows the opinion popup — player picks support / unsure / oppose and writes a text response.
6. Reloads itself for the next scenario; advances to stage 5 when all scenarios are exhausted.

---

## Configuration

### Scenarios — `scenarios.json`

The file has three top-level keys:

**`headlines`** — four topics (`crime`, `education`, `environment`, `immigration`), each with three left-leaning and three right-leaning headlines. Headlines have only `id` and `title`; responses are not embedded here.

```json
{
  "headlines": [
    {
      "type": "crime",
      "left": [
        { "id": 1, "title": "Chicago Study Finds Police..." }
      ],
      "right": [
        { "id": 4, "title": "Violent Crime Surged in Cities..." }
      ]
    }
  ]
}
```

**`responses`** — a pool of 8 paired response strings used as NPC comments.

```json
{
  "responses": [
    { "support": "I know this is true.", "oppose": "I know this is false." }
  ]
}
```

**`arrangements`** — 8 fixed combinations that define how each round is structured: which side's headline to show (`left`/`right`), what affiliation the NPC commenter presents (`left`/`right`), and what stance they take (`support`/`oppose`).

```json
{
  "arrangements": [
    { "headline": "left",  "comment": "left",  "stance": "support" },
    { "headline": "left",  "comment": "left",  "stance": "oppose"  },
    { "headline": "left",  "comment": "right", "stance": "support" },
    { "headline": "left",  "comment": "right", "stance": "oppose"  },
    { "headline": "right", "comment": "left",  "stance": "support" },
    { "headline": "right", "comment": "left",  "stance": "oppose"  },
    { "headline": "right", "comment": "right", "stance": "support" },
    { "headline": "right", "comment": "right", "stance": "oppose"  }
  ]
}
```

At startup `scenarios.gd` picks one headline per arrangement from the matching pool (shuffled), draws a random response pair from the response pool, and combines them. The 8 resulting rounds are then shuffled before play begins.

### Prompts — `config.json`

Defines all slider prompts shown in the discussion room. Each prompt runs either `"before"` or `"after"` the NPC comment appears.

```json
{
  "prompts": [
    {
      "type": "slider",
      "stage": "before",
      "column_name": "belief_prior",
      "text": "How likely do you think the headline is to be true?",
      "labels": ["Very unlikely", "Very likely"],
      "min_value": 0.0,
      "max_value": 100.0,
      "value": 50.0
    }
  ]
}
```

| Field | Description |
|-------|-------------|
| `type` | Always `"slider"` |
| `stage` | `"before"` or `"after"` the NPC comment |
| `column_name` | Key used in the saved data |
| `text` | Question shown to the participant |
| `labels` | Array of end-labels for the slider |
| `min_value` / `max_value` | Slider range |
| `value` | Default slider position (overridden by `use_previous`) |
| `use_previous` | If `true`, inherits the previous slider's final value as default |

Current prompts (in order):

| `column_name` | Stage | Question summary |
|---------------|-------|-----------------|
| `belief_prior` | before | Prior belief in headline truthfulness |
| `belief_posterior` | after | Posterior belief (inherits prior value as default) |
| `reliability` | after | How likely is this user to have accurate beliefs about the headline's topic |
| `attention_check` | after | Whether the comment supported or opposed the headline |
| `commenter_bias_rating` | after | Perceived political bias of the NPC commenter |

---

## Data output

Data is collected in two layers:

**Per-round** (saved to `Data.rounds[]`):

| Key | Description |
|-----|-------------|
| `scenario_id` | Headline ID from `scenarios.json` |
| `headline_type` | e.g. `"left_crime"` |
| `npc_affiliation` | `"left"` or `"right"` |
| `comment` | NPC comment text |
| `comment_leaning` | `"support"` or `"oppose"` |
| `belief_prior` | Slider value |
| `belief_posterior` | Slider value |
| `reliability` | Slider value |
| `attention_check` | Slider value |
| `commenter_bias_rating` | Slider value |
| `post_valence` | Player's opinion: `"support"`, `"unsure"`, or `"oppose"` |
| `post_content` | Player's written response |

**Global** (saved to `Data.results`):

| Key | Description |
|-----|-------------|
| `participant_id` | Currently always `0` (TODO) |
| `prior_accuracy_republican_crime` | Prior belief: Republican accuracy on crime (0–100) |
| `prior_accuracy_republican_education` | … education |
| `prior_accuracy_republican_immigration` | … immigration |
| `prior_accuracy_republican_environment` | … environment |
| `prior_accuracy_democrat_*` | Same four fields for Democrat |
| `prior_bias_republican_crime` | Prior belief: Republican bias on crime (0–100) |
| `prior_bias_republican_education` | … education |
| `prior_bias_republican_immigration` | … immigration |
| `prior_bias_republican_environment` | … environment |
| `prior_bias_democrat_*` | Same four fields for Democrat |
| `age` | From demographics |
| `gender` | From demographics |
| `education` | From demographics |
| `sharing_feeling` | Required: how participant felt about sharing views publicly |
| `feedback` | Optional: general comments / confusions |
| `participant_affiliation` | Affiliation selected in stage 2 |

### Saving

- **Web** (normal deployment): sends a JSON string to `window.parent.receiveGodotData()` for the embedding jsPsych page to handle.
- **Desktop** (local testing): writes to `res://test.json`.

---

## Running locally

Open the project in **Godot 4.5** (GL Compatibility renderer). Press **F5** to run from the editor. Data will be written to `test.json` in the project root.

## Building for web

Use the **Web** export preset (`export_presets.cfg`). The resulting HTML/JS bundle should be served over HTTPS and embedded in a jsPsych study as an `<iframe>`. The parent page must expose `receiveGodotData(jsonString)` on `window`.
