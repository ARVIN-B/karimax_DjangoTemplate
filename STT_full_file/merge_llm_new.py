from autogen_agentchat.agents import AssistantAgent
from autogen_ext.models.openai import OpenAIChatCompletionClient
from autogen_core.models import ModelInfo
from autogen_agentchat.messages import TextMessage
from autogen_core import CancellationToken
import asyncio
import json

models = [
    "google/gemma-3n-e4b-it:free",
    "google/gemma-3n-e2b-it:free",
    "deepseek/deepseek-chat-v3.1:free",
    "alibaba/tongyi-deepresearch-30b-a3b:free",
    "microsoft/mai-ds-r1:free",
    "z-ai/glm-4.5-air:free",
    "qwen/qwen3-coder:free",
    "moonshotai/kimi-k2:free",
    "cognitivecomputations/dolphin-mistral-24b-venice-edition:free",
    "google/gemma-3n-e4b-it:free",
    "tencent/hunyuan-a13b-instruct:free",
    "tngtech/deepseek-r1t2-chimera:free",
    "mistralai/mistral-small-3.2-24b-instruct:free",
    "moonshotai/kimi-dev-72b:free",
    "deepseek/deepseek-r1-0528-qwen3-8b:free",
    "deepseek/deepseek-r1-0528:free",
    "mistralai/devstral-small-2505:free",
    "google/gemma-3n-e4b-it:free",
    "meta-llama/llama-3.3-8b-instruct:free",
    "qwen/qwen3-4b:free",
    "qwen/qwen3-30b-a3b:free",
    "qwen/qwen3-8b:free",
    "qwen/qwen3-14b:free",
    "qwen/qwen3-235b-a22b:free",
    "tngtech/deepseek-r1t-chimera:free",
    "microsoft/mai-ds-r1:free",
    "shisa-ai/shisa-v2-llama3.3-70b:free",
    "arliai/qwq-32b-arliai-rpr-v1:free",
    "agentica-org/deepcoder-14b-preview:free",
    "meta-llama/llama-4-maverick:free",
    "meta-llama/llama-4-scout:free",
    "qwen/qwen2.5-vl-32b-instruct:free",
    "deepseek/deepseek-chat-v3-0324:free",
    "mistralai/mistral-small-3.1-24b-instruct:free",
    "google/gemma-3-4b-it:free",
    "google/gemma-3-12b-it:free",
    "google/gemma-3-27b-it:free",
    "nousresearch/deephermes-3-llama-3-8b-preview:free",
    "cognitivecomputations/dolphin3.0-mistral-24b:free",
    "qwen/qwen2.5-vl-72b-instruct:free",
    "mistralai/mistral-small-24b-instruct-2501:free",
    "deepseek/deepseek-r1-distill-llama-70b:free",
    "deepseek/deepseek-r1:free",
    "google/gemini-2.0-flash-exp:free",
    "meta-llama/llama-3.3-70b-instruct:free",
    "qwen/qwen-2.5-coder-32b-instruct:free",
    "meta-llama/llama-3.2-3b-instruct:free",
    "qwen/qwen-2.5-72b-instruct:free",
    "mistralai/mistral-nemo:free",
    "google/gemma-2-9b-it:free",
    "mistralai/mistral-7b-instruct:free",
]

models_families = [
    "google/gemma-3n-e4b-it:free",
    "google/gemma-3n-e2b-it:free",
    "deepseek/deepseek-chat-v3.1:free",
    "alibaba/tongyi-deepresearch-30b-a3b:free",
    "microsoft/mai-ds-r1:free",
    "z-ai/glm-4.5-air:free",
    "qwen/qwen3-coder:free",
    "moonshotai/kimi-k2:free",
    "cognitivecomputations/dolphin-mistral-24b-venice-edition:free",
    "google/gemma-3n-e4b-it:free",
    "tencent/hunyuan-a13b-instruct:free",
    "tngtech/deepseek-r1t2-chimera:free",
    "mistralai/mistral-small-3.2-24b-instruct:free",
    "moonshotai/kimi-dev-72b:free",
    "deepseek/deepseek-r1-0528-qwen3-8b:free",
    "deepseek/deepseek-r1-0528:free",
    "mistralai/devstral-small-2505:free",
    "google/gemma-3n-e4b-it:free",
    "meta-llama/llama-3.3-8b-instruct:free",
    "qwen/qwen3-4b:free",
    "qwen/qwen3-30b-a3b:free",
    "qwen/qwen3-8b:free",
    "qwen/qwen3-14b:free",
    "qwen/qwen3-235b-a22b:free",
    "tngtech/deepseek-r1t-chimera:free",
    "microsoft/mai-ds-r1:free",
    "shisa-ai/shisa-v2-llama3.3-70b:free",
    "arliai/qwq-32b-arliai-rpr-v1:free",
    "agentica-org/deepcoder-14b-preview:free",
    "meta-llama/llama-4-maverick:free",
    "meta-llama/llama-4-scout:free",
    "qwen/qwen2.5-vl-32b-instruct:free",
    "deepseek/deepseek-chat-v3-0324:free",
    "mistralai/mistral-small-3.1-24b-instruct:free",
    "google/gemma-3-4b-it:free",
    "google/gemma-3-12b-it:free",
    "google/gemma-3-27b-it:free",
    "nousresearch/deephermes-3-llama-3-8b-preview:free",
    "cognitivecomputations/dolphin3.0-mistral-24b:free",
    "qwen/qwen2.5-vl-72b-instruct:free",
    "mistralai/mistral-small-24b-instruct-2501:free",
    "deepseek/deepseek-r1-distill-llama-70b:free",
    "deepseek/deepseek-r1:free",
    "google/gemini-2.0-flash-exp:free",
    "meta-llama/llama-3.3-70b-instruct:free",
    "qwen/qwen-2.5-coder-32b-instruct:free",
    "meta-llama/llama-3.2-3b-instruct:free",
    "qwen/qwen-2.5-72b-instruct:free",
    "mistralai/mistral-nemo:free",
    "google/gemma-2-9b-it:free",
    "mistralai/mistral-7b-instruct:free",
]

def read_index():
    try:
        with open('index.json', 'r') as file:
            data = json.load(file)
            return data.get('index', 0)
    except FileNotFoundError:
        return 0

def save_index(index):
    with open('index.json', 'w') as file:
        json.dump({"index": index}, file)


def create_assistant(index):

    model_client = OpenAIChatCompletionClient(
        base_url="https://openrouter.ai/api/v1",
        model=models[index],
        api_key="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",
        temperature=0.5,
        model_info=ModelInfo(
            vision=True,
            function_calling=True,
            json_output=True,
            family=models_families[index],
            structured_output=True,
        ),
    )

    assistant_openrouter = AssistantAgent(
        name="formalizer",
        model_client=model_client,
        system_message=(
            f"""
            نقش:** شما یک ویراستار زبان فارسی حرفه‌ای و متخصص هستید که وظیفه دارید دو قطعه متن فارسی را به یکدیگر متصل کرده، ویرایش زبانی و نگارشی نمایید.
            **دستورالعمل‌های مرحله به مرحله:**
            ۱.  **الحاق (چسباندن):**
                * **متن اول** را در ابتدای پاراگراف نهایی قرار دهید.
                * **متن دوم** را بلافاصله پس از پایان منطقی متن اول قرار دهید و آن‌ها را به یکدیگر متصل کنید.
            ۲.  **حذف و ادغام:**
                * هرگونه **کلمه، عبارت یا حرف اضافه تکراری و اضافی** را که در محل اتصال دو متن ایجاد شده، حذف کنید تا یکپارچگی معنایی حفظ شود.
            ۳.  **ویرایش لحن (فرمال‌سازی):**
                * کل متن حاصل را بررسی کنید و لحن **عامیانه** یا **محاوره‌ای** را به لحن **رسمی، استاندارد و فرمال (کتابی)** تبدیل کنید. (مثلاً: "اومدم" به "آمدم"، "چطور" به "چگونه").
            ۴.  **ویرایش نگارشی (علائم‌گذاری):**
                * علائم نگارشی نظیر **نقطه (.)، کاما (،)، نقطه‌ویرگول (؛)** و سایر نشانه‌های لازم را به صورت کامل و دقیق در جای مناسب خود قرار دهید تا خوانایی و وضوح جملات بهبود یابد.
            """
        ),
    )
    return assistant_openrouter


async def agent_run(prev_text: str, new_text: str, assistant_openrouter):
    user_message = f"""
    **متن‌های ورودی:**
    **متن اول (ابتدای متن نهایی):**
    [{prev_text}]

    **متن دوم (پس از متن اول):**
    [{new_text}]

    **خروجی مورد انتظار:**
    تنها و تنها متن ویرایش‌شده، رسمی و علائم‌گذاری‌شده نهایی را برگردانید."""

    # user_message = "چقدر خوب میتونی فارسی صحبت کنی؟"

    response = await assistant_openrouter.on_messages(
        messages=[TextMessage(content=user_message, source="User")],
        cancellation_token=CancellationToken(),
    )
    return response.chat_message.content


async def handle_merge_with_llm(prev_text: str, new_text: str, assistant_openrouter) -> str:
    return await agent_run(prev_text, new_text, assistant_openrouter)


async def merge_with_llm(prev_text: str, new_text: str):
    index = read_index()
    max_tries = 1
    tries = 0

    while True:
        try:
            # ساخت دستیار با مدل فعال
            assistant_openrouter = create_assistant(index)
            result = await handle_merge_with_llm(prev_text, new_text, assistant_openrouter)
            return result
        except Exception as e:
            tries += 1
            print(f"{tries}'s tries")
            print(e)
            if tries >= max_tries:
                # رفتن به مدل بعدی در لیست
                index = (index + 1) % len(models)
                save_index(index)
                tries = 0

            if index > len(models):
                return "Unable to process due to insufficient credits on all models."


# if __name__ == "__main__":
#     import asyncio
#     result = asyncio.run(handle_llm_request("من من اروین هستم", "که که که در نهایت عمل هستم"))
#     print(result)