# Protocol 3 Game

## Configuration

### Editing scenarios/headlines

Scenarios can be edited through the `scenarios.json` file.
This file contains all possible scenarios and their responses.
Not all scenarios are always displayed; one scenario is randomly selected per topic and per leaning for each game.

The file contains a list of topics, and lists of left-leaning headlines and right-leaning headlines per topic.
Each headline has a unique ID, a title (the headline), and a response.
The response has a type (`true`, `false`, `unsure`), text, and affiliation (`democrat`, `republican`).
The structure is as follows (simplified):

```json
[
    {
        "type": "crime",
        "left": [
            {
                "id": 1,
                "title": "Local man dreams about cheese",
                "response": { "type": "true", "text": "Yea I don't doubt it.", "affiliation": "democrat" }
            }
        ],
        "right": []
    }
]
```

Key rundown:

- `type`: the topic (crime, education, environment, immigration). Used for data analysis.
- `left`: the list of left leaning headlines for the specific topic. This is a list of dictionaries.
  - `id`: unique headline ID. Used for data analysis.
  - `title`: headline title.
  - `response`: the response appearing in the comment for the headline. This is a dictionary.
    - `type`: the believed veracity of the headline. `true` (green), `false` (red), `unsure` (grey).
    - `text`: the content of the comment.
    - `affiliation`: the leaning of the commenter. `democrat` or `republican`.
- `right`: the list of right leaning headlines for the specific topic. Content is the same as `left`.


### Editing prompts

Prompts can be edited through the `config.json` file.
This file contains all _slider_ prompts.
The opinion entry prompt is currently not defined in the file.
Slider prompts can be added, removed, and edited.

The structure is as follows:

```json
{
	"prompts": [
		{
			"type": "slider",
			"stage": "after",
			"column_name": "belief_posterior",
			"text": "How likely do you think the headline is to be true?",
			"left_label": "Very unlikely",
			"right_label": "Very likely",
			"min_value": 0.0,
			"max_value": 100.0,
			"value": 50.0,
            "use_previous": true
		}
    ]
}
```

Key rundown:

- `prompts`: the list of prompts. This is a list of dictionaries.
  - `type`: the type of prompt. Currently this should always be `slider`.
  - `stage`: whether the prompt comes before or after the headline comment. `before` or `after`.
  - `column_name`: name of column for the CSV data saved by this prompt.
  - `text`: the text/question in the prompt.
  - `left_label`: the label on the left of the slider.
  - `right_label`: the label on the right of the slider.
  - `min_value`: the lower limit of the slider.
  - `max_value`: the upper limit of the slider.
  - `value`: the default value of the slider. Not required if using `use_previous`; `use_previous` overrides this.
  - `use_previous`: whether to use the value from the previous slider (as set by the user) as the default value. Not required if using `value`; overrides `value`.