import json
import os
from datetime import datetime
from apscheduler.schedulers.background import BackgroundScheduler  # pip install apscheduler
import mysql.connector  # pip install mysql-connector-python

from autogen_agentchat.agents import AssistantAgent
from autogen_ext.models.openai import OpenAIChatCompletionClient
from autogen_core.models import ModelInfo
from autogen_agentchat.messages import TextMessage
from autogen_core import CancellationToken
import asyncio

# تنظیم مدل (به Gemini تغییر دادم برای پایداری و function calling)
model_client = OpenAIChatCompletionClient(
    base_url="https://openrouter.ai/api/v1",
    # model="google/gemini-2.0-flash-exp:free",
    # model="meta-llama/llama-4-maverick:free",
    model="alibaba/tongyi-deepresearch-30b-a3b:free",
    api_key="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",
    temperature=0.5,
    model_info=ModelInfo(
        vision=True,
        function_calling=True,
        json_output=True,
        # family="google/gemini-2.0-flash-exp:free",
        # family="meta-llama/llama-4-maverick:free",
        family="alibaba/tongyi-deepresearch-30b-a3b:free",
        structured_output=True,
    ),
)

# مسیر فایل JSON
DATA_FILE = "participations.json"


# تابع استخراج داده از MariaDB (همون قبلی)
def extract_data_from_db():
    conn = mysql.connector.connect(
        host="localhost",
        user="root",
        password="",
        database="pms_db"
    )
    cursor = conn.cursor()
    cursor.execute("SELECT text_content FROM users_participation")
    rows = cursor.fetchall()
    participations = [{"id": i, "text": row[0]} for i, row in enumerate(rows)]
    with open(DATA_FILE, 'w', encoding='utf-8') as f:
        json.dump(participations, f, ensure_ascii=False, indent=4)
    conn.close()
    print(f"داده‌ها آپدیت شد: {datetime.now()}")


# scheduler برای آپدیت روزانه
scheduler = BackgroundScheduler()
scheduler.add_job(extract_data_from_db, 'cron', hour=0, minute=0)
scheduler.start()

# لود داده‌ها یک بار (inject در system_message)
if not os.path.exists(DATA_FILE):
    extract_data_from_db()

with open(DATA_FILE, 'r', encoding='utf-8') as f:
    all_data = json.load(f)  # تمام داده‌ها رو لود کن

# agent (بدون tool، مستقیم جستجو کنه)
chatbot_agent = AssistantAgent(
    name="limited_chatbot",
    model_client=model_client,
    system_message=(
        f"""
        نقش: شما یک چت‌بات محدود هستید که فقط بر اساس داده‌های زیر پاسخ می‌دهید. داده‌ها: {json.dumps(all_data, ensure_ascii=False)}.

        دستورالعمل‌ها:
        1. سؤال کاربر رو بررسی کن و فقط از داده‌های بالا استفاده کن.
        2. اگر مرتبط بود، خلاصه کوتاه و دقیق بده.
        3. اگر مرتبط نبود، بگو: "این موضوع خارج از دانش منه."
        4. پاسخ‌ها رو به فارسی، کوتاه و دقیق نگه دار. history رو حفظ کن.
        """
    ),
    # tools=[]  # tool رو حذف کردم برای سادگی؛ اگر بخوای اضافه کن
)


# فانکشن async برای اجرا با history
async def chatbot_run(messages):
    response = await chatbot_agent.on_messages(
        messages=messages,
        cancellation_token=CancellationToken(),
    )
    return response.chat_message.content


def chat_with_bot(user_query: str, history: list) -> str:
    # پیام کاربر رو به history اضافه کن
    history.append(TextMessage(content=user_query, source="User"))
    # اجرا با کل history
    agent_response = asyncio.run(chatbot_run(history))
    # پاسخ agent رو به history اضافه کن
    history.append(TextMessage(content=agent_response, source="Assistant"))
    return agent_response


# چت loop
if __name__ == "__main__":
    history = []  # history خالی شروع می‌شه
    print("چت شروع شد. query وارد کن (برای خروج: exit)")

    while True:
        query = input("سؤال شما: ")
        if query.lower() == 'exit':
            break
        response = chat_with_bot(query, history)
        print("پاسخ:", response)