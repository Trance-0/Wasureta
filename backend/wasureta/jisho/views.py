from rest_framework.response import Response
from rest_framework.decorators import api_view
from .serializers import JishoSerializer, WordPairSerializer, WordVariantSerializer
from .models import Jisho,MemRecord,WordPair,WordVariant

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

