# use openai to generate help prompt and fuzzy matching

import openai
import os
from pathlib import Path
from dotenv import load_dotenv
from .models import WordPair

import logging

logger = logging.getLogger(__name__)

BASE_DIR = Path(__file__).resolve().parent.parent

load_dotenv(os.path.join(BASE_DIR,'.env'))

OPENAI_API_KEY = os.getenv("OPENAI_API_KEY")

class LLM:
    def __init__(self,model: str='gpt-4o-mini',temperature: float=0.5):
        self.client = openai.OpenAI(api_key=OPENAI_API_KEY)
        self.model = model
        self.temperature = temperature

    def generate_help_prompt(self, wordPair: WordPair)->str:
        shots=[
            ("","")
        ]
        shots_str = "\n".join([f"Input: {shot[0]}\nOutput: {shot[1]}" for shot in shots])
        completion = self.client.chat.completions.create(
            model=self.model,
            temperature=self.temperature,
            messages=[
                {'role': 'user', 'content': f'Compose a paragraph to help me remember the key value pair {wordPair.key}, {wordPair.value} \n Example: \n{shots_str}'}
            ]
        )
        return completion.choices[0].message.content
    
    def generate_example(self, wordPair: WordPair)->str:
        shots=[
            ("","")
        ]
        shots_str = "\n".join([f"Input: {shot[0]}\nOutput: {shot[1]}" for shot in shots])
        completion = self.client.chat.completions.create(
            model=self.model,
            temperature=self.temperature,
            messages=[
                {'role': 'user', 'content': f'Compose a sentence in daily life containing this word {wordPair.key} with meaning {wordPair.value} to help me remember the word. \n Example: \n{shots_str}'}
            ]
        )
        return completion.choices[0].message.content

    def fuzzy_matching(self, wordPair: WordPair, answer: str)->float:
        shots=[
            ("","")
        ]
        shots_str = "\n".join([f"Input: {shot[0]}\nOutput: {shot[1]}" for shot in shots])
        completion = self.client.chat.completions.create(
            model=self.model,
            temperature=self.temperature,
            messages=[
                {'role': 'user', 'content': f'Compose a sentence in daily life containing this word {wordPair.key} with meaning {wordPair.value} to help me remember the word. \n Example: \n{shots_str}'}
            ]
        )
        return completion.choices[0].message.content 
