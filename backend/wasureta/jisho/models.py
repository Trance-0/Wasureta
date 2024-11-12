from django.db import models

# Create your models here.
import os
from django.db import models
from django.utils.translation import gettext_lazy as _

from member.models import Member

# from member.models import Member
# Create your models here.


def Jisho_file_path(instance, filename):
    """
    file will be uploaded to MEDIA_ROOT/user_<id>/<filename>
    https://docs.djangoproject.com/en/dev/ref/models/fields/#django.db.models.FileField.upload_to
    """
    # return "profile_pic/user_{0}/{1}".format(instance.user.id, filename)
    # we save only one latest image.
    _name, _extension = os.path.splitext(filename)
    return "user_upload/user_{0}/jisho/csv_{1}.csv".format(
        instance.owner_id.user_id.id, instance.id
    )


class Jisho(models.Model):
    # This objects contains the username, password, first_name, last_name, and email of member.
    owner_id = models.ForeignKey(
        Member,
        on_delete=models.CASCADE,
        null=False,
    )

    csv_file = models.FileField(upload_to=Jisho_file_path, null=True)
    title = models.CharField(max_length=100, null=False)
    description = models.CharField(max_length=3000, null=True)
    sharing_id = models.CharField(max_length=36, unique=True, null=True)

    # last_use and date_created automatically created, for these field, create one time value to timezone.now()
    date_created = models.DateTimeField(auto_now_add=True, null=False)

    def __str__(self):
        return f"{self.title},owner_id:{self.owner_id.user_id.id},owner_name:{self.owner_id.user_id.get_full_name()}"


class MemRecordChoice(models.TextChoices):
    # In: the meaning of the word in native language
    # Out: select the word in new language.
    ONE_TO_ONE = "I", _("One-to-one")
    # In: the meaning of the word in native language
    # Out: select the alternative form (te-form, potential form, particles) of the word in new language.
    ONE_TO_MANY = "O", _("One-to-many fuzzy matching")
    # In: the word (variant) in another language (exclude in-invertable particles).
    # Out: select the meaning, and form of the word in native language.
    MANY_TO_ONE = "M", _("Many-to-one fuzzy matching")
    # In: the meaning of the word in native language
    # Out: the word in new language.
    ONE_TO_ONE_EXACT = "A", _("One-to-one exact matching")
    # In: the meaning of the word in native language
    # Out: the word in new language.
    ONE_TO_MANY_EXACT = "E", _("One-to-many exact matching")
    # In: the word (variant) in another language.
    # Out: the meaning of the word in native language.
    MANY_TO_ONE_EXACT = "X", _("Many-to-many exact matching")
    # In: problem generated by AI or human.
    # Out: filling the blank given the translation of the word.
    CONTEXT = "C", _("Contextual problem solving")


class MemRecord(models.Model):
    """
    This class stores the record of the jisho
    """

    jisho_id = models.ForeignKey(
        Jisho,
        # when record is deleted, whether the creator should also be deleted
        on_delete=models.CASCADE,
        null=False,
    )
    start_time = models.DateTimeField(auto_now_add=True, null=False)
    end_time = models.DateTimeField(null=True)
    # stores how the word list is tested.
    mode = models.CharField(
        max_length=1,
        default=MemRecordChoice.ONE_TO_MANY,
        choices=MemRecordChoice.choices,
        null=False,
    )
    # if random seed is not null, the order of the word list is random.
    random_seed = models.IntegerField(null=True)
    # stores the current progress, to be implement.
    total_words = models.IntegerField(default=0, null=False)
    score = models.IntegerField(default=0, null=False)
    progress = models.IntegerField(default=0, null=False)
    sharing_id = models.CharField(max_length=36, unique=True, null=False)


class WordPair(models.Model):
    """
    This class stores the direct mapping of meaning in different language
    """

    jisho_id = models.ForeignKey(
        Jisho,
        # when record is deleted, whether the creator should also be deleted
        on_delete=models.CASCADE,
        null=False,
    )
    order = models.IntegerField(default=-1, null=False)
    key = models.CharField(max_length=64, null=False)
    value = models.CharField(max_length=64, null=False)
    attributes = models.CharField(max_length=256, null=False)

    def __str__(self):
        return f"{self.key},{self.value}:{self.attributes}"


class WordVariant(models.Model):
    """
    This class stores different form of a word, for example te-form and potential form for a japanese word
    """

    word_id = models.ForeignKey(
        WordPair,
        # when record is deleted, whether the creator should also be deleted
        on_delete=models.CASCADE,
        null=False,
    )
    # if the word is one-to-one, then given the variant, we can revert the meaning of the original word.
    # for example, given the particle, we cannot revert the meaning of the original word.
    is_one_to_one = models.BooleanField(default=True, null=False)
    variant = models.CharField(max_length=64, default="None", null=False)
    value = models.CharField(max_length=64, default="None", null=False)
    # explanation of the variant
    attributes = models.CharField(max_length=256, null=False)

    def __str__(self):
        return f"{self.word_id.key}|{self.variant},{self.value}:{self.attributes}"


class Hints(models.Model):
    """
    This class stores the hint to memorize the word
    """

    word_id = models.ForeignKey(
        WordPair,
        # when record is deleted, whether the creator should also be deleted
        on_delete=models.CASCADE,
        null=False,
    )
    is_AIGC = models.BooleanField(default=False, null=False)
    value = models.CharField(max_length=512, null=False)
    attributes = models.CharField(max_length=256, null=False)
