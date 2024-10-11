"""
This defines serializer for all objects in cluster
"""

from rest_framework import serializers
from .models import Jisho, WordPair,WordVariant


class JishoSerializer(serializers.ModelSerializer):
    class Meta:
        model = Jisho
        fields = "__all__"


class WordPairSerializer(serializers.ModelSerializer):
    class Meta:
        model = WordPair
        fields = "__all__"

class WordVariantSerializer(serializers.ModelSerializer):
    class Meta:
        model = WordVariant
        fields = "__all__"