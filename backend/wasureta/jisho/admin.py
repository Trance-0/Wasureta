from django.contrib import admin
from .models import Jisho,WordPair,WordVariant

# Register your models here.
admin.site.register(Jisho)
admin.site.register(WordPair)
admin.site.register(WordVariant)
