from autogen_agentchat.agents import AssistantAgent
from autogen_ext.models.openai import OpenAIChatCompletionClient
from autogen_core.models import ModelInfo
from autogen_agentchat.messages import TextMessage
from autogen_core import CancellationToken
import asyncio

model_client = OpenAIChatCompletionClient(
    base_url="https://openrouter.ai/api/v1",
    model="tngtech/deepseek-r1t2-chimera:free",
    api_key="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",
    temperature=0.5,
    model_info=ModelInfo(
        vision=True,
        function_calling=True,
        json_output=True,
        family="tngtech/deepseek-r1t2-chimera:free",
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


async def agent_run(prev_text: str, new_text: str):
    user_message = f"""
    **متن‌های ورودی:**

    **متن اول (ابتدای متن نهایی):**
    [{prev_text}]

    **متن دوم (پس از متن اول):**
    [{new_text}]

    **خروجی مورد انتظار:**
    تنها و تنها متن ویرایش‌شده، رسمی و علائم‌گذاری‌شده نهایی را برگردانید."""

    response = await assistant_openrouter.on_messages(
        messages=[TextMessage(content=user_message, source="User")],
        cancellation_token=CancellationToken(),
    )
    return response.chat_message.content


def merge_with_llm(prev_text: str, new_text: str) -> str:
    return asyncio.run(agent_run(prev_text, new_text))
