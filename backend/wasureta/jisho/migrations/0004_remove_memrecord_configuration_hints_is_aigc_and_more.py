# Generated by Django 4.2 on 2024-11-07 21:42

from django.db import migrations, models


class Migration(migrations.Migration):

    dependencies = [
        ('jisho', '0003_alter_jisho_csv_file'),
    ]

    operations = [
        migrations.RemoveField(
            model_name='memrecord',
            name='configuration',
        ),
        migrations.AddField(
            model_name='hints',
            name='is_AIGC',
            field=models.BooleanField(default=False),
        ),
        migrations.AddField(
            model_name='memrecord',
            name='is_random',
            field=models.BooleanField(default=False),
        ),
        migrations.AddField(
            model_name='memrecord',
            name='mode',
            field=models.CharField(choices=[('O', 'One-to-many fuzzy matching'), ('M', 'Many-to-many fuzzy matching'), ('E', 'One-to-many exact matching'), ('X', 'Many-to-many exact matching'), ('C', 'Contextual problem solving')], default='O', max_length=1),
        ),
        migrations.AddField(
            model_name='memrecord',
            name='total_words',
            field=models.IntegerField(default=0),
        ),
        migrations.AlterField(
            model_name='hints',
            name='value',
            field=models.CharField(max_length=512),
        ),
        migrations.AlterField(
            model_name='memrecord',
            name='progress',
            field=models.IntegerField(default=0),
        ),
    ]
