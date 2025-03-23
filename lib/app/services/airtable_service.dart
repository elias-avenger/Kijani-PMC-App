import 'package:airtable_crud/airtable_plugin.dart';
import 'package:kijani_pgc_app/utils/constants/airtable_constants.dart';

AirtableCrud uGOperations = AirtableCrud(kAirtableApiKey, kUgOperationsBaseId);
AirtableCrud uGNurseryActions = AirtableCrud(
  kAirtableApiKey,
  kUGNurseryActionsBaseId,
);
AirtableCrud uGGardens = AirtableCrud(kAirtableApiKey, kCurrentNurseryBaseId);
