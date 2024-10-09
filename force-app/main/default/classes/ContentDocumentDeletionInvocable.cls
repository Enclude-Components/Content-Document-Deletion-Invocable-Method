/**
 * @description     Class containing Invocable Method to delete Content Documents from list of SObject IDs
 * @author          Brandon DeMatteis, Enclude
 * @since           09/10/2024
 * @tests           LeadConversionInvocable_Test.cls
 */
public with sharing class ContentDocumentDeletionInvocable {

    /**
     * @description Deletes all Content Documents for provided record IDs
     * @param   args    ContentDocumentDeletionParams[]
    */
    @InvocableMethod(label='Delete Content Documents (Files)' description='Deletes all Content Documents for provided record IDs')
    public static void deleteContentDocuments(ContentDocumentDeletionParams[] args) {
        Set<Id> recordIds = new Set<Id>();
        for (ContentDocumentDeletionParams params : args) {
            if (params?.recordIds == null) {
                continue;
            }
            for (Id recordId : params.recordIds) {
                recordIds.add(recordId);
            }
        }

        if (recordIds.isEmpty()) {
            return;
        }
        
        Set<Id> contentDocumentIds = new Set<Id>();
        for (ContentDocumentLink link : [
            SELECT ContentDocumentId 
            FROM ContentDocumentLink 
            WHERE LinkedEntityId IN :recordIds
            WITH USER_MODE
        ]) {
            contentDocumentIds.add(link.ContentDocumentId);
        }

        ContentDocument[] docs = [
            SELECT Id
            FROM ContentDocument
            WHERE Id IN :contentDocumentIds
            WITH USER_MODE
        ];

        Database.delete(
            docs,
            true,
            AccessLevel.USER_MODE
        );
    }

    /**
     * @description     Class containing ContentDocumentDeletionParams parameters
    */
    public class ContentDocumentDeletionParams {
        @InvocableVariable(label = 'Record Ids' description='List of record IDs for whose related documents should be deleted' required = true)
        public Id[] recordIds;
    }

}