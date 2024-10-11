# Generated by Django 4.2 on 2024-10-11 01:01

from django.db import migrations, models
import django.db.models.deletion
import jisho.models


class Migration(migrations.Migration):

    initial = True

    dependencies = []

    operations = [
        migrations.CreateModel(
            name="Jisho",
            fields=[
                (
                    "id",
                    models.BigAutoField(
                        auto_created=True,
                        primary_key=True,
                        serialize=False,
                        verbose_name="ID",
                    ),
                ),
                ("csv_file", models.FileField(upload_to=jisho.models.Jisho_file_path)),
                ("title", models.CharField(max_length=100)),
                ("description", models.CharField(max_length=3000, null=True)),
                ("sharing_id", models.CharField(max_length=36, null=True, unique=True)),
                ("date_created", models.DateTimeField(auto_now_add=True)),
            ],
        ),
        migrations.CreateModel(
            name="WordPair",
            fields=[
                (
                    "id",
                    models.BigAutoField(
                        auto_created=True,
                        primary_key=True,
                        serialize=False,
                        verbose_name="ID",
                    ),
                ),
                ("key", models.CharField(max_length=64)),
                ("value", models.CharField(max_length=64)),
                ("attributes", models.CharField(max_length=256)),
                (
                    "jisho_id",
                    models.ForeignKey(
                        on_delete=django.db.models.deletion.CASCADE, to="jisho.jisho"
                    ),
                ),
            ],
        ),
        migrations.CreateModel(
            name="WordVariant",
            fields=[
                (
                    "id",
                    models.BigAutoField(
                        auto_created=True,
                        primary_key=True,
                        serialize=False,
                        verbose_name="ID",
                    ),
                ),
                ("value", models.CharField(max_length=64)),
                ("attributes", models.CharField(max_length=256)),
                (
                    "word_id",
                    models.ForeignKey(
                        on_delete=django.db.models.deletion.CASCADE, to="jisho.wordpair"
                    ),
                ),
            ],
        ),
        migrations.CreateModel(
            name="MemRecord",
            fields=[
                (
                    "id",
                    models.BigAutoField(
                        auto_created=True,
                        primary_key=True,
                        serialize=False,
                        verbose_name="ID",
                    ),
                ),
                ("start_time", models.DateTimeField(auto_now_add=True)),
                ("end_time", models.DateTimeField(null=True)),
                ("configuration", models.CharField(max_length=256)),
                ("progress", models.CharField(max_length=36, null=True)),
                ("sharing_id", models.CharField(max_length=36, unique=True)),
                (
                    "jisho_id",
                    models.ForeignKey(
                        on_delete=django.db.models.deletion.CASCADE, to="jisho.jisho"
                    ),
                ),
            ],
        ),
        migrations.CreateModel(
            name="Hints",
            fields=[
                (
                    "id",
                    models.BigAutoField(
                        auto_created=True,
                        primary_key=True,
                        serialize=False,
                        verbose_name="ID",
                    ),
                ),
                ("value", models.CharField(max_length=64)),
                ("attributes", models.CharField(max_length=256)),
                (
                    "word_id",
                    models.ForeignKey(
                        on_delete=django.db.models.deletion.CASCADE, to="jisho.wordpair"
                    ),
                ),
            ],
        ),
    ]
