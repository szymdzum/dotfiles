# Agent Skills

Claude Code can be extended with custom skills, allowing it to interact with external tools, APIs, and services. Skills are defined as Python functions that Claude Code can call to perform specific actions.

## How Skills Work

1.  **Skill Definition:** You define a Python function that represents a skill. This function takes arguments and performs an action (e.g., making an API call, running a shell command).
2.  **Skill Registration:** You register this skill with Claude Code, providing a description of what the skill does and its parameters.
3.  **Claude Code Invocation:** When Claude Code determines that a skill is relevant to a user's request, it will call the skill function with the appropriate arguments.
4.  **Result Handling:** The output of the skill function is returned to Claude Code, which then uses it to formulate a response or take further action.

## Defining a Skill

Skills are defined as Python functions within a Python file (e.g., `my_skills.py`).

```python
# my_skills.py

import requests

def get_weather(city: str) -> str:
    """Gets the current weather for a given city.

    Args:
        city: The name of the city.

    Returns:
        A string describing the current weather.
    """
    api_key = "YOUR_OPENWEATHERMAP_API_KEY"
    base_url = "http://api.openweathermap.org/data/2.5/weather"
    params = {"q": city, "appid": api_key, "units": "metric"}
    response = requests.get(base_url, params=params)
    data = response.json()

    if response.status_code == 200:
        weather_desc = data["weather"][0]["description"]
        temp = data["main"]["temp"]
        return f"The weather in {city} is {weather_desc} with a temperature of {temp}°C."
    else:
        return f"Could not retrieve weather for {city}. Error: {data.get("message", "Unknown error")}"


def search_wikipedia(query: str) -> str:
    """Searches Wikipedia for a given query and returns a summary.

    Args:
        query: The search query.

    Returns:
        A summary from Wikipedia.
    """
    base_url = "https://en.wikipedia.org/api/rest_v1/page/summary/"
    response = requests.get(base_url + query)
    data = response.json()

    if response.status_code == 200:
        return data.get("extract", "No summary found.")
    else:
        return f"Could not search Wikipedia for {query}. Error: {data.get("title", "Unknown error")}"
```

## Registering Skills

Skills are registered with Claude Code through your `.claude/settings.json` file or via the `/skills` slash command.

### Via `.claude/settings.json`

Add a `skills` section to your `.claude/settings.json`:

```json
{
  "skills": [
    {
      "name": "get_weather",
      "description": "Gets the current weather for a given city.",
      "parameters": {
        "type": "object",
        "properties": {
          "city": {"type": "string", "description": "The name of the city."}
        },
        "required": ["city"]
      },
      "file": "~/.claude/my_skills.py"
    },
    {
      "name": "search_wikipedia",
      "description": "Searches Wikipedia for a given query and returns a summary.",
      "parameters": {
        "type": "object",
        "properties": {
          "query": {"type": "string", "description": "The search query."}
        },
        "required": ["query"]
      },
      "file": "~/.claude/my_skills.py"
    }
  ]
}
```

*   `name`: The name of the skill (must match the Python function name).
*   `description`: A clear description of what the skill does. This helps Claude Code decide when to use the skill.
*   `parameters`: A JSON Schema defining the arguments the skill function expects.
*   `file`: The absolute path to the Python file containing the skill function.

### Via `/skills` Slash Command

You can also register skills dynamically during a conversation:

```
/skills add get_weather --description "Gets the current weather for a given city." --parameters '{"type":"object","properties":{"city":{"type":"string","description":"The name of the city."}},"required":["city"]}' --file ~/.claude/my_skills.py
```

## Using Skills

Once skills are registered, Claude Code will automatically use them when appropriate. For example:

**User:** "What's the weather like in London?"

Claude Code will recognize that `get_weather` is relevant and call it with `city="London"`. The result will then be used to answer your question.

**User:** "Tell me about the history of artificial intelligence."

Claude Code will use `search_wikipedia` with `query="history of artificial intelligence"`.

## Best Practices

*   **Clear Descriptions:** Provide concise and accurate descriptions for your skills and their parameters. This helps Claude Code understand when and how to use them.
*   **Robust Functions:** Ensure your skill functions handle errors gracefully and return meaningful results.
*   **Security:** Be mindful of the permissions granted to your skill functions, especially if they interact with sensitive APIs or the filesystem.
*   **Testing:** Thoroughly test your skills to ensure they work as expected.

## Troubleshooting

*   **Skill not being called:** Check the skill description and parameters. Ensure they are clear and accurately reflect what the skill does. Claude Code relies on these to decide when to invoke a skill.
*   **Skill errors:** Review the logs for your skill function. Ensure all dependencies are installed and paths are correct.
*   **Permissions:** Verify that Claude Code has the necessary permissions to execute your skill file and any external commands or APIs it calls.
