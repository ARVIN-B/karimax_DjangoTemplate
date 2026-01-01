from openai import OpenAI

client = OpenAI(
    base_url="https://openrouter.ai/api/v1",
    api_key="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",
)

def chat_completion_with_usage(messages):
    response = client.chat.completions.create(
        model="qwen/qwen2.5-vl-32b-instruct:free",
        messages=messages,
        extra_body={
            "usage": {
                "include": True
            }
        },
        stream=True
    )
    return response

for chunk in chat_completion_with_usage([
    {"role": "user", "content": "Write a haiku about Paris."}
]):
    if hasattr(chunk, 'usage'):
        if hasattr(chunk.usage, 'total_tokens'):
            print(f"\nUsage Statistics:")
            print(f"Total Tokens: {chunk.usage.total_tokens}")
            print(f"Prompt Tokens: {chunk.usage.prompt_tokens}")
            print(f"Completion Tokens: {chunk.usage.completion_tokens}")
            print(f"Cost: {chunk.usage.cost} credits")
    elif chunk.choices[0].delta.content:
        print(chunk.choices[0].delta.content, end="")
