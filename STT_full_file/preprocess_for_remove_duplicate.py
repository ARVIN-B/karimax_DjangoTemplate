def get_last_sentence_for_merge(full_text: str, min_words: int = 10):
    sentences = full_text.strip().split(".")

    # اگر نقطه در متن نباشد
    if len(sentences) == 1:
        return full_text, ""

    # از آخر به عقب می‌گردیم تا جمله‌ای با بیش از 10 کلمه پیدا کنیم
    last_sentence = ""
    for i in range(len(sentences) - 1, -1, -1):
        words = sentences[i].strip().split()
        if len(words) + len(last_sentence) >= min_words:
            # انتخاب جمله از اینجا تا انتها
            selected = ".".join(sentences[i:]).strip()
            remaining = ".".join(sentences[:i]).strip()
            return remaining, selected
        last_sentence = sentences[i] + last_sentence
    return "", full_text
