import os
import base64
import asyncio
from autogen_agentchat.agents import AssistantAgent
from autogen_ext.models.openai import OpenAIChatCompletionClient
from autogen_core.models import ModelInfo
from autogen_agentchat.messages import TextMessage, MultiModalMessage
from autogen_core import Image  # ✅ اصلاح import: از autogen_core مستقیم
from autogen_core import CancellationToken

model = "openrouter/sherlock-dash-alpha" # 1.84 M
model = "openrouter/sherlock-think-alpha" # 1.84 M
model = "nvidia/nemotron-nano-12b-v2-vl:free" # 128 K
model = "mistralai/mistral-small-3.2-24b-instruct:free" # 131 K
model = "qwen/qwen2.5-vl-32b-instruct:free" # 16 K
# model = "mistralai/mistral-small-3.1-24b-instruct:free" # 96 K
# model = "google/gemma-3-4b-it:free" # 33 K
# model = "google/gemma-3-12b-it:free" # 33 K # wrong
# model = "google/gemma-3-27b-it:free" # 131 K
# model = "google/gemini-2.0-flash-exp:free" # 1.05 M

# مدل ویژن رایگان + فارسی عالی
model_client = OpenAIChatCompletionClient(
    base_url="https://openrouter.ai/api/v1",
    model=model,
    api_key="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",
    temperature=0.7,
    model_info=ModelInfo(
        vision=True,
        function_calling=False,
        json_output=True,
        family=model,
        structured_output=False,
    ),
)

# ایجنت ویژن
vision_agent = AssistantAgent(
    name="VisionBot",
    model_client=model_client,
    system_message="""
    شما یک دستیار هوشمند فارسی هستید که عکس‌ها را می‌بینید و به فارسی توضیح می‌دهید.
    - همیشه به فارسی جواب بده.
    - توضیحات دقیق، مفید و طبیعی بده.
    - اگر کاربر سوال پرسید، فقط بر اساس محتوای عکس جواب بده.
    - لحنت دوستانه و صمیمی باشه.
    """
)

def encode_image(image_path):
    """تبدیل به base64 data_uri برای Image"""
    if not os.path.exists(image_path):
        return None
    mime_type = "image/png" if image_path.lower().endswith('.png') else "image/jpeg"
    with open(image_path, "rb") as f:
        base64_data = base64.b64encode(f.read()).decode('utf-8')
    return f"data:{mime_type};base64,{base64_data}"

async def ask_vision_bot(user_text: str, image_path: str = None, history=None):
    if history is None:
        history = []

    messages = history.copy()

    # ساخت محتوای multimodal (list از str و Image)
    content = []

    if user_text:
        content.append(user_text)  # متن به عنوان str

    if image_path:
        data_uri = encode_image(image_path)
        if data_uri:
            image = Image.from_uri(uri=data_uri)  # ✅ اصلاح: Image.from_uri(uri=...)
            content.append(image)  # عکس به عنوان Image
            print(f"تصویر لود شد: {os.path.basename(image_path)}")
        else:
            print("❌ عکس پیدا نشد!")

    # اگر محتوایی داشت، MultiModalMessage بساز
    if content:
        messages.append(MultiModalMessage(content=content, source="user"))

    # ارسال به مدل
    response = await vision_agent.on_messages(
        messages=messages,
        cancellation_token=CancellationToken()
    )

    # اضافه کردن پاسخ به تاریخچه
    assistant_msg = TextMessage(content=response.chat_message.content, source="assistant")
    history.extend([messages[-1], assistant_msg])  # کاربر + دستیار

    return response.chat_message.content, history


# تست سریع
if __name__ == "__main__":
    history = []
    print("چت‌بات ویژن آماده است! (برای خروج: exit)")

    while True:
        user_input = input("\nسؤالت چیه؟ (یا مسیر عکس رو وارد کن): ").strip()

        if user_input.lower() == "exit":
            print("خداحافظ!")
            break

        image_path = None
        text = user_input

        # اگر فایل بود → عکس
        if os.path.isfile(user_input):
            image_path = user_input
            q = input("سؤالت در مورد این عکس چیه؟ (Enter = توضیح کلی): ").strip()
            text = q or "این عکس رو با جزئیات و به فارسی توضیح بده."

        print("در حال پردازش...")
        try:
            response, history = asyncio.run(ask_vision_bot(text, image_path, history))
            print(f"\nپاسخ: {response}\n")
        except Exception as e:
            print(f"خطا: {e}")




# اوکی . درست شد همه چیز . من مدلش رو عوض کردم فقط . حالا یه چیزی ، من مخوام این رو به عنوان یه ماژول توی پروژه جنگو استفاده کنم ، میخوام اینجوری باشه که یه متن به صورت اجباری و یه ادرس عکس به صورت اختیاری بگیره و مثل یه چت بات با یوزر چت کنه