import csv
import os
from rest_framework.response import Response
from rest_framework.decorators import api_view
from rest_framework import status

from wasureta.settings import BASE_DIR
from .serializers import JishoSerializer, WordPairSerializer, WordVariantSerializer
from .models import Jisho,MemRecord,WordPair,WordVariant
import logging

logger=logging.getLogger(__name__)

# Create your views here.
@api_view(['GET'])
def getJishoList(request):
    jisho=Jisho.objects.all()
    serializer=JishoSerializer(jisho,many=True)
    return Response(serializer.data)

@api_view(['GET'])
def getJisho(request,jisho_id):
    jisho=Jisho.objects.get(pk=jisho_id)
    serializer=JishoSerializer(jisho,many=False)
    logger.info(serializer.data)
    return Response(serializer.data)

@api_view(['GET'])
def getWordPairs(request,jisho_id):
    wordPairs=WordPair.objects.filter(jisho_id=jisho_id)
    serializer=WordPairSerializer(wordPairs,many=True)
    return Response(serializer.data)

@api_view(['GET'])
def getWordVariant(request,wordPair_id):
    variants=WordVariant.objects.filter(wordPair_id=wordPair_id)
    serializer=WordVariantSerializer(variants,many=True)
    return Response(serializer.data)

@api_view(['POST'])
def createJisho(request):
    logger.info(request.data)
    # assume the following default parameters are provided in the request data:
    # hiragana is the primary key
    pk,sk='hiragana','english'
    # english is the native language
    serializer=JishoSerializer(data=request.data)
    if serializer.is_valid():
        jisho=serializer.save()
        # generate basic word pairs
        word_pairs=[]
        word_variants=[]
        with open(jisho.csv_file.path, newline='') as csvfile:
            reader = csv.DictReader(csvfile)
            for row in reader:
                # create word pair
                word_key,word_value=row[pk],row[sk]
                word_pairs.append(WordPair(jisho=jisho,key=word_key,value=word_value))
                # generate variants
                for k,v in row.items():
                    if k!=pk and k!=sk:
                        word_variants.append(WordVariant(wordPair=word_pairs[-1],variant=k,value=v))
        WordPair.objects.bulk_create(word_pairs)
        WordVariant.objects.bulk_create(word_variants)
        logger.info(f"created {len(word_pairs)} word pairs and {len(word_variants)} word variants from {jisho.csv_path}")
    else:
        logger.error(serializer.errors)
        return Response(serializer.errors,status=status.HTTP_400_BAD_REQUEST)
    return Response(serializer.data,status=status.HTTP_201_CREATED)

