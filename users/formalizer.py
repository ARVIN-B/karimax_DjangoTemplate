from autogen_agentchat.agents import AssistantAgent
from autogen_ext.models.openai import OpenAIChatCompletionClient
from autogen_core.models import ModelInfo
from autogen_agentchat.messages import TextMessage
import asyncio
from autogen_agentchat.ui import Console
from autogen_core import CancellationToken

model_client = OpenAIChatCompletionClient(
    base_url="https://openrouter.ai/api/v1",
    # model="nvidia/nemotron-nano-9b-v2:free",
    # model="alibaba/tongyi-deepresearch-30b-a3b:free",
    # model="google/gemini-2.0-flash-exp:free",
    # model="microsoft/mai-ds-r1:free",
    model="x-ai/grok-4-fast",
    api_key="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",
    temperature=0.5,
    model_info=ModelInfo(
        vision=True,
        function_calling=True,
        json_output=True,
        # family="Nemotron-Nano-9B-V2",
        # family="Tongyi-DeepResearch-30B-A3B",
        # family="gemini-2.0-flash",
        # family="MAI-DS-R1",
        family="grok-4",
        structured_output=True,
    ),
)


assistant_openrouter = AssistantAgent(
    name="formalizer",
    model_client=model_client,
    system_message=(
        "You are a professional Persian language editor. "
        "Your job is to rewrite informal or colloquial Persian text "
        "into formal, correct Persian, without summarizing, shortening, or adding meaning. "
        "Keep the tone professional and natural."
    ),
)

async def agent_run(text: str):
    response = await assistant_openrouter.on_messages(
        messages=[TextMessage(content=text, source="User")],
        cancellation_token=CancellationToken(),
    )
    return response.chat_message.content

def formalizer(text: str):
    return asyncio.run(agent_run(text))

print(formalizer("الان دارم تستش میکنم که ببینم چی به چیه"))
