# Generated by Django 4.2 on 2024-11-07 22:38

from django.db import migrations, models


class Migration(migrations.Migration):

    dependencies = [
        ('jisho', '0005_remove_memrecord_is_random_memrecord_random_seed'),
    ]

    operations = [
        migrations.AddField(
            model_name='memrecord',
            name='score',
            field=models.IntegerField(default=0),
        ),
    ]