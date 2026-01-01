from llama_cpp import Llama

llm = Llama.from_pretrained(
	repo_id="mradermacher/MeowGPT-3.5-GGUF",
	filename="MeowGPT-3.5.IQ3_M.gguf",
)
print(llm)
print("test")
llm.create_chat_completion(
    messages=[
        {"role": "user", "content": "Write a short story about a cat."}
    ]
)
print("test")