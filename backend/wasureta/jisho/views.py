from rest_framework.response import Response
from rest_framework.decorators import api_view
from rest_framework import status
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

    serializer=JishoSerializer(data=request.data)
    if serializer.is_valid():
        serializer.save()
    else:
        logger.error(serializer.errors)
        return Response(serializer.errors,status=status.HTTP_400_BAD_REQUEST)
    return Response(serializer.data,status=status.HTTP_201_CREATED)

